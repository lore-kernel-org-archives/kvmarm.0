Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A68C04FDE
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 09:08:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 852F54B93E;
	Mon, 12 Dec 2022 04:08:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qPLrb-ZtiD4O; Mon, 12 Dec 2022 04:08:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87A5A4B99D;
	Mon, 12 Dec 2022 04:08:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5594B99D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 04:08:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tmdrd4gUNGwd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 04:08:20 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0AE614B99B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 04:08:19 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A1C06B80B67;
 Mon, 12 Dec 2022 09:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E674C433D2;
 Mon, 12 Dec 2022 09:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1670836097;
 bh=z5HqcNfQJi1MaenD9RiDHiFMXvNXPXoJXEhKMYHhZY4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=InVOrkT1F1aLJT+4NIgtTnatQBkkM198K5TAlHCJ8DXZyGYDgCMCcXDT0eXeJz3c2
 OhCJHYPme4sbb5dZ565a7cKK1qaCiXEYnJXWXdWME12pIlCCH/ACPMXWctIjtXW60f
 IuquRiVR6GDD+fIAHNt6VCVJTZdv9i9JOkl/eqcqPqxoBMDPgSI2SrFb2+v/4ERFVd
 FwO3vmlhycWZHL/qgN6p9nBfu58Pq619zffjzAZeRkpY32bmPFV9B/0vIzup6X1FPT
 8XEuC6uh+1O9G054kGOYlyrFGYScTrFqJ6xZb4ApBVv5sbXNDxSuv7Ammblp9CCKKA
 nqMt4EAnyZwyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1p4enG-00C3aO-WF;
 Mon, 12 Dec 2022 09:08:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	James Clark <james.clark@arm.com>
Subject: Re: [PATCH 0/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Date: Mon, 12 Dec 2022 09:08:11 +0000
Message-Id: <167083608669.635334.13408416430959494147.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209164446.1972014-1-james.clark@arm.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, james.clark@arm.com,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Fri, 9 Dec 2022 16:44:45 +0000, James Clark wrote:
> We noticed qemu failing to run because of an assert on our CI. I don't see the issue anymore with
> this fix.
> 
> Applies to kvmarm/next (753d734f3f34)
> 
> Thanks
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
      commit: aff234839f8b80ac101e6c2f14d0e44b236efa48

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
