Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D384C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 15:55:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8055960E98
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 15:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8055960E98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B9F14A19A;
	Mon, 11 Oct 2021 11:55:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0E9CeEOP7Uc3; Mon, 11 Oct 2021 11:55:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3441449F5D;
	Mon, 11 Oct 2021 11:55:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA0A49F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 11:55:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JhNsqREqg1RG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 11:55:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D61340630
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 11:55:50 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5C0AA60E98;
 Mon, 11 Oct 2021 15:55:48 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mZxeU-00G454-1s; Mon, 11 Oct 2021 16:55:46 +0100
From: Marc Zyngier <maz@kernel.org>
To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, will@kernel.org,
 corbet@lwn.net, Alexandru Elisei <alexandru.elisei@arm.com>,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: admin-guide: Document side effects when
 pKVM is enabled
Date: Mon, 11 Oct 2021 16:55:42 +0100
Message-Id: <163396773657.855753.9209725646924595792.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011153835.291147-1-alexandru.elisei@arm.com>
References: <20211011153835.291147-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 will@kernel.org, corbet@lwn.net, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com,
 linux-doc@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Mon, 11 Oct 2021 16:38:35 +0100, Alexandru Elisei wrote:
> Recent changes to KVM for arm64 has made it impossible for the host to
> hibernate or use kexec when protected mode is enabled via the kernel
> command line.
> 
> There are people who rely on kexec (for example, developers who use kexec
> as a quick way to test a new kernel), let's document this change in
> behaviour, so it doesn't catch them by surprise and we have a place to
> point people to if it does.

Applied to next, thanks!

[1/1] Documentation: admin-guide: Document side effects when pKVM is enabled
      commit: 53e8ce137f7b34bd7a54429d18e0d0e5f56f54e8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
