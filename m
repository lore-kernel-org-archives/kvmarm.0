Return-Path: <SRS0=CLsl=Z2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2CEC2D0B1
	for <kvmarm@archiver.kernel.org>; Wed,  4 Dec 2019 20:44:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE8322073B
	for <kvmarm@archiver.kernel.org>; Wed,  4 Dec 2019 20:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HzLtdA3k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE8322073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C024AEEE;
	Wed,  4 Dec 2019 15:44:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZdkPAV47ibMC; Wed,  4 Dec 2019 15:44:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6DF4AEE0;
	Wed,  4 Dec 2019 15:44:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F0034AC07
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Dec 2019 15:44:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XEv9RqaFpJlX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Dec 2019 15:44:53 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D0864AF03
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Dec 2019 15:44:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575492292;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1HSSxylw+ml72S+tggNSNZjvCbGfb9EILB6DT2G4aGg=;
 b=HzLtdA3kQ49KuyG1St4386WLneAJXgpVdPDiBdlBJLTik8qk+nwlppIUXcDOynSgCkDy8m
 yj+RcsyZG/mWJsVnIio4orveN5m8KGFyGpxjny8HDOSeo546ew0dHL9YNHASZ7SzsvX/uG
 PnNXyjE+5rgQJGzkZhlYEYPaGUWpWVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-mZ8JF3-HOMaWnAVM9fm54Q-1; Wed, 04 Dec 2019 15:44:51 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54E4D1005502;
 Wed,  4 Dec 2019 20:44:50 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9C9C869192;
 Wed,  4 Dec 2019 20:44:47 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [RFC 3/3] KVM: arm64: pmu: Enforce PMEVTYPER evtCount size
Date: Wed,  4 Dec 2019 21:44:26 +0100
Message-Id: <20191204204426.9628-4-eric.auger@redhat.com>
In-Reply-To: <20191204204426.9628-1-eric.auger@redhat.com>
References: <20191204204426.9628-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: mZ8JF3-HOMaWnAVM9fm54Q-1
X-Mimecast-Spam-Score: 0
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

ARMv8.1-PMU supports 16-bit evtCount whereas 8.0 only supports
10 bits.

On Seatlle which has an 8.0 PMU implementation, evtCount[15:10]
are not read as 0, as expected. Fix that by applying a mask on
the selected event that depends on the PMU version.

Also remove a redundant __vcpu_sys_reg() assignment (already
done in kvm_pmu_set_counter_even_type()).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/include/asm/perf_event.h |  5 ++++-
 arch/arm64/include/asm/sysreg.h     |  5 +++++
 arch/arm64/kernel/perf_event.c      |  2 +-
 arch/arm64/kvm/sys_regs.c           | 14 ++++++++++----
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index 2bdbc79bbd01..37ad1d654d2a 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -189,7 +189,10 @@
 /*
  * PMXEVTYPER: Event selection reg
  */
-#define	ARMV8_PMU_EVTYPE_MASK	0xc800ffff	/* Mask for writable bits */
+/* Mask for writable bits featuring 10b evtCount (ARMv8.0-PMU)*/
+#define	ARMV8_PMU_EVTYPE_MASK	0xc80003ff
+/* Mask for writable bits featuring 16b evtCount (ARMv8.1-PMU)*/
+#define ARMV8_1_PMU_EVTYPE_MASK	0xc800ffff
 #define	ARMV8_PMU_EVTYPE_EVENT	0xffff		/* Mask for EVENT bits */
 
 /*
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6e919fafb43d..e01b3e3acdf6 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -672,6 +672,11 @@
 #define ID_AA64DFR0_TRACEVER_SHIFT	4
 #define ID_AA64DFR0_DEBUGVER_SHIFT	0
 
+#define ID_AA64DFR0_PMUVER_NOT_IMPL	0x0
+#define ID_AA64DFR0_PMUVER_8_0		0x1
+#define ID_AA64DFR0_PMUVER_8_1		0x4
+#define ID_AA64DFR0_PMUVER_IMPL_DEF	0xF
+
 #define ID_ISAR5_RDM_SHIFT		24
 #define ID_ISAR5_CRC32_SHIFT		16
 #define ID_ISAR5_SHA2_SHIFT		12
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index e40b65645c86..d5fe56190ad3 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -425,7 +425,7 @@ static void armv8pmu_write_counter(struct perf_event *event, u64 value)
 static inline void armv8pmu_write_evtype(int idx, u32 val)
 {
 	armv8pmu_select_counter(idx);
-	val &= ARMV8_PMU_EVTYPE_MASK;
+	val &= ARMV8_1_PMU_EVTYPE_MASK;
 	write_sysreg(val, pmxevtyper_el0);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 46822afc57e0..8deb6485d605 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -815,11 +815,17 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
-	u64 idx, reg;
+	unsigned int pmuver;
+	u64 idx, reg, dfr0, evtype_mask;
 
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	pmuver = cpuid_feature_extract_unsigned_field(dfr0,
+						      ID_AA64DFR0_PMUVER_SHIFT);
+	evtype_mask = (pmuver == ID_AA64DFR0_PMUVER_8_0) ?
+			ARMV8_PMU_EVTYPE_MASK : ARMV8_1_PMU_EVTYPE_MASK;
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -842,11 +848,11 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return false;
 
 	if (p->is_write) {
-		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
-		__vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_PMU_EVTYPE_MASK;
+		kvm_pmu_set_counter_event_type(vcpu,
+					       p->regval & evtype_mask, idx);
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_MASK;
+		p->regval = __vcpu_sys_reg(vcpu, reg) & evtype_mask;
 	}
 
 	return true;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
