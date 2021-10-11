Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2049CC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 09:18:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3FC460F38
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 09:18:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A3FC460F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA144B0ED;
	Mon, 11 Oct 2021 05:18:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uyL6wvydFw9O; Mon, 11 Oct 2021 05:18:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 195C04B0CC;
	Mon, 11 Oct 2021 05:18:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 599064B0C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 05:18:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LcaIpPZCzjRV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 05:18:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 684BB4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 05:18:52 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 176C760EB6;
 Mon, 11 Oct 2021 09:18:50 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mZrSK-00FyHU-7y; Mon, 11 Oct 2021 10:18:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Clean up CONFIG_KVM vs CONFIG_HAVE_KVM
Date: Mon, 11 Oct 2021 10:18:45 +0100
Message-Id: <163394386541.587062.11992680510514299329.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210921222231.518092-1-seanjc@google.com>
References: <20210921222231.518092-1-seanjc@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, catalin.marinas@arm.com, seanjc@google.com,
 linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, james.morse@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tue, 21 Sep 2021 15:22:29 -0700, Sean Christopherson wrote:
> Fix an oddity where arm64 can end up with KVM=y and HAVE_KVM=n.  This
> doesn't cause problems today as no generic code that supports arm64 uses
> HAVE_KVM, but that may not always be the case, e.g. I stumbled across this
> when exploring hiding perf's guest callbacks behind HAVE_KVM=y.
> 
> Sean Christopherson (2):
>   KVM: arm64: Unconditionally include generic KVM's Kconfig
>   KVM: arm64: Depend on HAVE_KVM => OF instead of directly on OF
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Unconditionally include generic KVM's Kconfig
      commit: c8f1e96734069c788b10545f4fd82bcbb6b55dfa
[2/2] KVM: arm64: Depend on HAVE_KVM => OF instead of directly on OF
      commit: e26bb75aa2f17fc079e6a24dff653b098e1f5d37

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
