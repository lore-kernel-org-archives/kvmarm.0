Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB85AC2BBC7
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 09:42:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 702F220787
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 09:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jWIHhKIh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 702F220787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B52C4B1B0;
	Fri, 10 Apr 2020 05:42:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ihB2Wk3raPEd; Fri, 10 Apr 2020 05:42:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF9B84B1D5;
	Fri, 10 Apr 2020 05:42:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61CC74B126
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 04:59:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ImAAWnO+7-YK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 04:59:16 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FCAA4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 04:59:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586509156;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0kCLBgqm5U5m0awoTWY24IbEePoTKJUpX6H4QYV0tTQ=;
 b=jWIHhKIh5tVhqUJEGifupFRMWWT+rAz0ESRA3vh9xitpXEtBJtKFTB9myDK518gUj5V0qX
 pdUpjcay4vk+NyTDClx3Z3OLeu4YrdqyFbQvUADWyl4yrkHjBJUWBqsQpFR+E6JPIKlRts
 Ce07N9EkRErCzub+qntlPeo7E893UJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-9hgVFw0cN8uJag-xEd0v0Q-1; Fri, 10 Apr 2020 04:59:14 -0400
X-MC-Unique: 9hgVFw0cN8uJag-xEd0v0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98C3F18C35A2;
 Fri, 10 Apr 2020 08:59:12 +0000 (UTC)
Received: from 192-168-1-115.tpgi.com.com (vpn2-54-29.bne.redhat.com
 [10.64.54.29])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 517F85E001;
 Fri, 10 Apr 2020 08:59:06 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH RFCv1 5/7] kvm/arm64: Allow inject data abort with specified
 DFSC
Date: Fri, 10 Apr 2020 18:58:18 +1000
Message-Id: <20200410085820.758686-6-gshan@redhat.com>
In-Reply-To: <20200410085820.758686-1-gshan@redhat.com>
References: <20200410085820.758686-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Fri, 10 Apr 2020 05:42:17 -0400
Cc: maz@kernel.org, sudeep.holla@arm.com, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

The data abort will be used as signal by the asynchronous page fault.
However, the specific IMPDEF Data Fault Status Code (DFSC) is used.
Currently, there is no API to inject data abort with specific DSC.
This fixes the gap by introducing kvm_inject_dabt_with_dfsc().

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  4 ++++
 arch/arm64/kvm/inject_fault.c        | 34 ++++++++++++++++++++++++----
 virt/kvm/arm/aarch32.c               | 27 +++++++++++++++-------
 3 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 2873bf6dc85e..fdf6a01b9dcb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -31,9 +31,13 @@ void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr);
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
+void kvm_inject_dabt_with_dfsc(struct kvm_vcpu *vcpu,
+			       unsigned long addr, unsigned int dfsc);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_undef32(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr);
+void kvm_inject_dabt32_with_dfsc(struct kvm_vcpu *vcpu,
+				 unsigned long addr, unsigned int dfsc);
 void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 0ae7c2e40e02..35794d0de0e9 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -110,7 +110,9 @@ static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
 	return new;
 }
 
-static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
+static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt,
+			 unsigned long addr, bool dfsc_valid,
+			 unsigned int dfsc)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
@@ -143,7 +145,12 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
-	vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
+	if (dfsc_valid)
+		esr |= dfsc;
+	else
+		esr |= ESR_ELx_FSC_EXTABT;
+
+	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
 }
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
@@ -180,7 +187,26 @@ void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
 	if (vcpu_el1_is_32bit(vcpu))
 		kvm_inject_dabt32(vcpu, addr);
 	else
-		inject_abt64(vcpu, false, addr);
+		inject_abt64(vcpu, false, addr, false, 0);
+}
+
+/**
+ * kvm_inject_dabt_with_dfsc - inject a data abort into the guest
+ * @vcpu: The VCPU to receive the data abort
+ * @addr: The address to report in the DFAR
+ * @dfsc: The data fault status code to be reported in DFSR
+ *
+ * It is assumed that this code is called from the VCPU thread and that the
+ * VCPU therefore is not currently executing guest code.
+ */
+void kvm_inject_dabt_with_dfsc(struct kvm_vcpu *vcpu,
+			       unsigned long addr,
+			       unsigned int dfsc)
+{
+	if (vcpu_el1_is_32bit(vcpu))
+		kvm_inject_dabt32_with_dfsc(vcpu, addr, dfsc);
+	else
+		inject_abt64(vcpu, false, addr, true, dfsc);
 }
 
 /**
@@ -196,7 +222,7 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
 	if (vcpu_el1_is_32bit(vcpu))
 		kvm_inject_pabt32(vcpu, addr);
 	else
-		inject_abt64(vcpu, true, addr);
+		inject_abt64(vcpu, true, addr, false, 0);
 }
 
 /**
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 0a356aa91aa1..82bded4cab25 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -163,7 +163,8 @@ void kvm_inject_undef32(struct kvm_vcpu *vcpu)
  * pseudocode.
  */
 static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
-			 unsigned long addr)
+			 unsigned long addr, bool dfsc_valid,
+			 unsigned int dfsc)
 {
 	u32 vect_offset;
 	u32 *far, *fsr;
@@ -184,21 +185,31 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 	*far = addr;
 
 	/* Give the guest an IMPLEMENTATION DEFINED exception */
-	is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
-	if (is_lpae) {
-		*fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
+	if (dfsc_valid) {
+		*fsr = dfsc;
 	} else {
-		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
-		*fsr = DFSR_FSC_EXTABT_nLPAE;
+		is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
+		if (is_lpae) {
+			*fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
+		} else {
+			/* no need to shuffle FS[4] into DFSR[10] as its 0 */
+			*fsr = DFSR_FSC_EXTABT_nLPAE;
+		}
 	}
 }
 
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)
 {
-	inject_abt32(vcpu, false, addr);
+	inject_abt32(vcpu, false, addr, false, 0);
+}
+
+void kvm_inject_dabt32_with_dfsc(struct kvm_vcpu *vcpu,
+				 unsigned long addr, unsigned int dfsc)
+{
+	inject_abt32(vcpu, false, addr, true, dfsc);
 }
 
 void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr)
 {
-	inject_abt32(vcpu, true, addr);
+	inject_abt32(vcpu, true, addr, false, 0);
 }
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
