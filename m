Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8194BC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 09:01:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C64154C03C;
	Wed,  6 Jul 2022 05:01:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7dRUZJsYXRg1; Wed,  6 Jul 2022 05:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97CE24C01B;
	Wed,  6 Jul 2022 05:01:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2921C4BF44
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 05:01:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YmIsFZO4zl3V for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 05:01:07 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFCA14BEE0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 05:01:07 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4BC07B81B31;
 Wed,  6 Jul 2022 09:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1BAC3411C;
 Wed,  6 Jul 2022 09:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657098065;
 bh=O5vfaJOmY630S2iHMOlIuDMP+z2m4nLFH7uCskj1on4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=CzA8UfW/I+II685vuTyCAKfooW2Cq099Oh1HZOkqOQtkLW5tIQNnLHzw9Xy+z1S4A
 nEDOXvzmB4BcQBa3PNv6R7C/jUK7LnT5SvnhQMwHlLmq1A+IFgupp1qOdk1rc99mPu
 bekuL/Qsqg0lGPbKd2oRufOtJfOfaqeQAor6WXg6qwd8/YunGN+B10LuDcI+0+hn7J
 XkMsgBeI6gN5RRiQGpdN3vZVCDL/EZVxMPWhcoEbVFKDiTEz6h7M2TdT6WHFP9jvO4
 Y5LewcW69v7JmWmEl8lDvsD7ltOSnTtol7pTtsjR3TI8UdqUxIKpzQ+2/uTdUyp0V8
 Xw4XxwiSjVz1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o90u6-005Zti-TJ;
 Wed, 06 Jul 2022 10:01:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Quentin Perret <qperret@google.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Don't return from void function
Date: Wed,  6 Jul 2022 10:00:58 +0100
Message-Id: <165709805020.885966.4815879973915586287.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220705142310.3847918-1-qperret@google.com>
References: <20220705142310.3847918-1-qperret@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, will@kernel.org,
 alexandru.elisei@arm.com, oliver.upton@linux.dev,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, qperret@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, kernel-team@android.com
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

On Tue, 5 Jul 2022 14:23:10 +0000, Quentin Perret wrote:
> Although harmless, the return statement in kvm_unexpected_el2_exception
> is rather confusing as the function itself has a void return type. The
> C standard is also pretty clear that "A return statement with an
> expression shall not appear in a function whose return type is void".
> Given that this return statement does not seem to add any actual value,
> let's not pointlessly violate the standard.
> 
> [...]

Applied to kvm-arm64/misc-5.20, thanks!

[1/1] KVM: arm64: Don't return from void function
      commit: 1c3ace2b8b3995d3213c5e2d2aca01a0577a3b0f

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
