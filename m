Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7264DC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:20:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E04024B2B8;
	Fri,  1 Apr 2022 14:20:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LEyG9In1RIr0; Fri,  1 Apr 2022 14:20:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 791324B2C3;
	Fri,  1 Apr 2022 14:20:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BC604B20F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3UWnXA4fzRmF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:03 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E5194B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:03 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 e12-20020a63544c000000b003985d5888a8so2000544pgm.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IZRim+LrWsbKLhWGtCJAPIUqsiasbKStOmO5lLjRFP8=;
 b=OZ/CKz/kS7tsC+5ET9TAryRE1kCwgOMM6JGu+otu2+fefVt4XEH8bXii6Cm3AUtLCN
 Gw9osJsofH3J6mv+Pa2qF4AgPyuVpqfC38Nn1tKiG+M3EKrlbdGH2QPh3j9eewzu59lx
 ICuKCxkiGaO+YeoyVNcW7Nro8EgWUt56TC8bmJ6E3nLjN6WPFH2wT9SX/X9xZP2ZiF17
 FJmRQTr/BPkOe9FVzGO8FNFlXg4UfuMC8jzLYVLEELEQwUE4jThW/O/paupXC7lWuxy1
 jJcoNEaCMLN9riLuRhRPnUtblhKer7FLcbWvKt2OPcW3oc7aFw2S1ONaKDFn48FfppNp
 IR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IZRim+LrWsbKLhWGtCJAPIUqsiasbKStOmO5lLjRFP8=;
 b=cjluRMz6N9hiBImeyf8PbgOfnymQ8BRfCoRNkmzZeRVzoHnL86f7hdrWP2hGZxT/mN
 sKE5UiDfXqIci7gWKkZer+UbuA4SrOdO3EupaA2zXJoncA2I3fs/zh2sEZHtElx2ZBGU
 BEGS/0Zk/Jsstcg1pqO22jX24+Wg3FVeRpoFsmBVclgjIfdaNSzdekMon3ZgFZQrSQDb
 Er6jeVzcV9GQED3vwGiO4sfotfoq+JBxakvg93Umv/xsp+Qy/FeXONOrJc/HSPCFs1eL
 CX4kGyhwrWm6SPuPF38dOWiRhvHJQ7I5KcrzUb4vddVaweCeAeebPEBrleKqMiiS5aHP
 uCXA==
X-Gm-Message-State: AOAM530E5ltCDCfJOdK/kQuuYKOq0XHTfJPFvcQ1rNaTIW/FQf1GPQFD
 H3HGUi9Hfod8GgnguI67viUZ0/peTFCoUA==
X-Google-Smtp-Source: ABdhPJw5vwbBPjHYSVeggYwsZsRSNlx5RqVJMTrxoIjsNKWoBtog3ECYJyqS377WsBTJdAeMsxOsjt/Joc7/Ug==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:6403:0:b0:4fa:c74c:83c5 with SMTP id
 y3-20020a626403000000b004fac74c83c5mr11997208pfb.30.1648835762419; Fri, 01
 Apr 2022 10:56:02 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:32 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 01/23] KVM: x86/mmu: Optimize MMU page cache lookup for all
 direct SPs
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
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
index 1361eb4599b4..dbfda133adbe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2034,7 +2034,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
-	bool direct_mmu = vcpu->arch.mmu->direct_map;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2075,7 +2074,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		if (direct_mmu)
+		/* unsync and write-flooding only apply to indirect SPs. */
+		if (sp->role.direct)
 			goto trace_get_page;
 
 		if (sp->unsync) {
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
