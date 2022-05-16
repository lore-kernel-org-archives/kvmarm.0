Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791E3C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34BE44B2E5;
	Tue, 17 May 2022 03:02:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cCu1J-Vqohpg; Tue, 17 May 2022 03:02:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2914C4B296;
	Tue, 17 May 2022 03:02:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 231BC4B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uyxB2L2A6Q8z for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:21:46 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0742F4B1F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:45 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 cw22-20020a056a00451600b0050e09a0c53aso6805251pfb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=X4uCUUh1rGfmOD3/lWwoQuwN7ClE8CziC7hFPLNCRtY=;
 b=hFeB6BH3Mk7VshvIAVpWcDVmYDpwvnSY5QkWaYbJwLjo1ir9fhO+bFdQtG6yVGX7zK
 t1oPzzOdhAsMDixXEjwg9yXq9XcutaFq/0xpTdRPmcBzm0YX5ysIkU5vORS5weJGrwP3
 PnoIGB12k06SgULkyahah2r4o4QbWTJO/vap+dojAQ9YZEIfWqymulkkpUqFP8fzSxX/
 Onr7rqoVvwnkIq5SdqjHwNmYnrTcmh2C8bZ/NIp8Sk+2uldb+dFZvYN0xax59BJjkPG8
 rN3X0TFXm4JojsgR1oiPFgxEOIkiTGPaQJbeQ0JUnVSeqzojBCe53i0mRhmWnFnT/ljv
 1QJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=X4uCUUh1rGfmOD3/lWwoQuwN7ClE8CziC7hFPLNCRtY=;
 b=02SMalkAB/6SoNfuaoNOgOgb3FpaIBtnLOtNV9TCqvrznbT6klCJoh61I9kBere6gb
 Q0Zkaa1H9UCAiMABl+z+1tLnjYoxlHVBLDkVealbUmev3sM6a2AU0T9J2Lot7bQTEDEZ
 MebE3NB++iZ8/6oDJ/WELY6SKOyaInRElr/0Nzdsjm2cPzHyKLOAlBAcgDo2BAHLe5sO
 rj7Wlr4QWaBDDU/GXH8C+fb9U4EhPIJcMJX0xh7Pe9CF/SZwA8Zb3m/aMDByMzEdhCg5
 R5BE3fN2Zw79nrSSA9F23uLMsP6gPhi4UavL2ctr4vK5Mbv7IPFJH0jffTKEJmeI2/6o
 0R1Q==
X-Gm-Message-State: AOAM5338GyJ9xJyipjRRvv4GmGhOE18M5El7RYj127xEJ4bNfDuGXoz7
 zEtQJfeyqIEzXrspN1JLto4YeMWmAAOUmw==
X-Google-Smtp-Source: ABdhPJwbO+fJ97CqwIl2Sls71Z6JyZGIMq9RjwHMhPS+5NIa19jDwPJcwiSkZGKIgaH0yYfXfhSvJ9zV3C5E3g==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4b83:b0:1df:6862:fa9d with SMTP
 id lr3-20020a17090b4b8300b001df6862fa9dmr5653658pjb.32.1652743305094; Mon, 16
 May 2022 16:21:45 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:18 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 02/22] KVM: x86/mmu: Use a bool for direct
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Tue, 17 May 2022 03:02:25 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
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

The parameter "direct" can either be true or false, and all of the
callers pass in a bool variable or true/false literal, so just use the
type bool.

No functional change intended.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 774810d8a2ed..34fb0cddff2b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1690,7 +1690,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2023,7 +2023,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
