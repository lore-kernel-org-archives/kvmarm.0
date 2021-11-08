Return-Path: <SRS0=McOM=P3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070F1C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 18:10:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DCA561503
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 18:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6DCA561503
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE9574B192;
	Mon,  8 Nov 2021 13:10:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IhFAcl09DpWX; Mon,  8 Nov 2021 13:10:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A7034B16E;
	Mon,  8 Nov 2021 13:10:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2DF4B15C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 13:10:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mAkALkjRe1Fq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 13:10:44 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58C254B0DE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 13:10:44 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6462C6112D;
 Mon,  8 Nov 2021 18:10:43 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mk96P-004DA2-51; Mon, 08 Nov 2021 18:10:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 James Morse <james.morse@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 linux-arm-kernel@lists.infradead.org, Quentin Perret <qperret@google.com>,
 Fuad Tabba <tabba@google.com>, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix host stage-2 finalization
Date: Mon,  8 Nov 2021 18:10:21 +0000
Message-Id: <163639501024.3332736.13628751369499525511.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211108154636.393384-1-qperret@google.com>
References: <20211108154636.393384-1-qperret@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, will@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, qperret@google.com, tabba@google.com,
 alexandru.elisei@arm.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

On Mon, 8 Nov 2021 15:46:32 +0000, Quentin Perret wrote:
> We currently walk the hypervisor stage-1 page-table towards the end of
> hyp init in nVHE protected mode and adjust the host page ownership
> attributes in its stage-2 in order to get a consistent state from both
> point of views. The walk is done on the entire hyp VA space, and expects
> to only ever find page-level mappings. While this expectation is
> reasonable in the half of hyp VA space that maps memory with a fixed
> offset (see the loop in pkvm_create_mappings_locked()), it can be
> incorrect in the other half where nothing prevents the usage of block
> mappings. For instance, on systems where memory is physically aligned at
> an address that happens to maps to a PMD aligned VA in the hyp_vmemmap,
> kvm_pgtable_hyp_map() will install block mappings when backing the
> hyp_vmemmap, which will later cause finalize_host_mappings() to fail.
> Furthermore, it should be noted that all pages backing the hyp_vmemmap
> are also mapped in the 'fixed offset range' of the hypervisor, which
> implies that finalize_host_mappings() will walk both aliases and update
> the host stage-2 attributes twice. The order in which this happens is
> unpredictable, though, since the hyp VA layout is highly dependent on
> the position of the idmap page, hence resulting in a fragile mess at
> best.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix host stage-2 finalization
      commit: 50a8d3315960c74095c59e204db44abd937d4b5d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
