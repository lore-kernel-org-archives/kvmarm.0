From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 06/26] arm64/sve: Check SVE virtualisability
Date: Fri, 1 Mar 2019 14:44:52 +0000
Message-ID: <20190301144452.GG3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-7-git-send-email-Dave.Martin@arm.com>
 <64764e35-c243-e642-a868-5b9e221813c7@arm.com>
 <20190226120630.GH3567@e103592.cambridge.arm.com>
 <d8d4d25d-13b7-be23-77bb-7cf498c8463a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B30B84A44F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 09:44:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jlpp9El4YGUP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Mar 2019 09:44:57 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4464A3B0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 09:44:57 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <d8d4d25d-13b7-be23-77bb-7cf498c8463a@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 01, 2019 at 12:39:52PM +0000, Julien Thierry wrote:
> 
> 
> On 26/02/2019 12:06, Dave Martin wrote:
> > On Wed, Feb 20, 2019 at 11:12:49AM +0000, Julien Thierry wrote:
> >> Hi Dave,
> >>
> >> On 18/02/2019 19:52, Dave Martin wrote:

[...]

> >>> +	/*
> >>> +	 * Mismatches above sve_max_virtualisable_vl are fine, since
> >>> +	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
> >>> +	 */
> >>> +	if (sve_vl_from_vq(bit_to_vq(b)) <= sve_max_virtualisable_vl) {
> >>> +		pr_warn("SVE: cpu%d: Unsupported vector length(s) present\n",
> >>
> >> Nit: might be good to specify that the vector length is unsupported for
> >> virtualisation.
> >>
> >> Also, since KVM is the one deciding what to do with the information,
> >> should we have a warning here? But I can understand that knowing which
> >> CPUs are introducing unsupported vector length, maybe using pr_devel()
> >> instead of pr_warn()
> > 
> > These warnings are really for consumption by SoC vendors, not users:
> > my aim is to flag up systems that we consider broken (or at least,
> > unsuitable for running KVM).
> > 
> > So I prefer to make this noisy and limit the amount of "useful"
> > information people might be tempted to programmatically scrape from
> > dmesg.
> > 
> > cpufeatures uses pr_warn("SANITY CHECK: [...]") here.  Maybe I should
> > stick "SANITY CHECK" in here too?  I will also try to make the commit
> > message more explicit and/or add comments to make the intent of the code
> > clearer.
> > 
> > It may also make sense to make this noise even if KVM isn't enabled
> > (which is a rare case anyhow).
> > 
> > Thoughts?
> 
> As I explained later in the patch series, I missed the fact that this
> function was for late secondary CPUs. I think things are fine like this
> (just add the bit about the vector lenght not being supported for
> virtualisation).

I've now reworked all this a bit: I probe for the largest vector length
than be offered to guests, and if this is less than the host's maximum
vector length then I print a one-off warning saying what limit KVM is
clamping guests' vector length to.

Elsewhere, I now just use the probed value as the maximum vector length,
rather than duplicating the bounds checking logic.

This approach seems simpler, and is hoepfully a bit more self-
explanatory -- so please take a look when I repost :)

Cheers
---Dave
