Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A5F1547F7
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 04:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992580; cv=none; b=AlEUiBd8jHah8z0vBOX8PqUCaBLuMtLJrJHTP0GympzRLc6ZXmWzdWXfqlGxQptN0mJQEdnIvYDPWjKl+RyBk1N0Xrto/VM5+40QcxpOcPrQjZe32xFXmsPhtLientJLOzp0k6naNSljd0Hr4RbtOjBT9H6pnyo9EYluIbCGj5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992580; c=relaxed/simple;
	bh=r9TnUuOu+gvC939NhJllHWf188auJJvL355zIecEOyo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WtreY7i48xculhovmH80uEa4pnjbGsL2Jn70AE44WzjRq6huWmBQHoQxgZ6J++XLceg11nIpSTl8pRjikw2wQJjKv9bfVQlHgkI+PcA/NfAqlCSHUiNfwwbxBpQyWdYjp79MrARGqrl8AoqPqGoQqdQiSsX6LKxw2kYy0bO/5y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iKHmcSbW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iKHmcSbW"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc6db23c74so14258305ad.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 21:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992577; x=1725597377; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mgnh0vt90hRoRdUmmB6HToka9M38WB/s+4LU+KtV258=;
        b=iKHmcSbWUeuRUjkH9B1+V7FuG0mSthPE/sYuAr1yfPxep7EAKY03EWAT87ODpJTUHZ
         uWWWre7IEhUrhJWVdTg4b/y4hCVyCuEQdQ9tTXtvfxpXBrWzzZ1UsA3EErkks/ozr2Zr
         mPzcFHZLAQ8d6qQ+/I/TwS8cgQfgLyAjf6Kat0M/nvBeap6+EPteUMIC2zw1E/HEMGGN
         Y5gFDxeKFhUieAN3uUKj2sq6QwmfaGHgSwRBNp+CjzudKFv/s72zooY0huaixGHq54JG
         Srl79GZ+IqjXct2YQ+w1UX59ZxhH5xOKTiL4KKWrh7MTkSw8KVk1cbhGeuWY1Q1DNpHm
         1rCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992577; x=1725597377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mgnh0vt90hRoRdUmmB6HToka9M38WB/s+4LU+KtV258=;
        b=ZN59+rtc/INEaZiJ49MueMA47vqgxIdJcocvb5C5bR1Rby2iNn6TCpf30rRn6VXnqg
         SjMh53Jg+LuKeC3YwBM7AjQtzzuheLMehQDMXw6TnA6clkwtsTy5qgUXBGBsmAFUjW1s
         /FdTbRmFbCikPvRBzdrI1G657hzL5xYRn+Nb2n4zHU/klp5Qel5AV79e7nMS99af8P2c
         w4eU8MEAtlW92Jv/r6wgKmWQbk3eLykBLoj0dMBwAuLwQo2lRsgewAFKBOfY3MCxrmWY
         kJSUGP7cF5xefyGBRYw19kg11XY/2/B695INVgZKW4PBQTXS0EZHH7I1ffCHxer0VW70
         ryMg==
X-Forwarded-Encrypted: i=1; AJvYcCXiN6P60syX2/TmjPBdH5CWLEynlqZ1G7OEl8lW2HMQIxSFb4Ymia5gFxWIRCF7kr5TcU2eEJU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCrpamscQg7eqOiPCKwGjM3ZZPrRikcMNCashl+SFEmvpKMrxk
	YGao2IFHwXgF12oI8MZwNEOqa6y9zIhWlczStGDGY0oeEm+m6FEjfyAbieuL0Cb9shwDVfIuMD5
	efQ==
X-Google-Smtp-Source: AGHT+IE7HTy6N+J/THFIKpl4Od8/dndX02uUteqyB99aiEenMzXSGqlK1AXIizH5wGxOY4Cdt0h/M5FZk0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1105:b0:1fd:74a8:df4a with SMTP id
 d9443c01a7336-20527681a40mr898945ad.5.1724992576608; Thu, 29 Aug 2024
 21:36:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:56 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-7-seanjc@google.com>
Subject: [PATCH v4 06/10] KVM: x86: Rename virtualization {en,dis}abling APIs
 to match common KVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename x86's the per-CPU vendor hooks used to enable virtualization in
hardware to align with the recently renamed arch hooks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  4 ++--
 arch/x86/include/asm/kvm_host.h    |  4 ++--
 arch/x86/kvm/svm/svm.c             | 18 +++++++++---------
 arch/x86/kvm/vmx/main.c            |  4 ++--
 arch/x86/kvm/vmx/vmx.c             | 10 +++++-----
 arch/x86/kvm/vmx/x86_ops.h         |  4 ++--
 arch/x86/kvm/x86.c                 | 10 +++++-----
 7 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 68ad4f923664..03b7e13f15bb 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -14,8 +14,8 @@ BUILD_BUG_ON(1)
  * be __static_call_return0.
  */
 KVM_X86_OP(check_processor_compatibility)
-KVM_X86_OP(hardware_enable)
-KVM_X86_OP(hardware_disable)
+KVM_X86_OP(enable_virtualization_cpu)
+KVM_X86_OP(disable_virtualization_cpu)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 94e7b5a4fafe..cb3b5f107c6e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1629,8 +1629,8 @@ struct kvm_x86_ops {
 
 	int (*check_processor_compatibility)(void);
 
-	int (*hardware_enable)(void);
-	void (*hardware_disable)(void);
+	int (*enable_virtualization_cpu)(void);
+	void (*disable_virtualization_cpu)(void);
 	void (*hardware_unsetup)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6f252555ab3..a9adbe10c12e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -592,14 +592,14 @@ static inline void kvm_cpu_svm_disable(void)
 	}
 }
 
-static void svm_emergency_disable(void)
+static void svm_emergency_disable_virtualization_cpu(void)
 {
 	kvm_rebooting = true;
 
 	kvm_cpu_svm_disable();
 }
 
-static void svm_hardware_disable(void)
+static void svm_disable_virtualization_cpu(void)
 {
 	/* Make sure we clean up behind us */
 	if (tsc_scaling)
@@ -610,7 +610,7 @@ static void svm_hardware_disable(void)
 	amd_pmu_disable_virt();
 }
 
-static int svm_hardware_enable(void)
+static int svm_enable_virtualization_cpu(void)
 {
 
 	struct svm_cpu_data *sd;
@@ -1533,7 +1533,7 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
 	 * available. The user return MSR support is not required in this case
 	 * because TSC_AUX is restored on #VMEXIT from the host save area
-	 * (which has been initialized in svm_hardware_enable()).
+	 * (which has been initialized in svm_enable_virtualization_cpu()).
 	 */
 	if (likely(tsc_aux_uret_slot >= 0) &&
 	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
@@ -3132,7 +3132,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * feature is available. The user return MSR support is not
 		 * required in this case because TSC_AUX is restored on #VMEXIT
 		 * from the host save area (which has been initialized in
-		 * svm_hardware_enable()).
+		 * svm_enable_virtualization_cpu()).
 		 */
 		if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) && sev_es_guest(vcpu->kvm))
 			break;
@@ -4980,8 +4980,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_processor_compatibility = svm_check_processor_compat,
 
 	.hardware_unsetup = svm_hardware_unsetup,
-	.hardware_enable = svm_hardware_enable,
-	.hardware_disable = svm_hardware_disable,
+	.enable_virtualization_cpu = svm_enable_virtualization_cpu,
+	.disable_virtualization_cpu = svm_disable_virtualization_cpu,
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.vcpu_create = svm_vcpu_create,
@@ -5411,7 +5411,7 @@ static void __svm_exit(void)
 {
 	kvm_x86_vendor_exit();
 
-	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
+	cpu_emergency_unregister_virt_callback(svm_emergency_disable_virtualization_cpu);
 }
 
 static int __init svm_init(void)
@@ -5427,7 +5427,7 @@ static int __init svm_init(void)
 	if (r)
 		return r;
 
-	cpu_emergency_register_virt_callback(svm_emergency_disable);
+	cpu_emergency_register_virt_callback(svm_emergency_disable_virtualization_cpu);
 
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0bf35ebe8a1b..4a5bf92edccf 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -23,8 +23,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
+	.enable_virtualization_cpu = vmx_enable_virtualization_cpu,
+	.disable_virtualization_cpu = vmx_disable_virtualization_cpu,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..cf7d937bfd2c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -755,7 +755,7 @@ static int kvm_cpu_vmxoff(void)
 	return -EIO;
 }
 
-static void vmx_emergency_disable(void)
+static void vmx_emergency_disable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
@@ -2844,7 +2844,7 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 	return -EFAULT;
 }
 
-int vmx_hardware_enable(void)
+int vmx_enable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2881,7 +2881,7 @@ static void vmclear_local_loaded_vmcss(void)
 		__loaded_vmcs_clear(v);
 }
 
-void vmx_hardware_disable(void)
+void vmx_disable_virtualization_cpu(void)
 {
 	vmclear_local_loaded_vmcss();
 
@@ -8584,7 +8584,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
+	cpu_emergency_unregister_virt_callback(vmx_emergency_disable_virtualization_cpu);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8632,7 +8632,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	cpu_emergency_register_virt_callback(vmx_emergency_disable);
+	cpu_emergency_register_virt_callback(vmx_emergency_disable_virtualization_cpu);
 
 	vmx_check_vmcs12_offsets();
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ce3221cd1d01..205692c43a8e 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -13,8 +13,8 @@ extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
 void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
-int vmx_hardware_enable(void);
-void vmx_hardware_disable(void);
+int vmx_enable_virtualization_cpu(void);
+void vmx_disable_virtualization_cpu(void);
 int vmx_vm_init(struct kvm *kvm);
 void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1182baf0d487..431358167fa8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9749,7 +9749,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	guard(mutex)(&vendor_module_lock);
 
-	if (kvm_x86_ops.hardware_enable) {
+	if (kvm_x86_ops.enable_virtualization_cpu) {
 		pr_err("already loaded vendor module '%s'\n", kvm_x86_ops.name);
 		return -EEXIST;
 	}
@@ -9876,7 +9876,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	return 0;
 
 out_unwind_ops:
-	kvm_x86_ops.hardware_enable = NULL;
+	kvm_x86_ops.enable_virtualization_cpu = NULL;
 	kvm_x86_call(hardware_unsetup)();
 out_mmu_exit:
 	kvm_mmu_vendor_module_exit();
@@ -9917,7 +9917,7 @@ void kvm_x86_vendor_exit(void)
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
 #endif
 	mutex_lock(&vendor_module_lock);
-	kvm_x86_ops.hardware_enable = NULL;
+	kvm_x86_ops.enable_virtualization_cpu = NULL;
 	mutex_unlock(&vendor_module_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_x86_vendor_exit);
@@ -12528,7 +12528,7 @@ int kvm_arch_enable_virtualization_cpu(void)
 	if (ret)
 		return ret;
 
-	ret = kvm_x86_call(hardware_enable)();
+	ret = kvm_x86_call(enable_virtualization_cpu)();
 	if (ret != 0)
 		return ret;
 
@@ -12610,7 +12610,7 @@ int kvm_arch_enable_virtualization_cpu(void)
 
 void kvm_arch_disable_virtualization_cpu(void)
 {
-	kvm_x86_call(hardware_disable)();
+	kvm_x86_call(disable_virtualization_cpu)();
 	drop_user_return_notifiers();
 }
 
-- 
2.46.0.469.g59c65b2a67-goog

