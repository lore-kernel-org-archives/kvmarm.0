From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 2/8] arm: KVM: Add optimized PIPT icache flushing
Date: Sat, 21 Oct 2017 17:18:17 +0200
Message-ID: <20171021151817.GE12618@cbox>
References: <20171020154904.31427-1-marc.zyngier@arm.com>
 <20171020154904.31427-3-marc.zyngier@arm.com>
 <20171020162711.2mb2wyw5xqfhkc4o@lakrids.cambridge.arm.com>
 <d0dd031b-976f-0a77-9b63-8807aa8f9b4b@arm.com>
 <20171020165440.sdqfdyt6jsmbjcx5@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D19949D17
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Oct 2017 11:17:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jPO1lJqbtNFB for <kvmarm@lists.cs.columbia.edu>;
 Sat, 21 Oct 2017 11:17:09 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C54A406D0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Oct 2017 11:17:09 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id k4so2682841wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Oct 2017 08:18:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171020165440.sdqfdyt6jsmbjcx5@lakrids.cambridge.arm.com>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20, 2017 at 05:54:40PM +0100, Mark Rutland wrote:
> On Fri, Oct 20, 2017 at 05:53:39PM +0100, Marc Zyngier wrote:
> > Hi Mark,
> > 
> > On 20/10/17 17:27, Mark Rutland wrote:
> > > Hi Marc,
> > > 
> > > On Fri, Oct 20, 2017 at 04:48:58PM +0100, Marc Zyngier wrote:
> > >> @@ -181,18 +185,40 @@ static inline void __invalidate_icache_guest_page(struct kvm_vcpu *vcpu,
> > >>  		return;
> > >>  	}
> > >>  
> > >> -	/* PIPT cache. As for the d-side, use a temporary kernel mapping. */
> > >> +	/*
> > >> +	 * CTR IminLine contains Log2 of the number of words in the
> > >> +	 * cache line, so we can get the number of words as
> > >> +	 * 2 << (IminLine - 1).  To get the number of bytes, we
> > >> +	 * multiply by 4 (the number of bytes in a 32-bit word), and
> > >> +	 * get 4 << (IminLine).
> > >> +	 */
> > >> +	iclsz = 4 << (read_cpuid(CPUID_CACHETYPE) & 0xf);
> > >> +
> > >>  	while (size) {
> > >>  		void *va = kmap_atomic_pfn(pfn);
> > >> +		void *end = va + PAGE_SIZE;
> > >> +		void *addr = va;
> > >>  
> > >> -		__cpuc_coherent_user_range((unsigned long)va,
> > >> -					   (unsigned long)va + PAGE_SIZE);
> > >> +		do {
> > >> +			write_sysreg(addr, ICIMVAU);
> > >> +			addr += iclsz;
> > >> +		} while (addr < end);
> > >> +
> > >> +		dsb(ishst);
> > > 
> > > I believe this needs to be ISH rather than ISHST.
> > > 
> > > Per, ARM DDI 0487B.b, page G3-4701, "G3.4 AArch32 cache and branch
> > > predictor support":
> > > 
> > >     A DSB or DMB instruction intended to ensure the completion of cache
> > >     maintenance instructions or branch predictor instructions must have
> > >     an access type of both loads and stores.
> > 
> > Right. This actually comes from 6abdd491698a ("ARM: mm: use
> > inner-shareable barriers for TLB and user cache operations"), and the
> > ARMv7 ARM doesn't mention any of this.
> 
> Ah; so it doesn't. :/
> 
> > My take is that we want to be consistent. Given that KVM/ARM on 32bit is
> > basically ARMv7 only, I'd rather keep the ST version of the barrier
> > here, and change it everywhere if/when someone decides to support a
> > 32bit kernel on ARMv8 (yes, we already do as a guest, but it doesn't
> > seem to really matter so far).
> 
> Keeping things consistent makes sense to me.
> 

Does that mea this is an ack/reviewed-by ?


Thanks,
-Christoffer
