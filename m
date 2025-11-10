Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36611448E3
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782337; cv=none; b=lEziiA7O4feNxN+Hpy4VI+GPmENh3m9+RbHYTxCLKdQ0sVtz6Qgg93PACdB+DjAjtLEWLfwAOOoQi2t1Twnaz/h70oCjS2c7QLIYzA07I+PIYfX6+ZFJ4Dtj5griZRk+9cVgXO2l8/AKYdTRQQxK630PkgUqZl3Pbyh1sEShf7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782337; c=relaxed/simple;
	bh=etcwb9wYCbUJ8VuvJlSiYJOfdn5DYspnlP9RdmZ2sWM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gE/3AB1ObURtRIE3xmTFNy2uQBNH2kEZ+dH1SzY6WGlfPGqO5/TB4WwTj3YxO0kHILebrPeQoeCfLcH3fI0sp3ODZyB3XDWeZDD+qtfWVULOJetmtfp03jNCW+tdrtd0OAg9W0qRaXhIk5fboy8Sq7VaQs9w7B+LHR3pYvCmxLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gh4k0c56; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gh4k0c56"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429c93a28ebso2311743f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782334; x=1763387134; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qzpqv5ajxbqxabD1jydfXotwMWgcKwPTq7CgnH0DZ4Q=;
        b=gh4k0c56ySUYzspB3I9UJlKb+PnfH19Csn6SNofaXAd/JNMKC1ONAlgGgvr2f/zvTh
         XZW3O8stryIqiz748DIvSoVlEqhre7locucy+jEgd8tsu4HbaLYNvf5eXck5F1cIU5aw
         kMNVhMFp4uhdNVstOgz1fnPgj2CnGKSy3shMpL/SiysO3OCmqhTEkuv9S9XSffCanysg
         wdZ4KBVC01UR5QqoZRAq2smkK50ogpPETPyFL2/3648amg+S9bMAmfeu+23Kox8wcCsl
         CnVqd9TjuF/gscU1/MkJnQuhuG6l+uRV1v+AAgNFqIYiN6gBEFt53L305n2MOckU3eGt
         bNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782334; x=1763387134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qzpqv5ajxbqxabD1jydfXotwMWgcKwPTq7CgnH0DZ4Q=;
        b=TsSZSKHBfxUHqQcIVJ/1btPWuw+Jbm9UXgnFbfT1Vo2ETQCKw3vgxeL2ANUCFijLo7
         HOxeAUbMbvfKKr4yxNYwRjRw/BRpVYv+e78RZGt69LAtQfpKfc3yaypJhBzqtNn1hz13
         KIJr6ZhOpKdpujcsyuSiEsCG1CqwUM3csA90jF/7gXuGbzmBV8HxyG5lLTn/Rc6iLfcd
         iaLItJY76IXc65VAr74f0fUIbIcclb1OVSbf5zee61xubNy7omSCjS/OR6oCsEck13Pd
         ykO/Lg/IaazxAVMpi2c1SXQ3DlDFw4boSRgaR7jJRUoQJx3V+QS+mYM9vVuQP6mqPOz6
         8yaA==
X-Gm-Message-State: AOJu0YwZZUAmwqIviMoKkywM31XaI3TtnxjlOQMv47cGxL7YKYQmwvgh
	G91O9fU5styXN1cCerKRwqb/dJhWUeGN9aTM6OA7XBjzJP6x39ZQxvixD3iVEu1YTlsm0j/wOEl
	6PKodV9zsDTyq+bDBQNsbClzud8lJ0vi4damEYTQOOlR6tYHZ3MJ8xts5k/Zj+ssyVOTfe6Hx/I
	7nGcQm4aqqRiMKMgHsFnjORoLWRu5qA7I=
X-Google-Smtp-Source: AGHT+IFXypgY1V9bfoxm4HDW9/b5rxBK9APolSwH/TBkmLsNgB/D1VFW8wsaUqSkXIyZxf2Xvb+MQ1m1cg==
X-Received: from wrnu4.prod.google.com ([2002:adf:eb44:0:b0:429:cab7:2300])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2910:b0:429:dde3:6576
 with SMTP id ffacd0b85a97d-42b2dc2fca4mr6437305f8f.16.1762782333846; Mon, 10
 Nov 2025 05:45:33 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:25 +0000
In-Reply-To: <20251110134525.3768197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-9-tabba@google.com>
Subject: [PATCH v3 8/8] KVM: arm64: Prevent host from managing timer offsets
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

For protected VMs, the guest's timer offset state must not be controlled
by the host and must always run with a virtual counter offset of 0. The
existing timer logic allowed the host to set and manage the timer
counter offsets for protected VMs in certain cases.

Disable all host-side management of timer offsets for protected VMs by
adding checks in the relevant code paths.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arch_timer.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3f675875abea..f5407301c8f9 100644
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
+		return -EINVAL;
+
 	mutex_lock(&kvm->lock);
 
 	if (!kvm_trylock_all_vcpus(kvm)) {
-- 
2.51.2.1041.gc1ab5b90ca-goog

