Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489A550276;
	Tue, 23 Jan 2024 20:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706041052; cv=none; b=maN8i1q18yYpzibHwcKM6yj28thQBnmKy2t6vRnrlYefhO6NGwON/D/MCLMdaO/6gQUXxxB/diPd4TeQtHzcjVx2lq3ua60MHyVm89mkkqSMZzxt1lscAQnsMU61sbMJFxal6wnhNw6BabduDbPKhGVQTtGqtDkrE1xQ4Htt/7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706041052; c=relaxed/simple;
	bh=/9f1YTKBu4zBe52fKkbMixxUaJxXc0rAwAqrn8phDrg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K9KR06ewFawxg4Ci9m7oUz0nITiCXYJhcjKk/qdKsEXC7Z8Ato55+ZYWcgsbemeTzGwgsmeIYgEv96Jxsfsubz4EmyHDjNQnPgbweIUmoCCo9zMoYSg/fqbep74VD6v9chpAqugRkXgavtlY0ZFIqNZ8vJ/ZAUkk7d95NWImE7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3bc21303a35so952288b6e.0;
        Tue, 23 Jan 2024 12:17:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706041050; x=1706645850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sjwjCx3B3HGly0Ju5hQihpTfVoMomg/HaqPAAfRqPtg=;
        b=sQ6L3aLirw23D0jKNqwKdIna8mzX8/Iqr6W9Bw1QyyHpbuDIfHaWhNDoWk0VhXnTQl
         I9Boj+nqoHm8OAfPew4MTtdqbZFPEzu3H5zGM+gpUC4/1kFOrscdKxM5u0jIt36SmYYj
         HzTQ0ncF12vRBXC277igMIUjub75UJBzVF3NT2LVMho8KKuuEaCtbPSbyblUWlpX9swI
         x9vyjTiJtmMTkYJC/G5i4rBp0WAgbpNvX2uTvEuyGQSQTnQhjJHUY1TxtR9pLuRui8+z
         CkZ9P1jXG47wM/5B5WBM4V0RyiwFuQAFOoPC/HVcyoNO63qwtq7ESmBkiWVWkMX9sYyV
         J/kA==
X-Gm-Message-State: AOJu0YwjfScHw+a5k2XXeuWT16L1foPneuxxNE8uFPkE0Fx7LzNmSB9D
	R2LvSPI1+b1q0YERYoLK+xHUFdjOMGKRwH2dhAzyRRhIPkSec6xF9dMTC4ARywUpc8HxCZzepVZ
	ISoXfAzfRz2jvuWHma2wuP9coB3e5E/4n
X-Google-Smtp-Source: AGHT+IHml0amPVumvE3AkdPdfk0wGdrTR6wdzSDBZsH+0cMpLee+4fRC2vTsTL1WMI0dC+P3unXdJ9Uy83P3RZ5jLig=
X-Received: by 2002:a05:6871:410e:b0:206:a752:52dd with SMTP id
 la14-20020a056871410e00b00206a75252ddmr498462oab.1.1706041050313; Tue, 23 Jan
 2024 12:17:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAJZ5v0g9nfLrEf9u4Ksw6BOWJQ9iv8Z-O8RsLU6jR5zk0ahxRw@mail.gmail.com>
 <20240122180013.000016d5@Huawei.com> <Za++/11n5KA1VS3p@shell.armlinux.org.uk>
 <CAJZ5v0h7wsLt8d3ZoLXsK1=crAx66T42WDKNoHcg8CiHpAjS8g@mail.gmail.com>
 <Za/q9jivG4OdZM0f@shell.armlinux.org.uk> <CAJZ5v0gwe02uzAQoX0QDHo35OTEozpbnqC6vukjM3aE6HMq9WQ@mail.gmail.com>
 <ZbADTBLDEFtdglho@shell.armlinux.org.uk> <CAJZ5v0jh-EdrnjkJep++UDo+Uv4hmR7VV4KYVdF4CK2K+5XLtg@mail.gmail.com>
 <ZbAMjZoybVfiAGcT@shell.armlinux.org.uk> <CAJZ5v0gt=MR1JGsPZnZG_AqudA-KMmb4BOa_A6H9B6+Rhe_+JQ@mail.gmail.com>
 <ZbAdAdqqfXRuY3Xj@shell.armlinux.org.uk>
In-Reply-To: <ZbAdAdqqfXRuY3Xj@shell.armlinux.org.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 23 Jan 2024 21:17:18 +0100
Message-ID: <CAJZ5v0gsqbeJc4qX-AefOqu53=rDme2XzFXacWz_0zbVBoaXjw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 05/21] ACPI: Rename ACPI_HOTPLUG_CPU to include 'present'
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
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

On Tue, Jan 23, 2024 at 9:09=E2=80=AFPM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Tue, Jan 23, 2024 at 08:27:05PM +0100, Rafael J. Wysocki wrote:
> > On Tue, Jan 23, 2024 at 7:59=E2=80=AFPM Russell King (Oracle)
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Tue, Jan 23, 2024 at 07:26:57PM +0100, Rafael J. Wysocki wrote:
> > > > On Tue, Jan 23, 2024 at 7:20=E2=80=AFPM Russell King (Oracle)
> > > > <linux@armlinux.org.uk> wrote:
> > > > >
> > > > > On Tue, Jan 23, 2024 at 06:43:59PM +0100, Rafael J. Wysocki wrote=
:
> > > > > > On Tue, Jan 23, 2024 at 5:36=E2=80=AFPM Russell King (Oracle)
> > > > > > <linux@armlinux.org.uk> wrote:
> > > > > > >
> > > > > > > On Tue, Jan 23, 2024 at 05:15:54PM +0100, Rafael J. Wysocki w=
rote:
> > > > > > > > On Tue, Jan 23, 2024 at 2:28=E2=80=AFPM Russell King (Oracl=
e)
> > > > > > > > <linux@armlinux.org.uk> wrote:
> > > > > > > > >
> > > > > > > > > On Mon, Jan 22, 2024 at 06:00:13PM +0000, Jonathan Camero=
n wrote:
> > > > > > > > > > On Mon, 18 Dec 2023 21:35:16 +0100
> > > > > > > > > > "Rafael J. Wysocki" <rafael@kernel.org> wrote:
> > > > > > > > > >
> > > > > > > > > > > On Wed, Dec 13, 2023 at 1:49=E2=80=AFPM Russell King =
<rmk+kernel@armlinux.org.uk> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > From: James Morse <james.morse@arm.com>
> > > > > > > > > > > >
> > > > > > > > > > > > The code behind ACPI_HOTPLUG_CPU allows a not-prese=
nt CPU to become
> > > > > > > > > > > > present.
> > > > > > > > > > >
> > > > > > > > > > > Right.
> > > > > > > > > > >
> > > > > > > > > > > > This isn't the only use of HOTPLUG_CPU. On arm64 an=
d riscv
> > > > > > > > > > > > CPUs can be taken offline as a power saving measure=
.
> > > > > > > > > > >
> > > > > > > > > > > But still there is the case in which a non-present CP=
U can become
> > > > > > > > > > > present, isn't it there?
> > > > > > > > > >
> > > > > > > > > > Not yet defined by the architectures (and I'm assuming =
it probably never will be).
> > > > > > > > > >
> > > > > > > > > > The original proposal we took to ARM was to do exactly =
that - they pushed
> > > > > > > > > > back hard on the basis there was no architecturally saf=
e way to implement it.
> > > > > > > > > > Too much of the ARM arch has to exist from the start of=
 time.
> > > > > > > > > >
> > > > > > > > > > https://lore.kernel.org/linux-arm-kernel/cbaa6d68-6143-=
e010-5f3c-ec62f879ad95@arm.com/
> > > > > > > > > > is one of the relevant threads of the kernel side of th=
at discussion.
> > > > > > > > > >
> > > > > > > > > > Not to put specific words into the ARM architects mouth=
s, but the
> > > > > > > > > > short description is that there is currently no demand =
for working
> > > > > > > > > > out how to make physical CPU hotplug possible, as such =
they will not
> > > > > > > > > > provide an architecturally compliant way to do it for v=
irtual CPU hotplug and
> > > > > > > > > > another means is needed (which is why this series doesn=
't use the present bit
> > > > > > > > > > for that purpose and we have the Online capable bit in =
MADT/GICC)
> > > > > > > > > >
> > > > > > > > > > It was a 'fun' dance of several years to get to that cl=
arification.
> > > > > > > > > > As another fun fact, the same is defined for x86, but I=
 don't think
> > > > > > > > > > anyone has used it yet (GICC for ARM has an online capa=
ble bit in the flags to
> > > > > > > > > > enable this, which was remarkably similar to the online=
 capable bit in the
> > > > > > > > > > flags of the Local APIC entries as added fairly recentl=
y).
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > > On arm64 an offline CPU may be disabled by firmware=
, preventing it from
> > > > > > > > > > > > being brought back online, but it remains present t=
hroughout.
> > > > > > > > > > > >
> > > > > > > > > > > > Adding code to prevent user-space trying to online =
these disabled CPUs
> > > > > > > > > > > > needs some additional terminology.
> > > > > > > > > > > >
> > > > > > > > > > > > Rename the Kconfig symbol CONFIG_ACPI_HOTPLUG_PRESE=
NT_CPU to reflect
> > > > > > > > > > > > that it makes possible CPUs present.
> > > > > > > > > > >
> > > > > > > > > > > Honestly, I don't think that this change is necessary=
 or even useful.
> > > > > > > > > >
> > > > > > > > > > Whilst it's an attempt to avoid future confusion, the r=
ename is
> > > > > > > > > > not something I really care about so my advice to Russe=
ll is drop
> > > > > > > > > > it unless you are attached to it!
> > > > > > > > >
> > > > > > > > > While I agree that it isn't a necessity, I don't fully ag=
ree that it
> > > > > > > > > isn't useful.
> > > > > > > > >
> > > > > > > > > One of the issues will be that while Arm64 will support h=
otplug vCPU,
> > > > > > > > > it won't be setting ACPI_HOTPLUG_CPU because it doesn't s=
upport
> > > > > > > > > the present bit changing. So I can see why James decided =
to rename
> > > > > > > > > it - because with Arm64's hotplug vCPU, the idea that ACP=
I_HOTPLUG_CPU
> > > > > > > > > somehow enables hotplug CPU support is now no longer true=
.
> > > > > > > > >
> > > > > > > > > Keeping it as ACPI_HOTPLUG_CPU makes the code less obviou=
s, because it
> > > > > > > > > leads one to assume that it ought to be enabled for Arm64=
's
> > > > > > > > > implementatinon, and that could well cause issues in the =
future if
> > > > > > > > > people make the assumption that "ACPI_HOTPLUG_CPU" means =
hotplug CPU
> > > > > > > > > is supported in ACPI. It doesn't anymore.
> > > > > > > >
> > > > > > > > On x86 there is no confusion AFAICS.  It's always meant "as=
 long as
> > > > > > > > the platform supports it".
> > > > > > >
> > > > > > > That's x86, which supports physical CPU hotplug. We're introd=
ucing
> > > > > > > support for Arm64 here which doesn't support physical CPU hot=
plug.
> > > > > > >
> > > > > > >                                                 ACPI-based   =
   Physical        Virtual
> > > > > > > Arch    HOTPLUG_CPU     ACPI_HOTPLUG_CPU        Hotplug      =
   Hotplug         Hotplug
> > > > > > > Arm64   Y               N                       Y            =
   N               Y
> > > > > > > x86     Y               Y                       Y            =
   Y               Y
> > > > > > >
> > > > > > > So ACPI_HOTPLUG_CPU becomes totally misnamed with the introdu=
ction
> > > > > > > of hotplug on Arm64.
> > > > > > >
> > > > > > > If we want to just look at stuff from an x86 perspective, the=
n yes,
> > > > > > > it remains correct to call it ACPI_HOTPLUG_CPU. It isn't corr=
ect as
> > > > > > > soon as we add Arm64, as I already said.
> > > > > >
> > > > > > And if you rename it, it becomes less confusing for ARM64, but =
more
> > > > > > confusing for x86, which basically is my point.
> > > > > >
> > > > > > IMO "hotplug" covers both cases well enough and "hotplug presen=
t" is
> > > > > > only accurate for one of them.
> > > > > >
> > > > > > > And honestly, a two line quip to my reasoned argument is not =
IMHO
> > > > > > > an acceptable reply.
> > > > > >
> > > > > > Well, I'm not even sure how to respond to this ...
> > > > >
> > > > > The above explanation you give would have been useful...
> > > > >
> > > > > I don't see how "hotplug" covers both cases. As I've tried to poi=
nt
> > > > > out many times now, ACPI_HOTPLUG_CPU is N for Arm64, yet it suppo=
rts
> > > > > ACPI based hotplug. How does ACPI_HOTPLUG_CPU cover Arm64 if it's
> > > > > N there?
> > > >
> > > > But IIUC this change is preliminary for changing it (or equivalent
> > > > option with a different name) to Y, isn't it?
> > >
> > > No. As I keep saying, ACPI_HOTPLUG_CPU ends up N on Arm64 even when
> > > it supports hotplug CPU via ACPI.
> > >
> > > Even with the full Arm64 patch set here, under arch/ we still only
> > > have:
> > >
> > > arch/loongarch/Kconfig: select ACPI_HOTPLUG_PRESENT_CPU if ACPI_PROCE=
SSOR && HOTPLUG_CPU
> > > arch/x86/Kconfig:       select ACPI_HOTPLUG_PRESENT_CPU         if AC=
PI_PROCESSOR && HOTPLUG_CPU
> > >
> > > To say it yet again, ACPI_HOTPLUG_(PRESENT_)CPU is *never* set on
> > > Arm64.
> >
> > Allright, so ARM64 is not going to use the code that is conditional on
> > ACPI_HOTPLUG_CPU today.
> >
> > Fair enough.
> >
> > > > > IMHO it totally doesn't, and moreover, it goes against what
> > > > > one would logically expect - and this is why I have a problem wit=
h
> > > > > your effective NAK for this change. I believe you are basically
> > > > > wrong on this for the reasons I've given - that ACPI_HOTPLUG_CPU
> > > > > will be N for Arm64 despite it supporting ACPI-based CPU hotplug.
> > > >
> > > > So I still have to understand how renaming it for all architectures
> > > > (including x86) is supposed to help.
> > > >
> > > > It will still be the same option under a different name.  How does
> > > > that change things technically?
> > >
> > > Do you think that it makes any sense to have support for ACPI-based
> > > hotplug CPU
> >
> > So this is all about what you and I mean by "ACPI-based hotplug CPU".
> >
> > > *and* having it functional with a configuration symbol
> > > named "ACPI_HOTPLUG_CPU" to be set to N ? That's essentially what
> > > you are advocating for...
> >
> > Setting ACPI_HOTPLUG_CPU to N means that you are not going to compile
> > the code that is conditional on it.
> >
> > That code allows the processor driver to be removed from CPUs and
> > arch_unregister_cpu() to be called from within acpi_bus_trim()  (among
> > other things).  On the way up, it allows arch_register_cpu() to be
> > called from within acpi_bus_scan().  If these things are not done,
> > what I mean by "ACPI-based hotplug CPU" is not supported.
>
> Even on Arm64, arch_register_cpu() and arch_unregister_cpu() will be
> called when the CPU in the VM is hot-removed or hot-added...

In a different way, however.
