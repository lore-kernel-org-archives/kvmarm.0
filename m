From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Thu, 17 Nov 2016 17:45:41 +0100
Message-ID: <20161117164541.uwmearukm3zcwahh@hawk.localdomain>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
 <20161116174544.GE11228@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83BB440284
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 11:45:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V2627jgiuvzX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 11:45:13 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA0CF4022C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 11:45:13 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161116174544.GE11228@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On Wed, Nov 16, 2016 at 05:45:44PM +0000, Mark Rutland wrote:
> On Wed, Nov 16, 2016 at 03:38:36PM +0100, Andrew Jones wrote:
> > ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
> > function allows unit tests to make the distinction.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > ---
> > I'm actually unsure if there's a feature bit or not that I could
> > probe instead. It'd be nice if somebody can confirm. Thanks, drew
> 
> > +/*
> > + * ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
> > + * function allows unit tests to make the distinction.
> > + */
> 
> What do you want this for, specifically?
> 
> Since the CPUID registers were introduced, the architecture goes to
> great lengths to not expose a version, and trying to guess from software
> is a losing battle.
> 
> So I don't think we should try to distinguish ARMv8-A AArch32 from
> ARMv7-A. We should test individual features, or if that's not possible,
> group them in the same bucket.

Perhaps I was too quick to look for a general way to approach the first
place I saw the need, which is

 check_cntr(read_pmccntr());
 if (is_aarch64())
     check_cntr(read_pmccntr64());

Is PMCCNTR the only "weird" difference?

Thanks,
drew

> 
> Thanks,
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
