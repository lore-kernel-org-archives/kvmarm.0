Return-Path: <SRS0=T7gh=UM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A42C31E45
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 07:31:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89F7920866
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 07:31:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89F7920866
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFB6F4A517;
	Thu, 13 Jun 2019 03:30:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UBGjcOA6dHqA; Thu, 13 Jun 2019 03:30:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 979C94A50A;
	Thu, 13 Jun 2019 03:30:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AE5C4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 03:30:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1yrUBX4Q5d1L for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jun 2019 03:30:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 031B14A4A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 03:30:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C403367;
 Thu, 13 Jun 2019 00:30:55 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 629243F73C;
 Thu, 13 Jun 2019 00:30:54 -0700 (PDT)
Subject: Re: [PATCH v9 4/5] KVM: arm/arm64: remove pmc->bitmask
To: Andrew Murray <andrew.murray@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
References: <20190612190450.7085-1-andrew.murray@arm.com>
 <20190612190450.7085-5-andrew.murray@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <6a8e4fdd-d8cf-f3fb-55cd-2d06805b0eb9@arm.com>
Date: Thu, 13 Jun 2019 08:30:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190612190450.7085-5-andrew.murray@arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Andrew,

On 12/06/2019 20:04, Andrew Murray wrote:
> We currently use pmc->bitmask to determine the width of the pmc - however
> it's superfluous as the pmc index already describes if the pmc is a cycle
> counter or event counter. The architecture clearly describes the widths of
> these counters.
> 
> Let's remove the bitmask to simplify the code.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  include/kvm/arm_pmu.h |  1 -
>  virt/kvm/arm/pmu.c    | 19 +++++++++----------
>  2 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index b73f31baca52..2f0e28dc5a9e 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -28,7 +28,6 @@
>  struct kvm_pmc {
>  	u8 idx;	/* index into the pmu->pmc array */
>  	struct perf_event *perf_event;
> -	u64 bitmask;
>  };
>  
>  struct kvm_pmu {
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index ae1e886d4a1a..88ce24ae0b45 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -47,7 +47,10 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  		counter += perf_event_read_value(pmc->perf_event, &enabled,
>  						 &running);
>  
> -	return counter & pmc->bitmask;
> +	if (select_idx != ARMV8_PMU_CYCLE_IDX)
> +		counter = lower_32_bits(counter);

Shouldn't this depend on PMCR.LC as well? If PMCR.LC is clear we only
want the lower 32bits of the cycle counter.

Cheers,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
