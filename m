Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0B4153BD0;
	Mon, 29 Jan 2024 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542512; cv=none; b=QLlgHrCXtR1LqJVaPfZqwWpDdJ4n7h3YP2jeSaRjOGaDAk/NYBw2xmgGIzzYrapDrz/9wOs5AXYSVJVR38ibGAYw2CV2hvAvecCl7vwWVbabXS77dwqVjNU2cm6WyFufF2Y9jnwOw/GmFomVJMivvzQ4j+zbdmXO490c20jx5FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542512; c=relaxed/simple;
	bh=oqnGdtTv/k7O49UAKeLaHEMigeXSQOzpobeqbQwsRC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ssOKd70V8wXouNaD0ss66a4L1cuMdg29Z1GsXH6EG9KgJs0vZTKTz01MBcPi0KZqfoKyI1zg3Ct8/XoKOrPeMhHBHDmlhu6MxmA5VLtW+dgxe6UFII8ZNAZQ+4o3ueLnxIVcWfcUkSBD++T61vEDROM51fXWpYdw1XNa66j6PSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2148935ece3so23661fac.1;
        Mon, 29 Jan 2024 07:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706542508; x=1707147308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TG+8XeCHdsIlnW4L47AUTukqeea8Ay75J0VzHSz+j7A=;
        b=kD2kRBjtjC9pXd2rTfWbl6gMiE1XyXI81/NlFyv+Zk4KHA4PtfNdf1UZx7eAcRnO0B
         /sJJC6aY9yXFlTzHezOpPKG7jHa3z2bDZd3jECDNed/uu4wPc/UaMI1erfrLby1N8eV5
         oZuTjOXg63kPFd6q5fGRVezssitWGWGGiWHoBvihmIALXYEd0BqXSGFMl6rRqQEsijm7
         Wdw5OZlsxT5grQVgTS2bv5WSvlmT26m3XMV97GAMZ5/KU8kFZYe93vhomfnoRYmy7fIq
         z7pfpu5be/T0CWb2Z2c2Kbvh4bscq4S5Vah+s9BnayQjOZzbfpCFXfHc7REwa8EqQIAT
         GWAg==
X-Forwarded-Encrypted: i=0; AJvYcCXfMlqn7xWqSMJGApAgRZAdYD3iFvxka2IMZ719GA17CBSjal6CKJyWfjteeHMhsqJV/i2TEXP7cYGXXNH7lW18ysPzpab0eh1PeStX9aEpdg6SG/qt3kqJNZtZGwtGCoBS
X-Gm-Message-State: AOJu0Yzj1H5wvWKm0REDYjt6QYuNObI3F/xBcH6nyMjiVNnOpBxMOQ7u
	/BYbgqMinLCegBWGs0783hpWq01xw4g1o+9HJw8/5DgilsmmVkNFNIZEhzmS+2XCVpScHxeKQqN
	1qMaB2Y8oeNUGkoCHoGv3Fzi5dmA=
X-Google-Smtp-Source: AGHT+IHhrTU6Vx9l5tJAOVsHqvjFv8owslRWENpfX2JETljBTVS4w/It4UoW1njjPVf/6maja2wtMQZ5MonYr2C+WRA=
X-Received: by 2002:a05:6870:230d:b0:214:fddf:99f7 with SMTP id
 w13-20020a056870230d00b00214fddf99f7mr7432263oao.5.1706542508620; Mon, 29 Jan
 2024 07:35:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZXmn46ptis59F0CO@shell.armlinux.org.uk> <ZXxxa+XZjPZtNfJ+@shell.armlinux.org.uk>
 <20231215161539.00000940@Huawei.com> <5760569.DvuYhMxLoT@kreacher>
 <20240102143925.00004361@Huawei.com> <20240111101949.000075dc@Huawei.com>
 <ZZ/CR/6Voec066DR@shell.armlinux.org.uk> <20240112115205.000043b0@Huawei.com>
 <Zbe8WQRASx6D6RaG@shell.armlinux.org.uk> <CAJZ5v0iba93EhQB2k3LMdb2YczndbRmF5WGRYHhnqCHq6TQJ0A@mail.gmail.com>
 <ZbfBYgdLzvEX/VjN@shell.armlinux.org.uk>
In-Reply-To: <ZbfBYgdLzvEX/VjN@shell.armlinux.org.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 29 Jan 2024 16:34:57 +0100
Message-ID: <CAJZ5v0gr3ZmLY9m+rYGP36zQYNH4ohL=zbym4LS3Eq+Qt4nZLA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 01/21] ACPI: Only enumerate enabled (or functional) devices
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org, loongarch@lists.linux.dev, 
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

On Mon, Jan 29, 2024 at 4:17=E2=80=AFPM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jan 29, 2024 at 04:05:42PM +0100, Rafael J. Wysocki wrote:
> > On Mon, Jan 29, 2024 at 3:55=E2=80=AFPM Russell King (Oracle)
> > <linux@armlinux.org.uk> wrote:
> > >
> > > Hi Jonathan,
> > >
> > > On Fri, Jan 12, 2024 at 11:52:05AM +0000, Jonathan Cameron wrote:
> > > > On Thu, 11 Jan 2024 10:26:15 +0000
> > > > "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > > > > @@ -2381,16 +2388,38 @@ EXPORT_SYMBOL_GPL(acpi_dev_clear_dependen=
cies);
> > > > >   * acpi_dev_ready_for_enumeration - Check if the ACPI device is =
ready for enumeration
> > > > >   * @device: Pointer to the &struct acpi_device to check
> > > > >   *
> > > > > - * Check if the device is present and has no unmet dependencies.
> > > > > + * Check if the device is functional or enabled and has no unmet=
 dependencies.
> > > > >   *
> > > > > - * Return true if the device is ready for enumeratino. Otherwise=
, return false.
> > > > > + * Return true if the device is ready for enumeration. Otherwise=
, return false.
> > > > >   */
> > > > >  bool acpi_dev_ready_for_enumeration(const struct acpi_device *de=
vice)
> > > > >  {
> > > > >     if (device->flags.honor_deps && device->dep_unmet)
> > > > >             return false;
> > > > >
> > > > > -   return acpi_device_is_present(device);
> > > > > +   /*
> > > > > +    * ACPI 6.5's 6.3.7 "_STA (Device Status)" allows firmware to=
 return
> > > > > +    * (!present && functional) for certain types of devices that=
 should be
> > > > > +    * enumerated. Note that the enabled bit should not be set un=
less the
> > > > > +    * present bit is set.
> > > > > +    *
> > > > > +    * However, limit this only to processor devices to reduce po=
ssible
> > > > > +    * regressions with firmware.
> > > > > +    */
> > > > > +   if (device->status.functional)
> > > > > +           return true;
> > >
> > > I have a report from within Oracle that this causes testing failures
> > > with QEMU using -smp cpus=3D2,maxcpus=3D4. I think it needs to be:
> > >
> > >         if (!device->status.present)
> > >                 return device->status.functional;
> > >
> > >         if (device->status.enabled)
> > >                 return true;
> > >
> > >         return !acpi_device_is_processor(device);
> >
> > The above is fine by me.
> >
> > > So we can better understand the history here, let's list it as a
> > > truth table. P=3Dpresent, F=3Dfunctional, E=3Denabled, Orig=3Dhow the=
 code
> > > is in mainline, James=3DJames' original proposal, Rafael=3Dthe propos=
ed
> > > replacement but seems to be buggy, Rmk=3Dthe fixed version that passe=
s
> > > tests:
> > >
> > > P F E   Orig    James   Rafael          Rmk
> > > 0 0 0   0       0       0               0
> > > 0 0 1   0       0       0               0
> > > 0 1 0   1       1       1               1
> > > 0 1 1   1       0       1               1
> > > 1 0 0   1       0       !processor      !processor
> > > 1 0 1   1       1       1               1
> > > 1 1 0   1       0       1               !processor
> > > 1 1 1   1       1       1               1
> > >
> > > Any objections to this?
> >
> > So AFAIAC it can return false if not enabled, but present and
> > functional.  [Side note: I'm wondering what "functional" means then,
> > but whatever.]
>
> From ACPI v6.5 (bit 3 is our "status.functional":
>
>  _STA may return bit 0 clear (not present) with bit [3] set (device is
>  functional). This case is used to indicate a valid device for which no
>  device driver should be loaded (for example, a bridge device.) Children
>  of this device may be present and valid. OSPM should continue
>  enumeration below a device whose _STA returns this bit combination.
>
> So, for this case, acpi_dev_ready_for_enumeration() returning true for
> this case is correct, since we're supposed to enumerate it and child
> devices.
>
> It's probably also worth pointing out that in the above table, the two
> combinations with P=3D0 E=3D1 goes against the spec, but are included for
> completness.

The difference between the last two columns is the present and
functional, but not enabled combination AFAICS, for which my patch
just returned true, but the firmware disagrees with that.

It is kind of analogous to the "not present and functional" case
covered by the spec, which is why it is fine by me to return "false"
then (for processors), but the spec is not crystal clear about it.
