Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732671FA5
	for <kvmarm@lists.linux.dev>; Sat,  3 Jun 2023 02:51:21 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-53f6e194e7bso2506547a12.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 19:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685760680; x=1688352680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2SBYW84L/m+RDCA19ekjkbKA/bg9Rb+RSkEF96qBDgs=;
        b=1BcDQfkzkfe0i2bUABNsoY/fv0w3MChr1jJqEU1n5t/4gQTnzoRWB7gRfTWMfu0/mq
         StQhrK4POlXN0TeajosvdJpgLIDh4y/h3gR+xD8ja8duhQea+WGjU8/WBf0nC/hI8xjz
         gp9KhTAp/Ox67+UgDbbucgvc1UU3yHRhe2N+1cnIf6IfyR4VlJ4SlEfgKgqzMEsjClqC
         W7OoNYZpeUqhnNmZGwpmqeH2+Xv6OHIEh8QTSoEqgZHKONTkBsh53tUOEsZSonpd6Ekv
         P4OP3+yr4H0UCyMlwnpABk0ceKHRM9J/c4j61GlTNidkXbvJf+dnWXsyxRQDlgjl2oFI
         WD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685760680; x=1688352680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2SBYW84L/m+RDCA19ekjkbKA/bg9Rb+RSkEF96qBDgs=;
        b=ghopejAHH5a7roRjGeh97dLoLlsaps27tKS4tyTHoj6Z/mjBPoe5zJxEmpFddavnrG
         g6wTSyuFD+7ijoVDjk+ofgC2caPZ0/8esxsBw+aZ8LYYXNa+7GDvJI3YpWn5m6mjAffX
         f/4NS3/33be0yvcnR35+Cob2NOkQcutp0MVk9Px08e4JaBvcBHlrAbJhNCt48s2uOssg
         PHvkJJRvJsYN3xroVm3BfizUxKc8UGR3VJvgyBf7s6oGQcmDKqfPs5qIByg4DoNtams8
         Oq+LTH55M/gvsTK93DYkVu7K6HzGkk+1QraZ98hZy/ITnlenH14CyRNfKyesu+75SpRb
         SUBQ==
X-Gm-Message-State: AC+VfDzwCEqKwXs7wlF3EcOFR+qjHDxlcK50a0JjEGsbI3Q0ac/HmFm5
	x2jvNIH06qL53jWxdwDzOV3wG7mNzNs=
X-Google-Smtp-Source: ACHHUZ7F41GX4kI7XUmhvJo2WeUg7o8g2JM34l5sTdU0OOY63gxJLffhrx6c9AFBJ63aEnrO/XTy+PrLYBc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a65:47c9:0:b0:53f:6f7c:554e with SMTP id
 f9-20020a6547c9000000b0053f6f7c554emr2728965pgs.12.1685760680506; Fri, 02 Jun
 2023 19:51:20 -0700 (PDT)
Date: Fri,  2 Jun 2023 19:50:34 -0700
In-Reply-To: <20230603025035.3781797-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230603025035.3781797-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230603025035.3781797-2-reijiw@google.com>
Subject: [PATCH v5 1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
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
index e78a08a72a3c..51229d847103 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -82,7 +82,12 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
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
 
@@ -106,8 +111,12 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
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
2.41.0.rc0.172.g3f132b7071-goog

