Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE94C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 14:05:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BAC749F14;
	Tue,  4 Jan 2022 09:05:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MgcFmUZuq7Kb; Tue,  4 Jan 2022 09:05:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E98649F4D;
	Tue,  4 Jan 2022 09:05:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C7749F14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 09:05:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XS6t3JFOfcY9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 09:05:27 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9DDF49EFD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 09:05:27 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9F1E6613EF;
 Tue,  4 Jan 2022 14:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F2BC36AE9;
 Tue,  4 Jan 2022 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1641305126;
 bh=bhl5UyJyteuv6QbsNSocnsvA1DaSc46ypy3s1vY6NFM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RDBJE1ochkvUckxJi/f4xkX89R0d6oE+kmNu/v+9+qzOcv0gmZt5tXts7x3xsujoW
 ED9cm29Iww8YZxAuJCRvDFZsjGu+e2dYwg0XzfYlvlPTRdRmbuVdTIdE/CVmPg7cvL
 xCbvMaMXMoTRutSqSs/DBuK433vqo85CZUtfekAl7af7d1TlaHG4HhvZQZeiSOwfhV
 PfFcnFpgdEMnxXa0aDW71xtwYD28qHc/vBY/elsbYvdSfCh4Kgv2WpewcAcfjxdCSF
 4ivPQL3ilUfaiXu1hzG+kmmozmJ3YCfdpZdQS8EYd92o0AvhpBinpT/WcAbA9kx60Z
 BOQJt2rkvj6Ww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n4kRI-00FvXP-5q; Tue, 04 Jan 2022 14:05:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Fix comment typo in kvm_vcpu_finalize_sve()
Date: Tue,  4 Jan 2022 14:05:19 +0000
Message-Id: <164130511055.3362481.10306211546953262745.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211230141535.1389-1-yuzenghui@huawei.com>
References: <20211230141535.1389-1-yuzenghui@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 yuzenghui@huawei.com, kernel.yuz@gmail.com, suzuki.poulose@arm.com,
 james.morse@arm.com, alexandru.elisei@arm.com, wanghaibin.wang@huawei.com
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

On Thu, 30 Dec 2021 22:15:35 +0800, Zenghui Yu wrote:
> kvm_arm_init_arch_resources() was renamed to kvm_arm_init_sve() in
> commit a3be836df7cb ("KVM: arm/arm64: Demote
> kvm_arm_init_arch_resources() to just set up SVE"). Fix the function
> name in comment of kvm_vcpu_finalize_sve().

Applied to next, thanks!

[1/1] KVM: arm64: Fix comment typo in kvm_vcpu_finalize_sve()
      commit: e938eddbeb85f4c0c47e56cd9e09ee196ea1bc1a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
