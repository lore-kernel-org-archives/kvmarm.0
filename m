Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF4E47ECC7
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 10:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791888651; cv=none; b=uJlF+rZuH15jx5ftGzra9urNFc6Ar3Tv+yAyi1QGKa784SHFM2CqWubzNVTaqvQAoX7yE0g4pW7aHRmGjENOlAka/PEZXBUS6m+5YOuvRf5xV2lsihkGwoIpR/TkApcimnPaDGCJZKzVv0saR9w46YUf9o4lRdZ2qV3xN1Gat90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791888651; c=relaxed/simple;
	bh=KVAzhVgNrvfGhJXuSFvrFDmK336xmECT5jayATxTm8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PkJDOhm3LCQWFj33/aVIHIfx/5iE57ZvWdFOlMfeXWl+ACx7uWAo8foekyMVy5/IzzZyHkkgB4oNEZCBlgDulqMMGIf57SMgj0nxHyOlkehJGWD4y9/hmU9ZHR3wUJ5wWVfzraYFETzqBCnlt5Y/H1jinkijFoHTeNOM4QbpjHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b1FoPo48; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b1FoPo48"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=KVAzhVgNrvfGhJXuSFvrFDmK336xmECT5jayATxTm8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791888647; v=1; x=1792493447;
 b=b1FoPo484jsbUcknLORxshs+NjUtGDlWFA0+BsB/lqir7EsKSbWvjb/tzPPS+KeIshCYthM5
 vAa7QxmsKETVmB+9c7FGwPMzlOyL6B508C/gQOYfaCCqy7L6s+Kdgqo5IItMXFsKCP7NYXMNCFj
 CN8OWGeiw/yBKZ9JEsHiNAqc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 83f9fc653666faac;
	Tue, 13 Oct 2026 10:50:47 +0000
X-Mizu-Trace-ID: 83f9fc653666faac
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba40832934so16925e87.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 03:50:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwT5ZWOOI00MUcv1F0AYxeDpnt3ZYe4xWwvj7Jw+vVgSX3id+Nw6EqIB1ltdRvjtVH78JCN95I=@lists.linux.dev
X-Gm-Message-State: AFq9FYLcyxZ80eE8PXC7WS03a+WH8eARfX0LZom3zc3uUzDpUkORqXoo
	p2H7Wf35IEzHtTGHQucXL1upyLuaDNYSGC4vYeTZ2rm1lcquRVpTH+xX4/qvsummJgMF67EmJFY
	FU9PTXbpE1PmsZqLEj0QoFMRLvg7N582x5g2Iw9Ne
X-Received: by 2002:a05:6512:1284:b0:5b8:c230:1241 with SMTP id
 2adb3069b0e04-5bcea5f77eamr307791e87.10.1791888646329; Tue, 13 Oct 2026
 03:50:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261013081646.933312-1-fuad.tabba@linux.dev> <as3_NKT20MNdqaJR@kernel.org>
 <86wlrl2a2f.wl-maz@kernel.org>
In-Reply-To: <86wlrl2a2f.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 13 Oct 2026 11:50:09 +0100
X-Gmail-Original-Message-ID: <CA+EHjTztZpFrmuz9pK+01BsDxHnzpEwUMt6E3nUrgk4NNTsKYQ@mail.gmail.com>
X-Gm-Features: AclHuK_kCCq3-9Q2tIHYoGWtf99ZLB81HNWPaAdr5x53TtL1SwcCZkCDuzzJ-Oc
Message-ID: <CA+EHjTztZpFrmuz9pK+01BsDxHnzpEwUMt6E3nUrgk4NNTsKYQ@mail.gmail.com>
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

On Tue, 13 Oct 2026 11:01:44 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Yeah, I now have a series that has the counting pause, your single
> vcpu pause (fixed to DTRT), and the LPI disabling fix. Patch #2 of
> this series can probably make use of the single-vcpu stunning.

I'll rebase the series on that once it's out, with patch 2 using the
single-vcpu stunning.

> As for the OUTSIDE_GUEST discussion, I've had a long discussion with
> Will where we reversed engineered the synchronisation requirements,
> and concluded that there was nothing to fix on that front (the logic
> is incredibly subtle and counter-intuitive, but overall sound). This
> patch is therefore dropped.

The first [High] issue Sashiko found on patch 2 [1] holds for DISCARD,
because the fold writes back the pending_latch that DISCARD clears.
With a 2ms delay after the exit to widen the window, and the DISCARD
sent at a varying time, the guest in my DISCARD reproducer takes the
discarded LPI in 13 of 20 runs on v2.

A vCPU on its way into the guest does the same: it loads its LRs in
kvm_vgic_flush_hwstate() while it's still OUTSIDE_GUEST_MODE, so
kvm_arm_halt_guest() doesn't wait for it. With the delay after the
flush instead, on v2 plus your 1/7 and 2/7 [2] and both changes from
your reply to 1/7 [3], the guest takes it in 9 of 20 runs.

Once DISCARD waits for irq->on_lr to clear before clearing
pending_latch, the guest takes it in none of 20 runs in either case.
I'll add that to v3, unless the single-vcpu stunning already waits for
it.

Cheers,
/fuad

[1] https://lore.kernel.org/r/sashiko-outbox-169278@kernel.org
[2] https://lore.kernel.org/r/20260929093548.3598547-1-maz@kernel.org
[3] https://lore.kernel.org/r/86a4p0403b.wl-maz@kernel.org
