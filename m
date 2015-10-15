From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Thu, 15 Oct 2015 10:53:17 -0600
Message-ID: <1444927997.4059.470.camel@redhat.com>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
 <7287273.XGFpHqQ9fN@wuerfel> <20151015121228.GA965@cbox>
 <5270338.MbsQ1bGczu@wuerfel> <561FBC31.3020900@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 436A741294
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 12:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0rn8jF+LeZy3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 12:51:01 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A80E741289
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 12:51:01 -0400 (EDT)
In-Reply-To: <561FBC31.3020900@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, patches@linaro.org, linux-kernel@vger.kernel.org, suravee.suthikulpanit@amd.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-10-15 at 16:46 +0200, Eric Auger wrote:
> Hi Arnd,
> On 10/15/2015 03:59 PM, Arnd Bergmann wrote:
> > On Thursday 15 October 2015 14:12:28 Christoffer Dall wrote:
> >>>
> >>> enum vfio_platform_op {
> >>>       VFIO_PLATFORM_BIND,
> >>>       VFIO_PLATFORM_UNBIND,
> >>>       VFIO_PLATFORM_RESET,
> >>> };
> >>>
> >>> struct platform_driver {
> >>>         int (*probe)(struct platform_device *);
> >>>         int (*remove)(struct platform_device *);
> >>>       ...
> >>>       int (*vfio_manage)(struct platform_device *, enum vfio_platform_op);
> >>>         struct device_driver driver;
> >>> };
> >>>
> >>> This would integrate much more closely into the platform driver framework,
> >>> just like the regular vfio driver integrates into the PCI framework.
> >>> Unlike PCI however, you can't just use the generic driver framework to
> >>> unbind the driver, because you still need device specific code.
> >>>
> >> Thanks for these suggestions, really helpful.
> >>
> >> What I don't understand in the latter example is how VFIO knows which
> >> struct platform_driver to interact with?
> > 
> > This would assume that the driver remains bound to the device, so VFIO
> > gets a pointer to the device from somewhere (as it does today) and then
> > follows the dev->driver pointer to get to the platform_driver.

The complexity of managing a bi-modal driver seems like far more than a
little bit of code duplication in a device specific reset module and
extends into how userspace makes devices available through vfio, so I
think it's too late for that discussion.
  
> >> Also, just so I'm sure I understand correctly, VFIO_PLATFORM_UNBIND is
> >> then called by VFIO before the VFIO driver unbinds from the device
> >> (unbinding the platform driver from the device being a completely
> >> separate thing)?
> > 
> > This is where we'd need a little more changes for this approach. Instead
> > of unbinding the device from its driver, the idea would be that the
> > driver remains bound as far as the driver model is concerned, but
> > it would be in a quiescent state where no other subsystem interacts with
> > it (i.e. it gets unregistered from networking core or whichever it uses).
> 
> Currently we use the same mechanism as for PCI, ie. unbind the native
> driver and then bind VFIO platform driver in its place. Don't you think
> changing this may be a pain for user-space tools that are designed to
> work that way for PCI?
> 
> My personal preference would be to start with your first proposal since
> it looks (to me) less complex and "unknown" that the 2d approach.
> 
> Let's wait for Alex opinion too...

I thought the reason we took the approach we have now is so that we
don't have reset code loaded into the kernel unless we have a device
that needs it.  Therefore we don't really want to preemptively load all
the reset drivers and have them do a registration.  The unfortunate
side-effect of that is the platform code needs to go looking for the
driver.  We do that via the __symbol_get() trick, which only fails
without modules because the underscore variant isn't defined in that
case.  I remember asking Eric previously why we're using that rather
than symbol_get(), I've since forgotten his answer, but the fact that
__symbol_get() is only defined for modules makes it moot, we either need
to make symbol_get() work or define __symbol_get() for non-module
builds.

Otherwise, we should probably abandon the idea of these reset functions
being modules and build them into the vfio platform driver (which would
still be less loaded, dead code than a bi-modal host driver).  Thanks,

Alex
