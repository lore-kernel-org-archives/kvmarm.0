Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD06C56201
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:26:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42BAE246AA
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="d5PO+tqR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42BAE246AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA9944B3D9;
	Thu, 19 Nov 2020 11:26:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mlj6gHfeyJB7; Thu, 19 Nov 2020 11:25:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD8CF4B488;
	Thu, 19 Nov 2020 11:25:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C1A4B47B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:25:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2oEVlFn5dIO0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 11:25:56 -0500 (EST)
Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com
 [209.85.208.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C5704B45E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:25:56 -0500 (EST)
Received: by mail-ed1-f67.google.com with SMTP id q3so6420703edr.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 08:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=4v/cI0W618Ll5oLWISpFhPxrIsIv3CzVb2jjngYJV1Y=;
 b=d5PO+tqR8NqolGIpflVwHQcaoSm8nizbEKWRPNduNGR++veNurs6hl8d+bpaVieFyx
 N/4qzptR0qOSoxQx7FQPsoe+iJswnHDVYtCadJO3C2slcCcPefUTQ+zOiNyarho+GJTQ
 eQVq93/itpn3uOMr/bNlKeAjhJZdy4EqJV6kjmkrHbofx2egXY3zQ+yRKs+a7dQtwgdK
 4NoSRABTZAqopd6clg6Riim7meD6ewWkye8RYV/TV41uhgV3OcI7IOBtaWy6jDfV+Jfn
 HS8RCnV4PSHXaSeawTEOygjXqwZVK8R/FKpjfbB4tqH67KPho4pLvDzc9Uy4bjYb/kik
 IvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=4v/cI0W618Ll5oLWISpFhPxrIsIv3CzVb2jjngYJV1Y=;
 b=dABpNhMq2frh+fSa6XdZGnkHgDfKa1aEPlU5b907H4LSN5NUpLG3W1mv7LS7fK6pRC
 X8Q+73zXsTiIk6EjyYX2UBSERWkrUB+7eaM+Snu53KaKgUFBvQhWTy8YRWPWfLwNSNZE
 cMqhgBrqDc+1CnpotfO9YVYWREIHKHjuqY5ZSUkX4cMflLND0PaW221zWQQ8C5w58B51
 D8JLYtkaYmGjcqkYjz+bpd9InH906NoazbW3q6BIeTTCS6GFuSzydjQRcSCxBSE99kzm
 78uS1iSrAxhNUdty4uXS8m2oPDZPKMryjQ1cghFG902B859X7DRrk7HIoM2P18jtf/fl
 yIAw==
X-Gm-Message-State: AOAM533fDbCg7JT4vBOCdpBaWbOQdU2539vOX9QZDzmwUIrYHLazqNOY
 2mHPaYeJg7hU6IPAbn+BPqdu+K2NkNLhVQ==
X-Google-Smtp-Source: ABdhPJwsWb2PZ6sVei/sp7eotqJ6Uj+ntArrx/BCAAQKZymcK4INkpViSTd4Aa9KHDTnkjsffwkiyQ==
X-Received: by 2002:a50:ccdb:: with SMTP id b27mr9198862edj.253.1605803154843; 
 Thu, 19 Nov 2020 08:25:54 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9843:cd3f:f36b:d55c])
 by smtp.gmail.com with ESMTPSA id k2sm84334ejp.6.2020.11.19.08.25.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 Nov 2020 08:25:53 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 3/6] kvm: arm64: Fix up RELR relocation in hyp code/data
Date: Thu, 19 Nov 2020 16:25:40 +0000
Message-Id: <20201119162543.78001-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119162543.78001-1-dbrazdil@google.com>
References: <20201119162543.78001-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

The arm64 kernel also supports packing of relocation data using the RELR
format. Implement a parser of RELR data and fixup the relocations using
the same infra as RELA relocs.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/va_layout.c | 41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index b80fab974896..7f45a98eacfd 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -145,6 +145,43 @@ static void __fixup_hyp_rela(void)
 		__fixup_hyp_rel(rel[i].r_offset);
 }
 
+#ifdef CONFIG_RELR
+static void __fixup_hyp_relr(void)
+{
+	u64 *rel, *end;
+
+	rel = (u64*)(kimage_vaddr + __load_elf_u64(__relr_offset));
+	end = rel + (__load_elf_u64(__relr_size) / sizeof(*rel));
+
+	while (rel < end) {
+		unsigned n;
+		u64 addr = *(rel++);
+
+		/* Address must not have the LSB set. */
+		BUG_ON(addr & BIT(0));
+
+		/* Fix up the first address of the chain. */
+		__fixup_hyp_rel(addr);
+
+		/*
+		 * Loop over bitmaps, i.e. as long as words' LSB is 1.
+		 * Each bit (ordered from LSB to MSB) represents one word from
+		 * the last full address (exclusive). If the corresponding bit
+		 * is 1, there is a relative relocation on that word.
+		 */
+		for (n = 0; rel < end && (*rel & BIT(0)); n++) {
+			unsigned i;
+			u64 bitmap = *(rel++);
+
+			for (i = 1; i < 64; ++i) {
+				if ((bitmap & BIT(i)))
+					__fixup_hyp_rel(addr + 8 * (63 * n + i));
+			}
+		}
+	}
+}
+#endif
+
 /*
  * The kernel relocated pointers to kernel VA. Iterate over relocations in
  * the hypervisor ELF sections and convert them to hyp VA. This avoids the
@@ -156,6 +193,10 @@ __init void kvm_fixup_hyp_relocations(void)
 		return;
 
 	__fixup_hyp_rela();
+
+#ifdef CONFIG_RELR
+	__fixup_hyp_relr();
+#endif
 }
 
 static u32 compute_instruction(int n, u32 rd, u32 rn)
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
