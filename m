Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93105C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 10:45:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E22356145B
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 10:45:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E22356145B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47F6C4B4EC;
	Thu, 22 Apr 2021 06:45:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XaghfdF6ePVZ; Thu, 22 Apr 2021 06:45:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FFBE4B4B4;
	Thu, 22 Apr 2021 06:45:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A97F4B49F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 06:45:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OhgYaz4lOCqY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 06:45:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFA8F4B413
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 06:45:53 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ECAD613C4;
 Thu, 22 Apr 2021 10:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619088352;
 bh=TGwnKk/RxvquNuLw5D+m/omaHgTDQoSOY+tpVfcrgEM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=L5yfjC8lbYuMRmPdHO6ptjp8eu5N99h7ZnBGiGzWGeTtqdJ9kqbZhWDy4q7gtd5YY
 RVr5CfV6tOpE5eZ0AU+6jk3WUcB0ub0Xyl5HgWucC/jQ85emuUQyVQV9fXj2MtyzHd
 ZsGp1DQwGyyJEPO5pQ4X+VHXCoadt6N5AfN+HmoIoO3whD55gR1/KXElfJlV2z7PeD
 4tt0krHZ4CZFGIDZpDOoUCCE0DQA2r4qIs0r1LLBKX+FmXnsZ7FZ1yS0OPQvjkDVCU
 umqonzbStYcdoLStaZ4vVJyqHYxmqKwuRzg8o/BpGT9FTcWQuBn4nYIeOiYZ31Avxv
 FDk5QCVI4sT8w==
Date: Thu, 22 Apr 2021 11:45:46 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/5] arm64: Get rid of oprofile leftovers
Message-ID: <20210422104545.GD1442@willie-the-truck>
References: <20210414134409.1266357-1-maz@kernel.org>
 <20210414134409.1266357-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210414134409.1266357-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-s390@vger.kernel.org, Rich Felker <dalias@libc.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, kvm@vger.kernel.org,
 linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Heiko Carstens <hca@linux.ibm.com>,
 linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 nathan@kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Apr 14, 2021 at 02:44:06PM +0100, Marc Zyngier wrote:
> perf_pmu_name() and perf_num_counters() are now unused. Drop them.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/perf/arm_pmu.c | 30 ------------------------------
>  1 file changed, 30 deletions(-)

Nice! This was some of the first code I ever wrote in the kernel but I can't
say I miss it:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
