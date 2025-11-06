Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AF23321CF
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 14:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762440265; cv=none; b=b+09z2IEqVGocNFNYj2FRD47CsGbEgrBrZvEGdkaDKGbGmzBGfUhr9EFlcWTDC7/zxC8NyrNr38hIPQb5qc/xIxqg/H/ltkZmbJfmfKgEIj9UbBa8NvYQUV2+6oo3jNy8g9lm7FrfOybFCmySx0sJQET6AO8Q9LtfNF1RCV1FdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762440265; c=relaxed/simple;
	bh=pfQLT99OMsoxBwzf757ZeK07Mh1n45aKNQ6DeEpM2GE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ahjKGgX7QJrgg7BPvZcCaeuftclMxzSFlwU/nSLHNPzTjFJ+YSncJhKN+SpHOQ9fNaShZPIxMW7qqY8zFDRWwgU9TohoiJ8YoijgMOYCIj5Q3ToQQDtmwgqrECfUAC8LafHV6wEzVKmOOBos/Ex8n230qdinBjjQ/NobAJehiWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pIgZZetF; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pIgZZetF"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4776079ada3so9306885e9.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 06:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762440262; x=1763045062; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q3PiPDAEsM185e5ZyPmBex5Eq2aGfxJgPBXDqPJKqPg=;
        b=pIgZZetFUIMs3XYLXCmjBSJpM7nrdc9jwTcSC3UqA5cgXNUSFZfdaLUdKM8VPTyQpi
         l9UN+CHYTQA+mFrOMv0yb2ihRg9PFNN7wpEfzW5zNt8WXw6v1gdWNb18VNMD8/siXA9D
         KLzhe1hQtE4/QA6XwWaikHtVScIx4MqxbJdHPdHp1Ma8NTgz08oKnvcvvv6FOt4sXsxf
         7u4+/U0/rx7nZDrUd3L2PipDzGBVkhegBMP2n6uZu1u1HSmLIoSfpUXx6+PxhK0tIPr2
         W/kx9XLwMV4YRrnb/KnsE455mgFSn+D1Acp24cKX6NkyTU8hC3j+kHlUk0s/TdI8nPwp
         ZrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440262; x=1763045062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3PiPDAEsM185e5ZyPmBex5Eq2aGfxJgPBXDqPJKqPg=;
        b=YiOio9GXFC/PAz+bHgbl6zFMlnoxIpRhE1qmqGgqi5Nj+PIkm66dLfufJVexBWVkrg
         mYeZXk+GcRaQORnxdhvvYGpabZYTMrijr1EMzUUOIoHdQw393XuIuhFsTfOuDL5lZ19D
         BPffP6djWu0v2jFznQky7VgjLz5KSpjq1buvydHh/GeakhVQJiSay2Rrrbm7xJeR25Dz
         /xK6SVkr9rfjahyVI+VRarMVyPZp0mDwGdF0aJ9WIG3pL1igreQx3ji3+KnDpTOgft2w
         /LjXk2BvI9zifPlDnLR7Onq2mKv6SaWx3CTiekVsF6+8ITN+ExiSv92EmniQBUNe/QkQ
         tG6Q==
X-Gm-Message-State: AOJu0YxGAf4fRynqsbPIsyVC5oBRXR4VVxgBhOYPW51rBxQAR07mBIR6
	IPdYBkwamDB7QF7Fq2sFZaGEvVo8JDLgnPyCIFGWcdGDJqZeMRfeG02KaMyQOLQdbm2pOmLeiBh
	Rrk3B3EnYw9TGO73yihFWWbmRBpuSUDyJlFpvRGuICZJX72rHnDsYDattpzJjM5l3mYY8lxZ/nl
	c81GUu89KvYGuUYYBYMpy8sh8uP4OYKYA=
X-Google-Smtp-Source: AGHT+IHQcO/yNTK0deG53SUFULs+OClplBrSmThrfSHa8qIXj6I07HYfFQyyo/MUKlZCP3ryzHv3F9D+4g==
X-Received: from wmbha8.prod.google.com ([2002:a05:600c:8608:b0:477:1ae3:73c7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6299:b0:477:559a:1ca7
 with SMTP id 5b1f17b1804b1-4775ce8e088mr59669125e9.39.1762440262376; Thu, 06
 Nov 2025 06:44:22 -0800 (PST)
Date: Thu,  6 Nov 2025 14:44:16 +0000
In-Reply-To: <20251106144418.2847443-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251106144418.2847443-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106144418.2847443-5-tabba@google.com>
Subject: [PATCH v2 4/5] KVM: arm64: Prevent host from managing timer offsets
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

For protected VMs, the guest's timer offset state is private and must
not be controlled by the host. Protected VMs must always run with a
virtual counter offset of 0.

The existing timer logic allowed the host to set and manage the timer
counter offsets (voffset and poffset) for protected VMs.

This patch disables all host-side management of timer offsets for
protected VMs by adding checks in the relevant code paths.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arch_timer.c | 18 +++++++++++++-----
 arch/arm64/kvm/sys_regs.c   |  6 ++++--
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3f675875abea..69f5631ebf84 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1056,10 +1056,14 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	ctxt->timer_id = timerid;
 
-	if (timerid == TIMER_VTIMER)
-		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
-	else
-		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
+	if (!kvm_vm_is_protected(vcpu->kvm)) {
+		if (timerid == TIMER_VTIMER)
+			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
+		else
+			ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
+	} else {
+		ctxt->offset.vm_offset = NULL;
+	}
 
 	hrtimer_setup(&ctxt->hrtimer, kvm_hrtimer_expire, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 
@@ -1083,7 +1087,8 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		timer_context_init(vcpu, i);
 
 	/* Synchronize offsets across timers of a VM if not already provided */
-	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
+	if (!vcpu_is_protected(vcpu) &&
+	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
 		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
 		timer_set_offset(vcpu_ptimer(vcpu), 0);
 	}
@@ -1687,6 +1692,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 	if (offset->reserved)
 		return -EINVAL;
 
+	if (kvm_vm_is_protected(kvm))
+		return -EBUSY;
+
 	mutex_lock(&kvm->lock);
 
 	if (!kvm_trylock_all_vcpus(kvm)) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e67eb39ddc11..3329a8f03436 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1606,11 +1606,13 @@ static int arch_timer_set_user(struct kvm_vcpu *vcpu,
 		val &= ~ARCH_TIMER_CTRL_IT_STAT;
 		break;
 	case SYS_CNTVCT_EL0:
-		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
+		if (!vcpu_is_protected(vcpu) &&
+		    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
 			timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read() - val);
 		return 0;
 	case SYS_CNTPCT_EL0:
-		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
+		if (!vcpu_is_protected(vcpu) &&
+		    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
 			timer_set_offset(vcpu_ptimer(vcpu), kvm_phys_timer_read() - val);
 		return 0;
 	}
-- 
2.51.2.1041.gc1ab5b90ca-goog

