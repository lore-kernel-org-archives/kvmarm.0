Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFBFC2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4D7B2224B
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="VBVxPuFz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4D7B2224B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A374C16F;
	Mon, 16 Nov 2020 15:43:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e52CP1lJt0D7; Mon, 16 Nov 2020 15:43:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 503AD4C248;
	Mon, 16 Nov 2020 15:43:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 265624C219
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tQWKBs1ZspC5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:31 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AA194C19D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:30 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id p8so20291059wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=i1OvP2q61CHl1qszot5RZrAZIRY6eLpATjvcLw+mVNU=;
 b=VBVxPuFz0v1VTxIhWc+Lrxy25SeJfCOpJAG27XQAFG1IjlE2oXtGlzk3400Z+kESsc
 6V/4SHdSfdtr5e6x8XvFe0sKbm3FkQOw0FUMSTcQhpXIp23sO5VzwOQrvHR/FjNr+e+8
 q5UKiuLIqgP1GIvawt3LAxo1d314xttGEOemqAuZMnRmQ/mAjvi//QdMK5UQqUAoppoG
 GWMpUTAcZJlaL5EgsnZm2+vljkdDsttYq7vJ5k23DOVdeVbCzxHVWWYd4kItMa1gFkI4
 pomXJMJSspC0SOuZwKwAkSVw+xfZQALrUWVWGtsi8G9v4nuZyZxlLczAM4n2uo0dg8mX
 Av0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=i1OvP2q61CHl1qszot5RZrAZIRY6eLpATjvcLw+mVNU=;
 b=NPgm2iIGE7N8BvGEP30z+L6ht86MO5ZB/CXrF9AFEEx070wFEnJ/Ot4D6GuVe6qRkC
 qHdkUXEYD4un7dTQ0Sf+PciPnSjTsg2gHvZr3287WAgtYpmcqfQE8ZI62IZ+h2J/TdZJ
 uHXONfAz+6mIogUxg8Qj70b+pOGoYHXoiHFKk5dj+dBM5CsuQczNW4sFTZYApcU+rWCn
 OKGpKaBhNUX9c/bHFTVPveygksSvpQnxsuZ5UEVnW+qn+Bmnd/u2Ev8IGljp/l7LWOcN
 ur4tFUd8DeTkloowVE6+6NL1xOuwhu2pyTdF8bRW9dquq8e8PRSjpQO5O9wLICza7YmG
 oVgw==
X-Gm-Message-State: AOAM530nIOU9Brk/eDCXnieb5LYWY8OF7NSyAl1HjQHlXZpKboOU60cS
 03eqSzwMXPLnl8UA1DRPIF6wAEnAPzYlh6Qi0Cg=
X-Google-Smtp-Source: ABdhPJwo5wX54x3EI1cjb6V0hNUDo7O9qMuKIAu7Wtf6d+0psErzZX0pP09b5KCMiJdBDam8PwHRaA==
X-Received: by 2002:adf:f5c8:: with SMTP id k8mr22225271wrp.2.1605559409325;
 Mon, 16 Nov 2020 12:43:29 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id z3sm23263951wrw.87.2020.11.16.12.43.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:28 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 03/24] arm64: Make cpu_logical_map() take unsigned int
Date: Mon, 16 Nov 2020 20:42:57 +0000
Message-Id: <20201116204318.63987-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

CPU index should never be negative. Change the signature of
(set_)cpu_logical_map to take an unsigned int.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/smp.h | 4 ++--
 arch/arm64/kernel/setup.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index 2e7f529ec5a6..bcb01ca15325 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -46,9 +46,9 @@ DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
  * Logical CPU mapping.
  */
 extern u64 __cpu_logical_map[NR_CPUS];
-extern u64 cpu_logical_map(int cpu);
+extern u64 cpu_logical_map(unsigned int cpu);
 
-static inline void set_cpu_logical_map(int cpu, u64 hwid)
+static inline void set_cpu_logical_map(unsigned int cpu, u64 hwid)
 {
 	__cpu_logical_map[cpu] = hwid;
 }
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 133257ffd859..2f2973bc67c7 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -276,7 +276,7 @@ arch_initcall(reserve_memblock_reserved_regions);
 
 u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
-u64 cpu_logical_map(int cpu)
+u64 cpu_logical_map(unsigned int cpu)
 {
 	return __cpu_logical_map[cpu];
 }
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
