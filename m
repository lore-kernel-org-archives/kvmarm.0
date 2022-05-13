Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DD6C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE25F4B236;
	Sat, 14 May 2022 06:09:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SmsBDDDcT6vl; Sat, 14 May 2022 06:09:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E1A14B20A;
	Sat, 14 May 2022 06:08:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6BA0408B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ey1KFsbYxznK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:37 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D5A549F46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:37 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 v8-20020a170902b7c800b0015e927ee201so4843432plz.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wGHIzUdkImHbOgCE37BkR/+UNfqdKdFelxzR1hh/jTU=;
 b=AW85gt8Cm/akM6fN9YF1VI56V5qXCSMYonkm5FLUHZmqUsPnuhCTTXnBtgi9DFNwcn
 lj1Uwa/0VEsJQYRr9wQ3+UjaZWq8uJG7fLbKkyERC0L8JC2D3iot3WmxCKvtFjImh4xD
 xGivzkup6jQN70pJM4gSbe1QGqAurA9yISloGSd7fmpHI225Zi4f2zMdXPe5FBZz/2MU
 3vdJN+sPmDEcwZag+FclmZI/8GrsXPDO7sTuMsFGNuF/I5yRtjZDVCGP3adLsCmRIPHe
 gAEFJbvUCcNJ4pRE9G+UuIthYkITZL9tRzZHkxVAVDuMrnxwVze4xwuduMVNOWpNhKMx
 pSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wGHIzUdkImHbOgCE37BkR/+UNfqdKdFelxzR1hh/jTU=;
 b=XN2XuTVBUX+PWpAIY4TUoANP3nzoT3PTewXnnxhIotobrDauD8ZwuF3tzEXovczNLY
 nXnOLiLfTkmTHVNEHp033Xvh75kCTQTRCwTaF9wsr/0rdw+yKTrjvMi9+iyxU7YFqO0P
 RX6KjZjwVsHaUF6zPQrt+9i7AhZ3r6aCz0s9Xrvquyvv+13ZA2qKFABkLWbeYJyh81M7
 StVzg8/LWSY1wlnNVDG1SfKsvQjz+PRuo/VppxWxM+5WLC/uy377JF8GVIxaqCj0H/5B
 YE/bHCshsFQlb3q99TeytVrr+O2uAVqjcA7kaG0Y1Gpbxf+QuKKjKnJu5KiS5jh8mnYm
 xi8w==
X-Gm-Message-State: AOAM530An2LuOqgI/Jl/CSHPNUDyuS1wUMe7AZ2PrvBwq+R5tAMo1J52
 EficsMLeUrkfcvYRLJpg4L6Gri0cXYlwhA==
X-Google-Smtp-Source: ABdhPJwKUE0zCOcwZVsO97x6AhzKjnMvIvYyLucVAPqidHDvTm6P1AHwrq6LuBKpW9p7xKHAdpS8f31uCrjI/A==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP
 id d3-20020a17090a8d8300b001dd258c7c55mr250781pjo.1.1652473715329; Fri, 13
 May 2022 13:28:35 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:02 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 04/21] KVM: x86/mmu: Always pass 0 for @quadrant when gptes
 are 8 bytes
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
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

The quadrant is only used when gptes are 4 bytes, but
mmu_alloc_{direct,shadow}_roots() pass in a non-zero quadrant for PAE
page directories regardless. Make this less confusing by only passing in
a non-zero quadrant when it is actually necessary.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a927a062a598..34786244ebad 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3409,9 +3409,10 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	role.level = level;
 	role.direct = direct;
 	role.access = ACC_ALL;
+	role.quadrant = quadrant;
 
-	if (role.has_4_byte_gpte)
-		role.quadrant = quadrant;
+	WARN_ON_ONCE(quadrant && !role.has_4_byte_gpte);
+	WARN_ON_ONCE(direct && role.has_4_byte_gpte);
 
 	if (level <= vcpu->arch.mmu->cpu_role.base.level)
 		role.passthrough = 0;
@@ -3450,7 +3451,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		for (i = 0; i < 4; ++i) {
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), i,
+			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
 					      PT32_ROOT_LEVEL, true);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_mask;
@@ -3535,6 +3536,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
+	unsigned int quadrant;
 	hpa_t root;
 	unsigned i;
 	int r;
@@ -3620,7 +3622,15 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			root_gfn = pdptrs[i] >> PAGE_SHIFT;
 		}
 
-		root = mmu_alloc_root(vcpu, root_gfn, i, PT32_ROOT_LEVEL, false);
+		/*
+		 * If shadowing 32-bit non-PAE page tables, each PAE page
+		 * directory maps one quarter of the guest's non-PAE page
+		 * directory. Othwerise each PAE page direct shadows one guest
+		 * PAE page directory so that quadrant should be 0.
+		 */
+		quadrant = (mmu->cpu_role.base.level == PT32_ROOT_LEVEL) ? i : 0;
+
+		root = mmu_alloc_root(vcpu, root_gfn, quadrant, PT32_ROOT_LEVEL, false);
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
