Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB99DF508
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:45:36 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-55c964d031aso4119673a12.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 09:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698736; x=1692290736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7vkCbr047ltjyeNSod64c+hA+AaA1LNd8Iy2F1bOfBE=;
        b=yDDdm3Z98ZL51ezeU3dyZisGjIZSm1scHPakb810LlPtbzZdWtSUIYn/IEOov5bS/a
         HhyaKTMZfG3GGLqUcOZEO3jWAbeBWbTi5j8vYHEICwvgbi8Qv93SV86ZXZ0R9uRIOEfU
         tfW4QxvXTLOQmrAp6N5uWwOcYGCQ1yrqQNnUXmzNz4YhAyyA4TJE3vbPvZe52JEjQ19o
         rSCyDjo7l5I7KgLtNETHDoB9SexVb9joZl0xIE+DtxXUBwwJrN0HrgEesHZL1dS3a3f9
         1WXahQMOWqNCdfgQgckue6kJBtPxpTLLOYavVWjQIXyOfD4f5EYp3T1flDKM9NrTNHJg
         ca5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698736; x=1692290736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7vkCbr047ltjyeNSod64c+hA+AaA1LNd8Iy2F1bOfBE=;
        b=Soudo/3ICowASLAP2G7z61C8rQUbm0MNJs8mqagdvjLzH/Z5dBuyBgmqRWhX7f5vCS
         EEDimlDbIDuiId1JpBrjbb5kr5JjndKpskMnMEfMI7rtiOxESF24e3V01XbQbsx3hIKx
         +u69u4rquE+kGntLThI9UrtblboSrF0rBsDu/zj9C9XTRSLz4EQFAQ7oHoN4RcO5q1Gu
         TiGGJi0hxsus+WuLu8vgo07dSIFScvmJc69U8Q/h0rr6GhtA0fuKLnuWTCOgMxx9M/ep
         My1ZtUY867SgkKY14Ye03/FKyPjP3VSQpAD4krltyvesRTRZDqAc0Pr+dSkbkSjuUtGC
         TPqw==
X-Gm-Message-State: ABy/qLbBUzS91LKG4gMUDK8mEoe25L4LEfuKykfyVpEQ234hIBuKR5XX
	DPYLlM6dq2bYcHjtYJtFeNp7RPPhR+BUy9o8tA==
X-Google-Smtp-Source: APBJJlHDDu+HxPs3scZlNF4+YoM4eumiXMxf7JemKCB4eK0aLPYXrlzf6mMhZxkgAMPgiQBQLnY7YjFAQ4oSoy0Zbw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:158e:b0:677:c9da:14b6 with
 SMTP id u14-20020a056a00158e00b00677c9da14b6mr159486pfk.4.1689698736287; Tue,
 18 Jul 2023 09:45:36 -0700 (PDT)
Date: Tue, 18 Jul 2023 16:45:21 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-6-jingzhangos@google.com>
Subject: [PATCH v6 5/6] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable writable from userspace for ID_AA64MMFR{0, 1, 2, 3}_EL1.
Added a macro for defining general writable idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 12b81ab27dbe..d560fc178a76 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1346,9 +1346,6 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS);
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -1582,6 +1579,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, val);
 }
 
+static u64 read_sanitised_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+	val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+
+	return val;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -1856,6 +1865,16 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.val = 0,				\
 }
 
+#define ID_SANITISED_WRITABLE(name) {		\
+	SYS_DESC(SYS_##name),			\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
+	.reset = kvm_read_sanitised_id_reg,	\
+	.val = GENMASK(63, 0),			\
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define AA32_ID_SANITISED(name) {		\
 	SYS_DESC(SYS_##name),			\
@@ -2077,10 +2096,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
-	ID_SANITISED(ID_AA64MMFR3_EL1),
+	ID_SANITISED_WRITABLE(ID_AA64MMFR0_EL1),
+	ID_SANITISED_WRITABLE(ID_AA64MMFR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64MMFR2_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_reg,
+	  .reset = read_sanitised_id_aa64mmfr2_el1,
+	  .val = GENMASK(63, 0), },
+	ID_SANITISED_WRITABLE(ID_AA64MMFR3_EL1),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.41.0.255.g8b1d071c50-goog

