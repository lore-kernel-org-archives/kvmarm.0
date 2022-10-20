Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCA6C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 09:16:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D7264B994;
	Thu, 20 Oct 2022 05:16:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O4CG4UtL6yYb; Thu, 20 Oct 2022 05:16:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23A024B974;
	Thu, 20 Oct 2022 05:16:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A8B4B943
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WPzg76mXD6lM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 05:16:49 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFAE84B979
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:48 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id EE3EDB82682;
 Thu, 20 Oct 2022 09:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2802C433C1;
 Thu, 20 Oct 2022 09:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666257406;
 bh=3tbOfP787ivANekjOpi0D+lzmeYXSesKC2n+sLbSetQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tmp9gTo1hdSKd8xa/Cb4CnZj4NfRTUvH93BSsSvZM+UeGmtVcuCX7T2lRtTTWwMMX
 O9OuS9WUHXGOv7LgGvPwf9F59FHLbsCGWM++xfNo00bS/JkWxp/jdpItRAt6TaTq06
 JNb0vvi6whYfO0vHJ20B8CAiwuZFy9t+3gf8OuCmlo4MqyuV8+8xwGT9tjvifIVmBp
 bRfyZeLObwa69MxkxXYb3MOBXBBjvq4M/u6+J7RtNQNSzP67KOV1ACD+Dxa/7my430
 aA8dlX6id4K0aeTON7QOQlhdQ3DmL8gHxbWcuSgbcyEvQBOX8VPpb42yhtORk1LJXt
 Pq/xvllZwECkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1olRWb-000Buf-3W;
 Thu, 20 Oct 2022 10:07:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/17] KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
Date: Thu, 20 Oct 2022 10:07:20 +0100
Message-Id: <20221020090727.3669908-11-maz@kernel.org>
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

Obviously, in order to be able to use VHE whilst at EL2, we need
to set HCR_EL2.E2H. Do so when ARM64_KVM_HVHE is set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..85df7ce0b051 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1558,6 +1558,8 @@ static void cpu_prepare_hyp_mode(int cpu)
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
 		params->hcr_el2 = HCR_HOST_NVHE_FLAGS;
+	if (cpus_have_final_cap(ARM64_KVM_HVHE))
+		params->hcr_el2 |= HCR_E2H;
 	params->vttbr = params->vtcr = 0;
 
 	/*
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
