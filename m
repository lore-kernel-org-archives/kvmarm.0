From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Wed, 14 Oct 2015 17:38:35 +0200
Message-ID: <22278785.Xzxnmu2YlU@wuerfel>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, thomas.lendacky@amd.com, patches@linaro.org, christoffer.dall@linaro.org, suravee.suthikulpanit@amd.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wednesday 14 October 2015 15:33:12 Eric Auger wrote:
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -31,6 +31,11 @@ static const struct vfio_platform_reset_combo reset_lookup_table[] = {
>                 .reset_function_name = "vfio_platform_calxedaxgmac_reset",
>                 .module_name = "vfio-platform-calxedaxgmac",
>         },
> +       {
> +               .compat = "amd,xgbe-seattle-v1a",
> +               .reset_function_name = "vfio_platform_amdxgbe_reset",
> +               .module_name = "vfio-platform-amdxgbe",
> +       },
>  };
>  
>  static void vfio_platform_get_reset(struct vfio_platform_device *vdev,
> 

This is causing build errors for me when CONFIG_MODULES is disabled.

Could this please be restructured so vfio_platform_get_reset does
not attempt to call __symbol_get() but instead has the drivers
register themselves properly to a subsystem?

I don't see any way this could be fixed otherwise. The problem
of course showed up with calxedaxgmac already, but I'd prefer not
to see anything added there until the common code has been improved.

	Arnd
