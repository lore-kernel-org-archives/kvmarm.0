Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09DB4F6474
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776559; cv=none; b=pyzKLZ97oWVWtR5e9gWpikPUul+6dYVZp7a/H14s1NWRo6KrX0BUlTg48RXl1rEjj6/CZ/Jh3v9nms37mecHLEJg+1mHvhU1850/JMwU+3AMWrsJN0zF2rCFB1jK/WdlNxvoKB+7ZlUiJkgoiQN6jj1y76p/UNj51FM+bL2Qnhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776559; c=relaxed/simple;
	bh=a1XkbvNEwns+9Wq5T50SzTXn2W/BGh5evvGntcNl+/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AIO9NVkBd0f8LjsXPHV5I5X8BUXLacWoC9+hGy1dxFmLpbVZnhDFx9DQMVkUV4qe+9Susi7U3qsd/xsDPx2YfS8ywI2fjYgtbkLrGiADbdBCrle6xHC9c5uLQZ3IEYFXLIjgMzy6cY1IkvW9KLB7OhfEmQrN6Zr20QRtKTpcnAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XxOnm0BG; arc=none smtp.client-ip=95.215.58.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XxOnm0BG"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=a1XkbvNEwns+9Wq5T50SzTXn2W/BGh5evvGntcNl+/I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790776546; v=1; x=1791381346;
 b=XxOnm0BGxOqaN6bD3doSLHrpLJH+ui8Z/ICFddfvu+7ADFHLoIjVOzFqEjCFHom9KB6hCNNU
 p12hKaTsVgzEYW7yGV7YPOt2iCTqEaLRMHPDAiF+yzsJ4xVDfs6+cX5Gc/saQjJr9bgyhVXkmM1
 QWy5XKP8gjz+MvJu5th1Wnq0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d2b6eabb8104a9c1;
	Wed, 30 Sep 2026 13:55:46 +0000
X-Mizu-Trace-ID: d2b6eabb8104a9c1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba4065fa07so1262e87.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 06:55:41 -0700 (PDT)
X-Gm-Message-State: AFq9FYICk8JKzsnmydIs59OO3uGdS0qERq46tmcK/GaPX0GXtPWxcNXJ
	hbJmSlNJ46yiEq+kRK0O7UKw0kGIvVlpU55Kq+WOHs0YJEcB0V1X+Cbrv/JUuciRgJACkFOblgO
	H26XKBFyai3+sWY9fFq7u3bRS4ceO26Ys+3+/r0zW
X-Received: by 2002:a05:6512:3ba3:b0:5b8:caec:cc77 with SMTP id
 2adb3069b0e04-5ba3f6d7afdmr77410e87.7.1790776541012; Wed, 30 Sep 2026
 06:55:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929212925.31775-1-oupton@kernel.org> <20260929212925.31775-3-oupton@kernel.org>
In-Reply-To: <20260929212925.31775-3-oupton@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 30 Sep 2026 14:55:04 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxu=rQ1Wz8QpGpMsMyw0NGU35qw6J12ZH07XeCwae5e9Q@mail.gmail.com>
X-Gm-Features: AclHuK-C8OUJdsXPF9naZ2AKQodEwmN4Y8UPOLRsE5g9BIl-HkrjsBjdF9GI31k
Message-ID: <CA+EHjTxu=rQ1Wz8QpGpMsMyw0NGU35qw6J12ZH07XeCwae5e9Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: arm64: vgic: Move IRQ migrations out of vgic_prune_ap_list()
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Steffen Eiden <seiden@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 29 Sep 2026 22:29:23 +0100, Oliver Upton <oupton@kernel.org> wrote:
[...]
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
[...]
> +void __vgic_update_irq_affinity(struct kvm *kvm, struct vgic_irq *irq,
> +                                struct kvm_vcpu *old, struct kvm_vcpu *new,
> +                                u32 data)
[...]
> +        /* Fire! */
> +        kvm_pause_vcpu(tmp);
> +
> +        scoped_guard(raw_spinlock_irqsave, &tmp->arch.vgic_cpu.ap_list_lock) {
> +                scoped_guard(raw_spinlock, &irq->irq_lock) {
> +                        /*
> +                         * The IRQ could've been moved to another AP list after
> +                         * dropping the irq_lock. Make sure it's where we expect
> +                         * it to be, remove from the list and retain the implied
> +                         * reference until we queue it on the new vCPU.
> +                         */
> +                        if (irq->vcpu == tmp) {
> +                                list_del(&irq->ap_list);
> +                                irq->vcpu = NULL;
> +                                irq->target_vcpu = new;
> +                                if (vgic_is_v2(kvm))
> +                                        irq->targets = data;
> +                                else
> +                                        irq->mpidr = data;
> +                                pruned = true;
> +                        }

Could an active IRQ stay on its current vCPU until it's deactivated?
With irq->vcpu cleared, the oracle returns target_vcpu for it, so with
EOImode 0 the old vCPU's EOI finds no LR and the SPI stays active on
the new vCPU. A scratch test moving the IROUTER of an active edge SPI
loses it with this patch, but not on Marc's branch.

Could this also make sure the IRQ isn't still in the old vCPU's LRs? A
vCPU between the vgic flush and the IN_GUEST_MODE store is
OUTSIDE_GUEST_MODE, so even kvm_arm_halt_guest() wouldn't wait for it.

Cheers,
/fuad
