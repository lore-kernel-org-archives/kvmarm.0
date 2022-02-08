Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945D8C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:55:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B32004B105;
	Tue,  8 Feb 2022 12:55:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MWsmH3np9aRb; Tue,  8 Feb 2022 12:55:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FCC04B0F7;
	Tue,  8 Feb 2022 12:55:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDE074B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:55:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ByYqqtHq4w-a for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:55:43 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8792940307
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:55:43 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE0A617E6;
 Tue,  8 Feb 2022 17:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CF8C004E1;
 Tue,  8 Feb 2022 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644342941;
 bh=vuOki87uw/cVjiDBNRuvVbweJ7mfBUbdWsYNIU6Q4CQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=iL+NboFDWPKiFk7BCoHiTAkSC8jqhERdstt77f7mcBalWlHF+WJ/qAPgpPHVzXpmm
 mSQlatzJT/sJqW4xeRc76+0fQgM4BpyHzDKYc6PInlI0Wl8XP3o+lAtimpKJHdXaZG
 qzO62yVy8P6ofwZxzbtA4BTsnT9H3MihYWUHzd/KVN5pGGIWyRRlO8gCJAdLgQbMcj
 5C2Y5rjpXoj3ZWMuhksDojrXpyCM3soqJJOUwPFUEfUEiNXBqhaJJU15551unAZUlc
 ULrx6qVqKzVhlHU6RLxXiXRWUw3sxDu/0MurK29n3yG2jQui0lH3GC2/jYWtbjs3ak
 OtUsFuJKrIO8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nHUiJ-006LJ3-Tp; Tue, 08 Feb 2022 17:55:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com,
 Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/6] KVM: arm64: Improve PMU support on heterogeneous
 systems
Date: Tue,  8 Feb 2022 17:55:37 +0000
Message-Id: <164434293099.3932761.490212877046976183.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127161759.53553-1-alexandru.elisei@arm.com>
References: <20220127161759.53553-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, mark.rutland@arm.com,
 james.morse@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, tglx@linutronix.de,
 mingo@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: tglx@linutronix.de, mingo@redhat.com
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

On Thu, 27 Jan 2022 16:17:53 +0000, Alexandru Elisei wrote:
> (CC'ing Peter Maydell in case this might be of interest to qemu)
> 
> The series can be found on a branch at [1], and the kvmtool support at [2].
> 
> Detailed explanation of the issue and symptoms that the patches attempt to
> correct can be found in the cover letter for v1 [3].
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Do not change the PMU event filter after a VCPU has run
      commit: 5177fe91e4cf78a659aada2c9cf712db4d788481
[2/6] perf: Fix wrong name in comment for struct perf_cpu_context
      commit: 2093057ab879da1070c851b9e07126eaa86d0dfc
[3/6] KVM: arm64: Keep a per-VM pointer to the default PMU
      commit: 46b18782147248b62f00e98a7f87abaf934951e8
[4/6] KVM: arm64: Keep a list of probed PMUs
      commit: db858060b1a788fba03711793dcaff19ea43286c
[5/6] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
      commit: 6ee7fca2a4a023b14aa1f1f3c4f6c833116116ef
[6/6] KVM: arm64: Refuse to run VCPU if the PMU doesn't match the physical CPU
      commit: 583cda1b0e7d5d49db5fc15db623166310e36bf6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
