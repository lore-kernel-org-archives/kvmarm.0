Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3F0C43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:12:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3484B397;
	Thu,  9 Jun 2022 08:12:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ohmq7Zg9hbp6; Thu,  9 Jun 2022 08:12:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 248E14B39E;
	Thu,  9 Jun 2022 08:12:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6851E4B3A4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BzVqBIGjQrH7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 08:12:43 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1DE04B3ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:42 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E3F56B82D32;
 Thu,  9 Jun 2022 12:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593E9C3411F;
 Thu,  9 Jun 2022 12:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654776760;
 bh=mF0MZDnz8qQHCl3wYfr445Mxu4221ivldNZ8SHrMvCU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=FaDVmvOcm/v9Q+F0wG3RtCAL1CvVQyYMFIU19KlSoFOfFIt77LbWOj1rhr6P1BiPT
 0P9xesgFm12thHY/tmMAPX2E8CXaDc0ieSLDpv1+/2gpK4QTWL/7SCIHsj9AD6gIv8
 24EcOaFP4wBtA+Ee4o3gme2vh1K+f2Zv5mGPR27+rvrla4fDAPYXdGxHT4D+9AzATu
 h6vSR/VFRSrtbDf/QsKk8oNQRZaFNUitG5CZjmVyI/k2ktQPRmRBhJi6Lf3UUM8hqr
 uAcvXuqzphgiAa80eZSKvv3Kcu7Jc1bjUTAq8AoNCrQlHKZdR5uGlejjx7AIAjTNge
 JDBV3dA/DkQow==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 6/6] KVM: arm64: Drop stale comment
Date: Thu,  9 Jun 2022 13:12:23 +0100
Message-Id: <20220609121223.2551-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220609121223.2551-1-will@kernel.org>
References: <20220609121223.2551-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

From: Marc Zyngier <maz@kernel.org>

The layout of 'struct kvm_vcpu_arch' has evolved significantly since
the initial port of KVM/arm64, so remove the stale comment suggesting
that a prefix of the structure is used exclusively from assembly code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 47a1e25e25bb..de32152cea04 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -362,11 +362,6 @@ struct kvm_vcpu_arch {
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
 
-	/*
-	 * Anything that is not used directly from assembly code goes
-	 * here.
-	 */
-
 	/*
 	 * Guest registers we preserve during guest debugging.
 	 *
-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
