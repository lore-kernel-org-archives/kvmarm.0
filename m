Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AED14F68C8
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896412; cv=none; b=DwrWbm1LzRHLMGpQoUaLwPmNkT0VN2nR/4ZPoJKE6E+j/mFtxuVHNoEYM/86pQoU8Cbzlno3IXP4u8dW04A75dibg1rfMXpzUFaEfTWNDK2g4eQ+sI8SkJs2OIFVioIShMcvEurf5toBsjhpne346Kb7b2R0uIuVJgA2iwMLprc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896412; c=relaxed/simple;
	bh=LYUbr06nCzkun3NGQIdKMFxFK4xBcbT7RiA9aRgNq6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fpwCRe4xZQlqXxetS0uSYxF4haDXAKd+MphbeUci/US9ZOd4Eks4Kaac6nkYhl85SFXyvl1a3u1p1PsGPVlfO0UAJb1jkAKXtiKE4j+ZkK/YheWt6MhnObv3jX/coTYHOuWrcyXYBEZzaruXvuF6o1aDrjgUpsm45rT/ZY5dg/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rK4z1QVw; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rK4z1QVw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LYUbr06nCzkun3NGQIdKMFxFK4xBcbT7RiA9aRgNq6I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791896407; v=1; x=1792501207;
 b=rK4z1QVwmU22rJdicoiauKEctVF/eNP7TCieRr5ehcSzvYwyYc7O0hxvNnm4HuqkQI0Mf9VR
 1gviz4Hn6LQbEqpZIHrqkZH+x+JZ6TMu07GbUFatkqIwWCrI5rLji5NGOlXveZCeLgfSBDtWoJa
 qy0IM7yofj6mugJz8fC8J7uQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f6d722294c551246;
	Tue, 13 Oct 2026 13:00:06 +0000
X-Mizu-Trace-ID: f6d722294c551246
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5ba40832934so17964e87.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 06:00:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwgzAwVdHYPWpeW4r8PpN+Bm+7n/E6PNc9YxW+W+jbSvPTIEp+/wbXZVPosT7VUQBzcYh7T32s=@lists.linux.dev
X-Gm-Message-State: AFq9FYK1yqu3eHIWvTK1qsfous7zB56DVVwl6l5JGvyXv6UrTGhAgHd9
	kygZlR+njdwHdbm5rrvVG34yTggVqRTDYur5xuAaqZyJCLy4oq8iTqBcQDphIpwCPXvfWlP1RMm
	yYAI9hFGXTJbJ5d2YRSn93vM/gXm1NNnJY1JlgP+K
X-Received: by 2002:a05:6512:1284:b0:5b8:c230:1241 with SMTP id
 2adb3069b0e04-5bcea5f77eamr325892e87.10.1791896400858; Tue, 13 Oct 2026
 06:00:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261013081646.933312-1-fuad.tabba@linux.dev> <as3_NKT20MNdqaJR@kernel.org>
 <86wlrl2a2f.wl-maz@kernel.org> <CA+EHjTztZpFrmuz9pK+01BsDxHnzpEwUMt6E3nUrgk4NNTsKYQ@mail.gmail.com>
 <86v77526me.wl-maz@kernel.org>
In-Reply-To: <86v77526me.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 13 Oct 2026 13:59:22 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyZA6VL6EjhkB2bf9fDk4fUWpc=iXsu+sR1B+_YbR-nOQ@mail.gmail.com>
X-Gm-Features: AclHuK91_oNrs_00jtZZScBUrir_3CsFdStuVvifnhav_N77zBitsUsBdY8t0FU
Message-ID: <CA+EHjTyZA6VL6EjhkB2bf9fDk4fUWpc=iXsu+sR1B+_YbR-nOQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: vgic-its: Fix LPI double mapping and DISCARD
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 13 Oct 2026 12:16:09 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > A vCPU on its way into the guest does the same: it loads its LRs in
> > kvm_vgic_flush_hwstate() while it's still OUTSIDE_GUEST_MODE, so
> > kvm_arm_halt_guest() doesn't wait for it. With the delay after the
> > flush instead, on v2 plus your 1/7 and 2/7 [2] and both changes from
> > your reply to 1/7 [3], the guest takes it in 9 of 20 runs.
>
> Does this mean we still need OUTSIDE_GUEST_MODE to be a store-release
> past the point where we resync the state?

Not for the 9 of 20: that run already had the release. The halt reads
the OUTSIDE_GUEST_MODE the vCPU published at its previous exit, so it
doesn't wait for the early exit that folds the LPI back.

We do still need it for the window after the exit: with the delay
there and the same patches applied, the guest takes it in none of 20
runs, against 13 of 20 on v2.

> > Once DISCARD waits for irq->on_lr to clear before clearing
> > pending_latch, the guest takes it in none of 20 runs in either case.
> > I'll add that to v3, unless the single-vcpu stunning already waits for
> > it.
>
> Polling for on_lr feels very dodgy, and I'd like to avoid this. If the
> OUTSIDE_GUEST release addresses it, I'd rather do that.

I'd rather avoid the polling too, but the release alone doesn't close
this one. The vCPU would also need to store IN_GUEST_MODE and check
its requests before kvm_vgic_flush_hwstate(), so that it never loads
its LRs while it's OUTSIDE_GUEST_MODE. The existing check after the
flush would still be needed, for the KVM_REQ_GUEST_HYP_IRQ_PENDING
request kvm_vgic_flush_hwstate() makes in a nested state. With that
and the release, the guest takes it in none of 20 runs with the delay
after the flush, and herd7 finds no LKMM execution that leaves it
pending.

The IN_GUEST_MODE change would also cover vgic_mmio_change_active(),
which depends on the same halt (the comment above
vgic_access_active_prepare()). Would you be OK folding it into your
series, on top of your OUTSIDE_GUEST_MODE changes? Patch 2 then
wouldn't need the on_lr wait.

Cheers,
/fuad
