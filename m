Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A132DC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 13:08:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58553610F9
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 13:08:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 58553610F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CDFB4B1DA;
	Fri,  3 Sep 2021 09:08:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@suse.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U9+7zRn76Ao7; Fri,  3 Sep 2021 09:08:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE3024B1ED;
	Fri,  3 Sep 2021 09:08:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E56E14B1F5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 09:08:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sMyieF4gzIhZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 09:08:30 -0400 (EDT)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A99464B1BF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 09:08:30 -0400 (EDT)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A5E3E226EF;
 Fri,  3 Sep 2021 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
 t=1630674509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tdRd8V4DfFLfvS4ckb7uA1RJKO/r/+sN4YgtnHYUSHo=;
 b=HQLpokubMLbTcIZbV8us+hyFFoqyOem0YyDB+HwyRUnwkOOi3DulTHsIbVrrySfpcJ0vnN
 nmah2V7Crihp/qW+u9/K+TZelCzJ2IaEY/kslaLf6QGKSwpYOQVJWxQVZnnCaA5h0o9osp
 X/BtXES2eZuNirPaQMUfbziFS5j9hEA=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0E5B0137D4;
 Fri,  3 Sep 2021 13:08:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id aO4BAk0eMmHYOAAAGKfGzw
 (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 13:08:29 +0000
From: Juergen Gross <jgross@suse.com>
To: kvm@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] kvm: allocate vcpu pointer array separately
Date: Fri,  3 Sep 2021 15:08:06 +0200
Message-Id: <20210903130808.30142-6-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210903130808.30142-1-jgross@suse.com>
References: <20210903130808.30142-1-jgross@suse.com>
MIME-Version: 1.0
Cc: Juergen Gross <jgross@suse.com>, Wanpeng Li <wanpengli@tencent.com>,
 ehabkost@redhat.com, Will Deacon <will@kernel.org>, maz@kernel.org,
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
V2:
- rebase to new kvm_arch_free_vm() implementation
---
 arch/arm64/kvm/arm.c            | 21 +++++++++++++++++++--
 arch/x86/include/asm/kvm_host.h |  5 +----
 arch/x86/kvm/x86.c              | 18 ++++++++++++++++++
 include/linux/kvm_host.h        | 17 +++++++++++++++--
 4 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 38fff5963d9f..8bb5caeba007 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -293,10 +293,27 @@ long kvm_arch_dev_ioctl(struct file *filp,
 
 struct kvm *kvm_arch_alloc_vm(void)
 {
+	struct kvm *kvm;
+
+	if (!has_vhe())
+		kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	else
+		kvm = vzalloc(sizeof(struct kvm));
+
+	if (!kvm)
+		return NULL;
+
 	if (!has_vhe())
-		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+		kvm->vcpus = kcalloc(KVM_MAX_VCPUS, sizeof(void *), GFP_KERNEL);
+	else
+		kvm->vcpus = vzalloc(KVM_MAX_VCPUS * sizeof(void *));
+
+	if (!kvm->vcpus) {
+		kvm_arch_free_vm(kvm);
+		kvm = NULL;
+	}
 
-	return vzalloc(sizeof(struct kvm));
+	return kvm;
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f16fadfc030a..6c28d0800208 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1517,10 +1517,7 @@ static inline void kvm_ops_static_call_update(void)
 }
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
-static inline struct kvm *kvm_arch_alloc_vm(void)
-{
-	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-}
+struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc552763f0e4..ff142b6dd00c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11126,6 +11126,24 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d75e9c2a00b1..9e2a5f1c6f54 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -536,7 +536,7 @@ struct kvm {
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	struct kvm_vcpu **vcpus;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
@@ -1042,12 +1042,25 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm);
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
 #endif
 
 static inline void __kvm_arch_free_vm(struct kvm *kvm)
 {
+	if (kvm)
+		kvfree(kvm->vcpus);
 	kvfree(kvm);
 }
 
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
