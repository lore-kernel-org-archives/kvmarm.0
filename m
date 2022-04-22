Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3651CC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6FD64B286;
	Sat, 23 Apr 2022 04:57:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TXPrhwVnh2Qf; Sat, 23 Apr 2022 04:57:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1814B1CA;
	Sat, 23 Apr 2022 04:57:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09D0540C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:05:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kOUghxYo6hHL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:05:50 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCDDB4A104
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:05:50 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 r5-20020a258285000000b0064577f2c8adso5011802ybk.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ktDpzPoEdSrcrUnITrmIICEFHz35bcwHx2m+itC59DQ=;
 b=NuUyT27h7C++sSsmxph7YDVnlVq9JEo2qNd/NHlqu/pFwe1ZaK/DqFkIUFejxWDZ+L
 HCFTyNkmdUQQpAdlAE2EkZPO7+NrKCh3q/AAd7bXPDPhOya7e3i6fTvDCMG8t6hQE5Nd
 LlAD1nOHAruz6us2mg92VCm+qVkIiLQazVDQ+39JAk9pvNX4s290hmOx785CWQUF5t8l
 A5vwsOA/rpOEPfHSx7Z1ShpIwVYbjqEzdgZPGBXOf3vJFRbopVHdJd29zqqqJTdtpec3
 qba+yk3xoqB4ftlQhK5uXzW3eBe511TeE4WQjoUUhYWhQBZEwMZ0EgCcCM4XOXGcpVi/
 6mZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ktDpzPoEdSrcrUnITrmIICEFHz35bcwHx2m+itC59DQ=;
 b=6e0ZN8DXUklL//aa9xHIapkM6e/jdLkvJd+dRkpVVGpXQsln01pSDAdyxaqaZE6VEc
 D9RJVbcj6ISCjNKPqAAbqKsk1eLso1xFDujBkJNXxNlG4M/PPR0Sg+rjKOcVSfY43Jk4
 IsbJPnx5jCXo2MPnirbQImpT0OZ/dFYd9xa8BxrDXdkAXOPA96edsMkObbWfCwmKZJyz
 NzVFZCtIqRYo3fJVaE+rBtyV1P+dPrACXje6nEWcGQeWNj8ZXb4xFtxmdLyJqUd+u0Cl
 KYNnNSbONqTpl8SmVvXaLFI41511elaYX/kfAwCEfxWLDsaaCqniS/sb6lrebdtlFKCG
 1Llw==
X-Gm-Message-State: AOAM532RuaPl0PPG5m+T5kFnNRZ3dGMAhfBPlzLF4XvY+Cj742rMh+Y5
 pMgr14KoC2yu0rkl9bleoDbdTH2HzMQmWQ==
X-Google-Smtp-Source: ABdhPJznlbTfpPgBcQWgSKtg2XkP7301qyrPyti3UXIeeQDW4BgY3Xl7oEU2Sfv4r0Q1kAkWzLGJ5G98i8gXew==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:bb4a:0:b0:633:92a6:c35 with SMTP id
 b10-20020a25bb4a000000b0063392a60c35mr6239899ybk.121.1650661550035; Fri, 22
 Apr 2022 14:05:50 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:27 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 01/20] KVM: x86/mmu: Optimize MMU page cache lookup for all
 direct SPs
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

Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 69a30d6d1e2b..3de4cce317e4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2028,7 +2028,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
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

base-commit: 150866cd0ec871c765181d145aa0912628289c8a
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
