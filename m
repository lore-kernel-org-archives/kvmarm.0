Return-Path: <SRS0=CdlU=TZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C850C04AB0
	for <kvmarm@archiver.kernel.org>; Sat, 25 May 2019 09:11:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EFA4B2168B
	for <kvmarm@archiver.kernel.org>; Sat, 25 May 2019 09:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFA4B2168B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=techsingularity.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3545D4A4E5;
	Sat, 25 May 2019 05:11:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tn6QN3cAkys6; Sat, 25 May 2019 05:11:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AD9B4A4C3;
	Sat, 25 May 2019 05:11:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D52444A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 06:39:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BeiBD3pm8gTg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 May 2019 06:39:27 -0400 (EDT)
Received: from outbound-smtp12.blacknight.com (outbound-smtp12.blacknight.com
 [46.22.139.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 854534A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 06:39:27 -0400 (EDT)
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
 by outbound-smtp12.blacknight.com (Postfix) with ESMTPS id
 4C0681C2220
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 11:39:26 +0100 (IST)
Received: (qmail 32417 invoked from network); 24 May 2019 10:39:26 -0000
Received: from unknown (HELO techsingularity.net)
 (mgorman@techsingularity.net@[37.228.225.79])
 by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated);
 24 May 2019 10:39:26 -0000
Date: Fri, 24 May 2019 11:39:24 +0100
From: Mel Gorman <mgorman@techsingularity.net>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: mm/compaction: BUG: NULL pointer dereference
Message-ID: <20190524103924.GN18914@techsingularity.net>
References: <1558689619-16891-1-git-send-email-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1558689619-16891-1-git-send-email-suzuki.poulose@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Sat, 25 May 2019 05:11:04 -0400
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, May 24, 2019 at 10:20:19AM +0100, Suzuki K Poulose wrote:
> Hi,
> 
> We are hitting NULL pointer dereferences while running stress tests with KVM.
> See splat [0]. The test is to spawn 100 VMs all doing standard debian
> installation (Thanks to Marc's automated scripts, available here [1] ).
> The problem has been reproduced with a better rate of success from 5.1-rc6
> onwards.
> 
> The issue is only reproducible with swapping enabled and the entire
> memory is used up, when swapping heavily. Also this issue is only reproducible
> on only one server with 128GB, which has the following memory layout:
> 
> [32GB@4GB, hole , 96GB@544GB]
> 
> Here is my non-expert analysis of the issue so far.
> 
> Under extreme memory pressure, the kswapd could trigger reset_isolation_suitable()
> to figure out the cached values for migrate/free pfn for a zone, by scanning through
> the entire zone. On our server it does so in the range of [ 0x10_0000, 0xa00_0000 ],
> with the following area of holes : [ 0x20_0000, 0x880_0000 ].
> In the failing case, we end up setting the cached migrate pfn as : 0x508_0000, which
> is right in the center of the zone pfn range. i.e ( 0x10_0000 + 0xa00_0000 ) / 2,
> with reset_migrate = 0x88_4e00, reset_free = 0x10_0000.
> 
> Now these cached values are used by the fast_isolate_freepages() to find a pfn. However,
> since we cant find anything during the search we fall back to using the page belonging
> to the min_pfn (which is the migrate_pfn), without proper checks to see if that is valid
> PFN or not. This is then passed on to fast_isolate_around() which tries to do :
> set_pageblock_skip(page) on the page which blows up due to an NULL mem_section pointer.
> 
> The following patch seems to fix the issue for me, but I am not quite convinced that
> it is the right fix. Thoughts ?
> 

I think the patch is valid and the alternatives would be unnecessarily
complicated. During a normal scan for free pages to isolate, there
is a check for pageblock_pfn_to_page() which uses a pfn_valid check
for non-contiguous zones in __pageblock_pfn_to_page. Now, while the
non-contiguous check could be made in the area you highlight, it would be a
relatively small optimisation that would be unmeasurable overall. However,
it is definitely the case that if the PFN you highlight is invalid that
badness happens. If you want to express this as a signed-off patch with
an adjusted changelog then I'd be happy to add

Reviewed-by: Mel Gorman <mgorman@techsingularity.net>

If you are not comfortable with rewriting the changelog and formatting
it as a patch then I can do it on your behalf and preserve your
Signed-off-by. Just let me know.

Thanks for researching this, I think it also applies to other people but
had not found the time to track it down.

-- 
Mel Gorman
SUSE Labs
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
