Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABE6A44
	for <kvmarm@lists.linux.dev>; Sat, 15 Jul 2023 00:54:17 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-c0f35579901so2014432276.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 17:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689382457; x=1689987257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRNC6fA4vY9IIzTukCRjUclh2x+xk9hgJU6Rf1v4LlI=;
        b=GW/dL6s1ehKPh/5954DkfJFtt3h3bcvOw4zkislkY8qK/1gk4+IB9PZ0pWKbs7As/w
         WLd3uXnV+TeINcdWYtR2Ax9+3sunPIRl05fMKVwT6nxoKsWRIWuqU6T1AMR8PBIXGFMB
         ThxrhSRkJhAOyfKke14JFi4gXqsuF7cGsE+8y69+pCVSOBD2/EOplkKl5jdn7f1ymKki
         fux7ZH3kEaGgnTscwY7Wn3SmQKlRKcEJCnXC2VhKA8NnHtIjIbKmIdP3XUWRAdm2wVvS
         jqjXT7vnYWM0iLubSMIpiEg87B345lhKUXH+eRlPDsS8pyTgaSBcs0SbejpIZsn0E72D
         29PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689382457; x=1689987257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRNC6fA4vY9IIzTukCRjUclh2x+xk9hgJU6Rf1v4LlI=;
        b=dIKKu/PQIgCQzNETDI/ObhvHyRHd5xpbgYbLcuoJflp2f2sG25Xyrdpi3krUC5m9sG
         Nk+uod7f+LTq4u5OBi2GuA0D7vb+IIxSV2YZSreMNakKgsuQMe22adObFclQ5RHI/j6l
         qlEJwY6rE628GyaSTs2SN9GnE/yDMe/4tqEZtlp+T0wUYf3FcFlitSQlXrOxnwqS9+To
         ws1/Xhe/nZz60NqgILzfa77QBVaVKdsr39NnZZEc8VY1+CaeZJOH9AAscoLkPIodJjY2
         10SCTTzi6NV2sNbgwao3OJl6SAvOjc0NqbINjipc7h28mh8+rs1m9Mo52wrOPO/aDIcu
         sNsw==
X-Gm-Message-State: ABy/qLaZyxoAjr78YSSJEyZqFOi1a148EY7OLboblPMEmO5Qadwvoltw
	gbWTBTqFU3nswwobeD2W/BnPCDyoJyPn
X-Google-Smtp-Source: APBJJlEA9KEZVMk/ou9H9hfwDv90RgOlHXktQfG21vm7Jdj4BjS7QOiWzDLO5fSMZvDv9BrKfFrVIlqO7Eih
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:2551:0:b0:cb6:6c22:d0f8 with SMTP id
 l78-20020a252551000000b00cb66c22d0f8mr37682ybl.4.1689382457013; Fri, 14 Jul
 2023 17:54:17 -0700 (PDT)
Date: Sat, 15 Jul 2023 00:54:00 +0000
In-Reply-To: <20230715005405.3689586-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.455.g037347b96a-goog
Message-ID: <20230715005405.3689586-7-rananta@google.com>
Subject: [PATCH v6 06/11] KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, David Matlack <dmatlack@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
to flush a range of stage-2 page-tables using IPA in one go.
If the system supports FEAT_TLBIRANGE, the following patches
would conviniently replace global TLBI such as vmalls12e1is
in the map, unmap, and dirty-logging paths with ripas2e1is
instead.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/tlb.c       | 23 +++++++++++++++++++++++
 4 files changed, 67 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 7d170aaa2db4..2c27cb8cf442 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -70,6 +70,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa_nsh,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr,
@@ -229,6 +230,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 extern void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 					 phys_addr_t ipa,
 					 int level);
+extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+					phys_addr_t start, unsigned long pages);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a169c619db60..857d9bc04fd4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -135,6 +135,16 @@ static void handle___kvm_tlb_flush_vmid_ipa_nsh(struct kvm_cpu_context *host_ctx
 	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
 }
 
+static void
+handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
+	DECLARE_REG(unsigned long, pages, host_ctxt, 3);
+
+	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
+}
+
 static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -327,6 +337,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa_nsh),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_read_vmcr),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index b9991bbd8e3f..09347111c2cd 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -182,6 +182,36 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t start, unsigned long pages)
+{
+	struct tlb_inv_context cxt;
+	unsigned long stride;
+
+	/*
+	 * Since the range of addresses may not be mapped at
+	 * the same level, assume the worst case as PAGE_SIZE
+	 */
+	stride = PAGE_SIZE;
+	start = round_down(start, stride);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt, false);
+
+	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	/* See the comment in __kvm_tlb_flush_vmid_ipa() */
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
index e69da550cdc5..4ed8a1786812 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -138,6 +138,29 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	dsb(nsh);
 	__tlbi(vmalle1);
 	dsb(nsh);
+
+	__tlb_switch_to_host(&cxt);
+}
+
+void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t start, unsigned long pages)
+{
+	struct tlb_inv_context cxt;
+	unsigned long stride;
+
+	/*
+	 * Since the range of addresses may not be mapped at
+	 * the same level, assume the worst case as PAGE_SIZE
+	 */
+	stride = PAGE_SIZE;
+	start = round_down(start, stride);
+
+	dsb(ishst);
+	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
 	isb();
 
 	__tlb_switch_to_host(&cxt);
-- 
2.41.0.455.g037347b96a-goog

