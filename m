Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D554CC63A
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 13:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790775272; cv=none; b=i96ztgT+5ogY5HNCz3rkNMh099gae8OUTOhah5dNaf/tLj3Dan7pwFBsC5T0ZtBbeFfIpHPt8Xtf+XcX4bTn6kHliDmL2hswKi0I4+RKwNGpv060J0zj7oPku+tgQg6tZREiwmOCOFIPjo4FoLrzPKpHTb3cYTptu8rBmNloLQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790775272; c=relaxed/simple;
	bh=dN7iIkrg2M+jf5Tj2Vy0WrS/Nd7WiyAkyWWbyMwdKQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ftiQAoauceFf2NAYIei1mEJ1fBtfa0MyKckfRv6GyEH7lm75qEde5mCqBwQ/WkZiZgEcihOHXEpqGatBYRJpc57pqI4Cqd255Vb3ZdONtONl8s5dvh2eWnzwZIHU3WUPOytuQLYYShJWbkQXkGjGEfmSA2fDEcMCeI6LDhZ4FyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Shgzquwo; arc=none smtp.client-ip=95.215.58.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Shgzquwo"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dN7iIkrg2M+jf5Tj2Vy0WrS/Nd7WiyAkyWWbyMwdKQo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790775260; v=1; x=1791380060;
 b=Shgzquwokc5/rGOxQdywbmDJeloIc7EbuWEKKs3/3LIyfoQCi5LC3dgoLP6MYq5m2aEpUk9B
 qirRmomOTKqxGoZOuVc8KNxbzVY8cu+ndyumXh13IHh3EiHN3st+IWkiZoLVxm6oANyELUnKzTk
 sjlUwtaEBVO4tJ2loao2AHbY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1454421c7059c8a3;
	Wed, 30 Sep 2026 13:34:20 +0000
X-Mizu-Trace-ID: 1454421c7059c8a3
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5ba3d1ea20cso1132e87.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 06:34:16 -0700 (PDT)
X-Gm-Message-State: AFq9FYIUy57YeVTEKYFbfs0PXUgnVSGfKzDApVbnhXl9j0NWP6j6isFc
	bdQ9KOoNYZoqbyqBWZc1gUSjbtT/+qKpBNTc+FjV4cZqKjfqB85lB3rqFgVktuPjktJmv+vSDdS
	E1FB5N+zwAArO05ovN2v6wqYvwuXs5fUe5CjgQzKr
X-Received: by 2002:a05:6512:12d1:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5ba3f6d7e5fmr77593e87.0.1790775255802; Wed, 30 Sep 2026
 06:34:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929212925.31775-1-oupton@kernel.org> <20260929212925.31775-2-oupton@kernel.org>
In-Reply-To: <20260929212925.31775-2-oupton@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 30 Sep 2026 14:33:39 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzjnJGXNZFLFKEv0QTCPA=-+zbiqArLPn0DnekzTLgVSA@mail.gmail.com>
X-Gm-Features: AclHuK9OdjQrdOGNR-0ecHL1vfChY5nIiN5ci0GNgWKucq05y1exXxSSPTfBarM
Message-ID: <CA+EHjTzjnJGXNZFLFKEv0QTCPA=-+zbiqArLPn0DnekzTLgVSA@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Add helpers to halt a vCPU
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Steffen Eiden <seiden@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 29 Sep 2026 22:29:22 +0100, Oliver Upton <oupton@kernel.org> wrote:
[...]
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
> +void kvm_pause_vcpu(struct kvm_vcpu *vcpu)
> +{
> +        atomic_inc(&vcpu->arch.pause);
> +        kvm_make_request_and_kick(KVM_REQ_SLEEP, vcpu);
> +}

Could this wait like kvm_arm_halt_guest() does? The halt sends an IPI
to any vCPU that isn't OUTSIDE_GUEST_MODE, but this only sends one if
its own cmpxchg takes the vCPU out of IN_GUEST_MODE. After an earlier
kick the vCPU can still have its LRs loaded when this returns. A
scratch test moving a pending LPI back and forth with MOVI hits the
WARN_ON(irq->on_lr) in vgic_v3_compute_lr(), and doesn't once this
waits.

Cheers,
/fuad
