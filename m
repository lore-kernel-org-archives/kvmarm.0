Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C353C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 13:22:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E54474B1C9;
	Wed,  6 Apr 2022 09:22:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LJ3sqgcL6C4q; Wed,  6 Apr 2022 09:22:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E423F4B1A2;
	Wed,  6 Apr 2022 09:22:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA1F34B18A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 09:22:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lON5jiS3DSLv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 09:22:37 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EB4B4B188
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 09:22:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE14614B3;
 Wed,  6 Apr 2022 13:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C2DC385A7;
 Wed,  6 Apr 2022 13:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649251356;
 bh=TLyvTgiqSYYjMHPC+UQMx0cLGBFAbPTGSNIZDD5qmEE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=BRcBrf+6Ca4lrZIXmPFpnu3aoqjnUw8Z6cGxpjYO6fDettqwmZVCSZOBIDjbNq5YO
 i5dzuDYR466yR9B0fywX8ZLS4PfkvRVA3d5dgswxve5JR04uo5sl6q1eF5FS8iRgbt
 GwlSaGapzZSML6khLQC38qPSgzf4Vcu6K0tQvETDYD/0PA4/4eAakoulI0mdHDq+UM
 E9gaEVbSo/U0Ob/Nj1VCvMzAms8bYJaOpLrryGksX2erF/kPMQhBcBmkF5A4NqPuoz
 Qw94e16voGukyrwBeUu708IJvfk0MmtInmz6xMhBXUBoPGp45bobwDs9thZs76CmOW
 M53nCiiglPPcQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nc5cH-002AfU-Jz; Wed, 06 Apr 2022 14:22:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 Yu Zhe <yuzhe@nfschina.com>, james.morse@arm.com
Subject: Re: [PATCH] KVM: arm64: vgic: remove unnecessary type castings
Date: Wed,  6 Apr 2022 14:22:31 +0100
Message-Id: <164925133306.3716042.8666897986559310118.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329102059.268983-1-yuzhe@nfschina.com>
References: <20220328103836.2829-1-yuzhe@nfschina.com>
 <20220329102059.268983-1-yuzhe@nfschina.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 yuzhe@nfschina.com, james.morse@arm.com, keescook@chromium.org,
 ricarkol@google.com, justin.he@arm.com, linux-arm-kernel@lists.infradead.org,
 samitolvanen@google.com, kernel-janitors@vger.kernel.org,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: justin.he@arm.com, keescook@chromium.org, catalin.marinas@arm.com,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 samitolvanen@google.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tue, 29 Mar 2022 03:20:59 -0700, Yu Zhe wrote:
> remove unnecessary casts.

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: remove unnecessary type castings
      commit: c707663e81ef48d279719e97fd86acef835a2671

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
