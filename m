Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B109C46467
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 17:57:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7674BB65;
	Tue,  3 Jan 2023 12:57:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pcKbTjfLVPTA; Tue,  3 Jan 2023 12:57:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF32D4BB32;
	Tue,  3 Jan 2023 12:57:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63AC24B906
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 12:57:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zyuZHZG0xXLA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 12:57:40 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23D3F411D3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 12:57:40 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0A4FE614B4;
 Tue,  3 Jan 2023 17:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C139C433D2;
 Tue,  3 Jan 2023 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672768658;
 bh=hUZ2XDvLrwJ9FannznPjhaf3MRrc6OlAN+J+YQi66mg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VWe/pJ0Rk3yxk2m19wCaALmQUCxhnbQi+NVxW6/7FRhaZSCBvm1Lzy0Wa8KPVvU0E
 4k/5NRa4jazSSKLEAl7WZl9WcA817NLvXoL8Qg6P/lV+JZhTAHwPxBRSBrdZVkm5h0
 lrLE/k2emox8Kdejgrli77+/I+4QeUbxD06407yQIh36wEl2YZofrqKmuzEOVXeM1K
 2vDqXCPDJEHPBhWDnBTwrXCsLKDID6l3lpS073aUw5VchrKqEAUpFfC1T9yjgdo1B1
 7HpgObpOkDxbMW166fbPambmCw9PhWFighD1qCqobaJhhwvY/aeiJj81Dd0zfW8wzr
 bHzVaa0m5tAOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pClXb-00Ga8q-9m;
 Tue, 03 Jan 2023 17:57:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Clark <james.clark@arm.com>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Date: Tue,  3 Jan 2023 17:57:32 +0000
Message-Id: <167276864513.3239355.2653412840294598299.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209164446.1972014-1-james.clark@arm.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.clark@arm.com, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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
      commit: edb4929ea9ba48cd91e3867041f49e4c34d729ed

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
