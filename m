Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522CBC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 04:44:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A979664FBE
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 04:44:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A979664FBE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0835E4B32F;
	Thu,  4 Feb 2021 23:44:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JAPuhUiM2LxK; Thu,  4 Feb 2021 23:44:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0CC24B328;
	Thu,  4 Feb 2021 23:44:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D5F24B324
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 23:44:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XC4OKrriNDig for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 23:44:28 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C0F74B321
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 23:44:28 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id n81so5618573ybg.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 20:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=mqWmHE42/s6gPzA1fc3dXOQLiShFY7rWgRdN3hlvQ18=;
 b=hax7z/8UE7eZAIWp0UejZmLvujb5KTav5ZdQIa98ezLBgkdf+Fmn1wKiME3VcuhVrh
 nRUxi+UauhUqxrGn4Eish8jqPVoIpsxcakgB6hR2lTbk3XunWKW7ZRcVjxbAWbGI5327
 H8CvvtRBNoszyhkjsq8y2SfvOX9MXipyKJvCH61+0IErKragiNP+k48mZ3iPn2gOme3Y
 hU+kjxT1lwSgrHulrS97JdvpDIZNWJOD0Qo7fadDAbiCG5Zuxnni26gPFWkTRB94bdzu
 oRmD/7aJViFnUF5Bt1sf4ArPKvRCu5o7A3bN/6hOqtX0Cw5iCF1LEBZOeZnsWlfwD7rM
 zsPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=mqWmHE42/s6gPzA1fc3dXOQLiShFY7rWgRdN3hlvQ18=;
 b=aLuiNCAJfYBvc+Po4moKN0Rxf3nnVmqN5lWp2YDoBB5wAhCD6QZY/QJt1fJcqfsMYe
 hxgu3sdKf5W1Oyrtb6554AaTlstvqVja1BxFaxyj5wxLNxgz7rlYg/5D9s/CFFrgj2Qo
 BSY9bkpbb1a6jdJYAhmGPmxoh6XotBFv9b6qo3kKvQVEnWaXePGP9muFqJjpSue/gq/a
 utRw1G8hk/x/TyxT4S5taUrFfzUlIrE/HXAmAT93U5h8C2bPM3WeqO+igiy0Z5/3G8rW
 Zfh2X9jVge6ecFKDn/P/kyuyQ21K2cO1/aJDvVX8DJJUBsvA4IICyhocJQkwpstsPMfx
 Q+og==
X-Gm-Message-State: AOAM5319NCxa0bXtAWsN3+i6cldZXj1HJvV8Cn0PO0leVbTXAUUm8Lq0
 cfFQ69E4elPxm6OjDkPGP92vegHzizLhg/Yu8g==
X-Google-Smtp-Source: ABdhPJwIpU1qgfHhoXG1v93Qd2i7DjQh2/0OMsvbT7B2NZVoUqIJ5eo00+aW3Cf7tVTPwL6oZWGpXQ6hd/koHi/9ow==
X-Received: from jingzhangos.c.googlers.com
 ([fda3:e722:ac3:10:2b:ff92:c0a8:513])
 (user=jingzhangos job=sendgmr) by 2002:a25:bec2:: with SMTP id
 k2mr4013508ybm.42.1612500267530; Thu, 04 Feb 2021 20:44:27 -0800 (PST)
Date: Fri,  5 Feb 2021 04:44:03 +0000
Message-Id: <20210205044403.1559010-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH] KVM: arm64: Remove redundant check for S2FWB
From: Jing Zhang <jingzhangos@google.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, 
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, 
 qperret@google.com
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

Remove redundant check for CPU feature S2FWB in dcache flush code
to save some CPU cycles for every memslot flush and unmapping.
And move the S2FWB check to outer functions to avoid future
redundancy and keep consistent with other usage like in
access_dcsw and kvm_arch_prepare_memory_region.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 9 ++-------
 arch/arm64/kvm/mmu.c         | 3 ++-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdf8e55ed308..afd57564b1cb 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -642,9 +642,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 
 static void stage2_flush_dcache(void *addr, u64 size)
 {
-	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		return;
-
 	__flush_dcache_area(addr, size);
 }
 
@@ -670,7 +667,8 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 		if (page_count(virt_to_page(childp)) != 1)
 			return 0;
-	} else if (stage2_pte_cacheable(pte)) {
+	} else if (stage2_pte_cacheable(pte) &&
+			!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
 		need_flush = true;
 	}
 
@@ -846,9 +844,6 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
 
-	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		return 0;
-
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..53130ed23304 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1458,7 +1458,8 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 	 * If switching it off, need to clean the caches.
 	 * Clean + invalidate does the trick always.
 	 */
-	if (now_enabled != was_enabled)
+	if (now_enabled != was_enabled &&
+			!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
 		stage2_flush_vm(vcpu->kvm);
 
 	/* Caches are now on, stop trapping VM ops (until a S/W op) */

base-commit: a8ac864a7d6dbc2fc43081b1eecd9e0183065d47
-- 
2.30.0.365.g02bc693789-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
