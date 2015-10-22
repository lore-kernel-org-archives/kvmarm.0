From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 6/6] vfio: platform: move get/put reset at open/release
Date: Thu, 22 Oct 2015 14:05 +0200
Message-ID: <4122253.nUc0E0jzBg@wuerfel>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org> <4304536.D7eNHjlsvD@wuerfel> <5628CB20.7040301@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5628CB20.7040301@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thursday 22 October 2015 13:40:16 Eric Auger wrote:
> On 10/22/2015 12:29 PM, Arnd Bergmann wrote:
> > On Thursday 22 October 2015 11:42:02 Eric Auger wrote:
> >> Currently reset lookup is done on probe. This introduces a
> >> race with new registration mechanism in the case where the
> >> vfio-platform driver is bound to the device before its module
> >> is loaded: on the load, the probe happens which triggers the
> >> reset module load which itself attempts to get the symbol for
> >> the registration function (vfio_platform_register_reset). The
> >> symbol is not yet available hence the lookup fails. In case we
> >> do the lookup in the first open we are sure the vfio-platform
> >> module is loaded and vfio_platform_register_reset is available.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> > 
> > I don't understand the explanation. I would expect the request_module()
> > call to block until the module is actually loaded. Is this not
> > what happens?
> 
> Again many thanks for this new review.
> 
> My understanding is the following
> 1) vfio-platform is attached to the device through the override mechanism
> 2) vfio-platform get loaded through modprobe:
> 2-1) the platform driver init function eventually calls the
> vfio-platform probe function.
> 2-2) request_module of vfio-platform-calxedaxgmac gets called.
> 3) The init of  vfio-platform-calxedaxgmac looks for
> vfio_platform_register_reset. Unfortunately at that stage the init of
> vfio-platform is not completed so the symbol is not available
> 3-1) in case symbol_get is used in vfio_platform_calxedaxgmac init, as
> of today, this latter simply returns -EINVAL. Reset registration failed
> but no stall.
> 3-2) in case symbol_get is *not* used, I think the module loader
> attempts to load vfio-platform, which is already under load and this
> causes a stall.
> 
> Let me know if you think this understanding is not correct.

I was expecting the vfio_platform_register_reset() function to be
available by the time of step 2-2.

What I think is going on here is that we are still inside of the
module_init() function of the vfio-platform driver at the time that
we call the request_module(), and the symbols are not made visible
to other modules until the module_init function returns with success.
This is a side-effect of the probe function for the platform driver
getting called from deep inside of the platform_driver_register()
function for all devices that are already present.

I think it already works for the AMBA case, which uses separate modules,
but we need to restructure the platform_device case slightly to do
the same:

diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 9ce8afe28450..a00a44814255 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -1,10 +1,12 @@
 
-vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o
+vfio-platform-base-y := vfio_platform_common.o vfio_platform_irq.o
 
-obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
+obj-$(CONFIG_VFIO_PLATFORM) += vfio_platform.o
+obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform-base.o
 obj-$(CONFIG_VFIO_PLATFORM) += reset/
 
 vfio-amba-y := vfio_amba.o
 
 obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
+obj-$(CONFIG_VFIO_AMBA) += vfio-platform-base.o
 obj-$(CONFIG_VFIO_AMBA) += reset/


	Arnd
