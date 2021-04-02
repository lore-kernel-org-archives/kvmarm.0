Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FDEC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0124A61008
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0124A61008
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0194B2A3;
	Fri,  2 Apr 2021 05:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6THlKflr7Dmo; Fri,  2 Apr 2021 05:20:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 444364B2DC;
	Fri,  2 Apr 2021 05:20:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B92FB4B722
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8Q+PlKdh5Txv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 20:57:03 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF4104B6D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:03 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id i6so7668773ybk.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Apr 2021 17:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=DA+Fdq2lOX/CZ+xUDvMaD5HbV7riu4wHkKUqD8IM4/k=;
 b=jEH+4lhN683scpuXyDyNcFSmirhDLEuGk0lJE37N6PVMAVFNUPQDsSlroxmScN5YO3
 IBCGvHhBjtc8BMlUOqXKu1gYXzYw4MZpMUA7myDRgmdzVC/ZR0PTr4HKxjo/4SCJHEih
 Y08yAAvk7+fWeRM2OJoXDnImvQy8YXKdFHJEsuWkAfDOWtaTi+0uKhWpi3Ie7p/zDjMP
 iq644k8yugcuqQZ9i1mkoun+uj7px8E1zhFnLvbBtwUp/G6IJhnB5biBIIFY7KsXYCJg
 jnmfpegvWrj9R8JFD2AZ/HKcezGw+adh+gF5gk/hNaz+UDc8nBr71LdSLSS+hgpp5xK2
 yJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=DA+Fdq2lOX/CZ+xUDvMaD5HbV7riu4wHkKUqD8IM4/k=;
 b=iXQ/rTyL7oVs1Rgb2teqNAwVaM9ICRGBM56msQN3ivFzXn3pc4nhh4gWQZGzjMpkqZ
 jW80FTqCxN2AUZZ/BEhR42HlsD7jyi5jq84jilZ6idLpHK3Jt2K9VEOE7Pdq5tY5WzHG
 9Js+q5XKW86Y2LfTRyeWLrcpYForhw2lIkZkaEEnUHwEP3eKoda/kKhUa1Nfo3A09/5g
 76Cep3q2luU/HrStYnXaTn/gZ9PXY2Ap2ZtJ3OeC2qLJMZAUtPl2iKQ52dCsWu2PEiJk
 0xDW+PZOogyMGAOTg1+F+4UyR0WA93xFV+iKDw1FkhS8q2etX8ba+S2NYNyM5RuNZ1tA
 cPOA==
X-Gm-Message-State: AOAM530UmmetWwSauDjKjM15dw0gkFylg8nMR39tez7jcxhfKRIqeAgL
 uab+ABqB4tbAymReWZ46HZxp0tJLNzo=
X-Google-Smtp-Source: ABdhPJygeKAdy1Ue7ggQyWInnKM/181me24PPoeX8s/XsaZF77/exnxBmdxBDDEECxkfyMlEpqfXzJSZ32w=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:af05:: with SMTP id
 a5mr16043377ybh.86.1617325023277; 
 Thu, 01 Apr 2021 17:57:03 -0700 (PDT)
Date: Thu,  1 Apr 2021 17:56:49 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 01/10] KVM: Assert that notifier count is elevated in
 .change_pte()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 02 Apr 2021 05:20:36 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

In KVM's .change_pte() notification callback, replace the notifier
sequence bump with a WARN_ON assertion that the notifier count is
elevated.  An elevated count provides stricter protections than bumping
the sequence, and the sequence is guarnateed to be bumped before the
count hits zero.

When .change_pte() was added by commit 828502d30073 ("ksm: add
mmu_notifier set_pte_at_notify()"), bumping the sequence was necessary
as .change_pte() would be invoked without any surrounding notifications.

However, since commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify
with invalidate_range_start and invalidate_range_end"), all calls to
.change_pte() are guaranteed to be bookended by start() and end(), and
so are guaranteed to run with an elevated notifier count.

Note, wrapping .change_pte() with .invalidate_range_{start,end}() is a
bug of sorts, as invalidating the secondary MMU's (KVM's) PTE defeats
the purpose of .change_pte().  Every arch's kvm_set_spte_hva() assumes
.change_pte() is called when the relevant SPTE is present in KVM's MMU,
as the original goal was to accelerate Kernel Samepage Merging (KSM) by
updating KVM's SPTEs without requiring a VM-Exit (due to invalidating
the SPTE).  I.e. it means that .change_pte() is effectively dead code
on _all_ architectures.

x86 and MIPS are clearcut nops if the old SPTE is not-present, and that
is guaranteed due to the prior invalidation.  PPC simply unmaps the SPTE,
which again should be a nop due to the invalidation.  arm64 is a bit
murky, but it's also likely a nop because kvm_pgtable_stage2_map() is
called without a cache pointer, which means it will map an entry if and
only if an existing PTE was found.

For now, take advantage of the bug to simplify future consolidation of
KVMs's MMU notifier code.   Doing so will not greatly complicate fixing
.change_pte(), assuming it's even worth fixing.  .change_pte() has been
broken for 8+ years and no one has complained.  Even if there are
KSM+KVM users that care deeply about its performance, the benefits of
avoiding VM-Exits via .change_pte() need to be reevaluated to justify
the added complexity and testing burden.  Ripping out .change_pte()
entirely would be a lot easier.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1de843b7618..8df091950161 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -461,12 +461,17 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 
 	trace_kvm_set_spte_hva(address);
 
+	/*
+	 * .change_pte() must be bookended by .invalidate_range_{start,end}(),
+	 * and so always runs with an elevated notifier count.  This obviates
+	 * the need to bump the sequence count.
+	 */
+	WARN_ON_ONCE(!kvm->mmu_notifier_count);
+
 	idx = srcu_read_lock(&kvm->srcu);
 
 	KVM_MMU_LOCK(kvm);
 
-	kvm->mmu_notifier_seq++;
-
 	if (kvm_set_spte_hva(kvm, address, pte))
 		kvm_flush_remote_tlbs(kvm);
 
-- 
2.31.0.208.g409f899ff0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
