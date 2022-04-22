Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4955C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C9D44B0CE;
	Sat, 23 Apr 2022 04:57:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U-63xgeiISMZ; Sat, 23 Apr 2022 04:57:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35AEB4B2A8;
	Sat, 23 Apr 2022 04:57:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21CC940C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XKQF8nahOY7C for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:06:09 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1430549F14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:09 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 k5-20020a636f05000000b003aab7e938a5so2681863pgc.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=K3CLnYXYtvwizIx0k/SHLSP8rSxb5Vb9/+Ons8DtsNg=;
 b=l2jbmncxyjqZKtjNxBwQjGGI5g04tJzYsGlUZdx53H4OmCl7Mb8VVw6NQr06/u5sIm
 t7o9fZY1KQubggYso4Hk8sVINmzelJOkDXmo4A3b0OvzrgMUHpJfM5GxpywlO8GiaglK
 boESpTsBCImRP9pHIN6HhIgSF8AVf860FSrJpiJk5cCfpoMa8Uutbu1v1IJjbjHKip5P
 OmoUnN2F8FYsQ9FiQJc5WB5DzQ4wQW5qYVEoc2/ebZ6AAXM7SCjgglwzsMQFgp/GNklH
 4O8m1AQ4dX5M6yymiWkhpE5eycUOVcGs06KWM6JBv7y+h9hHVc2cO/wykNVd1YFzJahw
 gK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=K3CLnYXYtvwizIx0k/SHLSP8rSxb5Vb9/+Ons8DtsNg=;
 b=eCEw095UpmPsP74LQJY0oP4DVhyvIMxkhfZKgcAiwdalfCdrDpPV6158wEJg/gmW3K
 KQmZ9Zl+SWlyfKqRaqKfP9xMqhtg9wY9Hk0HNz810qDPyu+9FuOOHxA+iFFGx4dbUAm5
 gY/OiGcADHBdhJeaExoxLHSPsMNemZLTjD/tILRZcEIYKbn68bPGRaPkae1j54C7UtqB
 g7xzYHK/LPGjmTBoarDHrBCrnFN2ktqgh/dtP1fzC2fNwJ7MkPH+Mz3Aym3W1MHRBKK7
 GhSrk4Ql0hbrd5sgc2xh7wR8Bi3rQ2foErL+bQ1u5+9fq8DzU3gUc2Kna9ufBvpxKPMS
 WHYQ==
X-Gm-Message-State: AOAM530u8ZRlBboHVs7mWpNdrenBQvpKfZ4Bs5NFHuXj9c6vVEhZeboi
 DHQfbsmOQ81eHfE0OS1nFokyPZ+p3NfRdw==
X-Google-Smtp-Source: ABdhPJxo16FW5saOeBbKmUkcRSzAGnKKyvc+JzAJ2fwc+QXYy7JIR3KSk+h5wZyUpeyuzG8nBdVfN7Odw8S7VQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP
 id k5-20020a17090a910500b001d29e987e1emr620451pjo.0.1650661567820; Fri, 22
 Apr 2022 14:06:07 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:38 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 12/20] KVM: x86/mmu: Pass const memslot to rmap_add()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 23 Apr 2022 04:57:06 -0400
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

rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
memslot.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 21407bd4435a..142c2f357f1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1595,7 +1595,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 		     u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
