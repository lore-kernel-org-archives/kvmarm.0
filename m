Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25653221729
	for <kvmarm@lists.linux.dev>; Mon, 10 Mar 2025 13:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741614157; cv=none; b=iZI073GAzFNQRsLaed7wtDj1Qtrx7RgK/d/p+QNwrEbhlCjQXrlrzQljxTMF7Wed/GPlKLiyU4y/V/5/sNR82vdVOUZRcTWhjURm5YS4jC1PkPIaaUfwEqnlnLd+E5QS1/e4/5ziurScjGkatbqRq9T3gjnVZNl3V1N2nnig5k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741614157; c=relaxed/simple;
	bh=9JX3XY9vPoVhLHV2mTUB+zf5fX4dLzA4Gt+vcTFbIqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=csFH83GvxwqUMaWCg+qIwgcvS9r2Hk+K/QIITdEn5WgYT4AFwbyCDsmeXtX4hSgtcbs3DkS8KNFELwERm2EwuzHrMFsajWqBUr3RzNjqaVWpvdp2jdrRVV1Jfrdz2j5VTx5YWVLOEDk7nwCc7YBzFzkYn8dsam1Z5wc86tlPlg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDL+VEnX; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDL+VEnX"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2a81e41e3so148720566b.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Mar 2025 06:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741614154; x=1742218954; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvsHojGzktqIc1mRDfrH3Tw28TialK1JD2DdtffnVRo=;
        b=RDL+VEnX4Ge6dSk3LIfnBBTAiVoaL02dXQWgUXLK2MBFq7X73b37Pa6ZJ3DS4YMNR+
         lOAPa2d8rNaOC32tzryOTT16xc7C9l9sCi1JDVxz91vqL5PnMh0uc8gnuU2EnJrmJGD3
         dMaeDalrDrkhDqfwnJq+kVjZscQgRpNkn3FeQUczUGvXwTqzFZzYUksfar5cszchUYKP
         +zeXj3KtMZUSC43vy/mQCGpY4PhdDTxHtydGBhXpMV/rS6YuLBJQPHYkhjzOeTFC5dvM
         gOYuiWSjTHtIQhOAaSK5WV4E+rmZk4Sj3z35oRTDjecGnBW64SAJ/TOzFe0NE4nix3Ud
         8cOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741614154; x=1742218954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvsHojGzktqIc1mRDfrH3Tw28TialK1JD2DdtffnVRo=;
        b=hgoLPav9mP48qDv727CxteFHdpIiGaKjnqjiJS/srd857NS4i7uA6egCaEjmERVvew
         /WS2hTspR24fJtXK6ic+Bk+NANzo6mvu47dhXkhzHrU8CKMl/TDNpOllpEROjAh54xiA
         uLiJGt+bnTpd7S/CL/Q3iSkmPBooX+LW0socMU3QPOyyjTVJGKWSMQS51AiJhbpp24aS
         B7uSw6pDczF+Vitu5TNQxPruhdiodaaywoWVND7AeZ2UWW0Hrj/iY+hGI3tllesJEEOs
         ZRNh5GtSWxXDAeMCStXC02qxTV37Czf+DNSR8jsA6FpJK2qwwySw7XeH3+Utr44pietM
         /HLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVS8x5dllcow9gHHSo2LeezgSATYTyofpFo6FT/i3TzBBWFNK90+Qm/ZDbKiZde6DYaSslteEc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEXLq6LYIpQ9gMp52s+mnYZu3G4MYDPyR7W50imtBa6k+YhwIB
	o7Vu9Iwry7Ns+FsyDQxkXTGRUKWs07yec3wa/bfwVeFag/TxOLgHKW95YTc2VcyiAWSD7gpSAei
	2Adgk9S0aSOjZl+Xz6LgmCpm6OEc=
X-Gm-Gg: ASbGncvZWkLWiqe9MkH09gnyVTF5JTmgJtb6MzRywjEcLmuHw3AACUEQwT30NUUgBOQ
	/0Oe/OeXW+WajRMqxbI+DmKcpRQdylSAhCCeJire5ZSUIdXbS3SIKO16ksbtOLBM8WI7kZZ5rXH
	piX0pn3DxjPLk1AyBZkzE5aVqu6iPw1uCOxwGIWiqdr1CW
X-Google-Smtp-Source: AGHT+IFUfaQlQuaPqqkcPWFR+Uc30OuqKeGBgv4UhgRVglMXjxzsUDhKEonas+ed+S1TKw+FHpP1oVa0jMVOpi7ix8c=
X-Received: by 2002:a17:907:9691:b0:aa6:b63a:4521 with SMTP id
 a640c23a62f3a-ac252a886dbmr1424178866b.15.1741614154071; Mon, 10 Mar 2025
 06:42:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307220304.247725-1-romank@linux.microsoft.com> <20250307220304.247725-10-romank@linux.microsoft.com>
In-Reply-To: <20250307220304.247725-10-romank@linux.microsoft.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Mon, 10 Mar 2025 21:41:57 +0800
X-Gm-Features: AQ5f1JrFNYOkTeGrjIoQMzNLPYhLnbwrDYGfCpL3y-Ny919xFrzmZmgmS7VWREs
Message-ID: <CAMvTesCFZ6sxQp7qqSDjD9idRjVHxh96Sp4betomgFH-OFLZ3Q@mail.gmail.com>
Subject: Re: [PATCH hyperv-next v5 09/11] Drivers: hv: vmbus: Introduce hv_get_vmbus_root_device()
To: Roman Kisel <romank@linux.microsoft.com>
Cc: arnd@arndb.de, bhelgaas@google.com, bp@alien8.de, catalin.marinas@arm.com, 
	conor+dt@kernel.org, dave.hansen@linux.intel.com, decui@microsoft.com, 
	haiyangz@microsoft.com, hpa@zytor.com, joey.gouly@arm.com, krzk+dt@kernel.org, 
	kw@linux.com, kys@microsoft.com, lenb@kernel.org, lpieralisi@kernel.org, 
	manivannan.sadhasivam@linaro.org, mark.rutland@arm.com, maz@kernel.org, 
	mingo@redhat.com, oliver.upton@linux.dev, rafael@kernel.org, robh@kernel.org, 
	ssengar@linux.microsoft.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tglx@linutronix.de, wei.liu@kernel.org, will@kernel.org, yuzenghui@huawei.com, 
	devicetree@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	apais@microsoft.com, benhill@microsoft.com, bperkins@microsoft.com, 
	sunilmut@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 8, 2025 at 6:05=E2=80=AFAM Roman Kisel <romank@linux.microsoft.=
com> wrote:
>
> The ARM64 PCI code for hyperv needs to know the VMBus root
> device, and it is private.
>
> Provide a function that returns it. Rename it from "hv_dev"
> as "hv_dev" as a symbol is very overloaded. No functional
> changes.
>
> Signed-off-by: Roman Kisel <romank@linux.microsoft.com>

Why change all device's parent to vmbus_root_device?

The ARM64 platform uses the device tree to enumerate vmbus
devices..  Can we find the root device via device tree? vmbus
code on the x86 use ACPI and it seems to work via ACPI.


> ---
>  drivers/hv/vmbus_drv.c | 23 +++++++++++++++--------
>  include/linux/hyperv.h |  2 ++
>  2 files changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index c8474b48dcd2..7bfafe702963 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -45,7 +45,8 @@ struct vmbus_dynid {
>         struct hv_vmbus_device_id id;
>  };
>
> -static struct device  *hv_dev;
> +/* VMBus Root Device */
> +static struct device  *vmbus_root_device;
>
>  static int hyperv_cpuhp_online;
>
> @@ -80,9 +81,15 @@ static struct resource *fb_mmio;
>  static struct resource *hyperv_mmio;
>  static DEFINE_MUTEX(hyperv_mmio_lock);
>
> +struct device *hv_get_vmbus_root_device(void)
> +{
> +       return vmbus_root_device;
> +}
> +EXPORT_SYMBOL_GPL(hv_get_vmbus_root_device);
> +
>  static int vmbus_exists(void)
>  {
> -       if (hv_dev =3D=3D NULL)
> +       if (vmbus_root_device =3D=3D NULL)
>                 return -ENODEV;
>
>         return 0;
> @@ -861,7 +868,7 @@ static int vmbus_dma_configure(struct device *child_d=
evice)
>          * On x86/x64 coherence is assumed and these calls have no effect=
.
>          */
>         hv_setup_dma_ops(child_device,
> -               device_get_dma_attr(hv_dev) =3D=3D DEV_DMA_COHERENT);
> +               device_get_dma_attr(vmbus_root_device) =3D=3D DEV_DMA_COH=
ERENT);
>         return 0;
>  }
>
> @@ -1930,7 +1937,7 @@ int vmbus_device_register(struct hv_device *child_d=
evice_obj)
>                      &child_device_obj->channel->offermsg.offer.if_instan=
ce);
>
>         child_device_obj->device.bus =3D &hv_bus;
> -       child_device_obj->device.parent =3D hv_dev;
> +       child_device_obj->device.parent =3D vmbus_root_device;
>         child_device_obj->device.release =3D vmbus_device_release;
>
>         child_device_obj->device.dma_parms =3D &child_device_obj->dma_par=
ms;
> @@ -2292,7 +2299,7 @@ static int vmbus_acpi_add(struct platform_device *p=
dev)
>         struct acpi_device *ancestor;
>         struct acpi_device *device =3D ACPI_COMPANION(&pdev->dev);
>
> -       hv_dev =3D &device->dev;
> +       vmbus_root_device =3D &device->dev;
>
>         /*
>          * Older versions of Hyper-V for ARM64 fail to include the _CCA
> @@ -2383,7 +2390,7 @@ static int vmbus_device_add(struct platform_device =
*pdev)
>         struct device_node *np =3D pdev->dev.of_node;
>         int ret;
>
> -       hv_dev =3D &pdev->dev;
> +       vmbus_root_device =3D &pdev->dev;
>
>         ret =3D of_range_parser_init(&parser, np);
>         if (ret)
> @@ -2702,7 +2709,7 @@ static int __init hv_acpi_init(void)
>         if (ret)
>                 return ret;
>
> -       if (!hv_dev) {
> +       if (!vmbus_root_device) {
>                 ret =3D -ENODEV;
>                 goto cleanup;
>         }
> @@ -2733,7 +2740,7 @@ static int __init hv_acpi_init(void)
>
>  cleanup:
>         platform_driver_unregister(&vmbus_platform_driver);
> -       hv_dev =3D NULL;
> +       vmbus_root_device =3D NULL;
>         return ret;
>  }
>
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 7f4f8d8bdf43..1f0851fde041 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1333,6 +1333,8 @@ static inline void *hv_get_drvdata(struct hv_device=
 *dev)
>         return dev_get_drvdata(&dev->device);
>  }
>
> +struct device *hv_get_vmbus_root_device(void);
> +
>  struct hv_ring_buffer_debug_info {
>         u32 current_interrupt_mask;
>         u32 current_read_index;
> --
> 2.43.0
>
>


--=20
Thanks
Tianyu Lan
