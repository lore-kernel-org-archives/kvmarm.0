Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260C4219E0;
	Mon, 22 Apr 2024 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713812757; cv=none; b=gQfLiKHGyLThQkCLQqcyZX8rwdCgTP+NYlTNafLcejP+mjKxH2WqwZo3dmTuAQulUzqDdd/XJrnJx1HTMPi2qxl3j1cYraTWjVU6htvg5ByZATK0xgnPUvsgu39RApRlC94qVK0OW6p6YdSRhLEu1b2CwVMePqGtY51Hm8bf5hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713812757; c=relaxed/simple;
	bh=olqbjtMO2lYQFKdnW9FhBNUoQLhAMSlCx3EdoK7BvxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BnPOPqmX1bBviROfsGh/Lrf9hNfkwooEZRorfMbOQ30E9qH5nhJkq8qTlVZILnPp9HWruHKwEcXphafGN9FKSdmy7de9cBqfj6P19Sxpd2K0bfMbn+R510e5oTnOuR1IJyZAgWYuMtw1ZW0JkxhKsXwIXrYpZ9jgY64swWJ/BfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDXCxd3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDXCxd3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A45C4AF0B;
	Mon, 22 Apr 2024 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713812757;
	bh=olqbjtMO2lYQFKdnW9FhBNUoQLhAMSlCx3EdoK7BvxQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uDXCxd3sZnTu0YXjlb27OMBo2Ww2PBVIwA+q8lUNvApEq/PWHI1QUkVnqx5Ydl+j3
	 1FjK1hRE44LaOBxQDRMXqtuoal3S/5FElxlVHf9ogy7p/ZycNb/RIsXvkUXdQwMsgH
	 bXarTEys6i+IEP2d/uWh3ep3Ka9wJjL3OT95V4VfT2+IHY2cGsvcMsAjiZ91945MkB
	 lZlu0/ba4iregoy927lvLlmniSLuG0+IYbHNX1JXlUwm7besyDoAHgOi1UI/tQo7iL
	 7p1RJcHEg/MuH0jb5LtTG964ydw10G2NUg1ov9MYBCCVDmuIJEgbNOkuCvwi4ymjQe
	 1Q0y51v50ZUaw==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5acdbfa7a45so1541133eaf.2;
        Mon, 22 Apr 2024 12:05:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXj4rSAfFhzo1lYfqg7Qs+JfRGzLYE8hPpSPlIVLySVK6b+sHpIHCOELozQd5dpyH6wdxNfU/jSZxOAWc3dJzfhASBMqzfB/pQm2vOSiCi7icpeDR+SJhyhWRNHdNyi6UPp
X-Gm-Message-State: AOJu0Yy+VFG4j4XO048JXuXTLRgpEPVmqWbJAXkVFg4P0jsLlje/FnQV
	Sh49GEc19bKUsdT7SL/Ex2Acom/52K8oobklerYQ86naJ/pZR02eTEeEFz2H6zpZ0B/CHTCMnpl
	9XpkLqvhgpUfZviAKXH+Lgx1UFF0=
X-Google-Smtp-Source: AGHT+IFQupzOqLQf3rypOOXDX+7ylfjySYUjvK8/UL2sIHZWqWZ3BDV9Q5+/PQPXaF+OFzkdf7PFFmoR2i+wYA/uyXY=
X-Received: by 2002:a4a:5581:0:b0:5aa:3e4f:f01e with SMTP id
 e123-20020a4a5581000000b005aa3e4ff01emr12662466oob.1.1713812756200; Mon, 22
 Apr 2024 12:05:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240418135412.14730-1-Jonathan.Cameron@huawei.com> <20240418135412.14730-8-Jonathan.Cameron@huawei.com>
In-Reply-To: <20240418135412.14730-8-Jonathan.Cameron@huawei.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 22 Apr 2024 21:05:44 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0jOoH7nP-5uaK9XVL_zf7Uh5SZnoupRyxK1qxwUdwq_dA@mail.gmail.com>
Message-ID: <CAJZ5v0jOoH7nP-5uaK9XVL_zf7Uh5SZnoupRyxK1qxwUdwq_dA@mail.gmail.com>
Subject: Re: [PATCH v7 07/16] ACPI: scan: switch to flags for acpi_scan_check_and_detach()
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, linux-pm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-acpi@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, 
	Russell King <linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>, 
	Salil Mehta <salil.mehta@huawei.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linuxarm@huawei.com, justin.he@arm.com, 
	jianyong.wu@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 3:57=E2=80=AFPM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> Precursor patch adds the ability to pass a uintptr_t of flags into
> acpi_scan_check_and detach() so that additional flags can be
> added to indicate whether to defer portions of the eject flow.
> The new flag follows in the next patch.
>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I have no specific heartburn related to this, so

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
> v7: No change
> v6: Based on internal feedback switch to less invasive change
>     to using flags rather than a struct.
> ---
>  drivers/acpi/scan.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index d1464324de95..1ec9677e6c2d 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -244,13 +244,16 @@ static int acpi_scan_try_to_offline(struct acpi_dev=
ice *device)
>         return 0;
>  }
>
> -static int acpi_scan_check_and_detach(struct acpi_device *adev, void *ch=
eck)
> +#define ACPI_SCAN_CHECK_FLAG_STATUS    BIT(0)
> +
> +static int acpi_scan_check_and_detach(struct acpi_device *adev, void *p)
>  {
>         struct acpi_scan_handler *handler =3D adev->handler;
> +       uintptr_t flags =3D (uintptr_t)p;
>
> -       acpi_dev_for_each_child_reverse(adev, acpi_scan_check_and_detach,=
 check);
> +       acpi_dev_for_each_child_reverse(adev, acpi_scan_check_and_detach,=
 p);
>
> -       if (check) {
> +       if (flags & ACPI_SCAN_CHECK_FLAG_STATUS) {
>                 acpi_bus_get_status(adev);
>                 /*
>                  * Skip devices that are still there and take the enabled
> @@ -288,7 +291,9 @@ static int acpi_scan_check_and_detach(struct acpi_dev=
ice *adev, void *check)
>
>  static void acpi_scan_check_subtree(struct acpi_device *adev)
>  {
> -       acpi_scan_check_and_detach(adev, (void *)true);
> +       uintptr_t flags =3D ACPI_SCAN_CHECK_FLAG_STATUS;
> +
> +       acpi_scan_check_and_detach(adev, (void *)flags);
>  }
>
>  static int acpi_scan_hot_remove(struct acpi_device *device)
> @@ -2601,7 +2606,9 @@ EXPORT_SYMBOL(acpi_bus_scan);
>   */
>  void acpi_bus_trim(struct acpi_device *adev)
>  {
> -       acpi_scan_check_and_detach(adev, NULL);
> +       uintptr_t flags =3D 0;
> +
> +       acpi_scan_check_and_detach(adev, (void *)flags);
>  }
>  EXPORT_SYMBOL_GPL(acpi_bus_trim);
>
> --
