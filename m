Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65C847CA71
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121045; cv=none; b=d9VZE5Ksa2zmDV/q0YZ537WtPfIP3ym2mhLNdzo+oQIkGFfUq9stZHzSfV9dw4zw2zfsHfN25bqbbf99rHvhOf8mkc+Q7jzzo0ZVa8CFEN9dOsLiuosRiD8DBwtKLHQamouk1aNiwxh9YUYNYLe8Ut0yjOPFUBCdZ69UojQInxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121045; c=relaxed/simple;
	bh=dG75R9t60p8la9dDfP9piGZZE5hhgOort9SadpwYw1Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O721vY5XXM1H95T3W2KQxYUKiyndBC794x8XeInDFNEFNcvt0gffK6l+B4b6B/s7VgeNuYR/+xXc6VxNwg03BNFyWtYuq79E3D6SLzsd2brXnXFLE7ByGiBVqQgVVs9GXF5rtGPtUFOgMxTBP4HSiIyf6GvCPgn+QAjT6WI8BRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MdCmZsUi; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MdCmZsUi"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-495474a5fbcso31230155e9.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121037; x=1786725837; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qlULfceAkSyqJh1I9C7h7VPnh2+5JOHQToDbI7j6Lxc=;
        b=MdCmZsUi+Rz7DK6cyfUflU27tEssj8X0se7vMaqlR66EzrUeIcQwoMr44oxRzJmloS
         UvlqbAndPuBpJIP16AzzPz0HjKVPu2Hfttrp5vZO+Q9lNR6y0PYbO/qu/HGgSH8TTnpb
         kvTkx+6ckr4BuFLpg7/fZ6CEMdLBA4bignVkaIOpd57G5JDUdVmZNtIPBbaD8UnWOYbg
         F9MHe1wjd7sDqnkTe8TC4d07fvbY+6VnAqIYnR0mS3GK1zze0SNKyrulaaBGURanhnvA
         +TNRD1yQxaPq3p1MZMGNmrhDgzDXMoM9gJc80MgPlcCFeSRUNEkFwWROmDUcEwkgsR+/
         rDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121037; x=1786725837;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qlULfceAkSyqJh1I9C7h7VPnh2+5JOHQToDbI7j6Lxc=;
        b=Nqe25BAVETUP6DqpIR2FTIHklF2rQgqzCpZkfUDsYvURtuRAMzFXHFEOYDMuxdp7WS
         ODr11M3eE6moNxXAKOcegmMpHXtThmKmqolOCn9KBc+FOKClx8V//PT3tay0rtWuqaGY
         VVyAuSma6zscTtOWeqUOTSDnvoCbeh/7EBY+bmpcQe55O/eOG0nXTkblPuDK7rGyhweF
         SStGlKfzYKOz4ZofgmuQDvKdEKISJhwFikSv2EBsFpwx1Lf+AmhVzhTUtyRGJ4XlLNoo
         qmQ/d2VOtw+s4C4YKbtcs+aeixr4l1NzPilKklZ0wXtqz2wplCn9ck+jC1StyJPyCA3A
         IOjg==
X-Gm-Message-State: AOJu0Yx/8ZKSWkTpDnW5gcjJjr6J9YfjzP2rK92XeuOX+GddMNbN9zTo
	vADa7MkcLHJroKbaG8hQR241TX3iz6c9kw6ROIx2V2xq4t15dBm9CbtAQAXWuQIEV1mCKhuaqoh
	YU4nY/6yRtz1r+A5ur8IWmd2ODLN/uA==
X-Received: from wmbjx23.prod.google.com ([2002:a05:600c:5797:b0:495:58ee:fab7])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b01:b0:495:641a:bd3f with SMTP id 5b1f17b1804b1-4996199a076mr13517025e9.13.1786121037301;
 Fri, 07 Aug 2026 09:43:57 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:23 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-15-sebastianene@google.com>
Subject: [PATCH v2 13/13] KVM: arm64: Implement HVC interface for ITS
 emulation setup
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Introduce a new HVC to allow the host to trigger the ITS emulation
setup. Use the introduced API in the GIC ITS driver to call the driver
to lock the ITS before pKVM finalize and to prepare for emulation setup.
On the return path from the pKVM finalize, call into the driver to
release the ITS locks which performs a switch in the driver to use a
different command queue and a different set of level-1 indirect tables.
Allocate memory that will be used by the emulation to track the internal
state and send the snapshot state from the driver.
Replace the initial "trap-and-forward" MMIO handler with a full-featured
emulation handler.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_asm.h      |  1 +
 arch/arm64/include/asm/kvm_pkvm.h     |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/its_emulate.c |  4 ++--
 arch/arm64/kvm/pkvm.c                 | 26 ++++++++++++++++++++++++--
 5 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..fcb2871b8a86 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -114,6 +114,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___pkvm_its_emulate_setup,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
 };
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 78597210a53c..cc89e2bde468 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -32,8 +32,8 @@ struct pkvm_protected_reg {
 
 extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
 extern unsigned int kvm_nvhe_sym(num_protected_reg);
-extern void kvm_nvhe_sym(its_emulate_forward_req)(struct pkvm_protected_reg *region, u64 offset,
-						  bool write, u64 *reg, u8 reg_size);
+extern void kvm_nvhe_sym(pkvm_its_emulate_handler)(struct pkvm_protected_reg *region, u64 offset,
+						   bool write, u64 *reg, u8 reg_size);
 
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3df96ed8ba4..ad57b2076eee 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -16,6 +16,7 @@
 #include <asm/kvm_mmu.h>
 
 #include <nvhe/ffa.h>
+#include <nvhe/its_emulate.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
@@ -705,6 +706,20 @@ static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host_ctxt)
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
 
+static void handle___pkvm_its_emulate_setup(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, dev_addr, host_ctxt, 1);
+	DECLARE_REG(struct its_host_state *, host_state, host_ctxt, 2);
+	DECLARE_REG(void *, priv_state, host_ctxt, 3);
+	DECLARE_REG(size_t, priv_state_num_pages, host_ctxt, 4);
+
+	if (!is_protected_kvm_enabled())
+		return;
+
+	cpu_reg(host_ctxt, 1) = pkvm_its_emulate_setup(dev_addr, host_state, priv_state,
+						       priv_state_num_pages);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -762,6 +777,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__pkvm_its_emulate_setup),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 82dc60dcde68..8c8acaee4d2b 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -6,8 +6,8 @@
 
 #include <linux/irqchip/arm-gic-v3.h>
 
-void its_emulate_forward_req(struct pkvm_protected_reg *region, u64 offset, bool write, u64 *reg,
-			     u8 reg_size)
+static void its_emulate_forward_req(struct pkvm_protected_reg *region, u64 offset, bool write,
+				    u64 *reg, u8 reg_size)
 {
 	void __iomem *addr = __hyp_va(PFN_PHYS(region->pfn) + offset);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 4bfffbedac4c..a9ceb9ffe6a4 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -71,7 +71,7 @@ static int __init register_its_emulated_region(void)
 		 */
 		kvm_nvhe_sym(pkvm_protected_regs)[i].pfn = PHYS_PFN(res.start);
 		kvm_nvhe_sym(pkvm_protected_regs)[i].cb =
-			lm_alias(&kvm_nvhe_sym(its_emulate_forward_req));
+			lm_alias(&kvm_nvhe_sym(pkvm_its_emulate_handler));
 		kvm_nvhe_sym(pkvm_protected_regs)[i].nr_pages =
 			PFN_DOWN(min_t(u64, resource_size(&res), PAGE_ALIGN_DOWN(GITS_TRANSLATER)));
 
@@ -312,8 +312,28 @@ static void __init _kvm_host_prot_finalize(void *arg)
 		WRITE_ONCE(*err, -EINVAL);
 }
 
+#define ITS_PAGES	(2UL)
+
+static int pkvm_init_its_emulation(phys_addr_t dev_addr, struct its_host_state *host)
+{
+	size_t priv_state_sz = ITS_PAGES << PAGE_SHIFT;
+	void *priv_state;
+	int ret;
+
+	priv_state = alloc_pages_exact(priv_state_sz, GFP_ATOMIC);
+	if (!priv_state)
+		return -ENOMEM;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_its_emulate_setup, dev_addr, host, priv_state, ITS_PAGES);
+	if (ret)
+		free_pages_exact(priv_state, priv_state_sz);
+
+	return ret;
+}
+
 static int __init pkvm_drop_host_privileges(void)
 {
+	unsigned long its_flags;
 	int ret = 0;
 
 	/*
@@ -321,8 +341,10 @@ static int __init pkvm_drop_host_privileges(void)
 	 * once the host stage 2 is installed.
 	 */
 	static_branch_enable(&kvm_protected_mode_initialized);
+
+	its_emulate_acquire_locks(&its_flags);
 	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
-	return ret;
+	return its_emulate_release_locks(ret, &its_flags, pkvm_init_its_emulation);
 }
 
 static int __init finalize_pkvm(void)
-- 
2.55.0.654.g21b8a5bc05-goog

