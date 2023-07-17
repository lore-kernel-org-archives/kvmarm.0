Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D4E253C3
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 15:27:32 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-666e87eff0eso4045939b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 08:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607652; x=1692199652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mV2IQqjJWtXV0PBatZiBNfFvtLn0ngWE8+KQeRLOuQ=;
        b=oFJclosJYBUiBrr6sqDKjbvtQ+/OOqJGzwDh7S5LS4rB2ZeKJ55XIrvjrMfDYEeTmW
         DZ44BWI/M/xcKIcSE0mS/AK4xxWyFl9knZF4MDluXaBAezoPx7SxY7h6Su8J50VjcO9Z
         3yqe2yfU1pGSZxR/tRZAbgB0OMgHiUQ6ecFvVTnBIXMKadUOomUV5uxXnh3ng6+AjgZw
         0AFhQyO0ZpjpVLAx3g9Mt5I7m2vhoK5i6j6gjHqvIJYCwFwT3Xu+k6bwWIozjsRtLN9E
         cfZk2J0WYkQhemmdcG+NxaIkaj+8b7i8TE9P0N6LwBkkGj7C7enbpyeiuWkyjrL4OMc8
         3y+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607652; x=1692199652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mV2IQqjJWtXV0PBatZiBNfFvtLn0ngWE8+KQeRLOuQ=;
        b=eRcWEjejGQ6IaldF96HIusNa2lIdptfFq/etP0syhDICzinZHFArlLnKB/5a5Luf2U
         ssCybC7tr/ko6ZoH8HeX+YzLXysQHpc5qgC00F59dY78vvWVuW4JHJxSheB8LQ+Zi2Uw
         Ne9Hw6dBB/iwUex3Bie7JpqmI5rWWWoah37i5VBFgI/rMASc1OU1uh9VYdoq4qW5o2eI
         BOpmNuV95aafI+m2JGQscHnuWNUAA5WFn2m06x70HzHNrWI9oCMswRXG9ExzRqyh/5pE
         VCzDbkl2E8jH28tf5xKMFSgc5oXmfLbtE5cGeHKv2Roj+YzC0Ni16pgWcFoSHj/Kjb/j
         YkTw==
X-Gm-Message-State: ABy/qLaEADEctU+Och4+NYQrKZMr6NNdez9qHWU2yjW7MDMw55Cv/5uu
	s+RMLTk+fccz5Psbky3mA0gUy8vAawIPIkXlvg==
X-Google-Smtp-Source: APBJJlGWPC7Roh8Pd0zejhfDsSo3VBfRNb6G9bRpZN3JPepGli2gJO4trCOigT9eujUPRt4Q/PqJoaBeAl+3o8yMZw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:3a13:b0:668:95c1:b507 with
 SMTP id fj19-20020a056a003a1300b0066895c1b507mr145112pfb.6.1689607652562;
 Mon, 17 Jul 2023 08:27:32 -0700 (PDT)
Date: Mon, 17 Jul 2023 15:27:21 +0000
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-5-jingzhangos@google.com>
Subject: [PATCH v6 4/5] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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
index fab525508510..5fbf14320ad9 100644
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

