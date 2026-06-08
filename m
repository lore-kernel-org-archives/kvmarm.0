Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5D853F0ABB;
	Mon,  8 Jun 2026 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929803; cv=none; b=KYllUjJ1h8jg3cLt00r6j1xRvphzJVOWY52dt0AYU9YNoh6WNwhLxuX6/zBCli/IozJhNzuw1vbns9Gg312qQL6nGPeV3/A1UNsujP10SEdvX4R2uh+bax1SO1CGoaCFO+UCQwmR0wqQKr2FCyFKRUcKVZRGv5xySnIWZl99B9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929803; c=relaxed/simple;
	bh=75KxlGnkwC/kmi3XF4Qw6hXJxaPunEix++qeQB+dLBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcwplRT3Ruvt2OAaDfV7dZqeLkQxqv0YdYsv5ne/3l7eSTNl9xF66I7L7sshXCLowV3slzGMNLITGH0Esx9o8lMIGXjSxQBSaV76PtQ7Wm6oWPFjdIFr0E1QKWKClyriESFvktRBKcWkbpUV0wQPjBr+7xU2c5mgYb+goYz5ia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 337162028BB;
	Mon,  8 Jun 2026 16:43:10 +0200 (CEST)
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
Subject: [PATCH 24/60] kvm: Move kvm_vcpu spinloop members to struct kvm_vcpu_common
Date: Mon,  8 Jun 2026 16:42:16 +0200
Message-ID: <20260608144252.351443-25-joro@8bytes.org>
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

Onlyh one struct kvm_vcpu across all planes can be in a spin-loop.
Move the state to struct kvm_vcpu_common to make detection independent
of the active struct kvm_vcpu.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h | 32 +++++++++++++++----------------
 virt/kvm/kvm_main.c      | 41 ++++++++++++++++++++++------------------
 2 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9220c452aa3a..f6e8a0b653b3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -350,6 +350,20 @@ struct kvm_vcpu_common {
 	rwlock_t pid_lock;
 	int sigset_active;
 	sigset_t sigset;
+	unsigned int halt_poll_ns;
+
+#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
+	/*
+	 * Cpu relax intercept or pause loop exit optimization
+	 * in_spin_loop: set when a vcpu does a pause loop exit
+	 *  or cpu relax intercepted.
+	 * dy_eligible: indicates whether vcpu is eligible for directed yield.
+	 */
+	struct {
+		bool in_spin_loop;
+		bool dy_eligible;
+	} spin_loop;
+#endif
 
 	/* Scheduling state */
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -373,8 +387,6 @@ struct kvm_vcpu {
 
 	struct kvm_run *run;
 
-	unsigned int halt_poll_ns;
-
 	u64 plane_requests;
 
 	/* S390 only */
@@ -398,18 +410,6 @@ struct kvm_vcpu {
 	} async_pf;
 #endif
 
-#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
-	/*
-	 * Cpu relax intercept or pause loop exit optimization
-	 * in_spin_loop: set when a vcpu does a pause loop exit
-	 *  or cpu relax intercepted.
-	 * dy_eligible: indicates whether vcpu is eligible for directed yield.
-	 */
-	struct {
-		bool in_spin_loop;
-		bool dy_eligible;
-	} spin_loop;
-#endif
 	struct kvm_vcpu_arch arch;
 	struct kvm_vcpu_stat stat;
 	char stats_id[KVM_STATS_NAME_SIZE];
@@ -2500,11 +2500,11 @@ extern struct kvm_device_ops kvm_arm_vgic_v5_ops;
 
 static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
 {
-	vcpu->spin_loop.in_spin_loop = val;
+	vcpu->common->spin_loop.in_spin_loop = val;
 }
 static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 {
-	vcpu->spin_loop.dy_eligible = val;
+	vcpu->common->spin_loop.dy_eligible = val;
 }
 
 #else /* !CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1858880ee3d3..24ff8748a317 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -485,6 +485,9 @@ static int kvm_vcpu_init_common(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned
 
 	vcpu->common = no_free_ptr(common);
 
+	kvm_vcpu_set_in_spin_loop(vcpu, false);
+	kvm_vcpu_set_dy_eligible(vcpu, false);
+
 	return 0;
 
 out_drop_counter:
@@ -515,8 +518,6 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->vcpu_id = id;
 	kvm_async_pf_vcpu_init(vcpu);
 
-	kvm_vcpu_set_in_spin_loop(vcpu, false);
-	kvm_vcpu_set_dy_eligible(vcpu, false);
 	vcpu->last_used_slot = NULL;
 
 	vcpu->plane_level = 0;
@@ -3721,9 +3722,10 @@ void kvm_sigset_deactivate(struct kvm_vcpu *vcpu)
 
 static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu_common *common = vcpu->common;
 	unsigned int old, val, grow, grow_start;
 
-	old = val = vcpu->halt_poll_ns;
+	old = val = common->halt_poll_ns;
 	grow_start = READ_ONCE(halt_poll_ns_grow_start);
 	grow = READ_ONCE(halt_poll_ns_grow);
 	if (!grow)
@@ -3733,16 +3735,17 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 	if (val < grow_start)
 		val = grow_start;
 
-	vcpu->halt_poll_ns = val;
+	common->halt_poll_ns = val;
 out:
 	trace_kvm_halt_poll_ns_grow(vcpu->vcpu_id, val, old);
 }
 
 static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu_common *common = vcpu->common;
 	unsigned int old, val, shrink, grow_start;
 
-	old = val = vcpu->halt_poll_ns;
+	old = val = common->halt_poll_ns;
 	shrink = READ_ONCE(halt_poll_ns_shrink);
 	grow_start = READ_ONCE(halt_poll_ns_grow_start);
 	if (shrink == 0)
@@ -3753,7 +3756,7 @@ static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 	if (val < grow_start)
 		val = 0;
 
-	vcpu->halt_poll_ns = val;
+	common->halt_poll_ns = val;
 	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
 }
 
@@ -3864,19 +3867,20 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
 	unsigned int max_halt_poll_ns = kvm_vcpu_max_halt_poll_ns(vcpu);
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
+	struct kvm_vcpu_common *common = vcpu->common;
 	ktime_t start, cur, poll_end;
 	bool waited = false;
 	bool do_halt_poll;
 	u64 halt_ns;
 
-	if (vcpu->halt_poll_ns > max_halt_poll_ns)
-		vcpu->halt_poll_ns = max_halt_poll_ns;
+	if (common->halt_poll_ns > max_halt_poll_ns)
+		common->halt_poll_ns = max_halt_poll_ns;
 
-	do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
+	do_halt_poll = halt_poll_allowed && common->halt_poll_ns;
 
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
-		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
+		ktime_t stop = ktime_add_ns(start, common->halt_poll_ns);
 
 		do {
 			if (kvm_vcpu_check_block(vcpu) < 0)
@@ -3914,18 +3918,18 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
 		} else if (max_halt_poll_ns) {
-			if (halt_ns <= vcpu->halt_poll_ns)
+			if (halt_ns <= common->halt_poll_ns)
 				;
 			/* we had a long block, shrink polling */
-			else if (vcpu->halt_poll_ns &&
+			else if (common->halt_poll_ns &&
 				 halt_ns > max_halt_poll_ns)
 				shrink_halt_poll_ns(vcpu);
 			/* we had a short halt and our poll time is too small */
-			else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
+			else if (common->halt_poll_ns < max_halt_poll_ns &&
 				 halt_ns < max_halt_poll_ns)
 				grow_halt_poll_ns(vcpu);
 		} else {
-			vcpu->halt_poll_ns = 0;
+			common->halt_poll_ns = 0;
 		}
 	}
 
@@ -4046,13 +4050,14 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_yield_to);
 static bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
+	struct kvm_vcpu_common *common = vcpu->common;
 	bool eligible;
 
-	eligible = !vcpu->spin_loop.in_spin_loop ||
-		    vcpu->spin_loop.dy_eligible;
+	eligible = !common->spin_loop.in_spin_loop ||
+		    common->spin_loop.dy_eligible;
 
-	if (vcpu->spin_loop.in_spin_loop)
-		kvm_vcpu_set_dy_eligible(vcpu, !vcpu->spin_loop.dy_eligible);
+	if (common->spin_loop.in_spin_loop)
+		kvm_vcpu_set_dy_eligible(vcpu, !common->spin_loop.dy_eligible);
 
 	return eligible;
 #else
-- 
2.53.0

