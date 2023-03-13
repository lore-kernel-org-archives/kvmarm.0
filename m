Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7003815CA
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 03:32:37 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id az7-20020a170902a58700b001a0534b4ddbso252491plb.15
        for <kvmarm@lists.linux.dev>; Sun, 12 Mar 2023 20:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678357;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cy0M1iGheyvntKi3y+GjSM1iOxY11G04EpNocjkoq+U=;
        b=cTlJ+7udPzmM6zDFIF8ee2sFIvZBsuiRIzV3hNdqlXEPHqtV/3ijyFigaPGG7iWIbO
         1guLZBZQIfl0luMifYX5GK0gqJ3c0xz/QgTJgsbv1j6AMWobq0tNK8nGok9LbuyK+0el
         rvRQs5ZG/duTgxuDLv0bQtipFopuFsxP8G+HiucL2KRVM8o6xEf8/+vriszjqqrNtsZ7
         XGfP9seoWjth9Ksb9BeuGopHHfUcP5zGR+xoYhy5m2yI5Z2vllNEqNzt9XTFb7I3pGTK
         woOmBWlowBmXlGZWhKub2Au27Z0uepqBaSnUTTCfkeNGOi3xq8FbhneFxCaqOUneCp+R
         DB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678357;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cy0M1iGheyvntKi3y+GjSM1iOxY11G04EpNocjkoq+U=;
        b=uypXVF5pTRwbDxgYLJ7fh0LvxhLTi37JHJvSJfkc5wxfu325sVzuqpqnP40NEbeF8D
         I55YdRJjvaNt2I/jMU9JIec+TW0xJ/kkDSEbhJEBpcdEa61Qz37IDdqZewsjAMVGQBKh
         oQyx8aqthDeQRNSeNHs+lEo8f5bOSyh9ePPk5lw0xgQkiEG9Im8ceP7zkudM80r/6XMv
         JyJaXRTyl8OkJGt6e0xbxxIRwTOeo5Dj1S7B4UR7anD+rdzYimWKLkldE71QvNBaAs+X
         pE51/ukOFvicwNjsrXrUuUmKgv9JUBiMySRIzmGl/8TnCbw0fuGMyOLA5JvF1Gx9Soem
         6PlQ==
X-Gm-Message-State: AO0yUKWXlnu1SDeBtRlJMx7B2wHOY7t3JJj8qEq+YDFAS8da5w3Va+MC
	vWCnmsUwW3ct5LZSZz/w66YKDZGHZD8=
X-Google-Smtp-Source: AK7set/Qj4lGvY7S0/dBT1dO/b9crIdCITPApjcUxw1m+F6Uzkdmxx1UuVnqUaK/Yt3t/zLkSaQwoK0FjNU=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a63:b55e:0:b0:502:e1c4:d37b with SMTP id
 u30-20020a63b55e000000b00502e1c4d37bmr11190335pgo.12.1678678357011; Sun, 12
 Mar 2023 20:32:37 -0700 (PDT)
Date: Sun, 12 Mar 2023 20:32:34 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313033234.1475987-1-reijiw@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Presently, when a guest writes 1 to PMCR_EL0.{C,P}, which is WO/RAZ,
KVM saves the register value, including these bits.
When userspace reads the register using KVM_GET_ONE_REG, KVM returns
the saved register value as it is (the saved value might have these
bits set).  This could result in userspace setting these bits on the
destination during migration.  Consequently, KVM may end up resetting
the vPMU counter registers (PMCCNTR_EL0 and/or PMEVCNTR<n>_EL0) to
zero on the first KVM_RUN after migration.

Fix this by not saving those bits when a guest writes 1 to those bits.

Fixes: ab9468340d2b ("arm64: KVM: Add access handler for PMCR register")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..c243b10f3e15 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -538,7 +538,8 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_pmu_is_3p5(vcpu))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	/* The reset bits don't indicate any state, and shouldn't be saved. */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) = val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
-- 
2.40.0.rc1.284.g88254d51c5-goog

