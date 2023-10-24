Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2556B224FE;
	Tue, 24 Oct 2023 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3b41132c33aso481372b6e.1;
        Tue, 24 Oct 2023 05:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698148937; x=1698753737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q2pHDhFBV3p+9e1mZi2uGJDDYekveY6SeTMBwmaYx/4=;
        b=NtCCdVzzRWe8UPPmdKzzv+6E4lym6dbiOBnyCXUV+2yLq4Boxj1xvBAbOl8nNP2cQv
         yjM+k2HOQ/Iyf6goik+VsNBdAYX1ib4xN0wGVx40cGzuLor2cZLwmUY3bgJC+McB2fgq
         6oYPAdWt104gZdHTXsBZaf+ZPJgBvwMUK7RGEhQ27QpEMtOVxCXd7HgbSrUMIHSwqma+
         K2rG3Q4Hx275ABEMxFuqPdZawYKdlF6Oe+RjcckWXBJxZWeY3lBNhEM/5fjYHCOg9xex
         9XkaAROXYVFy3nnauD8JzB5sLMSt9+lkp7MOJAOEhyK9ZBCP+Ck0T0rAQhCxuiV/c+hf
         sp9Q==
X-Gm-Message-State: AOJu0Yxm/dOh2O1h3xqnYppJYka2ZE2e+NawrsCbPUGfjM8ohZ1F8THt
	3SwHmjw2uOwbprbaXoff82v3rhShgrNmUfaZTug=
X-Google-Smtp-Source: AGHT+IGIETBiiFD1D2fRVRb8FftiTW+n7MOvkpWXai2dprUcsPzAq6Nyi8wxC+U5gNTBl00FSuUydUoDBwyRfxz40/M=
X-Received: by 2002:a05:6808:1513:b0:3ae:5e6a:5693 with SMTP id
 u19-20020a056808151300b003ae5e6a5693mr13497868oiw.0.1698148937006; Tue, 24
 Oct 2023 05:02:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <E1qtuWW-00AQ7P-0W@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1qtuWW-00AQ7P-0W@rmk-PC.armlinux.org.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 24 Oct 2023 14:02:05 +0200
Message-ID: <CAJZ5v0hEXaYSgre=F=hZ0XTRqupaBR5Grnck=tQtfj4inDkOKA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Rename acpi_scan_device_not_present() to be about enumeration
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, 
	James Morse <james.morse@arm.com>, Salil Mehta <salil.mehta@huawei.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com, justin.he@arm.com, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 20, 2023 at 8:47=E2=80=AFPM Russell King <rmk+kernel@armlinux.o=
rg.uk> wrote:
>
> From: James Morse <james.morse@arm.com>
>
> acpi_scan_device_not_present() is called when a device in the
> hierarchy is not available for enumeration. Historically enumeration
> was only based on whether the device was present.
>
> To add support for only enumerating devices that are both present
> and enabled, this helper should be renamed. It was only ever about
> enumeration, rename it acpi_scan_device_not_enumerated().
>
> No change in behaviour is intended.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> This is another patch from James' aarch64 hotplug vcpu series.
>
> I asked:
> > Is this another patch which ought to be submitted without waiting
> > for the rest of the series?
> to which Jonathan Cameron replied:
> > Looks like a valid standalone change to me.
>
> So let's get this queued up.
>
>  drivers/acpi/scan.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index ed01e19514ef..17ab875a7d4e 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -289,10 +289,10 @@ static int acpi_scan_hot_remove(struct acpi_device =
*device)
>         return 0;
>  }
>
> -static int acpi_scan_device_not_present(struct acpi_device *adev)
> +static int acpi_scan_device_not_enumerated(struct acpi_device *adev)
>  {
>         if (!acpi_device_enumerated(adev)) {
> -               dev_warn(&adev->dev, "Still not present\n");
> +               dev_warn(&adev->dev, "Still not enumerated\n");
>                 return -EALREADY;
>         }
>         acpi_bus_trim(adev);
> @@ -327,7 +327,7 @@ static int acpi_scan_device_check(struct acpi_device =
*adev)
>                         error =3D -ENODEV;
>                 }
>         } else {
> -               error =3D acpi_scan_device_not_present(adev);
> +               error =3D acpi_scan_device_not_enumerated(adev);
>         }
>         return error;
>  }
> @@ -339,7 +339,7 @@ static int acpi_scan_bus_check(struct acpi_device *ad=
ev, void *not_used)
>
>         acpi_bus_get_status(adev);
>         if (!acpi_device_is_present(adev)) {
> -               acpi_scan_device_not_present(adev);
> +               acpi_scan_device_not_enumerated(adev);
>                 return 0;
>         }
>         if (handler && handler->hotplug.scan_dependent)
> --

Applied as 6.7 material, thanks!
