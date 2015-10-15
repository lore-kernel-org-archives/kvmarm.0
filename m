From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Thu, 15 Oct 2015 14:26:26 -0600
Message-ID: <1444940786.4059.497.camel@redhat.com>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
 <7287273.XGFpHqQ9fN@wuerfel> <20151015121228.GA965@cbox>
 <5270338.MbsQ1bGczu@wuerfel> <561FBC31.3020900@linaro.org>
 <1444927997.4059.470.camel@redhat.com> <20151015194219.GG21930@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48786412D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 16:24:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jQlMApH7iMvj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 16:24:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 270B741278
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 16:24:08 -0400 (EDT)
In-Reply-To: <20151015194219.GG21930@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, patches@linaro.org, linux-kernel@vger.kernel.org, suravee.suthikulpanit@amd.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-10-15 at 21:42 +0200, Christoffer Dall wrote:
> On Thu, Oct 15, 2015 at 10:53:17AM -0600, Alex Williamson wrote:
> > On Thu, 2015-10-15 at 16:46 +0200, Eric Auger wrote:
> > > Hi Arnd,
> > > On 10/15/2015 03:59 PM, Arnd Bergmann wrote:
> > > > On Thursday 15 October 2015 14:12:28 Christoffer Dall wrote:
> > > >>>
> > > >>> enum vfio_platform_op {
> > > >>>       VFIO_PLATFORM_BIND,
> > > >>>       VFIO_PLATFORM_UNBIND,
> > > >>>       VFIO_PLATFORM_RESET,
> > > >>> };
> > > >>>
> > > >>> struct platform_driver {
> > > >>>         int (*probe)(struct platform_device *);
> > > >>>         int (*remove)(struct platform_device *);
> > > >>>       ...
> > > >>>       int (*vfio_manage)(struct platform_device *, enum vfio_platform_op);
> > > >>>         struct device_driver driver;
> > > >>> };
> > > >>>
> > > >>> This would integrate much more closely into the platform driver framework,
> > > >>> just like the regular vfio driver integrates into the PCI framework.
> > > >>> Unlike PCI however, you can't just use the generic driver framework to
> > > >>> unbind the driver, because you still need device specific code.
> > > >>>
> > > >> Thanks for these suggestions, really helpful.
> > > >>
> > > >> What I don't understand in the latter example is how VFIO knows which
> > > >> struct platform_driver to interact with?
> > > > 
> > > > This would assume that the driver remains bound to the device, so VFIO
> > > > gets a pointer to the device from somewhere (as it does today) and then
> > > > follows the dev->driver pointer to get to the platform_driver.
> > 
> > The complexity of managing a bi-modal driver seems like far more than a
> > little bit of code duplication in a device specific reset module and
> > extends into how userspace makes devices available through vfio, so I
> > think it's too late for that discussion.
> >   
> 
> I have had extremely limited exposure to the implementation details of
> the drivers for devices relevant for VFIO platform, so apologies for
> asking stupid questions.
> 
> I'm sure that your point is valid, I just fully understand how the
> complexities of a bi-modal driver arise?
> 
> Is it simply that the reset function in a particular device driver may
> not be self-contained so therefore the whole driver would need to be
> refactored to be able to do a reset for the purpose of VFIO?

Yes, I would expect that reset function in a driver is not typically
self contained, probably referencing driver specific data structures for
register offsets, relying on various mappings that are expected to be
created from the driver probe() function, etc.  It also creates a
strange dependency on the host driver, how is the user to know they need
the native host driver loaded for full functionality in a device
assignment scenario?  Are we going to need to do a module_request() of
the host driver in vfio platform anyway?  What if there are multiple
devices and the host driver claims the others when loaded?  In the case
of PCI and SR-IOV virtual functions, I often blacklist the host VF
driver because I shouldn't need it when I only intend to use the device
in guests.  Not to mention that we'd have to drop a little bit of vfio
knowledge into each host driver that we intend to enlighten like this,
and how do we resolve whether the host driver, potentially compiled from
a separate source tree has this support.

I really don't see the layering violation in having a set of reset
functions and some lookup mechanism to pick the correct one.  The vfio
platform driver is a meta driver and sometimes we need to enlighten it a
little bit more about the device it's operating on.  For PCI we have all
sorts of special functionality for reset, but we have a standard to work
with there, so we may need to choose between a bus reset, PM reset, AF
FLR, PCIe FLR, or device specific reset, but it's all buried in the PCI
core code; where device specific resets are the exception on PCI, they
are the norm on platform.

> > > >> Also, just so I'm sure I understand correctly, VFIO_PLATFORM_UNBIND is
> > > >> then called by VFIO before the VFIO driver unbinds from the device
> > > >> (unbinding the platform driver from the device being a completely
> > > >> separate thing)?
> > > > 
> > > > This is where we'd need a little more changes for this approach. Instead
> > > > of unbinding the device from its driver, the idea would be that the
> > > > driver remains bound as far as the driver model is concerned, but
> > > > it would be in a quiescent state where no other subsystem interacts with
> > > > it (i.e. it gets unregistered from networking core or whichever it uses).
> > > 
> > > Currently we use the same mechanism as for PCI, ie. unbind the native
> > > driver and then bind VFIO platform driver in its place. Don't you think
> > > changing this may be a pain for user-space tools that are designed to
> > > work that way for PCI?
> > > 
> > > My personal preference would be to start with your first proposal since
> > > it looks (to me) less complex and "unknown" that the 2d approach.
> > > 
> > > Let's wait for Alex opinion too...
> > 
> > I thought the reason we took the approach we have now is so that we
> > don't have reset code loaded into the kernel unless we have a device
> > that needs it.  Therefore we don't really want to preemptively load all
> > the reset drivers and have them do a registration.  The unfortunate
> > side-effect of that is the platform code needs to go looking for the
> > driver. 
> 
> Does the current approach have a separate driver for doing VFIO reset or
> does it reuse the existing device driver?

They're separate modules, not drivers.  They simply export a reset
function, no module init or exit function.  A table lookup via the
device compatibility string identifies the module to load and name of
reset function.  At one point I suggested that we simply use standard
naming based on the compatibility string to name the module and reset
function to avoid the table, but that was thought to be too hackish or
perhaps dangerous to have vfio requesting modules like that.

> Why does the driver registering itself instead of using symbol_get
> imply that we must load reset drivers that we don't need?

Who would register the reset driver if not the reset "driver" itself?
Either we have a table/list of registered reset drivers and we can pick
the one we want and the code is already loaded, or we have a table/list
of who provides which reset driver and we load and get a pointer when we
determine that we need it.  Are there other options?  Thanks,

Alex
