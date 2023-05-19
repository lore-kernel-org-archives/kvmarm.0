Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F22362
	for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 00:52:38 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-76c365e0114so417905339f.3
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 17:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457557; x=1687049557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Jo/RCBNZEVvtCkzM3auZwKFc9mCMN65uMrYmj8Cg6c=;
        b=kBespD8hLjQXTQczEpM+vtlVlvFRNvCvTwFkfOOMbDJNZGnbpkolporHMFfB8gqI+r
         4Swj3TIK/pJudwZ4nwJn0CA9k9ZC4Ni7zhcNjYzPweBpisRgVJ5jEq6jsD1AiZlwV7de
         0dQLS3rMgDzJGHCtnWKs3cO3VBGqa1/sOj8vMeZsBfDu2/CjK7AH5mweDyyi6XIBj7sr
         8Z3OmXV4+eNON2F9Gu3pHJO2lT3w4v+vDaojHuDwiiZoIAFtnC3uxbWj3QCtyPMVM036
         bp9nXnILknAgqio//mWIB3wZvVMy4jX0mqescCGh9GQZd77HNzTxW1BXEyPie8DgwGQN
         caRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457557; x=1687049557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Jo/RCBNZEVvtCkzM3auZwKFc9mCMN65uMrYmj8Cg6c=;
        b=QonlJ0vqw9+yBmOjLRH7wzYa8Op9NiiNJZmTaEpWKRM2VfQ8HGqvUniFgLTDHRlyZu
         778Ls9EOErCXprFtgvAMwOr/nZVk8HeIgav+cq5ZA5ZzHSjNmrYlzWidzNGoPOZTeamJ
         p9sHByu5YPg3VMTIk/LOmEdGX1rvA4s/D4a78NGA7vAJrf6JwMLJJ6w5SZ6DDsPnWuxy
         8ZCgQRoHd0BK+yDXlrg9CQzgCVbtphj+bjFzy7dY6xa6O8z/8DVEPYwDKtoOGet0jPG4
         +vgmuuwfA63o8L6i4Mj5h/QuZrw3jPgZCEZJzJcI5E3yVcBrVofJEMA5OhzG3iYr6T9S
         mG2A==
X-Gm-Message-State: AC+VfDwfcI65R2ArZzkZgKPWylY2vbpkUS1tUdlNiv+T9BjoTN9fI2Zd
	bUDFwtrqQ8JgPRihkvWSGMVHhRHPpR9k
X-Google-Smtp-Source: ACHHUZ6jvrPcWHxA7WBN9olQ1vxAdHrwW+CSix/U34owWIIgzWv9ikGQKqOo589qtSQqIbhWXYTMGpi013xy
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5e:8e4b:0:b0:76c:6fd8:282 with SMTP id
 r11-20020a5e8e4b000000b0076c6fd80282mr87940ioo.2.1684457557713; Thu, 18 May
 2023 17:52:37 -0700 (PDT)
Date: Fri, 19 May 2023 00:52:27 +0000
In-Reply-To: <20230519005231.3027912-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-3-rananta@google.com>
Subject: [PATCH v4 2/6] KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Ricardo Koller <ricarkol@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
to flush a range of stage-2 page-tables using IPA in one go.
If the system supports FEAT_TLBIRANGE, the following patches
would conviniently replace global TLBI such as vmalls12e1is
in the map, unmap, and dirty-logging paths with ripas2e1is
instead.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 39 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/tlb.c       | 35 +++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43c3bc0f9544d..33352d9399e32 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
@@ -225,6 +226,8 @@ extern void __kvm_flush_vm_context(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
+extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+					phys_addr_t start, phys_addr_t end);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 728e01d4536b0..81d30737dc7c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -125,6 +125,16 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
+static void
+handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
+	DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
+
+	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, end);
+}
+
 static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -315,6 +325,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 978179133f4b9..d4ea549c4b5c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -130,6 +130,45 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t start, phys_addr_t end)
+{
+	struct tlb_inv_context cxt;
+	unsigned long pages, stride;
+
+	/*
+	 * Since the range of addresses may not be mapped at
+	 * the same level, assume the worst case as PAGE_SIZE
+	 */
+	stride = PAGE_SIZE;
+	start = round_down(start, stride);
+	end = round_up(end, stride);
+	pages = (end - start) >> PAGE_SHIFT;
+
+	if (!system_supports_tlb_range() || pages >= MAX_TLBI_RANGE_PAGES) {
+		__kvm_tlb_flush_vmid(mmu);
+		return;
+	}
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	/* See the comment below in __kvm_tlb_flush_vmid_ipa() */
+	if (icache_is_vpipt())
+		icache_inval_all_pou();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 24cef9b87f9e9..f34d6dd9e4674 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -111,6 +111,41 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t start, phys_addr_t end)
+{
+	struct tlb_inv_context cxt;
+	unsigned long pages, stride;
+
+	/*
+	 * Since the range of addresses may not be mapped at
+	 * the same level, assume the worst case as PAGE_SIZE
+	 */
+	stride = PAGE_SIZE;
+	start = round_down(start, stride);
+	end = round_up(end, stride);
+	pages = (end - start) >> PAGE_SHIFT;
+
+	if (!system_supports_tlb_range() || pages >= MAX_TLBI_RANGE_PAGES) {
+		__kvm_tlb_flush_vmid(mmu);
+		return;
+	}
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
-- 
2.40.1.698.g37aff9b760-goog

