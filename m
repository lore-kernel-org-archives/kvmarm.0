Return-Path: <SRS0=/DGV=SW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F505C282DD
	for <kvmarm@archiver.kernel.org>; Sat, 20 Apr 2019 05:18:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB691208C0
	for <kvmarm@archiver.kernel.org>; Sat, 20 Apr 2019 05:18:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB691208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46BCB4A4DF;
	Sat, 20 Apr 2019 01:18:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S6lbaw0L0gfk; Sat, 20 Apr 2019 01:18:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB88A4A492;
	Sat, 20 Apr 2019 01:18:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C16E64A492
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Apr 2019 01:18:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tIKBhCYt4Qeq for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 Apr 2019 01:18:23 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4B7C4A389
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Apr 2019 01:18:22 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 19 Apr 2019 22:18:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,372,1549958400"; d="scan'208";a="144223367"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
 by orsmga003.jf.intel.com with ESMTP; 19 Apr 2019 22:18:20 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Joerg Roedel <joro@8bytes.org>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: Directly return result from
 kvm_arch_check_processor_compat()
Date: Fri, 19 Apr 2019 22:18:17 -0700
Message-Id: <20190420051817.5644-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190420051817.KVtKBA0PL27uXei9FMtNmfHvCcdLiJxowVXefjMMPLk@z>

Add a wrapper to invoke kvm_arch_check_processor_compat() so that the
boilerplate ugliness of checking virtualization support on all CPUs is
hidden from the arch specific code.  x86's implementation in particular
is quite heinous, as it unnecessarily propagates the out-param pattern
into kvm_x86_ops.

While the x86 specific issue could be resolved solely by changing
kvm_x86_ops, make the change for all architectures as returning a value
directly is prettier and technically more robust, e.g. s390 doesn't set
the out param, which could lead to subtle breakage in the (highly
unlikely) scenario where the out-param was not pre-initialized by the
caller.

Opportunistically annotate svm_check_processor_compat() with __init.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Tested on VMX only.

 arch/mips/kvm/mips.c             | 4 ++--
 arch/powerpc/kvm/powerpc.c       | 4 ++--
 arch/s390/include/asm/kvm_host.h | 1 -
 arch/s390/kvm/kvm-s390.c         | 5 +++++
 arch/x86/include/asm/kvm_host.h  | 2 +-
 arch/x86/kvm/svm.c               | 4 ++--
 arch/x86/kvm/vmx/vmx.c           | 8 ++++----
 arch/x86/kvm/x86.c               | 4 ++--
 include/linux/kvm_host.h         | 2 +-
 virt/kvm/arm/arm.c               | 4 ++--
 virt/kvm/kvm_main.c              | 9 ++++++---
 11 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 6d0517ac18e5..1c22b938c550 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -123,9 +123,9 @@ int kvm_arch_hardware_setup(void)
 	return 0;
 }
 
-void kvm_arch_check_processor_compat(void *rtn)
+int kvm_arch_check_processor_compat(void)
 {
-	*(int *)rtn = 0;
+	return 0;
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 92910b7c5bcc..7b7635201739 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -425,9 +425,9 @@ int kvm_arch_hardware_setup(void)
 	return 0;
 }
 
-void kvm_arch_check_processor_compat(void *rtn)
+int kvm_arch_check_processor_compat(void)
 {
-	*(int *)rtn = kvmppc_core_check_processor_compat();
+	return kvmppc_core_check_processor_compat();
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index c47e22bba87f..96a1603ecf10 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -903,7 +903,6 @@ extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
 static inline void kvm_arch_hardware_disable(void) {}
-static inline void kvm_arch_check_processor_compat(void *rtn) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 28f35d2b06cb..4c50bd533ebc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -221,6 +221,11 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
+int kvm_arch_check_processor_compat(void)
+{
+	return 0;
+}
+
 static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 			      unsigned long end);
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8d68ba0cba0c..02ba99ef8c5f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -995,7 +995,7 @@ struct kvm_x86_ops {
 	int (*disabled_by_bios)(void);             /* __init */
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
-	void (*check_processor_compatibility)(void *rtn);
+	int (*check_processor_compatibility)(void);/* __init */
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 	bool (*cpu_has_accelerated_tpr)(void);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 406b558abfef..236e2fc0edec 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5859,9 +5859,9 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
-static void svm_check_processor_compat(void *rtn)
+static int __init svm_check_processor_compat(void)
 {
-	*(int *)rtn = 0;
+	return 0;
 }
 
 static bool svm_cpu_has_accelerated_tpr(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d8f101b58ab8..7d0733b8f383 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6720,22 +6720,22 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static void __init vmx_check_processor_compat(void *rtn)
+static int __init vmx_check_processor_compat(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
 
-	*(int *)rtn = 0;
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
-		*(int *)rtn = -EIO;
+		return -EIO;
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept,
 					   enable_apicv);
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
 		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
 				smp_processor_id());
-		*(int *)rtn = -EIO;
+		return -EIO;
 	}
+	return 0;
 }
 
 static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c09507057743..6214c27b0c2a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9042,9 +9042,9 @@ void kvm_arch_hardware_unsetup(void)
 	kvm_x86_ops->hardware_unsetup();
 }
 
-void kvm_arch_check_processor_compat(void *rtn)
+int kvm_arch_check_processor_compat(void)
 {
-	kvm_x86_ops->check_processor_compatibility(rtn);
+	return kvm_x86_ops->check_processor_compatibility();
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 640a03642766..0ddef348b9b0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -842,7 +842,7 @@ int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
-void kvm_arch_check_processor_compat(void *rtn);
+int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index be4ec5f3ba5f..67ecadbd8961 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -105,9 +105,9 @@ int kvm_arch_hardware_setup(void)
 	return 0;
 }
 
-void kvm_arch_check_processor_compat(void *rtn)
+int kvm_arch_check_processor_compat(void)
 {
-	*(int *)rtn = 0;
+	return 0;
 }
 
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4bb20f2b2a69..41effae3f9ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4135,6 +4135,11 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_vcpu_put(vcpu);
 }
 
+static void check_processor_compat(void *rtn)
+{
+	*(int *)rtn = kvm_arch_check_processor_compat();
+}
+
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
@@ -4166,9 +4171,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_0a;
 
 	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu,
-				kvm_arch_check_processor_compat,
-				&r, 1);
+		smp_call_function_single(cpu, check_processor_compat, &r, 1);
 		if (r < 0)
 			goto out_free_1;
 	}
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
