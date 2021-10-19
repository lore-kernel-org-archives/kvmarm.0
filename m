Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384CCC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE68161372
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DE68161372
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 813D34B186;
	Tue, 19 Oct 2021 08:13:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wtZuSMOCTU9m; Tue, 19 Oct 2021 08:13:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 187404B133;
	Tue, 19 Oct 2021 08:13:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D07BF4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eQ08jh4i+0cE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:18 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E28CC4B12E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:16 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 f1-20020a5d64c1000000b001611832aefeso10100317wri.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=++xVX7cq9dri2+SFZW5WIc0fF/Kl7wWBtgdSK2pMHEw=;
 b=YfeNcGEPdATddU+z3YnUUEeQ58+n/htJaUr7pcFV0pLA8xf8N3BummwMBtbl3EkXsd
 5k5yC2YGf2i6gvmE+RzgT0nkae5+wdy/qpTCYJ2RFzC+k0trTK9gggZpZpt8KAEIh0Fa
 ewhY3rYjID7F6W3V0jeBklt1ck6TqnAD2uCqaZ2EjRpP12OowyDJSEC/xSOu6LMRgjju
 4IcUs8iFs92golKvI4zYNg+BTy+L8nK5+HfpFxA9z/rdh4Gg4waWf2oAdnC8KUoxp8N9
 LhGqQkkyjCCBEo5f856TkfoeG0dIh52NHjH5Jedm2jt+9zDWLyDLl2hgbw60pjmTfn+n
 0NYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=++xVX7cq9dri2+SFZW5WIc0fF/Kl7wWBtgdSK2pMHEw=;
 b=O2odfpqcjaLexTTAMSb3iVONpC804Q/iKAq4+MohjF/inOILH7w2o7el5Mwy4JUbFM
 NTXjIswmc8SO8zqTKgtjwZ6apDn1h1uSBINZjZ3U4Ia77KICchuREE4H7C/JeIFe/xod
 PXBB38l2CGVM/pa8ja+K4A5h+HogdySvlzsIQ4PCvUQYuec2UfTIXaFdDrw1k7dL9TUF
 Pp1rGYJbp++5uK89lG5xGlVfDQaqrVw5I4/Jy2B/ISEMn7/SHpVOmiQF72VXVbesgR3c
 H71jRO4i20G6A0aCxy/SOKHdfi0mJf1N0+biGv4fdnXqmcIdtWlpgsma81WYP3pmIlV8
 R1pQ==
X-Gm-Message-State: AOAM530irbBqkfvSrYu4e9zb32ZcguloIWxIWXgaY/82mYF8t17yqMMz
 UDoy74bYQKCElI02MtztpVqk4UwQO7jC
X-Google-Smtp-Source: ABdhPJyUp2THf2vqTs2t6aOxbzWJ1ZyfKwGpN2QbKlKxK+/isqHvkyIyOmDTVZPJdG4S62oIcZFlzqHeLYBK
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:adf:b1d4:: with SMTP id
 r20mr43489909wra.308.1634645596136; Tue, 19 Oct 2021 05:13:16 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:53 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-5-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 04/15] KVM: arm64: Fixup hyp stage-1 refcount
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

In nVHE-protected mode, the hyp stage-1 page-table refcount is broken
due to the lack of refcount support in the early allocator. Fix-up the
refcount in the finalize walker, once the 'hyp_vmemmap' is up and running.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 862c7b514e20..9e5c92237a51 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -167,12 +167,22 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 {
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	kvm_pte_t pte = *ptep;
 	phys_addr_t phys;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
 
+	/*
+	 * Fix-up the refcount for the page-table pages as the early allocator
+	 * was unable to access the hyp_vmemmap and so the buddy allocator has
+	 * initialised the refcount to '1'.
+	 */
+	mm_ops->get_page(ptep);
+	if (flag != KVM_PGTABLE_WALK_LEAF)
+		return 0;
+
 	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
@@ -205,7 +215,8 @@ static int finalize_host_mappings(void)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= finalize_host_mappings_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pkvm_pgtable.mm_ops,
 	};
 
 	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
@@ -230,19 +241,19 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = finalize_host_mappings();
-	if (ret)
-		goto out;
-
 	pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
-		.zalloc_page = hyp_zalloc_hyp_page,
-		.phys_to_virt = hyp_phys_to_virt,
-		.virt_to_phys = hyp_virt_to_phys,
-		.get_page = hpool_get_page,
-		.put_page = hpool_put_page,
+		.zalloc_page	= hyp_zalloc_hyp_page,
+		.phys_to_virt	= hyp_phys_to_virt,
+		.virt_to_phys	= hyp_virt_to_phys,
+		.get_page	= hpool_get_page,
+		.put_page	= hpool_put_page,
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
+	ret = finalize_host_mappings();
+	if (ret)
+		goto out;
+
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
