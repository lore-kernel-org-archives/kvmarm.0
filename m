From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 2/8] KVM: arm64: Rework detection of SVE, !VHE systems
Date: Mon, 10 Dec 2018 12:40:44 +0000
Message-ID: <20181210124043.GA25144@edgewater-inn.cambridge.arm.com>
References: <20181206173126.139877-1-marc.zyngier@arm.com>
 <20181206173126.139877-3-marc.zyngier@arm.com>
 <20181210101305.GH30263@e113682-lin.lund.arm.com>
 <aff2750e-6746-3378-6d4d-dcbfc2028154@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DA7C4A2E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 07:40:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ip50evcHmYhM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 07:40:22 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEB844A2B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 07:40:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <aff2750e-6746-3378-6d4d-dcbfc2028154@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 10, 2018 at 10:28:05AM +0000, Marc Zyngier wrote:
> On 10/12/2018 10:13, Christoffer Dall wrote:
> > On Thu, Dec 06, 2018 at 05:31:20PM +0000, Marc Zyngier wrote:
> >> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> >> index 23774970c9df..1db4c15edcdd 100644
> >> --- a/virt/kvm/arm/arm.c
> >> +++ b/virt/kvm/arm/arm.c
> >> @@ -1640,8 +1640,10 @@ int kvm_arch_init(void *opaque)
> >>  		return -ENODEV;
> >>  	}
> >>  
> >> -	if (!kvm_arch_check_sve_has_vhe()) {
> >> -		kvm_pr_unimpl("SVE system without VHE unsupported.  Broken cpu?");
> >> +	in_hyp_mode = is_kernel_in_hyp_mode();
> >> +
> >> +	if (!in_hyp_mode && kvm_arch_requires_vhe()) {
> >> +		kvm_pr_unimpl("CPU requiring VHE was booted in non-VHE mode");
> > 
> > nit: The error message feels weird to me (are we reporting CPU bugs?)
> > and I'm not sure about the unimpl and I think there's a linse space
> > missing.
> > 
> > How about:
> > 
> > 	kvm_err("Cannot support this CPU in non-VHE mode, not initializing\n");
> 
> Yup, works for me. Will, do you mind changing this message for me?

I pushed out an updated branch here:

https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=kvm/cortex-a76-erratum-1165522

which should address all of Christoffer's comments and add his tags.

I plan to merge that into for-next/core later today.

Will
