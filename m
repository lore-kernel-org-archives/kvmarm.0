Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D843D7D82;
	Mon,  8 Jun 2026 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929802; cv=none; b=bSWa5UMyF3naEJERkkS6Pptkzj56XHyY3CufMv0+kNUkSIgqgF25YkZe8fwvJqQpSdD404YZlCrng2xeiUaMHatRaeAiHC6WhmRorTYxh0XW6vSr+zNN6qdIHB9zFoZCWl6ax5iXuwiicg5B2E43rkfckvJnpnMzfLcMTlMabmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929802; c=relaxed/simple;
	bh=sj5qOHLYW02zuH39dxwjZL1FmODVc+KM6dPGRJ9mA4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX4VJvsGyfThkaQ3jIpcaMfbNgTNgJjiNYXGe1oHK2tChz3W5QKxUJEtypYYBF8NqhTREUnsGOR4MJbA/xOXN2DTkLHr/u9BvrgkY1AguGg7/dfb+R96Ekb9uRmXBGXflrEsOia5NcePIR0POhsQvUY1/atANClcrA2sjfWVXPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id B17262028B4;
	Mon,  8 Jun 2026 16:43:08 +0200 (CEST)
From: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com
Subject: [PATCH 17/60] kvm: Move VCPU locking to struct kvm_vcpu_common
Date: Mon,  8 Jun 2026 16:42:09 +0200
Message-ID: <20260608144252.351443-18-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <joerg.roedel@amd.com>

Fields in struct kvm_vcpu which are protected by these locks is going
to move to struct kvm_vcpu_common. So move the locks as well.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h | 31 +++++++++++++++++--------------
 virt/kvm/kvm_main.c      |  3 ++-
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 611bba515ac0..c8085c23e18e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -330,6 +330,13 @@ struct kvm_vcpu_common {
 	/* Currently active VCPU */
 	struct kvm_vcpu *current_vcpu;
 
+	/* Locks */
+	int ____srcu_idx; /* Don't use this directly.  You've been warned. */
+#ifdef CONFIG_PROVE_RCU
+	int srcu_depth;
+#endif
+	struct mutex mutex;
+
 	/* Scheduling state */
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
@@ -347,15 +354,11 @@ struct kvm_vcpu {
 	int cpu;
 	int vcpu_id; /* id given by userspace at creation */
 	int vcpu_idx; /* index into kvm->planes[]->vcpu_array */
-	int ____srcu_idx; /* Don't use this directly.  You've been warned. */
-#ifdef CONFIG_PROVE_RCU
-	int srcu_depth;
-#endif
+
 	int mode;
 	u64 requests;
 	unsigned long guest_debug;
 
-	struct mutex mutex;
 	struct kvm_run *run;
 
 #ifndef __KVM_HAVE_ARCH_WQP
@@ -1001,35 +1004,35 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 
 static inline void kvm_vcpu_lock(struct kvm_vcpu *vcpu)
 {
-	mutex_lock(&vcpu->mutex);
+	mutex_lock(&vcpu->common->mutex);
 }
 
 static inline void kvm_vcpu_unlock(struct kvm_vcpu *vcpu)
 {
-	mutex_unlock(&vcpu->mutex);
+	mutex_unlock(&vcpu->common->mutex);
 }
 
 static inline struct mutex *kvm_vcpu_mutex(struct kvm_vcpu *vcpu)
 {
-	return &vcpu->mutex;
+	return &vcpu->common->mutex;
 }
 
 static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_PROVE_RCU
-	WARN_ONCE(vcpu->srcu_depth++,
-		  "KVM: Illegal vCPU srcu_idx LOCK, depth=%d", vcpu->srcu_depth - 1);
+	WARN_ONCE(vcpu->common->srcu_depth++,
+		  "KVM: Illegal vCPU srcu_idx LOCK, depth=%d", vcpu->common->srcu_depth - 1);
 #endif
-	vcpu->____srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	vcpu->common->____srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 }
 
 static inline void kvm_vcpu_srcu_read_unlock(struct kvm_vcpu *vcpu)
 {
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->____srcu_idx);
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->common->____srcu_idx);
 
 #ifdef CONFIG_PROVE_RCU
-	WARN_ONCE(--vcpu->srcu_depth,
-		  "KVM: Illegal vCPU srcu_idx UNLOCK, depth=%d", vcpu->srcu_depth);
+	WARN_ONCE(--vcpu->common->srcu_depth,
+		  "KVM: Illegal vCPU srcu_idx UNLOCK, depth=%d", vcpu->common->srcu_depth);
 #endif
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6975a5c60b4..9accca10c249 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -466,6 +466,8 @@ static int kvm_vcpu_init_common(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned
 
 	common->vcpu_idx = atomic_read(&kvm->online_vcpus);
 
+	mutex_init(&common->mutex);
+
 	common->kvm = kvm;
 	common->current_vcpu = vcpu;
 
@@ -500,7 +502,6 @@ static void kvm_vcpu_finish_common(struct kvm_vcpu *vcpu)
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
-	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
 	vcpu->kvm = kvm;
 	vcpu->plane = kvm->planes[0];
-- 
2.53.0

