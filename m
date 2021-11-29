Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B3BC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:02:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E274B120;
	Mon, 29 Nov 2021 15:02:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sHcnaUADKklu; Mon, 29 Nov 2021 15:02:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A01304B12E;
	Mon, 29 Nov 2021 15:02:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9B404B102
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:02:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dTDw+8KZjTVK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:02:19 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16DC94B0E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:02:17 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id D1CCECE140D;
 Mon, 29 Nov 2021 20:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B93C53FD2;
 Mon, 29 Nov 2021 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216132;
 bh=r1KVpSR7EgIPE8I4/GpAKDCPw+V3aHcPhm5guWg0kK0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=cLEypiGX/Kz7h6mdeCJwpUhz3LiCZn0KCrGZ3Fpyr5abbPxTc2I8Pf4KvWMXQJWCw
 OXxCmvjqPrli5MqoRrySZ1QypS3IXkjIs6ztJzUQ3mNES7SAPaFhRE1Z/AOxNPf41X
 /fgnIDRmYqDs4P5N8eow/MN7uxtwRjXLZ0wKQ6J9ZumwVzNhLOWxHiTMTpt4LnGUk0
 /GRnEzmsZuZdvJgFMXLZQ9i3p8l1t4qXwt+DeZjICcLEdveIOARaro9XT35uaZ0qM2
 McAWtybaxeqOaid4Qi2BfLFDMa5qV1Hq78ygJ4BAx81MaefY+cJhlcdggKTrEgOOyy
 VDgT3pL391XdQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmqo-008gvR-NI; Mon, 29 Nov 2021 20:02:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 05/69] KVM: arm64: Allow preservation of the S2 SW bits
Date: Mon, 29 Nov 2021 20:00:46 +0000
Message-Id: <20211129200150.351436-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

The S2 page table code has a limited use the SW bits, but we are about
to need them to encode some guest Stage-2 information (its mapping size
in the form of the TTL encoding).

Propagate the SW bits specified by the caller, and store them into
the corresponding entry.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 8cdbc43fa651..d69e400b2de6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1064,9 +1064,6 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	u32 level;
 	kvm_pte_t set = 0, clr = 0;
 
-	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
-		return -EINVAL;
-
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
@@ -1076,6 +1073,10 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
+	/* Always propagate the SW bits */
+	clr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_SW, 0xf);
+	set |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
+
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
 	if (!ret)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
