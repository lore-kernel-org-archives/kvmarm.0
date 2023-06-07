Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1A838CC2
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 19:46:06 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2562fbb193bso2595202a91.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Jun 2023 12:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167166; x=1688759166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kt9Re8VhD2+c+e08bfchTfKK01Rj2MUePQIf0sCv4Xg=;
        b=qnLVcf4LBOV1GocAfKmE7OOXWzG9JXsx+o5fD5NyUihLa4ZmEEtGXBCpzgiwnDFzpW
         3i9IE5h6ihvg8wwHtLHRzRrmvSiqyq53LJ5VdfHiV/e3LDQnWSjiBl2omUAEyOSXHCvb
         CHDx0jkRuYbIVXezwbq9YBlEropjp33Q5X5v8O3ixEuMOEQeQ8f1dVDxgyOFKJPD+e8v
         8eqaxzIAlQKYECNoDAZ2EDzO7PmAJgcbwIXx6TA6P1gNq8IfNTK8hknyk2zzl5/syfVP
         N64VmdmpBXc9YSc4MaxWzquMO6VleuSWpfh2cPXzcRKY2zF8umgZx0vTVuieF++qHdj4
         q5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167166; x=1688759166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kt9Re8VhD2+c+e08bfchTfKK01Rj2MUePQIf0sCv4Xg=;
        b=C/A75LXSbgoFpX2bWBKhvCrWwYgfixgVv2n0mce4O90L4etkQh289PGkasLmkVcgpM
         8Ykl7to/MzgBBsW94+9Nw5r4poZy8O4H8iCqVoB2rchxjq5WtAPcpeUA5C1FiAfEzdBX
         URMy0pGmzl9WAxQxSo/WeiykLzqdq1N6w1J5PuH3q0mESM8BE9vH2mmHHGvtTxz4z00m
         EJgAgqpqkWe7optcuzM6irvtDEScIVCpFBxSiXURN8T0616FZI37Ym5RE4nzqzd2iQh7
         bc4KGVMETInMNt8Hh48ezZYK1afNZoSn0wWR6tvnnyGja3xE2gSqX79WhHyXpDxFj6ut
         /u8g==
X-Gm-Message-State: AC+VfDyhwkWpaFfRF/By/CRb7HOXWJwlgvwYrhuIp3EJ0R9C5gPbvwvf
	yiud9skMy2Y6MWI5Ol6RR+/vdsjR/eLm1kmKiw==
X-Google-Smtp-Source: ACHHUZ6AdZhHVsK3gBqZ29mngq3wYJzUe8nyFBCy0MXmvWuiKLwI//W+KPq7fWqN45t7RWSqbJlvv7QNt3JQHgOuqw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:db02:b0:1b0:4af9:9032 with
 SMTP id m2-20020a170902db0200b001b04af99032mr2121642plx.0.1686167165934; Wed,
 07 Jun 2023 12:46:05 -0700 (PDT)
Date: Wed,  7 Jun 2023 19:45:54 +0000
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-5-jingzhangos@google.com>
Subject: [PATCH v4 4/4] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2}_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable writable from userspace for ID_AA64MMFR{0, 1, 2}_EL1.
Added a macro for defining general writable idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8f3ad9c12b27..54c762c95983 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1391,9 +1391,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
 				  pmuver_to_perfmon(vcpu_pmuver(vcpu)));
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -1663,6 +1660,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return pmuver_update(vcpu, rd, val, perfmon_to_pmuver(perfmon), valid_pmu);
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
@@ -1898,6 +1907,16 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.val = 0,				\
 }
 
+#define ID_SANITISED_WRITABLE(name) {		\
+	SYS_DESC(SYS_##name),			\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
+	.reset = general_read_kvm_sanitised_reg,\
+	.val = GENMASK(63, 0),			\
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define AA32_ID_SANITISED(name) {		\
 	SYS_DESC(SYS_##name),			\
@@ -2113,9 +2132,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
+	ID_SANITISED_WRITABLE(ID_AA64MMFR0_EL1),
+	ID_SANITISED_WRITABLE(ID_AA64MMFR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64MMFR2_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_reg,
+	  .reset = read_sanitised_id_aa64mmfr2_el1,
+	  .val = GENMASK(63, 0), },
 	ID_UNALLOCATED(7,3),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
-- 
2.41.0.rc0.172.g3f132b7071-goog

