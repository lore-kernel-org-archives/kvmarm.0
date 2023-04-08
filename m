Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F30B1841
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 03:50:02 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-54c17fb245dso58125307b3.21
        for <kvmarm@lists.linux.dev>; Fri, 07 Apr 2023 20:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680925801; x=1683517801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+eQXKVk5bYBI9kU8FS6e9Eu8uo6AIYsLflVePzrnFLQ=;
        b=SvK9ArDgnmx3fnPqMxJtEL2EA8PQv5DaUsFb6ZhMPOQepiwwC73rxTSDunhfEkk/hU
         lIrPhL/eSC9EoyNsh2z9zTlSbXOc8aC1/gI0pXPrSjcY/WGhzGHiOZVJXXMH0Ne4Zm3Q
         woXlPoIZ/UBXaFlpUwYfR2e16fwzEEUkotPHhtuzo6vYP7RviWYk1/hG+eBoul5Cvqiw
         uw4a0Jx5+5Uzsbt2ouA3tcov2AMkRU42V3r4BS4uKeoppaj3o8Kh0J8mEY+kWv7f7a26
         R0PWrAw6cB0T32t0JvK7/BT50X9Yzgu6qCZ7KGQ+eiL0FwPr39lUs0epEeITVdvkS8Th
         69ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680925801; x=1683517801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+eQXKVk5bYBI9kU8FS6e9Eu8uo6AIYsLflVePzrnFLQ=;
        b=Q0jdDFxyc/Odz72gkZ5qP6/UsF6nSAYEEei/4OPYtGzQBMy2jcEGb46G2BTUULk8n8
         jafb9n481ZvgWTwHoweGnUX2IUrndG9dqd0E5ueWcuiNs0I64MnfpShvbRVRZ5qWXHSC
         y+NEeaB7GR+l+5JuFRRjdwrPM823RDoNizCYOuUwBUlANBcMc9ep3FNUn8GP2dm6VKKi
         polsiRRRrt5XgpwRBXKHg8gJLIdBKAWh0v1jtX3pyFIs6agtNa7vY+6GWxsk+TfYwZzJ
         pEE+7XsvgvrDNSK7pCHSRjx5Mez4cffpdNkMZmRbRFhpgjZUzQGicL2jAomQVevEfC7e
         SRnw==
X-Gm-Message-State: AAQBX9dqZ9ItSrYdwzlXMHf2V0HDRjxbgEOpWiVh/tivGXYLsGNtJy/0
	gKc3QE7f2IHR0ez7Sp2Gq3TQfar8oog=
X-Google-Smtp-Source: AKy350aQRt6i1U1RtZLFdPCYuwN2ajZD+RcM1fazysdk8uRYX0B7k4CJYjFtfCXeA2/8+WqTdrbecudjLxI=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:cfcf:0:b0:b8b:f1ac:9c6c with SMTP id
 f198-20020a25cfcf000000b00b8bf1ac9c6cmr3106735ybg.3.1680925801503; Fri, 07
 Apr 2023 20:50:01 -0700 (PDT)
Date: Fri,  7 Apr 2023 20:47:58 -0700
In-Reply-To: <20230408034759.2369068-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230408034759.2369068-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230408034759.2369068-2-reijiw@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
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
2.40.0.577.gac1e443424-goog

