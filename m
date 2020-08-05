Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43440C433DF
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E7A6222D05
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZjM14aqy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7A6222D05
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F254B4BA;
	Wed,  5 Aug 2020 14:26:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jd3rliw4n0eA; Wed,  5 Aug 2020 14:26:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94C794B57C;
	Wed,  5 Aug 2020 14:26:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9BA64B4BA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iXnY5yqEHnN6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:26:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F99B4B5A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:04 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9675F22CF7;
 Wed,  5 Aug 2020 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596651963;
 bh=wWb5P2mM2VHVjg44eg8vt1OdSOFdGlD9psq1EEKpMEA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZjM14aqyHfo09RtEYMSLPu0D+fP6m15iMK+fDhm83ZhvwIw6hGyXhEfjYAByhvFta
 znlRCGvss//JFdRqTb4mwZMfnjqxZPXD3NOXUNaI+RExOVYb3NNbq+y74AKdyNe3R+
 BAs9EyFCFrc/u6p4Z99MZa+kr9bNFtuHtzmsJuhY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3Nfy-0004w9-DT; Wed, 05 Aug 2020 18:58:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 49/56] KVM: arm64: Make nVHE ASLR conditional on RANDOMIZE_BASE
Date: Wed,  5 Aug 2020 18:56:53 +0100
Message-Id: <20200805175700.62775-50-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
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

From: David Brazdil <dbrazdil@google.com>

If there are spare bits in non-VHE hyp VA, KVM unconditionally replaces them
with a random tag chosen at init. Disable this if the kernel is built without
RANDOMIZE_BASE to align with kernel behavior.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200721094445.82184-2-dbrazdil@google.com
---
 arch/arm64/kvm/va_layout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index a4f48c1ac28c..e0404bcab019 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -48,7 +48,7 @@ __init void kvm_compute_layout(void)
 	va_mask = GENMASK_ULL(tag_lsb - 1, 0);
 	tag_val = hyp_va_msb;
 
-	if (tag_lsb != (vabits_actual - 1)) {
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (vabits_actual - 1)) {
 		/* We have some free bits to insert a random tag. */
 		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
 	}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
