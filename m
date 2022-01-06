Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C02C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06FEA49F40;
	Wed,  5 Jan 2022 23:28:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KknV5E8LbTpC; Wed,  5 Jan 2022 23:28:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0FEF49F26;
	Wed,  5 Jan 2022 23:28:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FA6049EEE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VO4BvZkl4Nhv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:41 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4540D40BE6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:40 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 f11-20020a17090a664b00b001b0fbffc9d6so1030006pjm.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iggCERYPvKZzkmiH5L0dJnOh5/4oawtODr5G6JGC3EA=;
 b=mVLqwj6g6bvq57fUaSXBKokDOk+Vl5QV/c2R0889pzyzfCBoA/raBr27Y7kswkDDvt
 wCDfvRtxY/zyAeZZpDDG6FaHhPoAsHlTPkalAKLnRzJSHDPdJBhM+95Oc37OOpPNILcg
 XJQblN1T7v+0cS6yn+I85idg1qCUXVRBP/sKXhl0gKeZysvAhhVQqLZ/AA4DHQwrbePb
 s8vCdjD+phywxu/FGU3qwT6KZ4N/E7IAJW/Q9jWJr5q0fFXjEVz4nMKM/ULNrtzDFP59
 Gs7JiJpDxpAcEoQqEGZBABmMH3cUOOzEu/PL9UWJC/RjpX69PO75BPiBBuXuTIbRRwRD
 DHKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iggCERYPvKZzkmiH5L0dJnOh5/4oawtODr5G6JGC3EA=;
 b=XHBuBFV71kpDbHiSIuSM1ey2dm36BNARBRqnXQIkRIk5IeCZBTPscqWHVJ8KxV6hkM
 9+eUKm4at27IehsvX6iI6H+ez/s5XWVIe1P18qIV3qmnsjKHEtCjxT83tISzG8CZvyVt
 +UTXEdKx4aYrrbm+t5lMXW9IrUeVIu34gFGKaH9crN+Gnd2w2j3KDLg9+vASwbh44g7F
 MQG6JWqoaTRtQFVGQ1uj9cSnFuBLujm+2o9BqZcZJO9r7iuwafcmZcQ8WJFQQD0T75qw
 H12o+wT0pQOgUffLVN1Wvb79NhCu+2P5cnwefMD+wS0PRbtqbE+Phf0qnreQX4bhJhcR
 o6bg==
X-Gm-Message-State: AOAM530mcwRenv82FraLCcYilhQ0IwdReOCZ5UqCGQ9EKp1vRS2HK7G/
 B5bKV23Dtalcj2eD/Tf3qIdOjH92MCw=
X-Google-Smtp-Source: ABdhPJxDhvY2RCuxPGDkqE5OOdzgA9LIz2uvcajr4q2pHOtqqx/TF2sfgcMcvVhIt9btg/jJEMB+aQVz7pA=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:2a4e:: with SMTP id
 d14mr528686pjg.0.1641443319139; Wed, 05 Jan 2022 20:28:39 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:48 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 06/26] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64ISAR0_EL1 to make it writable
by userspace.

Updating sm3, sm4, sha1, sha2 and sha3 fields are allowed only
if values of those fields follow Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ae9ca341a2e4..3f1313875be5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
+{
+	unsigned int sm3, sm4, sha1, sha2, sha3;
+
+	/* Run consistency checkings according to Arm ARM */
+	sm3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM3_SHIFT);
+	sm4 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM4_SHIFT);
+	if (sm3 != sm4)
+		return -EINVAL;
+
+	sha1 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA1_SHIFT);
+	sha2 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA2_SHIFT);
+	if ((sha1 == 0) ^ (sha2 == 0))
+		return -EINVAL;
+
+	sha3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA3_SHIFT);
+	if (((sha2 == 2) ^ (sha3 == 1)) || (!sha1 && sha3))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -441,6 +464,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
 };
 
+static struct id_reg_info id_aa64isar0_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR0_EL1,
+	.validate = validate_id_aa64isar0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -452,6 +480,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
