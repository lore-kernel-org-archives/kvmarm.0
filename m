Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38142C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 09:19:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD511233A2
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 09:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="abS987FQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD511233A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93BFB4B414;
	Mon, 29 Jun 2020 05:19:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8fEhFdtm3PmZ; Mon, 29 Jun 2020 05:19:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 452194B427;
	Mon, 29 Jun 2020 05:19:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F3984B417
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 05:19:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sQ0hkmcV31H9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 05:19:07 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47D114B411
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 05:19:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593422347;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=t8GQ23V8YMb+4gfIb5E6up2owYgSdjQTC9kopabnb+Q=;
 b=abS987FQEgCu0ejc2+QMmMwrBL1u/vWxB1uAw2CiquFwgw4AWNRfl45YngsSY0PrXnv41m
 tcUlUtYfVcmpMnBDzy6ZCVp91BFtl2ijgLq00a8zZFS0v3DDciJB3DaHrNXhsovP68DRTV
 RaRzqX8ZRVrxGMtxFEPKqlDV/T7+Z7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-aYIT1l2qNwmd9lT2iwtkxw-1; Mon, 29 Jun 2020 05:19:03 -0400
X-MC-Unique: aYIT1l2qNwmd9lT2iwtkxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 591331005513;
 Mon, 29 Jun 2020 09:19:02 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-102.bne.redhat.com
 [10.64.54.102])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 79D6610013C1;
 Mon, 29 Jun 2020 09:19:00 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/2] kvm/arm64: Detach ESR operator from vCPU struct
Date: Mon, 29 Jun 2020 19:18:41 +1000
Message-Id: <20200629091841.88198-3-gshan@redhat.com>
In-Reply-To: <20200629091841.88198-1-gshan@redhat.com>
References: <20200629091841.88198-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org
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

There are a set of inline functions defined in kvm_emulate.h. Those
functions reads ESR from vCPU fault information struct and then operate
on it. So it's tied with vCPU fault information and vCPU struct. It
limits their usage scope.

This detaches these functions from the vCPU struct by introducing an
other set of inline functions in esr.h to manupulate the specified
ESR value. With it, the inline functions defined in kvm_emulate.h
can call these inline functions (in esr.h) instead. This shouldn't
cause any functional changes.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/esr.h         | 32 +++++++++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h | 43 ++++++++++++----------------
 2 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 035003acfa87..950204c5fbe1 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -326,6 +326,38 @@ static inline bool esr_is_data_abort(u32 esr)
 	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
 }
 
+#define ESR_DECLARE_CHECK_FUNC(name, field)	\
+static inline bool esr_is_##name(u32 esr)	\
+{						\
+	return !!(esr & (field));		\
+}
+#define ESR_DECLARE_GET_FUNC(name, mask, shift)	\
+static inline u32 esr_get_##name(u32 esr)	\
+{						\
+	return ((esr & (mask)) >> (shift));	\
+}
+
+ESR_DECLARE_CHECK_FUNC(il_32bit,   ESR_ELx_IL);
+ESR_DECLARE_CHECK_FUNC(condition,  ESR_ELx_CV);
+ESR_DECLARE_CHECK_FUNC(dabt_valid, ESR_ELx_ISV);
+ESR_DECLARE_CHECK_FUNC(dabt_sse,   ESR_ELx_SSE);
+ESR_DECLARE_CHECK_FUNC(dabt_sf,    ESR_ELx_SF);
+ESR_DECLARE_CHECK_FUNC(dabt_s1ptw, ESR_ELx_S1PTW);
+ESR_DECLARE_CHECK_FUNC(dabt_write, ESR_ELx_WNR);
+ESR_DECLARE_CHECK_FUNC(dabt_cm,    ESR_ELx_CM);
+
+ESR_DECLARE_GET_FUNC(class,        ESR_ELx_EC_MASK,      ESR_ELx_EC_SHIFT);
+ESR_DECLARE_GET_FUNC(fault,        ESR_ELx_FSC,          0);
+ESR_DECLARE_GET_FUNC(fault_type,   ESR_ELx_FSC_TYPE,     0);
+ESR_DECLARE_GET_FUNC(condition,    ESR_ELx_COND_MASK,    ESR_ELx_COND_SHIFT);
+ESR_DECLARE_GET_FUNC(hvc_imm,      ESR_ELx_xVC_IMM_MASK, 0);
+ESR_DECLARE_GET_FUNC(dabt_iss_nisv_sanitized,
+		     (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC), 0);
+ESR_DECLARE_GET_FUNC(dabt_rd,      ESR_ELx_SRT_MASK,     ESR_ELx_SRT_SHIFT);
+ESR_DECLARE_GET_FUNC(dabt_as,      ESR_ELx_SAS,          ESR_ELx_SAS_SHIFT);
+ESR_DECLARE_GET_FUNC(sys_rt,       ESR_ELx_SYS64_ISS_RT_MASK,
+				   ESR_ELx_SYS64_ISS_RT_SHIFT);
+
 const char *esr_get_class_string(u32 esr);
 #endif /* __ASSEMBLY */
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9ba0df47f7d..9337d90c517f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -266,12 +266,8 @@ static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 
 static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
-
-	if (esr & ESR_ELx_CV)
-		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
-
-	return -1;
+	return esr_is_condition(kvm_vcpu_get_esr(vcpu)) ?
+	       esr_get_condition(kvm_vcpu_get_esr(vcpu)) : -1;
 }
 
 static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
@@ -291,79 +287,79 @@ static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
 
 static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_xVC_IMM_MASK;
+	return esr_get_hvc_imm(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline bool kvm_vcpu_dabt_isvalid(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_ISV);
+	return esr_is_dabt_valid(kvm_vcpu_get_esr(vcpu));
 }
 
 static inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC);
+	return esr_get_dabt_iss_nisv_sanitized(kvm_vcpu_get_esr(vcpu));
 }
 
 static inline bool kvm_vcpu_dabt_issext(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_SSE);
+	return esr_is_dabt_sse(kvm_vcpu_get_esr(vcpu));
 }
 
 static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_SF);
+	return esr_is_dabt_sf(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 {
-	return (kvm_vcpu_get_esr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
+	return esr_get_dabt_rd(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_S1PTW);
+	return esr_is_dabt_s1ptw(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR) ||
-		kvm_vcpu_dabt_iss1tw(vcpu); /* AF/DBM update */
+	return esr_is_dabt_write(kvm_vcpu_get_esr(vcpu)) ||
+	       esr_is_dabt_s1ptw(kvm_vcpu_get_esr(vcpu)); /* AF/DBM update */
 }
 
 static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_CM);
+	return esr_is_dabt_cm(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
 {
-	return 1 << ((kvm_vcpu_get_esr(vcpu) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
+	return 1 << esr_get_dabt_as(kvm_vcpu_get_esr(vcpu));
 }
 
 /* This one is not specific to Data Abort */
 static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_IL);
+	return esr_is_il_32bit(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
 {
-	return ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
+	return esr_get_class(kvm_vcpu_get_esr(vcpu));
 }
 
 static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
+	return esr_get_class(kvm_vcpu_get_esr(vcpu)) == ESR_ELx_EC_IABT_LOW;
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC;
+	return esr_get_fault(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
+	return esr_get_fault_type(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
@@ -387,8 +383,7 @@ static __always_inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
 
 static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
-	return ESR_ELx_SYS64_ISS_RT(esr);
+	return esr_get_sys_rt(kvm_vcpu_get_esr(vcpu));
 }
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
