Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1034CB8D4
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 18:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791830279; cv=none; b=abrPMuejLosAwriiRaXWBmVfULNJXcN5ooiXxSA2R8F18EPD/VXkhaf/pBGE4BG5IaTCVKBM0KJys85fsaOx+/kcxdRWRKI65p1kGj/y4MIsHHH8M1fUTdvDXGQacqkgeheGOwlyylLzzE2zpwLt67VgXu0teGfN+y+sThHFYSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791830279; c=relaxed/simple;
	bh=PAJwNoyeV9qo8z7bFLcFxGpJsVQgzwLwwepP4CadQZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qHauxiCyqjYluAjwzI1aZQsOSZCIBuJbych/z1qsc5kn8jHd2QOP9VC2bFS1uSDooWc2MA3oa4uzMEPqzbtCCRmYowQ/xP3G/8EXpsfXrE1qc2r2xgQuXbfNX9yfmoZBMywsSAcR5cizKbAQN1W1545k/Nm5l+zO19I3FClbboU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=polbG+MS; arc=none smtp.client-ip=91.218.175.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="polbG+MS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PAJwNoyeV9qo8z7bFLcFxGpJsVQgzwLwwepP4CadQZ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791830274; v=1; x=1792435074;
 b=polbG+MSyl5zyYK/hvQlFzQUvHeX+gdmTB1WG9tSAZI4tgTlnm06xM9q7o7ETXqMv7vxmvI3
 DRTVpXQtL7vv2TAn/ArbJcnmgMbhCWp1M/98JrniazHUw/ygOzwxGeOItIW55itl3NwwUT+YoO+
 vkcR9mdZpOFRFmDxlbXQiy2A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d60e517c5e6734f1;
	Mon, 12 Oct 2026 18:37:53 +0000
X-Mizu-Trace-ID: d60e517c5e6734f1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so10933e87.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 11:37:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzxLgprX4ZGN3IRe88Ukjo0BVilPrZCjCgJDE1B1QkqECgasaH6VFWWdJ73Tk8eTAoQvzQt8hk=@lists.linux.dev
X-Gm-Message-State: AFq9FYItMiA4o9rjVjQOEknoKRUoAIFv7NXUUz2b9PtoBpdn7bWUf0iQ
	UF7remRjuMbIhiQMW53shBI6V0LJ0dPM3lLV95qEnUYa2sAcqHQi3E45r3OzTZjyEuhFbXP87aw
	3yk2gaz2UkHqkzEvrbass/9NGeVHCOSoubYe1tcX4
X-Received: by 2002:a05:6512:6204:b0:5bc:f1dd:f0ac with SMTP id
 2adb3069b0e04-5bcf1ddf0c7mr137133e87.1.1791830271913; Mon, 12 Oct 2026
 11:37:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261012084743.2228612-1-fuad.tabba@linux.dev>
 <8633ub2mlg.wl-maz@kernel.org> <CA+EHjTwyQPPVG4tGY0i0DRk=kwbdEmjca6+GNjLDXrGxkNbMOw@mail.gmail.com>
 <86zewi23ga.wl-maz@kernel.org>
In-Reply-To: <86zewi23ga.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 12 Oct 2026 19:37:15 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy1zAoOH32hsf0cHZGP1C-=uVBSJS91QGZ3_-NkKJEKhw@mail.gmail.com>
X-Gm-Features: AclHuK_918Jtmjw5j4JcpJhTo2ueYx7ntIhbD08RWsI09XibC9OrOgTwIR86Ta0
Message-ID: <CA+EHjTy1zAoOH32hsf0cHZGP1C-=uVBSJS91QGZ3_-NkKJEKhw@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: vgic-v4: Don't forward an LPI with no
 target vCPU
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 Oct 2026 at 19:12, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 12 Oct 2026 15:13:51 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > Hi Marc,
> >
> > On Mon, 12 Oct 2026 12:18:51 +0100, Marc Zyngier <maz@kernel.org> wrote:
> > [...]
> > > Isn't the core problem that we don't correctly handle the UNPRED
> > > double mapping of the same LPI? I'd rather we attack the issue at the
> > > source instead of papering over the consequences.
> > >
> > > I hacked the following, which is obviously untested. Can you give it a
> > > go?
> >
> > With your diff on rc3, the second MAPTI is dropped, and forwarding the
> > vfio-pci MSI to its event leaves the host up.
> >
> > However, a vgic_irq outlives its ITE while the LPI is pending on a
> > vCPU, so the check also drops a legitimate remap: a guest that
> > DISCARDs a pending LPI and then maps it again loses the new mapping.
>
> But this is yet another bug: 5.3.4 is pretty clear that DISCARD should
> get rid of everything (pending bit and mapping). I reckon this is yet
> another case of the initial implementation being overly worried about
> kicking vcpus out of the guest when destructive action is required.
>
> We should fix this.

I'll add a patch to v2 that makes DISCARD clear the pending state,
kicking the vCPUs out of the guest first when the LPI is queued on
one.

Cheers,
/fuad


>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
