Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35520C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D777163222
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D777163222
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8982A4B0BA;
	Wed, 17 Nov 2021 01:53:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kQ9icz+mS0ay; Wed, 17 Nov 2021 01:53:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E3644B0D7;
	Wed, 17 Nov 2021 01:53:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 852234B0BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qFEv6XlODcGe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:15 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 300B44A7FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:15 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 gf12-20020a17090ac7cc00b001a968c11642so854735pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SC5T9znPBLTNrmN/sDQzNw6Ub+Qjzd3qc7h2EDRdpsw=;
 b=g/3NbKzHcUiXa+m/7cvTZ1xTKPYSz37HHs47wNPYPhkDUo2NjRSjilyLwR4i+nLrVY
 k0CyX97TWk0Ody6mji2CZ9wWp/OcbHpfT4FtJsU1gbn77p2NN7zZtfirQFP8PPlYzo20
 YUfM7RQLCGQ6yDYJEdVosYHXiP07cGB1dOF/k4W92QCz4TZq+K5R1vc8xRxXvio+osdY
 EQUK9mid9FV0hbYPr+2j51+1uvBX/aVW4JJCmwY5C/TFtfjmSwhvueqc2g4XdxRV1RNc
 9ei+QRh2fRv8siqh7/suv9Icey8MMkuKJH9+w84TprS+t0kZ0ym6L1+IAhlfY/I0lCPJ
 ASUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SC5T9znPBLTNrmN/sDQzNw6Ub+Qjzd3qc7h2EDRdpsw=;
 b=7og8z4QyM3zlEDO+7tmEJcDKMLm5T8u7MU3NL7OtNzbILLb/ydRBdkwn70zysxfj+9
 IefWUIpjeSwuBiQBi5x/t4iIgl8cMSoba/OfoU8Y905xswl2unWG2QLFRKs8lWyzEgC7
 p5Y3ajDMUFfMrgZmFqL++2K8GQvLX3KjFoEaRyNRhdWJPnqgIsXXL0XPLY4wI0BIfQIJ
 VBaIVgWNxMdR2oimLCgRL3sWx1bmzDgZGm+pukNbCH2BLpK78ar/oORWC5X/uKrmdvWZ
 qh3sxqzdt25qXT2iA+nWs77uEAcYl0Od9wo3tJP9fu5DSTfTqLm88NAcLqKARM48VEJl
 /zbA==
X-Gm-Message-State: AOAM531SLNbsSHwjOt5PSCCnABsruJr5nEyUuV4awRRWlTwLajjTOViI
 sPDfFBskB87SwM4UxfkAnAkaqLdXa70=
X-Google-Smtp-Source: ABdhPJzxco6E3AqetETiY0RA3xGyLBBSVtg3Qx53KDDwdkXujTql0gFgly7E7xEMCFlAmqMkTH074Ke6ZUQ=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:c58e:: with SMTP id
 l14mr6765135pjt.214.1637131993894; Tue, 16 Nov 2021 22:53:13 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:41 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-12-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 11/29] KVM: arm64: Make ID_DFR0_EL1 writable
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

This patch adds id_reg_info for ID_DFR0_EL1 to make it writable
by userspace.

Return an error if userspace tries to set PerfMon field of the
register to a value that conflicts with the PMU configuration.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 52 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0faf458b0efb..fbd335ac5e6b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -665,6 +665,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				const struct id_reg_info *id_reg, u64 val)
+{
+	bool vcpu_pmu, dfr0_pmu;
+	unsigned int perfmon;
+
+	perfmon = cpuid_feature_extract_unsigned_field(val, ID_DFR0_PERFMON_SHIFT);
+	if (perfmon == 1 || perfmon == 2)
+		/* PMUv1 or PMUv2 is not allowed on ARMv8. */
+		return -EINVAL;
+
+	vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	dfr0_pmu = id_reg_has_pmu(val, ID_DFR0_PERFMON_SHIFT, ID_DFR0_PERFMON_8_0);
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_pmu ^ dfr0_pmu)
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -725,6 +746,15 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_dfr0_el1_info(struct id_reg_info *id_reg)
+{
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	id_reg->vcpu_limit_val =
+		cpuid_feature_cap_perfmon_field(id_reg->vcpu_limit_val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_4);
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     const struct id_reg_info *idr)
 {
@@ -762,6 +792,14 @@ static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
 }
 
+static u64 get_reset_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				 const struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_DFR0_PERFMON)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
@@ -814,6 +852,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.get_reset_val = get_reset_id_aa64dfr0_el1,
 };
 
+static struct id_reg_info id_dfr0_el1_info = {
+	.sys_reg = SYS_ID_DFR0_EL1,
+	.init = init_id_dfr0_el1_info,
+	.validate = validate_id_dfr0_el1,
+	.get_reset_val = get_reset_id_dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -823,6 +868,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
@@ -1677,12 +1723,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
 		}
 		break;
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
 	}
 
 	return val;
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
