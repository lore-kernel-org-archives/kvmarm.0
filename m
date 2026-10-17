Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C12C435537
	for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 07:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222846; cv=none; b=AipYcXOjDdcllTXgVOzicehzznkRL0ubJLkTM8hIHqayB4JypRGbLhxP52IGLoQXvz8U1yK1zVNIDm6DMspKZUeSvO1iOwBTU0HsQ712MaaTKdWMO6iG8S3qWWbOC20Oxdm1MbY653s1tQgJBwe/w9+0Hi+VoFoFERul4W1ZeWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222846; c=relaxed/simple;
	bh=Lrzxfa7i0XIQgY3L+j7KanmroAYbc+jLnsGPgXkNd8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SQQSvlAaMhO1s3EGvEdr2ZZlc9gpv2f6OTNMVjk79XFEL3kETmWpHnTeKvr5dCSLaflhyVmDdS/8AYXqejFy4B5HTqcn7Az11QN82JbRPdQ4DPMhq5GOK4NRfJ4cb3/GLuCYqNHBRIpiTv+pglpc5fUIcFHvXkQD9uDqV7glAdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FUvwDXac; arc=none smtp.client-ip=91.218.175.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FUvwDXac"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Lrzxfa7i0XIQgY3L+j7KanmroAYbc+jLnsGPgXkNd8Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792222841; v=1; x=1792827641;
 b=FUvwDXac1Igb/NI1hxXeYV0l96o8401glxiaFhEUZM72X8i0Ec26RIKgczoIFmXlHlkuxU07
 22h3tmdonIy9S8lxMbhgMcAqLOKcjXM/naDy/GZScis3QhU5z0Cmhmf6kW/y/ThryNrrHfikgYo
 QjRMjohkvpgvOACgQkTN5vvg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a470a9ff958b5a5d;
	Sat, 17 Oct 2026 07:40:26 +0000
X-Mizu-Trace-ID: a470a9ff958b5a5d
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: vgic-its: Remove the pending state of a discarded LPI
Date: Sat, 17 Oct 2026 08:40:21 +0100
Message-Id: <20261017074021.1948168-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <867bjh1w52.wl-maz@kernel.org>
References: <867bjh1w52.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Fri, 16 Oct 2026 16:51:37 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
[...]
> > @@ -829,13 +829,27 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
[...]
> > +                /*
> > +                 * A queued LPI can be pending in a running vCPU's list register,
> > +                 * which the exit path folds back: halt the guest before clearing.
> > +                 */
> > +                scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
> > +                        queued = irq->vcpu;
>
> Is this comment correct? This is only checking that the LPI is on the
> AP list of a vcpu, not that it is in the LRs.

The comment is correct but incomplete: it should say that only an LPI
on a vCPU's AP list can be in that vCPU's LRs, which is why the check
is enough.

> > +
> > +                if (queued)
> > +                        kvm_arm_halt_guest(kvm);
>
> And should we move this to kvm_pause_vcpu() instead of the big hammer,
> this still works because
>
> - we hold the ITS lock, so no MOVI can be issued on the same ITS
>
> - mapping of the same LPI is already prevented by the previous patch,
>   so no sneaky MOVI generated somewhere else can impact this LPI
>
> Do you agree?

Agreed, with one gap: a MOVI that completed before the DISCARD leaves
the LPI on the old vCPU's AP list until that vCPU's next exit. Pausing
irq->vcpu forces that exit, vgic_prune_ap_list() moves the LPI to the
new target and kicks it, and the target can load it into an LR before
pending_latch is cleared. Your two points keep target_vcpu stable, so
pausing the target as well closes that.

I forced the window with a delay between the pause and the clear: after
a MOVI and then a DISCARD, the new target takes the discarded LPI in
every run with only irq->vcpu paused, and doesn't take it in any run
with the target paused too.

[...]
> If you're OK with the above, I'll make the corresponding changes as I
> apply the patches.

Yes please, with the target paused as well.

Cheers,
/fuad
