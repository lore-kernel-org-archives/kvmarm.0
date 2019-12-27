Return-Path: <SRS0=/1aR=2R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AA8C2D0C6
	for <kvmarm@archiver.kernel.org>; Fri, 27 Dec 2019 11:48:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A38320828
	for <kvmarm@archiver.kernel.org>; Fri, 27 Dec 2019 11:48:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="t6Hr7CtJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A38320828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 746F44A4DF;
	Fri, 27 Dec 2019 06:48:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QfeSDMzqoXv8; Fri, 27 Dec 2019 06:48:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF6F4A4FF;
	Fri, 27 Dec 2019 06:48:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C4E04A4A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Dec 2019 06:48:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DYFL76udIL0i for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Dec 2019 06:47:51 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C57494A36B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Dec 2019 06:47:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
 Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
 :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
 Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
 List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=hCGKPCoMaBS4IBTKip826fdUigXOuuWSTAZw407pK+E=; b=t6Hr7CtJ5GxkzmWdnl1k84Jl7b
 MvtXZJk3A5dXUjofSV6mLR6qLbu6TYzV89ccuNyDyZvFXOA+XvjoZr2XNjvP6LkBWEk11dH2D4Egg
 s/9robREO6RCMaTsCMR9tgNY2VPCfVrDCO0UtgWcvjsisaSbsDanhA5RFwU9/KsjwtDEVDXDALNnh
 X6FxhRLjTJdChZR2eYvZxJsXlc7S0lUyUcXPtyci3aZY7wRRencDR6hVhO7KylFlBZForJL7k4VP6
 PiYrKkafKtsAXNe+xkfFraq2XlmmTQl5ZxfMoUwyApc5J/X2nIDdngfBMdwTDaV97zWAl7v69G4nH
 kItNfyFg==;
Received: from e0022681537dd.dyn.armlinux.org.uk
 ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:46184 helo=rmk-PC.armlinux.org.uk)
 by pandora.armlinux.org.uk with esmtpsa
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <rmk@armlinux.org.uk>)
 id 1iko5g-000199-Mj; Fri, 27 Dec 2019 11:47:36 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
 (envelope-from <rmk@armlinux.org.uk>)
 id 1iko5f-0000z2-Tx; Fri, 27 Dec 2019 11:47:35 +0000
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] arm64: kvm: fix IDMAP overlap with HYP VA
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <E1iko5f-0000z2-Tx@rmk-PC.armlinux.org.uk>
Date: Fri, 27 Dec 2019 11:47:35 +0000
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Booting 5.4 on LX2160A reveals that KVM is non-functional:

kvm: Limiting the IPA size due to kernel Virtual Address limit
kvm [1]: IPA Size Limit: 43bits
kvm [1]: IDMAP intersecting with HYP VA, unable to continue
kvm [1]: error initializing Hyp mode: -22

Debugging shows:

kvm [1]: IDMAP page: 81a26000
kvm [1]: HYP VA range: 0:22ffffffff

as RAM is located at:

80000000-fbdfffff : System RAM
2080000000-237fffffff : System RAM

Comparing this with the same kernel on Armada 8040 shows:

kvm: Limiting the IPA size due to kernel Virtual Address limit
kvm [1]: IPA Size Limit: 43bits
kvm [1]: IDMAP page: 2a26000
kvm [1]: HYP VA range: 4800000000:493fffffff
...
kvm [1]: Hyp mode initialized successfully

which indicates that hyp_va_msb is set, and is always set to the
opposite value of the idmap page to avoid the overlap. This does not
happen with the LX2160A.

Further debugging shows vabits_actual = 39, kva_msb = 38 on LX2160A and
kva_msb = 33 on Armada 8040. Looking at the bit layout of the HYP VA,
there is still one bit available for hyp_va_msb. Set this bit
appropriately. This allows kvm to be functional on the LX2160A, but
without any HYP VA randomisation:

kvm: Limiting the IPA size due to kernel Virtual Address limit
kvm [1]: IPA Size Limit: 43bits
kvm [1]: IDMAP page: 81a24000
kvm [1]: HYP VA range: 4000000000:62ffffffff
...
kvm [1]: Hyp mode initialized successfully

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm64/kvm/va_layout.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 2cf7d4b606c3..83f8b3f51cf4 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -22,6 +22,17 @@ static u8 tag_lsb;
 static u64 tag_val;
 static u64 va_mask;
 
+/*
+ * We want to generate a hyp VA with the following format:
+ *
+ *  63 ... V |     V-1    | V-2 .. tag_lsb | tag_lsb - 1 .. 0
+ *  ---------------------------------------------------------
+ * | 0000000 | hyp_va_msb |    random tag  |  kern linear VA |
+ *
+ * which does not conflict with the idmap regions. This means that hyp_va_msb
+ * must always be present. Luckily, when kva_msb == (vabits_actual - 1) we
+ * still have one bit for this, but no bits for the random tag.
+ */
 static void compute_layout(void)
 {
 	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
@@ -39,19 +50,16 @@ static void compute_layout(void)
 		/*
 		 * No space in the address, let's compute the mask so
 		 * that it covers (vabits_actual - 1) bits, and the region
-		 * bit. The tag stays set to zero.
+		 * bit.
 		 */
-		va_mask  = BIT(vabits_actual - 1) - 1;
-		va_mask |= hyp_va_msb;
+		tag_lsb = kva_msb;
+		va_mask = BIT(vabits_actual - 1) - 1;
+		tag_val = hyp_va_msb >> tag_lsb;
 	} else {
 		/*
 		 * We do have some free bits to insert a random tag.
 		 * Hyp VAs are now created from kernel linear map VAs
 		 * using the following formula (with V == vabits_actual):
-		 *
-		 *  63 ... V |     V-1    | V-2 .. tag_lsb | tag_lsb - 1 .. 0
-		 *  ---------------------------------------------------------
-		 * | 0000000 | hyp_va_msb |    random tag  |  kern linear VA |
 		 */
 		tag_lsb = kva_msb;
 		va_mask = GENMASK_ULL(tag_lsb - 1, 0);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
