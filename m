Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646A3C43465
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 10:28:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA66021D7B
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 10:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNyaO/4Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA66021D7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC9E4B454;
	Fri, 18 Sep 2020 06:28:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fhLvKI2vZc2A; Fri, 18 Sep 2020 06:28:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A81244B45B;
	Fri, 18 Sep 2020 06:28:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D304B44B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 06:28:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7MOZ5qo-Jn44 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 06:28:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2484B3B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 06:28:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600424897;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hr8z2HiMXzzbN2LrjLF0Nl8J3Aoy3w81O76x25EfTuo=;
 b=QNyaO/4Qrbi0mFpuQumBonRwKtiudlwqgenSgMLdVArtgMHwiA3U13sEEIrFYg7VP/NK64
 7wZbwPIzmowqD6snTd2RdpDOpq+yWcXn9zcYsvhxyBj/7iPB8ca+24lpBsGsaPiS8k6nmg
 xgCYjIr0lOm18yH9hwWYN5Azu7oe/JY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-NZl6CcNMN3KIFgRdDbQgDQ-1; Fri, 18 Sep 2020 06:28:15 -0400
X-MC-Unique: NZl6CcNMN3KIFgRdDbQgDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D7666408E;
 Fri, 18 Sep 2020 10:28:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 495EE60C53;
 Fri, 18 Sep 2020 10:28:11 +0000 (UTC)
Date: Fri, 18 Sep 2020 12:28:08 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC v2 1/7] arm64: add a helper function to traverse
 arm64_ftr_regs
Message-ID: <20200918102808.gwpk6ggy36prq7iv@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-2-liangpeng10@huawei.com>
 <20200918071820.e6hghta4yclio7ca@kamzik.brq.redhat.com>
 <00293b67-e9bb-3ad1-d6db-adb35bcacba6@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <00293b67-e9bb-3ad1-d6db-adb35bcacba6@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Sep 18, 2020 at 05:24:27PM +0800, Peng Liang wrote:
> On 9/18/2020 3:18 PM, Andrew Jones wrote:
> > On Thu, Sep 17, 2020 at 08:00:55PM +0800, Peng Liang wrote:
> >> If we want to emulate ID registers, we need to initialize ID registers
> >> firstly.  This commit is to add a helper function to traverse
> >> arm64_ftr_regs so that we can initialize ID registers from
> >> arm64_ftr_regs.
> >>
> >> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> >> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> >> ---
> >>  arch/arm64/include/asm/cpufeature.h |  2 ++
> >>  arch/arm64/kernel/cpufeature.c      | 13 +++++++++++++
> >>  2 files changed, 15 insertions(+)
> >>
> >> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> >> index 89b4f0142c28..2ba7c4f11d8a 100644
> >> --- a/arch/arm64/include/asm/cpufeature.h
> >> +++ b/arch/arm64/include/asm/cpufeature.h
> >> @@ -79,6 +79,8 @@ struct arm64_ftr_reg {
> >>  
> >>  extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
> >>  
> >> +int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp);
> >> +
> >>  /*
> >>   * CPU capabilities:
> >>   *
> >> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> >> index 6424584be01e..698b32705544 100644
> >> --- a/arch/arm64/kernel/cpufeature.c
> >> +++ b/arch/arm64/kernel/cpufeature.c
> >> @@ -1112,6 +1112,19 @@ u64 read_sanitised_ftr_reg(u32 id)
> >>  	return regp->sys_val;
> >>  }
> >>  
> >> +int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp)
> >> +{
> >> +	int i, ret;
> >> +
> >> +	for (i = 0; i <  ARRAY_SIZE(arm64_ftr_regs); i++) {
> >> +		ret = (*op)(arm64_ftr_regs[i].sys_id,
> >> +			    arm64_ftr_regs[i].reg->sys_val, argp);
> >> +		if (ret < 0)
> >> +			return ret;
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >>  #define read_sysreg_case(r)	\
> >>  	case r:		return read_sysreg_s(r)
> >>  
> >> -- 
> >> 2.26.2
> >>
> > 
> > Skimming the rest of the patches to see how this is used I only saw a
> > single callsite. Why wouldn't we just put this simple for-loop right
> > there at that callsite? Or, IOW, I think this traverse function should
> > be dropped.
> > 
> > Thanks,
> > drew
> > 
> > .
> > 
> 
> arm64_ftr_regs is defined as a static array in arch/arm64/kernel/cpufeature.c,
> which is not a virtualization-related file.  Putting this simple for-loop
> right there will make cpufeature.c depend on kvm_host.h.  Is this a good idea?

Well, the fact that arm64_ftr_regs is static to cpufeature.c is a clue
that your implementation is likely playing with internal arm64_ftr
state that it shouldn't be. If there's not an accessor function that
works for you, then you can try adding one. Providing general functions
like this, that are effectively just an odd way of removing 'static'
from arm64_ftr_regs, breaks the encapsulation.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
