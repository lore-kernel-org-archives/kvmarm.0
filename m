Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B401C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Sep 2022 09:59:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B458E4B62F;
	Thu, 29 Sep 2022 05:59:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jl7WNPjjohVQ; Thu, 29 Sep 2022 05:59:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BFA49EEE;
	Thu, 29 Sep 2022 05:59:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61D6141174
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 05:59:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FuEo6vRgnhTc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Sep 2022 05:59:03 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EB7D41049
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 05:59:03 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 45FE860B3E;
 Thu, 29 Sep 2022 09:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E110C433D6;
 Thu, 29 Sep 2022 09:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664445541;
 bh=BXkonWJgpsbuy/26LAupm79T+HxrsMlPk/4p4uUXRTo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=aDBlj/G1IOsJkXqyjv5qcv8M0tQMVA1T5LA3b982kglWFJKx32bLwWZor7TM5g2jj
 LCxrU+pWJhOnzu+D9qYb5CiMvudNJCq0RgHEH+LG18h5Krbpb5CIdOiYzPE0rjURu8
 T5SVhOUprLS1B9vXJKLGL4tKK7ywC08WCAMQ2bqwXwk3eLozc8L7J0lMBNz3KptdTg
 PxA1UhIlxz4m9ON8UCWuwHfl7z3ePkDcXcXBdUqbvkxvdIpQ35bviMj8R284OUgj32
 M8vVSHnIa63L8EF6HbWqqsBRWBAkKp3SWqLzkfnK8K4FNGZnIsurU/KyTdLdM0eXPT
 B1ncciPJQ2D5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1odqJn-00DVVu-IG;
 Thu, 29 Sep 2022 10:58:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Subject: Re: [PATCH] KVM: arm64: Fix comment typo in nvhe/switch.c
Date: Thu, 29 Sep 2022 10:58:57 +0100
Message-Id: <166444538478.3798115.11069322305925080874.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220929042839.24277-1-r09922117@csie.ntu.edu.tw>
References: <20220929042839.24277-1-r09922117@csie.ntu.edu.tw>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: r09922117@csie.ntu.edu.tw, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org,
 alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, 29 Sep 2022 12:28:39 +0800, Wei-Lin Chang wrote:
> Fix the comment of __hyp_vgic_restore_state() from saying VEH to VHE,
> also change the underscore to a dash to match the comment
> above __hyp_vgic_save_state().

Applied to next, thanks!

[1/1] KVM: arm64: Fix comment typo in nvhe/switch.c
      commit: 43b233b1582de501e441deb7c4ed1f944e60b1f9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
