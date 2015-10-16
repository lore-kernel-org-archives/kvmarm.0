From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Fri, 16 Oct 2015 15:26:34 +0200
Message-ID: <3768580.4oTvTNW7Bh@wuerfel>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
 <1444927997.4059.470.camel@redhat.com> <5620F665.5010903@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D4D4156D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 09:24:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DFMOErPgJ6-R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Oct 2015 09:24:23 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E1764130B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 09:24:22 -0400 (EDT)
In-Reply-To: <5620F665.5010903@linaro.org>
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
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, suravee.suthikulpanit@amd.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 16 October 2015 15:06:45 Eric Auger wrote:

>  I've since forgotten his answer, but the fact that
> > __symbol_get() is only defined for modules makes it moot, we either need
> > to make symbol_get() work or define __symbol_get() for non-module
> > builds.
> I currently don't see any solution for any of those. The only solution I
> can see is someone registers the reset function pointer to vfio.
> 
> I think we could keep the existing reset modules, do the request_module
> from VFIO, using their module name registered in the lookup table. But
> instead of having the reset function in the look-up table we would have
> the reset modules register their reset function pointer to VFIO. I think
> this could work around the symbol_get issue.
> 
> This still leaves the layer violation argument though.
> 
> Assuming this works, would that be an acceptable solution, although I
> acknowledge this does not perfectly fit into the driver model?

I think it's possible to avoid the layering violation that way too,
by loading the module based on the compatible string, with a module_alias.

static void vfio_platform_get_reset(struct vfio_platform_device *vdev,
                                    struct device *dev)
{
        const char *compat;
        int (*reset)(struct vfio_platform_device *);
        int ret, i;
	char modname[256];

        ret = device_property_read_string(dev, "compatible", &compat);
        if (ret)
                return;

	reset = vfio_platform_lookup_reset(compat);
	if (!reset) {
		snprintf(modname, "vfio-reset:%s", compat);
		request_module(modname);
		reset = vfio_platform_lookup_reset(compat);
	}

	vdev->reset = reset;
}

---

#define module_vfio_reset_handler(compat, reset)			\
MODULE_ALIAS("vfio_reset" compat);					\
static int reset ## _module_init(void)					\
{									\
	return vfio_reset_register(THIS_MODULE, compat, &reset);	\
}

I think that solution is good enough, as it avoids most of the
problems with the current implementation but is a simple enough change.

	Arnd
