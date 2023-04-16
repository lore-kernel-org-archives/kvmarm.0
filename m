Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CEC7B
	for <kvmarm@lists.linux.dev>; Sun, 16 Apr 2023 04:53:47 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id f66-20020a255145000000b00b7f75c3cafdso6328894ybb.16
        for <kvmarm@lists.linux.dev>; Sat, 15 Apr 2023 21:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681620826; x=1684212826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z2M63eTttyiy9/bDAykyJM/0pATtpC5A2Oom8LHCZ9k=;
        b=mMpx3Bnz+YyuerVz2UYMMxm87U+L3QFxU+9+ZoC0ZIL3v0qe1yV+kSwsRevNY7WVL5
         MR3zlG9AVCgWTuj+rBn1/UYn4kvLz9njcJLviGpX8iWr8zudxa/Y2LRLJ5LnjoatKTjF
         TEeOWgGszxzohxE20eR0T2QrvwvBMkjPSQArc7PHFvkM7NNJUzKr1rQRVqy25AgAbzMC
         fy49X2o59VmPoGlQx0sthP2bDyxgeyyx7smEMOrobsIm+QPxabfAp8upRH7YuQjCYkFs
         HluGNUOc/4gj8BE0MfJHU27lSWPedBgZ0vu/wq8eMRaDjsm02vYNpTjQ1b+pbqfgnL9k
         tV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681620826; x=1684212826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z2M63eTttyiy9/bDAykyJM/0pATtpC5A2Oom8LHCZ9k=;
        b=QjylZZcDfXottptMgtewFA2gzf76AHxQDvNSgjDESK4NcMoXwUxBhrli9JsARh1iLX
         LpPqo/+wrBYMJjhm15shoOK51nAKmQvVHubPjCLko1ug5xj3B2zbN1ahHil2wUSU3BZO
         komfIe+z1qPHIV5mxArzxMsVyQFKxO4w+8QAWgSzlPH1K6S3CYFnvh7Rwu4qqNPgoSfY
         T8bJCa/bids/JuQcEK7brKjPVyp91Flix0WlFtDh2tLTHY80v9glHLQSlqM9KkbYkomi
         JjJsOKVYgCYLKJa9Z7tXteYS+TFfOVM5fmeqXrhbyB5TchCQ/RRmdS2bngFtyJ9gOI7C
         4/dA==
X-Gm-Message-State: AAQBX9cLizkYc/NkEMxTGBzARFSniAHBBsh69YY5Hj9y/32fxkGvxsSV
	X5Rs7gjWp6yPrqUq+9o0n2qXZexvCf4=
X-Google-Smtp-Source: AKy350ay38/hP/VbicPQnxi2ZFSp00i/m3tOLdWXYluI8u83RZnoCL7i/3Eo9oxtJIjidgaymKWAod4ejj8=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:cc05:0:b0:b8b:eea7:525a with SMTP id
 l5-20020a25cc05000000b00b8beea7525amr5425476ybf.7.1681620826160; Sat, 15 Apr
 2023 21:53:46 -0700 (PDT)
Date: Sat, 15 Apr 2023 21:53:15 -0700
In-Reply-To: <20230416045316.1367849-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230416045316.1367849-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230416045316.1367849-2-reijiw@google.com>
Subject: [PATCH v4 1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
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

