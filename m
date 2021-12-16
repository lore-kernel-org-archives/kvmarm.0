Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8489BC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 17:20:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEBE74B2FB;
	Thu, 16 Dec 2021 12:20:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ccUs-XLw30vR; Thu, 16 Dec 2021 12:20:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C34A84B2A3;
	Thu, 16 Dec 2021 12:20:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B278E4B29D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 12:20:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 63WyOQZI41rA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 12:20:07 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8CBD4B29C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 12:20:07 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 29A21B82461;
 Thu, 16 Dec 2021 17:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EA5C36AE4;
 Thu, 16 Dec 2021 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639675205;
 bh=DmJfUcVa4WEqw43aPD7aqrGwtV991ysCoXXGRte8rfs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GPfIYfhhoIQdTv3KtxoKer/kqPUZbH6iRehQhuTNeMIsNx7kUjQmxZKSYhhqVBpKT
 LjLlUbTcsuxjyrorzpSRBCpAGuCZeGjTg/474oqq2+MONhNgz/n60z6sQx4Bpg33+G
 M5QX3YONFJZG8/NvXcbCXC3G9uwWqRvxPElbfKsWqb61anv1LFtBRBV16q+zwgIQjF
 UmYhFWBtYo/+Lqx8dN/uscJUU61qWpIOr7EjmgT1lGpuAuyvlY7mkzDs00lbT/XOFS
 e/hUfeE+dFKHPHHeRdQk+wHOF1XdbCFtu1v++kSOgl6LbPhzWS9n3sQPAy+toNMx5P
 CLNJWmK5q+45A==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxuQE-00CaTQ-TO; Thu, 16 Dec 2021 17:20:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: (subset) [PATCH v5 00/69] KVM: arm64: ARMv8.3/8.4 Nested
 Virtualization support
Date: Thu, 16 Dec 2021 17:19:55 +0000
Message-Id: <163967515734.1690660.13878910598737761364.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 andre.przywara@arm.com, gankulkarni@os.amperecomputing.com,
 christoffer.dall@arm.com, kernel-team@android.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 Christoffer Dall <christoffer.dall@arm.com>
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

On Mon, 29 Nov 2021 20:00:41 +0000, Marc Zyngier wrote:
> Here the bi-annual drop of the KVM/arm64 NV support code, the least
> loved series in the history of KVM!
> 
> Not a lot has changed since [1]: a number of bug fixes (wrong MMU
> context being selected leading to failing TLB invalidations, fixes
> around the handling of nested faults), a complete rewrite of the early
> exit handling, a change in the way the NV support is enabled
> ("kvm-arm.mode=nested"), and a rebase on top of 5.16-rc1.
> 
> [...]

Applied to next, thanks!

[04/69] KVM: arm64: Rework kvm_pgtable initialisation
        commit: 9d8604b28575ccab3afd8d6f56cab9a6c0d281ef

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
