Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A76C19F2C
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 14:29:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1F364C7B4;
	Wed, 27 Jul 2022 10:29:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wAogmGW5yt5Y; Wed, 27 Jul 2022 10:29:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 067444C437;
	Wed, 27 Jul 2022 10:29:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B59444C791
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 10:29:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7O10EsWZyKyK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 10:29:28 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2423F4C79C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 10:29:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 87A3561866;
 Wed, 27 Jul 2022 14:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC5AC43470;
 Wed, 27 Jul 2022 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658932166;
 bh=fZInrAoNIVl8PR0KpPGqdwlflap1sZZaD7KTRy5ITxo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=N16LoX6sEIfnKsJ4VapTkdCtVgIv4l3efmNbGIh9CotiND+28uE6EmYY0nFK6Pi8x
 5c79S/T0IFV4nxWgj87xx8RSAJysD33pqPes4YeD6NGBtTBt5NEc6c2lU9/5MknQ6x
 GM3SMEo5T8SXa0n0tDtybfeJIcUx6abwYiW0uaisS9bbApZCpROztnIsiJr1yJARMT
 oeAwjSd4dckzL89bctz2/ZYjdkueaCrdgcMDXXCWCoGoykqv/O8UtInnBm9sUZvj5v
 ES65Vq/wF5ojSIh9gH8Oet94mgkBEhhUlThBqb+SR7ZVFIJAEhamOvETWh7CQ1htyT
 r7MSAw7u8TAdw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oGi2O-00APjL-Jm;
 Wed, 27 Jul 2022 15:29:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 5/6] KVM: arm64: Don't open code ARRAY_SIZE()
Date: Wed, 27 Jul 2022 15:29:05 +0100
Message-Id: <20220727142906.1856759-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com,
 broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com,
 oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
 james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com,
 mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
 elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org,
 oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, madvenka@linux.microsoft.com,
 kernel-team@android.com, elver@google.com, broonie@kernel.org,
 andreyknvl@gmail.com, mhiramat@kernel.org
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

From: Oliver Upton <oliver.upton@linux.dev>

Use ARRAY_SIZE() instead of an open-coded version.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/stacktrace.c | 3 +--
 arch/arm64/kvm/stacktrace.c          | 6 ++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index acbe272ecb32..58f645ad66bc 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -103,14 +103,13 @@ static void notrace unwind(struct unwind_state *state,
 static bool pkvm_save_backtrace_entry(void *arg, unsigned long where)
 {
 	unsigned long *stacktrace = this_cpu_ptr(pkvm_stacktrace);
-	int size = NVHE_STACKTRACE_SIZE / sizeof(long);
 	int *idx = (int *)arg;
 
 	/*
 	 * Need 2 free slots: 1 for current entry and 1 for the
 	 * delimiter.
 	 */
-	if (*idx > size - 2)
+	if (*idx > ARRAY_SIZE(pkvm_stacktrace) - 2)
 		return false;
 
 	stacktrace[*idx] = where;
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 417665854f86..949d19d603fb 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -187,11 +187,13 @@ static void pkvm_dump_backtrace(unsigned long hyp_offset)
 {
 	unsigned long *stacktrace
 		= (unsigned long *) this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
-	int i, size = NVHE_STACKTRACE_SIZE / sizeof(long);
+	int i;
 
 	kvm_nvhe_dump_backtrace_start();
 	/* The saved stacktrace is terminated by a null entry */
-	for (i = 0; i < size && stacktrace[i]; i++)
+	for (i = 0;
+	     i < ARRAY_SIZE(kvm_nvhe_sym(pkvm_stacktrace)) && stacktrace[i];
+	     i++)
 		kvm_nvhe_dump_backtrace_entry((void *)hyp_offset, stacktrace[i]);
 	kvm_nvhe_dump_backtrace_end();
 }
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
