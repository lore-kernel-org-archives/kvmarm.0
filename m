Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A40C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 13:25:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3B042082E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 13:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="G/dR2Xzg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3B042082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4994B3C0;
	Thu, 30 Jul 2020 09:25:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9BeEtwWAcztB; Thu, 30 Jul 2020 09:25:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 031F34B0B3;
	Thu, 30 Jul 2020 09:25:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B81D34B3C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 09:25:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fyilcn36hJ9Y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 09:25:25 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83AF34B3C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 09:25:25 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id r4so21935569wrx.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 06:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=VUEiWZ9pO6UikEPfnSxWzM8COZBi2CR+f41vrCc2PbU=;
 b=G/dR2XzgwW5YtNdUxo7l6BrOSY8dlaYGR3bL6VO/Qt+dAQs46+Fzql3lsSJws7Ri4K
 rmU53JAod/zYnRODSPbMlaQo/8wdoxS+NhVSLUnbEdnX33Cnthrx5VCzfsKRS1cZrrZr
 bYkGxpJpV0ADVvKBgCgabzkJBiMLxlR9IaD0CnCip0jLeZaVkNIJ8ztHFDgrknltpQEu
 Qcy1/uXwU4UYBxPcAWWpYYyyQZf+BnIArF6YasmLRsCp+UznJe2+UrgHjb1GAVK/dFSB
 qq2aPX3+QhJtfjDWYK7IYVoTZVQ3VNW2kh6sWOEz9cZryUZTFgMQAw7XrR3xsd3hm9VP
 dfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=VUEiWZ9pO6UikEPfnSxWzM8COZBi2CR+f41vrCc2PbU=;
 b=ChlbWn4OA1jpgvh+ftaHwYdTTKf8Ot6/KPDMQNFQRZ3WW9sUj8h9X5m47c29PJq9zJ
 PSQGmkoXGsJL+t9DsKK0eOH2O+GPseYvvEVPWrpkH8+obwl2MDzuj1uiYT755+9kzYe4
 dHMvJUvH9EWk4egmiYlVEdcgAVeXA3xAp1Lf+UiKaVgXNX1sbcx54LCUtTkDlWImxzCD
 9rlMtfJkr5jZMeykJ+nJ3c8k5AP/DIBBN3eNYe0RjhpQqfn+lqNGdN56OLIdPuHaHQSm
 WyNny0nPNnLg4fK/UDYmRfNFxMXqJukL0sX8fAeJxuu/46Cq7r1lfRHB6ozyEfBP8YJD
 l1gg==
X-Gm-Message-State: AOAM532XRGxr62mDnGJGcxng+eB99phVkmYbowK4UvgRMj73lkrAsyf7
 /lAWnE1AWssrALLSYVt7VHLExw==
X-Google-Smtp-Source: ABdhPJxUh0JNkpM1blwpstAX29yKD5NnvCsKPNTg2SbOEjWPbmwEW4f53P8bEqqdzEpR20ArFW0tjw==
X-Received: by 2002:adf:94c5:: with SMTP id 63mr2776837wrr.34.1596115524080;
 Thu, 30 Jul 2020 06:25:24 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:b4ef:bd7f:473a:9fdf])
 by smtp.gmail.com with ESMTPSA id b142sm6483931wmd.19.2020.07.30.06.25.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Jul 2020 06:25:22 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: Ensure that all nVHE hyp code is in .hyp.text
Date: Thu, 30 Jul 2020 14:25:19 +0100
Message-Id: <20200730132519.48787-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 clang-built-linux@googlegroups.com, kernel-team@google.com,
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

Patch based off kvmarm/next (commit a394cf6e85).

Signed-off-by: David Brazdil <dbrazdil@google.com>
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
2.28.0.163.g6104cc2f0b6-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
