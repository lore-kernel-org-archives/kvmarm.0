Return-Path: <SRS0=nwVD=36=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D92C352A3
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 16:38:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1915120842
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 16:38:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1915120842
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD3504A5A6;
	Mon, 10 Feb 2020 11:37:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hPsB63DYr-ZI; Mon, 10 Feb 2020 11:37:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 937554A7FD;
	Mon, 10 Feb 2020 11:37:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C2284A5A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 11:37:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id umCw0sbx5Mgg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Feb 2020 11:37:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 587B14A50F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 11:37:56 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD3F81FB;
 Mon, 10 Feb 2020 08:37:55 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCBAE3F68F;
 Mon, 10 Feb 2020 08:37:54 -0800 (PST)
Subject: Re: [PATCH 1/2] arm64: cpufeature: add cpus_have_final_cap()
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
References: <20200210122708.38826-1-mark.rutland@arm.com>
 <20200210122708.38826-2-mark.rutland@arm.com>
From: Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <047f1cd2-3537-6671-233c-69f1758684bf@arm.com>
Date: Mon, 10 Feb 2020 16:37:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200210122708.38826-2-mark.rutland@arm.com>
Content-Language: en-US
Cc: catalin.marinas@arm.com, maz@kernel.org, will@kernel.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 10/02/2020 12:27, Mark Rutland wrote:
> When cpus_have_const_cap() was originally introduced it was intended to
> be safe in hyp context, where it is not safe to access the cpu_hwcaps
> array as cpus_have_cap() did. For more details see commit:
> 
>    a4023f682739439b ("arm64: Add hypervisor safe helper for checking constant capabilities")
> 
> We then made use of cpus_have_const_cap() throughout the kernel.
> 
> Subsequently, we had to defer updating the static_key associated with
> each capability in order to avoid lockdep complaints. To avoid breaking
> kernel-wide usage of cpus_have_const_cap(), this was updated to fall
> back to the cpu_hwcaps array if called before the static_keys were
> updated. As the kvm hyp code was only called later than this, the
> fallback is redundant but not functionally harmful. For more details,
> see commit:
> 
>    63a1e1c95e60e798 ("arm64/cpufeature: don't use mutex in bringup path")
> 
> Today we have more users of cpus_have_const_cap() which are only called
> once the relevant static keys are initialized, and it would be
> beneficial to avoid the redundant code.
> 
> To that end, this patch adds a new cpus_have_final_cap(), helper which
> is intend to be used in code which is only run once capabilities have
> been finalized, and will never check the cpus_hwcap array. This helps
> the compiler to generate better code as it no longer needs to generate
> code to address and test the cpus_hwcap array. To help catch misuse,
> cpus_have_final_cap() will BUG() if called before capabilities are
> finalized.
> 
> In hyp context, BUG() will result in a hyp panic, but the specific BUG()
> instance will not be identified in the usual way.
> 
> Comments are added to the various cpus_have_*_cap() helpers to describe
> the constraints on when they can be used. For clarity cpus_have_cap() is
> moved above the other helpers.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Suzuki Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will@kernel.org>
> ---

...

> +/*
> + * Test for a capability without a runtime check.
> + *
> + * Before capabilities are finalized, this will BUG().
> + * After capabilities are finalized, this is patched to avoid a runtime check.
> + *
> + * @num must be a compile-time constant.
> + */
> +static __always_inline bool cpus_have_final_cap(int num)
> +{
> +	if (static_branch_likely(&arm64_const_caps_ready))

We have introduced system_capabilities_finalized() helper and may be
it is a good idea to use it here, to make it more clear.

Either ways :

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
