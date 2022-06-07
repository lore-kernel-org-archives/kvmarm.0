Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F93C43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 14:28:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B58C74B34D;
	Tue,  7 Jun 2022 10:28:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cCFzPEeqRADY; Tue,  7 Jun 2022 10:28:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4E04B33E;
	Tue,  7 Jun 2022 10:28:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37EBF4B2FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 10:28:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U6NvmHssFAVj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 10:28:25 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 356E543C72
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 10:28:25 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8159A615DA;
 Tue,  7 Jun 2022 14:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D33C385A5;
 Tue,  7 Jun 2022 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654612103;
 bh=aPLYd3KgtEjQHeA9cBl3JPZVGNS5SWH0+fVtRGJZ+VE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nCBoApsn3vKD2DmhSQk6kJ8oEXtmEpDRV7Ad08bX2Vuq6UBt7nJqu4FW54iTsoaC/
 L8VZ3o5MoeoTrFFtLzihSp9a2Z5FOscnwbp0NmomH5srjeB9NyRfF/RiRP7wSmtcjK
 1ltVwCUW29kRXcVqaqZ8pmujAXBYh6a/8xigk9KCyy5e2tViQGzM3C99N9GWhLXv7d
 b4q6Wh+c8k5B+0nH/m0ccvFOWLeNJ/gsq9iL+Nsh06dGPPnLidHYUcfBrXXnte8mTc
 VXWTxWW7afmsTjhG8M6xMhIGAs6n3uJh688WG91zQgML5Gb7ozZVc1IUZ+63uHlSSB
 MW2q/zjhKaG1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nyaBx-00GCvF-EX; Tue, 07 Jun 2022 15:28:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: james.morse@arm.com, julien.grall@arm.com, catalin.marinas@arm.com,
 sunliming <sunliming@kylinos.cn>, will@kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: fix the inconsistent indenting
Date: Tue,  7 Jun 2022 15:28:10 +0100
Message-Id: <165461208429.127112.9553887915528964109.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602024805.511457-1-sunliming@kylinos.cn>
References: <20220602024805.511457-1-sunliming@kylinos.cn>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, julien.grall@arm.com,
 catalin.marinas@arm.com, sunliming@kylinos.cn, will@kernel.org,
 suzuki.poulose@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kelulanainsley@gmail.com, lkp@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel test robot <lkp@intel.com>, kelulanainsley@gmail.com,
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

On Thu, 2 Jun 2022 10:48:05 +0800, sunliming wrote:
> Fix the inconsistent indenting in function flush_context.
> 
> Fix the following smatch warnings:
> 
> arch/arm64/kvm/vmid.c:62 flush_context() warn: inconsistent indenting

Applied to fixes, thanks!

[1/1] KVM: arm64: fix the inconsistent indenting
      commit: e3fe65e0d3671ee5ae8a2723e429ee4830a7c89c

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
