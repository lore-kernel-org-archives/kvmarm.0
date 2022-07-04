Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C55C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 07:21:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 581924C074;
	Wed,  6 Jul 2022 03:21:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bOwnH3YrnOi7; Wed,  6 Jul 2022 03:21:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA81E4C063;
	Wed,  6 Jul 2022 03:21:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 846FE4BDCE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jul 2022 15:10:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cCpZ7f17CuLs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jul 2022 15:10:14 -0400 (EDT)
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr
 [80.12.242.127])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2B2E4BCA9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jul 2022 15:10:13 -0400 (EDT)
Received: from pop-os.home ([90.11.190.129]) by smtp.orange.fr with ESMTPA
 id 8RSToSo9rZDzU8RSToUB9C; Mon, 04 Jul 2022 21:10:12 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 04 Jul 2022 21:10:12 +0200
X-ME-IP: 90.11.190.129
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: Use the bitmap API to allocate bitmaps
Date: Mon,  4 Jul 2022 21:10:08 +0200
Message-Id: <a93d3e94be2003922c7e9652b57e96261cc47641.1656961792.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 06 Jul 2022 03:21:23 -0400
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

While at it, turn a bitmap_clear() into an equivalent bitmap_zero(). It is
also less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 arch/arm64/kvm/vmid.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index d78ae63d7c15..f4612cdb60ff 100644
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -47,7 +47,7 @@ static void flush_context(void)
 	int cpu;
 	u64 vmid;
 
-	bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
+	bitmap_zero(vmid_map, NUM_USER_VMIDS);
 
 	for_each_possible_cpu(cpu) {
 		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
@@ -182,8 +182,7 @@ int kvm_arm_vmid_alloc_init(void)
 	 */
 	WARN_ON(NUM_USER_VMIDS - 1 <= num_possible_cpus());
 	atomic64_set(&vmid_generation, VMID_FIRST_VERSION);
-	vmid_map = kcalloc(BITS_TO_LONGS(NUM_USER_VMIDS),
-			   sizeof(*vmid_map), GFP_KERNEL);
+	vmid_map = bitmap_zalloc(NUM_USER_VMIDS, GFP_KERNEL);
 	if (!vmid_map)
 		return -ENOMEM;
 
@@ -192,5 +191,5 @@ int kvm_arm_vmid_alloc_init(void)
 
 void kvm_arm_vmid_alloc_free(void)
 {
-	kfree(vmid_map);
+	bitmap_free(vmid_map);
 }
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
