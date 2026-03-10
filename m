Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CDD3EE1D4
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147002; cv=none; b=CjcDcfN8W2xHeXA4eX3G0NzmBxi/HG0YNbUCr8EUctN54uLBWzqAZuH0+TwCm4SPDr0IcQQHZhQEwtPBFLssod1SS8ff9sCbV49L/4EEq4CT++GkjmENfBLfwbLBOfjSZ9tyAyX8ML9wP9oYFUgWCUut3oV4lzNk4RD5MdpwAZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147002; c=relaxed/simple;
	bh=63KweO9P+FBqDWP+uz4wXBFXl+Gx6XDUn+f16gacMkw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UxILVcCymU6xT3CuDuU4ic2E56N+XsIDv8jsuASUvYM4l/ZHhxrvIgIZICJKUHgw/8XFZeLM4wGWRJg09MAKIs4tU7nB1+B0fboTqivKbbRLLHBMEYw7RvZoLSyfSQLq2OX8l/eR74uv+M669f13uYMuA3bYybhJMBU5ybWHvNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H5tuT2js; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H5tuT2js"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485390246c8so25977845e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146999; x=1773751799; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mh5fFUja/4mDlRa8xj9RozoLiOFoKZimG1GpvA9+1Yc=;
        b=H5tuT2jsGQdGPQekgLzn3egDutpE71Cy69pJHc5oKTTPsllPFGaEIP1Hn51okNaWbK
         58gGyq29j2g9+lsaQoNqVMnVuY0p1iCxqpHHlZevc5y4y3nKnKF7wOEfQhP40fk7enfE
         4AxFvlOTVeKE/q8Eyqa7Q+K2wg3IuEZ4rjtwBXo/zo5EScxtNqz7QnUlNz13v9CyKklS
         XcPvJTyIHc+OiC/O0vOxDikCafPtQZg08xb9XCMmElP+5DriuRQnJiibIYwP+DmzYfeQ
         W/jxHl3oYqGqE6X+DuZkXV2EMWvOQ/sn7JHJQ/7uC+7k9712VK7OQiTy4xMmvooELAtV
         NUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146999; x=1773751799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mh5fFUja/4mDlRa8xj9RozoLiOFoKZimG1GpvA9+1Yc=;
        b=d58F0DXHOl9xyEfLLwEOkgpDaq2/l+YWBSZ1h+dbh4GXdWrzq5/9jUU9U4hwmSuDy2
         8DigNCYmBiAN8ImJ8vez14TSgxUatfzgNZ3N+gtJ+ZUvYt1qXfZsniIHgC7CwIRwHzlU
         aXU4XtkXrIWQ0cqeJqD671MtmNaS+VrR8Ued1dvlV4UOfuCFT7lu7t7AzLQl7GwmRwcC
         Wgup56XvoUXBjvzSN83oGqnAb3LVbh2VGaKYYmsFw+yGrjMdU9sWYUM2nthnuf8ZT0z0
         QUiiYB1pA0rrj6KZ7yTC0LnMOU2fMRkuKcWrlrARkRYwRdimTT3j2dTADs54VRQ8+Ltu
         Kwzw==
X-Forwarded-Encrypted: i=1; AJvYcCXlrvvn5XFGWtjb9SgGg6jIfm/bELCxaZ4uJ5xEQzJ6A4TQ7SsmKBO6nh8PRZSsiLUl8PMwH0A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBihSaaOXWxSp2Ms/KL9NLu2aYDMn33zkhomYUDaOn63m8vvYa
	5YaiAIhEKpXMRgEatsgK7avV+mtLBz80ov//sdgOX0viX9ztNuVZKcLgpOJUtY0GTmg3x3fqlkx
	NjPGdz9N5Zl6DEa4uSPq9MB5crM8SCA==
X-Received: from wmqy3.prod.google.com ([2002:a05:600c:3643:b0:482:ef72:5793])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4445:b0:483:a27e:6706 with SMTP id 5b1f17b1804b1-48526922533mr269324465e9.9.1773146999106;
 Tue, 10 Mar 2026 05:49:59 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:33 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-15-sebastianene@google.com>
Subject: [PATCH 14/14] KVM: arm64: Implement HVC interface for ITS emulation setup
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Introduce a new HVC to allow the host to trigger the ITS emulation
setup.

This interface notifies the ITS driver that hypervisor initialization is
complete. Upon invocation, the hypervisor replaces the initial
"trap-and-forward" MMIO handler with a full-featured emulation handler.
This transition enables mediated access to the ITS hardware, enforcing
the verifications required for a protected hypervisor environment.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_pkvm.h  |  3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 14 ++++++++++++++
 arch/arm64/kvm/pkvm.c              | 24 +++++++++++++++++++++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a1ad12c72ebf..550dafee88ef 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___pkvm_init_its_emulation,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index dc5ef2f9ac49..20fb2678a9b9 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -35,7 +35,8 @@ extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
 extern unsigned int kvm_nvhe_sym(num_protected_reg);
 extern void kvm_nvhe_sym(pkvm_handle_forward_req)(struct pkvm_protected_reg *region, u64 offset,
 						  bool write, u64 *reg, u8 reg_size);
-
+extern void kvm_nvhe_sym(pkvm_handle_gic_emulation)(struct pkvm_protected_reg *region, u64 offset,
+						    bool write, u64 *reg, u8 reg_size);
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7790097db93..4e58e24a1eed 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -14,6 +14,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/its_emulate.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -421,6 +422,18 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
+static void handle___pkvm_init_its_emulation(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, dev_addr, host_ctxt, 1);
+	DECLARE_REG(void *, its_state, host_ctxt, 2);
+	DECLARE_REG(struct its_shadow_tables *, shadow, host_ctxt, 3);
+
+	if (!is_protected_kvm_enabled())
+		return;
+
+	cpu_reg(host_ctxt, 1) = pkvm_init_gic_its_emulation(dev_addr, its_state, shadow);
+}
+
 static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
@@ -630,6 +643,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__pkvm_init_its_emulation),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index a766be6de735..5399998d5235 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -6,6 +6,7 @@
 
 #include <linux/init.h>
 #include <linux/interval_tree_generic.h>
+#include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kmemleak.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
@@ -62,7 +63,7 @@ static int __init register_protected_regions(void)
 
 		pkvm_protected_regs[i].start_pfn = res.start >> PAGE_SHIFT;
 		pkvm_protected_regs[i].num_pages = resource_size(&res) >> PAGE_SHIFT;
-		pkvm_protected_regs[i].cb = lm_alias(&kvm_nvhe_sym(pkvm_handle_forward_req));
+		pkvm_protected_regs[i].cb = lm_alias(&kvm_nvhe_sym(pkvm_handle_gic_emulation));
 		i++;
 	}
 
@@ -286,16 +287,37 @@ static void __init _kvm_host_prot_finalize(void *arg)
 		WRITE_ONCE(*err, -EINVAL);
 }
 
+static int pkvm_init_its_emulation(phys_addr_t dev_addr, struct its_shadow_tables *shadow)
+{
+	void *its_state;
+	int ret;
+
+	its_state = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	if (!its_state)
+		return -ENOMEM;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_init_its_emulation, dev_addr, its_state, shadow);
+	if (ret)
+		free_page((unsigned long)its_state);
+
+	return ret;
+}
+
 static int __init pkvm_drop_host_privileges(void)
 {
 	int ret = 0;
+	void *flags;
 
 	/*
 	 * Flip the static key upfront as that may no longer be possible
 	 * once the host stage 2 is installed.
 	 */
 	static_branch_enable(&kvm_protected_mode_initialized);
+
+	flags = its_start_depriviledge();
 	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
+	its_end_depriviledge(ret, flags, &pkvm_init_its_emulation);
+
 	return ret;
 }
 
-- 
2.53.0.473.g4a7958ca14-goog

