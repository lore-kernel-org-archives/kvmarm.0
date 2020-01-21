Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C73C33CAF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 22:32:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 689AA24653
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 22:32:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 689AA24653
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 212F74AEC3;
	Tue, 21 Jan 2020 17:32:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TSGbs3P8ic0K; Tue, 21 Jan 2020 17:32:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC5224ACF5;
	Tue, 21 Jan 2020 17:32:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23E514AECF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 17:32:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MnQ1uZw3sre5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 17:32:06 -0500 (EST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E677F4ACF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 17:32:05 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Jan 2020 14:32:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; d="scan'208";a="244845141"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 21 Jan 2020 14:32:03 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 10/19] KVM: Drop "const" attribute from old memslot in
 commit_memory_region()
Date: Tue, 21 Jan 2020 14:31:48 -0800
Message-Id: <20200121223157.15263-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200121223157.15263-1-sean.j.christopherson@intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

Drop the "const" attribute from @old in kvm_arch_commit_memory_region()
to allow arch specific code to free arch specific resources in the old
memslot without having to cast away the attribute.  Freeing resources in
kvm_arch_commit_memory_region() paves the way for simplifying
kvm_free_memslot() by eliminating the last usage of its @dont param.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       | 2 +-
 arch/powerpc/kvm/powerpc.c | 2 +-
 arch/s390/kvm/kvm-s390.c   | 2 +-
 arch/x86/kvm/x86.c         | 2 +-
 include/linux/kvm_host.h   | 2 +-
 virt/kvm/arm/mmu.c         | 2 +-
 virt/kvm/kvm_main.c        | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 6d54e18ebdc1..908f7ec3e755 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -224,7 +224,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
-				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 48abf1b9ad58..768c4a9269be 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -701,7 +701,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
-				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 743e09dd38b5..1bfbeac13a3b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4508,7 +4508,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b55bf2ecdd98..a9d2d9decbc3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9932,7 +9932,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index aa5cb2ff7a2b..33b76106cd75 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -678,7 +678,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 bool kvm_largepages_enabled(void);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 66f59c067bf6..c9e0acefaba2 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2253,7 +2253,7 @@ int kvm_mmu_init(void)
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
-				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 64f6c5d35260..69d6158cb405 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -984,7 +984,7 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
-			   const struct kvm_memory_slot *old,
+			   struct kvm_memory_slot *old,
 			   struct kvm_memory_slot *new, int as_id,
 			   enum kvm_mr_change change)
 {
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
