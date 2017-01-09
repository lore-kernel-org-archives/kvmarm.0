From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 50/55] KVM: arm/arm64: Abstract kvm_phys_addr_ioremap() function
Date: Mon,  9 Jan 2017 01:24:46 -0500
Message-ID: <1483943091-1364-51-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE552400FC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tqq54Lz9sEDn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:55 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E71AB408C1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:53 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q9dq018086
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:35 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 7866185
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:35 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 3E78880
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:35 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QYG9057940
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:35 -0500
Received: by mail-qk0-f200.google.com with SMTP id a195so63266876qkg.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:35 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The original kvm_phys_addr_ioremap function only uses mmu pointing to
the VM's mmu context. However, it would be very useful to reuse this
function for the nested mmu context. Therefore, create a function named
__kvm_phys_addr_ioremapp which takes mmu as an argument, and let
kvm_phys_addr_ioremap calls this function with the VM's mmu context.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/kvm/mmu.c               | 18 +++++++++++++-----
 arch/arm64/include/asm/kvm_mmu.h |  3 +++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 344bc01..2cd6a19 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1058,15 +1058,16 @@ static int stage2_pmdp_test_and_clear_young(pmd_t *pmd)
 }
 
 /**
- * kvm_phys_addr_ioremap - map a device range to guest IPA
+ * __kvm_phys_addr_ioremap - map a device range to guest IPA
  *
  * @kvm:	The KVM pointer
  * @guest_ipa:	The IPA at which to insert the mapping
  * @pa:		The physical address of the device
  * @size:	The size of the mapping
  */
-int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
-			  phys_addr_t pa, unsigned long size, bool writable)
+int __kvm_phys_addr_ioremap(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+			    phys_addr_t guest_ipa, phys_addr_t pa,
+			    unsigned long size, bool writable)
 {
 	phys_addr_t addr, end;
 	int ret = 0;
@@ -1087,8 +1088,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
-		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
-						KVM_S2PTE_FLAG_IS_IOMAP);
+		ret = stage2_set_pte(mmu, &cache, addr, &pte,
+				     KVM_S2PTE_FLAG_IS_IOMAP);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			goto out;
@@ -1101,6 +1102,13 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	return ret;
 }
 
+int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
+			  phys_addr_t pa, unsigned long size, bool writable)
+{
+	return __kvm_phys_addr_ioremap(kvm, &kvm->arch.mmu, guest_ipa, pa,
+				       size, writable);
+}
+
 static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, gfn_t gfn,
 					phys_addr_t *ipap)
 {
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7754f3e..ec9e5e9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -149,6 +149,9 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 int __kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm *kvm);
 void __kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
+int __kvm_phys_addr_ioremap(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+			    phys_addr_t guest_ipa, phys_addr_t pa,
+			    unsigned long size, bool writable);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
 void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
-- 
1.9.1
