Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15ACBC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:37:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86F3360F0F
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:37:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 86F3360F0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A3BB4B11F;
	Wed, 27 Oct 2021 03:37:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8idZC0TPCLcq; Wed, 27 Oct 2021 03:37:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A5324A193;
	Wed, 27 Oct 2021 03:37:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2B884A193
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 03:37:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jRJzEisw5e4j for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 03:37:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A63E49F6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 03:37:15 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 349F560C4A;
 Wed, 27 Oct 2021 07:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1635320232;
 bh=FRBog1tZWZi2KIk+C4NUR+287z9q0T1v5SYwsgJ3a2Q=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hp+D7l/0metU0vwZubbT50AhWOWxepnxz0aH+R3ssX2EAovAtfr052vm79z9WYEiG
 YDt62rrku7de17CVxCGQadznxkw2+eUKD2SHhrF1myXTv/0rgKyxRlQPkWl+z26LvZ
 K8gyUdC65IM1Tfc65K3NRs5hL6VpSk8iFiATxITZFQvjIWGnu/JzsB3XDEoN0d3mQV
 pJEsMz24F5nGVaIIR3IqpYvSHApsT7/fkbqLC35iIKgyFMCqHrMGa3U6RW/jvuWAo0
 IIhV7fDrHKRDoUHx1NvXJRQBeENzm01Zh/UAK2aJcTgihnUtz+cwv8Bxhbjvlb4n0c
 uIHeBvvg1Yz7w==
Date: Wed, 27 Oct 2021 08:37:07 +0100
From: Will Deacon <will@kernel.org>
To: Qian Cai <quic_qiancai@quicinc.com>
Subject: Re: [PATCH] KVM: arm64: Remove unused TRNG_NO_ENTROPY
Message-ID: <20211027073707.GB22231@willie-the-truck>
References: <20211026210913.57006-1-quic_qiancai@quicinc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211026210913.57006-1-quic_qiancai@quicinc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Oct 26, 2021 at 05:09:13PM -0400, Qian Cai wrote:
> TRNG_NO_ENTROPY was unused when introduced and now. This is also caught by
> GCC (W=2):
> 
> arch/arm64/kvm/trng.c:17: warning: macro "TRNG_NO_ENTROPY" is not used [-Wunused-macros]
>    17 | #define TRNG_NO_ENTROPY   ((unsigned long)-3)

This return value is defined by the TRNG SMCCC spec (Arm DEN0098) so I'd
rather just keep it around given that it's not causing any problems.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
