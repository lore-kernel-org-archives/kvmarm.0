Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649ABC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 09:07:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 129D94B954;
	Thu, 20 Oct 2022 05:07:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2zwD5ypXtWMr; Thu, 20 Oct 2022 05:07:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 583F94B953;
	Thu, 20 Oct 2022 05:07:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8A84B940
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:07:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZQXEz7lfC4K9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 05:07:40 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF05F4B94D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:07:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E3180B826AF;
 Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FABC43140;
 Thu, 20 Oct 2022 09:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666256857;
 bh=L1c/+tFZZRhijg30lPPqIBaHqiyb70GwjjA7yQE8RbU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kdHjbnJxE1vsadwz99+FDtf+3bDvjYIypzkkG++XKlx5pC2sCEgLZWVGpRaO+deYE
 rDw2gXsPIO8OXFey6/zSQOejSCNiPwJ274Olia2ILnPtQrx5d8F76hAJSTs2W+pynX
 W/fCe+UDInZhlj/JnXY5oVDVtv3rPMv8lU128yqTn5DqxqF+8y/PCItcN9mG49MrNl
 aCH+r4AGlo1cPKUof1+CeExDOlUAJR47D/5QHHzkjpd1Epx18yhDTMVdH0xuUNRQut
 nt1Xl0+/tVdaedjuNmV9uBWxjr7Dy9cv9bZhD/exzmF+zv5l9HtZCe58h0IEjyHgeN
 17JzpXPpLoMow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1olRWZ-000Buf-Id;
 Thu, 20 Oct 2022 10:07:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/17] arm64: Prevent the use of is_kernel_in_hyp_mode() in
 hypervisor code
Date: Thu, 20 Oct 2022 10:07:14 +0100
Message-Id: <20221020090727.3669908-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>
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

Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
mistake. This helper only checks for CurrentEL being EL2, which
is always true.

Make the link fail if using the helper in hypervisor context
by referencing a non-existent function. Whilst we're at it,
flag the helper as __always_inline, which it really should be.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/virt.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index b11a1c8c8b36..5f84a87a6a2d 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -110,8 +110,13 @@ static inline bool is_hyp_mode_mismatched(void)
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 
-static inline bool is_kernel_in_hyp_mode(void)
+extern void gotcha_is_kernel_in_hyp_mode(void);
+
+static __always_inline bool is_kernel_in_hyp_mode(void)
 {
+#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
+	gotcha_is_kernel_in_hyp_mode();
+#endif
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
