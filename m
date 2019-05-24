Return-Path: <SRS0=F0YX=TY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F019C46470
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 10:43:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1422B2184B
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 10:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1422B2184B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 765F24A4BE;
	Fri, 24 May 2019 06:43:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DvtcfKKPCyNy; Fri, 24 May 2019 06:43:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21ACF4A4C2;
	Fri, 24 May 2019 06:43:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3C3A4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 06:42:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RcOoWyUi2uNo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 May 2019 06:42:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 725BD4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 06:42:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D473B374;
 Fri, 24 May 2019 03:42:57 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5690D3F703;
 Fri, 24 May 2019 03:42:56 -0700 (PDT)
Subject: Re: mm/compaction: BUG: NULL pointer dereference
To: mgorman@techsingularity.net
References: <1558689619-16891-1-git-send-email-suzuki.poulose@arm.com>
 <20190524103924.GN18914@techsingularity.net>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <98b93f38-64a7-dcd1-c027-6d1195f3380f@arm.com>
Date: Fri, 24 May 2019 11:42:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524103924.GN18914@techsingularity.net>
Content-Language: en-US
Cc: mhocko@suse.com, kvm@vger.kernel.org, marc.zyngier@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cai@lca.pw,
 akpm@linux-foundation.org, kvmarm@lists.cs.columbia.edu
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

Hi Mel,

Thanks for your quick response.

On 24/05/2019 11:39, Mel Gorman wrote:
> On Fri, May 24, 2019 at 10:20:19AM +0100, Suzuki K Poulose wrote:
>> Hi,
>>
>> We are hitting NULL pointer dereferences while running stress tests with KVM.
>> See splat [0]. The test is to spawn 100 VMs all doing standard debian
>> installation (Thanks to Marc's automated scripts, available here [1] ).
>> The problem has been reproduced with a better rate of success from 5.1-rc6
>> onwards.
>>
>> The issue is only reproducible with swapping enabled and the entire
>> memory is used up, when swapping heavily. Also this issue is only reproducible
>> on only one server with 128GB, which has the following memory layout:
>>
>> [32GB@4GB, hole , 96GB@544GB]
>>
>> Here is my non-expert analysis of the issue so far.
>>
>> Under extreme memory pressure, the kswapd could trigger reset_isolation_suitable()
>> to figure out the cached values for migrate/free pfn for a zone, by scanning through
>> the entire zone. On our server it does so in the range of [ 0x10_0000, 0xa00_0000 ],
>> with the following area of holes : [ 0x20_0000, 0x880_0000 ].
>> In the failing case, we end up setting the cached migrate pfn as : 0x508_0000, which
>> is right in the center of the zone pfn range. i.e ( 0x10_0000 + 0xa00_0000 ) / 2,
>> with reset_migrate = 0x88_4e00, reset_free = 0x10_0000.
>>
>> Now these cached values are used by the fast_isolate_freepages() to find a pfn. However,
>> since we cant find anything during the search we fall back to using the page belonging
>> to the min_pfn (which is the migrate_pfn), without proper checks to see if that is valid
>> PFN or not. This is then passed on to fast_isolate_around() which tries to do :
>> set_pageblock_skip(page) on the page which blows up due to an NULL mem_section pointer.
>>
>> The following patch seems to fix the issue for me, but I am not quite convinced that
>> it is the right fix. Thoughts ?
>>
> 
> I think the patch is valid and the alternatives would be unnecessarily
> complicated. During a normal scan for free pages to isolate, there
> is a check for pageblock_pfn_to_page() which uses a pfn_valid check
> for non-contiguous zones in __pageblock_pfn_to_page. Now, while the

I had the initial version with the pageblock_pfn_to_page(), but as you said,
it is a complicated way of perform the same check as pfn_valid().

> non-contiguous check could be made in the area you highlight, it would be a
> relatively small optimisation that would be unmeasurable overall. However,
> it is definitely the case that if the PFN you highlight is invalid that
> badness happens. If you want to express this as a signed-off patch with
> an adjusted changelog then I'd be happy to add

Sure, will send it right away.

> 
> Reviewed-by: Mel Gorman <mgorman@techsingularity.net>
> 

Thanks.

Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
