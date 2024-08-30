Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE06166F24
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 04:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992587; cv=none; b=NHkPDmfsWwdvHjIn1oXhsiMQZO5yeZp2dilNu9B7Ah91eWyu0N9zCOZWvKTyJXSsuEypyV+tpeop/FM++fVdAeEn3BbiRfT1Xdvfl0k/uSRXYm0cRv3H+pzie41eUa9skqZN4DFmjs9ZwHzEJhqpDtM26knjg/6EbJhNDO8n50o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992587; c=relaxed/simple;
	bh=f8gTFb2B6g+nTdEPEoEjRizoL0QZCxVbzC4A0L6M8Vc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TO1KsvXZrt1paoazcyemkfjM9KWgWBNh0SOTQ/FX68PJQ1PJmSfCoSjOSpPm46qrX22JpzJK+7wihIu0kOqLjS3Tf4iOGyOi8hNW8NlptVwQspesiSbOTfDHMwadY0GpHJkIcs9gnEMbjfaHViEf9drmI9uFwSUnnoKwJYrOsqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=svqCo+Up; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="svqCo+Up"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7cd93173175so729184a12.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 21:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992585; x=1725597385; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ifnPkNWOuuY4EYgQ8TsiC+nc4mt99+bHFrgN10JBfbg=;
        b=svqCo+UpPopEOJecwVFw5dNHKfN9HxEE1Q5K3GnCKN/P9P1/k8LDDslVNAQbyYcBg4
         kelPkos60CK/YetwZsBB8PEaiOzePCuDYPr/MCb/1x9UcdLPm/auNl73rRlXW03XCxx4
         B6YE4xQCCYXO2hO/ZMx+ePzcB0n1/cVaLYFtGNGTPuHbJLx8FB0rQgYXksP1yW3IPQO8
         y6V6Lw6pCAX8/cm2fHUikNhmMrmPXMQU489eD0zWkNGj8liymF6dGZ2ZpGKrCckC2Jci
         4a8jAckPqAEMG6GqJL5FeC8pdMQd7NONVQFWeKOvAzchAhzg/KJ3iuzV51tn6HPvPRyv
         HFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992585; x=1725597385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ifnPkNWOuuY4EYgQ8TsiC+nc4mt99+bHFrgN10JBfbg=;
        b=ph7avAcxRpGFHSZyYhBxeQ6ZOZQYONRfnLn/LpmAAY6E+Hn+tv9QhDVx3MqCFGCY76
         JHQ4uethphEj6DOwjRClBY7nexsOwwlFTcBaU9U7Y3elpTAwSLtTLqhcQ6pAGHRUUccS
         +tDNfK8/zMZpYk0U7ZUyB2DLNRumUbU1RC9aOw5RTXZLVgI6dpUMe5dR7le+Yj/0uBVv
         n5OeKVWjexDrKCPk+GxrmcSMNSrf1aWptRuP0N2DFI1AyAqVTsPSZZBLS/5ZZT6UDw4c
         KpaSm4kIr3ytLydxLj/yrnYiDlUJF1gVVpfvpSSRX5znvqZNaazIenT9Za+TdGmHlhat
         JwIA==
X-Forwarded-Encrypted: i=1; AJvYcCVOwPyUYNac6t+IOr7a2RshxUoV2jbKtYFz+2I+/F1FOt1WIQ7JDgK7dKzCJefh0INo35JZAQM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzS37DHC0p7f1KgWSndO/j35bKFv286P0khelTXM+CxK+KTrqOE
	p89PEXVyBpXV13ETEEOsjzu2yjon+GzeHG9k/JH2Dpen0FMAaCH0oJdjG1yM4bYSRiU4NcvxjhU
	WeA==
X-Google-Smtp-Source: AGHT+IFbr9dMQrR+mXp/rGgRu95zX7CYqRN/pGYBvf5wJW9KzwkznUNDOT/XrC79C9bzXvvgnK+ABsLgkRI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2310:b0:202:3bed:1dab with SMTP id
 d9443c01a7336-20527a4fdc0mr46745ad.6.1724992584767; Thu, 29 Aug 2024 21:36:24
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:36:00 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-11-seanjc@google.com>
Subject: [PATCH v4 10/10] KVM: x86: Register "emergency disable" callbacks
 when virt is enabled
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

Register the "disable virtualization in an emergency" callback just
before KVM enables virtualization in hardware, as there is no functional
need to keep the callbacks registered while KVM happens to be loaded, but
is inactive, i.e. if KVM hasn't enabled virtualization.

Note, unregistering the callback every time the last VM is destroyed could
have measurable latency due to the synchronize_rcu() needed to ensure all
references to the callback are dropped before KVM is unloaded.  But the
latency should be a small fraction of the total latency of disabling
virtualization across all CPUs, and userspace can set enable_virt_at_load
to completely eliminate the runtime overhead.

Add a pointer in kvm_x86_ops to allow vendor code to provide its callback.
There is no reason to force vendor code to do the registration, and either
way KVM would need a new kvm_x86_ops hook.

Suggested-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/svm.c          |  5 +----
 arch/x86/kvm/vmx/main.c         |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  6 +-----
 arch/x86/kvm/vmx/x86_ops.h      |  1 +
 arch/x86/kvm/x86.c              | 10 ++++++++++
 6 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cb3b5f107c6e..aa9eea61a092 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -36,6 +36,7 @@
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
+#include <asm/reboot.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
@@ -1631,6 +1632,8 @@ struct kvm_x86_ops {
 
 	int (*enable_virtualization_cpu)(void);
 	void (*disable_virtualization_cpu)(void);
+	cpu_emergency_virt_cb *emergency_disable_virtualization_cpu;
+
 	void (*hardware_unsetup)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a9adbe10c12e..9a0506ef87df 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4982,6 +4982,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_unsetup,
 	.enable_virtualization_cpu = svm_enable_virtualization_cpu,
 	.disable_virtualization_cpu = svm_disable_virtualization_cpu,
+	.emergency_disable_virtualization_cpu = svm_emergency_disable_virtualization_cpu,
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.vcpu_create = svm_vcpu_create,
@@ -5410,8 +5411,6 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 static void __svm_exit(void)
 {
 	kvm_x86_vendor_exit();
-
-	cpu_emergency_unregister_virt_callback(svm_emergency_disable_virtualization_cpu);
 }
 
 static int __init svm_init(void)
@@ -5427,8 +5426,6 @@ static int __init svm_init(void)
 	if (r)
 		return r;
 
-	cpu_emergency_register_virt_callback(svm_emergency_disable_virtualization_cpu);
-
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 4a5bf92edccf..7e2e78a14257 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -25,6 +25,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.enable_virtualization_cpu = vmx_enable_virtualization_cpu,
 	.disable_virtualization_cpu = vmx_disable_virtualization_cpu,
+	.emergency_disable_virtualization_cpu = vmx_emergency_disable_virtualization_cpu,
+
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf7d937bfd2c..89682832dded 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -755,7 +755,7 @@ static int kvm_cpu_vmxoff(void)
 	return -EIO;
 }
 
-static void vmx_emergency_disable_virtualization_cpu(void)
+void vmx_emergency_disable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
@@ -8584,8 +8584,6 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	cpu_emergency_unregister_virt_callback(vmx_emergency_disable_virtualization_cpu);
-
 	vmx_cleanup_l1d_flush();
 }
 
@@ -8632,8 +8630,6 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	cpu_emergency_register_virt_callback(vmx_emergency_disable_virtualization_cpu);
-
 	vmx_check_vmcs12_offsets();
 
 	/*
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 205692c43a8e..b6a7cfc6ae31 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -15,6 +15,7 @@ void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
 int vmx_enable_virtualization_cpu(void);
 void vmx_disable_virtualization_cpu(void);
+void vmx_emergency_disable_virtualization_cpu(void);
 int vmx_vm_init(struct kvm *kvm);
 void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 431358167fa8..f72e5d89e942 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12512,6 +12512,16 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
+void kvm_arch_enable_virtualization(void)
+{
+	cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
+}
+
+void kvm_arch_disable_virtualization(void)
+{
+	cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
+}
+
 int kvm_arch_enable_virtualization_cpu(void)
 {
 	struct kvm *kvm;
-- 
2.46.0.469.g59c65b2a67-goog

