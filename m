Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37EAC433E4
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:13:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 585DD206DA
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpmlJOf8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 585DD206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E6F4C2C6;
	Mon, 17 Aug 2020 21:13:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xryu1dRPH54I; Mon, 17 Aug 2020 21:13:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B263A4C2AA;
	Mon, 17 Aug 2020 21:13:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B6DE4C296
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eY7pjRQUbVMx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 21:13:42 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02CEB4C28B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597713221;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cifT85tDevGep2udXzfZ6p4u2RYkWVE9qeE3xPE0oxs=;
 b=bpmlJOf83aGFjAI4Yqd2IOr6aSu8LE9vdPX4Ku1g9hWXjLVo7j+s5PVgxejt6ncIx0aVTy
 /6Qwl96WSaoDmG5fU7r+ColFRAtnLqzbfZR+1W4trI34y5b44LrZQ7o+gOcaJK2zdR77i/
 3TWGzonzHdIVQDMZPkqwa6zhUjk26o0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-TAkIPXK_MWqs5_pCV9Ed1Q-1; Mon, 17 Aug 2020 21:13:40 -0400
X-MC-Unique: TAkIPXK_MWqs5_pCV9Ed1Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA30E1DDE9;
 Tue, 18 Aug 2020 01:13:38 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 7AA865D9D2;
 Tue, 18 Aug 2020 01:13:36 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/6] kvm/arm64: Export kvm_handle_user_mem_abort() with
 prefault mode
Date: Tue, 18 Aug 2020 11:13:16 +1000
Message-Id: <20200818011319.91777-4-gshan@redhat.com>
In-Reply-To: <20200818011319.91777-1-gshan@redhat.com>
References: <20200818011319.91777-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com, will@kernel.org
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

This renames user_mem_abort() to kvm_handle_user_mem_abort(), and
then exports it. The function will be used in asynchronous page fault
to populate a page table entry once the corresponding page is populated
from the backup device (e.g. swap partition):

   * Parameter @fault_status is replace by @esr.
   * Parameter @prefault is added

As the @esr is passed as parameter, not fetched from vCPU struct. This
also introduces the necessasry helpers in esr.h, to manupulate the @esr.
The helpers defined in kvm_emulate.h reuses the newly added helper. This
shouldn't cause functional changes.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/esr.h         |  5 +++++
 arch/arm64/include/asm/kvm_emulate.h |  8 ++++----
 arch/arm64/include/asm/kvm_host.h    |  4 ++++
 arch/arm64/kvm/mmu.c                 | 18 ++++++++++++------
 4 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 035003acfa87..ec0b5d81183c 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -317,8 +317,13 @@
 					 ESR_ELx_CP15_32_ISS_DIR_READ)
 
 #ifndef __ASSEMBLY__
+#include <linux/bitfield.h>
 #include <asm/types.h>
 
+#define esr_get_trap_class(esr)		FIELD_GET(ESR_ELx_EC_MASK, esr)
+#define esr_is_dabt_wnr(esr)		!!(FIELD_GET(ESR_ELx_WNR, esr))
+#define esr_is_dabt_iss1tw(esr)		!!(FIELD_GET(ESR_ELx_S1PTW, esr))
+
 static inline bool esr_is_data_abort(u32 esr)
 {
 	const u32 ec = ESR_ELx_EC(esr);
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bb7aee5927a5..2681d1fe4003 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -323,13 +323,13 @@ static __always_inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 
 static __always_inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_S1PTW);
+	return esr_is_dabt_iss1tw(kvm_vcpu_get_hsr(vcpu));
 }
 
 static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WNR) ||
-		kvm_vcpu_dabt_iss1tw(vcpu); /* AF/DBM update */
+	return (esr_is_dabt_wnr(kvm_vcpu_get_hsr(vcpu)) ||
+		kvm_vcpu_dabt_iss1tw(vcpu)); /* AF/DBM update */
 }
 
 static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
@@ -350,7 +350,7 @@ static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu
 
 static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
 {
-	return ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
+	return esr_get_trap_class(kvm_vcpu_get_hsr(vcpu));
 }
 
 static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ba8cdc304b81..b6c9851b2a65 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -441,6 +441,10 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_handle_user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			      struct kvm_memory_slot *memslot,
+			      unsigned long hva, unsigned int esr,
+			      bool prefault);
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7a7ddc4558a7..b23778392aa1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1787,11 +1787,15 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
 	return PAGE_SIZE;
 }
 
-static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  unsigned long fault_status)
+int kvm_handle_user_mem_abort(struct kvm_vcpu *vcpu,
+			      phys_addr_t fault_ipa,
+			      struct kvm_memory_slot *memslot,
+			      unsigned long hva,
+			      unsigned int esr,
+			      bool prefault)
 {
 	int ret;
+	unsigned int fault_status = (esr & ESR_ELx_FSC_TYPE);
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, needs_exec;
 	unsigned long mmu_seq;
@@ -1805,8 +1809,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long vma_pagesize, flags = 0;
 
-	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
+	exec_fault = (esr_get_trap_class(esr) == ESR_ELx_EC_IABT_LOW);
+	write_fault = (!exec_fault &&
+		       (esr_is_dabt_wnr(esr) || esr_is_dabt_iss1tw(esr)));
 	VM_BUG_ON(write_fault && exec_fault);
 
 	if (fault_status == FSC_PERM && !write_fault && !exec_fault) {
@@ -2116,7 +2121,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
+	ret = kvm_handle_user_mem_abort(vcpu, fault_ipa, memslot, hva,
+					kvm_vcpu_get_hsr(vcpu), false);
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
