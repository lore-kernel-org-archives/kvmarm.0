Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF401C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78FF94B2C1;
	Tue, 17 May 2022 03:02:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id loodRxLZdivl; Tue, 17 May 2022 03:02:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3144B2C3;
	Tue, 17 May 2022 03:02:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7CE4B1F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5XiS36nsUNFP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:21:44 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81F7D4B1F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:44 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 o16-20020a17090ab89000b001d84104fc2cso244884pjr.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nd6Dxj+D3c/luGLy1QY1Ne5KCdEStn7D54niackY8Gg=;
 b=i3uMJsKKZ/XQE4JHEj68rSTKlYb1NduEyUOZ3xS8XgWD9SjI/+SpqpYTidv2LQax4s
 Kt2YfPCb390F3PDSFpc8dol9kk4EG2+VQ3LPEM39lW4asDIdueiF9ywQRN7ZDdQHFPxS
 rjhXVZnTN3vQ1YyLF4Siw+CKlwy2IblDNMYwQZP8ODwweFgU3BUeA3pYmSiUZMJFO51g
 gsn0ARDvZSuDL4E1HO+la9IDrMmxJJ3zomsyr8N+H2unSOY4V2ClpS2op9i2dY6w6twK
 e76qUp9gPrSFHtqa97W8KhPb9zpg7aH3Sfxmp1NwBZk+eIe5o8iS9qIP7BftkJKcbzvR
 Mm/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nd6Dxj+D3c/luGLy1QY1Ne5KCdEStn7D54niackY8Gg=;
 b=o21+7Tn5daIDmB4MSn9j0Ag7xL3ATBHxL0ZcUiwXOihTgHXf/o/wthTKSZdhvpcRtk
 NEmpKHEk3kZG3uQ8Gdqv7VAAdetdMBp2C4o1ImI53GF6eiDfbRfNjNFkOyUc8PG7V6T+
 g2+vHz2RHcAE7EZ6ueMkKUtaT/tFvzPjrbNLPwhzpLfzE/2UU7GzflGHCCGfLPvR9V3Z
 ZDi3GkF6ieTP0SrODCFTCpFFQFwjll0KadxyOjhFr5a+6snLhWISUZdoIpXunAHvaZXb
 o0jKg7RwYwhoS+lDmzNf/g9IcP9qryTuJN+L8NLThCP33lr11OMkH4MRX22NkoPzB+lw
 pj1g==
X-Gm-Message-State: AOAM530bZASKSRSQ8t4tB+Ekz6u5BkEZaenvUJU0qCF6NPTutEMwzytB
 fzUBqyt8x/j+ILHwjwzOJknWYb26kUYkiw==
X-Google-Smtp-Source: ABdhPJwZ4hPASu3hwlbQApjM3Qpw4pmZCcc7AWStf7IYvk7O3j5Z1wZRMVRJ5UOh13coV7lr1j1BYTYIPZhckg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:30d2:b0:161:70be:bf86 with SMTP
 id s18-20020a17090330d200b0016170bebf86mr8770769plc.18.1652743303616; Mon, 16
 May 2022 16:21:43 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:17 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 01/22] KVM: x86/mmu: Optimize MMU page cache lookup for all
 direct SPs
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
