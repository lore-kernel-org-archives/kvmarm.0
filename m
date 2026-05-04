Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93527388E77
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934572; cv=none; b=gRtC9CQ1owGt962172Scq+787XApLe5ofvqoe2O6kSuvN0rgz/D3JO4OCc5Bb8feU9bUXTTPpAIOIS3rhjiHD6JgeYeMUYcwGFivYL45RZSCya3dJJQ7D6dQMer/aMgNSvzV/R7XHt86zYDjzOmLbq41aCD9lH09MWcSOWeg54c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934572; c=relaxed/simple;
	bh=InGnsmMXyUKk5UR+us+b7DjwbtH0DDKd3A8oEQN+NKI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J6CHhoB4d8X9JveaH0A1oMqI9k9tFCoNNXF7yZa7mFUDPBan67J7FYS8ZtD2FI+9nPE5OlojDeDwFBiHvjMAeXoqUd+McxdCwwYZnHaMZTrv6tT0DDS0tzIq+ez+TuXfgMPjicmqI+QZ0Mbmj/zAgHz2Y4kN2KJCDNP1HyjmUkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pF6kUdVd; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pF6kUdVd"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b258636d16so49473905ad.2
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 15:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934569; x=1778539369; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vC+QCMBPXdQWF+dL8GXMYzl+k9Np64sK2GTCcOrjhPY=;
        b=pF6kUdVdUDb8c4L/UIjueHnKiiUw/EOtFeg3JZsoJZlAJuVeT2qvqSOhnVr1jhKLbd
         bcvcxhOplHcWvtkL4xN4I1qN9oKXUba1XIlzUHAgxobBHDSlD+d7DrczeqhTVXlA4a8J
         wC5Nk+EmDAIGqx+1Qe4z7GWE60Hd6nl42vjCQZVtw3as1olDPg93qV7VfAqZAchaMadv
         TAi620gqBLNojSuEzCaeEbiVpGolWCdeExe1xvaGgNQpoBpww/7c9bLms0Ui5TFV6eWd
         wQY/rNZbSgfaPmaWknuajHys1Z2PmLQSt4xU2k6Ho4E4MM5+XE7QNVpOAoGk5BZ3u2ig
         X+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934569; x=1778539369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vC+QCMBPXdQWF+dL8GXMYzl+k9Np64sK2GTCcOrjhPY=;
        b=jvpa916HolWWYsLzk0Z8KCSTgSUI3ZBII/CUcfPLhisAnZphwGTgki6osdoTwuDX/D
         9Lm0qJCFcdul8qym537RB2w5k153AO6X+m+bcWEoRgIThNrYeNT1AfdG8an27rkg3bed
         CRAccSOC2+UfN3NvN6dg6d1+Vjjp3susLc9fDNIXphRd0w7P2mCH8n7PsmzkHEPanI27
         0n3SWcH4gI/8MVXXofyrBDHI4sx5bgW38magSiIT4fzff6WwYWw6PS77rvS+fLUG/BCh
         N28og2EiPULVIsMKbC0tLlVE5R50nV68j3TR+CkwJbcz8beTUHhpDwmgeeiwt/daCjOl
         1W/A==
X-Forwarded-Encrypted: i=1; AFNElJ9hkz8GyBLaIjOz1tOqqPxTO7sA501WF3RAjcB7jOdU3up7zBRP7aHRK8LmQtAyM0X0LKTEUBg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxS/cekjc2RSEJb9KPwa3qcadM0olcvlRXLTjue8WhgYaMMCH4i
	cJWs508hTOI0HsccCzYdy2e7QSKGjqfDfakkR9axsR9ZLr00/5FIa80P1xa+gn9+O8iB50Ict3k
	oELz8XEgZ0OHspcSp5t28mg==
X-Received: from plmx11.prod.google.com ([2002:a17:902:fe8b:b0:2ae:3bca:37a5])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b0d:b0:2b0:6d33:e7c0 with SMTP id d9443c01a7336-2ba535e2df5mr4309355ad.1.1777934568708;
 Mon, 04 May 2026 15:42:48 -0700 (PDT)
Date: Mon,  4 May 2026 22:42:11 +0000
In-Reply-To: <20260504224213.1049426-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504224213.1049426-1-jthoughton@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504224213.1049426-5-jthoughton@google.com>
Subject: [PATCH 4/5] KVM: Hold MMU lock exclusively when calling kvm_arch_flush_shadow_all()
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
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

All architectures that non-trivially implement this function grab the
KVM MMU lock exclusively to prevent things like double-freeing of page
table entries and caches. Do so generically to somewhat simplify the
architecture-specific logic.

Without this change, it is possible for kvm_arch_flush_shadow_all() to
be called on the same `kvm` at the same time: if the `kvm`'s mm is
destroyed (exit_mm()) at the same time to the final reference to the
`kvm` is dropped.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/nested.c  | 2 +-
 arch/loongarch/kvm/mmu.c | 4 +++-
 arch/mips/kvm/mips.c     | 2 +-
 arch/riscv/kvm/mmu.c     | 4 ++--
 arch/riscv/kvm/vm.c      | 2 ++
 arch/x86/kvm/mmu/mmu.c   | 4 +---
 virt/kvm/kvm_main.c      | 3 +++
 7 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 977598bff5e6..ba2e6c98bd45 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1190,7 +1190,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	int i;
 
-	guard(write_lock)(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 5dbce9b18e1c..120001da26e4 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -486,7 +486,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT, 1);
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	kvm_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT, 0);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 463b6c4aa62c..4ad9e21a3321 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -180,7 +180,7 @@ long kvm_arch_dev_ioctl(struct file *filp, unsigned int ioctl,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	guard(spinlock)(&kvm->mmu_lock);
+	lockdep_assert_held(&kvm->mmu_lock);
 
 	/* Flush whole GPA */
 	kvm_mips_flush_gpa_pt(kvm, 0, ~0);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 2d3def024270..c1b9333f17eb 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -558,7 +558,8 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 	struct kvm_gstage gstage;
 	void *pgd = NULL;
 
-	spin_lock(&kvm->mmu_lock);
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	if (kvm->arch.pgd) {
 		kvm_riscv_gstage_init(&gstage, kvm);
 		kvm_riscv_gstage_unmap_range(&gstage, 0UL,
@@ -568,7 +569,6 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 		kvm->arch.pgd_phys = 0;
 		kvm->arch.pgd_levels = 0;
 	}
-	spin_unlock(&kvm->mmu_lock);
 
 	if (pgd)
 		free_pages((unsigned long)pgd, get_order(kvm_riscv_gstage_pgd_size));
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index a9f083feeb76..f704a64bfc48 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -38,7 +38,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	r = kvm_riscv_gstage_vmid_init(kvm);
 	if (r) {
+		spin_lock(&kvm->mmu_lock);
 		kvm_riscv_mmu_free_pgd(kvm);
+		spin_unlock(&kvm->mmu_lock);
 		return r;
 	}
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 892246204435..6e6f94046b3f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7352,7 +7352,7 @@ static void kvm_mmu_zap_all(struct kvm *kvm)
 	LIST_HEAD(invalid_list);
 	int ign;
 
-	write_lock(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (WARN_ON_ONCE(sp->role.invalid))
@@ -7367,8 +7367,6 @@ static void kvm_mmu_zap_all(struct kvm *kvm)
 
 	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
-
-	write_unlock(&kvm->mmu_lock);
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 89489996fbc1..f5affd3bfda8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -340,7 +340,10 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
+	KVM_MMU_LOCK(kvm);
 	kvm_arch_flush_shadow_all(kvm);
+	KVM_MMU_UNLOCK(kvm);
+
 	kvm_arch_guest_memory_reclaimed(kvm);
 }
 
-- 
2.54.0.545.g6539524ca2-goog

