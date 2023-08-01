Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93064DC90
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:23 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6871c35ac54so3375233b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903223; x=1691508023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6FyTW1VsL4amGRSIg6wJqneP5gVog8VOaALdC61uAQM=;
        b=C0ZfPq3efOpnuDcjVLErVLMbvOkEBdQvbm4wQodeYlarW1FXMlMZid16hWYooPNHQg
         FySrGsafcV+pPcCeKbUiDJXzjc+1S4iffzB2PNPF7P3pEZ3/wA5J+oaXkexLLPEDBUTL
         4EbZMcSnQSuQmvmJ6DxOhJX+twsw+aZlzTQC9E+KUFYuYNTgTVQW5bHIrFlpSZD2kjZ5
         av1L2nNW80E8q9U4tCNyRXzWHt6OcoUQIt2DkunjdDA1YmF5bZUXBsYOnM4bsG7d7J2p
         OG0u8sL+1JVv9F0pgL21R5NOmzp+v1VmtztLqjLVQiyX4m33EH5jpctaIwsxb62NEABX
         /P6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903223; x=1691508023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6FyTW1VsL4amGRSIg6wJqneP5gVog8VOaALdC61uAQM=;
        b=WYQsKlCwCypQUSYq1z9nnhkwE3q7yq+JFIXHMafqAX/SqqDPda0h4wGzsBVtObr+9z
         B0BNs7nn0iJZzhcNm4lS3rN0ViZU3a5HW9P2wfo7BebSo2jpxtdjFgmD4V7n/Yd/ueIp
         bp0j8Zb0w79VSEp0vvFZiKa0Jntpt2peY3qWxi+/RHqAOSAFwVbdNHLpoUkOr3o+elar
         Wb4HFOm5QFhwRV89Ar/rDctKaH+G3iYBg6sfmpmB6hnGbGsy+qnBUc6alt04RF/gls7l
         tpyXGZd6lptiYjLXQQdAoBL9cf1NGNFZjqSzYVkNDUbh423wV5ue/MRKLuasw48iEAQ/
         /quA==
X-Gm-Message-State: ABy/qLaFIs31Hx7CvowiLNM4PiaLCrY6+WzvdgRubehDEvuHLrL0qcKo
	mq4VSZgtjp8MiMztgKxab25EiZZGV51MRFvxdA==
X-Google-Smtp-Source: APBJJlEL3UUpI4AI77yIqdcAOJwFOq1i8j3nPTDlAWpLoDzAvhrkuZEeOT3azEun/jvOMdCuFYFKd2z4TNq9i2f2Qg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:80a:b0:682:f33:fa97 with SMTP
 id m10-20020a056a00080a00b006820f33fa97mr109865pfk.6.1690903222997; Tue, 01
 Aug 2023 08:20:22 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:20:02 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-7-jingzhangos@google.com>
Subject: [PATCH v7 06/10] KVM: arm64: Bump up the default KVM sanitised debug
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
index 2183cd3af472..5a886ccb33fa 100644
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

