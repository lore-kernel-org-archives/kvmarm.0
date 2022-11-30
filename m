Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44016C352A1
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB4AC4B650;
	Wed, 30 Nov 2022 18:10:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XgMBrz1j23Vt; Wed, 30 Nov 2022 18:10:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C3D4B742;
	Wed, 30 Nov 2022 18:10:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA22E4B649
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dfYDks04Cuwp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:45 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 651664B652
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:42 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 r17-20020a17090aa09100b0021903e75f14so154430pjp.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=dHU3XdySL+sqLW+/LrYmZDKEHUg9NLktQjaTwPQsVog=;
 b=c7btJG8Vz8oky7wiaNPxy35uhrDeANgOVQezTibSlYx2PbLSsMoH8mDkHjvWv43r2I
 DOyGFxiN/wlU13wd54TlpFEXVNRhIPVkrbT8VpB5+R7A+NORau1uqiIuKdNp1l9ZxS3q
 63CVt28/ps3LWgQLgldTdPmii2k6nYJPIndkTp9NkSDs8QnJA4J1ix03atRul1JJ3BJo
 V4dVc1X9caFKy+lQSJ06QfkENtsRL2kJnSrgxeyZLCJnwJ/oKQ1fSFF4sK0sqmL7zSo3
 SfI9db7qU+AzVLeBiqxZmQO+74EumASU/wum9bD/2lVaCR/4JTt9XngR5ZgsGJrmLu4R
 AyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=dHU3XdySL+sqLW+/LrYmZDKEHUg9NLktQjaTwPQsVog=;
 b=UtW9aS0csP6w5tSETFDRtcOLYkJc0IVxeFpMMt513nAXktSw42FRdFKp/8yWC1OcrP
 3F3bZriBY9nU2SKY4RBTPYpWj4pgRLoHgABjpZ1i5tWwZMIMABtvzPxzuZs1cTJh2GvG
 05/JrLXZr8fZqZQWLROFnTB5X0mJd2yLQzVhchq2wgL8tC7KX1VzM96KBs7OS+Xip4ng
 3EhJ7tDWcO5nHAv8xVG9ypUdP+BDbidcEsR7GU6KEYw9GAll77Ra/d7IvpBVcOQya8uE
 eoH1FqRNnuOgoV4vMbnZZpJZ47dco4odOG+6qwPcTHurNK/QAEbWyEIKderPiK7JOZT4
 hhuw==
X-Gm-Message-State: ANoB5pknUUo8Lil8qUHtN7jwjok8GV5wWmAmTZCwEjCmILBfKrGMtSsV
 NInItInLCSIciPIY+kmoO9s7BM3Bz+w=
X-Google-Smtp-Source: AA0mqf7lZJJIAb/z3d8ghyEmf3T+skYhpBDPK5HurVPIO9Y/yo5JSkPk3YpIVuNzGNu9rTBuuswE8IOM/i8=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:515:b0:189:90d4:3c03 with SMTP id
 jn21-20020a170903051500b0018990d43c03mr15127383plb.45.1669849841483; Wed, 30
 Nov 2022 15:10:41 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:21 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-38-seanjc@google.com>
Subject: [PATCH v2 37/50] KVM: VMX: Shuffle support checks and hardware
 enabling code around
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Reorder code in vmx.c so that the VMX support check helpers reside above
the hardware enabling helpers, which will allow KVM to perform support
checks during hardware enabling (in a future patch).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 216 ++++++++++++++++++++---------------------
 1 file changed, 108 insertions(+), 108 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 23b64bf4bfcf..2a8a6e481c76 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2485,79 +2485,6 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
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
-	hv_reset_evmcs();
-
-	intel_pt_handle_vmx(0);
-}
-
 /*
  * There is no X86_FEATURE for SGX yet, but anyway we need to query CPUID
  * directly instead of going through cpu_has(), to ensure KVM is trapping
@@ -2783,6 +2710,114 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
+static bool __init kvm_is_vmx_supported(void)
+{
+	if (!cpu_has_vmx()) {
+		pr_err("CPU doesn't support VMX\n");
+		return false;
+	}
+
+	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
+	    !this_cpu_has(X86_FEATURE_VMX)) {
+		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL\n");
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
+	hv_reset_evmcs();
+
+	intel_pt_handle_vmx(0);
+}
+
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 {
 	int node = cpu_to_node(cpu);
@@ -7468,41 +7503,6 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static bool __init kvm_is_vmx_supported(void)
-{
-	if (!cpu_has_vmx()) {
-		pr_err("CPU doesn't support VMX\n");
-		return false;
-	}
-
-	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
-	    !this_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL\n");
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
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
