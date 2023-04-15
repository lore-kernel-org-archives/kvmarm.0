Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1B82F58
	for <kvmarm@lists.linux.dev>; Sat, 15 Apr 2023 16:41:00 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-517a6547b0aso1093219a12.1
        for <kvmarm@lists.linux.dev>; Sat, 15 Apr 2023 09:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681576860; x=1684168860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z2M63eTttyiy9/bDAykyJM/0pATtpC5A2Oom8LHCZ9k=;
        b=TUQUCtCJib3y4up2QnqFd/naObQKhfNVY7afy7u9JkA8pMqyu4rdiZKWgXORmpq/fC
         X5ETMMDTvclo+ScvAxMF9E/5ES7fjYYlbnpHGVn1KIa247m/sTbKp1LiKYm6cFlrVB+9
         XJj2oiTUGiZTx6tK+D078A/8/ov0MU+lI1lPjGAmeyBl4wMC1K+hALb+JCsaHRRWmJ5e
         93bbVzLDiknxQxkPfOURflcbszH6G2+bbVV2z8VBou27F05tmm53aUSC0YIqpjh6cTos
         XXaytsJlLmhKUoGamjBghxs9fpVneoIo45c+V5bb8+/zyfK9yOB08NqssaJWxbQfZV03
         zXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681576860; x=1684168860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z2M63eTttyiy9/bDAykyJM/0pATtpC5A2Oom8LHCZ9k=;
        b=a+cW53/JwDwFXsYkfuENuP6Y8DgwmxMcnxMuOYV3pROA4Pr2fogKt6xe+DUQhW3wve
         xy9kH+bxYL1m34z/lAOLjPMQih6N41jYvjaW+AW/9Er5JDRIqh2oedODGN4RWyXbASwf
         Hv81aNMxTMkA093JVJtUUOVUFDghLmFCo9qphpnWKPTsZ/ACBcbf3xT31VciENENIOXA
         Wb3b1XNHz4/9yszmnPYWb6fowvDAWQlPlO0B7dXySlPzKm9RctCCcIKDz6tHUTFIQjUM
         SaG8vwOIGk3UKA4aAL16ylKtbXDYod1zDoXUmS9qcYXW4J6zsXSaGRTKCjNlexITCchZ
         X7zg==
X-Gm-Message-State: AAQBX9fPefljQgs6B0tOA1gdXHmwSeG96hlFCWcyTtNwOIRNSzm+8zX5
	9kHKPTWzd6JI2qCIpypxDIZFyqNhKtQ=
X-Google-Smtp-Source: AKy350brZ9cJoLoaZNJmMW+tpDxq5a3i0icYIzxJIjiLPR3atdE1a+olD8DSeBPpLqiSycbYFskGMVlrt64=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:a1d:b0:63b:6e47:8646 with SMTP id
 p29-20020a056a000a1d00b0063b6e478646mr2576065pfh.3.1681576859816; Sat, 15 Apr
 2023 09:40:59 -0700 (PDT)
Date: Sat, 15 Apr 2023 09:40:28 -0700
In-Reply-To: <20230415164029.526895-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230415164029.526895-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230415164029.526895-2-reijiw@google.com>
Subject: [PATCH v3 1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Rob Herring <robh@kernel.org>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Restore the host's PMUSERENR_EL0 value instead of clearing it,
before returning back to userspace, as the host's EL0 might have
a direct access to PMU registers (some bits of PMUSERENR_EL0 for
might not be zero for the host EL0).

Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..6718731729fd 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -81,7 +81,12 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 * EL1 instead of being trapped to EL2.
 	 */
 	if (kvm_arm_support_pmu_v3()) {
+		struct kvm_cpu_context *hctxt;
+
 		write_sysreg(0, pmselr_el0);
+
+		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
 
@@ -105,8 +110,12 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
-	if (kvm_arm_support_pmu_v3())
-		write_sysreg(0, pmuserenr_el0);
+	if (kvm_arm_support_pmu_v3()) {
+		struct kvm_cpu_context *hctxt;
+
+		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
+	}
 
 	if (cpus_have_final_cap(ARM64_SME)) {
 		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
-- 
2.40.0.634.g4ca3ef3211-goog

