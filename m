Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB60BC47082
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46683613DC
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46683613DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD2E54B0AC;
	Thu,  3 Jun 2021 14:34:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F8ezOVrULjzg; Thu,  3 Jun 2021 14:34:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E814B0E7;
	Thu,  3 Jun 2021 14:34:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 958224B10C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:34:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MgHG3nwfEitT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 14:34:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B817D4B108
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:34:03 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F2C8613B8;
 Thu,  3 Jun 2021 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1622745242;
 bh=osyrOd8rLcVCMiPHAeJKLzTGdMUBbbPPNLLfrYOVNtE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fOt+VKmNu2qb7NlmlC8F8f7NZks31mqaTKoFAcQTxTnnIZsP99bm4KVUW3Fy5BRvN
 k2jFjdJeC1Ex6aXIlzQTS6Z+2nmuqbXQ5BCBEDUFJ2hXtvBa2kF4PGG8m6Ug2xCo0Q
 2mkPnUbq1g9fcBSTNR1e0d8gzL2CvA8qU1mdCLwmONsEdMYiX9MBJPQUtdKpSzTkEr
 ei3Ud1mbQSStGuUhg7+ec20zSiVnEUYt0Fyd7Ylz0JXyoDEzLq6C2N7S8fN7v4J9dy
 l0CBMMnNmYEK9oOkkz2xWN2Ub6RyqV+ey0y9/m+fBqIL12YAOOv7nPK2CygTSFZayc
 TwB4LD/lrL5yg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/4] KVM: arm64: Extend comment in has_vhe()
Date: Thu,  3 Jun 2021 19:33:45 +0100
Message-Id: <20210603183347.1695-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603183347.1695-1-will@kernel.org>
References: <20210603183347.1695-1-will@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>
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

has_vhe() expands to a compile-time constant when evaluated from the VHE
or nVHE code, alternatively checking a static key when called from
elsewhere in the kernel. On face value, this looks like a case of
premature optimization, but in fact this allows symbol references on
VHE-specific code paths to be dropped from the nVHE object.

Expand the comment in has_vhe() to make this clearer, hopefully
discouraging anybody from simplifying the code.

Cc: David Brazdil <dbrazdil@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/virt.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 7379f35ae2c6..3218ca17f819 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -111,6 +111,9 @@ static __always_inline bool has_vhe(void)
 	/*
 	 * Code only run in VHE/NVHE hyp context can assume VHE is present or
 	 * absent. Otherwise fall back to caps.
+	 * This allows the compiler to discard VHE-specific code from the
+	 * nVHE object, reducing the number of external symbol references
+	 * needed to link.
 	 */
 	if (is_vhe_hyp_code())
 		return true;
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
