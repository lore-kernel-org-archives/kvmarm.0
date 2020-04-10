Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B7EC2BB86
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 09:42:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2284C20801
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 09:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3WRcfFg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2284C20801
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C228D4B1C2;
	Fri, 10 Apr 2020 05:42:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 67KyRDw2OoRs; Fri, 10 Apr 2020 05:42:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B9A4B1CD;
	Fri, 10 Apr 2020 05:42:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 288CA4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 04:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k0V4EMPv6py0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 04:59:02 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DF914B17E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 04:59:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586509141;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SzgzXE9lIE0M6eWgr4KWBqqpXLesWeBSkINGyFAQgss=;
 b=P3WRcfFgJcBkNoPuKJhiIqWQzQSiWTo3gxCJMkEk0hiR56G1QypoCtiUqbpPD4MXFwh8VB
 a5hLGs+AZLG2kzg6M6BcGubyJ96MPvVNsChuYEr3479KNkuSln2XW72skcwY0bE6kdeooH
 PenCNjcWI5SCa986vH7XQfPv0bB4ZLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-EQrlD14EPgO8CZcFEs4j6w-1; Fri, 10 Apr 2020 04:59:00 -0400
X-MC-Unique: EQrlD14EPgO8CZcFEs4j6w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 944C18017FC;
 Fri, 10 Apr 2020 08:58:58 +0000 (UTC)
Received: from 192-168-1-115.tpgi.com.com (vpn2-54-29.bne.redhat.com
 [10.64.54.29])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5BA605E001;
 Fri, 10 Apr 2020 08:58:54 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH RFCv1 3/7] kvm/arm64: Replace hsr with esr
Date: Fri, 10 Apr 2020 18:58:16 +1000
Message-Id: <20200410085820.758686-4-gshan@redhat.com>
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

This replace the variable names to make them self-explaining. The
tracepoint isn't changed accordingly because they're part of ABI:

   * @hsr to @esr
   * @hsr_ec to @ec
   * Use kvm_vcpu_trap_get_class() helper if possible

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/handle_exit.c | 28 ++++++++++++++--------------
 arch/arm64/kvm/hyp/switch.c  |  9 ++++-----
 arch/arm64/kvm/sys_regs.c    | 30 +++++++++++++++---------------
 3 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 00858db82a64..e3b3dcd5b811 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -123,13 +123,13 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
  */
 static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	u32 hsr = kvm_vcpu_get_esr(vcpu);
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	int ret = 0;
 
 	run->exit_reason = KVM_EXIT_DEBUG;
-	run->debug.arch.hsr = hsr;
+	run->debug.arch.hsr = esr;
 
-	switch (ESR_ELx_EC(hsr)) {
+	switch (kvm_vcpu_trap_get_class(esr)) {
 	case ESR_ELx_EC_WATCHPT_LOW:
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
 		/* fall through */
@@ -139,8 +139,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	case ESR_ELx_EC_BRK64:
 		break;
 	default:
-		kvm_err("%s: un-handled case hsr: %#08x\n",
-			__func__, (unsigned int) hsr);
+		kvm_err("%s: un-handled case esr: %#08x\n",
+			__func__, (unsigned int)esr);
 		ret = -1;
 		break;
 	}
@@ -150,10 +150,10 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	u32 hsr = kvm_vcpu_get_esr(vcpu);
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 
-	kvm_pr_unimpl("Unknown exception class: hsr: %#08x -- %s\n",
-		      hsr, esr_get_class_string(hsr));
+	kvm_pr_unimpl("Unknown exception class: esr: %#08x -- %s\n",
+		      esr, esr_get_class_string(esr));
 
 	kvm_inject_undefined(vcpu);
 	return 1;
@@ -230,10 +230,10 @@ static exit_handle_fn arm_exit_handlers[] = {
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 {
-	u32 hsr = kvm_vcpu_get_esr(vcpu);
-	u8 hsr_ec = ESR_ELx_EC(hsr);
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 ec = kvm_vcpu_trap_get_class(esr);
 
-	return arm_exit_handlers[hsr_ec];
+	return arm_exit_handlers[ec];
 }
 
 /*
@@ -273,15 +273,15 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	if (ARM_SERROR_PENDING(exception_index)) {
 		u32 esr = kvm_vcpu_get_esr(vcpu);
-		u8 hsr_ec = ESR_ELx_EC(esr);
+		u8 ec = kvm_vcpu_trap_get_class(esr);
 
 		/*
 		 * HVC/SMC already have an adjusted PC, which we need
 		 * to correct in order to return to after having
 		 * injected the SError.
 		 */
-		if (hsr_ec == ESR_ELx_EC_HVC32 || hsr_ec == ESR_ELx_EC_HVC64 ||
-		    hsr_ec == ESR_ELx_EC_SMC32 || hsr_ec == ESR_ELx_EC_SMC64) {
+		if (ec == ESR_ELx_EC_HVC32 || ec == ESR_ELx_EC_HVC64 ||
+		    ec == ESR_ELx_EC_SMC32 || ec == ESR_ELx_EC_SMC64) {
 			u32 adj =  kvm_vcpu_trap_il_is32bit(esr) ? 4 : 2;
 			*vcpu_pc(vcpu) -= adj;
 		}
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 369f22f49f3d..7bf4840bf90e 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -356,8 +356,8 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
 	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 ec = kvm_vcpu_trap_get_class(esr);
 	bool vhe, sve_guest, sve_host;
-	u8 hsr_ec;
 
 	if (!system_supports_fpsimd())
 		return false;
@@ -372,14 +372,13 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		vhe = has_vhe();
 	}
 
-	hsr_ec = kvm_vcpu_trap_get_class(esr);
-	if (hsr_ec != ESR_ELx_EC_FP_ASIMD &&
-	    hsr_ec != ESR_ELx_EC_SVE)
+	if (ec != ESR_ELx_EC_FP_ASIMD &&
+	    ec != ESR_ELx_EC_SVE)
 		return false;
 
 	/* Don't handle SVE traps for non-SVE vcpus here: */
 	if (!sve_guest)
-		if (hsr_ec != ESR_ELx_EC_FP_ASIMD)
+		if (ec != ESR_ELx_EC_FP_ASIMD)
 			return false;
 
 	/* Valid trap.  Switch the context: */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 012fff834a4b..58f81ab519af 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2182,10 +2182,10 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 				struct sys_reg_params *params)
 {
 	u32 esr = kvm_vcpu_get_esr(vcpu);
-	u8 hsr_ec = kvm_vcpu_trap_get_class(esr);
+	u8 ec = kvm_vcpu_trap_get_class(esr);
 	int cp = -1;
 
-	switch(hsr_ec) {
+	switch (ec) {
 	case ESR_ELx_EC_CP15_32:
 	case ESR_ELx_EC_CP15_64:
 		cp = 15;
@@ -2216,17 +2216,17 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 			    size_t nr_specific)
 {
 	struct sys_reg_params params;
-	u32 hsr = kvm_vcpu_get_esr(vcpu);
-	int Rt = kvm_vcpu_sys_get_rt(hsr);
-	int Rt2 = (hsr >> 10) & 0x1f;
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	int Rt = kvm_vcpu_sys_get_rt(esr);
+	int Rt2 = (esr >> 10) & 0x1f;
 
 	params.is_aarch32 = true;
 	params.is_32bit = false;
-	params.CRm = (hsr >> 1) & 0xf;
-	params.is_write = ((hsr & 1) == 0);
+	params.CRm = (esr >> 1) & 0xf;
+	params.is_write = ((esr & 1) == 0);
 
 	params.Op0 = 0;
-	params.Op1 = (hsr >> 16) & 0xf;
+	params.Op1 = (esr >> 16) & 0xf;
 	params.Op2 = 0;
 	params.CRn = 0;
 
@@ -2273,18 +2273,18 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 			    size_t nr_specific)
 {
 	struct sys_reg_params params;
-	u32 hsr = kvm_vcpu_get_esr(vcpu);
-	int Rt  = kvm_vcpu_sys_get_rt(hsr);
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	int Rt = kvm_vcpu_sys_get_rt(esr);
 
 	params.is_aarch32 = true;
 	params.is_32bit = true;
-	params.CRm = (hsr >> 1) & 0xf;
+	params.CRm = (esr >> 1) & 0xf;
 	params.regval = vcpu_get_reg(vcpu, Rt);
-	params.is_write = ((hsr & 1) == 0);
-	params.CRn = (hsr >> 10) & 0xf;
+	params.is_write = ((esr & 1) == 0);
+	params.CRn = (esr >> 10) & 0xf;
 	params.Op0 = 0;
-	params.Op1 = (hsr >> 14) & 0x7;
-	params.Op2 = (hsr >> 17) & 0x7;
+	params.Op1 = (esr >> 14) & 0x7;
+	params.Op2 = (esr >> 17) & 0x7;
 
 	if (!emulate_cp(vcpu, &params, target_specific, nr_specific) ||
 	    !emulate_cp(vcpu, &params, global, nr_global)) {
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
