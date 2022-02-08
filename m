Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26033C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:37:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8AFA4B091;
	Tue,  8 Feb 2022 12:37:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PPdHpZTdQGoP; Tue,  8 Feb 2022 12:37:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B3774B137;
	Tue,  8 Feb 2022 12:37:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2974B0FC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tYgQXwElgZ1Q for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:37:24 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D5914B091
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:24 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DBD77617D9;
 Tue,  8 Feb 2022 17:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1672C340ED;
 Tue,  8 Feb 2022 17:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644341843;
 bh=zoVcBqBlFwWw4RwkCbOIV8HYffhswg6RiqAJtljMnUQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Q3AoQVNnP7igB2TprzpCi2ThBw0PugrptAC7v0i6BjLMB9THldE31bY6T/6GWTxLa
 AgUbFb1y2lpN+ptzuAF0hcilHqg7AiFR83ydAzQzWf9y6+bcXT3oz+5BzPXeGj/rNF
 lq92p4pWyYhWFGHsP1f9T1+K2LJoCXykOFqb6waeAWpsgAqZTDgL4hcFySIMTtkORK
 Gbghp790s7OK6Ox8FpAszG8CB5u3c0tqRvJmRjta8yRQU9+DFsaqs1QzeBzmHCLryB
 f+NspBdl1yc3LELltLmR6OLeuNrlQp1V9vID7GmdImhuAU3GK44KTLPg4T4GxN9Ydr
 oCrprPUC70RMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nHUQb-006KsD-Pi; Tue, 08 Feb 2022 17:37:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Keir Fraser <keirf@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] KVM: arm64: pkvm: Implement CONFIG_DEBUG_LIST at Hyp
Date: Tue,  8 Feb 2022 17:37:20 +0000
Message-Id: <164434147328.3931943.15101620519718026308.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220131124114.3103337-1-keirf@google.com>
References: <20220131124114.3103337-1-keirf@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: keirf@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 wangkefeng.wang@huawei.com, tabba@google.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, samitolvanen@google.com, qperret@google.com,
 will@kernel.org, keescook@chromium.org, james.morse@arm.com,
 alexandru.elisei@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Kees Cook <keescook@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>
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

On Mon, 31 Jan 2022 12:40:53 +0000, Keir Fraser wrote:
> Currently the check functions are stubbed out at EL2. Implement
> versions suitable for the constrained EL2 environment.

Applied to next, thanks!

[1/1] KVM: arm64: pkvm: Implement CONFIG_DEBUG_LIST at Hyp
      commit: 4c68d6c0a1757139c791ccf1a781cbd81e35a063

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
