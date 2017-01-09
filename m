From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 33/55] KVM: arm/arm64: Remove unused params in mmu functions
Date: Mon,  9 Jan 2017 01:24:29 -0500
Message-ID: <1483943091-1364-34-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2E174027C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bb8JUBkO3T4c for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:35 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF4D040194
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:33 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q9BH006310
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:15 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 5ECEA8A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:15 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 26A0B8C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:15 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QEcb057425
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:15 -0500
Received: by mail-qt0-f197.google.com with SMTP id t56so77866636qte.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:15 -0800 (PST)
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

From: Christoffer Dall <christoffer.dall@linaro.org>

stage2_flush_xxx functions take a pointer to the kvm struct as the first
parameter but they are never used. Clean this up before modifying mmu
code for nested virtualization support.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/kvm/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index a5265ed..57cb671 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -300,7 +300,7 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 	} while (pgd++, addr = next, addr != end);
 }
 
-static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
+static void stage2_flush_ptes(pmd_t *pmd,
 			      phys_addr_t addr, phys_addr_t end)
 {
 	pte_t *pte;
@@ -312,7 +312,7 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
-static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
+static void stage2_flush_pmds(pud_t *pud,
 			      phys_addr_t addr, phys_addr_t end)
 {
 	pmd_t *pmd;
@@ -325,12 +325,12 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
 			if (pmd_thp_or_huge(*pmd))
 				kvm_flush_dcache_pmd(*pmd);
 			else
-				stage2_flush_ptes(kvm, pmd, addr, next);
+				stage2_flush_ptes(pmd, addr, next);
 		}
 	} while (pmd++, addr = next, addr != end);
 }
 
-static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
+static void stage2_flush_puds(pgd_t *pgd,
 			      phys_addr_t addr, phys_addr_t end)
 {
 	pud_t *pud;
@@ -343,7 +343,7 @@ static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
 			if (stage2_pud_huge(*pud))
 				kvm_flush_dcache_pud(*pud);
 			else
-				stage2_flush_pmds(kvm, pud, addr, next);
+				stage2_flush_pmds(pud, addr, next);
 		}
 	} while (pud++, addr = next, addr != end);
 }
@@ -359,7 +359,7 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
 		next = stage2_pgd_addr_end(addr, end);
-		stage2_flush_puds(kvm, pgd, addr, next);
+		stage2_flush_puds(pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
-- 
1.9.1
