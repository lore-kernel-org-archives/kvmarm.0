Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD56D26462E
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 09:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763372488; cv=none; b=q7k/4t6x2JtP+mjDLRq1SM79UuV3LZQpQJYC+qh02lUHrWOBrU/ZeIKul+GBkG6P2xUqKdpixw9QlMY1RUoSPDIUrZ67uCdKbNDDrc3/1EUyygGR6lHRtxGQ5fMCIMYvDJOqtvU32w/Rl/9fO1t1KWDOWQHhzdk1KgjAbBkGsQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763372488; c=relaxed/simple;
	bh=T83IHgCK2t5OduC4DpuVuodTcvRaJPbXnYRwNe9f80I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gT++dZj9zThL4qDm4+/a9azGmEihXb34XEnlzk5A9TGvq61mD3ZKC6oucsnt6buhXtuG6DFMAQHKnEdhcCRqNRVBNlDoLaA3tTwh5k4s6qJX3AdJ98/5PL1T4xWnmKlAan94rKjpIocrbA6a4IUKVdnUABaQc5b8rTGkGsOgKRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZC+lrU7b; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZC+lrU7b"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed67a143c5so530151cf.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 01:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763372486; x=1763977286; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H4iPsNPmkfuJ1cA2QIm1+zZAl2TgmFyV4FeEo9bCgdc=;
        b=ZC+lrU7bROJHal7hlO+PQpMNn91IJ8Q+WTdB1/PQOCMGKV0EV8cRun4PaAlSIE6Xvs
         MhS4YNaAd3i5+6vVq3QQwFdiLVozfiZcYD3RuZnCadgn+HWCTQc07moRLBjOIJGmtHPI
         z3rTLWyItYPYSHWfbViYqJV9OSRF31TvlXdCMz8GS/TtbO7CYTxkvgoyyno2tx8YiIH+
         tH5bEu4GGaCDbD3dzmmsxuDnqkwVVaCArvn6kQdlSR/2bZ4LAzFt+SW6yCbV9PxhvNii
         9OP6bfRafn/J2Q4U2bpLDHJ8pJfPbTIWNPC++eQzhFCBuYjXuFXkMOm46jsFiG5OyH9q
         lNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763372486; x=1763977286;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4iPsNPmkfuJ1cA2QIm1+zZAl2TgmFyV4FeEo9bCgdc=;
        b=a7VjueF2d6G1bW0Dg14j4Qmt/vPa7xfVaZSuNANaa7rMptxIgKbmDP4y6ucA92Aa4J
         GfBpcFcBQVuUhn+zxYUMTxe3+877J7qHN7pbXIfv+T91CHIX4LnJtTV56+Hnsbsb3xp2
         8LSOuqLO3nZD7S8SgOLI8mqHJJ52xPvZiVyqz7vhX0lOGar7rvlbsx+1Y1ZcxFuM8RDb
         B8Hs6UPQmvKFxwt5veIy61aBgO+UX76EcDmqgB8zqVwc7Vio1fgK3AInv9IEOrOZ7qy/
         RqV7wVsjSEaqcKL4xZlSvqPdkL2mO4UBKWogKUEGRuQqx3nPXresPAZg0fd0LDeYcoU0
         dtLg==
X-Gm-Message-State: AOJu0Yyy8KmKMI+CglqmKzj+w0QmhZ2QtjyORNiuYVttyizW2lXlDj7B
	s8hNNxaxORLgCY7+QtkVpsoXwhz2EjLwuNZ7GGjLluqLAIxMLLdzkK0+oFhrWQC7NBGu51XwE4e
	dN4e4krOZscsJQxTGEq7JYCmGa9mSlYUoYKWxb1TQhYGBVyAyr9Ynpqd9odY=
X-Gm-Gg: ASbGncuMgyMoWH7XnPYdm/RPLMYxjXTRV4nnvQ4AOPOd/32cQu2GpewtFKDs1W5OxXW
	PlwWdQE3Na1DhwPVzVk1wcuCaDgtfM7hkzKtEePHm+WhUszhry+nNwuhsueViJWmkZ0dREBJXhg
	pAHSUzzKCKDXHI722nxoYGMMXBLvOyOaQ2OypeeK8gjKj4HUVKF+HqIP0Q+0Jkh87AG/jLOFSGR
	0zBaKnP59r9NawgoHOdseJKlHZbYTXYoYCxt02qAouDOHtlyn59FqlHm+LcedcUgoJtWKu/XEKU
	cyx14w==
X-Google-Smtp-Source: AGHT+IHyo86gLv8n5byRB2qu1f3O+SKyJvAI8m25dfDky6i1oSr81nnsILE93xqowzBnQ39Jo2dqU3RBGBtQLDM1NBM=
X-Received: by 2002:a05:622a:1802:b0:4b7:94d7:8b4c with SMTP id
 d75a77b69052e-4ee02670f8cmr10745491cf.0.1763372485428; Mon, 17 Nov 2025
 01:41:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 09:40:47 +0000
X-Gm-Features: AWmQ_blkni7hFj-3KPK3MSATlT_Q1XxZLNDeB0Yy2C3U6vIpgzPianfsTz7ILTY
Message-ID: <CA+EHjTzudrep2hEno4RPwh8H88txiVYFoU7AyJYVWG9SFSk87Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
>
> This is a follow-up to the original series [1] (and fixes [2][3])
> with a bunch of bug-fixes and improvements. At least one patch has
> already been posted, but I thought I might repost it as part of a
> series, since I accumulated more stuff:

I'd like to test this series as well. Do you have it applied in one of
your branches at
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
, or which commit is it based on?

Thanks,
/fuad

> - The first patch addresses Mark's observation that the no-vgic-v3
>   test has been broken once more. At some point, we'll have to retire
>   that functionality, because even if we keep fixing the SR handling,
>   nobody tests the actual interrupt state exposure to userspace, which
>   I'm pretty sure has badly been broken for at least 5 years.
>
> - The second one addresses a report from Fuad that on QEMU,
>   ICH_HCR_EL2.TDIR traps ICC_DIR_EL1 on top of ICV_DIR_EL1, leading to
>   the host exploding on deactivating an interrupt. This behaviour is
>   allowed by the spec, so make sure we clear all trap bits
>
> - Running vgic_irq in an L1 guest (the test being an L2) results in a
>   MI storm on the host, as the state synchronisation is done at the
>   wrong place, much like it was on the non-NV path before it was
>   reworked. Apply the same methods to the NV code, and enjoy much
>   better MI emulation, now tested all the way into an L3.
>
> - Nuke a small leftover from previous rework.
>
> - Force a read-back of ICH_MISR_EL2 when disabling the vgic, so that
>   the trap prevents too many spurious MIs in an L1 guest, as the write
>   to ICH_HCR_EL2 does exactly nothing on its own when running under
>   FEAT_NV2.
>
> Oliver: this is starting to be a large series of fixes on top of the
> existing series, plus the two patches you have already added. I'd be
> happy to respin a full v4 with the fixes squashed into their original
> patches. On the other hand, if you want to see the history in its full
> glory, that also works for me.
>
> [1] https://msgid.link/20251109171619.1507205-1-maz@kernel.org
> [2] https://msgid.link/20251113172524.2795158-1-maz@kernel.org
> [3] https://lore.kernel.org/kvmarm/86frahu21h.wl-maz@kernel.org
>
> Marc Zyngier (5):
>   KVM: arm64: GICv3: Don't advertise ICH_HCR_EL2.En==1 when no vgic is
>     configured
>   KVM: arm64: GICv3: Completely disable trapping on vcpu exit
>   KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early for better MI
>     emulation
>   KVM: arm64: GICv3: Remove vgic_hcr workaround handling leftovers
>   KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
>
>  arch/arm64/include/asm/kvm_hyp.h     |  1 +
>  arch/arm64/kvm/hyp/vgic-v3-sr.c      | 11 +++-
>  arch/arm64/kvm/vgic/vgic-v3-nested.c | 78 ++++++++++++++++------------
>  arch/arm64/kvm/vgic/vgic-v3.c        |  3 ++
>  arch/arm64/kvm/vgic/vgic.c           |  6 ++-
>  arch/arm64/kvm/vgic/vgic.h           |  1 +
>  6 files changed, 62 insertions(+), 38 deletions(-)
>
> --
> 2.47.3
>
>
