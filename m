Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA18CC4321E
	for <kvmarm@archiver.kernel.org>; Mon,  5 Dec 2022 14:42:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F5204B199;
	Mon,  5 Dec 2022 09:42:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VhpL9JZrphp6; Mon,  5 Dec 2022 09:42:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F01B940B75;
	Mon,  5 Dec 2022 09:42:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5478A40B75
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 09:42:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dz8+c63pU4Tz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 09:42:27 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C16A4042A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 09:42:27 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C7760B810C5;
 Mon,  5 Dec 2022 14:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839EBC433D6;
 Mon,  5 Dec 2022 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1670251344;
 bh=qgfnbCONh6FE2YPb3DvzapxvL2v1U5EvlqaAsa6tm6A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ym0d1Jh6A00n9rOi3ngnAxCcHCfd7ayber2mRhH/bj/SQrXleGoeu3+kfkqcxSlEk
 pfRcGGUVxUlchm1jiJdrK/JhW7aKAQWvjgVD7Q4Zy7b0S2ZuZ0gGGbGRznwITDrCfM
 lCKGRL8M6SW4J0WsviEkl1QSZFCxYBm6vvePoXTTDmhvg/xKMyBgOKjpyVipf1rPhm
 KgGqHqUaN8D3jvjnppZavy6xD6SQiTglgo63cTaV9rR1xRCS6hUREHG2q3Gx7jL0lP
 tphI9Vjn+MxBu3P6KuX9PGpnrrCwS93J467BGzWrKbo5Ityh2JKB5HxqptTvbpI/Q3
 zoMUZCCFlkgNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1p2Cfm-00Aat6-3T;
 Mon, 05 Dec 2022 14:42:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v1] KVM: arm64: Fix benign bug with incorrect use of
 VA_BITS.
Date: Mon,  5 Dec 2022 14:42:18 +0000
Message-Id: <167025133280.231752.10614963931118046339.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205114031.3972780-1-ryan.roberts@arm.com>
References: <20221205114031.3972780-1-ryan.roberts@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Mon, 5 Dec 2022 11:40:31 +0000, Ryan Roberts wrote:
> get_user_mapping_size() uses kvm's pgtable library to walk a user space
> page table created by the kernel, and in doing so, fakes up the metadata
> that the library needs, including ia_bits, which defines the size of the
> input address.
> 
> For the case where the kernel is compiled for 52 VA bits but runs on HW
> that does not support LVA, it will fall back to 48 VA bits at runtime.
> Therefore we must use vabits_actual rather than VA_BITS to get the true
> address size.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix benign bug with incorrect use of VA_BITS.
      commit: 219072c09abde0f1d0a6ce091be375e8eb7d08f0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
