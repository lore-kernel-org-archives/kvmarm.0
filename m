Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244AE7B
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 00:21:53 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 8-20020a250508000000b00b7c653a0a4aso5765239ybf.23
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 17:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680049312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M9VEYqg/OD1okwRTmN4uX/z0exuBfdAWAGm4G9tIIbA=;
        b=cogAFos4A80Hq8+t7GQy2mKfxVx3APH3a1KXMCXu7X/Ftmir6SwV/tqrbmvoyJV6/G
         2Ln6du+IarOLF0lqN4pFV71t1o3gztK8xBtNYgxZEc+rO8yCGMELfozjOMMWvnWq6Ie6
         lw+XRBp+AUzc2OfkHb0EEqO6gGrCdqfI0U8b8Mg5GwGINrpd9B+/YmRxAixj7MdKPoe1
         lySTkVLKGijW9ROYl46XIe+OR0Ao4qRHlfp/mq8zcTLuvsXKLceeDDVuhiXFh5GIQwOe
         97BbRju/HlGwDxqp+BaFRCg+z7D74wMA4nXoK5NY8BFHqXjum7uu0MPk0UANnwwS/sPp
         sLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680049312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9VEYqg/OD1okwRTmN4uX/z0exuBfdAWAGm4G9tIIbA=;
        b=Ns1TOhAHpfXnNW3M3Xp9RylD0a1Rgerx+zvX0nQQa0DehHF+jpVAN8rP8fYHeumL3O
         +u6crVwNnDY65eWOH8+HctRqctpAk7HVqz8OOBeuJWAKdQ6Jgs/4q1TU1hsHRcmAwW1h
         EgYmUPJMt0KZoUzFN/ukq+zhjtFZRGz5SopEeJHPjtbCbk9yOk+spEriKgbZuSrz9CII
         fbx6upw9Vi5ywhnv0or9Vw7V4JZgbxis4CfGAQhCPycb9TBMBZWddgeOAGSn64+axttn
         VMEfr78Pm5s492uFEJz5iXvk6kJVQw8YNGbEPAZLwzeFMSEDe8Gicw3UsKssLDHd8hWk
         d4Yw==
X-Gm-Message-State: AAQBX9dN1q3OMfQWXoQC2U/xQkqMxpl4kOW+a0KF/s6BY2t1HIYPZFLj
	woi5NALEUYEGClXF+/jOHwopUGm60As=
X-Google-Smtp-Source: AKy350b63N/z5xs9NWQe+Xzd9HYhlJjhHJ9wsmtc2tjjz7mh4ninFi18LOOb1YEpPeCHA5TDzNeRfFgcGVw=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:168d:b0:b26:47f3:6cb with SMTP id
 bx13-20020a056902168d00b00b2647f306cbmr8882729ybb.4.1680049312210; Tue, 28
 Mar 2023 17:21:52 -0700 (PDT)
Date: Tue, 28 Mar 2023 17:21:35 -0700
In-Reply-To: <20230329002136.2463442-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230329002136.2463442-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329002136.2463442-2-reijiw@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Restore the host's PMUSERENR_EL0 value instead of clearing it,
before returning back to userspace, as the host's EL0 might have
a direct access to PMU registers (some bits of PMUSERENR_EL0
might not be zero).

Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h       | 3 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..82220ecec10e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -544,6 +544,9 @@ struct kvm_vcpu_arch {
 
 	/* Per-vcpu CCSIDR override or NULL */
 	u32 *ccsidr;
+
+	/* the value of host's pmuserenr_el0 before guest entry */
+	u64	host_pmuserenr_el0;
 };
 
 /*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..44b84fbdde0d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -82,6 +82,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_arm_support_pmu_v3()) {
 		write_sysreg(0, pmselr_el0);
+		vcpu->arch.host_pmuserenr_el0 = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
 
@@ -106,7 +107,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3())
-		write_sysreg(0, pmuserenr_el0);
+		write_sysreg(vcpu->arch.host_pmuserenr_el0, pmuserenr_el0);
 
 	if (cpus_have_final_cap(ARM64_SME)) {
 		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
-- 
2.40.0.348.gf938b09366-goog

