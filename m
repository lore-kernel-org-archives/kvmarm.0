Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BA7C433B4
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BA307613EA
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA307613EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 518054B491;
	Fri,  7 May 2021 02:41:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SQRZyl5u1oly; Fri,  7 May 2021 02:41:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09CD44B41E;
	Fri,  7 May 2021 02:41:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A43E4B52D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aQpFKjeHPeW9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:41:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 569E34B54C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369672;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2LI4eA946eDRWIry8QnZkm27lHt9ZmwJpghwYcjQ8ho=;
 b=H5YKVcawQKWMTxVgSo6/OP8Kj+fh+aZfWwZCS0Zi1k1Qsg1HK1AI2IAyMsNgvAVjqRrTnb
 K8VYUsrU01nwcg55WMSBHgOGiiOgX5NXoqILJ4abktrziW0ZHPNNiDZi1gDmCgvoyxOb9I
 6aAqgldsP2JKL5Felaq9ki/UNakV1E8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-3DLZyLT6Oge5zxVWb319iQ-1; Fri, 07 May 2021 02:41:10 -0400
X-MC-Unique: 3DLZyLT6Oge5zxVWb319iQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09160801817;
 Fri,  7 May 2021 06:41:09 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B55655C276;
 Fri,  7 May 2021 06:41:06 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 04/15] KVM: x86: Use generic async PF slot management
Date: Fri,  7 May 2021 16:40:42 +0800
Message-Id: <20210507084053.44407-5-gshan@redhat.com>
In-Reply-To: <20210507084053.44407-1-gshan@redhat.com>
References: <20210507084053.44407-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This uses the generic slot management mechanism for asynchronous
page fault by enabling CONFIG_KVM_ASYNC_PF_SLOT because the private
implementation is totally duplicate to the generic one.

The changes introduced by this is pretty mechanical and shouldn't
cause any logical changes.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 -
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/x86.c              | 86 +++------------------------------
 4 files changed, 8 insertions(+), 83 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cbbcee0a84f9..9b344a71f083 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -766,7 +766,6 @@ struct kvm_vcpu_arch {
 
 	struct {
 		bool halted;
-		gfn_t gfns[ASYNC_PF_PER_VCPU];
 		struct gfn_to_hva_cache data;
 		u64 msr_en_val; /* MSR_KVM_ASYNC_PF_EN */
 		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
@@ -1797,7 +1796,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
 void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu);
 bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
-extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f6b93a35ce14..8b8ae8a0467d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -34,6 +34,7 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_EVENTFD
 	select KVM_ASYNC_PF
+	select KVM_ASYNC_PF_SLOT
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
 	select TASKSTATS
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4b3ee244ebe0..c355d980fd9a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3701,7 +3701,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 
 	if (!prefault && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
-		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
+		if (kvm_async_pf_find_slot(vcpu, gfn)) {
 			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return true;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 300661dc6ca4..55d53082a8df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -305,13 +305,6 @@ static struct kmem_cache *kvm_alloc_emulator_cache(void)
 
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
 
-static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
-{
-	int i;
-	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
-		vcpu->arch.apf.gfns[i] = ~0;
-}
-
 static void kvm_on_user_return(struct user_return_notifier *urn)
 {
 	unsigned slot;
@@ -829,7 +822,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
+		kvm_async_pf_reset_slot(vcpu);
 	}
 
 	if ((cr0 ^ old_cr0) & update_bits)
@@ -2959,7 +2952,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 
 	if (!kvm_pv_async_pf_enabled(vcpu)) {
 		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
+		kvm_async_pf_reset_slot(vcpu);
 		return 0;
 	}
 
@@ -10264,7 +10257,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 
-	kvm_async_pf_hash_reset(vcpu);
+	kvm_async_pf_reset_slot(vcpu);
 	kvm_pmu_init(vcpu);
 
 	vcpu->arch.pending_external_vector = -1;
@@ -10381,7 +10374,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvmclock_reset(vcpu);
 
 	kvm_clear_async_pf_completion_queue(vcpu);
-	kvm_async_pf_hash_reset(vcpu);
+	kvm_async_pf_reset_slot(vcpu);
 	vcpu->arch.apf.halted = false;
 
 	if (vcpu->arch.guest_fpu && kvm_mpx_supported()) {
@@ -11221,73 +11214,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
 }
 
-static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
-{
-	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
-
-	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
-}
-
-static inline u32 kvm_async_pf_next_probe(u32 key)
-{
-	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
-}
-
-static void kvm_add_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	u32 key = kvm_async_pf_hash_fn(gfn);
-
-	while (vcpu->arch.apf.gfns[key] != ~0)
-		key = kvm_async_pf_next_probe(key);
-
-	vcpu->arch.apf.gfns[key] = gfn;
-}
-
-static u32 kvm_async_pf_gfn_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	int i;
-	u32 key = kvm_async_pf_hash_fn(gfn);
-
-	for (i = 0; i < ASYNC_PF_PER_VCPU &&
-		     (vcpu->arch.apf.gfns[key] != gfn &&
-		      vcpu->arch.apf.gfns[key] != ~0); i++)
-		key = kvm_async_pf_next_probe(key);
-
-	return key;
-}
-
-bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	return vcpu->arch.apf.gfns[kvm_async_pf_gfn_slot(vcpu, gfn)] == gfn;
-}
-
-static void kvm_del_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	u32 i, j, k;
-
-	i = j = kvm_async_pf_gfn_slot(vcpu, gfn);
-
-	if (WARN_ON_ONCE(vcpu->arch.apf.gfns[i] != gfn))
-		return;
-
-	while (true) {
-		vcpu->arch.apf.gfns[i] = ~0;
-		do {
-			j = kvm_async_pf_next_probe(j);
-			if (vcpu->arch.apf.gfns[j] == ~0)
-				return;
-			k = kvm_async_pf_hash_fn(vcpu->arch.apf.gfns[j]);
-			/*
-			 * k lies cyclically in ]i,j]
-			 * |    i.k.j |
-			 * |....j i.k.| or  |.k..j i...|
-			 */
-		} while ((i <= j) ? (i < k && k <= j) : (i < k || k <= j));
-		vcpu->arch.apf.gfns[i] = vcpu->arch.apf.gfns[j];
-		i = j;
-	}
-}
-
 static inline int apf_put_user_notpresent(struct kvm_vcpu *vcpu)
 {
 	u32 reason = KVM_PV_REASON_PAGE_NOT_PRESENT;
@@ -11351,7 +11277,7 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	struct x86_exception fault;
 
 	trace_kvm_async_pf_not_present(work->arch.token, work->cr2_or_gpa);
-	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
+	kvm_async_pf_add_slot(vcpu, work->arch.gfn);
 
 	if (kvm_can_deliver_async_pf(vcpu) &&
 	    !apf_put_user_notpresent(vcpu)) {
@@ -11388,7 +11314,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	if (work->wakeup_all)
 		work->arch.token = ~0; /* broadcast wakeup */
 	else
-		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
+		kvm_async_pf_remove_slot(vcpu, work->arch.gfn);
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
 
 	if ((work->wakeup_all || work->notpresent_injected) &&
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
