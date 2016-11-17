From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Thu, 17 Nov 2016 17:59:48 +0100
Message-ID: <20161117165948.lajsuwyrkgrtpvbd@hawk.localdomain>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
 <38d079b9-c693-65ea-1e32-4e3c9ea7b91c@arm.com>
 <bb33f1ca-c47c-90b3-668d-e51101c2e642@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1D4401E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 11:59:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id etz8TSn-E2EK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 11:59:22 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B05E401BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 11:59:21 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <bb33f1ca-c47c-90b3-668d-e51101c2e642@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, shannon.zhao@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 16, 2016 at 05:02:59PM -0500, Christopher Covington wrote:
> On 11/16/2016 12:46 PM, Marc Zyngier wrote:
> > On 16/11/16 14:38, Andrew Jones wrote:
> >> ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
> >> function allows unit tests to make the distinction.
> > 
> > Hi Drew,
> > 
> > Overall, having to find out about the architecture is a bad idea most of
> > the time. We have feature registers for most things, and it definitely
> > makes more sense to check for those than trying to cast a wider net.
> > 
> >>
> >> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >>
> >> ---
> >> I'm actually unsure if there's a feature bit or not that I could
> >> probe instead. It'd be nice if somebody can confirm. Thanks, drew
> 
> I'd be happy to settle with the hard-coded CPU list.
> 
> But if you're curious about alternatives, I've taken a look through some
> documentation. ID_ISAR0.coproc describes whether mrrc is available but
> I think it is generally available on v7 and above. I think ID_ISAR5 will
> be zero on v7 and nonzero on v8-A32. But PMCR.LC seems like the best bit
> to check.
> 
> >> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> >> index 84d5c7ce752b..b602e1fbbc2d 100644
> >> --- a/lib/arm64/asm/processor.h
> >> +++ b/lib/arm64/asm/processor.h
> >> @@ -81,5 +81,10 @@ DEFINE_GET_SYSREG32(mpidr)
> >>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
> >>  extern bool is_user(void);
> >>  
> >> +static inline bool is_aarch32(void)
> >> +{
> >> +	return false;
> >> +}
> >> +
> >>  #endif /* !__ASSEMBLY__ */
> >>  #endif /* _ASMARM64_PROCESSOR_H_ */
> >>
> > 
> > So the real question is: what are you trying to check for?
> 
> The question is "how many bits wide is pmccntr?" I think we
> can test whether writing PMCR.LC = 1 sticks. Based on the
> documentation, it seems to me like it wouldn't for v7 and
> would for v8-A32.
> 
> uint8_t size_pmccntr(void) {
>   uint32_t pmcr = get_pmcr();
>   if (pmcr & PMU_PMCR_LC_MASK)
>     return 64;
>   set_pmcr(pmcr | (1 << PMU_PMCR_LC_SHIFT));
>   if (get_pmcr() & PMU_PMCR_LC_MASK)
>     return 64;
>   return 32;
> }

Thanks for this Cov. I mostly agree with the proposal, except for two
reasons; the spec says the bit is UNK/SBZP for v7, which doesn't give
me 100% confidence that we can rely on it behaving a certain way. And,
I'd rather not rely on the emulation we're testing to work well enough
that we can probe it.

For our PMU testing purposes there is a somewhat ugly, but foolproof
way to manage it; we could just add a command line input that says
we're aarch32 (-cpu host,aarch64=off -append aarch32)

I'm still hoping we can come up with a general way to implement an
is_aarch32() though, assuming we'll want it elsewhere in tests.
Although that assumption may be wrong...

Thanks,
drew
 

> 
> Thanks,
> Cov
> 
> -- 
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
> Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
> Aurora Forum, a Linux Foundation Collaborative Project.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
