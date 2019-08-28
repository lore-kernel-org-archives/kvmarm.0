Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC2BC3A5A1
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 16:19:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEB4E2173E
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 16:19:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEB4E2173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 394914A52F;
	Wed, 28 Aug 2019 12:19:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jpasKS8Cao7W; Wed, 28 Aug 2019 12:19:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E46E4A54B;
	Wed, 28 Aug 2019 12:19:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0C34A537
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 12:19:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MMh2li774Cbm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 12:19:26 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43BA44A4E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 12:19:26 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 17B255AFDE;
 Wed, 28 Aug 2019 16:19:25 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D8F05D9C9;
 Wed, 28 Aug 2019 16:19:23 +0000 (UTC)
Date: Wed, 28 Aug 2019 18:19:20 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 10/16] lib: Add UL and ULL definitions
 to linux/const.h
Message-ID: <20190828161920.6w7jfl7gcofozun7@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-11-git-send-email-alexandru.elisei@arm.com>
 <20190828151006.x6bfxlseqp5s55su@kamzik.brq.redhat.com>
 <c476a2cc-98d7-6315-a742-df252ff56be5@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c476a2cc-98d7-6315-a742-df252ff56be5@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.39]); Wed, 28 Aug 2019 16:19:25 +0000 (UTC)
Cc: kvm@vger.kernel.org, maz@kernel.org, andre.przywara@arm.com,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Aug 28, 2019 at 04:46:04PM +0100, Alexandru Elisei wrote:
> On 8/28/19 4:10 PM, Andrew Jones wrote:
> > On Wed, Aug 28, 2019 at 02:38:25PM +0100, Alexandru Elisei wrote:
> >> The UL macro was previously defined in lib/arm64/asm/pgtable-hwdef.h. Move
> >> it to lib/linux/const.h so it can be used in other files. To keep things
> >> consistent, also add an ULL macro.
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  lib/linux/const.h             | 7 +++++--
> >>  lib/arm64/asm/pgtable-hwdef.h | 2 --
> >>  2 files changed, 5 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/lib/linux/const.h b/lib/linux/const.h
> >> index c872bfd25e13..e3c7fec3f4b8 100644
> >> --- a/lib/linux/const.h
> >> +++ b/lib/linux/const.h
> >> @@ -21,7 +21,10 @@
> >>  #define _AT(T,X)	((T)(X))
> >>  #endif
> >>  
> >> -#define _BITUL(x)	(_AC(1,UL) << (x))
> >> -#define _BITULL(x)	(_AC(1,ULL) << (x))
> >> +#define UL(x) 		_AC(x, UL)
> >> +#define ULL(x)		_AC(x, ULL)
> >> +
> >> +#define _BITUL(x)	(UL(1) << (x))
> >> +#define _BITULL(x)	(ULL(1) << (x))
> > I don't mind this, but if we want to keep this file consistent with
> > Linux's include/uapi/linux/const.h, which is actually the goal, then we
> > should be adding _UL and _ULL instead. But in that case we'd probably
> > want to leave the define below.
> >
> > Thanks,
> > drew
> 
> Hm... The next patch needs the UL define. Consistency is good, so if we want to
> keep it consistent with include/uapi/linux/const.h, then I will change the
> defines (and the uses) to _UL and _ULL, if that's fine with you.

Yeah, I think that's best.

Thanks,
drew

> 
> Thanks,
> Alex
> >
> >>  
> >>  #endif /* !(_LINUX_CONST_H) */
> >> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
> >> index 045a3ce12645..e6f02fae4075 100644
> >> --- a/lib/arm64/asm/pgtable-hwdef.h
> >> +++ b/lib/arm64/asm/pgtable-hwdef.h
> >> @@ -9,8 +9,6 @@
> >>   * This work is licensed under the terms of the GNU GPL, version 2.
> >>   */
> >>  
> >> -#define UL(x) _AC(x, UL)
> >> -
> >>  #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
> >>  
> >>  /*
> >> -- 
> >> 2.7.4
> >>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
