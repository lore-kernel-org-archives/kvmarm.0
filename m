Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116BCC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:27:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BA7C223100
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMLT1zyg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA7C223100
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7538E4B49C;
	Wed,  5 Aug 2020 14:27:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NDuaeS9wTpNx; Wed,  5 Aug 2020 14:27:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F2A44B60B;
	Wed,  5 Aug 2020 14:27:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCE974B45F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:27:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bjdRiXXRKvqH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:27:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 598DD4B5B9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:59 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8518422E01;
 Wed,  5 Aug 2020 18:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596652018;
 bh=qWbqjPlIPwkyEPb+J2ieeFiKJ1fw2t8X5TuAlqMXn4o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=vMLT1zygplaGzq1ry484nkOe49QbNtJysFnQnA0VGRPDz5QKI9WoHaBh6OIvAKxZC
 ZSlMV1dLmyWCOjtZl/foqv2sJBoKSjYZTwiw1+hqY+63NS3fSREa+GpzxQ+CrXZKwe
 2c1EXdR1vs50js27ni2fL2Vl3jAngS9wSIs4xUOA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3Ng0-0004w9-5p; Wed, 05 Aug 2020 18:58:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 51/56] KVM: arm64: Ensure that all nVHE hyp code is in
 .hyp.text
Date: Wed,  5 Aug 2020 18:56:55 +0100
Message-Id: <20200805175700.62775-52-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: David Brazdil <dbrazdil@google.com>

Some compilers may put a subset of generated functions into '.text.*'
ELF sections and the linker may leverage this division to optimize ELF
layout. Unfortunately, the recently introduced HYPCOPY command assumes
that all executable code (with the exception of specialized sections
such as '.hyp.idmap.text') is in the '.text' section. If this
assumption is broken, code in '.text.*' will be merged into kernel
proper '.text' instead of the '.hyp.text' that is mapped in EL2.

To ensure that this cannot happen, insert an OBJDUMP assertion into
HYPCOPY. The command dumps a list of ELF sections in the input object
file and greps for '.text.'. If found, compilation fails. Tested with
both binutils' and LLVM's objdump (the output format is different).

GCC offers '-fno-reorder-functions' to disable this behaviour. Select
the flag if it is available. From inspection of GCC source (latest
Git in July 2020), this flag does force all code into '.text'.
By default, GCC uses profile data, heuristics and attributes to select
a subsection.

LLVM/Clang currently does not have a similar optimization pass. It can
place static constructors into '.text.startup' and it's optimizer can
be provided with profile data to reorder hot/cold functions. Neither
of these is applicable to nVHE hyp code. If this changes in the future,
the OBJDUMP assertion should alert users to the problem.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200730132519.48787-1-dbrazdil@google.com
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0b34414557d6..aef76487edc2 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -20,10 +20,30 @@ $(obj)/%.hyp.tmp.o: $(src)/%.S FORCE
 $(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
 	$(call if_changed,hypcopy)
 
+# Disable reordering functions by GCC (enabled at -O2).
+# This pass puts functions into '.text.*' sections to aid the linker
+# in optimizing ELF layout. See HYPCOPY comment below for more info.
+ccflags-y += $(call cc-option,-fno-reorder-functions)
+
+# The HYPCOPY command uses `objcopy` to prefix all ELF symbol names
+# and relevant ELF section names to avoid clashes with VHE code/data.
+#
+# Hyp code is assumed to be in the '.text' section of the input object
+# files (with the exception of specialized sections such as
+# '.hyp.idmap.text'). This assumption may be broken by a compiler that
+# divides code into sections like '.text.unlikely' so as to optimize
+# ELF layout. HYPCOPY checks that no such sections exist in the input
+# using `objdump`, otherwise they would be linked together with other
+# kernel code and not memory-mapped correctly at runtime.
 quiet_cmd_hypcopy = HYPCOPY $@
-      cmd_hypcopy = $(OBJCOPY)	--prefix-symbols=__kvm_nvhe_		\
-				--rename-section=.text=.hyp.text	\
-				$< $@
+      cmd_hypcopy =							\
+	if $(OBJDUMP) -h $< | grep -F '.text.'; then			\
+		echo "$@: function reordering not supported in nVHE hyp code" >&2; \
+		/bin/false;						\
+	fi;								\
+	$(OBJCOPY) --prefix-symbols=__kvm_nvhe_				\
+		   --rename-section=.text=.hyp.text			\
+		   $< $@
 
 # Remove ftrace and Shadow Call Stack CFLAGS.
 # This is equivalent to the 'notrace' and '__noscs' annotations.
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
