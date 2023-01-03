Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C923BC3DA7D
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 17:56:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 308A6411D3;
	Tue,  3 Jan 2023 12:56:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AOukFBYEs3Gr; Tue,  3 Jan 2023 12:56:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CC0C4BB45;
	Tue,  3 Jan 2023 12:56:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD9E54BA88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 12:56:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jobg4ULIA3Ar for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 12:56:16 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5A544BA34
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 12:56:15 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A5034B81076;
 Tue,  3 Jan 2023 17:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69800C433F0;
 Tue,  3 Jan 2023 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672768573;
 bh=bASjt/VEWeldoBQAa+xsMEZuXAK0ZYCNfXSwTOB8GAE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=umSYJHy9XKGc6R1lA1bNKX4EknwSK/Lwc1by42L+nD7RG1GZJYDkzn1/ZxSQ/772A
 FILKGUMQ7IAMvQ/c96h4SP9B7rCE6Dw/K8gPYjPFNeVBvv/M9DXxQvgGzoSSVuscQy
 E+XwCD4CGi68Ji6CEu40UpvqyXjLWJ1eyjAH1SUdyGGPN3jCAksxA6y0knpYK2+b6l
 eH2pJcKHBhMFaXHnXPB6Q4Cky+KG+o/xHBZbc0xejjEUpIWe+KVKcCO9Xu1M0sUgW5
 eBisX1OPuHET0+k52s4Fy5FUN7Yn58FsCk+iAyRJbyH2MsP1iDg+lC7YSn4i+auER1
 xMMmm4vKHOL4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pClWF-00Ga6D-5e;
 Tue, 03 Jan 2023 17:56:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
Date: Tue,  3 Jan 2023 17:56:08 +0000
Message-Id: <167276854454.3239244.4963037118223652100.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103123933.3234865-1-maz@kernel.org>
References: <20230103123933.3234865-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 kvmarm@lists.linux.dev, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

On Tue, 3 Jan 2023 12:39:33 +0000, Marc Zyngier wrote:
> Zenghui has been around for quite some time, and has been instrumental
> in reviewing the GICv4/4.1 KVM support. I'm delighted that he's agreed
> to help with the patch review in a more official capacity!

Applied to fixes, thanks!

[1/1] MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
      commit: f4d488bcbeedf5f625904beef0e1e55d85cb29c9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
