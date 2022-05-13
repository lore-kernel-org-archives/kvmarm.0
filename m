Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7A9C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9CC94B1BD;
	Sat, 14 May 2022 06:09:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q5cik5LP3SRA; Sat, 14 May 2022 06:09:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 891D14B274;
	Sat, 14 May 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8430249EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BLK6s45DVKSc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:57 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62680408B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:57 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 r16-20020a17090b051000b001db302efed7so4845659pjz.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=R2k5lQSqINgMzSg3h1Jv/V+x4VA+8gcfFTJByzEmdDA=;
 b=EU3henCftOq2Phx82RY7J6BqUQU+5NnYx5FkdAcZ0AjTnM/NEfcaeb8QdDyAd2mn87
 Ofot1wIIOg7d/ZxD2XEKWbYLKnHccAJ2tqSzLFxbb/YOleCCNYnl4lxWlgAbnQukzWPu
 72LMPoClWYE+XWiNBre8Goc/f9udtUpYva7+hvc7GU2wnamgH0z+Eqw9vLj0LpGEb6KM
 70CPZdMsZAUBI5mjCNpQRCQ8n7Xr9qtR6WPrqaCm5k9pIE4OhYSORd4IigD2RIyJ1bp4
 oYhPb2mL8IIoTjyJ0FnJcfLzLVFuR31s36OqUpDHmT3XZkVUVX6kdG+1wHL0K+KFgtsG
 BGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=R2k5lQSqINgMzSg3h1Jv/V+x4VA+8gcfFTJByzEmdDA=;
 b=4Nocv1wFHWS7J6wK+aw3M1boey+ipmWJ2iRJVXS9n2FDmgEgPCn+1z2jGO5dyse+LT
 7uMRJIdIQD6zFXJYlx3LaSuvP8A9uiLAueGFdS4IzJSTDO5hE6YWfcykVssNOd307yID
 NaZhPziFvBEershIW2g7S4C3WYaWOTk3vjel3aV8QjsSvfCpMZooSA2Xo0L5+Rs1l91o
 CoOwrbpfzYMWadm8hhXP+F0z22y38KzKlTlHRSlhNzXv32+glyo6KqWf6i5nwklXdZZC
 M+wJuHqmWh98Pp09eH1s6AZ2MlUFuLyJ0HvA8nIWXsSx13JBYaFUshTM0wgxmvrw1iAk
 B5WQ==
X-Gm-Message-State: AOAM532yJ9b7TblJ6lt03amYgnBXA7l1W4nbrLQz2bY+Uh83T7TWpLII
 lyNJ08VvLx4PfUckmimnpcrtcV1WGFI/bA==
X-Google-Smtp-Source: ABdhPJxY2BhZKf4uGbUq4BeYViiLb0nNkU/Ef26vfAz8aiDUZBG4gjV5YebQ/CaStCtCadWMLVYtA+Ydny+dSA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:174a:b0:4fd:ac35:6731 with SMTP
 id j10-20020a056a00174a00b004fdac356731mr5985955pfc.71.1652473737018; Fri, 13
 May 2022 13:28:57 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:13 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-16-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 15/21] KVM: x86/mmu: Update page stats in __rmap_add()
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
index 0a14320fb148..c7cc552440f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1588,6 +1588,8 @@ static void __rmap_add(struct kvm *kvm,
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
@@ -2810,7 +2812,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
