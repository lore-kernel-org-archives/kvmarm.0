Return-Path: <SRS0=tVNh=FB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5118C2D0E4
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 11:21:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09EA921D7F
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 11:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSdQ4/Si"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09EA921D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DA854BE7D;
	Fri, 27 Nov 2020 06:21:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Ybt+lgiW9e7; Fri, 27 Nov 2020 06:21:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EABB54BE88;
	Fri, 27 Nov 2020 06:21:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9090E4BE75
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 06:21:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xB0PztC880AD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2020 06:21:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 952FF4BE74
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 06:21:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4B10A2222A;
 Fri, 27 Nov 2020 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606476081;
 bh=uSWDwx9Mf1mz4a4sUj9aoF18Ki8K132MbX4ipSnTuaA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=CSdQ4/SiMbCkHZxxf4Xs9Ns/mlpYP1T71glovqQ0NVcxhqtksVhVYpdTLzXNhgxZv
 vxegoO+0yoZaQO+E1WUMzUy6gw3GLPoQWV/C2mTN1/jNxJWk44z60pdoSM8Y8O6IOi
 Clu/4rn5Cy8XBMNSox/QlksFtx2LpU1VnU5t6Xvg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiboV-00E2fR-EV; Fri, 27 Nov 2020 11:21:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/2] KVM: arm64: Correctly align nVHE percpu data
Date: Fri, 27 Nov 2020 11:21:00 +0000
Message-Id: <20201127112101.658224-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201127112101.658224-1-maz@kernel.org>
References: <20201127112101.658224-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com,
 eric.auger@redhat.com, jamie@nuviainc.com, zhukeqian1@huawei.com,
 will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Jamie Iles <jamie@nuviainc.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

From: Jamie Iles <jamie@nuviainc.com>

The nVHE percpu data is partially linked but the nVHE linker script did
not align the percpu section.  The PERCPU_INPUT macro would then align
the data to a page boundary:

  #define PERCPU_INPUT(cacheline)					\
  	__per_cpu_start = .;						\
  	*(.data..percpu..first)						\
  	. = ALIGN(PAGE_SIZE);						\
  	*(.data..percpu..page_aligned)					\
  	. = ALIGN(cacheline);						\
  	*(.data..percpu..read_mostly)					\
  	. = ALIGN(cacheline);						\
  	*(.data..percpu)						\
  	*(.data..percpu..shared_aligned)				\
  	PERCPU_DECRYPTED_SECTION					\
  	__per_cpu_end = .;

but then when the final vmlinux linking happens the hypervisor percpu
data is included after page alignment and so the offsets potentially
don't match.  On my build I saw that the .hyp.data..percpu section was
at address 0x20 and then the percpu data would begin at 0x1000 (because
of the page alignment in PERCPU_INPUT), but when linked into vmlinux,
everything would be shifted down by 0x20 bytes.

This manifests as one of the CPUs getting lost when running
kvm-unit-tests or starting any VM and subsequent soft lockup on a Cortex
A72 device.

Fixes: 30c953911c43 ("kvm: arm64: Set up hyp percpu data for nVHE")
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201113150406.14314-1-jamie@nuviainc.com
---
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index bb2d986ff696..a797abace13f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -13,6 +13,11 @@
 
 SECTIONS {
 	HYP_SECTION(.text)
+	/*
+	 * .hyp..data..percpu needs to be page aligned to maintain the same
+	 * alignment for when linking into vmlinux.
+	 */
+	. = ALIGN(PAGE_SIZE);
 	HYP_SECTION_NAME(.data..percpu) : {
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	}
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
