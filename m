Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D0824F28
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:20:13 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id p18-20020a63e652000000b0046b27534651so83514pgj.17
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FB9/txOY21wW/TPsgqc6j4ZQ11jhPkkdawz9sPCSXNA=;
        b=Gh0pNKJAjUP7sOLxgeINR/cbIHMm/TCvJmesgDmGY7tgu6P6YXBVfYIXTfojpYFhsq
         HkT9AYvu2cJGezPMeBp64lBMsTUd9ONRFB5hypdMyN7za0hetccYQckOK26B+CDbxF6r
         +OhS46uwFsSqDvUawxhpwU4TdzcYBw50A+ZMoD8n+DmjlNK3aB9aXy9DkBx+JSHJ6ISO
         pjQ1VfDtpdTwM/Mhh3TXxzf4TORrG3FqJQ2hX6AUGnQSwf155R85whsuIiWoEQQ1/uAN
         5ZiQXw1v8DLP7PBHC5uyXihM2rPnRlLj9wclnfoxTX04fyoZeThV5J1v6/TU+dV2434R
         khBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FB9/txOY21wW/TPsgqc6j4ZQ11jhPkkdawz9sPCSXNA=;
        b=XcZmK4Cxl4CnqZrvEJn7GX1Ee6j2rapQmTH5aQkOgrRu5ZwBLcVz2KTPHysL8g3z43
         LhMAOEhZWRADW1gz2n5dL54acKXOfavUcD1BLOOtebpZbw8y2HoWkEQGKfuEOgF1CKW0
         UHpSE3q72IgVWuwonZWnOzBa7aKGpUYGwfGMs7plWqXdo0c2R2jW9a7cGtFGeWpVSl1n
         iPcrtn1QE9vzELNIWF2zNZbiGxhklMDfwrt84GC1vsJxJR55O2O9TNyG4SEFWs7/PuSW
         B5AF2VTmLvA1yNb7qqRpazVjDvaBrJB9WvLW81/KOwoJ/E5iQE4g7WiH6BWXwhAycY13
         9t6Q==
X-Gm-Message-State: ACrzQf3wEn21T1R0pJBpQ0ZY8EH5M7uuCyPZqFNpbCLFOJ+I71zMf2hg
	KXCpB02arxd7pZrExGu2Y5JMCXRuNJ0=
X-Google-Smtp-Source: AMsMyM7nfKY/wHJ8tA5FRpJD6/RIsVOrpmudYjvQ2DhJNYVckSrzlEN04CTpOiyaCyk531P1edibX7B9dbc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3698:b0:56d:3180:e88f with SMTP id
 dw24-20020a056a00369800b0056d3180e88fmr24063664pfb.66.1667431212769; Wed, 02
 Nov 2022 16:20:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:19:01 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-35-seanjc@google.com>
Subject: [PATCH 34/44] KVM: VMX: Shuffle support checks and hardware enabling
 code around
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221102231901.FbeGDaCuy-O8qyhj0wzhUTaHuS738HtNQO0l_5oIZSw@z>

Reorder code in vmx.c so that the VMX support check helpers reside above
the hardware enabling helpers, which will allow KVM to perform support
checks during hardware enabling (in a future patch).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 212 ++++++++++++++++++++---------------------
 1 file changed, 106 insertions(+), 106 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2a7e62d0707d..07d86535c032 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2485,77 +2485,6 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-static int kvm_cpu_vmxon(u64 vmxon_pointer)
-{
-	u64 msr;
-
-	cr4_set_bits(X86_CR4_VMXE);
-
-	asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
-			  _ASM_EXTABLE(1b, %l[fault])
-			  : : [vmxon_pointer] "m"(vmxon_pointer)
-			  : : fault);
-	return 0;
-
-fault:
-	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
-		  rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
-	cr4_clear_bits(X86_CR4_VMXE);
-
-	return -EFAULT;
-}
-
-static int vmx_hardware_enable(void)
-{
-	int cpu = raw_smp_processor_id();
-	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
-	int r;
-
-	if (cr4_read_shadow() & X86_CR4_VMXE)
-		return -EBUSY;
-
-	/*
-	 * This can happen if we hot-added a CPU but failed to allocate
-	 * VP assist page for it.
-	 */
-	if (static_branch_unlikely(&enable_evmcs) &&
-	    !hv_get_vp_assist_page(cpu))
-		return -EFAULT;
-
-	intel_pt_handle_vmx(1);
-
-	r = kvm_cpu_vmxon(phys_addr);
-	if (r) {
-		intel_pt_handle_vmx(0);
-		return r;
-	}
-
-	if (enable_ept)
-		ept_sync_global();
-
-	return 0;
-}
-
-static void vmclear_local_loaded_vmcss(void)
-{
-	int cpu = raw_smp_processor_id();
-	struct loaded_vmcs *v, *n;
-
-	list_for_each_entry_safe(v, n, &per_cpu(loaded_vmcss_on_cpu, cpu),
-				 loaded_vmcss_on_cpu_link)
-		__loaded_vmcs_clear(v);
-}
-
-static void vmx_hardware_disable(void)
-{
-	vmclear_local_loaded_vmcss();
-
-	if (cpu_vmxoff())
-		kvm_spurious_fault();
-
-	intel_pt_handle_vmx(0);
-}
-
 /*
  * There is no X86_FEATURE for SGX yet, but anyway we need to query CPUID
  * directly instead of going through cpu_has(), to ensure KVM is trapping
@@ -2781,6 +2710,112 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
+static bool __init kvm_is_vmx_supported(void)
+{
+	if (!cpu_has_vmx()) {
+		pr_err("CPU doesn't support VMX\n");
+		return false;
+	}
+
+	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
+	    !boot_cpu_has(X86_FEATURE_VMX)) {
+		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL\n");
+		return false;
+	}
+
+	return true;
+}
+
+static int __init vmx_check_processor_compat(void)
+{
+	struct vmcs_config vmcs_conf;
+	struct vmx_capability vmx_cap;
+
+	if (!kvm_is_vmx_supported())
+		return -EIO;
+
+	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
+		return -EIO;
+	if (nested)
+		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
+	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
+		pr_err("CPU %d feature inconsistency!\n", smp_processor_id());
+		return -EIO;
+	}
+	return 0;
+}
+
+static int kvm_cpu_vmxon(u64 vmxon_pointer)
+{
+	u64 msr;
+
+	cr4_set_bits(X86_CR4_VMXE);
+
+	asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : [vmxon_pointer] "m"(vmxon_pointer)
+			  : : fault);
+	return 0;
+
+fault:
+	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
+		  rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
+	cr4_clear_bits(X86_CR4_VMXE);
+
+	return -EFAULT;
+}
+
+static int vmx_hardware_enable(void)
+{
+	int cpu = raw_smp_processor_id();
+	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
+	int r;
+
+	if (cr4_read_shadow() & X86_CR4_VMXE)
+		return -EBUSY;
+
+	/*
+	 * This can happen if we hot-added a CPU but failed to allocate
+	 * VP assist page for it.
+	 */
+	if (static_branch_unlikely(&enable_evmcs) &&
+	    !hv_get_vp_assist_page(cpu))
+		return -EFAULT;
+
+	intel_pt_handle_vmx(1);
+
+	r = kvm_cpu_vmxon(phys_addr);
+	if (r) {
+		intel_pt_handle_vmx(0);
+		return r;
+	}
+
+	if (enable_ept)
+		ept_sync_global();
+
+	return 0;
+}
+
+static void vmclear_local_loaded_vmcss(void)
+{
+	int cpu = raw_smp_processor_id();
+	struct loaded_vmcs *v, *n;
+
+	list_for_each_entry_safe(v, n, &per_cpu(loaded_vmcss_on_cpu, cpu),
+				 loaded_vmcss_on_cpu_link)
+		__loaded_vmcs_clear(v);
+}
+
+static void vmx_hardware_disable(void)
+{
+	vmclear_local_loaded_vmcss();
+
+	if (cpu_vmxoff())
+		kvm_spurious_fault();
+
+	intel_pt_handle_vmx(0);
+}
+
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 {
 	int node = cpu_to_node(cpu);
@@ -7466,41 +7501,6 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static bool __init kvm_is_vmx_supported(void)
-{
-	if (!cpu_has_vmx()) {
-		pr_err("CPU doesn't support VMX\n");
-		return false;
-	}
-
-	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
-	    !boot_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL\n");
-		return false;
-	}
-
-	return true;
-}
-
-static int __init vmx_check_processor_compat(void)
-{
-	struct vmcs_config vmcs_conf;
-	struct vmx_capability vmx_cap;
-
-	if (!kvm_is_vmx_supported())
-		return -EIO;
-
-	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
-		return -EIO;
-	if (nested)
-		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
-	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
-		pr_err("CPU %d feature inconsistency!\n", smp_processor_id());
-		return -EIO;
-	}
-	return 0;
-}
-
 static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;
-- 
2.38.1.431.g37b22c650d-goog

