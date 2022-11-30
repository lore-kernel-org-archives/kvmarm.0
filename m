Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61A6C352A1
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:11:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 552404B797;
	Wed, 30 Nov 2022 18:11:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Of68zRMWqYRG; Wed, 30 Nov 2022 18:11:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B784B6B9;
	Wed, 30 Nov 2022 18:10:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49D354B6B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3bSJsu5KisFl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:51 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EAC64B286
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:48 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 c1-20020a170902d48100b0018723580343so19037636plg.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=f2C8vDRaA/O8SbCTM+wfwlQ+MVAOdj+YvpH8iocCum8=;
 b=E8ory0J1I2HGG0veF4yVwhyY9m0RRKrUrQNbtHkcBPn3mu4coPo+BcZ2CCSzBYmt1U
 gLqizNJDmxOs7ohAfQhuw1mtRxvIWCRJ1ZjGtcj9O77B+F2VF9B0cWhIdzQ02sw591vX
 fdSkALucc7nvyd/ucUkC9khImEPpK6ZxVf/6qAMCnOioiN6e65FTcxBoi9EhyhsHRvLB
 6DuDXJdb6qUgt4jDvBcmP8KYPUbvEzvzpi828Cuwms5+CFGS0VNQK/Ys8J/r7urUqDtN
 pCLG6YtdBn+DHe0STOYvxL6cUh5uQ8qX1SMqSbW+jxDAMmvD7Bx5d27IfSui/C5++PVG
 HYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=f2C8vDRaA/O8SbCTM+wfwlQ+MVAOdj+YvpH8iocCum8=;
 b=vaSkbc+RnffcWK1I7SrCG9HJ/iFc3zp8ecFhOE45ROoJdhDweFufNZ0ScEQSQz9M9x
 xcHRD3uIVj3GDgbYaSE3RSs8twfaP8c3e1KLLg+cmLqt6jh7YMipjA3pIoih2iTy/E4G
 SmodkQ14N3iwKouHYACOLzZjagj0aqb5ovDbo9aEsEbLWeFLFYI5zWbdnux9wJGSaF50
 y54/KtLWVdrMirawdN9U1IoSb9KC1t71ZjW7nWyrmqGWJkK4rMRcS+eEOLcq3QGJz9aU
 6OKyWrSs83frvf7ztPFKOOpqndu8tPGejnG4QjC2+365Vw5qzaEj+U9hT1LCrIfGaHfl
 B0iA==
X-Gm-Message-State: ANoB5pkQLQt6x72e0Xcev9DnGtRCq3M76K/lGZrBrv5+btm6GIK6FRa/
 +xo+GGNEJC742W1YT911erHOKiQ1L8Y=
X-Google-Smtp-Source: AA0mqf7KhS1zzjBRRWmgNzYeinI7lFKtVig8aF30FAKfC8K3egPzRcjNw0j/jgHxn/ZrtapQhwi3bSxxU3g=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1941:b0:572:6e9b:9fa2 with SMTP id
 s1-20020a056a00194100b005726e9b9fa2mr44563414pfk.8.1669849846939; Wed, 30 Nov
 2022 15:10:46 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:24 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-41-seanjc@google.com>
Subject: [PATCH v2 40/50] KVM: x86: Do compatibility checks when onlining CPU
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

From: Chao Gao <chao.gao@intel.com>

Do compatibility checks when enabling hardware to effectively add
compatibility checks when onlining a CPU.  Abort enabling, i.e. the
online process, if the (hotplugged) CPU is incompatible with the known
good setup.

At init time, KVM does compatibility checks to ensure that all online
CPUs support hardware virtualization and a common set of features. But
KVM uses hotplugged CPUs without such compatibility checks. On Intel
CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX, or
VM-Entry failure if the hotplugged CPU doesn't support all features
enabled by KVM.

Note, this is little more than a NOP on SVM, as SVM already checks for
full SVM support during hardware enabling.

Opportunistically add a pr_err() if setup_vmcs_config() fails, and
tweak all error messages to output which CPU failed.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  8 +++-----
 arch/x86/kvm/vmx/vmx.c | 15 ++++++++++-----
 arch/x86/kvm/x86.c     |  5 +++++
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c2e95c0d9fd8..46b658d0f46e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -521,11 +521,12 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 
 static bool kvm_is_svm_supported(void)
 {
+	int cpu = raw_smp_processor_id();
 	const char *msg;
 	u64 vm_cr;
 
 	if (!cpu_has_svm(&msg)) {
-		pr_err("SVM not supported, %s\n", msg);
+		pr_err("SVM not supported by CPU %d, %s\n", cpu, msg);
 		return false;
 	}
 
@@ -536,7 +537,7 @@ static bool kvm_is_svm_supported(void)
 
 	rdmsrl(MSR_VM_CR, vm_cr);
 	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE)) {
-		pr_err("SVM disabled (by BIOS) in MSR_VM_CR\n");
+		pr_err("SVM disabled (by BIOS) in MSR_VM_CR on CPU %d\n", cpu);
 		return false;
 	}
 
@@ -587,9 +588,6 @@ static int svm_hardware_enable(void)
 	if (efer & EFER_SVME)
 		return -EBUSY;
 
-	if (!kvm_is_svm_supported())
-		return -EINVAL;
-
 	sd = per_cpu_ptr(&svm_data, me);
 	sd->asid_generation = 1;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6416ed5b7f89..39dd3082fcd8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2711,14 +2711,16 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 static bool kvm_is_vmx_supported(void)
 {
+	int cpu = raw_smp_processor_id();
+
 	if (!cpu_has_vmx()) {
-		pr_err("CPU doesn't support VMX\n");
+		pr_err("VMX not supported by CPU %d\n", cpu);
 		return false;
 	}
 
 	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
 	    !this_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL\n");
+		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL on CPU %d\n", cpu);
 		return false;
 	}
 
@@ -2727,18 +2729,21 @@ static bool kvm_is_vmx_supported(void)
 
 static int vmx_check_processor_compat(void)
 {
+	int cpu = raw_smp_processor_id();
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
 
 	if (!kvm_is_vmx_supported())
 		return -EIO;
 
-	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
+	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
+		pr_err("Failed to setup VMCS config on CPU %d\n", cpu);
 		return -EIO;
+	}
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
-	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
-		pr_err("CPU %d feature inconsistency!\n", smp_processor_id());
+	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config))) {
+		pr_err("Inconsistent VMCS config on CPU %d\n", cpu);
 		return -EIO;
 	}
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee9af412ffd4..5a9e74cedbc6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11967,6 +11967,11 @@ int kvm_arch_hardware_enable(void)
 	bool stable, backwards_tsc = false;
 
 	kvm_user_return_msr_cpu_online();
+
+	ret = kvm_x86_check_processor_compatibility();
+	if (ret)
+		return ret;
+
 	ret = static_call(kvm_x86_hardware_enable)();
 	if (ret != 0)
 		return ret;
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
