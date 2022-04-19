Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B448C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E82504B203;
	Tue, 19 Apr 2022 02:57:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 711nKMjnSTo7; Tue, 19 Apr 2022 02:57:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2414B1D1;
	Tue, 19 Apr 2022 02:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 977B449F16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AXYHRaNOb+7X for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:13 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D35FD4B1CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:12 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 z88-20020a17090a6d6100b001cb89a1969fso10143976pjj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VJImZSIZ+gG1OFTvYyrxAjCUBTqUqO7tRcl+ZvmmrQU=;
 b=fY034672N11uX9UN7COg34VjlKUqAo7dFya/wOHPBEs1jzO5xKlaqEmIenpptQfc3Z
 UO7slba7gfWUWNvpAFkm02q8WMmVD74ZeN9mCnYt2u2qXBaNDY4yoKJ/OuV+Z3lqdmmz
 W278iSjt45hIPJ+VKUtTyZeNHoo6fojiDaHX4KiwL8XTeN7iX5Gc8A/VbEX/dtjLYPWh
 ToYtzkMaDBmaPztTc/CagS+36DIDmgQw3Pry0pzFNvmBUmLwIjP/b6OljEat0qNHn/Qe
 uQMzg7jaZcRaQlvLVne9u6lapGzQYrEkbFM1BUCEeNf2SItPlzY0vnkCiPTUt9nqpRf2
 xpig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VJImZSIZ+gG1OFTvYyrxAjCUBTqUqO7tRcl+ZvmmrQU=;
 b=RafPI0piHFirwJWBOUw5xh85GS1GGmaD8S6mL7fF6lOAEGSYWEfP4+AZif2PCcJ4AN
 PjggWcJ/WWwaAwaYqpETim8hX+sbxDTqRSYi4IPEQpTmzDFxgxakxCM5R1vtlCrpxMJv
 SiYBV9SRXbCiHnjmkHA+wE4XhiX6Kcyq2O0ypUxL3zAsJC18wWjtD76D/n7mJKBWWLkY
 c04BlTY45RbEjsYKDNgr5XVPh3OhKaGVnWkbsMvnpxDMiVODZZdywrpNIShXcyqxu+Sc
 OSi8Qjdplzjbu8d691+9LJfI+qddkd3IBE3vcVmwkZRPoPcEmYfk6un/HUvyeJ3KxQzZ
 shfw==
X-Gm-Message-State: AOAM5323x2UuhMPrYKi5tuL4qoEYQnLblWkcUulCyBUkdChuL/0Hua60
 lGdPKox+sA724a1nmI35X50pWcn90U4=
X-Google-Smtp-Source: ABdhPJwcF9IGP+oXjWqN513CFHPTbOhEPIcFqBvtuNUAEogsKCaN3cLS4dsvrgirt3TnfNpD+Muf6CEieGo=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:10d0:b0:4f7:5af4:47b6 with SMTP id
 d16-20020a056a0010d000b004f75af447b6mr16187254pfu.6.1650351431964; Mon, 18
 Apr 2022 23:57:11 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:10 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-5-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 04/38] KVM: arm64: Generate id_reg_desc's ftr_bits at KVM
 init when needed
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

Most of entries in ftr_bits[] of id_reg_desc will be UNSIGNED+LOWER_SAFE.
Use that as the default arm64_ftr_bits for any entries that are not
statically defined in ftr_bits[] so that we don't have to statically
define every single UNSIGNED+LOWER_SAFE entry.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30adc19e4619..b19e14a1206a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -35,6 +35,7 @@
 
 static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
 static inline struct id_reg_desc *get_id_reg_desc(u32 id);
+static void id_reg_desc_init_ftr(struct id_reg_desc *idr);
 
 /*
  * All of this file is extremely similar to the ARM coproc.c, but the
@@ -325,6 +326,8 @@ struct id_reg_desc {
 	 * Used to validate the ID register values with arm64_check_features().
 	 * The last item in the array must be terminated by an item whose
 	 * width field is zero as that is expected by arm64_check_features().
+	 * Entries that are not statically defined will be generated as
+	 * UNSIGNED+LOWER_SAFE entries during KVM's initialization.
 	 */
 	struct arm64_ftr_bits	ftr_bits[FTR_FIELDS_NUM];
 };
@@ -335,6 +338,9 @@ static void id_reg_desc_init(struct id_reg_desc *id_reg)
 	u64 val = read_sanitised_ftr_reg(id);
 
 	id_reg->vcpu_limit_val = val;
+
+	id_reg_desc_init_ftr(id_reg);
+
 	if (id_reg->init)
 		id_reg->init(id_reg);
 
@@ -3173,6 +3179,54 @@ static inline struct id_reg_desc *get_id_reg_desc(u32 id)
 	return id_reg_desc_table[IDREG_IDX(id)];
 }
 
+void kvm_ftr_bits_set_default(u8 shift, struct arm64_ftr_bits *ftrp)
+{
+	ftrp->sign = FTR_UNSIGNED;
+	ftrp->type = FTR_LOWER_SAFE;
+	ftrp->shift = shift;
+	ftrp->width = ARM64_FEATURE_FIELD_BITS;
+	ftrp->safe_val = 0;
+}
+
+/*
+ * Check to see if the id_reg's ftr_bits have statically defined entries
+ * for all fields of the ID register, and generate the default ones
+ * (FTR_UNSIGNED+FTR_LOWER_SAFE) for any missing fields.
+ */
+static void id_reg_desc_init_ftr(struct id_reg_desc *idr)
+{
+	struct arm64_ftr_bits *ftrp = idr->ftr_bits;
+	int index = 0;
+	int shift;
+	u64 ftr_mask;
+	u64 mask = 0;
+
+	/* Create a mask for fields that are statically defined */
+	for (index = 0; ftrp->width != 0; index++, ftrp++) {
+		ftr_mask = arm64_ftr_mask(ftrp);
+		WARN_ON_ONCE(mask & ftr_mask);
+		mask |= ftr_mask;
+	}
+
+	if (mask == -1UL)
+		/* All fields are statically defined */
+		return;
+
+	/* The 'index' indicates the first unused index of ftr_bits */
+	for (shift = 0; shift < 64; shift += ARM64_FEATURE_FIELD_BITS) {
+		/* Check if there is an existing ftrp for the field */
+		ftr_mask = ARM64_FEATURE_FIELD_MASK << shift;
+		if (mask & ftr_mask)
+			continue;
+
+		/* Generate the default arm64_ftr_bits for the field */
+		kvm_ftr_bits_set_default(shift, &idr->ftr_bits[index++]);
+		mask |= ftr_mask;
+	}
+
+	WARN_ON((mask != -1UL) || (index != (FTR_FIELDS_NUM - 1)));
+}
+
 static void id_reg_desc_init_all(void)
 {
 	int i;
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
