Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5BB125C1
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:23:04 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-564fb0b4934so5409304a12.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652984; x=1693257784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YgTaLJAmUad0YLnHfOMQe2MEne8LxCU1g5ZxaAq3g0U=;
        b=PIl6nC2/xM90YAB0x/YrU1gwi0CviK/tWjFaeL65SWUQbUQsgpVJRPn76978PnD4u6
         bUaiGMw+W7iOfyNuZAthpf6LJK0IfuZJxGAKOM4HQxgVOzLTvOyp7yDPUmb9Ph83bDfG
         ndD0X9hQe7EuKGLXb4bi1CDpqCtvhSOmD/vKTKnjOYnuaZTj9q3ogcV31WaBh6QSOyx1
         Nw8263cJrnqh4ffttwH7WVpUuT+SdZZkOIr7M+JIiktCM/PUS00fUySXtJrPPSXXD/BA
         uS14x06dGL1jh7ry9crzF+Wkj3pcTJZOipAmWYUuxHCaKUvBZdWM0hPeHvv7L7w7JzNB
         krxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652984; x=1693257784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YgTaLJAmUad0YLnHfOMQe2MEne8LxCU1g5ZxaAq3g0U=;
        b=A+Yv/f1Q8ikaD98Zo3n2AnuIYq+5WdM1zlw4vWJUeg2z7ny2pBe0lER1Zt1zJNnlTh
         wGyaDsEP+BRklyBxSaWMR3PeanDHtieJuDjx8bWP4XwjWncfXLXb07MZFN96HZSUIQmS
         QPIp2+Sqr7kmoowGqlJKCaOaqNj2MLk6TqDP427Jk2PmnOK/ZbJo8sJRR32yMbP8uLYq
         jB2b+ypLA7oEj92HI+MDXSiuiY6gRGRpQWu7udaZm6bgTFeNl7jY659bbWID7NUxuRVq
         PqjRc9STM3Z1Dwv5iSJxL3dKuxPdzu9e1CYibhsdkWJEJL+NW1zQkpCrzdzgtMEgoNxd
         kJTQ==
X-Gm-Message-State: AOJu0YyUGxvuecSd44wav4wMUQi44uQzOpA9yQLbE/AQvllakK51+kbS
	Qu5Ep0Mf4ULqmzo7vPL1gJJnyT7kRGolUVKELg==
X-Google-Smtp-Source: AGHT+IHMLzQuvWaAzxElJKP9Dp9OtXD637SCTtUsKnZJ0SqP6VYj3mFXGJE3BulMdkjVz/lV1VBaWwqQYtRJCXaReA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:cec9:b0:1bc:f6d:b2f1 with SMTP
 id d9-20020a170902cec900b001bc0f6db2f1mr3958879plg.5.1692652983926; Mon, 21
 Aug 2023 14:23:03 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:41 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-10-jingzhangos@google.com>
Subject: [PATCH v9 09/11] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable writable from userspace for ID_AA64MMFR{0, 1, 2, 3}_EL1.
RES0 fields and those fields not exposed by KVM are not writable.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44d164d47756..96a1dccf1af5 100644
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
@@ -1936,6 +1942,10 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 }
 
 #define ID_AA64DFR0_EL1_RES0_MASK (GENMASK(59, 56) | GENMASK(27, 24) | GENMASK(19, 16))
+#define ID_AA64MMFR0_EL1_RES0_MASK GENMASK(55, 48)
+#define ID_AA64MMFR1_EL1_RES0_MASK GENMASK(63, 60)
+#define ID_AA64MMFR2_EL1_RES0_MASK GENMASK(47, 44)
+#define ID_AA64MMFR3_EL1_RES0_MASK (GENMASK(59, 32) | GENMASK(27, 8))
 
 /*
  * Architected system registers.
@@ -2068,10 +2078,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
-	ID_SANITISED(ID_AA64MMFR3_EL1),
+	ID_SANITISED_W(ID_AA64MMFR0_EL1, ~ID_AA64MMFR0_EL1_RES0_MASK),
+	ID_SANITISED_W(ID_AA64MMFR1_EL1, ~ID_AA64MMFR1_EL1_RES0_MASK),
+	_ID_SANITISED_W(ID_AA64MMFR2_EL1, set_id_reg, read_sanitised_id_aa64mmfr2_el1,
+			~(ID_AA64MMFR2_EL1_CCIDX_MASK | ID_AA64MMFR2_EL1_RES0_MASK)),
+	ID_SANITISED_W(ID_AA64MMFR3_EL1, ~ID_AA64MMFR3_EL1_RES0_MASK),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.42.0.rc1.204.g551eb34607-goog

