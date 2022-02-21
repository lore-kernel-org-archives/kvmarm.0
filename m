Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B562CC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 16:12:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F05A4B1DB;
	Mon, 21 Feb 2022 11:12:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J9UPxE3jU9VQ; Mon, 21 Feb 2022 11:12:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F23E4B1E9;
	Mon, 21 Feb 2022 11:12:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9A384B1D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 11:12:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4I3JaslsTDE5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 11:12:07 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71C474B1C9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 11:12:07 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 784926127C;
 Mon, 21 Feb 2022 16:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96318C340E9;
 Mon, 21 Feb 2022 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645459925;
 bh=rXfYkjzMAd8gqYTCzojHWpfwxEm4+OnkWI5i3lL+9ic=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=MxshJQ1icfflQrnleTm8HLn+UKRNxYK8zEuDZa6gc5GPXUAXqQeCExC7H2pDmeqPe
 6RanQJrtlxXUkfVDNV6eEqT0wHZbEC6+odFk+yC8jsrf5jsU48lZLaqx2XBFbTBv/z
 P2z18arSS3fxYeXvvEbjK8cA2RJcIYQpQAEQdWXOB3FbbQYPiEW5uq55s11XAHUL+r
 912LMQXXFt/wen+jdjqvY8B0+UhHEL4DcwTYbpKFOKrbZABb7DnoXW9g8PwLc/vMZ/
 yipIgyl3OUsVlT6lDkvjXeN6EPLUSU6g0mSq541orb0M+lnjTZoMIFEdvzz0HFgf1T
 5bzOTxq5CjBcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nMBIB-009LKw-BR; Mon, 21 Feb 2022 16:12:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/3] Plumb PSCI SYSTEM_RESET2 call for guests
Date: Mon, 21 Feb 2022 16:11:59 +0000
Message-Id: <164545991160.12907.13490221046797691154.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220221153524.15397-1-will@kernel.org>
References: <20220221153524.15397-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, will@kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org
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

On Mon, 21 Feb 2022 15:35:21 +0000, Will Deacon wrote:
> Here's version two of the patches I posted at the end of last week:
> 
>   https://lore.kernel.org/r/20220217184001.11753-1-will@kernel.org
> 
> The only change is to the comments and ABI documentation, so that we
> refer to the PSCI spec instead of describing the arguments to RESET2.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Bump guest PSCI version to 1.1
      commit: 512865d83fd9685a4d5aab26f898737b57d3187e
[2/3] KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest
      commit: d43583b890e7cb0078d13d056753a56602b92406
[3/3] KVM: arm64: Indicate SYSTEM_RESET2 in kvm_run::system_event flags field
      commit: 34739fd95fab3a5efb0422e4f012b685e33598dc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
