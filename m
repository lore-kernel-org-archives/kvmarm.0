From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 13/40] KVM: arm64: Introduce VHE-specific kvm_vcpu_run
Date: Wed, 21 Feb 2018 19:18:32 +0100
Message-ID: <20180221181832.i5c46evx6y3h635k@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-14-christoffer.dall@linaro.org>
 <20180221174300.74lxks5gb6qzny75@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C9234047F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 13:12:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R17d0BqPWRo1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Feb 2018 13:11:58 -0500 (EST)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 781B5402DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 13:11:58 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180221174300.74lxks5gb6qzny75@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 21, 2018 at 06:43:00PM +0100, Andrew Jones wrote:
> On Thu, Feb 15, 2018 at 10:03:05PM +0100, Christoffer Dall wrote:
> > So far this is mostly (see below) a copy of the legacy non-VHE switch
> > function, but we will start reworking these functions in separate
> > directions to work on VHE and non-VHE in the most optimal way in later
> > patches.
> > 
> > The only difference after this patch between the VHE and non-VHE run
> > functions is that we omit the branch-predictor variant-2 hardening for
> > QC Falkor CPUs, because this workaround is specific to a series of
> > non-VHE ARMv8.0 CPUs.
> > 
> > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > 
> > Notes:
> >     Changes since v3:
> >      - Added BUG() to 32-bit ARM VHE run function
> >      - Omitted QC Falkor BP Hardening functionality from VHE-specific
> >        function
> >     
> >     Changes since v2:
> >      - Reworded commit message
> >     
> >     Changes since v1:
> >      - Rename kvm_vcpu_run to kvm_vcpu_run_vhe and rename __kvm_vcpu_run to
> >        __kvm_vcpu_run_nvhe
> >      - Removed stray whitespace line
> > 
> >  arch/arm/include/asm/kvm_asm.h   |  5 ++-
> >  arch/arm/kvm/hyp/switch.c        |  2 +-
> >  arch/arm64/include/asm/kvm_asm.h |  4 ++-
> >  arch/arm64/kvm/hyp/switch.c      | 66 +++++++++++++++++++++++++++++++++++++++-
> >  virt/kvm/arm/arm.c               |  5 ++-
> >  5 files changed, 77 insertions(+), 5 deletions(-)
> > 
> 
> ...
> 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 2062d9357971..5bd879c78951 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -736,7 +736,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		if (has_vhe())
> >  			kvm_arm_vhe_guest_enter();
> >  
> > -		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
> > +		if (has_vhe())
> > +			ret = kvm_vcpu_run_vhe(vcpu);
> > +		else
> > +			ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);
> >  
> >  		if (has_vhe())
> >  			kvm_arm_vhe_guest_exit();
> 
> We can combine these has_vhe()'s
> 
>  if (has_vhe()) {
>     kvm_arm_vhe_guest_enter();
>     ret = kvm_vcpu_run_vhe(vcpu);
>     kvm_arm_vhe_guest_exit();
>  } else
>     ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);

Maybe even do a cleanup patch that removes
kvm_arm_vhe_guest_enter/exit by putting the daif
masking/restoring directly into kvm_vcpu_run_vhe()?

Thanks,
drew
