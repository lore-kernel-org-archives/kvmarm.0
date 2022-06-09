Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF03C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:12:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04D024B39F;
	Thu,  9 Jun 2022 08:12:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yTVt9VVn1hQ0; Thu,  9 Jun 2022 08:12:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E34D34B3A2;
	Thu,  9 Jun 2022 08:12:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC8CB4B35E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CgGJBXmQOVKq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 08:12:39 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59D6B4B39E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 78A3EB82D5B;
 Thu,  9 Jun 2022 12:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97545C3411F;
 Thu,  9 Jun 2022 12:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654776757;
 bh=Vt2h95kPG0rNKVQQsdXAODtHYoMLCkyG3rzEO6q/eug=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Gv+GUgGppkKB03l7lJQ/wVVkga0Gm3t6nEI6UygxyNzTAosWDy19fFtQ1vAsgUQW8
 5P2cTvEZ+hphy9wKSHolD29YcxdZd88j3Em7BFHYm0y0tBH8LEL2Z5zwxOzPotPN7j
 a3fnIqGHZ08KcwDaUgeglRRhLSMCZCIjacv6rKxeSLW/CHt5SmTzZPXVHjj2uWXBy/
 KZsjPAZXxFgJ5z4cw0zpNalwO8yFM4Lto7MVcZOlvO9pZMTsXaEinNU28ZPjM/v1ku
 NdiYIgyZhC9jfSB+UEBVheB9vYaqE6xj6LFrTkRnkMSynhu+LHvudPlk1zLVqCk7DK
 2CRjBeTMt29+A==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/6] KVM: arm64: Extend comment in has_vhe()
Date: Thu,  9 Jun 2022 13:12:21 +0100
Message-Id: <20220609121223.2551-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220609121223.2551-1-will@kernel.org>
References: <20220609121223.2551-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
