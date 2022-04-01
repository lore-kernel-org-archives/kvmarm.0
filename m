Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89ABC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A69EA4B266;
	Fri,  1 Apr 2022 14:21:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s5gpPdYe6Zr2; Fri,  1 Apr 2022 14:21:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D60EE4B2EC;
	Fri,  1 Apr 2022 14:20:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E83C4B268
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mkzJnEvvB+oX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:26 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09CB54B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:25 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 b7-20020a633407000000b0038413d39ca9so2019133pga.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=M8diawJ0a5+6KeqCTlFavoigvh5ZH93bmgpmzfeJdKU=;
 b=RKIqIHqTnVlf04If3sQSSAHbqv3QjMDqucAB4bBcWHE84GJh7XwJyqak7+P6HFLJ6n
 +L1EoCVaxTwBwzeLwEZ0Mnk42VtiBqYSiLFEinADKf1v/Yjbv09HeUnW2aHu/sANey8q
 cjo663yO9FAQ7xYig94gQ5SsFEJK87TpzlrwfQpq1FmDouuBdRw3HLf/GzCksxq6h6Qd
 dHPc1eGJ/weS0TRiejDzlpOCxn9sAZnBRZi0jKPd4b8sUEQnMpL4KP+7rN83HYMRmSNw
 x95OtGAk1v69jDYVtvnNR9Y1eLvJJQfdxffJ5OeETA4K9WvDstqnYfAG9CmLiSo2fVV2
 anFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=M8diawJ0a5+6KeqCTlFavoigvh5ZH93bmgpmzfeJdKU=;
 b=hgO3xHUtVxvTuIPxmwAbvhdO9+oUqmg3nY5maL4ikLae/3pdrLyv/bVA5h03yaTdeB
 xXCezQN+Jr7XD77/7dSQuY1Vr+7hNwSm6/HV77ZDLgo12kl0UOL8Xsq1SlTILUXDj2rk
 4simCdNXxKnmMJwGhkZc1xiaILC3Grj7WU3c6qreHQaVw9vpL7wL8xSQmPCr9i1vzBzx
 pO9XQWyz0zy6MHdrYyAl8SGZC+Fs/OaZ3o2fLzdX6NJtv68VYo0Q/UGJuCg4wyyyS9l+
 No4Oj8HwzV7P2AMJ2E5cykMmwpwvIqRepLfgQ9UyrJbJlmcC5aDCaaetlrwLKQXhs354
 i6cQ==
X-Gm-Message-State: AOAM5312GRY0N5yn7DjtEsmZUusXgskHvM29km2aBIxjKC+VYsCVUZmf
 ruBA9nzFQjkYO5GTK+gUKMctYmGVsE7YIA==
X-Google-Smtp-Source: ABdhPJzPFkqyWE5YerNB8OHSTmxQmbipoI1rO0qgKI7jWDlomyQ1zN1wSQvVwslRKXespEzPjv+VbOwMvNn3Mg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ec8c:b0:154:7cee:774e with SMTP
 id x12-20020a170902ec8c00b001547cee774emr11782718plg.61.1648835785152; Fri,
 01 Apr 2022 10:56:25 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:46 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-16-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 15/23] KVM: x86/mmu: Update page stats in __rmap_add()
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

Update the page stats in __rmap_add() rather than at the call site. This
will avoid having to manually update page stats when splitting huge
pages in a subsequent commit.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7305a8c625c0..5e1002d57689 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1602,6 +1602,8 @@ static void __rmap_add(struct kvm *kvm,
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
@@ -2839,7 +2841,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
