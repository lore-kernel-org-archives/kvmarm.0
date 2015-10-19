From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/4] vfio: platform: reset: calxedaxgmac: add reset
 function registration
Date: Mon, 19 Oct 2015 15:04:47 +0200
Message-ID: <3829716.dW4OHEgDOa@wuerfel>
References: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
 <1445184015-24414-3-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDF31412DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 09:02:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jIk+UDwnqJcF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2015 09:02:33 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73772412A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 09:02:33 -0400 (EDT)
In-Reply-To: <1445184015-24414-3-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sunday 18 October 2015 18:00:13 Eric Auger wrote:
> diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> index 619dc7d..4f76b17 100644
> --- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> +++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> @@ -29,8 +29,7 @@
>  #define DRIVER_VERSION  "0.1"
>  #define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
>  #define DRIVER_DESC     "Reset support for Calxeda xgmac vfio platform device"
> -
> -#define CALXEDAXGMAC_COMPAT "calxeda,hb-xgmac"
> +#define COMPAT		"calxeda,hb-xgmac"

Why the rename?

>  /* XGMAC Register definitions */
>  #define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
> @@ -80,6 +79,43 @@ int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_calxedaxgmac_reset);
>  
> +static int __init vfio_platform_calxedaxgmac_init(void)
> +{
> +	int (*register_reset)(struct module *, char*,
> +				vfio_platform_reset_fn_t);
> +	int ret;
> +
> +	register_reset = symbol_get(vfio_platform_register_reset);
> +	if (!register_reset)
> +		return -EINVAL;

I don't understand what you do the symbol_get() here for.
Why not just call that function directly?

> +	ret = register_reset(THIS_MODULE, COMPAT,
> +	vfio_platform_calxedaxgmac_reset);

This is whitespace damaged, the second line needs to be indented
to the opening braces.

I would also suggest defining register_reset as a macro that
implicitly passes the THIS_MODULE argument, as other subsystems
do.

	Arnd
