Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EE715E7E3;
	Wed, 10 Apr 2024 13:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712755712; cv=none; b=MhIoOmIPSNy3pIXUlG5TiJz5//4LA/72lWIRfZtFypszs3Lu8HQ7Z28DwIOt5M9MoT9Ne6VoyRaCK6Zk4UAmNy/fb3bxhv6HmMmP0Glm9Ft8SfJcRZdMqKRJP2h/OIhfMkX7Onw9xB/Bq6Q039LGfrb8myexUT5Caeq2F7YK0Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712755712; c=relaxed/simple;
	bh=vG/etX9uFWDRMQyM96dxgcCHcoWyYgwQIb4SGb4iHUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pFE5KGExm9ldLtWNzpVfXxAsel8oTW139z98N881Ms2pY7edPAw3aqu6IDNfTA3ShQNykpevnpgI/oY0dlEr4OgMMyhz5MyTHxOVS9GWgiNUxfsoeNR6oT5CMfEHT1b4ON4A+MuKOS27q8SKUIOElHWEmctQrxlmzU5SGGt4kLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iubVYXfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iubVYXfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C6DC433B2;
	Wed, 10 Apr 2024 13:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712755711;
	bh=vG/etX9uFWDRMQyM96dxgcCHcoWyYgwQIb4SGb4iHUc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iubVYXfK6JPDhhN9TmRS0x6QzxNaToPZCeVJnHP93bzsfQkb7YaWzUGU5fvosdVlK
	 1iYtCJ+3WmeWgXErCaKKoO8GwwKCAVsPQSeaDEZwvjhLCuOC89oo5gQpo6M/afAEAy
	 4yeMyJV1phaU5H/syWUh2fS6hJ6AmMPbK9BuOo+0TU6FA/S11ekIIS3LR1gsLiMZaG
	 mJvEUbFS4EnjHWHw0mmkVeePQ3ozflixNW+Mf7PgkbFPaNxs5zDRXrhRsUvsJ6qIwh
	 nvaEhh/w7672EUsnJyENttVNo1/Exy/MsDqmdMXp6iyLxGelAPVwHWr0EhfXbeuCBH
	 DtboMbnFmvheg==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-22ed9094168so394137fac.1;
        Wed, 10 Apr 2024 06:28:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUvCPBj70J2L7Pf20S46pLKB44Q9L3Zj7tUQnUdZwDY+n5wWKFhcFzXFKfbifvqxZY/nrQdgN4W0BxFsnxpA5fvMO4hSI9hOB9eEcr9eHTxlWD5shUzzOggwiSLGYfY7ME5
X-Gm-Message-State: AOJu0YysDmvciEMEmsh2cBnscbvEoSjfuVGS/ci8v3IYyBGH8XQHwfnV
	DHXGn+eQFy2CnS6+iFf1EAuwdMccpU9mNbvWz/zz2SQ9+wsddGKLNwBmTu/a/tXaiVwApdbRSS5
	bI4MDgGrtWS387rhXFp9N35GygeI=
X-Google-Smtp-Source: AGHT+IFL5SftybRh1r8JWNftMLn5Ll2W8+pkIYo7YlzdluWnaIUYaO6UpMp9mGVfMWaTjUBfbyWqBLpc+8TxlkLduX4=
X-Received: by 2002:a05:6871:a00a:b0:22d:fb4b:9d11 with SMTP id
 vp10-20020a056871a00a00b0022dfb4b9d11mr2534660oab.4.1712755710509; Wed, 10
 Apr 2024 06:28:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Zbp5xzmFhKDAgHws@shell.armlinux.org.uk> <E1rVDmU-0027YP-Jz@rmk-PC.armlinux.org.uk>
 <CAJZ5v0iiJpUWq5GMSnKFWQTzn_bdwoQz9m=hDaXNg4Lj_ePF4g@mail.gmail.com>
 <20240322185327.00002416@Huawei.com> <20240410134318.0000193c@huawei.com>
In-Reply-To: <20240410134318.0000193c@huawei.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 10 Apr 2024 15:28:18 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0ggD042sfz3jDXQVDUxQZu_AWaF2ox-Me8CvFeRB8nczw@mail.gmail.com>
Message-ID: <CAJZ5v0ggD042sfz3jDXQVDUxQZu_AWaF2ox-Me8CvFeRB8nczw@mail.gmail.com>
Subject: Re: [PATCH RFC v4 02/15] ACPI: processor: Register all CPUs from acpi_processor_get_info()
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, 
	linux-pm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, 
	acpica-devel@lists.linuxfoundation.org, linux-csky@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-ia64@vger.kernel.org, 
	linux-parisc@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com, justin.he@arm.com, 
	James Morse <james.morse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024 at 2:43=E2=80=AFPM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> > >
> > > > diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> > > > index 47de0f140ba6..13d052bf13f4 100644
> > > > --- a/drivers/base/cpu.c
> > > > +++ b/drivers/base/cpu.c
> > > > @@ -553,7 +553,11 @@ static void __init cpu_dev_register_generic(vo=
id)
> > > >  {
> > > >         int i, ret;
> > > >
> > > > -       if (!IS_ENABLED(CONFIG_GENERIC_CPU_DEVICES))
> > > > +       /*
> > > > +        * When ACPI is enabled, CPUs are registered via
> > > > +        * acpi_processor_get_info().
> > > > +        */
> > > > +       if (!IS_ENABLED(CONFIG_GENERIC_CPU_DEVICES) || !acpi_disabl=
ed)
> > > >                 return;
> > >
> > > Honestly, this looks like a quick hack to me and it absolutely
> > > requires an ACK from the x86 maintainers to go anywhere.
> > Will address this separately.
> >
>
> So do people prefer this hack, or something along lines of the following?
>
> static int __init cpu_dev_register_generic(void)
> {
>         int i, ret =3D 0;
>
>         for_each_online_cpu(i) {
>                 if (!get_cpu_device(i)) {
>                         ret =3D arch_register_cpu(i);
>                         if (ret)
>                                 pr_warn("register_cpu %d failed (%d)\n", =
i, ret);
>                 }
>         }
>         //Probably just eat the error.
>         return 0;
> }
> subsys_initcall_sync(cpu_dev_register_generic);

I would prefer something like the above.

I actually thought that arch_register_cpu() might return something
like -EPROBE_DEFER when it cannot determine whether or not the CPU is
really available.

Then, the ACPI processor enumeration path may take care of registering
CPU that have not been registered so far and in the more-or-less the
same way regardless of the architecture (modulo some arch-specific
stuff).

In the end, it should be possible to avoid changing the behavior of
x86 and loongarch in this series.

> Which may look familiar at it's effectively patch 3 from v3 which was dea=
ling
> with CPUs missing from DSDT (something we think doesn't happen).
>
> It might be possible to elide the arch_register_cpu() in
> make_present() but that will mean we use different flows in this patch se=
t
> for the hotplug and initially present cases which is a bit messy.
>
> I've tested this lightly on arm64 and x86 ACPI + DT booting and it "seems=
" fine.

Sounds promising.

Thanks!
