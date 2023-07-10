Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D5014AB3
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:24:43 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-55c1fd0f723so3655858a12.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 12:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017083; x=1691609083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q8Pfm1k8D0yA8LpBE9VtBtVTcRMyZS82/djAneCpkmQ=;
        b=GDvwqv1MlzXGhRLJnLJVug7YjvSyOR6eGB5341bF6QxHQZRZgkvaDlH66y4otQAjxR
         44UbQIWUSOEUnsrC+JRRpIOD794NJBNrvpilQ7LO6keqcvGltAH1FCmFC3SyXkOwYQ/0
         crkiuQnUI2yGw0A4pjGjbwtLO3U6I5Dh1NwZzexJa3qLV/JxBB+WCx0PBSJDgoXI72sq
         LXWeycLBLLeq7lyQ+Kz3VJhHfDhYEvJ/rpKj4QaoZuWnuNfv2i5xlOK+8ONgEsLm1Gze
         4kc8pmZHweX9syFCVFkCQQ7hmDa3KevbPWic1vjbctzP5FGA9XSCZpASTHh3DdJ0ZRsF
         merg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017083; x=1691609083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8Pfm1k8D0yA8LpBE9VtBtVTcRMyZS82/djAneCpkmQ=;
        b=LtRW/KT+qeB0HbyPdEsk8lrariWUlPCibhCZfkKD7UkN9pY7Xw6kNgH/YoanuR0/Nl
         A8vhcqLfaJcvb4xdICAF6cuodBMAukEWpwKpCWvW22N3meiNf1i2Y7XGJ2/DACKf+INs
         5v7h8j4xCEDx5N5fMgifL1byktv/DQaCcNlAd3ENVCxFdVmhJILqVAgTylCPI8KhsOXw
         icwBbB7Uh4Z2KZcim2XUPj4CiOUpy8SE3qcxbdezd7afCZZ/FxI3iMDYk3w7OJmgxe0K
         VhWIiWp2hZZyD8RuN1WKSuirUsqmdhs4177xSseeJBDsMc+35rjV6Z8ckxTZKHw/Zks/
         +9HQ==
X-Gm-Message-State: ABy/qLZSZbdOS+2Y9kC/PDQ9LVGpbBXjE+LWrcR9bbFY+e/GtAIN/BJ/
	ite0rM1IQWeIepmWghz9P1/kWZ+hZ1MKQraUiA==
X-Google-Smtp-Source: APBJJlGBCHc1RRKkPANqOkNMUbhIdTsh4hoWApD9cH5zSD49oQpk7M8yIJXyvY9F4ifLaUr+n7yMTQtPbIKIxkg7Jw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:6:0:b0:550:d2d6:525b with SMTP id
 6-20020a630006000000b00550d2d6525bmr9180529pga.12.1689017082796; Mon, 10 Jul
 2023 12:24:42 -0700 (PDT)
Date: Mon, 10 Jul 2023 19:24:28 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-6-jingzhangos@google.com>
Subject: [PATCH v5 5/6] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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
index 967ecd57a86a..78ccc95624fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1340,9 +1340,6 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS);
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -1566,6 +1563,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -1840,6 +1849,16 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
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
@@ -2061,10 +2080,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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

