Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829F0C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E11734B0B6;
	Fri, 11 Mar 2022 03:48:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4zI8osFH0KpA; Fri, 11 Mar 2022 03:48:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4F649F1C;
	Fri, 11 Mar 2022 03:48:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6980A40BBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y3ij7lVUGluQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:35 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B60140CDE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:35 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 d145-20020a621d97000000b004f7285f67e8so4189241pfd.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0eAfKiOxcQy9JlkrjXNpoHqYHtmPuiAwbCjCtsBF1gU=;
 b=Ds65Duv71Sj++gu858kzQzfx4qj+n74AY3f3En/PZmXyzUO8L6iQ55bITs/kJzLy7E
 1jAfwm8/sK5JqfrHLJDw8N2+qOoDaqdIgsikIF90Gdja6qFOkEyH/1V+THlFIGsLKAUI
 NrzcYy53Cwxzug9SUZA/22KspdbY3akV2eXvpVmmP8/088xMO6De1aJppaQIBk6f513S
 D/KDc7JzburUmP0xkKQTMIcZS0hk68J7NNa+iw2WZ6/Q3TfdAEBsREKoblTyIGSfh6K2
 k54muP2tXq0Pjriu0Esl1G3PuZQVW3OvY79X+cSH57wTuUftGGbDJIGQSSTasJuF1s2x
 vb6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0eAfKiOxcQy9JlkrjXNpoHqYHtmPuiAwbCjCtsBF1gU=;
 b=bEpHY1+0MXCmbz/Q+kDKb/CcwJXJ7nysdtnpJnyGEjgu3ULlZSTWGvd8HY1nsji/+T
 4oY/tVkaK9Ll1vrz9msJdyP1bN7IU4KOs43JXJEZjqeknr9qGCj481pi+oje+R6I8VbJ
 l/6ICLb6Jr/GFUypuWn+NiHjDJSKGrh8ML+yDBE5rkB3c2xG3sOZ3bqMGotzxszm6wvu
 IWN5S38F2A3Pv+Lnmu32jkIaFEHNzAVHnpxmrhPFqkV8TRpQIgW6D+TXcPixGrpWX5ax
 aEcnHiJwqpeZbobfOHZoqUYcYcY/BqarW2XDUUpHsy6oPAddI/aOPruN6uM2s2PIDAo7
 D6Og==
X-Gm-Message-State: AOAM531ndzDvKgBJAE8dNAvBwqPXsY62KZuf0TJhn+RdwGXDYeUhegW4
 jHyjioW70+0ocNwDRJ+wCO44C7EIvprvWA==
X-Google-Smtp-Source: ABdhPJx2ihth+Lyp0jx20NkW4UoRmNnE2WoUi5zOLMEZXktLr7faLnrpgu/8QE08DLH0Spz2A92OMKfVSAfiBg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e5cd:b0:151:da9a:2b5d with SMTP
 id u13-20020a170902e5cd00b00151da9a2b5dmr7419566plf.67.1646958334306; Thu, 10
 Mar 2022 16:25:34 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:04 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 02/26] KVM: x86/mmu: Use a bool for direct
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:41 -0500
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

The parameter "direct" can either be true or false, and all of the
callers pass in a bool variable or true/false literal, so just use the
type bool.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3ad67f70e51c..146df73a982e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1706,7 +1706,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2031,7 +2031,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
