Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C898C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 372554B311;
	Tue, 17 May 2022 03:02:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7zGPKokXVqE0; Tue, 17 May 2022 03:02:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9571C4B2BF;
	Tue, 17 May 2022 03:02:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5498349E38
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cpMOGI5FzKFV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:22:05 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 456F449EBE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:05 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 d125-20020a636883000000b003db5e24db27so6534856pgc.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rGzh5GvsV5L2zEqZPzXFz37QyRFi+koDaicRtP2dkmU=;
 b=OPhWIYxaFR2dtemS1rpu36wC5OAd8tOZ8Uy2j4Sg+WmZABVjAcyDohNhu+23Yq9S3i
 lo9dvAU0C2WlPy4wPB/0ufQBWEYovz7uf/zJMgR9WCwBx1KAg2LfO9cHzZRiv3nMmsWp
 rK6uGwu6ZWNC5ACoMjwmE/Djab2jF+ubLqAbGpWr2k6vL2WscKZdZXJ2wR+5v497WQPy
 P8IuV7t04tfEA9/qnPS8z0vRzSxQiXp4Gv3P0w+YCkXoi69Ani0G3bbldBY1bAY33Plj
 0Dtf7YNPhcD3HSt+A297W/OcRbYZVZQn4hgkC5h0dLMFuNzmU0xrtmyPuQEf5QUZhAdP
 yfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rGzh5GvsV5L2zEqZPzXFz37QyRFi+koDaicRtP2dkmU=;
 b=ozC+OVewLlz4W9DmiepMSQM47QEAbugel66ILz+82Qgl4A3itp3dpRIHADw/VINjUP
 Jut3Yh3rwFoNHHPFOuaCXUkkRHAFsp3O4Q/Yz0y+B5MVOVt2olU/EBVlw91hcqtVohUx
 Q5AcegA5IoRrsLSJPRJe/rbjelFQ+NGNFC//WXMXFUP31wk5Arpx/6k50rfPF/1is4fL
 4CqLbeJmn8dWG4vZBlpSQ91GIJYzX2ClnwHLOS4Wq53lZc/4vJ/YhAx8/yEfSyVuKx+C
 noqSEiu8cri+VQGgqCDR1FK79PWQI8NsVmNTGjkSK62TFNHQtXBjoDOdLdN2jHDyy+r6
 nXzg==
X-Gm-Message-State: AOAM533vQppVy2cK2S4wiYzlrO0D3TmASuI39JzuBjblX0q/uYd3GAnC
 bPkdfFIfFLmp8c36jUG45PiBRjWiHhNY/A==
X-Google-Smtp-Source: ABdhPJzOidTi35Ysu50FwznFojTNwKrHJzIVcpYJbrQfhWJlsKRUbKWh5n19ouRkc2VuKRGIDM46saF5Yjcz2A==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:2a8a:b0:1df:26ba:6333 with SMTP
 id j10-20020a17090a2a8a00b001df26ba6333mr4145pjd.0.1652743324001; Mon, 16 May
 2022 16:22:04 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:30 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-15-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 14/22] KVM: x86/mmu: Pass const memslot to rmap_add()
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

rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
memslot.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index acb54d6e0ea5..1c0c1f82067d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1582,7 +1582,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 		     u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
