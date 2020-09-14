Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC12C2BC11
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19FF520771
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="uI/iQaAn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19FF520771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAC854B571;
	Mon, 14 Sep 2020 13:28:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UCaGhBTiJ+QG; Mon, 14 Sep 2020 13:28:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8F524B58B;
	Mon, 14 Sep 2020 13:28:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2F834B567
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PCz6Ec+xOQuE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:06 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E8E54B571
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:06 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id z9so866677wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=giQoIm7ww9o7WbiRNjhgzGzCrffBGGule76BQnYzoVI=;
 b=uI/iQaAnhz3Rb1rxk2fe04dFKCupBX6ghPL7T1uUwqbl92dUULrnTdyKTCk5O3kQ5A
 JRjuhoIY2N1UVpWIl9QtCEy/iGMZnNG41xPQCXLPEJpOF2Tpd6sp0KALC2AD8lgXTu2j
 bUhIOKUvEicaIOZsb2+fYEOfBzUZ1nKGsTGcJ7O25/87/uOAalz5qnul5IPGNfg+fEqg
 xwQ/11H9wYnyUwG7mCMtj8+Uj1pYNYZXNe9fanGcdlFzOTGFDaPukkC2wT/8/DrREZR2
 5cSu5T12OjmTPxWAQR/2dka541vyP0ossBIVmncwMUbW/+IU+sD/AgHfEeqZLjuhn9/c
 PkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=giQoIm7ww9o7WbiRNjhgzGzCrffBGGule76BQnYzoVI=;
 b=XGjOQqKBxR6eWXM9XN3tHybtHeQdeMjdvjMraqb2DqAsH+NgM/psERXYVBY7fQUz/i
 V6yYU6vsscgLSg5wwyufxAD6Ld/B4JElbq1Lz9J/vp9fNK62eXYEB7wq9/OBkSysKuW7
 hjyhzg8vSsqLNvbEIRiE4FJu6Ug2KsXuEDk+VwzVDyoudHFx9jxZtOYxgZ8o1gSHOwvW
 jvSHFkGpn9bxXi4rFLVdARVPElQgFJAQK8KaPQv67tyqBfgGT732pdI+CjC0f2SWBnAd
 +4nOmWCFbAuqAzGiYsTp2mLPneQ44h7Ic0SVBauNNi74Q6RA4mD9mJ5XytKvL57T9jZe
 4Q1Q==
X-Gm-Message-State: AOAM531A/lm4Vx8tI63byBUn4tn735gIARId2WiygyostRYt+9wAT94T
 JhP8YO+8WPR9IsYK8I/s4NztaA==
X-Google-Smtp-Source: ABdhPJzIM8L5QBOZ1G45T6rFbKm9SssKcSzPM7wAmTlp7uD3PTPktsRiE4T2L0aO6lTWC6jHotleiw==
X-Received: by 2002:a1c:f608:: with SMTP id w8mr432260wmc.161.1600104485530;
 Mon, 14 Sep 2020 10:28:05 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id o9sm21315846wrw.58.2020.09.14.10.28.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:04 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 02/14] KVM: arm64: Define a macro for storing a value inside a
 per_cpu variable
Date: Mon, 14 Sep 2020 17:27:38 +0000
Message-Id: <20200914172750.852684-3-georgepope@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200914172750.852684-1-georgepope@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
MIME-Version: 1.0
Cc: arnd@arndb.de, elver@google.com, tglx@linutronix.de, keescook@chromium.org,
 maskray@google.com, linux-kbuild@vger.kernel.org, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 clang-built-linux@googlegroups.com, broonie@kernel.org, dvyukov@google.com,
 natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: George Popescu <georgepope@google.com>

Use the hyp_str_this_cpu assembly macro to store a value in a per_cpu
variable. This macro is designed to be used inside of the hyp code.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6f98fbd0ac81..200bb8d0a720 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -211,6 +211,11 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 	ldr	\reg,  [\reg, \tmp]
 .endm
 
+.macro hyp_str_this_cpu sym, reg, tmp1, tmp2
+	hyp_adr_this_cpu \tmp1, \sym, \tmp2
+	str	\reg, [\tmp1]
+.endm
+
 .macro get_host_ctxt reg, tmp
 	hyp_adr_this_cpu \reg, kvm_host_data, \tmp
 	add	\reg, \reg, #HOST_DATA_CONTEXT
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
