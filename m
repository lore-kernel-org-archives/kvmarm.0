Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611DC11C8F
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 16:22:32 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bc4abfca29so28214025ad.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 09:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425352; x=1692030152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KQ512HkIoQ+JjDzsBkwZD/O45k5sXYn+9E1zCZiXBTM=;
        b=6Lo9H24x8NTxC0n4kLhv0iJn7Shulw6bzYqLRydoTq7ITj9ZEMtDdbusgZ9Y2360bu
         8NAb1ux1MMgQTMc8dIKPjKpIrjK4OZOPoRUbHDDyBJHa4zmV0qeicuZ/SnRbEsghTWjR
         lttSTUslekgfspuAH2XPtE1/wt36SeLpKlZ6+xPvzi8ODkznx8oJj1ikC9iK4bWBKIQQ
         acWXrbWLULbOeWV9v9a4MPSNMIk1DxvuLoTVeWG6dvqOMiuM7T8/yBCa1NgGWbMC4p0R
         Y+OUL3O7tPB99sQDEj1N6mSEVTvcs/IfpMSvIM6SiAPjpfk9lVMgwgECFWXNRIAUaALI
         L2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425352; x=1692030152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KQ512HkIoQ+JjDzsBkwZD/O45k5sXYn+9E1zCZiXBTM=;
        b=Fv0Gq9XXUljzCTCsnsuvrrmY8FlI2fAMR90kMc4YZlYSihsAgtfbmLMmq6GXfETDD8
         Ai7heQihHC7hT5nPIF6OQTSIoqSu6vqXtnmaus+qJ5OKkQsMHUBxxbU/upgL+8r61nNl
         c60kEQiJiutCQMvSQUBaD3OZQEJg7M1Z48UqQkfzXH41Y+TfL0l2kcuWk4sHgPjyLfsi
         wWtZgFzwMhH/NiUWWVJU7PIQhNYL8ThOeYsUBSP6qHdAnPDuGldajJfp4f2iohcU8n0I
         gcq1u7QZlBzDzvmQbu6L3EikRsM3PpiqRiCpCN6dPWvq5ERcA9Sqk99VcHx2KNv9etfk
         MCRg==
X-Gm-Message-State: AOJu0Yyfo83Ts3jG0PFVxaAz+pM9CoFsB0Y5aH4oTUKAJNWbt+3xa7xp
	IIOHsjkLLmq7lJ3jeZOLipdZ3/17Aw/ZHAp+9A==
X-Google-Smtp-Source: AGHT+IHp4MVAV4n481W5LCw7P/7em8n7s/3BaGvDZ7vncQfCYL58OphuOXpZAfvPrGytnKkgdfgjYDyzmGS6V7A3kQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:22c2:b0:1b9:e338:a8b7 with
 SMTP id y2-20020a17090322c200b001b9e338a8b7mr41787plg.5.1691425351454; Mon,
 07 Aug 2023 09:22:31 -0700 (PDT)
Date: Mon,  7 Aug 2023 09:22:07 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-10-jingzhangos@google.com>
Subject: [PATCH v8 09/11] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 85b5312bdee6..59c590fff4f2 100644
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
@@ -1581,6 +1578,15 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, val);
 }
 
+static u64 read_sanitised_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *rd)
+{
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+
+	val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+	return val;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2063,10 +2069,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
-	ID_SANITISED(ID_AA64MMFR3_EL1),
+	ID_SANITISED_W(ID_AA64MMFR0_EL1),
+	ID_SANITISED_W(ID_AA64MMFR1_EL1),
+	_ID_SANITISED_W(ID_AA64MMFR2_EL1, set_id_reg, read_sanitised_id_aa64mmfr2_el1),
+	ID_SANITISED_W(ID_AA64MMFR3_EL1),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.41.0.585.gd2178a4bd4-goog

