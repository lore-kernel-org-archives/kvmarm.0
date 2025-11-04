Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1B02ECEAC
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261157; cv=none; b=mENWc8Zcpr04JEENv+sq+l59u+Vb2ZK+CT2WB3g1BZ+JNTLqM+HSAzH0Bnx3oBXGKVuRfoYn6e+3U6fzXs21B5rGFSeirvaCevGBhDhm5B/iIiWonpL2f6s0syRnLwOX3IgaRZRh08z7l87vEF+fnLAQpo6epBuU2450O8edUU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261157; c=relaxed/simple;
	bh=eGLQyLWK5yhJv32b2I7Q4XrUgLWRfbQk6DCXGzy2uZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jcxxml3S5Dd2dmm++RIvqN0b3NIN1WN11niOsT+HfMrIi458cQHODRD7Vt0FrQxnGLlkF3oxkeaYhtYQz3JAQSp9h+eAoZYqC/7A5q762DBrHKGLX3Q1WnK03gcisi24s4yJcwDY1/jBFqxrDzqliuHQ2yD4Ij+C6NNWaGeilR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4hDi8MPa; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4hDi8MPa"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477563e531cso6227665e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261154; x=1762865954; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Xik15WmAoHNbrZxUtrbj+k4Ee3EdsKPCteYm+EiLok=;
        b=4hDi8MPaT/PHLPavdRpDBYiP25Bu4vBKttqJHpGTdZABQ26YQex1DX0mdp+NdcZMM1
         0cyQjR89OOo8J5wsSmWQooHmBvHNuI9XJFtgGO92lKiPnAlmY6ox7azeJg4Ur+xlRT+d
         OMs7lHot5D/SC0WLrKpfvC6kW0ygMXCp4xLpjLrl8/WYY+sdG8WcOquN5wH/hJ0jU3Tz
         eEAzPKyYnAtkg87N0iDKG2O7bmQeGo4C9gzvXpWXqEQVGOekXH1zBcGjpmHeAufctUn4
         WeCsIZFSQe6g4zOUQGQKtb/fU0tzMnATp3S7ZIn4+lJBRJ2Z2ueAHEGjCV7DBEaqoyhO
         KNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261154; x=1762865954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Xik15WmAoHNbrZxUtrbj+k4Ee3EdsKPCteYm+EiLok=;
        b=NXIe5uEjH5M1q6JCdpErvVTw4rRxkGsThNd8xfwiHDFQavtBj4bNDVkah2cBqeBJuw
         kdY2vVgE3InDMzR9t0fN5VyvZ/n67zyw1sF4rpwRjpNdezh3MN23C7xyRDZ+cpOxl/V/
         haVXwPgxHbbF2ibI7kbF3VjwiCUxiYcAW1AS9mIMH7/67AM612hpWBV3UOUsq5IZ2gMu
         HvpBykFDKjzoqM9Bv88d6lQTAVNBuY3esmsomziNqBgXs58CKcsYDiWGdnXewzVtASL4
         BAnGqBImjoIAWF8zYdSdc+i6iVFjg+Hs0DaPUTcL2oLFEQAf6AT3jyUHQUqR5sW5tYTl
         41Cg==
X-Gm-Message-State: AOJu0Yzsf3cvw3CA2bTK/JrRXfGAxU+An5NEcu7PHh3Ucqb2xywSQPaE
	509NrR9G+rdsGRAlTWwOnT5XWCTSJGUZDS0AX1e2yv2h6MPFLKcNX5iqE0rxmCMty3YG454u2Pn
	rsH3POIsKBmoA8P06pNZPl9JSPQSFuur3Ssx5Elego/iLmNhVie17ZaHxi1qHKjjvhSm0CwHZ0J
	W3kXYqOZZ9amWgEGa5qBnrx8MHn3BwUoo=
X-Google-Smtp-Source: AGHT+IHlL/KyIyvJlAW6DKZbZabOz+McTPMSW0dgQJQD446yDCbFkkDQ67a8de15zsGEFor4k3yG3Qs0NA==
X-Received: from wmco10.prod.google.com ([2002:a05:600c:a30a:b0:477:cf9:f4a3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b67:b0:45d:f81d:eae7
 with SMTP id 5b1f17b1804b1-4773089c98cmr166646825e9.28.1762261153921; Tue, 04
 Nov 2025 04:59:13 -0800 (PST)
Date: Tue,  4 Nov 2025 12:59:05 +0000
In-Reply-To: <20251104125906.1919426-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-8-tabba@google.com>
Subject: [PATCH v1 7/8] KVM: arm64: Prevent host from managing timer offsets
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
2.51.2.997.g839fc31de9-goog

