Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DA6C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748214B1F2;
	Sat, 14 May 2022 06:09:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fpWtWZQehyt7; Sat, 14 May 2022 06:09:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AFB44B26A;
	Sat, 14 May 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A65149F46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PjlGGEFg6jCW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:54 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3571C49EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:54 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 r16-20020a17090b051000b001db302efed7so4845659pjz.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HdSYABheIVOM10QD4ZayPYXlWKlD3eG3FLGapADPyAM=;
 b=DKv+56mwaJWUT+G4vsPsYCrRgu169RzDr1vagq7TzGEWd8AGHodvyf1WxeUSTaQk1R
 NZpymIDqGyI73sb4uJT4lVVGGSNWJoPOGVC3ufHvKHKYMUDvpLfYxri94REs0NdLnym4
 VQlUurwgO69SpR4w7OrRXKWUnkasbPEm/KGx2WDD45/Wch+D2vSCMrwnnLxBR5Dg+i++
 RbIaYmLyPpn+RmzwOcwuiMaxrmfIOKCC9JC3SeXVyGnF3OPutmFP8inT0wwv8GBmXQ7k
 up4S9n+QdlOKGVRoYLpl3fUoIcGjM0FIiWJyGxiCbZ5/sEGDz4LRyDtCZBI7ZEf5/LAe
 dYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HdSYABheIVOM10QD4ZayPYXlWKlD3eG3FLGapADPyAM=;
 b=R2u8BcercbANML+pmPvzn5ATtRjXfPwOuZKAGMmFJ1R5UiRq7nknIQa6o3fbjd9NBb
 TFDIkvZDuiWgzzzbuM+kGRSjc4pHednwSMsSts3Rvv4OBeKHoUmxVzngE5EwLoIP3x1K
 5afFBLMIxjxj4CFFbKMct6iSlAYiLqFzF91nxg32Px135lWmEbBVIjX+lhPX8Sxjx8VR
 vjtrNbu4WvTV57JClPjsfDyXvfwgRtOPEQpf5InVnT3tA36BeF5E2C79rj/6ZLiLqBX7
 BiU1m0bpVQnmsJ3XRiCIe5dDN0/iaq5WBNgW1kyyqrQXzuGZLAviSiDieXKGHj/RHicL
 R72g==
X-Gm-Message-State: AOAM532qNhz05nSqlua8c/UpwiWS8L9KJQjrsZnh8WkOSVy9U/cJLjGv
 bI8oDC223M7VqgYCBS5fkV/c3+zly+xlIQ==
X-Google-Smtp-Source: ABdhPJwj07m7NSEGJMSuAfHJ7qPKyzdtRoR8FmJzEkiBVDgBAvJuoRdDpvYbVdyeM8hldK3oO0+DNeon+My0nA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:c7d2:b0:1d9:34fe:10dc with SMTP
 id gf18-20020a17090ac7d200b001d934fe10dcmr18025976pjb.109.1652473733328; Fri,
 13 May 2022 13:28:53 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:11 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 13/21] KVM: x86/mmu: Pass const memslot to rmap_add()
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

rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
memslot.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bc66029d837f..8a6dec1c27c8 100644
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
