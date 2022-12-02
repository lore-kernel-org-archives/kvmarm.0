Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253CEC4321E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 11:18:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5F840C23;
	Fri,  2 Dec 2022 06:18:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I1TFLZFdbQwz; Fri,  2 Dec 2022 06:18:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59B5843399;
	Fri,  2 Dec 2022 06:18:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A34C40C23
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 06:17:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OLbcf1grpkJW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 06:17:58 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A01E40B92
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 06:17:58 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E49776225D;
 Fri,  2 Dec 2022 11:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0C2C43470;
 Fri,  2 Dec 2022 11:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1669979876;
 bh=+Z1MWlojIRA1QnTq1ioenobi9ADsvAqAO/dbKIkbqjE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=HubRNWXyGURblb7IaT99ORDq0RAytki48Py2iNBMKtLeEmIUw5kIR4/XIgr4IAHnb
 4T5KMpEae2eaNa7TyLUEd6Jf5aJxTwdPg3i049crdrYVGshKHGxlyW8UtpX2tYvM3N
 iUaVu3gx+8/Wg+/HfEeH6INCWGDqyTf/dl3s6olUARfaU0Octbd45SN+lSvEgHdF/x
 hSF/nIr0hi/kFUbfmn6f6jmSDB146ZbSOK6oIw0gs0G93El+mNtgNAG1RLHrs9/YE5
 +FsQzyQI9l1Tjaw810VXs/t3Dr/GHcC7x9Cew+fzI95CBaRFe+edZLpDXN6ISfoc2r
 UvUHlrSFy6Vpw==
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Quentin Perret <qperret@google.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Andrew Walbran <qwandor@google.com>,
 Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 00/12] KVM: arm64: FF-A proxy for pKVM
Date: Fri,  2 Dec 2022 11:17:43 +0000
Message-Id: <166990989276.390165.11951641189203574187.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
References: <20221116170335.2341003-1-qperret@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
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

On Wed, 16 Nov 2022 17:03:23 +0000, Quentin Perret wrote:
> pKVM's primary goal is to protect guest pages from a compromised host by
> enforcing access control restrictions using stage-2 page-tables. Sadly,
> this cannot prevent TrustZone from accessing non-secure memory, and a
> compromised host could, for example, perform a 'confused deputy' attack
> by asking TrustZone to use pages that have been donated to protected
> guests. This would effectively allow the host to have TrustZone
> exfiltrate guest secrets on its behalf, hence breaking the isolation
> that pKVM intends to provide.
> 
> [...]

Applied first two cleanups to arm64 (for-next/ffa), thanks!

[01/12] firmware: arm_ffa: Move constants to header file
        https://git.kernel.org/arm64/c/229d58e31678
[02/12] firmware: arm_ffa: Move comment before the field it is documenting
        https://git.kernel.org/arm64/c/c8e320b00a2a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
