Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566A2C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 10:43:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87263613C3
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 10:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87263613C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB174B4F4;
	Thu, 22 Apr 2021 06:43:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 62kjqeBYHECt; Thu, 22 Apr 2021 06:43:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07F2C4B47E;
	Thu, 22 Apr 2021 06:43:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F0F34B43E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 06:43:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C5KacMg1c8bD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 06:43:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43C174B413
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 06:43:37 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3FB613C3;
 Thu, 22 Apr 2021 10:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619088214;
 bh=R8WtOHNj+/vk47cusAz7Di0unsa6rOD5nce0ZJvBbNA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Pv3lOJjOC3h2kDfka9ri27gZcUMB8VEyrTNgwHgulcfk5rxqf4vWQAs+9f4/gOkt4
 q1K3IywZtSZmfuAuIV1QlMAUjPELcnGmE+E6Q026430OI045oc9fdo7XHAtntCWx98
 HrWrGalnCPFn5nmiuwtowUrC/HJgymZi/N/SPpHeF+WemaKXveP8zNQFVsLG2r+1U5
 HbcS8855VzvPFetj1B3nDnzltb2SYqfePUXA1jdPD22flPn/kWQngnV9RR9Z/YwqoY
 26f/HjDjK0J7nMqMw15ZClfInqScIhZ30PQLcQAPeEphwJqk8EnwbzQZC3oFbWjVKj
 m58DmUXn1KEpQ==
Date: Thu, 22 Apr 2021 11:43:27 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/5] KVM: arm64: Divorce the perf code from oprofile
 helpers
Message-ID: <20210422104327.GC1442@willie-the-truck>
References: <20210414134409.1266357-1-maz@kernel.org>
 <20210414134409.1266357-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210414134409.1266357-2-maz@kernel.org>
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

On Wed, Apr 14, 2021 at 02:44:05PM +0100, Marc Zyngier wrote:
> KVM/arm64 is the sole user of perf_num_counters(), and really
> could do without it. Stop using the obsolete API by relying on
> the existing probing code.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/perf.c     | 7 +------
>  arch/arm64/kvm/pmu-emul.c | 2 +-
>  include/kvm/arm_pmu.h     | 4 ++++
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
> index 739164324afe..b8b398670ef2 100644
> --- a/arch/arm64/kvm/perf.c
> +++ b/arch/arm64/kvm/perf.c
> @@ -50,12 +50,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
>  
>  int kvm_perf_init(void)
>  {
> -	/*
> -	 * Check if HW_PERF_EVENTS are supported by checking the number of
> -	 * hardware performance counters. This could ensure the presence of
> -	 * a physical PMU and CONFIG_PERF_EVENT is selected.
> -	 */
> -	if (IS_ENABLED(CONFIG_ARM_PMU) && perf_num_counters() > 0)
> +	if (kvm_pmu_probe_pmuver() != 0xf)

Took me a while to figure out that this returns 0xf if the hardware has a
PMUVer of 0x0, so it's all good:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
