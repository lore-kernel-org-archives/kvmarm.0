From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/6] vfio: platform: reset: calxedaxgmac: add reset function registration
Date: Thu, 22 Oct 2015 12:13:30 +0200
Message-ID: <4810974.apRDTjc3oB@wuerfel>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org> <1445506922-6005-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445506922-6005-4-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thursday 22 October 2015 11:41:59 Eric Auger wrote:
> This patch adds the reset function registration/unregistration.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>

Looks good, except one thing:
> @@ -70,6 +69,8 @@ int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
>  			return -ENOMEM;
>  	}
>  
> +	pr_info("VFIO reset of %s\n", vdev->name);
> +
>  	/* disable IRQ */
>  	writel(0, reg.ioaddr + XGMAC_DMA_INTR_ENA);
>  

This probably slipped in from debugging, please remove it.

	Arnd
