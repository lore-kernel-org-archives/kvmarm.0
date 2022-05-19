Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D468FC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FA074B360;
	Thu, 19 May 2022 09:44:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ub8AtO15Zg3; Thu, 19 May 2022 09:44:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79D394B28D;
	Thu, 19 May 2022 09:44:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C96E4B28D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v9q0E1IMYlnm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:54 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 222D94B3EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:54 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4D9B8B824B0;
 Thu, 19 May 2022 13:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA86C34117;
 Thu, 19 May 2022 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967892;
 bh=uJnqJPwMR6L3zu0hKzCa6M5X1lVNf2v8m3jLNKMqNM4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=R0497BzDPARsmIUjvgx2EZejin+P6ZOTLPa81aUHW0q8FvPtUJP3LpWcU5PBUgbsP
 1rTwT+sJjD87VWB+U3bJ2FlpMn5iMvHaasaeqjlHOG6BTz6R2Dkx1BTXTjflDPt5vD
 EbLuhQG5UZCHhie+rj+6NSAqo+vGrYiysbTw1lpwerRIFeIU4Rue5txCLlp7ygUKo3
 1sXAkTbYjJqhpkF+K7h4MsO51v8LylExPcfY1OC59B4TbCaYuIWZUQcbHfD2DpPhNm
 KbuRo2ggObmCIdukL1p+Yw7hNwXkF0voQUCYz8ZNWanYj6WZYUNCZAJqovOrQdiVGe
 2BmAIjL0MlR/w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 37/89] KVM: arm64: Explicitly map kvm_vgic_global_state at EL2
Date: Thu, 19 May 2022 14:41:12 +0100
Message-Id: <20220519134204.5379-38-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

The pkvm hypervisor may need to read the kvm_vgic_global_state variable
at EL2. Make sure to explicitly map it in its stage-1 page-table rather
than relying on mapping all of the host .rodata section.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 59a478dde533..a851de624074 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -136,6 +136,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
+	ret = pkvm_create_mappings(&kvm_vgic_global_state,
+				   &kvm_vgic_global_state + 1, prot);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
