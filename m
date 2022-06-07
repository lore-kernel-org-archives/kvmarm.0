Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A1CC43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 15:27:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C59944B323;
	Tue,  7 Jun 2022 11:27:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q7AMN68P21Pt; Tue,  7 Jun 2022 11:27:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4684B332;
	Tue,  7 Jun 2022 11:27:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C914B308
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 11:27:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6lptOC3g5wFa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 11:27:21 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 183F84B2D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 11:27:21 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C0785B8212A;
 Tue,  7 Jun 2022 15:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D23C385A5;
 Tue,  7 Jun 2022 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654615638;
 bh=ueyRcXFv7rEb7tdf83066lmJl8gE/lV6HoeLB5Uk8VM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=QKZ659VVSj3rE2txIcfea6nvbu90HicYGxlDUpKKJtmSZcGmMVt2NkIlC9S8fhddd
 Fj28+BkA2aQd3hIOvxQIELcVqba7Y/CSsfaAXK1CmjGKj7oqmx3I2ZtFamJtvGOvvY
 WZUZOQgkNYLV/5aD5dVkhwQ7TSYtsuhNEP+0shTOkUcDWcVou3GDhw/AKPBCvIv9oh
 KFOEjxkxI0+34PY6qUFXvtnzLanT7PW6Vv/35LWGZ1DnJFhFq7suD3/2cAEW/rR9hc
 yWlxJM0ukla5O1GLb+EWWo9D8faRE1Iyc3cV7e29/dMw11p7vkfBJ979KznEJZWYez
 lVJA95gt+d6ZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nyb6y-00GDdG-0G; Tue, 07 Jun 2022 16:27:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: (subset) [PATCH v2 0/3] KVM: arm64: Fix userspace access to HW
 pending state
Date: Tue,  7 Jun 2022 16:27:12 +0100
Message-Id: <165461559010.127313.6746590114309145143.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220607131427.1164881-1-maz@kernel.org>
References: <20220607131427.1164881-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

On Tue, 7 Jun 2022 14:14:24 +0100, Marc Zyngier wrote:
> This is a followup from [1], which aims at fixing userspace access to
> interrupt pending state for HW interrupts.
> 
> * From v1 [1]:
>   - Keep some of the GICv3-specifics around to avoid regressing the
>     line vs latch distinction (Eric).
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Don't read a HW interrupt pending state in user context
      commit: bfb5ed4097c75917da5c8a74ab236b5acc703d08

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
