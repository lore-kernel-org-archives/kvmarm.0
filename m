Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A7FC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DD4249F2C;
	Fri, 11 Mar 2022 03:48:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UlBMWFRgmbVA; Fri, 11 Mar 2022 03:48:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 683BB49F3E;
	Fri, 11 Mar 2022 03:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08A43410F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yJA534f6uClM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:46 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1DA141021
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:45 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 i4-20020a63b304000000b0038108d6e7cdso318337pgf.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hUhTNfsRlcAhlCAEwuaf6qTSRETsPLu85xICgb6Pw2I=;
 b=Ux2f+mr/mK9ysuQSi/sBCmxVVqyTzZtZcuO+SYe9GBnc8TQpBaRNkuO26UcTq9+K7m
 9XCEug+JYAx7QgnxtFzMKpDzCZ2Kl3NLGHYaMWkmd4Ic4q6ryxK1fh3eirtILH29GWRl
 y4ndBbNMnsnmerSi8z/TQIBMaNCb13Zxm6I81Hm3D5/Iw1XB83q9r0puc/5thPme9yUe
 5CQHUvdH3HOyCN2dpgX6tbRevneUEVUCc5bYxwqg6D0Njsn05gMV/tq0tNKd8PUtrCZL
 TKX0vUgoYTO6j6iEsFtBVDflNzJ0qcKCJCSdpf3D5PzBxpdR1jblF6G0g4UsVDlY5RTe
 t19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hUhTNfsRlcAhlCAEwuaf6qTSRETsPLu85xICgb6Pw2I=;
 b=QsXTafz/Ow+rVZWBzasn5L48wYmOgLC0TsJCT4FGm4tNP0dlGJN5e4ARtRgPMJzgsj
 EeWQymngnSejvFO3ancdUEsDrR3ijO1/nBTOgPOfiDtTgj5VaG4tpgMq9ZAP+q+E+mFq
 ea+jq8EK7qcn2f2iq1KDm+xhRn7RjSfWPCWojuIm/lgt/qwcRxOvOUqP7wghrSF3hDX8
 4LPbxrPfkTq4vOKZ9yYseAfCQdEMqFMys9YTa9KxJMhBqP01Cc5laFTjuNp/pkx+XTBH
 Cb07bsQ4LskcCeeHddF509Km6Gh6LAUvSqKfZUJOBfLHVbJ/Bdu8KaXoOJd0WBMPem1R
 FaYw==
X-Gm-Message-State: AOAM531SVpexKMZq7l1seThbDctPFb5KEDXhlkc7sFG5xt8+TlBbd5V4
 NFbqZs6SJagZRuxqWVN+FSGa82045BJ2uQ==
X-Google-Smtp-Source: ABdhPJyVkv6e6MFwOzwVPNnjhMEMTwjec6c9yLeYXj0Dnt6k4PAJzbfaJIjMW+/lDxdSlSq9DXN35GK1V5t4+g==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:9d8c:0:b0:378:4b73:5b3b with SMTP id
 i134-20020a639d8c000000b003784b735b3bmr6119017pgd.564.1646958344889; Thu, 10
 Mar 2022 16:25:44 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:10 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 08/26] KVM: x86/mmu: Link spt to sp during allocation
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
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
index af60922906ef..eecb0215e636 100644
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
@@ -1410,6 +1409,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 		return NULL;
 	}
 
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
 	return sp;
 }
 
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
