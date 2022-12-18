Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAC0C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 18 Dec 2022 05:15:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69D7C4B600;
	Sun, 18 Dec 2022 00:15:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oIvUiXg1X9nC; Sun, 18 Dec 2022 00:15:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 149FA4B3E8;
	Sun, 18 Dec 2022 00:15:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A86B343C6F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rk4GkjNqe6eZ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Dec 2022 00:15:45 -0500 (EST)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E39B843482
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:44 -0500 (EST)
Received: by mail-pj1-f54.google.com with SMTP id u5so6123925pjy.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Dec 2022 21:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=vbku2iGSL/iRdowGqnTtMdWjwk//SMim4nWmdRDxnMs=;
 b=123/KLCj3LYyn7rqztkvM6x2AeqkXLK9bCMFJRafssVwqlH+yC/0Sec+Z9u5yN86hV
 E9SHypw+xwWcprb2R7QAMbw8bNosbbo653zRWRSkrKWkmNzlbElAXrX6qOUnflJ+cHDW
 v+aOruOljFuRajGzX90eIbOg9g6ZYWFP+2+dF7G6VOvkAf6UBT0nU532pY3Ye366bWBF
 CHemz3sLKDVpy6JltRaNfIYvf/INHt6prddtEpMHz1eywXgnqQCUTA6Gc8eoe63aOEZI
 pwEncdhARLzxG5coAckvqDxpWoMzyhk0H9t+vVV5aCqN2aqYqTBYbS+0HC6oK+RAkVfX
 Hu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=vbku2iGSL/iRdowGqnTtMdWjwk//SMim4nWmdRDxnMs=;
 b=QNkuUBrilIYTvoVw35GL5XOD6c3xVBFUcbs1jGEvoX5VcLURgYgqnocfkRKyWr2zO7
 piPtN1rNKUBGFSSo9h/rcD9oHVBr17eaoj/8yIykywEeLHFkFbQBCUgwTPlFfZz6Oimm
 OZBNF7eDdLu99VgNhRcbB+bcLfVqS4vxQYSv4T+UYxzxmbRnI48LDA3CsAq/3r47pT5k
 gWRnXd6al2cYr5BPUhgsquoz26z+u+oGWqcl0y/cZQHYmzxQBVdSxw4HWLiny0bNwHDt
 rrd/QTNIAvFAXH8k1JW+QpEn//b0TJ9jzVnFJTBpiqpq0G7BJg6efdJbka3645Cgax5w
 Bhbg==
X-Gm-Message-State: ANoB5pmTT19R+kkkwoeIjQNIapDHW/GW7cGpMvHlRoCv1k1lvv8UVEyQ
 IYHtyccMIbBojp+sBoWY89OePQ==
X-Google-Smtp-Source: AA0mqf47GW9wCDSTklj2Bvuc8AJ8IgjIZXIJkwM9/dZgQRSZQMCLTY55T8L/SnveaWRUwRQn4MdOPg==
X-Received: by 2002:a17:90a:a04:b0:219:bd62:f048 with SMTP id
 o4-20020a17090a0a0400b00219bd62f048mr38770743pjo.4.1671340544122; 
 Sat, 17 Dec 2022 21:15:44 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 17 Dec 2022 21:15:43 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v3 5/7] KVM: arm64: Allow user to set CCSIDR_EL1
Date: Sun, 18 Dec 2022 14:14:10 +0900
Message-Id: <20221218051412.384657-6-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221218051412.384657-1-akihiko.odaki@daynix.com>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Allow the userspace to set CCSIDR_EL1 so that if the kernel changes the
default values of CCSIDR_EL1, the userspace can restore the old values
from an old saved VM context.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/include/asm/kvm_host.h |   3 +
 arch/arm64/kvm/reset.c            |   1 +
 arch/arm64/kvm/sys_regs.c         | 116 ++++++++++++++++++++----------
 3 files changed, 83 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cc2ede0eaed4..cfc6930efe1b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -417,6 +417,9 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	/* Per-vcpu CCSIDR override or NULL */
+	u32 *ccsidr;
 };
 
 /*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ae18472205a..7980983dbad7 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -157,6 +157,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
+	kfree(vcpu->arch.ccsidr);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f4a7c5abcbca..f48a3cc38d24 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -87,11 +87,27 @@ static u32 cache_levels;
 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
 #define CSSELR_MAX 14
 
+static u8 get_min_cache_line_size(u32 csselr)
+{
+	u64 ctr_el0;
+	int field;
+
+	ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	field = csselr & CSSELR_EL1_InD ? CTR_EL0_IminLine_SHIFT : CTR_EL0_DminLine_SHIFT;
+
+	return cpuid_feature_extract_unsigned_field(ctr_el0, field) - 2;
+}
+
 /* Which cache CCSIDR represents depends on CSSELR value. */
-static u32 get_ccsidr(u32 csselr)
+static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
 {
+	u32 ccsidr_index = csselr & (CSSELR_EL1_Level | CSSELR_EL1_InD);
 	u32 ccsidr;
 
+	if (vcpu->arch.ccsidr && is_valid_cache(ccsidr_index) &&
+	    !(kvm_has_mte(vcpu->kvm) && (csselr & CSSELR_EL1_TnD)))
+		return vcpu->arch.ccsidr[ccsidr_index];
+
 	/* Make sure noone else changes CSSELR during this! */
 	local_irq_disable();
 	write_sysreg(csselr, csselr_el1);
@@ -102,6 +118,61 @@ static u32 get_ccsidr(u32 csselr)
 	return ccsidr;
 }
 
+static bool is_valid_cache(u32 val)
+{
+	u32 level, ctype;
+
+	if (val >= CSSELR_MAX)
+		return false;
+
+	/* Bottom bit is Instruction or Data bit.  Next 3 bits are level. */
+	level = (val >> 1);
+	ctype = (cache_levels >> (level * 3)) & 7;
+
+	switch (ctype) {
+	case 0: /* No cache */
+		return false;
+	case 1: /* Instruction cache only */
+		return (val & 1);
+	case 2: /* Data cache only */
+	case 4: /* Unified cache */
+		return !(val & 1);
+	case 3: /* Separate instruction and data caches */
+		return true;
+	default: /* Reserved: we can't know instruction or data. */
+		return false;
+	}
+}
+
+static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
+{
+	u8 line_size = (val & CCSIDR_EL1_LineSize) >> CCSIDR_EL1_LineSize_SHIFT;
+	u32 *ccsidr = vcpu->arch.ccsidr;
+	u32 i;
+
+	if ((val & CCSIDR_EL1_RES0) || line_size < get_min_cache_line_size(csselr))
+		return -EINVAL;
+
+	if (!ccsidr) {
+		if (val == get_ccsidr(vcpu, csselr))
+			return 0;
+
+		ccsidr = kmalloc_array(CSSELR_MAX, sizeof(u32), GFP_KERNEL);
+		if (!ccsidr)
+			return -ENOMEM;
+
+		for (i = 0; i < CSSELR_MAX; i++)
+			if (is_valid_cache(i))
+				ccsidr[i] = get_ccsidr(vcpu, i);
+
+		vcpu->arch.ccsidr = ccsidr;
+	}
+
+	ccsidr[csselr] = val;
+
+	return 0;
+}
+
 /*
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
@@ -1300,7 +1371,7 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return write_to_read_only(vcpu, p, r);
 
 	csselr = vcpu_read_sys_reg(vcpu, CSSELR_EL1);
-	p->regval = get_ccsidr(csselr);
+	p->regval = get_ccsidr(vcpu, csselr);
 
 	/*
 	 * Guests should not be doing cache operations by set/way at all, and
@@ -2660,33 +2731,7 @@ static int set_invariant_sys_reg(u64 id, u64 __user *uaddr)
 	return 0;
 }
 
-static bool is_valid_cache(u32 val)
-{
-	u32 level, ctype;
-
-	if (val >= CSSELR_MAX)
-		return false;
-
-	/* Bottom bit is Instruction or Data bit.  Next 3 bits are level. */
-	level = (val >> 1);
-	ctype = (cache_levels >> (level * 3)) & 7;
-
-	switch (ctype) {
-	case 0: /* No cache */
-		return false;
-	case 1: /* Instruction cache only */
-		return (val & 1);
-	case 2: /* Data cache only */
-	case 4: /* Unified cache */
-		return !(val & 1);
-	case 3: /* Separate instruction and data caches */
-		return true;
-	default: /* Reserved: we can't know instruction or data. */
-		return false;
-	}
-}
-
-static int demux_c15_get(u64 id, void __user *uaddr)
+static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 {
 	u32 val;
 	u32 __user *uval = uaddr;
@@ -2705,13 +2750,13 @@ static int demux_c15_get(u64 id, void __user *uaddr)
 		if (!is_valid_cache(val))
 			return -ENOENT;
 
-		return put_user(get_ccsidr(val), uval);
+		return put_user(get_ccsidr(vcpu, val), uval);
 	default:
 		return -ENOENT;
 	}
 }
 
-static int demux_c15_set(u64 id, void __user *uaddr)
+static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 {
 	u32 val, newval;
 	u32 __user *uval = uaddr;
@@ -2733,10 +2778,7 @@ static int demux_c15_set(u64 id, void __user *uaddr)
 		if (get_user(newval, uval))
 			return -EFAULT;
 
-		/* This is also invariant: you can't change it. */
-		if (newval != get_ccsidr(val))
-			return -EINVAL;
-		return 0;
+		return set_ccsidr(vcpu, val, newval);
 	default:
 		return -ENOENT;
 	}
@@ -2773,7 +2815,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
-		return demux_c15_get(reg->id, uaddr);
+		return demux_c15_get(vcpu, reg->id, uaddr);
 
 	err = get_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
@@ -2817,7 +2859,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
-		return demux_c15_set(reg->id, uaddr);
+		return demux_c15_set(vcpu, reg->id, uaddr);
 
 	err = set_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
