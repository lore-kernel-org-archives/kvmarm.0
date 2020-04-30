Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA963C47254
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:49:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3E432074A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:49:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OA5l7aPT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3E432074A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E85F4B4D7;
	Thu, 30 Apr 2020 10:49:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A7AQAUA-EbUO; Thu, 30 Apr 2020 10:49:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7387F4B52C;
	Thu, 30 Apr 2020 10:49:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BB3A4B4D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UkvYLNg728zo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 10:49:19 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C29C4B4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:49:14 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id v8so7668920wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=g7eYSMAp+jVN9aeMCPrBnn3TIBRQFFZukfwsZjZglmQ=;
 b=OA5l7aPTjb+/faLVms3XE72y8w1jxluq6N84GtC94alO2aDBpgsSDm1VINExf6U31K
 9tqr3waTe0vuItea2ZK+4FQY33rrwYVdlFm66/zz3Cbebio6W/zJw+cuzPwy6n+iuVO1
 Qv5Txcaf0FBe7wgFuL7AbtE7IOV5EsWHhF+AbyMKfvo6KM8oDXgrOneyRlflh3kUpYDW
 E4uoX+Djh2ULGNXS229plrMBCBOviGp/3ySosN9wHOowtX6bdb+p566EJDb6/lYWICXS
 WRk4yWH7ivHkDHxhIfzZpbxIlPohMJP1LV+ksBsadHK0LHqwXShd8qhbrbm5BovWgXrw
 ++DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=g7eYSMAp+jVN9aeMCPrBnn3TIBRQFFZukfwsZjZglmQ=;
 b=cCjhtQEgSDQjoGA/a8127Q3skJZns0OZn86fdwUPS/8bCjsBavpn7aR/ys+BxN6b36
 HgreK1bJpuEw6R+bxM9Dz+wbSJSBRaBo4JtGCtg6YfnjHMxgbLvJKmFAn4p1kbchZdsP
 r5vt/c5J3K++8dh/FMObhm6Qkb1LSMb9Zxfgp8xKW+3YfV3dtnsadCKBFhbnxDCwus2X
 Z5Gu6ul0JGc65WrKdH2lPnVG67V5j+/lJ+JQV/TewMYPiCdyFyUkwmUA4N87Ez+vsdwu
 NaLxWPZ9XD5PrtjYv5zCYKtIvD1jDYeyuL+SKjiPqI7B8mNQbxWXjKVYCFIbegwYSSin
 7mjw==
X-Gm-Message-State: AGi0PuYlUPUH9crnDTFZ91XOBquy+MqhaOtutm6kQFrPAzxHFpmI+/HO
 9WzqpTVfzUCl3BsdHleQAddzZw==
X-Google-Smtp-Source: APiQypITD1jhHlRSJgCpCChsFN8ZYowBb0ctI7WS8xvFw5N4p+kZxrBFEWIMXyQBlBl3+nKP5Z4Cvw==
X-Received: by 2002:a7b:c306:: with SMTP id k6mr3287632wmj.40.1588258152859;
 Thu, 30 Apr 2020 07:49:12 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d4b6:9828:8bd2:ce6f])
 by smtp.gmail.com with ESMTPSA id f2sm4557427wro.59.2020.04.30.07.49.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Apr 2020 07:49:12 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 15/15] arm64: kvm: Lift instrumentation restrictions on VHE
Date: Thu, 30 Apr 2020 15:48:31 +0100
Message-Id: <20200430144831.59194-16-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200430144831.59194-1-dbrazdil@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

With VHE and nVHE executable code completely separated, remove build config
that disabled GCOV/KASAN/UBSAN/KCOV instrumentation for VHE as these now
execute under the same memory mappings as the rest of the kernel.

No violations are currently being reported by either KASAN or UBSAN.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/Makefile | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index a6883f4fed9e..f877ac404b46 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,11 +10,3 @@ obj-$(CONFIG_KVM) += vhe.o nvhe/
 
 vhe-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
 	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
-
-# KVM code is run at a different exception code with a different map, so
-# compiler instrumentation that inserts callbacks or checks into the code may
-# cause crashes. Just disable it.
-GCOV_PROFILE	:= n
-KASAN_SANITIZE	:= n
-UBSAN_SANITIZE	:= n
-KCOV_INSTRUMENT	:= n
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
