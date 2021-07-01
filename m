Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB60C11F67
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 15:41:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5012C61430
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 15:41:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5012C61430
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3CF34B0A0;
	Thu,  1 Jul 2021 11:41:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@suse.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@suse.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lWcPvvBqQ6BN; Thu,  1 Jul 2021 11:41:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E48E4B088;
	Thu,  1 Jul 2021 11:41:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B13B74B07F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 11:41:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id teYpe2eG89Bm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 11:41:11 -0400 (EDT)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94ABD4A95C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 11:41:11 -0400 (EDT)
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
 (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id D7FB021C73;
 Thu,  1 Jul 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
 t=1625154070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=20iVhRkgvk7R55d8QRN7JiSBSHg1fFPl28ZXdD64E5I=;
 b=nqFW6MET9/FBOStxUz0qTUdgV2ZP7kSbZQ0KCLji03HNA64JnBHyJL+TBon5RgiRKfQtm9
 x4gZ1ndgpbenV1xf+wmyzkFA29Wz3O7N/X7o689zDbxwepJu5SsD3L51VNJEY+vcvM8VDY
 as4O1VFzEA4mSnr5jdekClrYoHnxV58=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
 by imap.suse.de (Postfix) with ESMTP id 56FA811CD5;
 Thu,  1 Jul 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
 t=1625154070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=20iVhRkgvk7R55d8QRN7JiSBSHg1fFPl28ZXdD64E5I=;
 b=nqFW6MET9/FBOStxUz0qTUdgV2ZP7kSbZQ0KCLji03HNA64JnBHyJL+TBon5RgiRKfQtm9
 x4gZ1ndgpbenV1xf+wmyzkFA29Wz3O7N/X7o689zDbxwepJu5SsD3L51VNJEY+vcvM8VDY
 as4O1VFzEA4mSnr5jdekClrYoHnxV58=
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
 id SGobFBbi3WAOFwAALh3uQQ
 (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:10 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [PATCH 5/6] kvm: allocate vcpu pointer array separately
Date: Thu,  1 Jul 2021 17:41:04 +0200
Message-Id: <20210701154105.23215-6-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
MIME-Version: 1.0
Cc: Juergen Gross <jgross@suse.com>, Wanpeng Li <wanpengli@tencent.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Sean Christopherson <seanjc@google.com>,
 "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

Prepare support of very large vcpu numbers per guest by moving the
vcpu pointer array out of struct kvm.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/arm64/kvm/arm.c            | 28 ++++++++++++++++++++++++----
 arch/x86/include/asm/kvm_host.h |  5 +----
 arch/x86/kvm/x86.c              | 19 +++++++++++++++++++
 include/linux/kvm_host.h        | 17 +++++++++++++++--
 4 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e720148232a0..4f055408fe9f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -280,18 +280,38 @@ long kvm_arch_dev_ioctl(struct file *filp,
 
 struct kvm *kvm_arch_alloc_vm(void)
 {
+	struct kvm *kvm;
+
 	if (!has_vhe())
-		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+		kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	else
+		kvm = vzalloc(sizeof(struct kvm));
 
-	return vzalloc(sizeof(struct kvm));
+	if (!kvm)
+		return NULL;
+
+	if (!has_vhe())
+		kvm->vcpus = kcalloc(KVM_MAX_VCPUS, sizeof(void *), GFP_KERNEL);
+	else
+		kvm->vcpus = vzalloc(KVM_MAX_VCPUS * sizeof(void *));
+
+	if (!kvm->vcpus) {
+		kvm_arch_free_vm(kvm);
+		kvm = NULL;
+	}
+
+	return kvm;
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
 {
-	if (!has_vhe())
+	if (!has_vhe()) {
+		kfree(kvm->vcpus);
 		kfree(kvm);
-	else
+	} else {
+		vfree(kvm->vcpus);
 		vfree(kvm);
+	}
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 79138c91f83d..39cbc4b6bffb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1440,10 +1440,7 @@ static inline void kvm_ops_static_call_update(void)
 }
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
-static inline struct kvm *kvm_arch_alloc_vm(void)
-{
-	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-}
+struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3af398ef1fc9..a9b0bb2221ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10741,9 +10741,28 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
+struct kvm *kvm_arch_alloc_vm(void)
+{
+	struct kvm *kvm;
+
+	kvm = __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!kvm)
+		return NULL;
+
+	kvm->vcpus = __vmalloc(KVM_MAX_VCPUS * sizeof(void *),
+			       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!kvm->vcpus) {
+		vfree(kvm);
+		kvm = NULL;
+	}
+
+	return kvm;
+}
+
 void kvm_arch_free_vm(struct kvm *kvm)
 {
 	kfree(to_kvm_hv(kvm)->hv_pa_pg);
+	vfree(kvm->vcpus);
 	vfree(kvm);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8583ed3ff344..e424ef1078a1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -525,7 +525,7 @@ struct kvm {
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	struct kvm_vcpu **vcpus;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
@@ -1022,11 +1022,24 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm);
  */
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+
+	if (!kvm)
+		return NULL;
+
+	kvm->vcpus = kcalloc(KVM_MAX_VCPUS, sizeof(void *), GFP_KERNEL);
+	if (!kvm->vcpus) {
+		kfree(kvm);
+		kvm = NULL;
+	}
+
+	return kvm;
 }
 
 static inline void kvm_arch_free_vm(struct kvm *kvm)
 {
+	if (kvm)
+		kfree(kvm->vcpus);
 	kfree(kvm);
 }
 #endif
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
