Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C29C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:20:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232074B2DC;
	Fri,  1 Apr 2022 14:20:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AN6mYjPdM5oU; Fri,  1 Apr 2022 14:20:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F86B4B2D5;
	Fri,  1 Apr 2022 14:20:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E302E4B219
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eur+EkhOG1xx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:15 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8B004B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:15 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 w201-20020a627bd2000000b004fa92f4725bso1973452pfc.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iIUi4j5dTF9zBg27X61yXEUlsha95IziaYqw02FJyl4=;
 b=XUYkEsDRY+yxOCCR/ISvExrk4TUU/9GP5XtZIVgZZDgY9kQP/XNnlk8fvUiSOISjYK
 R5m/JMOu+EmpXbr04dXRQa3x0NDxA+wEK3Kuz/EnkzaIX58tYbeh5VIO1ePqPEADkcP+
 Bxr9baz/W/j0udZ76lWfRF8cYFvhRj3MFWoWUBcTG0gE/u6V6q5Pr6lM/mJiJpFcEG/M
 Ypf+ihXzgburWCxjfnncvi45fUrEjlfc6Kk10teb6t1BFUYa7k9dsG5WHjomwRREcHD9
 UGOO5aksD6e2p7VRKL8vpkBf9oXsHOu3bl1zFvbHF0S6ZiuWYOv4Gib1FOulsahDO063
 e0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iIUi4j5dTF9zBg27X61yXEUlsha95IziaYqw02FJyl4=;
 b=8N0QLCayJdh46OSUWnJHantAWAdqrBr5awHj6QANpFGgcNqZAW9GK16e2TaTkTum/g
 9ZAqmJAFa/p2AeNWgoYpPuteW+DOFlf6iuadzFQnC6iUlbzoOcQV9cBgwlbEetYJXjgo
 1JdZwJP13ekoEujP5dYaJ0bvaGDcMacuano2jEVGGHX0Qgf1ywFfac2NKeqVoBf2Y+Tc
 9VFEr8lfldTLlhwyv0epqkSvNZs6c80HoxADx8Nc0yU2bGxTKY8TayQqSsY1i6IVi/V2
 +aHOzACy158HrFZkrhpJC7Gw0z5KwD6shwFP/2ccUKDFF9VmGxXBww0mKj4/Qf+PLGCE
 IZvQ==
X-Gm-Message-State: AOAM530kKP7jzth6X2FMiJZp4G7eFTeEIm6uBvf+VTsmMiM0e0nQqg47
 /BRvw7DGuCH9nsPqsGOBKS7FXGqP5D8gzQ==
X-Google-Smtp-Source: ABdhPJzO4HC0kF89hVPwzXPdQHYPWNvD/kUD++1/OnBDK4J5ailVX4fYbPj+olrmsSjzQDC0shWUbcvlHeR7vQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:e81:b0:1c6:5a9c:5afa with SMTP id
 fv1-20020a17090b0e8100b001c65a9c5afamr587543pjb.1.1648835774239; Fri, 01 Apr
 2022 10:56:14 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:39 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 08/23] KVM: x86/mmu: Link spt to sp during allocation
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Link the shadow page table to the sp (via set_page_private()) during
allocation rather than initialization. This is a more logical place to
do it because allocation time is also where we do the reverse link
(setting sp->spt).

This creates one extra call to set_page_private(), but having multiple
calls to set_page_private() is unavoidable anyway. We either do
set_page_private() during allocation, which requires 1 per allocation
function, or we do it during initialization, which requires 1 per
initialization function.

No functional change intended.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b3b6426725d4..17354e55735f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -274,6 +274,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	return sp;
 }
@@ -281,8 +282,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 			    gfn_t gfn, union kvm_mmu_page_role role)
 {
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
 	sp->role = role;
 	sp->gfn = gfn;
 	sp->ptep = sptep;
@@ -1435,6 +1434,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 		return NULL;
 	}
 
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
 	return sp;
 }
 
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
