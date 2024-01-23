Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD736351F;
	Tue, 23 Jan 2024 16:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706026568; cv=none; b=lp1pCEXWWHtIuOYRKcSKPHz7UnTD4aWYq096DwX3jpz2Elr9AUiUtGIM72lPFIXX+oWDbEMuAZharN34NXJhp893SboWozaz+Jdd4Ija2aPVRLP5hhRynGpLPKaW5AUm5WcwpaDhmJHEgmUKx8m1mmKX2ZP/8MViX3FHG24OJxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706026568; c=relaxed/simple;
	bh=w3+AYXUdBPT1k1chiYw1nvRpK0AKwcZFytOy9qQHdiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mydW34joNzZQ5GFphB968f7z/i8uG6eSLhdpisEoXarGxkEU8WYE4Kxg4hULDt4J63aaZYN3H2oba/Xg+jdHAulZOvjIsnTV/q07niJtR21ybOw02Y22WIr7UFkBEV3EeKB90f4PvE0UukkT31K4M6wT1GdoSSjWNBY8v79PxPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6dde3884b92so877592a34.0;
        Tue, 23 Jan 2024 08:16:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706026566; x=1706631366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJEIU7VR+3J2Yia1miwsBzYF1liLE8jqQNwwQ3tqywA=;
        b=P4rsU49zxq5qgndsVd617wSdUTw9OQiUYgMNpC+qFmdpxCI/9OKaftHpzINQaYamf7
         6uu4p1nDvUIBC/ZqqobISKjr9WKeDi59BEkKuxWAeSdWaKMKKgN0ONMmt3rdglMVfvYk
         Fj1H1wxLjgG+bpvWl7QEm7cDdM/+xdk2E54hPb1wdN0A3GGeKuWRj05L4gt7cGj05Rdp
         +jBzr0CyyetEutCTLebg3C0fpJaaVQFAwG0KvES8XltpzRVBGHVWlfJbvYDgwrtEcoKX
         n28LhlgHMk8DtLLfOPU6B01R0UCz4oDRDyUlNgIZqWGOcUAn5jss3OjMOaZoM6EvM0cJ
         POVQ==
X-Gm-Message-State: AOJu0YzEzyG8ZszhW/PtdOvOTEAD+CG10OU0HGKCIah3k6L24F0Gh0TM
	UeWZ4+DxPsm8xQR+0TIiY6fmPUsP3xspVhz2WOAVxqOC8JVZsuD3lFA3aCb7kX0jacaoWUo7lTn
	OnWTv8D+FkCEGuXSinoKd32ZoU+E=
X-Google-Smtp-Source: AGHT+IHQzsBW5twpX6SIjbULqATUBQ0vqIkaZWwGQH4D7Ygegig4qDUNFIf/V4v9BHOfqKgEoP5iIqbc4ar0eQw6LMM=
X-Received: by 2002:a05:6808:f10:b0:3bd:c5eb:451c with SMTP id
 m16-20020a0568080f1000b003bdc5eb451cmr2255072oiw.1.1706026566440; Tue, 23 Jan
 2024 08:16:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZXmn46ptis59F0CO@shell.armlinux.org.uk> <E1rDOgD-00Dvk2-3h@rmk-PC.armlinux.org.uk>
 <CAJZ5v0g9nfLrEf9u4Ksw6BOWJQ9iv8Z-O8RsLU6jR5zk0ahxRw@mail.gmail.com>
 <20240122180013.000016d5@Huawei.com> <Za++/11n5KA1VS3p@shell.armlinux.org.uk>
In-Reply-To: <Za++/11n5KA1VS3p@shell.armlinux.org.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 23 Jan 2024 17:15:54 +0100
Message-ID: <CAJZ5v0h7wsLt8d3ZoLXsK1=crAx66T42WDKNoHcg8CiHpAjS8g@mail.gmail.com>
Subject: Re: [PATCH RFC v3 05/21] ACPI: Rename ACPI_HOTPLUG_CPU to include 'present'
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
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

On Tue, Jan 23, 2024 at 2:28=E2=80=AFPM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jan 22, 2024 at 06:00:13PM +0000, Jonathan Cameron wrote:
> > On Mon, 18 Dec 2023 21:35:16 +0100
> > "Rafael J. Wysocki" <rafael@kernel.org> wrote:
> >
> > > On Wed, Dec 13, 2023 at 1:49=E2=80=AFPM Russell King <rmk+kernel@arml=
inux.org.uk> wrote:
> > > >
> > > > From: James Morse <james.morse@arm.com>
> > > >
> > > > The code behind ACPI_HOTPLUG_CPU allows a not-present CPU to become
> > > > present.
> > >
> > > Right.
> > >
> > > > This isn't the only use of HOTPLUG_CPU. On arm64 and riscv
> > > > CPUs can be taken offline as a power saving measure.
> > >
> > > But still there is the case in which a non-present CPU can become
> > > present, isn't it there?
> >
> > Not yet defined by the architectures (and I'm assuming it probably neve=
r will be).
> >
> > The original proposal we took to ARM was to do exactly that - they push=
ed
> > back hard on the basis there was no architecturally safe way to impleme=
nt it.
> > Too much of the ARM arch has to exist from the start of time.
> >
> > https://lore.kernel.org/linux-arm-kernel/cbaa6d68-6143-e010-5f3c-ec62f8=
79ad95@arm.com/
> > is one of the relevant threads of the kernel side of that discussion.
> >
> > Not to put specific words into the ARM architects mouths, but the
> > short description is that there is currently no demand for working
> > out how to make physical CPU hotplug possible, as such they will not
> > provide an architecturally compliant way to do it for virtual CPU hotpl=
ug and
> > another means is needed (which is why this series doesn't use the prese=
nt bit
> > for that purpose and we have the Online capable bit in MADT/GICC)
> >
> > It was a 'fun' dance of several years to get to that clarification.
> > As another fun fact, the same is defined for x86, but I don't think
> > anyone has used it yet (GICC for ARM has an online capable bit in the f=
lags to
> > enable this, which was remarkably similar to the online capable bit in =
the
> > flags of the Local APIC entries as added fairly recently).
> >
> > >
> > > > On arm64 an offline CPU may be disabled by firmware, preventing it =
from
> > > > being brought back online, but it remains present throughout.
> > > >
> > > > Adding code to prevent user-space trying to online these disabled C=
PUs
> > > > needs some additional terminology.
> > > >
> > > > Rename the Kconfig symbol CONFIG_ACPI_HOTPLUG_PRESENT_CPU to reflec=
t
> > > > that it makes possible CPUs present.
> > >
> > > Honestly, I don't think that this change is necessary or even useful.
> >
> > Whilst it's an attempt to avoid future confusion, the rename is
> > not something I really care about so my advice to Russell is drop
> > it unless you are attached to it!
>
> While I agree that it isn't a necessity, I don't fully agree that it
> isn't useful.
>
> One of the issues will be that while Arm64 will support hotplug vCPU,
> it won't be setting ACPI_HOTPLUG_CPU because it doesn't support
> the present bit changing. So I can see why James decided to rename
> it - because with Arm64's hotplug vCPU, the idea that ACPI_HOTPLUG_CPU
> somehow enables hotplug CPU support is now no longer true.
>
> Keeping it as ACPI_HOTPLUG_CPU makes the code less obvious, because it
> leads one to assume that it ought to be enabled for Arm64's
> implementatinon, and that could well cause issues in the future if
> people make the assumption that "ACPI_HOTPLUG_CPU" means hotplug CPU
> is supported in ACPI. It doesn't anymore.

On x86 there is no confusion AFAICS.  It's always meant "as long as
the platform supports it".
