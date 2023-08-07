Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FA011C8F
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 16:22:26 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-563ab574cb5so2640313a12.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 09:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425345; x=1692030145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zvko96XhFtpYYidvZOJTCgoG3opZmvwlh1PYr9fTkkI=;
        b=jaMmpyvd6ihZ06+wE8AlrhnE1qPFQoCnq+e0opFsICAtC3WVl+O4TUJ+k01tMVQm5z
         L8YyZk2p1e1UUxT5Ir40iF256pReWqm38iiNRDL5vLoukvqOiR9GrVum8fK4WfahG8f5
         QWZ6HRbnpFx6UQUaxWMTKdcfV1qrLBQf10u9merYlRbtmrgforr4lnVp0/W7w7sCnAbt
         9jax0nr7qlx8M+YJpbXqQsWa6+eqJ4jwyCgLG3q5+Cg5CAohUn/bYnUgi+/IR3LIcsk8
         KTUBLJcc3Rslkj61Lrur7GagaijK8lASUHDDnw5QCAOYnPcD5hX1Jux2aeuGmk83vat+
         xy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425345; x=1692030145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zvko96XhFtpYYidvZOJTCgoG3opZmvwlh1PYr9fTkkI=;
        b=VXCtfcUZO9dO6+4iObV2FhrxfFx5BoMsbFEDb5n2nUPrtGLc+H8dYbNBBUoCEp1ce8
         D2RRplykdIhBnvWPz73Ynwn7sxGhSn7nXCTesY5cblH5hG2lmXaiwNWZFsWB0G/HBMmc
         HI6AlMIP1B6k6wrIGqHYmvnJoeZWgCQCXgSajRqsxe6W70DDBZPQVupLfX52umGEn4sE
         VaDS9xA8vhdt6DFo/8mijGJtYEu3DygjAmCAA9yEoNFeV0PGXOffo7Ir9HVm6eM2W97c
         Y6KQSdMS+xatY5Mcg7tU3ulkCXU8XeQzfGwJ3ePTUDqv0x1VXB6R0bWg0JI+zDR3rvxF
         hcTw==
X-Gm-Message-State: AOJu0YyypatMAejz9p70T1czxT6aALKt2lqc8TIj5AIaDxpmY44e7y1g
	zU4rfdDdehv4a4gWmC1zu5uXB7NitxAsvFX2RQ==
X-Google-Smtp-Source: AGHT+IF0luikMERZ5n3CMp2yFSmVcfgwmELbpWdGVUJ7uHnLdJhIRB6jZe3Nzpwz9XCDsQ4vNxF9J7MobIwiMfhDew==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:790e:0:b0:55b:c42d:e454 with SMTP
 id u14-20020a63790e000000b0055bc42de454mr44303pgc.11.1691425345621; Mon, 07
 Aug 2023 09:22:25 -0700 (PDT)
Date: Mon,  7 Aug 2023 09:22:04 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-7-jingzhangos@google.com>
Subject: [PATCH v8 06/11] KVM: arm64: Bump up the default KVM sanitised debug
 version to v8p8
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

From: Oliver Upton <oliver.upton@linux.dev>

Since ID_AA64DFR0_EL1 and ID_DFR0_EL1 are now writable from userspace,
it is safe to bump up the default KVM sanitised debug version to v8p8.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5f6c2be12e44..879004fd37e5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1489,8 +1489,7 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 
-	/* Limit debug to ARMv8.0 */
-	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, IMP);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 
 	/*
 	 * Only initialize the PMU version if the vCPU was configured with one.
@@ -1550,6 +1549,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
 
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
+
 	return val;
 }
 
-- 
2.41.0.585.gd2178a4bd4-goog

