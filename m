Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72869C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:01:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A39C20814
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1eWTrAjr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A39C20814
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E594B29C;
	Fri, 29 May 2020 12:01:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0wZAEIfvjT0n; Fri, 29 May 2020 12:01:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85ECD4B2C1;
	Fri, 29 May 2020 12:01:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AE644B1F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:01:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RV2EC49wYzY0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 12:01:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26E5A4B282
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:01:48 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5A34A21475;
 Fri, 29 May 2020 16:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590768107;
 bh=AcbWpu2QzTsPlhf5TBTGn04PSLgi53DNyTEyXgNuJp8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=1eWTrAjr67oCnpndgRkN8/x6dx5LMdNQF1ZeiGF0YLLttwMqBjTUyHZPanvrP8vTX
 r4ARB/YfvxlAJVvFlGhIQI2saFOYczaoK14iXGI8WZNk7WcJx2FBBvzglLrc2Bdoku
 mBSeGXqDUP9pxwJJFY3/KvMHBhBQNxrmfF8Yy4Dc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jehS5-00GJKc-Fq; Fri, 29 May 2020 17:01:45 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 07/24] KVM: arm64: Use cpus_have_final_cap for has_vhe()
Date: Fri, 29 May 2020 17:01:04 +0100
Message-Id: <20200529160121.899083-8-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com,
 dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com,
 zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Jiang Yi <giangyi@amazon.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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

By the time we start using the has_vhe() helper, we have long
discovered whether we are running VHE or not. It thus makes
sense to use cpus_have_final_cap() instead of cpus_have_const_cap(),
which leads to a small text size reduction.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>
Link: https://lore.kernel.org/r/20200513103828.74580-1-maz@kernel.org
---
 arch/arm64/include/asm/virt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 61fd26752adc..5051b388c654 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -85,7 +85,7 @@ static inline bool is_kernel_in_hyp_mode(void)
 
 static __always_inline bool has_vhe(void)
 {
-	if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
+	if (cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN))
 		return true;
 
 	return false;
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
