Return-Path: <SRS0=CdlU=TZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668F5C282E5
	for <kvmarm@archiver.kernel.org>; Sat, 25 May 2019 09:11:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B49D21848
	for <kvmarm@archiver.kernel.org>; Sat, 25 May 2019 09:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B49D21848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=techsingularity.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0C364A4C3;
	Sat, 25 May 2019 05:11:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K+0cZwGz2-+0; Sat, 25 May 2019 05:11:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACFBE4A4EB;
	Sat, 25 May 2019 05:11:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 910564A47A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 08:30:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pgJ4PFv7-hIt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 May 2019 08:30:50 -0400 (EDT)
Received: from outbound-smtp19.blacknight.com (outbound-smtp19.blacknight.com
 [46.22.139.246])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B9894A479
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 08:30:50 -0400 (EDT)
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
 by outbound-smtp19.blacknight.com (Postfix) with ESMTPS id
 257F51C274E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 13:30:49 +0100 (IST)
Received: (qmail 27446 invoked from network); 24 May 2019 12:30:49 -0000
Received: from unknown (HELO techsingularity.net)
 (mgorman@techsingularity.net@[37.228.225.79])
 by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated);
 24 May 2019 12:30:48 -0000
Date: Fri, 24 May 2019 13:30:47 +0100
From: Mel Gorman <mgorman@techsingularity.net>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: mm/compaction: BUG: NULL pointer dereference
Message-ID: <20190524123047.GO18914@techsingularity.net>
References: <1558689619-16891-1-git-send-email-suzuki.poulose@arm.com>
 <cfddd75a-b302-5557-05b8-2b328bba27c8@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cfddd75a-b302-5557-05b8-2b328bba27c8@arm.com>
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

On Fri, May 24, 2019 at 04:26:16PM +0530, Anshuman Khandual wrote:
> 
> 
> On 05/24/2019 02:50 PM, Suzuki K Poulose wrote:
> > Hi,
> > 
> > We are hitting NULL pointer dereferences while running stress tests with KVM.
> > See splat [0]. The test is to spawn 100 VMs all doing standard debian
> > installation (Thanks to Marc's automated scripts, available here [1] ).
> > The problem has been reproduced with a better rate of success from 5.1-rc6
> > onwards.
> > 
> > The issue is only reproducible with swapping enabled and the entire
> > memory is used up, when swapping heavily. Also this issue is only reproducible
> > on only one server with 128GB, which has the following memory layout:
> > 
> > [32GB@4GB, hole , 96GB@544GB]
> > 
> > Here is my non-expert analysis of the issue so far.
> > 
> > Under extreme memory pressure, the kswapd could trigger reset_isolation_suitable()
> > to figure out the cached values for migrate/free pfn for a zone, by scanning through
> > the entire zone. On our server it does so in the range of [ 0x10_0000, 0xa00_0000 ],
> > with the following area of holes : [ 0x20_0000, 0x880_0000 ].
> > In the failing case, we end up setting the cached migrate pfn as : 0x508_0000, which
> > is right in the center of the zone pfn range. i.e ( 0x10_0000 + 0xa00_0000 ) / 2,
> > with reset_migrate = 0x88_4e00, reset_free = 0x10_0000.
> > 
> > Now these cached values are used by the fast_isolate_freepages() to find a pfn. However,
> > since we cant find anything during the search we fall back to using the page belonging
> > to the min_pfn (which is the migrate_pfn), without proper checks to see if that is valid
> > PFN or not. This is then passed on to fast_isolate_around() which tries to do :
> > set_pageblock_skip(page) on the page which blows up due to an NULL mem_section pointer.
> > 
> > The following patch seems to fix the issue for me, but I am not quite convinced that
> > it is the right fix. Thoughts ?
> > 
> > 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index 9febc8c..9e1b9ac 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -1399,7 +1399,7 @@ fast_isolate_freepages(struct compact_control *cc)
> >  				page = pfn_to_page(highest);
> >  				cc->free_pfn = highest;
> >  			} else {
> > -				if (cc->direct_compaction) {
> > +				if (cc->direct_compaction && pfn_valid(min_pfn)) {
> >  					page = pfn_to_page(min_pfn);
> 
> pfn_to_online_page() here would be better as it does not add pfn_valid() cost on
> architectures which does not subscribe to CONFIG_HOLES_IN_ZONE. But regardless if
> the compaction is trying to scan pfns in zone holes, then it should be avoided.

CONFIG_HOLES_IN_ZONE typically applies in special cases where an arch
punches holes within a section. As both do a section lookup, the cost is
similar but pfn_valid in general is less subtle in this case. Normally
pfn_valid_within is only ok when a pfn_valid check has been made on the
max_order aligned range as well as a zone boundary check. In this case,
it's much more straight-forward to leave it as pfn_valid.

-- 
Mel Gorman
SUSE Labs
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
