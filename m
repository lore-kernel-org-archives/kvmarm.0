Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3947CC4332F
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D59F449EFB;
	Sat, 14 May 2022 06:09:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UjyUE767F-FD; Sat, 14 May 2022 06:09:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2CA24B1F8;
	Sat, 14 May 2022 06:08:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD8F49F07
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gIxq5sVdVPvs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:30 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4A8A49EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:30 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 g5-20020a62e305000000b0050d2dba0c5dso4469049pfh.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nd6Dxj+D3c/luGLy1QY1Ne5KCdEStn7D54niackY8Gg=;
 b=lIVEL9NlTTvEk0jvQdHGYdcqrkD4LzOGT+wWlx67gTGwgZCjTYYlZT0CXziIbqm805
 xEKGjNBHceio2qKgjjTz8s9D5VtcH+dahCCFdmRcTqau/OYncXoMwZfNVfZijldNuv9t
 x/H0ytTC9mY//Xnze7OLPh7PnqyEe8fMWdiFNyA0LYDukR0MWxkuWuz89LLmeMUnb3Oe
 v0KP285xw0HkbLpInenTzibDOT9o6C/Gd0WhPdssg4N88symfMODlZ+JGY+RaQNZ+zOR
 A+TvhwsKTkkv6Ipa2LjdGJ7/AkMXZWaOORe18arUxR6aWUMglTc9tXO4XNDRNYNitv9G
 4f0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nd6Dxj+D3c/luGLy1QY1Ne5KCdEStn7D54niackY8Gg=;
 b=7ywSbNffB9lE/9UpO0nLdZdppPlckl4mc+WyP5bbCxO+7f7pk6SgygIQbUwukx1gex
 zssLUMJfP74/aNeS9nxDS+Zzq6ACk6sq0O+IHJVOnWYzoGJepFHVi9Y/6yRdFq5aAbgJ
 H9Nk69JkiwyhbsjOD27nyuNq8Bjf+XIc8/Txkz6s8ihz2Valz+OO1ehyVrm+9kpC4Get
 LXeKj8Cet3aJzUFT2Pyh9MHR8FPlak0cJGsdW6Ry0HH80xqkNDFxwZbh0NMQk0FeMtYm
 e19l2cngnBiSz3IS92MoQaqRTJU73pBKO6/aaiWtOXzs7rlfYuym67l7wIsOw6+/IuNX
 92bA==
X-Gm-Message-State: AOAM532JPLrLzNQ5Ysspx49PwOPq/3aqAeN2LtvYPxmAvbRthnkqolwF
 nzTCz2eFJCJbo5+g6Vaig4OrTYlxC6IGjA==
X-Google-Smtp-Source: ABdhPJxPNMW3m8DWDbKR8Cxzp87MsHzpapuqXK0x8Mkd7Lb+oA/CXzKK6BuuZIvN94SWRy5m3PsmasidYIIY8g==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr250707pjy.0.1652473708906; Fri, 13
 May 2022 13:28:28 -0700 (PDT)
Date: Fri, 13 May 2022 20:27:59 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 01/21] KVM: x86/mmu: Optimize MMU page cache lookup for all
 direct SPs
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

Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
fully direct MMUs") skipped the unsync checks and write flood clearing
for full direct MMUs. We can extend this further to skip the checks for
all direct shadow pages. Direct shadow pages in indirect MMUs (i.e.
shadow paging) are used when shadowing a guest huge page with smaller
pages. Such direct shadow pages, like their counterparts in fully direct
MMUs, are never marked unsynced or have a non-zero write-flooding count.

Checking sp->role.direct also generates better code than checking
direct_map because, due to register pressure, direct_map has to get
shoved onto the stack and then pulled back off.

No functional change intended.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e0..774810d8a2ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2026,7 +2026,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
-	bool direct_mmu = vcpu->arch.mmu->root_role.direct;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2070,7 +2069,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		if (direct_mmu)
+		/* unsync and write-flooding only apply to indirect SPs. */
+		if (sp->role.direct)
 			goto trace_get_page;
 
 		if (sp->unsync) {
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
