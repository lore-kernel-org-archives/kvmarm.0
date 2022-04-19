Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA275C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9759E4B1D4;
	Tue, 19 Apr 2022 02:57:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tdfmDOHk1iCm; Tue, 19 Apr 2022 02:57:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 159174B22A;
	Tue, 19 Apr 2022 02:57:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90C804B190
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HK2rjdEzsy4s for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:37 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0E8C49EF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:37 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 m11-20020a170902f64b00b0015820f8038fso9223405plg.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XAe9o8/7QtvwA7T4kzsz7p8aDgk6j+Di6GgUS4L29XQ=;
 b=bjp6ZxrGAh7052Gw6Xdmrg+7KZKA2uAnPjBgjXkIw2dFvt7G7LE/TTe8/W3Oj57ExI
 cZYBHWsYxkJIQ7lHFYgAKKcsok3iLVBUXssHXQQQ655fJ2DAs1rIPQ936ssjYaDW5leP
 74OrsDeIahHKz5IKhc/qqk97SKOd4YF0gSsM2oRzjAKfleXT3nu/pB8ojlS0R+IA2MFb
 oN9GtMZPUdiMTKCBf2adntBJFKoPdzlR+R0bKWByFsr3b4kJw9P/zVfmY19IQAQJ+qut
 DV2weGfw90L/YB66aNJH8bfLF+/l6o4j7hpIPYdJMMBKUSgC5sOMHQ0BYi1Zjo5kIT7c
 BZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XAe9o8/7QtvwA7T4kzsz7p8aDgk6j+Di6GgUS4L29XQ=;
 b=IgwITjeSu1xzUpYqBvn0SgjzS3KkaZSMTEJ68VO6u5GqegN7gq7mwzJRCDUamCG9u8
 gX1JhfqNUZrihncdEZf0XlBv7GDwh5HijdjUGH/wTqZzTKcodfxV39FwVpVo0AxuVSVC
 n91MJwZPoio4T4Ig2TZVhoER4kYe4bh9pKSoMUfj29a7A76eCc8EAsdNTUmD/o7K1wiQ
 2qOZ7IN9MJKoYllpjWEvshvDOH0PLFoI9anEXYqD0k1v3mC6wJPmg4vQjKpQ7EhXDRId
 YU7Z5mcu7bPgSCJWaDCuq8D4n1k6PhT+FxePB7U6ef4FPrprBiNk0jtPbrtcxrqJ3kUu
 6ZLA==
X-Gm-Message-State: AOAM533B47tkJ4OZUgm9xSo3xaOjK3SzdTt78fXTYK28/cicz57dYlAz
 eL8Or1MJSd9xJ/LEIF4kRziQkxZVnZc=
X-Google-Smtp-Source: ABdhPJxlcowD6T6yPgHuseBL0ofs+MsqwJykl/a/FrUlFopUkhnFg/TqdMwK8KVyg1eylJC4AC624op+zHg=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:b89:b0:505:dead:db1d with SMTP id
 g9-20020a056a000b8900b00505deaddb1dmr16566920pfj.74.1650351456883; Mon, 18
 Apr 2022 23:57:36 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:25 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-20-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 19/38] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
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

Add hidden or reserved ID registers, and remaining ID registers,
which don't require special handling, to id_reg_desc_table.
Add 'flags' field to id_reg_desc, which is used to indicates hiddden
or reserved registers. Since now id_reg_desc_init() is called even
for hidden/reserved registers, change it to not do anything for them.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 84 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9e090441057a..479208dedd79 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -331,6 +331,11 @@ struct id_reg_desc {
 	/* Fields that are not validated by arm64_check_features. */
 	u64	ignore_mask;
 
+	/* Miscellaneous flags */
+#define ID_DESC_REG_UNALLOC	(1UL << 0)
+#define ID_DESC_REG_HIDDEN	(1UL << 1)
+	u64	flags;
+
 	/* An optional initialization function of the id_reg_desc */
 	void (*init)(struct id_reg_desc *id_reg);
 
@@ -376,8 +381,13 @@ struct id_reg_desc {
 static void id_reg_desc_init(struct id_reg_desc *id_reg)
 {
 	u32 id = reg_to_encoding(&id_reg->reg_desc);
-	u64 val = read_sanitised_ftr_reg(id);
+	u64 val;
+
+	if (id_reg->flags & (ID_DESC_REG_HIDDEN | ID_DESC_REG_UNALLOC))
+		/* Nothing to do for a hidden/unalloc ID register */
+		return;
 
+	val = read_sanitised_ftr_reg(id);
 	id_reg->vcpu_limit_val = val;
 
 	id_reg_desc_init_ftr(id_reg);
@@ -4192,33 +4202,103 @@ static struct id_reg_desc mvfr1_el1_desc = {
 	.validate = validate_mvfr1_el1,
 };
 
+#define ID_DESC_DEFAULT(name)					\
+	[IDREG_IDX(SYS_##name)] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_SANITISED(name),			\
+	}
+
+#define ID_DESC_HIDDEN(name)					\
+	[IDREG_IDX(SYS_##name)] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_HIDDEN(name),			\
+		.flags = ID_DESC_REG_HIDDEN,			\
+	}
+
+#define ID_DESC_UNALLOC(crm, op2)				\
+	[(crm - 1) << 3 | op2] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_UNALLOCATED(crm, op2),		\
+		.flags = ID_DESC_REG_UNALLOC,			\
+	}
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
-/* A table for ID registers's information. */
+/*
+ * A table for ID registers's information.
+ * All entries in the table except ID_DESC_HIDDEN and ID_DESC_UNALLOC
+ * must have corresponding entries in arm64_ftr_regs[] in
+ * arch/arm64/kernel/cpufeature.c because read_sanitised_ftr_reg() is
+ * called for each of the ID registers.
+ */
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
+	ID_DESC_DEFAULT(ID_PFR0_EL1),
+	ID_DESC_DEFAULT(ID_PFR1_EL1),
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
+	ID_DESC_HIDDEN(ID_AFR0_EL1),
 	ID_DESC(ID_MMFR0_EL1, &id_mmfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_MMFR1_EL1),
+	ID_DESC_DEFAULT(ID_MMFR2_EL1),
+	ID_DESC_DEFAULT(ID_MMFR3_EL1),
+
+	/* CRm=2 */
+	ID_DESC_DEFAULT(ID_ISAR0_EL1),
+	ID_DESC_DEFAULT(ID_ISAR1_EL1),
+	ID_DESC_DEFAULT(ID_ISAR2_EL1),
+	ID_DESC_DEFAULT(ID_ISAR3_EL1),
+	ID_DESC_DEFAULT(ID_ISAR4_EL1),
+	ID_DESC_DEFAULT(ID_ISAR5_EL1),
+	ID_DESC_DEFAULT(ID_MMFR4_EL1),
+	ID_DESC_DEFAULT(ID_ISAR6_EL1),
 
 	/* CRm=3 */
+	ID_DESC_DEFAULT(MVFR0_EL1),
 	ID_DESC(MVFR1_EL1, &mvfr1_el1_desc),
+	ID_DESC_DEFAULT(MVFR2_EL1),
+	ID_DESC_UNALLOC(3, 3),
+	ID_DESC_DEFAULT(ID_PFR2_EL1),
 	ID_DESC(ID_DFR1_EL1, &id_dfr1_el1_desc),
+	ID_DESC_DEFAULT(ID_MMFR5_EL1),
+	ID_DESC_UNALLOC(3, 7),
 
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
+	ID_DESC_UNALLOC(4, 2),
+	ID_DESC_UNALLOC(4, 3),
+	ID_DESC_DEFAULT(ID_AA64ZFR0_EL1),
+	ID_DESC_UNALLOC(4, 5),
+	ID_DESC_UNALLOC(4, 6),
+	ID_DESC_UNALLOC(4, 7),
 
 	/* CRm=5 */
 	ID_DESC(ID_AA64DFR0_EL1, &id_aa64dfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64DFR1_EL1),
+	ID_DESC_UNALLOC(5, 2),
+	ID_DESC_UNALLOC(5, 3),
+	ID_DESC_HIDDEN(ID_AA64AFR0_EL1),
+	ID_DESC_HIDDEN(ID_AA64AFR1_EL1),
+	ID_DESC_UNALLOC(5, 6),
+	ID_DESC_UNALLOC(5, 7),
 
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
 	ID_DESC(ID_AA64ISAR2_EL1, &id_aa64isar2_el1_desc),
+	ID_DESC_UNALLOC(6, 3),
+	ID_DESC_UNALLOC(6, 4),
+	ID_DESC_UNALLOC(6, 5),
+	ID_DESC_UNALLOC(6, 6),
+	ID_DESC_UNALLOC(6, 7),
 
 	/* CRm=7 */
 	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64MMFR1_EL1),
+	ID_DESC_DEFAULT(ID_AA64MMFR2_EL1),
+	ID_DESC_UNALLOC(7, 3),
+	ID_DESC_UNALLOC(7, 4),
+	ID_DESC_UNALLOC(7, 5),
+	ID_DESC_UNALLOC(7, 6),
+	ID_DESC_UNALLOC(7, 7),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
