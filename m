From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Thu, 15 Oct 2015 13:21:55 +0200
Message-ID: <7287273.XGFpHqQ9fN@wuerfel>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
 <22278785.Xzxnmu2YlU@wuerfel> <561F5EE2.7010405@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3A064130B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 07:20:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Li0FQEIDjaGH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 07:20:18 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1760341022
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 07:20:17 -0400 (EDT)
In-Reply-To: <561F5EE2.7010405@linaro.org>
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
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, suravee.suthikulpanit@amd.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thursday 15 October 2015 10:08:02 Eric Auger wrote:
> Hi Arnd,
> On 10/14/2015 05:38 PM, Arnd Bergmann wrote:
> > On Wednesday 14 October 2015 15:33:12 Eric Auger wrote:
> >> --- a/drivers/vfio/platform/vfio_platform_common.c
> >> +++ b/drivers/vfio/platform/vfio_platform_common.c
> >> @@ -31,6 +31,11 @@ static const struct vfio_platform_reset_combo reset_lookup_table[] = {
> >>                 .reset_function_name = "vfio_platform_calxedaxgmac_reset",
> >>                 .module_name = "vfio-platform-calxedaxgmac",
> >>         },
> >> +       {
> >> +               .compat = "amd,xgbe-seattle-v1a",
> >> +               .reset_function_name = "vfio_platform_amdxgbe_reset",
> >> +               .module_name = "vfio-platform-amdxgbe",
> >> +       },
> >>  };
> >>  
> >>  static void vfio_platform_get_reset(struct vfio_platform_device *vdev,
> >>
> > 
> > This is causing build errors for me when CONFIG_MODULES is disabled.
> Sorry about that and thanks for reporting the issue
> > 
> > Could this please be restructured so vfio_platform_get_reset does
> > not attempt to call __symbol_get() but instead has the drivers
> > register themselves properly to a subsystem?
> OK
> 
> Could you elaborate about "has the drivers register themselves properly
> to a subsystem".
> 
> My first proposal when coping with this problematic of being able to add
> reset plugins to the vfio-platform driver was to create new drivers per
> device requiring reset. but this was considered painful for end-users,
> who needed to be aware of the right driver to bind - and I think that
> makes sense - (https://lkml.org/lkml/2015/4/17/568) .

Having multiple drivers indeed sucks, but your current approach isn't
that much better, as you still have two modules that are used to driver
the same hardware.

I would expect that the same driver that is used for the normal
operation and that it calls a function to register itself to vfio
by passing a structure with the device and reset function pointer.

> A naive question I dare to ask, wouldn't it be acceptable to make
> vfio_platform depend on CONFIG_MODULES? Don't we disable modules for
> security purpose? In that context would we use VFIO?

I think a lot of embedded systems turn off modules to save a little
memory, speed up boot time and simplify their user space.

Aside from that, the current method is highly unusual and looks a bit
fragile to me, as you are relying on internals of the module loader
code. It's also a layering violation as the generic code needs to be
patched for each device specific module that is added, and we try
to avoid that.

A possible solution could be something inside the xgbe driver like


static void xgbe_init_module(void)
{
	int ret = 0;

	if (IS_ENABLED(CONFIG_AMD_XGBE_ETHERNET)
		ret = platform_driver_register(&xgbe_driver);
	if (ret)
		return ret;

	if (IS_ENABLED(CONFIG_VFIO_PLATFORM))
		ret = vfio_platform_register_reset(&xgbe_of_match, xgbe_platform_reset);

	return ret;	
}

This way you have exactly one driver module that gets loaded for the
device and you can use it either with the platform_driver or through
vfio.

A nicer way that would be a little more work would be to integrate
the reset infrastructure into 'struct platform_driver' framework,
by adding another callback to the it for doing the interaction with
vfio, something like

enum vfio_platform_op {
	VFIO_PLATFORM_BIND,
	VFIO_PLATFORM_UNBIND,
	VFIO_PLATFORM_RESET,
};

struct platform_driver {
        int (*probe)(struct platform_device *);
        int (*remove)(struct platform_device *);
	...
	int (*vfio_manage)(struct platform_device *, enum vfio_platform_op);
        struct device_driver driver;
};

This would integrate much more closely into the platform driver framework,
just like the regular vfio driver integrates into the PCI framework.
Unlike PCI however, you can't just use the generic driver framework to
unbind the driver, because you still need device specific code.

	Arnd
