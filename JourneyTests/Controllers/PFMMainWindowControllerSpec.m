#import "TestHelper.h"
#import "PFMMainWindowController.h"
#import "PFMMomentListViewController.h"
#import "PFMToolbarViewController.h"

SpecBegin(PFMMainWindowController)

__block PFMMainWindowController *controller;

before(^{
  [ASIHTTPRequest resetRequests];
  controller = [PFMMainWindowController new];
  [[controller window] makeKeyAndOrderFront:nil];
});

after(^{
  [controller close];
});

it(@"loads MainWindow nib", ^{
  expect([controller windowNibName]).toEqual(@"MainWindow");
});

it(@"has its wrapper view outlets correctly connected", ^{
  expect(controller.toolbarViewWrapper).toBeKindOf([NSView class]);
  expect(controller.momentListViewWrapper).toBeKindOf([NSView class]);
});

it(@"initializes PFMMomentListViewController and adds its view as a subview of momentListViewWrapper", ^{
  expect(controller.momentListViewController).toBeKindOf([PFMMomentListViewController class]);
  NSView *momentListView = [controller.momentListViewController view];
  expect([[controller.momentListViewWrapper subviews] objectAtIndex:0]).toEqual(momentListView);
  expect([momentListView frame]).toEqual([controller.momentListViewWrapper bounds]);
});

it(@"initializes PFMToolbarViewController and adds its view as a subview of toolbarViewWrapper", ^{
  expect(controller.toolbarViewController).toBeKindOf([PFMToolbarViewController class]);
  NSView *toolbarView = [controller.toolbarViewController view];
  expect([[controller.toolbarViewWrapper subviews] objectAtIndex:0]).toEqual(toolbarView);
  expect([toolbarView frame]).toEqual([controller.toolbarViewWrapper bounds]);
});

SpecEnd
