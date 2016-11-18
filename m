From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Fri, 18 Nov 2016 11:57:43 +0100
Message-ID: <20161118105743.szrsnahvvhuavfc2@kamzik.brq.redhat.com>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
 <20161116174544.GE11228@leverpostej>
 <20161117164541.uwmearukm3zcwahh@hawk.localdomain>
 <20161117174751.GD21742@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161117174751.GD21742@leverpostej>
Sender: kvm-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, pbonzini@redhat.com, shannon.zhao@linaro.org, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 17, 2016 at 05:47:51PM +0000, Mark Rutland wrote:
> On Thu, Nov 17, 2016 at 05:45:41PM +0100, Andrew Jones wrote:
> > Hi Mark,
> > 
> > On Wed, Nov 16, 2016 at 05:45:44PM +0000, Mark Rutland wrote:
> > > So I don't think we should try to distinguish ARMv8-A AArch32 from
> > > ARMv7-A. We should test individual features, or if that's not possible,
> > > group them in the same bucket.
> > 
> > Perhaps I was too quick to look for a general way to approach the first
> > place I saw the need, which is
> > 
> >  check_cntr(read_pmccntr());
> >  if (is_aarch64())
> >      check_cntr(read_pmccntr64());
> > 
> > Is PMCCNTR the only "weird" difference?
> 
> Define "weird". ;)
> 
> I believe the extension of PMCCNTR to 64 bits is part of PMUv3. So you
> should be able to check ID_DFR0.PerfMon == 0b0011. For overflow you'll
> also need to configure PMCR.LC.

Thanks Mark,

checking for ID_DFR0.PerfMon == 0b0011 for this case does indeed look
like the right thing to do.

Wei,

when you respin the PMU test can you add the additional 64-bit read,
when a PMUv3 is present?

Thanks,
drew


> 
> Thanks,
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
