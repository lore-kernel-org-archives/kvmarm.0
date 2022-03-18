Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D89C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 14:07:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F48749F02;
	Fri, 18 Mar 2022 10:07:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AB44JkDu3aiJ; Fri, 18 Mar 2022 10:07:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 545C649EFF;
	Fri, 18 Mar 2022 10:07:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B80049EEA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 10:07:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G5cGn3dXZ4op for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 10:07:47 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8169F49EBF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 10:07:47 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DF34061A44;
 Fri, 18 Mar 2022 14:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF8CC340E8;
 Fri, 18 Mar 2022 14:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647612466;
 bh=6/qgX4VsYNnji//fdZoQeDNIf2p1YkUCR7TjkqdZtpw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=T0CYtkxiIyiTg/I8iNxQYQS0pKjEug7xKQ0rPiFckKyyMbBkXqUKGykOLnfz/cnw6
 GrEGfEiTa6lyTHRE/IkKM/eouuIj3V2BnZCWBUpmzbMNraXHF6yDrwQa0FOGGwhQ9c
 FKhxYxQKTZ79+Qjk/dfX5k4kuUSQL2JUMJC4vj0u8fsCV6bdjEu6SEtc0pDgIX6tC1
 5vA0LWfLvqsoUJGyw0cJw8hxmCY95/zorirvuRBgxP88WhPrfNhf5FBlgo5ZhNwnK1
 Sc0/xZkf+VQQs5c7x2952lsZRPom7eqPZ4cFlnlGgXjF3SaCq+Rt5bMRDyy4XWD+V1
 dElewf3DmAXRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nVDGa-00FSU4-5V; Fri, 18 Mar 2022 14:07:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [PATCH] KVM: arm64: fix typos in comments
Date: Fri, 18 Mar 2022 14:07:37 +0000
Message-Id: <164761240231.2295955.754353604300597232.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318103729.157574-24-Julia.Lawall@inria.fr>
References: <20220318103729.157574-24-Julia.Lawall@inria.fr>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: Julia.Lawall@inria.fr, james.morse@arm.com, will@kernel.org,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

On Fri, 18 Mar 2022 11:37:19 +0100, Julia Lawall wrote:
> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.

Applied to next, thanks!

[1/1] KVM: arm64: fix typos in comments
      commit: 21ea457842759a236eefed2cfaa8cc7e5dc967a0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
