Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D0B1F3BBD
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743000928; cv=none; b=gqFpph2U0gDLmyKJDIlWDhOaIMNLiqvIjToXLWr1aix7U93W9CG0lw7FBmEaD534xdBHfC2iDtRMUbbXPCifGhRQAdfcvLgzqbIpGyyfpDXVyp417fQbydbkstY84tsqC3oSahPVMgwzN3X2JGJk+hijEQHaj0dsP8P8f7Kolpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743000928; c=relaxed/simple;
	bh=2FjJkXZ1Sr7UVOgZLzCfOaayYT0ey4QBq9TK9OK+P/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iny8sHywRy1KDbeDQ8bEOeoLWeS1yRNjap40ktcb3yMCdjkyEfceIfsqdJeUTQgKG49caAwF1cPGvHqOINZLTHf0aqZyZKw7Au8JqWQ4MeTWJiYHGfE10lUYCv63ivspVyEhYd3nhB7vgqgW3XT8D5Mmd9MFksXJBH9qBvaA6Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDcfB9qL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDcfB9qL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A12C4CEFB
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 14:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743000928;
	bh=2FjJkXZ1Sr7UVOgZLzCfOaayYT0ey4QBq9TK9OK+P/E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EDcfB9qLmelk6xZBmGSi6mVmBLovFad1OlocQSjvhAzVhMR4BNYCA3B1ucq9r7CFS
	 cWRFZXzLCJPSfvojCRGMK+jR9d4nmSuyVqNj+RKWjOga4AOIwX9euhqO39IrABy41l
	 2KdRhz6J2dE7iA90FqghusvHqjBxxG7N+7URoK8Ztvs1/u4mS2Oznn+lfI6vPX+GG5
	 De+ihB8MKEnkpQWKZmoXR7gSaGKmeITCRHvHQwuOxCdmySMsM6qjYkCAZoeG7/Yb0h
	 za/Ajad6cxqyEm4G8qFFp6CPHdFMYNH/P0aPMpvwRZ0BaNIqZqgL8BOTFf60d2SM7/
	 wtstXXj3BMV3Q==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2b2b6019a74so3438860fac.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 07:55:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUb7/A8IecX73a0tfMlTND2P14VkAuvhiIuxet5kTFCs7qcv7x9N3r7Worq8guuMmLY2R1LCFw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3H+oixeMCAbO+EFOGqN5laaO2APRMovP9GGZq+MCB8qGd+RSh
	AW7x0RRCKTdHevIThTUb8s5YB+vJXAPrgYufmmHL05qpHg9Yus8Rr87Nex64CRdxvt71pIzF3ek
	B7fg6Qf1vLrk9u7RgLZhKxHlXC9A=
X-Google-Smtp-Source: AGHT+IEYYA/6LylePhPYpVsBFlVh+o1a/2X6ugf3+5Zk77UyBnBXpaSo0UzJzWGtji5Mqp0Q8hwWmxY8a4Ns27KKFng=
X-Received: by 2002:a05:6871:5223:b0:2bd:455e:c22e with SMTP id
 586e51a60fabf-2c7803002damr12663712fac.19.1743000926945; Wed, 26 Mar 2025
 07:55:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250315001931.631210-1-romank@linux.microsoft.com> <20250315001931.631210-11-romank@linux.microsoft.com>
In-Reply-To: <20250315001931.631210-11-romank@linux.microsoft.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 26 Mar 2025 15:55:15 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0g1bX_3zRUUf-=euuvhm1dPB6bjEXPH9O-kMGcZjRspcw@mail.gmail.com>
X-Gm-Features: AQ5f1Jr4yQ264W4Fr4uvYbe-kFtKKfam4-v0_OqzzA1JU-y-jScH9oT2tKvFv-0
Message-ID: <CAJZ5v0g1bX_3zRUUf-=euuvhm1dPB6bjEXPH9O-kMGcZjRspcw@mail.gmail.com>
Subject: Re: [PATCH hyperv-next v6 10/11] ACPI: irq: Introduce acpi_get_gsi_dispatcher()
To: Roman Kisel <romank@linux.microsoft.com>
Cc: arnd@arndb.de, bhelgaas@google.com, bp@alien8.de, catalin.marinas@arm.com, 
	conor+dt@kernel.org, dan.carpenter@linaro.org, dave.hansen@linux.intel.com, 
	decui@microsoft.com, haiyangz@microsoft.com, hpa@zytor.com, 
	joey.gouly@arm.com, krzk+dt@kernel.org, kw@linux.com, kys@microsoft.com, 
	lenb@kernel.org, lpieralisi@kernel.org, manivannan.sadhasivam@linaro.org, 
	mark.rutland@arm.com, maz@kernel.org, mingo@redhat.com, 
	oliver.upton@linux.dev, rafael@kernel.org, robh@kernel.org, 
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

On Sat, Mar 15, 2025 at 1:19=E2=80=AFAM Roman Kisel <romank@linux.microsoft=
.com> wrote:
>
> Using acpi_irq_create_hierarchy() in the cases where the code
> also handles OF leads to code duplication as the ACPI subsystem
> doesn't provide means to compute the IRQ domain parent whereas
> the OF does.
>
> Introduce acpi_get_gsi_dispatcher() so that the drivers relying
> on both ACPI and OF may use irq_domain_create_hierarchy() in the
> common code paths.
>
> No functional changes.
>
> Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
> Reviewed-by: Michael Kelley <mhklinux@outlook.com>

This basically looks OK to me except for a couple of coding style
related nits below.

> ---
>  drivers/acpi/irq.c   | 15 +++++++++++++--
>  include/linux/acpi.h |  5 ++++-
>  2 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/irq.c b/drivers/acpi/irq.c
> index 1687483ff319..8eb09e45e5c5 100644
> --- a/drivers/acpi/irq.c
> +++ b/drivers/acpi/irq.c
> @@ -12,7 +12,7 @@
>
>  enum acpi_irq_model_id acpi_irq_model;
>
> -static struct fwnode_handle *(*acpi_get_gsi_domain_id)(u32 gsi);
> +static acpi_gsi_domain_disp_fn acpi_get_gsi_domain_id;
>  static u32 (*acpi_gsi_to_irq_fallback)(u32 gsi);
>
>  /**
> @@ -307,12 +307,23 @@ EXPORT_SYMBOL_GPL(acpi_irq_get);
>   *     for a given GSI
>   */
>  void __init acpi_set_irq_model(enum acpi_irq_model_id model,
> -                              struct fwnode_handle *(*fn)(u32))

Please retain the indentation here and analogously below.

> +       acpi_gsi_domain_disp_fn fn)
>  {
>         acpi_irq_model =3D model;
>         acpi_get_gsi_domain_id =3D fn;
>  }
>
> +/**
> + * acpi_get_gsi_dispatcher - Returns dispatcher function that
> + *                           computes the domain fwnode for a
> + *                           given GSI.
> + */

I would format this kerneldoc comment a bit differently:

/*
 * acpi_get_gsi_dispatcher() - Get the GSI dispatcher function
 *
 * Return the dispatcher function that computes the domain fwnode for
a given GSI.
 */

> +acpi_gsi_domain_disp_fn acpi_get_gsi_dispatcher(void)
> +{
> +       return acpi_get_gsi_domain_id;
> +}
> +EXPORT_SYMBOL_GPL(acpi_get_gsi_dispatcher);
> +
>  /**
>   * acpi_set_gsi_to_irq_fallback - Register a GSI transfer
>   * callback to fallback to arch specified implementation.
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 4e495b29c640..abc51288e867 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -336,8 +336,11 @@ int acpi_register_gsi (struct device *dev, u32 gsi, =
int triggering, int polarity
>  int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
>  int acpi_isa_irq_to_gsi (unsigned isa_irq, u32 *gsi);
>
> +typedef struct fwnode_handle *(*acpi_gsi_domain_disp_fn)(u32);
> +
>  void acpi_set_irq_model(enum acpi_irq_model_id model,
> -                       struct fwnode_handle *(*)(u32));
> +       acpi_gsi_domain_disp_fn fn);
> +acpi_gsi_domain_disp_fn acpi_get_gsi_dispatcher(void);
>  void acpi_set_gsi_to_irq_fallback(u32 (*)(u32));
>
>  struct irq_domain *acpi_irq_create_hierarchy(unsigned int flags,
> --

With the above addressed, please feel free to add

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

to the patch and route it along with the rest of the series.

Thanks!
