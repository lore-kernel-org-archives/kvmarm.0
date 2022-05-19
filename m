Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3707AC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:42:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAD794B382;
	Thu, 19 May 2022 09:42:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jXPTBE3tASop; Thu, 19 May 2022 09:42:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8C04B214;
	Thu, 19 May 2022 09:42:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DDA3410FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d1cnsKzzeRlE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:42:47 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08A0A4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:47 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 30548B824A5;
 Thu, 19 May 2022 13:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD7AC34100;
 Thu, 19 May 2022 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967765;
 bh=zEyj8WLPsyQCMesj24K7D/KNcr+nQZHaLAKHGDzvuq4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fD8yVP55ECUDTOIB2ZF91hhiW/pXGiOLRiH9DKxoF7SKZ3tRhXC/oVAYXimZ6UkrM
 x4FY73V72GW1+D4lL4qnxnASYOOVFx43W3TcuBHcnLH86nuNNDUqMpmh9qc/QPgAw+
 mnDgOHMcuIyIjRH080UE8TEP5c3VV8hgTmjUjaz0x6Jruxinnc/iZZ6YXvkDqMnefn
 C51HST7GtdYV5X/a63U6pctf6w8xqghITrg/sedqgU1aeT3HE4/rLJNMJ28kINcp2s
 Qa2zmIgtsaB0hNLWo9VzrMowddP3w1ZE7D5EyS5VUJcEZBCjUhRJDS/k2edTmPVwaz
 DrMacKmPY4bHg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 05/89] KVM: arm64: Extend comment in has_vhe()
Date: Thu, 19 May 2022 14:40:40 +0100
Message-Id: <20220519134204.5379-6-will@kernel.org>
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

has_vhe() expands to a compile-time constant when evaluated from the VHE
or nVHE code, alternatively checking a static key when called from
elsewhere in the kernel. On face value, this looks like a case of
premature optimization, but in fact this allows symbol references on
VHE-specific code paths to be dropped from the nVHE object.

Expand the comment in has_vhe() to make this clearer, hopefully
discouraging anybody from simplifying the code.

Cc: David Brazdil <dbrazdil@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/virt.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 3c8af033a997..0e80db4327b6 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -113,6 +113,9 @@ static __always_inline bool has_vhe(void)
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
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
