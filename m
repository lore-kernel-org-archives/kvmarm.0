Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA68C3404C
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 23:54:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 211C324655
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 23:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 211C324655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF0914AF81;
	Tue, 18 Feb 2020 18:54:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id njVFffFIRI0P; Tue, 18 Feb 2020 18:54:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 847594AF74;
	Tue, 18 Feb 2020 18:54:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F2364AF3B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 18:54:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vc0PnBUblqdS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 18:54:41 -0500 (EST)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5DAC4AF3D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 18:54:40 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Feb 2020 15:54:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; d="scan'208";a="224313156"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga007.jf.intel.com with ESMTP; 18 Feb 2020 15:54:38 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 1/9] KVM: Pass kvm_init()'s opaque param to additional arch
 funcs
Date: Tue, 18 Feb 2020 15:54:29 -0800
Message-Id: <20200218235437.20533-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218235437.20533-1-sean.j.christopherson@intel.com>
References: <20200218235437.20533-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Pass @opaque to kvm_arch_hardware_setup() and
kvm_arch_check_processor_compat() to allow architecture specific code to
reference @opaque without having to stash it away in a temporary global
variable.  This will enable x86 to separate its vendor specific callback
ops, which are passed via @opaque, into "init" and "runtime" ops without
having to stash away the "init" ops.

No functional change intended.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Tested-by: Cornelia Huck <cohuck@redhat.com> #s390
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       |  4 ++--
 arch/powerpc/kvm/powerpc.c |  4 ++--
 arch/s390/kvm/kvm-s390.c   |  4 ++--
 arch/x86/kvm/x86.c         |  4 ++--
 include/linux/kvm_host.h   |  4 ++--
 virt/kvm/arm/arm.c         |  4 ++--
 virt/kvm/kvm_main.c        | 18 ++++++++++++++----
 7 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 71244bf87c3a..68e27ce8bbba 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -118,12 +118,12 @@ void kvm_arch_hardware_disable(void)
 	kvm_mips_callbacks->hardware_disable();
 }
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	return 0;
 }
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 1af96fb5dc6f..ffa9d0ac5390 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -416,12 +416,12 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	return kvmppc_core_check_processor_compat();
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d7ff30e45589..5cae22b56ddd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -228,7 +228,7 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	return 0;
 }
@@ -293,7 +293,7 @@ static struct notifier_block kvm_clock_notifier = {
 	.notifier_call = kvm_clock_sync,
 };
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	gmap_notifier.notifier_call = kvm_gmap_notifier;
 	gmap_register_pte_notifier(&gmap_notifier);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..bdd0a613b374 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9591,7 +9591,7 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	int r;
 
@@ -9627,7 +9627,7 @@ void kvm_arch_hardware_unsetup(void)
 	kvm_x86_ops->hardware_unsetup();
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e89eb67356cb..fb33a95067bd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -882,9 +882,9 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
 
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
-int kvm_arch_hardware_setup(void);
+int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
-int kvm_arch_check_processor_compat(void);
+int kvm_arch_check_processor_compat(void *opaque);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index d65a0faa46d8..c92a70f58966 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -64,12 +64,12 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
-int kvm_arch_hardware_setup(void)
+int kvm_arch_hardware_setup(void *opaque)
 {
 	return 0;
 }
 
-int kvm_arch_check_processor_compat(void)
+int kvm_arch_check_processor_compat(void *opaque)
 {
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ae2d5c37b2..d719e4ee9ff7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4425,14 +4425,22 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
         return &kvm_running_vcpu;
 }
 
-static void check_processor_compat(void *rtn)
+struct kvm_cpu_compat_check {
+	void *opaque;
+	int *ret;
+};
+
+static void check_processor_compat(void *data)
 {
-	*(int *)rtn = kvm_arch_check_processor_compat();
+	struct kvm_cpu_compat_check *c = data;
+
+	*c->ret = kvm_arch_check_processor_compat(c->opaque);
 }
 
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
+	struct kvm_cpu_compat_check c;
 	int r;
 	int cpu;
 
@@ -4456,12 +4464,14 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_0;
 	}
 
-	r = kvm_arch_hardware_setup();
+	r = kvm_arch_hardware_setup(opaque);
 	if (r < 0)
 		goto out_free_1;
 
+	c.ret = &r;
+	c.opaque = opaque;
 	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &r, 1);
+		smp_call_function_single(cpu, check_processor_compat, &c, 1);
 		if (r < 0)
 			goto out_free_2;
 	}
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
