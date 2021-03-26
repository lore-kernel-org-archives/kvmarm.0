Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90393C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35B1961A21
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35B1961A21
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3634B45C;
	Fri, 26 Mar 2021 09:54:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tQQFhaTjJ7js; Fri, 26 Mar 2021 09:54:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 074D04B4BC;
	Fri, 26 Mar 2021 09:54:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4661D4B1E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rrnkU+LuI-Tf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:27 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 652614B1F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:27 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id v18so4459577qtx.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=6DC92nb/KI7jWYCp6JOuoACO+r7yp8IjmJZ11jFmVcc=;
 b=JbUTKZPl/W/MrrvWQUZUwB6/PNz+uprjL43QoBtU1wD/mAej30Q8jYby+47AHKHhaD
 qBqEBSQiu2bEr1qfUHbwQYlI6gWDl4chgn5S8D90qIehLlVx/nchC3vJJMtesz8zy8/Y
 M1LbviODPL1MGWHOIgE4Z5dpFy6id4wLzGJaHGzRuSpy/ZC1eQarGzMJCuDST+iapHDq
 hqHQp6qA6x7NQdKxbbnSJd/iB8Dkv/td88Lb87UdQ6D804kTiRc9d9Vha8oDU/N1jtA7
 3mxTxHygoTzC20DEx3ttGZ8pl2+fGX8Q1O74BGCQbeoumy93ZYjiqrVLI4BWvrM36iOI
 OzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=6DC92nb/KI7jWYCp6JOuoACO+r7yp8IjmJZ11jFmVcc=;
 b=j+Wse+W1ll5TMXB5tyVaqHvCfRCR7iAP/BLl3EJYaopL44TvB/BQLPSmaSVyal9prc
 TnEXRH+jeJD3y+xhhssHq18YpCk2eDPouCvWTlvaaOcibVvsIBRkOLmlJl7jPlb14i4v
 bLp639khHGqZFRDCvVUqRt3oe8PnVQ7XUCI2qpxTV45b0TSCgkO6YSGL71ihI+J82Pu/
 mvoY5PuUUje+aWA+lA23kj3e+SvzMxVzUgfZtlla26ueflVhhoehvTsfnbBhuJl0qKs+
 qZmceqXPi47YfaECpaSCQw4cJYAq4LBqHpeQpIgBJSm+93mVd7Qfn2aQK9JYGvnRRS4/
 3l0A==
X-Gm-Message-State: AOAM53352pwJ4z5Ru5vxOMnGK+xFGgSQ7LZbzO4mIHo2313Ps+oF+aJ6
 aQy7PDvMJrVeZeiFW/a2AA3h7ofUy5Y=
X-Google-Smtp-Source: ABdhPJxJS3G4Tp3oACq1aE0Kk13Vb4BteCkja1S5xuHowEheSpbEGJ6yFi11Vc4ofL1uuJo1KA/BTZTheoY=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:ad4:5812:: with SMTP id
 dd18mr10836929qvb.7.1616725226899; 
 Thu, 25 Mar 2021 19:20:26 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:46 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 07/18] KVM: x86/mmu: Use leaf-only loop for walking TDP SPTEs
 when changing SPTE
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 26 Mar 2021 09:54:23 -0400
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

Use the leaf-only TDP iterator when changing the SPTE in reaction to a
MMU notifier.  Practically speaking, this is a nop since the guts of the
loop explicitly looks for 4k SPTEs, which are always leaf SPTEs.  Switch
the iterator to match age_gfn_range() and test_age_gfn() so that a future
patch can consolidate the core iterating logic.

No real functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7fe5004b1565..a2b3d9699320 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1042,7 +1042,7 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	new_pfn = pte_pfn(*ptep);
 
-	tdp_root_for_each_pte(iter, root, gfn, gfn + 1) {
+	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
 		if (iter.level != PG_LEVEL_4K)
 			continue;
 
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
