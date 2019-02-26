From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 07/26] arm64/sve: Clarify role of the VQ map
 maintenance functions
Date: Tue, 26 Feb 2019 12:06:55 +0000
Message-ID: <20190226120654.GJ3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-8-git-send-email-Dave.Martin@arm.com>
 <f8a56d62-3b45-e369-ed4a-187895a178c0@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D233F4A36C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:07:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rCP3FvHAeM3s for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:06:59 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCE834A321
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:06:59 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <f8a56d62-3b45-e369-ed4a-187895a178c0@arm.com>
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

On Wed, Feb 20, 2019 at 11:43:24AM +0000, Julien Thierry wrote:
> 
> 
> On 18/02/2019 19:52, Dave Martin wrote:
> > The roles of sve_init_vq_map(), sve_update_vq_map() and
> > sve_verify_vq_map() are highly non-obvious to anyone who has not dug
> > through cpufeatures.c in detail.
> > 
> > Since the way these functions interact with each other is more
> > important here than a full understanding of the cpufeatures code, this
> > patch adds comments to make the functions' roles clearer.
> > 
> > No functional change.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kernel/fpsimd.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index 64729e2..92c2331 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -647,6 +647,10 @@ static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
> >  	}
> >  }
> >  
> > +/*
> > + * Initialise the set of known supported VQs for the boot CPU.
> > + * This is called during kernel boot, before secondary CPUs are brought up.
> > + */
> >  void __init sve_init_vq_map(void)
> >  {
> >  	sve_probe_vqs(sve_vq_map);
> > @@ -656,6 +660,7 @@ void __init sve_init_vq_map(void)
> >  /*
> >   * If we haven't committed to the set of supported VQs yet, filter out
> >   * those not supported by the current CPU.
> > + * This function is called during the bring-up of early secondary CPUs only.
> >   */
> >  void sve_update_vq_map(void)
> >  {
> > @@ -666,7 +671,10 @@ void sve_update_vq_map(void)
> >  	bitmap_or(sve_vq_partial_map, sve_vq_partial_map, tmp_map, SVE_VQ_MAX);
> >  }
> >  
> > -/* Check whether the current CPU supports all VQs in the committed set */
> > +/*
> > + * Check whether the current CPU supports all VQs in the committed set.
> > + * This function is called during the bring-up of late secondary CPUs only.
> 
> Oh I see, this is for late CPUs. So you can probably disregard my
> comment on the warning in the previous patch.
> 
> If you respin this series, I feel it would be more useful to have this
> patch before the current patch 6.

Agreed, I'll swap them over.  Looking at the two patches, I'm not sure
how they ended up this way round.  It may have been an unintended side-
effect of a previous rebase.

> Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Thanks
---Dave
