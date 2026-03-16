Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA793D3305
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682541; cv=none; b=m+yflS2SxdYmLtnOPOxfFMOYFdgObsrCrfhCQApHkZ5L1SCgDYDL25s92k3W5HbfO15HibYf6/R8JJF7ckWilh3cDP72gCqfx+ot5mwnee8JqKrXGRC2rWP6xXl+CW8MoWBOa4ApE6sXnBPqkiQsIdGzn+A3aFo1lgxs533iOUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682541; c=relaxed/simple;
	bh=yNUIHO2NMw8B5EFVSRGekqdFjiqxXTiNYvgnQBnltj4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rcg9VmU7IdnpdWc9WCES3oEOJyQnXb9PNxdp7lfApGjueq6pq0bBhkofvAaxKSjREMjJi5g5Ba1Qxz89FMk2XshypUBnAeQswekUUmSO/SnUgZZCdBgNs8P5R8v25s6LLJ79n/K1Vh+uyzdRi9H9sJPoxOW8z5dYyGgVOPgpb3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cJL7sqbl; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cJL7sqbl"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485350666bfso39198275e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682537; x=1774287337; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cfzLIsn2Q20JghpCHqLQPcreo5Zv/pRgRX5lZKoPSE8=;
        b=cJL7sqblowVMXJVe5tHDgxY5uccMH+tzcdN/LEZ07p7ZRASByn+UgbHa9XXQlUJlRm
         HoLDOo0v2hEaeCbl4n/5lcfPPsF15KI8SDfzBAIkffjdLckNTvWlLRlQJ8hrELhLQ1/x
         A2HqFTy6J3MwaJ+16ustVjTsuAC/hZC//SWfdcSE7jKbccH9SMfrNVa74e8qw862OKqi
         EHPaf2h9HiFfxZAwdDGCk4M1ACg5leap0b3Aou/XUJO6DOGk7RxVaRz7x3ljPrqdcPba
         bGswZcu/e0XqeEyeth1bkjgB1GEkvNKZBvn0CZdpI5KTIhBZfUBVBg6GZEHFWh0y3Ka5
         25eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682537; x=1774287337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cfzLIsn2Q20JghpCHqLQPcreo5Zv/pRgRX5lZKoPSE8=;
        b=fFtANtvCvR7ckxYGPaTja0VzrESxGR7R23QTHbahCsL/quWI1Pqspp3G4G7r+yapIU
         xtEgmkjlHxjYtzTT4ReBZy/+Hk9rPvu3P6+RxJx5ARUBpOp2kU/2Ysk252OOeJR3AGIK
         SUVXdJ3epvpWqyRNHMda7eHRw/SG5pa2pryqGZ5TZH6ClPRQaKhbnB45VeCrCYaKZQgH
         YGRWTtfwwwMTakVwCfrNrrjM9h9a2gE6r8JMd6y8VNAJDtgUUblQXRXFe3uOO5PC9wfd
         Tw+BKC/VLFd25542EDkTAK7CQF9SolYQIN9KxTUaAogdpr9fWic+akOr4F2BZSLsJ+Jp
         VFYw==
X-Forwarded-Encrypted: i=1; AJvYcCX76xhnOBjHCiYSYMF8galPK3RwQI/e73/l0b1vego7HTMQA2ljned3lj18bX+VeRIONJyrLQ8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGyckdcjf6wj8lQO4izbeOaYl0+pZXgLbR9cJ3O7haTZqSEiCG
	FtZ5aqEqQ56NARQv04lFVeo/JLKLui2RWuuhDEpFtzyrdh0L/6fmdWdHXdsHUOd+VS7medyFSz3
	AwQ==
X-Received: from wmbh3.prod.google.com ([2002:a05:600c:a103:b0:485:343f:9fb3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f54:b0:485:49c5:8eb7
 with SMTP id 5b1f17b1804b1-485566fd0eamr230387435e9.22.1773682537346; Mon, 16
 Mar 2026 10:35:37 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:29 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-8-456875a2c6db@google.com>
Subject: [PATCH 08/10] KVM: arm64: Use guard(spinlock) in psci.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate manual spin_lock() and spin_unlock() calls managing
the vcpu->arch.mp_state_lock to use the guard(spinlock) macro.

This eliminates manual unlock calls on return paths and simplifies
error handling during PSCI calls by replacing unlock goto labels
with direct returns.

Change-Id: Iaf72da18b18aaec8edff91bc30379bed9dd04b2b
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/psci.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0e..04801f8b596a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -62,7 +62,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct vcpu_reset_state *reset_state;
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
-	int ret = PSCI_RET_SUCCESS;
 	unsigned long cpu_id;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
@@ -78,14 +77,13 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 
-	spin_lock(&vcpu->arch.mp_state_lock);
+	guard(spinlock)(&vcpu->arch.mp_state_lock);
+
 	if (!kvm_arm_vcpu_stopped(vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
-			ret = PSCI_RET_ALREADY_ON;
+			return PSCI_RET_ALREADY_ON;
 		else
-			ret = PSCI_RET_INVALID_PARAMS;
-
-		goto out_unlock;
+			return PSCI_RET_INVALID_PARAMS;
 	}
 
 	reset_state = &vcpu->arch.reset_state;
@@ -113,9 +111,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 	kvm_vcpu_wake_up(vcpu);
 
-out_unlock:
-	spin_unlock(&vcpu->arch.mp_state_lock);
-	return ret;
+	return PSCI_RET_SUCCESS;
 }
 
 static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
@@ -176,9 +172,8 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 	 * re-initialized.
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		spin_lock(&tmp->arch.mp_state_lock);
-		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
-		spin_unlock(&tmp->arch.mp_state_lock);
+		scoped_guard(spinlock, &tmp->arch.mp_state_lock)
+			WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
 	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 

-- 
2.53.0.851.ga537e3e6e9-goog

