Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE82C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 13:31:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03AFD61990
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 13:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03AFD61990
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 856C64B442;
	Wed, 31 Mar 2021 09:31:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id minZLIxUxj9S; Wed, 31 Mar 2021 09:31:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 674C94B430;
	Wed, 31 Mar 2021 09:31:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C07C4B404
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 09:31:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SwAp-vOtDw28 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 09:31:04 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6505D4B3EF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 09:31:04 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id y5so1023943wrp.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 06:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=G0CRqLqXvRiG1/XBSQU7fXbBsXpuUCmZ+DzzZxxUzIo=;
 b=rpChXq0EFgKIpVkS59ynQK6JSC0ep27UrPlpHOIVXXkfEXuY1WiqSTcyQmMkdr6XPW
 53JPsCxnplpk4AqN/UvbynyFxEGzP9Rkq1sDPNgNceVhS5YpfVel6aA/w4KaFNV4vBL+
 QAFVKTMZV/lVWqCLIk5bsq1MIBrRkA/Ooyp+rx78E8X8PzrXals9D+IfBPlLMlBal7B2
 j9drq3kA22qdFUjiiv/1chYzZQIwhn77vvgUXToIwPnCIbU22Ww6RXQnMF7obLxEdoX1
 9ex5kaUnqXGhNbhsmM+ethxGc/m0mPttOb29qF0OS9eSSj0QbOP/jOa/4Jluy5hhGv27
 6S2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=G0CRqLqXvRiG1/XBSQU7fXbBsXpuUCmZ+DzzZxxUzIo=;
 b=ONWYHGt12zg9yIGF7oq4seiW5ce/Oa95msMQSbYXcb5e5UD75TCEI7DIp+mmTe1mCG
 5kAveZPwxsMGdVk27y7ow6SxXV6QQlegf6Sb9NDXK4C+HyTomoZvbFKNoJ0ELDfM4XOb
 gWoiAueFAuSW5jPNVzCEpsBIUDQZxmu0BfS0xeRBtIoyFtCToGZOB09xjR+KUv5dKVN0
 XMPNpGoAFIqpBBN1IQi5aFL/vcTcu8Ix6sIClvJ55SmvcsxD89vAiQzVWiT1YF1MKXnq
 BOpnXmXXWN6bchFV/JfkEJH5hvA+w3nZ8NXLDiYa3KkRb86GHx+k2SIC4kYkGgKsZl4Q
 f4Pg==
X-Gm-Message-State: AOAM532L1b3NoW+4mIelblnCXgNHYqAaszaRzxgSGITA7HbvgDs6e77+
 Cl836xIIyKpm1oYPuVEmt5bW61zIeN9wvhnhGv3KvXDdy9bQgqC5QJoFoW2gef4lmUd3+3swQRo
 8BXQf5dC/ZosNfBuyk9O0p7fAaVIE32HlfrCYwP/nKSuRyDbPLdzy3hEz3FIC9YUiItfH8rkYrp
 Q=
X-Google-Smtp-Source: ABdhPJySMhwc9kqXQ1VmN7daeWnrVfYLeV5Uk5jjjZpqjhpojJFXojBjLNB+z8i/nKEIQhH3v7TuNHaCn5+7lg==
X-Received: from dbrazdil.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:7f9b])
 (user=dbrazdil job=sendgmr) by 2002:adf:fb05:: with SMTP id
 c5mr3869165wrr.302.1617197463183; Wed, 31 Mar 2021 06:31:03 -0700 (PDT)
Date: Wed, 31 Mar 2021 13:30:48 +0000
Message-Id: <20210331133048.63311-1-dbrazdil@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH] KVM: arm64: Support PREL/PLT relocs in EL2 code
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

gen-hyprel tool parses object files of the EL2 portion of KVM
and generates runtime relocation data. While only filtering for
R_AARCH64_ABS64 relocations in the input object files, it has an
allow-list of relocation types that are used for relative
addressing. Other, unexpected, relocation types are rejected and
cause the build to fail.

This allow-list did not include the position-relative relocation
types R_AARCH64_PREL64/32/16 and the recently introduced _PLT32.
While not seen used by toolchains in the wild, add them to the
allow-list for completeness.

Fixes: 8c49b5d43d4c ("KVM: arm64: Generate hyp relocation data")
Cc: <stable@vger.kernel.org>
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
index ead02c6a7628..6bc88a756cb7 100644
--- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -50,6 +50,18 @@
 #ifndef R_AARCH64_ABS64
 #define R_AARCH64_ABS64			257
 #endif
+#ifndef R_AARCH64_PREL64
+#define R_AARCH64_PREL64		260
+#endif
+#ifndef R_AARCH64_PREL32
+#define R_AARCH64_PREL32		261
+#endif
+#ifndef R_AARCH64_PREL16
+#define R_AARCH64_PREL16		262
+#endif
+#ifndef R_AARCH64_PLT32
+#define R_AARCH64_PLT32			314
+#endif
 #ifndef R_AARCH64_LD_PREL_LO19
 #define R_AARCH64_LD_PREL_LO19		273
 #endif
@@ -371,6 +383,12 @@ static void emit_rela_section(Elf64_Shdr *sh_rela)
 		case R_AARCH64_ABS64:
 			emit_rela_abs64(rela, sh_orig_name);
 			break;
+		/* Allow position-relative data relocations. */
+		case R_AARCH64_PREL64:
+		case R_AARCH64_PREL32:
+		case R_AARCH64_PREL16:
+		case R_AARCH64_PLT32:
+			break;
 		/* Allow relocations to generate PC-relative addressing. */
 		case R_AARCH64_LD_PREL_LO19:
 		case R_AARCH64_ADR_PREL_LO21:
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
