Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A11C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63EB74B242;
	Sat, 14 May 2022 06:09:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tG1JUqOO3Sc2; Sat, 14 May 2022 06:09:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1123D4B18F;
	Sat, 14 May 2022 06:08:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF3449EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:29:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fjKq7OI18Il3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:29:04 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7562408B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:29:03 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 h23-20020a17090a051700b001dc9132f2e6so4467595pjh.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HIEyJZRpr2jcyJ/fmafeFJZJ+wHC9HCHT15KsP+KWpI=;
 b=iX2OHbcsw6FoAz7JEDK5rCc0tPJZ6WRbOZwRG6RKbT6jQXE17WlJGssIhPSuOfq4wg
 XIWYuYcX7Qr2tZDPW/lhm/HFLaZITZv+aTjfF8YjFYU0sFPcSEKTdsQf8V8UCBPIFDaJ
 zAX4r9SsXZT4d/vumXd9b2lJvSoFyEdn6BpoxZjDvlRUGV6YUGcOXw1I+2+xVxP9bJfS
 W1UKZ0cG0kKiaF/jhb6RGWAroxpcUtuLqHG2/OVzXh3xkhppxtZHgOnppeAhPozEtFQE
 kWNDFaxhB2KovtE4moxtaq1/N45e6JC2x9tkuceH94bEa+5M6j3HNICKGx6Yavc3s6Nc
 H7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HIEyJZRpr2jcyJ/fmafeFJZJ+wHC9HCHT15KsP+KWpI=;
 b=ses790tfjDKGGsf3rk5zmonOlBxV2ckrR7hRgoqxiohWGc2GzJQwSSIDUzbt68Sizo
 8NNhZbdu2kzEBBEc5LRPHfGDRNnXVvA3ePR8CD0oqW+/exHtOWt5FxmzHw77BkTkTwnP
 6JMva2t+6RTt4x3c5Ujl6bgR8WQw9OM0YOKSdK40XxVWOeYwnZiG1ykr96YK8yysLwYH
 X1fPlTj/Nf54ZjGWQ9IU9rwlh22KUddB7a1PopNFjZ1GY9/tuAefoIpDjgjJHGwQdHG2
 tks+CLU3Kx3I6PMQ+kFyLTgMsFuHMz0T6UO14aEin2o+KVl5VSqhxk80STizPkk2mXJc
 cJKw==
X-Gm-Message-State: AOAM530D1BVm3/MQT/gkDMLIz43ZS+cr5n4Yv4GyKZ/tBfRBJo7BTLKF
 +w1wyRCy3BfYhR5eLA4zrRkWlKJN3AvYmA==
X-Google-Smtp-Source: ABdhPJybUih+bwE7FyOBg+qcGDi8Nof6ENpdkam6v1N4A8EAkz8f1UOC2uM61149paY4cu0ueKr5wo9dTOwczg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:cf44:0:b0:50d:6d18:17f9 with SMTP id
 b65-20020a62cf44000000b0050d6d1817f9mr6142945pfg.63.1652473743414; Fri, 13
 May 2022 13:29:03 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:17 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-20-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 19/21] KVM: x86/mmu: Refactor drop_large_spte()
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

drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
Its helper function, __drop_large_spte(), does the drop without the
flush.

In preparation for eager page splitting, which will need to sometimes
flush when dropping large SPTEs (and sometimes not), push the flushing
logic down into __drop_large_spte() and add a bool parameter to control
it.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef190dd77ccc..4b40fa2e27eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1161,26 +1161,26 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void __drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
+	struct kvm_mmu_page *sp;
 
-	return false;
+	if (!is_large_pte(*sptep))
+		return;
+
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
+
+	drop_spte(kvm, sptep);
+
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
-
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
+	return __drop_large_spte(vcpu->kvm, sptep, true);
 }
 
 /*
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
