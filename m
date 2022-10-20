Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 102C9C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 09:16:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF9294B974;
	Thu, 20 Oct 2022 05:16:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e2z6Amozriw0; Thu, 20 Oct 2022 05:16:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 999D94B942;
	Thu, 20 Oct 2022 05:16:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 078924B946
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1QejOe-AuWtB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 05:16:40 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FD114B8D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2A779B82682;
 Thu, 20 Oct 2022 09:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC131C433D7;
 Thu, 20 Oct 2022 09:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666257396;
 bh=Kh7rAMQF4Hxlrt7iAoagQjYOHX+yuNkIyncSWSxab3w=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=o4+OWsb3VlGPdt96pGsmVB/lCLUEcZjeGH3kzM9Kf3zI+CXIUp2fXUka5ZaV/bpts
 75uYN510E8e5qqicwO1E4M3l74e8Uhi5k2p1Vc5GqZ+sR7HzBURKY5zjymQdgqZht5
 xrchs+7s7bK7mYKzwlpFAFBnbPeVJq8XdWSBxWLxYl+mp2wsA6UXOUSQxw08T+kKOr
 a0V8jBmQuOYp4yX6EqT0UnW3FWg98gIdd3+Iece32NGbbsPX51CLcfrsi5gwaH1F9k
 kohB/Juwp5avonJL0aG4l4ZK27EMkYHeVECaCfQA0HSbv8wTPmiuv8eP6wdD5JMejn
 lBdMQz/4rlPXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1olRWb-000Buf-Jw;
 Thu, 20 Oct 2022 10:07:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/17] KVM: arm64: Adjust EL2 stage-1 leaf AP bits when
 ARM64_KVM_HVHE is set
Date: Thu, 20 Oct 2022 10:07:22 +0100
Message-Id: <20221020090727.3669908-13-maz@kernel.org>
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

El2 stage-1 page-table format is subtly (and annoyingly) different
when HCR_EL2.E2H is set.

Take the ARM64_KVM_HVHE configuration into account when setting
the AP bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index cdf8e76b0be1..50caaf735f52 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -21,8 +21,10 @@
 
 #define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
 #define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO		\
+	({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 2 : 3; })
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW		\
+	({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 0 : 1; })
 #define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
 #define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
 #define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
