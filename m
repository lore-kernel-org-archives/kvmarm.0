Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826E4C433E3
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 13:48:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F09720888
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 13:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="I0l69/eV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F09720888
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E604BA0F;
	Tue, 18 Aug 2020 09:48:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SHuQ86uMBex5; Tue, 18 Aug 2020 09:48:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EB404B7B3;
	Tue, 18 Aug 2020 09:48:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC0864C1AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 13:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id evMrcLpZRjSl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 13:12:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7008B4C1AB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 13:12:02 -0400 (EDT)
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C44AF2067C;
 Mon, 17 Aug 2020 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597684321;
 bh=BFKmMwm3OgowIDbWwU9+GxfmhcLKDlOgozUQDhUzMwE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:From;
 b=I0l69/eVcqo9XoM5DNTMT2IHtJeSrEZ38TqHPaQ/MVg8ogXat9uYkR7vEL1h7hC/z
 4cLCk8F86byzwpWkE5mzd9DLMcDhX/pCeCX3FeDhyRFWxlZX5zhabrxqFjID+r4yxO
 t824qZlf+pcCGkc+eCBMReSoEY+74OYfzcbpY05c=
Date: Mon, 17 Aug 2020 12:11:59 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH  v1 1/3] arm64: allow de-selection of ThunderX PCI
 controllers
Message-ID: <20200817171159.GA1426023@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200804124417.27102-2-alex.bennee@linaro.org>
X-Mailman-Approved-At: Tue, 18 Aug 2020 09:48:54 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 Robert Richter <rrichter@marvell.com>, linux-pci@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Aug 04, 2020 at 01:44:15PM +0100, Alex Benn=E9e wrote:
> For a pure VirtIO guest bringing in all the PCI quirk handling adds a
> significant amount of bloat to kernel we don't need. Solve this by
> adding a CONFIG symbol for the ThunderX PCI devices and allowing it to
> be turned off. Saving over 300k from the uncompressed vmlinux:

It *looks* like just turning off CONFIG_PCI_QUIRKS should be
sufficient because pci-thunder-ecam.c and pci-thunder-pem.c are
wrapped with:

  #if defined(CONFIG_PCI_HOST_THUNDER_PEM) || (defined(CONFIG_ACPI) && defi=
ned(CONFIG_PCI_QUIRKS))

so if you turn off CONFIG_PCI_HOST_THUNDER_ECAM,
CONFIG_PCI_HOST_THUNDER_PEM, and CONFIG_PCI_QUIRKS that should omit
pci-thunder-ecam.o and pci-thunder-pem.o.  But I must be missing
something.

>   -rwxr-xr-x 1 alex alex  85652472 Aug  3 16:48 vmlinux*
>   -rwxr-xr-x 1 alex alex  86033880 Aug  3 16:39 vmlinux.orig*
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Cc: Robert Richter <rrichter@marvell.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm64/Kconfig.platforms    | 2 ++
>  arch/arm64/configs/defconfig    | 1 +
>  drivers/pci/controller/Kconfig  | 7 +++++++
>  drivers/pci/controller/Makefile | 4 ++--
>  4 files changed, 12 insertions(+), 2 deletions(-)
> =

> diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
> index 8dd05b2a925c..a328eebdaa59 100644
> --- a/arch/arm64/Kconfig.platforms
> +++ b/arch/arm64/Kconfig.platforms
> @@ -253,12 +253,14 @@ config ARCH_SPRD
>  =

>  config ARCH_THUNDER
>  	bool "Cavium Inc. Thunder SoC Family"
> +        select PCI_THUNDER
>  	help
>  	  This enables support for Cavium's Thunder Family of SoCs.
>  =

>  config ARCH_THUNDER2
>  	bool "Cavium ThunderX2 Server Processors"
>  	select GPIOLIB
> +        select PCI_THUNDER

Indent these with tabs, not spaces, to be consistent with other
whitespace usage in this file.

>  	help
>  	  This enables support for Cavium's ThunderX2 CN99XX family of
>  	  server processors.
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index 2ca7ba69c318..d840cba99941 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -199,6 +199,7 @@ CONFIG_PCI_HOST_GENERIC=3Dy
>  CONFIG_PCI_XGENE=3Dy
>  CONFIG_PCIE_ALTERA=3Dy
>  CONFIG_PCIE_ALTERA_MSI=3Dy
> +CONFIG_PCI_THUNDER=3Dy
>  CONFIG_PCI_HOST_THUNDER_PEM=3Dy
>  CONFIG_PCI_HOST_THUNDER_ECAM=3Dy
>  CONFIG_PCIE_ROCKCHIP_HOST=3Dm
> diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kcon=
fig
> index adddf21fa381..28335ffa5d48 100644
> --- a/drivers/pci/controller/Kconfig
> +++ b/drivers/pci/controller/Kconfig
> @@ -286,6 +286,13 @@ config PCI_LOONGSON
>  	  Say Y here if you want to enable PCI controller support on
>  	  Loongson systems.
>  =

> +config PCI_THUNDER
> +       bool "Thunder X PCIE controllers"
> +       depends on ARM64
> +       select PCI_QUIRKS
> +       help
> +          Say Y here to enable ThunderX ECAM and PEM PCI controllers.

Indent with tabs, not spaces.

The existing Kconfig help text refers to simply "Thunder", not
"Thunder X", so both of these references should probably follow suit.

s/PCIE controllers/PCIe controllers/

>  source "drivers/pci/controller/dwc/Kconfig"
>  source "drivers/pci/controller/mobiveil/Kconfig"
>  source "drivers/pci/controller/cadence/Kconfig"
> diff --git a/drivers/pci/controller/Makefile b/drivers/pci/controller/Mak=
efile
> index efd9733ead26..8fad4781a5d3 100644
> --- a/drivers/pci/controller/Makefile
> +++ b/drivers/pci/controller/Makefile
> @@ -45,8 +45,8 @@ obj-y				+=3D mobiveil/
>  # ARM64 and use internal ifdefs to only build the pieces we need
>  # depending on whether ACPI, the DT driver, or both are enabled.
>  =

> +obj-$(CONFIG_PCI_THUNDER) +=3D pci-thunder-ecam.o
> +obj-$(CONFIG_PCI_THUNDER) +=3D pci-thunder-pem.o
>  ifdef CONFIG_PCI
> -obj-$(CONFIG_ARM64) +=3D pci-thunder-ecam.o
> -obj-$(CONFIG_ARM64) +=3D pci-thunder-pem.o
>  obj-$(CONFIG_ARM64) +=3D pci-xgene.o
>  endif
> -- =

> 2.20.1
> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
