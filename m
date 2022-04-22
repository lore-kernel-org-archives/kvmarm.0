Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF2FC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5196A4B21A;
	Sat, 23 Apr 2022 04:57:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7da6fwtCfLxu; Sat, 23 Apr 2022 04:57:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 917884B299;
	Sat, 23 Apr 2022 04:57:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE3B649F1C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wWiuui3AQ2kY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:06:00 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3D7D4A11C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:00 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 q13-20020a638c4d000000b003821725ad66so5625239pgn.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EZ6lXuaS+fWlhXKNn5Z8JpVAcYLp2zeP1jB8K8WPgIo=;
 b=c9IZvAf9/lbIbolLkPnD9B93ep9zv/hzix3WCn+e74Fmjb2P/4TE+CBLjJ8hDC2Mq9
 cDB//hDlGC6hZ4KlHcTLpYqfZG1xGE+cd+VRxeSUJu6Hm7Aiuxb3wdIRPkUGu/gMv3uE
 YDQlVgY4NqfyftIukn7TVeVdRCf9XNubptM2eOgvVPOXcUX4+v/ynPLsVe4mBj96Unad
 JW9x5rF/GyAlRqRU9p5r5qy7//mNfVEJdH4cH5thRpqGPtRs5FWt/YtMEViwXxugkbSl
 c/r6R21ZsBPm04eZkSMBQ3truwm/JD9O31lNnAaIXX3xIG/vUJTk+FM8rq6d+8Xc1mWI
 XtTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EZ6lXuaS+fWlhXKNn5Z8JpVAcYLp2zeP1jB8K8WPgIo=;
 b=Agh8PuqK1zBN6amL3Xc5dIrgKDIY/xA1m5GJcLP/LeOU0zZ4MmPYXUCpnoyHgfIoE2
 mfVyMBtt0X4zaqPpthYG7+rU07Ve/+SxAdwTExVryFiZbFeC/GI5wSxjVeqyCWhp6qas
 2W5ul4G4bGtMnCgnSxctbuGuK5ku3cHgpYVCbHfJFxYcAJ5STlDXFB9yL0d9U3n0b9ES
 u83hkXY0ACpSg/03PCrUskOreYaiZcsRalEGo6djjycLSxl1sOBAYJ5dxrDCy0AkM3zD
 R6bG3SVedxcnlLG4cjrF6syOf9q3FFy/YFgiMwPz0cUg2CsO/MqzEm/e1qlMA7yLC7f2
 afAw==
X-Gm-Message-State: AOAM530TEdzSU/h6bJdbppbG5K8k4Fr0MoODGV2gjWVefcVMH6CgAt6f
 P/ubVudbMNozAU+D3HJAi+WIb0Bydymz5w==
X-Google-Smtp-Source: ABdhPJzeRPLDKYvrDf1cDSUjbw4PRRYcM20/mlPk3ZQsllbTvdzlIbLo6Pq0AisuhgcyHRC442gDS2XxX07z5w==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1a05:b0:50c:f9b5:6c7e with SMTP
 id g5-20020a056a001a0500b0050cf9b56c7emr2359480pfv.55.1650661559952; Fri, 22
 Apr 2022 14:05:59 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:33 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 07/20] KVM: x86/mmu: Move guest PT write-protection to
 account_shadowed()
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

Move the code that write-protects newly-shadowed guest page tables into
account_shadowed(). This avoids a extra gfn-to-memslot lookup and is a
more logical place for this code to live. But most importantly, this
reduces kvm_mmu_alloc_shadow_page()'s reliance on having a struct
kvm_vcpu pointer, which will be necessary when creating new shadow pages
during VM ioctls for eager page splitting.

Note, it is safe to drop the role.level == PG_LEVEL_4K check since
account_shadowed() returns early if role.level > PG_LEVEL_4K.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fa7846760887..4f894db88bbf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -807,6 +807,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 						    KVM_PAGE_TRACK_WRITE);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
+
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2100,11 +2103,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
-	if (!role.direct) {
+
+	if (!role.direct)
 		account_shadowed(vcpu->kvm, sp);
-		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
-			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
-	}
 
 	return sp;
 }
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
