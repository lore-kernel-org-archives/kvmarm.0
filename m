Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C961038757D
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 22:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934558; cv=none; b=qvJJ0Kl0a62j4oo4tAnd0/8WL4cY6k1vetuHZUB0/FDk9vqk54qbMGENKkw/Dv3ngF7EawFFEBSkrv4Qhn1GMDcEWSJuPq9IoyRnO7DqhpLy5FB+5Y+BBiOp8GRT9aUmtvfM/lPPNtHTvSiu0il3710Z/1feMInJtPDmibHvJJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934558; c=relaxed/simple;
	bh=rDuwAeB4ha58gotrneg8EsaMOT+AwZ1dhESIVBbvmoQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QeIETYUwicw0H6VVw/YuPt2ECleYJ9nod3zwtJ4hThZa+e4yXzO+XqDsY94UdIVHCsvxTBaxoFPb1Oq1zU1nPPXcOdJjzrNP56fndDBil6oq5sAzFgH+rb4i/ikz43+4w6FXdAuTK+suLCSeSOnxdT07KpuPxNhXlQDcsIQYGEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=irWbr457; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="irWbr457"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8353df9bc7eso1951373b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 15:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934556; x=1778539356; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uWygzttyaDGZ8i1sz2PNqa3rZtIdDV4A7Q8dk96hn1w=;
        b=irWbr457DoL0+IaA3mVFPRner2nSVOWjSOtNq0BfJEDMv/8yKrfOVUqruROJULMO5T
         O8bTpkfzfzP1CH0dtl2J6ED7hrkui4sDbYVZrFQ3QXfoXyDTV4q/FpiZuCxm/L4MOdCE
         FcYfOOJHcWcXFAQDX/WqkVbSFl19dKYb9yjoSsZeCfX/XQLDcLmM2K0hkzSrY0nV3zsB
         gZiei9BnwMt0Gpj3yciY6C0UPJyYfWYUB5NfRse0mgkrql+yqnrF6IWhLHfR6YqPWZ5k
         ELEry3ijvFERYhDVwNyD1FVRnS1+cPeXTF4FRdRm15bj61KSOy0Arw1P1PSB7ySglbzG
         6rGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934556; x=1778539356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uWygzttyaDGZ8i1sz2PNqa3rZtIdDV4A7Q8dk96hn1w=;
        b=H7/2Ex74X+jdoNv2ggHo42PEqYlkvzIo78ILKo3HvEPbUu5oj2iqpkz9YN63xMoNof
         fhwYrAUdiXr1kkdCXkcgY5MAAh+7dXFPM68/RKcUoKaKxG4lVWwEwsK2FHQTFuN6/Mzn
         2yw8T5jOiUEetZOl7VO84nFsD6+b76YYVL/KVWP7iDYmsM3qGQdxkivltlbc7y2FqQI3
         BToLehUXTkYEwLmyXvREXG1DpLzksqw1vXZdeRQK6hhQo3Hmzr3Q+uWx8FtBaseYW6SK
         P36R5WGfgfdzESZGoQU/0PlGztSLRVhldYfoMd0ge26XMr0Q/umzOJvOrP0SB56kFUrJ
         PFhg==
X-Forwarded-Encrypted: i=1; AFNElJ85oJzykbJN8Iqgxni5xUYzf3xEh6Ur4oVh0OP9AV35w4BqsMC635BsZJUdH3RWaLuElrn0SuA=@lists.linux.dev
X-Gm-Message-State: AOJu0YytGePplFyKKcuOYVbyDrn4NFlky6k2rC9OITBFP/gr8SpsYogU
	NCPSb4dE208XPUFy24BWUmqSHPOS0xUkJZN0kgipv+W4gq5sRxZdZU8oeliqlMLOx2NEXmmKIAM
	qsJXSm9c2HWpb8P+4ermKgg==
X-Received: from pfbhh11.prod.google.com ([2002:a05:6a00:868b:b0:82f:a959:4a7f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:181b:b0:823:d2c:b156 with SMTP id d2e1a72fcca58-8352d037329mr12663141b3a.5.1777934555976;
 Mon, 04 May 2026 15:42:35 -0700 (PDT)
Date: Mon,  4 May 2026 22:42:08 +0000
In-Reply-To: <20260504224213.1049426-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504224213.1049426-1-jthoughton@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504224213.1049426-2-jthoughton@google.com>
Subject: [PATCH 1/5] KVM: arm64: Grab KVM MMU write lock in kvm_arch_flush_shadow_all()
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Gavin Shan <gshan@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, James Hogan <jhogan@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_arch_flush_shadow_all() may sometimes be called on the same `kvm`
concurrently in the event that the KVM's `mm` is __mmput() at the
same time that last reference to the KVM is being dropped.

T1              T2
KVM_CREATE_VM
                Get VM file from T1
close VM
exit_mm()       close VM

T1: exit_mm() -> kvm_mmu_notifier_release() -> kvm_flush_shadow_all(),
    with only the KVM srcu read lock held.

T2: kvm_vm_release() ---> mmu_notifier_unregister() ->
    kvm_mmu_notifier_release() -> kvm_flush_shadow_all(),
    again, with only the KVM srcu read lock held.

This leads to a potential double-free of
kvm->arch.kvm_mmu_free_memory_cache and now with NV
kvm->arch.nested_mmus.

Cc: stable@vger.kernel.org
Fixes: e7bf7a490c68 ("KVM: arm64: Split huge pages when dirty logging is enabled")
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/kvm/mmu.c             | 23 +++++++++++++++++++----
 arch/arm64/kvm/nested.c          |  4 +++-
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 01e9c72d6aa7..30d5c24fcebb 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -178,6 +178,7 @@ void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
+void kvm_free_stage2_pgd_locked(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d089c107d9b7..4bab407d43bb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1021,7 +1021,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	kvm_free_stage2_pgd_locked(&kvm->arch.mmu);
 	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
@@ -1095,12 +1097,14 @@ void stage2_unmap_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
+static void __kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu, bool locked)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
 
-	write_lock(&kvm->mmu_lock);
+	if (!locked)
+		write_lock(&kvm->mmu_lock);
+
 	pgt = mmu->pgt;
 	if (pgt) {
 		mmu->pgd_phys = 0;
@@ -1111,7 +1115,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		kvm_init_nested_s2_mmu(mmu);
 
-	write_unlock(&kvm->mmu_lock);
+	if (!locked)
+		write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
 		kvm_stage2_destroy(pgt);
@@ -1119,6 +1124,16 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	}
 }
 
+void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
+{
+	__kvm_free_stage2_pgd(mmu, false);
+}
+
+void kvm_free_stage2_pgd_locked(struct kvm_s2_mmu *mmu)
+{
+	__kvm_free_stage2_pgd(mmu, true);
+}
+
 static void hyp_mc_free_fn(void *addr, void *mc)
 {
 	struct kvm_hyp_memcache *memcache = mc;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 883b6c1008fb..977598bff5e6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1190,11 +1190,13 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	int i;
 
+	guard(write_lock)(&kvm->mmu_lock);
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
 		if (!WARN_ON(atomic_read(&mmu->refcnt)))
-			kvm_free_stage2_pgd(mmu);
+			kvm_free_stage2_pgd_locked(mmu);
 	}
 	kvfree(kvm->arch.nested_mmus);
 	kvm->arch.nested_mmus = NULL;
-- 
2.54.0.545.g6539524ca2-goog

