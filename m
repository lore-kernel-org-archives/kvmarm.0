Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F73CCA47B
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 15:41:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D5794B3B6;
	Fri,  1 Jul 2022 11:41:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vRpUuDN6JgfT; Fri,  1 Jul 2022 11:41:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 323D74B606;
	Fri,  1 Jul 2022 11:41:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD63F4B378
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 11:41:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AMBT5MlXym1R for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2022 11:41:44 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FD9E4B607
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 11:41:44 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id AF6966245B;
 Fri,  1 Jul 2022 15:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50929C385A5;
 Fri,  1 Jul 2022 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656690103;
 bh=KtpcW/Ij79Xo4GJ+n802wbSYDEeHSXn8ShvdFzaWm2E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ExWPAZscdSHmU86zgOAGVKTzNkyQUySq20+/UNsDN9USyAVTM8wu1jjCUpZLK/keL
 nLrTYFXoN5kHae8RQY3w1XDTz9QbVlq6rav7d0/aFVyT9DGT7DCmEp28x/kx+xFs+K
 xrBPPQ27bApY2+pmIk3uAXygCVcAgdZMtcAyyyP+Vq7BP2T2jqwqLFYh5JysrAMlB1
 GAyR9wPucZeUb1S2SAaWViUGSVl3nzRdZ/SQiYE1FStGb9M0VMSUlfIe2RwIU+4Ukx
 Bao4AmQtPWJyO1ub6+8bXGRgPpAm3YYwFQjoR/pxDxteYq8PcBb4nSxrS+kzjZIRqN
 dr+pRI4mXdNiA==
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
 Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool] arm: gic: fdt: fix PPI CPU mask calculation
Date: Fri,  1 Jul 2022 16:41:25 +0100
Message-Id: <165668798833.3744902.12084627427900181326.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220616145526.3337196-1-andre.przywara@arm.com>
References: <20220616145526.3337196-1-andre.przywara@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
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

On Thu, 16 Jun 2022 15:55:26 +0100, Andre Przywara wrote:
> The GICv2 DT binding describes the third cell in each interrupt
> descriptor as holding the trigger type, but also the CPU mask that this
> IRQ applies to, in bits [15:8]. However this is not the case for GICv3,
> where we don't use a CPU mask in the third cell: a simple mask wouldn't
> fit for the many more supported cores anyway.
> 
> At the moment we fill this CPU mask field regardless of the GIC type,
> for the PMU and arch timer DT nodes. This is not only the wrong thing to
> do in case of a GICv3, but also triggers UBSAN splats when using more
> than 30 cores, as we do shifting beyond what a u32 can hold:
> $ lkvm run -k Image -c 31 --pmu
> arm/timer.c:13:22: runtime error: left shift of 1 by 31 places cannot be represented in type 'int'
> arm/timer.c:13:38: runtime error: signed integer overflow: -2147483648 - 1 cannot be represented in type 'int'
> arm/timer.c:13:43: runtime error: left shift of 2147483647 by 8 places cannot be represented in type 'int'
> arm/aarch64/pmu.c:202:22: runtime error: left shift of 1 by 31 places cannot be represented in type 'int'
> arm/aarch64/pmu.c:202:38: runtime error: signed integer overflow: -2147483648 - 1 cannot be represented in type 'int'
> arm/aarch64/pmu.c:202:43: runtime error: left shift of 2147483647 by 8 places cannot be represented in type 'int'
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] arm: gic: fdt: fix PPI CPU mask calculation
      https://git.kernel.org/will/kvmtool/c/d9fdaad02dfd

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
