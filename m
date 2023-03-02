Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713B5110B
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 05:51:24 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id i11-20020a256d0b000000b0086349255277so3000117ybc.8
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 21:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hAeigAPYX6PnR/b5lR1z3A0Ou4mZhyXw4iE+Gul5d2w=;
        b=S1M+msyVuazCZC1jdDkuyZB99/+UoLVYJNPhJKpNeE44O4EuVXwpeh9BnXm61qBeb9
         ApoySJ5SBBEcy/KXGkwEeq0SsgXOtPv24dFS8dfs4hEu/GVyxpF0rkDbrhn3MajXaChC
         MC+9c9RB10yvKep1RFvNhhOF9UI3T6u37HtD9hTwGH/DPMQpgpSm1MMRumJJC3olWXN7
         Ch/125Oj7tyI+1HZEP+OLDDxPUNBYg//+JhMCtEedg/mGQ2QvweA4h4Cq4+w6lxsHs/F
         KCGVJg9WVPz8VneF8B+hhahBoOZfB/yGsUsOzGPiDPNVizsbuLwSVtclrHAtjDUmKRD3
         IFWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hAeigAPYX6PnR/b5lR1z3A0Ou4mZhyXw4iE+Gul5d2w=;
        b=dQ42eS65bVERJuBeMJw8TPSjQTKQ4V97t0Cy4oZLDMg+HCOigZvG75Kk8z+AIcc/wG
         sw4aOZPqBVkT8JsGT//6Ka6pfJllAM/o0UcQFpgEGhkY5L1FWTZBMHWF5fvQHOZjVU/X
         fLxFPXUOYzOkCoYD+ned5/MdBaUpiPuRU2aqchzOxNEl6j5bWQgOFAF9Hdkpod7XkTBn
         AoaK4lYR3jOPN0cw9Y3nBSRSnzya6IjgLZcjSiNnPlqprR+L/PbPvH1S9LPSKhunqvTX
         CzetBsDqNVgXDIvwo0HnTaQ7AFxRkep2B02VktS1WctgmoJZELyqtkx+CG4sRlrkIxE/
         2ocg==
X-Gm-Message-State: AO0yUKUJzCTjf/HTGyLxf2BQKX8kDD3nFSWypBW/kb6xqHmuz16jirD1
	dOSzNP5tsl2Kekl8+oEDfunYeH5c6hY=
X-Google-Smtp-Source: AK7set8SIN82F7pX/7DIs31aOFCLmpZGlyZYmaWI9McxHHG3QjtT/R2ncOCELjAhdRqJsIDoAk0eWd1GuTg=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:9112:0:b0:9fe:1493:8bb with SMTP id
 v18-20020a259112000000b009fe149308bbmr3722651ybl.13.1677736283390; Wed, 01
 Mar 2023 21:51:23 -0800 (PST)
Date: Wed,  1 Mar 2023 21:50:33 -0800
In-Reply-To: <20230302055033.3081456-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230302055033.3081456-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230302055033.3081456-3-reijiw@google.com>
Subject: [PATCH 2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
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

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..a5a0a9811ddb 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -538,7 +538,9 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_pmu_is_3p5(vcpu))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	/* The reset bits don't indicate any state, and shouldn't be saved. */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) =
+				val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
-- 
2.39.2.722.g9855ee24e9-goog

