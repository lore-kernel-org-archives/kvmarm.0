Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A704C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 030FF4B1F1;
	Tue, 19 Apr 2022 02:57:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CLC0fK+w03zL; Tue, 19 Apr 2022 02:57:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E38954B235;
	Tue, 19 Apr 2022 02:57:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6627E4B1D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2IEAzZ0IAYTJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:37 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52A334B1D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:36 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 s2-20020a17090302c200b00158ea215fa2so4278553plk.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=k1aHxZoAaiwp9IBNDG6Sd3gJpxfpCorD51sV50ZX1Is=;
 b=Jli11xd8mqtWlIpeSa3R9uzukrE3588Wd4QhntxW82Bu/d8zHdDqy5Vnvhjai2huOG
 ctO1oRjeEaWQimFertWBqamfLaap9CKRToZztNwFW6AE5f77/xW9p6paFim7Eh7qvzSO
 ebE76Z2+yGh8wGatmYbFF/t13Q+dURYNiYoKJpRw2q7/OEK020kfrOfRxaTFtD8m1pBL
 ktAWStxHUd0QTBBINHesSzJ4IiTrb13R5/APAq0j6EGDHxYbYy5APaRw13Y0xyseo7hY
 rD7XzK+d9NrLLA43JNxU1nQ1vNk3faa9dqHy9TI1prJnH+RtsxwhlLg2kiKVaTaiNKH/
 mlng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=k1aHxZoAaiwp9IBNDG6Sd3gJpxfpCorD51sV50ZX1Is=;
 b=ATtPvKmloL/DauRtxbX5vVNL42NXdq/vShG1OGgQ3hqA198jWuE1o+p+cLVZTTBzRx
 8H8vV/T/VdsUn0wg4Mlmfk5aLgq+ABSaD7hYHZbhzmJ7kgyN1Eyv3b4ubibwNPDF0lo3
 NyX2nt9jVfkNiyf1T+t98+KBag0oeRoSo0xrrKlgrzAbe+fr/qeb+j9L/B3v1siRxU4l
 76C5wOAGxy731ATxpHcfniBwf1IYCNMsiGa2OPopraVrXCxYlE6rjWPvZiZhIMJSn3Od
 3Yg7zPv9tqRabu/Agk4uG6UNuPP6/SmZp2D+UZd43PtEGESkSMWefbUxShfoBtZUlKY9
 XHxQ==
X-Gm-Message-State: AOAM530QeaIqqxMlgeGQt/gO3kDlHejbjvuypbm1WD1NqQmv1JS+Ik16
 C+MVulDkXdBBxm3d28jYqK+GTr/1n3w=
X-Google-Smtp-Source: ABdhPJw4BjqWGKNFLnPZMZUC1+9yLnqihHWKtPmY8zD8R5Ja1UK3sVAaay5AnyQvY9iXieVJivmijHyA5sg=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:2349:b0:4fa:934f:f6db with SMTP id
 j9-20020a056a00234900b004fa934ff6dbmr16170589pfj.44.1650351455448; Mon, 18
 Apr 2022 23:57:35 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:24 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-19-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 18/38] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_desc for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dfcf95eee139..9e090441057a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -723,6 +723,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_desc *id_reg, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -4157,6 +4187,11 @@ static struct id_reg_desc id_mmfr0_el1_desc = {
 	},
 };
 
+static struct id_reg_desc mvfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(MVFR1_EL1),
+	.validate = validate_mvfr1_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -4167,6 +4202,7 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	ID_DESC(ID_MMFR0_EL1, &id_mmfr0_el1_desc),
 
 	/* CRm=3 */
+	ID_DESC(MVFR1_EL1, &mvfr1_el1_desc),
 	ID_DESC(ID_DFR1_EL1, &id_dfr1_el1_desc),
 
 	/* CRm=4 */
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
