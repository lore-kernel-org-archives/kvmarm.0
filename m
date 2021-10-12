Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE93C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6315861074
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6315861074
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 199444B0E2;
	Tue, 12 Oct 2021 00:36:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1eCHsivKjVY7; Tue, 12 Oct 2021 00:36:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1CDB4B128;
	Tue, 12 Oct 2021 00:36:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 639BC4B11B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BSx9gJknW0Na for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:38 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1FD64B0DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:36 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 u5-20020a63d3450000b029023a5f6e6f9bso8017400pgi.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cwGN9Xe3XWxW643nb96+bXhhQ/Ir7xJT1HwtMeHM7cQ=;
 b=DBUBOXq/KtFBlinyQ1LBw4GMEMeHuJzh2MUTnjINtr2KUrltQAUA/+vj8wI0Fk5ST3
 XiWsa2domVcF8x4i7LPxC0hj8GAwn/DPal9Zqj1qoljPzYPMatgwIia0NMQQqWKOxdYE
 LeLft6vpRTZbBcHr0bemhAlKRQCe5qJgGwKhn2+w35t4snNcehqQb2g0rsw1RIOdYFU9
 bAiPujoV+AaVBXHt8l6+A821yQN76n/5eHRiIh9+1xoDs8dHcReaRoDiKfQOBKkSwGZP
 HVYmsNdv0YnE0MVnp1hIZAk+puV5zvweS0KhO09Xkis/O6oEEaP7NKkHSlBTNJZEgphI
 qdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cwGN9Xe3XWxW643nb96+bXhhQ/Ir7xJT1HwtMeHM7cQ=;
 b=1VLwTK5kMz5/OMMZrPXL6/W+Y1zTOp/ev4re8ZBSdH1e2O1YVJfzj5TvZ884Udg4f/
 u2Xhps4OTRO16ZwjL+wBgS3mbkdzTePjtIXAa0dx8MASfBTvVF6Nx/+C7JQ7xL3uwqyq
 8lqokpZ75+uWLTvrCplgB5hWtRtM7LtOjGC0YocJAAJaiafj1P/l4jdXOlC0N/198Dbv
 UFD5Z79V3j54TKKEMFBXfS2MFD5FDZO0RXzWIjyeqbcYrRHL3IneJUwSHUoWB22zufeg
 89kVu/rjoMWbOFurcBnDpS/tH+bOibCDrI549mg+1UaBWpi3CnjzJLDN5ZFDnV8Qydeu
 6mKw==
X-Gm-Message-State: AOAM532TdVEydwXl0MC7RJF+9cUlrsT7g3RpLNG3v1vyCA9eGq/taB3V
 qdXlQSRCQwn5+uj5/0SqzXzIgC9dCq8=
X-Google-Smtp-Source: ABdhPJy8CGkD4X+vedywWNr5lgYqfM+G5c5VEXo+GN+CPYbQ23SjsxTScLeFIEMAadLh5UzZSK8h53NYvAg=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:8b8d:: with SMTP id
 z13mr296126pjn.0.1634013395790; Mon, 11 Oct 2021 21:36:35 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:21 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-12-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 11/25] KVM: arm64: Make ID_DFR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 57 +++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 61e61f4bb81c..84c064dfc63a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -442,6 +442,25 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	bool vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	unsigned int perfmon = cpuid_feature_extract_unsigned_field(val,
+						ID_DFR0_PERFMON_SHIFT);
+	bool dfr0_pmu = id_reg_has_pmu(val, ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_0);
+
+	if (perfmon == 1 || perfmon == 2)
+		/* PMUv1 or PMUv2 is not allowed on ARMv8. */
+		return -EINVAL;
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
 	u64 limit;
@@ -526,6 +545,16 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_dfr0_el1_info(struct id_reg_info *id_reg)
+{
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	id_reg->vcpu_limit_val = id_reg_cap_pmu(id_reg->sys_val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_4);
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     struct id_reg_info *idr)
 {
@@ -557,6 +586,14 @@ static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
 }
 
+static u64 get_reset_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				 struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_DFR0_PERFMON)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.init = init_id_aa64pfr0_el1_info,
@@ -593,6 +630,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
@@ -602,6 +646,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
@@ -1440,18 +1485,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = reg_to_encoding(r);
-	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
-	switch (id) {
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
-	}
-
-	return val;
+	return raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 }
 
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
