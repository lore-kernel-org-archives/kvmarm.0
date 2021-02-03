Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AF4C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 16:44:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5997064F7E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 16:44:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5997064F7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C92E94B290;
	Wed,  3 Feb 2021 11:44:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ve6Jk1MhTTxX; Wed,  3 Feb 2021 11:44:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 777B44B291;
	Wed,  3 Feb 2021 11:44:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47FC14B282
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 11:44:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OObRINzJ-GPW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 11:44:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 532CD4B281
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 11:44:01 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1207564F7C;
 Wed,  3 Feb 2021 16:44:00 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7LG1-00Bnsm-Sk; Wed, 03 Feb 2021 16:43:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: arnd@arndb.de, Quentin Perret <qperret@google.com>,
 catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Stub exports in nvhe code
Date: Wed,  3 Feb 2021 16:43:48 +0000
Message-Id: <161237062025.1419625.13086305573512898143.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203141931.615898-1-qperret@google.com>
References: <20210203141931.615898-1-qperret@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: arnd@arndb.de, qperret@google.com, catalin.marinas@arm.com,
 will@kernel.org, ardb@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-arch@vger.kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, ardb@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, 3 Feb 2021 14:19:29 +0000, Quentin Perret wrote:
> In the context of the currently ongoing work to remove the host kernel
> from the TCB under KVM/arm64, I have been trying to wrap the host kernel
> with a stage 2 page-table -- see [1].
> 
> Using this infrastructure, I attempted to unmap the .hyp. sections from
> the host stage 2 as it really shouldn't need to access them. But by
> doing so, I realized quickly the module loader was getting very confused
> by the usage of EXPORT_SYMBOL() macros in library functions that have
> been pulled into the EL2 object, and that we end up linking modules
> against the EL2 copy of e.g. memset. And so, this series essentially
> tries to fix this.
> 
> [...]

Applied to kvm-arm64/misc-5.12, thanks!

[1/2] asm-generic: export: Stub EXPORT_SYMBOL with __DISABLE_EXPORTS
      commit: 54effa653246c35997f5e990e0134be5be09f9d1
[2/2] KVM: arm64: Stub EXPORT_SYMBOL for nVHE EL2 code
      commit: bbc075e01ceac50e0a8353b520544f3089e94e44

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
