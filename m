Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673E7C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:09:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19ECE49EFE;
	Wed,  2 Mar 2022 09:09:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8o35kzDK9lhG; Wed,  2 Mar 2022 09:09:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 126CA49EEE;
	Wed,  2 Mar 2022 09:09:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5B549EEE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:09:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ccXhItqSq-kQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 09:09:14 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E62D49EED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:09:14 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 23AA0B81FE8;
 Wed,  2 Mar 2022 14:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C62C004E1;
 Wed,  2 Mar 2022 14:09:09 +0000 (UTC)
Date: Wed, 2 Mar 2022 14:09:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Enable Cortex-A510 erratum 2077057 by default
Message-ID: <Yh96ggLwtKAhu7xe@arm.com>
References: <20220225184658.172527-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220225184658.172527-1-broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Feb 25, 2022 at 06:46:58PM +0000, Mark Brown wrote:
> The recently added configuration option for Cortex A510 erratum 2077057 does
> not have a "default y" unlike other errata fixes. This appears to simply be
> an oversight since the help text suggests enabling the option if unsure and
> there's nothing in the commit log to suggest it is intentional.
> 
> Fixes: 1dd498e5e26ad ("KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata")
> Signed-off-by: Mark Brown <broonie@kernel.org>

The fixed commit went in through Marc's KVM tree, so this patch can go
in via the same route. I don't think it's critical for 5.17 (unless
there are pending fixes from Marc already; I don't have any for arm64).

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
