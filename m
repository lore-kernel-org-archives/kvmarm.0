Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F59346A0F
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 10:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763548699; cv=none; b=Qgl5xxcRLrugNk44lScAeH4Pw0IQLpGjxUArgqwwJwu7IFsbyH8QcokE71jGTwQrDXlIgCn/yDi3sERlepi61loowMY8eULJnYIcELp0WQ5w0kFzUl8p8wmi/RKy+GZIaSrrPAJFVklMwt535QdhQK3G4rCk6+GlSlS9VQWS4ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763548699; c=relaxed/simple;
	bh=qWJmc0Xb6IbyOw8w8OA9A8sY8tyZ294+v84mJLscPjU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BiboorSPvo4qxlInrsZ10oRwdc0A2cnjD+IRJIgfWh6krynurkIl0Z716eLi+9RGxo7j1VPFM1yOP9hnm4jSRirkXpA4JCSfFxyQ89BZsTHD3sWVjWISaDfFpxfv/kEo4n9X4BnThhqSTliRT+Ay2ub01ENAXc67KQJ6LKBD/sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p1Yrd9ZU; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p1Yrd9ZU"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee243b98caso198031cf.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 02:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763548697; x=1764153497; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ajPJXKSb6EvakAv/OuhuRvH8YRFIbHznazB/0gEJ+2M=;
        b=p1Yrd9ZU5w1DwF0kfkhpUCQhPf9jLjxGaQjIfXuIrUW0PvFX0caOrKscllUxHtGEbW
         lccFbQ+F0ZmpSYVM0KWSIJlNfy7foHMvcqkvzVwYUOMA1C937TKOhUCzPLT16C4Lj3Pg
         v4GWjDo2rAUUFGpjTGELaukyWNtDbK0yVi3CSx9tNBFjhf19/H9tzFWJNM8uQ5w1059L
         N0IvUewcnVHKI02tmFb7xFgaaqQlxkXmy4cprfpmOAvcAzYUEPsI1xCNuejhSfPR5YrK
         R9zk36uQblS88Hlfa3qMQZvrPMw6gB4zGpU4gP0P6mfmtydmD0f2wk97e+ooGrSA2E6v
         iQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763548697; x=1764153497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajPJXKSb6EvakAv/OuhuRvH8YRFIbHznazB/0gEJ+2M=;
        b=br2MhygB4BniB46yf049fOI8Mquu7tD0EWr7AwOSJPRu1Xa78UiorkBM+YDJaMI4Od
         M84k5fQtF81cixMBD2mhMZeEoek2wiNTTHTLMN/hUxGsr3uGmLZ2VIzFuOxsRVZkQ+I9
         yLMa2s847x0TtPd6p/IGB42XayLDWCmHbsa4nzFGgQDPweahWDUJe7mxWay4igF+jgAT
         PetIednBRqgr8NHaD54kyY08Gd2052o23+WhxHJtGylOFJ/sXioqnqYoKeL1hiYk4ft0
         BuD8aV5xS5BIXrbtCxVVitLyQCzWKiaW0RHyJz6vrZLcRHa+neksZNMLo4SQ5bL6xPgj
         3nqw==
X-Forwarded-Encrypted: i=1; AJvYcCVP0i+BgR8vwt6F651TAf/RPh0pxuAkoQy3E5yTGoUGp/CaLUfcdA1aLGJvHX7UjirJJOFIXvs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxV6IW4DjYsecYze4WmMfgMu84pzMak9AffRj33eSbn6V2/LoXO
	1fvPPd3M/lCdwrdgl43Tp0aChAw8x6zgPHi6fiVExZr5pKWLvCta+oAfjKIhVRYD9felPpamYLF
	iyvVhCTx4a5/bOCv29FEyEwEG/+IuBOtMcgsM1kwd
X-Gm-Gg: ASbGncvz/WEa/6/4Ze6m9sMCbDe7Qv75BWn+NxQUUJczJ6YbAsjbonGiDcGcRvLTzkK
	1FHX0yDxG+ELyQeJHtLa1pueeBcY54d+AdgqlFlTZWn9KXBlzUFSidJqxInwty/h6Sij27ZTh6P
	PfFLO1DmRa7lqzaPxFkNiwx3B4eYrO07oO3MNFarX4MeO+z2FlfVBuqcU8z0cwE0HZgjq1FAte/
	MugkYhbOIOm+oWD92omKJHiTyGARZCKCA0fd++zjyF1lWdAJ4V16TCdgZV72X+oGJG6jo09BKVG
	B64y8Cc5IwBE2BebY/eoFCG9treLw4XMt5I=
X-Google-Smtp-Source: AGHT+IHyZj1mHlRoqcMVEK+Ke9v+QKN/GTCdvCboTV8ytrHFav/L7x1i8RWg43NziKnKMj+gWGYsCAB6fcyxt7vblr4=
X-Received: by 2002:a05:622a:1b88:b0:4ed:18ef:4060 with SMTP id
 d75a77b69052e-4ee3ec3080cmr5005131cf.8.1763548696534; Wed, 19 Nov 2025
 02:38:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <aRweUM4O71ecPvVr@kernel.org>
 <CA+EHjTzJQOTTSUoXVKpGdWO8vz9Vc-2AL3zRyzG4DkUPz+wBBQ@mail.gmail.com> <86ms4jrwhr.wl-maz@kernel.org>
In-Reply-To: <86ms4jrwhr.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 19 Nov 2025 10:37:39 +0000
X-Gm-Features: AWmQ_bnZDu_VkCPXAw-nz27IkT05jj1DSam5-p8uzswdO8xX2NqMq69pMVBt_H4
Message-ID: <CA+EHjTyiM+BNP+iRTYP7968np=y0+Vn38GtAfiTtg=JcUzjPpQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 18 Nov 2025 at 19:06, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Tue, 18 Nov 2025 13:59:14 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > On Tue, 18 Nov 2025 at 07:20, Oliver Upton <oupton@kernel.org> wrote:
> > >
> > > On Mon, Nov 17, 2025 at 09:15:22AM +0000, Marc Zyngier wrote:
> > > > This is a follow-up to the original series [1] (and fixes [2][3])
> > > > with a bunch of bug-fixes and improvements. At least one patch has
> > > > already been posted, but I thought I might repost it as part of a
> > > > series, since I accumulated more stuff:
> > > >
> > > > - The first patch addresses Mark's observation that the no-vgic-v3
> > > >   test has been broken once more. At some point, we'll have to retire
> > > >   that functionality, because even if we keep fixing the SR handling,
> > > >   nobody tests the actual interrupt state exposure to userspace, which
> > > >   I'm pretty sure has badly been broken for at least 5 years.
> > > >
> > > > - The second one addresses a report from Fuad that on QEMU,
> > > >   ICH_HCR_EL2.TDIR traps ICC_DIR_EL1 on top of ICV_DIR_EL1, leading to
> > > >   the host exploding on deactivating an interrupt. This behaviour is
> > > >   allowed by the spec, so make sure we clear all trap bits
> > > >
> > > > - Running vgic_irq in an L1 guest (the test being an L2) results in a
> > > >   MI storm on the host, as the state synchronisation is done at the
> > > >   wrong place, much like it was on the non-NV path before it was
> > > >   reworked. Apply the same methods to the NV code, and enjoy much
> > > >   better MI emulation, now tested all the way into an L3.
> > > >
> > > > - Nuke a small leftover from previous rework.
> > > >
> > > > - Force a read-back of ICH_MISR_EL2 when disabling the vgic, so that
> > > >   the trap prevents too many spurious MIs in an L1 guest, as the write
> > > >   to ICH_HCR_EL2 does exactly nothing on its own when running under
> > > >   FEAT_NV2.
> > > >
> > > > Oliver: this is starting to be a large series of fixes on top of the
> > > > existing series, plus the two patches you have already added. I'd be
> > > > happy to respin a full v4 with the fixes squashed into their original
> > > > patches. On the other hand, if you want to see the history in its full
> > > > glory, that also works for me.
> > >
> > > I'll pick up these patches in a moment but at this point I'd prefer a
> > > clean history. Plan is to send out the 6.19 pull sometime next week so
> > > any time before then would be great for v4.
> >
> > I'm happy to take that for another spin Marc before you send it, if
> > it's different from the ToT I tested. In that case, just send me a
> > pointer to the branch.
>
> I've just pushed out a full branch at [1]. Please make sure to merge
> kvmarm-fixes-6.18-3 in, as it fixes a couple of nasties (small
> conflict expected, but the resolution should be obvious).

For this branch [1]:
Tested-by: Fuad Tabba <tabba@google.com>

On QEMU, nVHE, hVHE protected mode (non-protected VMs with and without
the Android pKVM patches), and protected VMs (with the Android pKVM
patches).

Cheers,
/fuad



> For my own testing, I added -rc6 on top.
>
> Note that I didn't take your Tested-by: tags, as you are about to
> retest the whole thing anyway. If all goes well (fingers crossed),
> Oliver will be able to apply any further tag once I post these
> patches.
>
> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vgic-lr-overflow
>
> --
> Without deviation from the norm, progress is not possible.
