Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5951ADD7
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:30 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d11f35a0d5cso6564238276.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903229; x=1691508029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b/7Lgt+l6L+++1Locph+rfoqbHtbNhHaO0z9TCoQ7fA=;
        b=Luf11HbqJXsqK0tpJ3+Vf7M5BsSvN+4sdgT+iA5iaTwGYb83udLYbD7YLGG7D/+G34
         /NR7P0ZzJ0OJ8Gd7885VO4M+zd6M6ml2nN4eTdX5MdfXaHHUdF3Z0blhLg2hkWxopmj5
         21J5DRheYcsD53vj2OiJkVw/3yyXOjD1mZ7MmY6AmnpTdmcyvijI38DWiVrLiFb+vlPc
         nXTMtu1DrSrw3bs4tNTz4M+aC4rnuaRCCPimr+rKbe1di7FuQV9cG6mu65xztADcSNfd
         NQJz9ik/07luYAB3j4hG87oq7Q3FY2x5F1MD0wGAvoPzt82QqMq92BdQ6UsiSErDtKgq
         ZDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903229; x=1691508029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/7Lgt+l6L+++1Locph+rfoqbHtbNhHaO0z9TCoQ7fA=;
        b=FQpBXvoHPk8B/gZGPtQUNHm0gBW0W7w7oZXgjAETdGzLX6EtMLkxqYnHfFJ8mnXSv1
         DKhW9OVN2Gg5VqDivJs0tfunAF5juqIxILS+TIWVitBpHeQhKv/hrZC69FsvUIUMgtiq
         iBf/0GrKk4yxMjxHyGe2Xi31ooyqpcYb+BgxgmLcOAlrHSYyDML4bKluy0uPYrLCbq91
         EOfITsajHEPGgo7V85ZCdxxWk6TlEl4EJO5zOspunjzDUUUouT/48VukdSHNQq+xHYOx
         8cGH0jes8tpcxwyV+5JLCK4OZERqrPsonam6Kf3DPTe6YoYsy5vLGjbTVt6SGt0J0nMd
         PRJQ==
X-Gm-Message-State: ABy/qLbIos/2nc5EWtpRERvaiy4GimDreYAx2jcQBqjn4Zi/LS9Rj5rC
	ka0/xA9XKLRlVSRvLL/afuKTER8SHc+YAeEIaA==
X-Google-Smtp-Source: APBJJlHzVwXMgVQQFdwSLT/blqJxTGWY8QTbzn3EO4lzgefNJKzxZfyyaG0mqKCJlhRCBb/Kq++VwHj9ggc+2qA52g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:1446:0:b0:d31:b7c5:5170 with SMTP
 id 67-20020a251446000000b00d31b7c55170mr42960ybu.12.1690903229712; Tue, 01
 Aug 2023 08:20:29 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:20:05 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-10-jingzhangos@google.com>
Subject: [PATCH v7 09/10] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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
index 9ca23cfec9e5..67b50a088eac 100644
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

