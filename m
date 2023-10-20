Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC2B2115;
	Fri, 20 Oct 2023 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-57de3096e25so90191eaf.1;
        Fri, 20 Oct 2023 09:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697820731; x=1698425531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=psILNHinFhubd7kf1xu/dppnYDWKXA3Ybjqll4DLjw0=;
        b=bqu13Kjh8MC10HoYqc2V+zfrx6i5e0ZUk5lx/eFI+0K6x8A9E3pUkN5VSQdLINSVRh
         +cNyEPs/pIikY2i7dyDg0IU1dkPc+45a0axtQ6/0kKVUT/4QwIIEyF5K/mOs+KnwfytE
         6QL3/0EJxQ5XnAcpFFL6H9TRdeUyHcMD7+8Ia/HDbrWJ2ReqRLWN3D/dLvNursPH9Oiq
         x8JVEb8tR1M+iucKza+tsXpyzv7enJdYG6uTSYi2VV0Zmxo2/sUutJP3RanG3NMfIT7z
         O/311H7U+jz1ORMUZsHXxY6WfWdJYi/Q39KvcLFMmnQTAK2J/zudOQX++vNk8IoiMnQD
         gPKQ==
X-Gm-Message-State: AOJu0Yzm3j+unuDhe3TJ9w0+54PyhUF+ifwwcnz6nV2h15BmUWiof+uX
	Rju1oMihWavQPg1m3iR5zLFIYcUPa3jHCEUpAa4=
X-Google-Smtp-Source: AGHT+IGh0cmdaOOYZFwyTinjpHRLVyGaQdJ8C+chdN0KihO5maTrIgG7O0UmbbjbnDR2+SuI/Pn6JwhLUpC07VMZzYY=
X-Received: by 2002:a4a:e7d1:0:b0:583:ec88:e0 with SMTP id y17-20020a4ae7d1000000b00583ec8800e0mr2657273oov.0.1697820730971;
 Fri, 20 Oct 2023 09:52:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <E1qtq2W-00AJ8T-Mm@rmk-PC.armlinux.org.uk> <95A91316-0210-41D6-B8E2-4EE958066FFB@oracle.com>
In-Reply-To: <95A91316-0210-41D6-B8E2-4EE958066FFB@oracle.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 20 Oct 2023 18:52:00 +0200
Message-ID: <CAJZ5v0hfJkbE=TNpNWnVZsxzB4Hd-BCwQrJ+Lc3B95S9-KQezg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Use the acpi_device_is_present() helper in more places
To: Miguel Luis <miguel.luis@oracle.com>, Russell King <rmk+kernel@armlinux.org.uk>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, 
	James Morse <james.morse@arm.com>, Salil Mehta <salil.mehta@huawei.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "jianyong.wu@arm.com" <jianyong.wu@arm.com>, 
	"justin.he@arm.com" <justin.he@arm.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 20, 2023 at 4:52=E2=80=AFPM Miguel Luis <miguel.luis@oracle.com=
> wrote:
>
> Hi Russell,
>
> > On 20 Oct 2023, at 13:59, Russell King <rmk+kernel@armlinux.org.uk> wro=
te:
> >
> > From: James Morse <james.morse@arm.com>
> >
> > acpi_device_is_present() checks the present or functional bits
> > from the cached copy of _STA.
> >
> > A few places open-code this check. Use the helper instead to
> > improve readability.
> >
> > Signed-off-by: James Morse <james.morse@arm.com>
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> > Jonathan Cameron suggests "Pull this one out and send it upstream in
> > advance of the rest" so let's do that. See
> > https://lore.kernel.org/r/20230914130455.00004434@Huawei.com/
> >
> > So, let's get this upstream to reduce the number of outstanding patches
> > for aarch64 vcpu hotplug.
> >
> > drivers/acpi/scan.c | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 691d4b7686ee..ed01e19514ef 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -304,7 +304,7 @@ static int acpi_scan_device_check(struct acpi_devic=
e *adev)
> > int error;
> >
> > acpi_bus_get_status(adev);
> > - if (adev->status.present || adev->status.functional) {
> > + if (acpi_device_is_present(adev)) {
> > /*
> > * This function is only called for device objects for which
> > * matching scan handlers exist.  The only situation in which
> > @@ -338,7 +338,7 @@ static int acpi_scan_bus_check(struct acpi_device *=
adev, void *not_used)
> > int error;
> >
> > acpi_bus_get_status(adev);
> > - if (!(adev->status.present || adev->status.functional)) {
> > + if (!acpi_device_is_present(adev)) {
>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Applied as 6.7 material, thanks!
