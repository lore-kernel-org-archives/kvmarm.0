From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 0/4] kvm: arm/arm64: vgic: APRn uaccess support.
Date: Mon, 4 Sep 2017 19:27:17 +0200
Message-ID: <20170904172717.GK13572@cbox>
References: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
 <20170831203356.GE13572@cbox> <59A8DDD3.1000204@huawei.com>
 <20170901094438.GF13572@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E1D40CE9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Sep 2017 13:25:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a5U9PfMOKcWD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Sep 2017 13:25:00 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BC1340C5A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Sep 2017 13:25:00 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id v2so8436804wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Sep 2017 10:27:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170901094438.GF13572@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wanghaibin,

On Fri, Sep 01, 2017 at 11:44:38AM +0200, Christoffer Dall wrote:
> On Fri, Sep 01, 2017 at 12:10:59PM +0800, wanghaibin wrote:
> > On 2017/9/1 4:33, Christoffer Dall wrote:
> > 
> > > Hi Wanghaibin,
> > > 
> > > On Wed, Aug 23, 2017 at 09:05:22AM +0800, wanghaibin wrote:
> > >> v3: Coding style fix.
> > >>     Add the valid APRn access check which Marc proposed. 
> > >>
> > >> v2: Split the patch again to make it easier for review
> > >>     some fixes were proposed by Marc
> > > 
> > > Usually we put the changelog at the end of the description, before the
> > > diff state.  I suggest you have a look at other patch series on the
> > > kvmarm list or on the ARM linux mailing list and see how most people do
> > > it.
> > 
> > 
> > OK, Pay attention next time.
> > 
> > Thanks.
> > 
> > > 
> > >>
> > >> v1: the problem describe:
> > >> In the case (GICv2 on GICv3 migration), I did the test on my board as follow:
> > >> vm boot => migrate to destination => shutdown at destination => start at destination 
> > >> => migrate back to source ... go round and begin again;
> > >>
> > >> I tested many times, but unlucky, there maybe failed by accident when shutdown the vm 
> > >> at destination. (GICv3 on GICv3 migration, 1000+ times, That's OK).
> > >> while failed,  we can watch the interrupts in the vm, some vcpus of the vm can not 
> > >> receive the virt timer interrupt. And, these vcpus will 100% with top tool at host.
> > >>
> > >> vgic_state debug file at destination shows(a active virt timer interrupt) that:
> > >> VCPU 0 TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID
> > >> ---------------------------------------------------------------
> > >>             ....................
> > >>        PPI   25      0 000001        0        1   0 160      -1
> > >>        PPI   26      0 000001        0        1   0 160      -1
> > >>        PPI   27      0 011111       27        1   0 160       0
> > >>
> > >>
> > >> I added log to print ICH* registers for VCPU0 at destination:
> > >> **HCR:0x1, VMCR:0xf0ec0001,SRE:0x0, ELRSR:0xe**
> > >> -----AP0R:0: 0x0------
> > >> -----AP0R:1: 0x0------
> > >> -----AP0R:2: 0x0------
> > >> -----AP0R:3: 0x0------
> > >> -----AP1R:0: 0x0------
> > >> -----AP1R:1: 0x0------
> > >> -----AP1R:2: 0x0------
> > >> -----AP1R:3: 0x0------
> > >> -----LR:0: 0xa0a0001b0000001b------
> > >> -----LR:1: 0x0------
> > >> -----LR:2: 0x0------
> > >> -----LR:3: 0x0------
> > >>
> > >> and the ICH_AP1R0 value is 0x10000 at source.
> > >>
> > >> At present, QEMU have supproted GICC_APRn put/set interface for emulated GICv2,
> > >> and kvm does not support the uaccess interface. This patchset try to support this.
> > >>
> > > 
> > > So I feel like this series is horribly complicated for what it does, and
> > > does things in the reverse order.  If you really want to take your
> > > appraoch, it would be much nicer if you first changed existing functions
> > > and added infrastructure, and then in the end wired it up to the user
> > > space ABI.  In other words, reverse your patches.
> > 
> > 
> > No problem. The patch order can be adjusted if you feel necessary (this
> > depends on the results of the simpler patch discussion).
> > 
> > > 
> > > However, I think I have a simpler approach to solving this.  Please have
> > > a look at this:
> > > 
> > > commit 1d49c5ef047a2218379aa170d9a3bdd39cd70e3a (HEAD -> gicv2-apr-uaccess)
> > > Author: Christoffer Dall <cdall@linaro.org>
> > > Date:   Thu Aug 31 22:24:25 2017 +0200
> > > 
> > >     KVM: arm/arm64: Support uaccess of GICC_APRn
> > >     
> > >     When migrating guests around we need to know the active priorities to
> > >     ensure functional virtual interrupt prioritization by the GIC.
> > >     
> > >     This commit clarifies the API and how active priorities of interrupts in
> > >     different groups are represented, and implements the accessor functions
> > >     for the uaccess register range.
> > >     
> > >     We live with a slight layering violation in accessing GICv3 data
> > >     structures from vgic-mmio-v2.c, because anything else just adds too much
> > >     complexity for us to deal with (it's not like there's a benefit
> > >     elsewhere in the code of an intermediate representation as is the case
> > >     with the VMCR).  We accept this, because while doing v3 processing from
> > >     a file named something-v2.c can look strange at first, this really is
> > >     specific to dealing with the user space interface for something that
> > >     looks like a GICv2.
> > >
> > 
> > 
> > I have different opinions here.
> > 
> > Form Marc's proposed, I guess we take the vgic-v2.c/ vgic-v3.c as the hardware abstraction
> > layer for GICH_* / ICH_* registers. These files provide a series of methods to interactive with
> > registers (not only vgic_vmcr, such as vgic_hcr, vgic_elrsr, vgic_lr), these registers only can
> > be changed by the provided methods (eq: vgic_v2/v3_fold/populate_lr_state,  vgic_v2/v3_set_underflow)
> > and finally, these methods are invoking by the uniform interface (vgic_set_underflow,
> > vgic_populate/fold_lr, these uniform interfaces invoked the corresponding method through HW probed info)
> > 
> > In a word, I think we should design the high cohesion and low coupling code, and we've been doing this too.
> > We should strictly restrict other modules or files to know or access the vgic_v2/v3_cpu_if or
> > its registers (Unfortunately, vgic_sre and vgic_aprn are breaking the rules currently, the patch 4 fix
> > vgicv3 sys access, and this patchset design followed this rule).
> > 
> > My understanding is as mentioned above, maybe not correct.
> > 
> 
> There are no strict layering definitions, exported ABIs or even APIs
> here.  We split things into multiple files to make the code readable and
> easy to maintain and understand.
> 
> Comparing the diff state (6 files, 126 inserts, 22 deletes in your
> version, 2 files, 45 inserts, 1 delete in my version) speaks to some of
> the completexity of the two approaches.
> 
> The biggest problem is that it takes me hours to understand your patch
> series, which indicates that it's over-designed or fails to convery the
> necessity of the complication.
> 
> >      
> > 
> > 
> > Put aside the discussion of the abstract layer,  same to Marc's proposed:
> > Avoid to allow userspace to save/restore undefined APR register,  that doesn't
> > make sense.
> > 
> 
> I don't see it as a big problem; they will have RAZ/WI semantics towards
> the VM, similar to hardware.  The only downside is that you can write
> something into registers that are not used to the VM and read back that
> value, when accessing from userspace.  However, if we really want to do
> this, I'd argue this is much simpler:
> 
> commit 5cd35287d086c99859900a3d7630a12c9d549fad
> Author: Christoffer Dall <cdall@linaro.org>
> Date:   Fri Sep 1 11:41:52 2017 +0200
> 
>     KVM: arm/arm64: Extract GICv3 max APRn index calculation
>     
>     As we are about to access the APRs from the GICv2 uaccess interface,
>     make this logic generally available.
>     
>     Signed-off-by: Christoffer Dall <cdall@linaro.org>
> 
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> index 116786d..c77d508 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -208,29 +208,12 @@ static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
>  static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r, u8 apr)
>  {
> -	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
>  	u8 idx = r->Op2 & 3;
>  
> -	/*
> -	 * num_pri_bits are initialized with HW supported values.
> -	 * We can rely safely on num_pri_bits even if VM has not
> -	 * restored ICC_CTLR_EL1 before restoring APnR registers.
> -	 */
> -	switch (vgic_v3_cpu->num_pri_bits) {
> -	case 7:
> -		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> -		break;
> -	case 6:
> -		if (idx > 1)
> -			goto err;
> -		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> -		break;
> -	default:
> -		if (idx > 0)
> -			goto err;
> -		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> -	}
> +	if (idx > vgic_v3_max_apr_idx(vcpu))
> +		goto err;
>  
> +	vgic_v3_access_apr_reg(vcpu, p, apr, idx);
>  	return true;
>  err:
>  	if (!p->is_write)
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index bba7fa2..bf9ceab 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -220,4 +220,20 @@ int vgic_debug_destroy(struct kvm *kvm);
>  bool lock_all_vcpus(struct kvm *kvm);
>  void unlock_all_vcpus(struct kvm *kvm);
>  
> +static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_cpu *cpu_if = &vcpu->arch.vgic_cpu;
> +
> +	/*
> +	 * num_pri_bits are initialized with HW supported values.
> +	 * We can rely safely on num_pri_bits even if VM has not
> +	 * restored ICC_CTLR_EL1 before restoring APnR registers.
> +	 */
> +	switch (cpu_if->num_pri_bits) {
> +	case 7: return 3;
> +	case 6: return 1;
> +	default: return 0;
> +	}
> +}
> +
>  #endif
> 
> 
> 
> commit 660efe48259ebe83e6f93cba0a184327cebf8e82 (HEAD -> gicv2-apr-uaccess)
> Author: Christoffer Dall <cdall@linaro.org>
> Date:   Thu Aug 31 22:24:25 2017 +0200
> 
>     KVM: arm/arm64: Support uaccess of GICC_APRn
>     
>     When migrating guests around we need to know the active priorities to
>     ensure functional virtual interrupt prioritization by the GIC.
>     
>     This commit clarifies the API and how active priorities of interrupts in
>     different groups are represented, and implements the accessor functions
>     for the uaccess register range.
>     
>     We live with a slight layering violation in accessing GICv3 data
>     structures from vgic-mmio-v2.c, because anything else just adds too much
>     complexity for us to deal with (it's not like there's a benefit
>     elsewhere in the code of an intermediate representation as is the case
>     with the VMCR).  We accept this, because while doing v3 processing from
>     a file named something-v2.c can look strange at first, this really is
>     specific to dealing with the user space interface for something that
>     looks like a GICv2.
>     
>     Signed-off-by: Christoffer Dall <cdall@linaro.org>
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
> index b2f60ca..b3ce126 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> @@ -83,6 +83,11 @@ Groups:
>  
>      Bits for undefined preemption levels are RAZ/WI.
>  
> +    Note that this differs from a CPU's view of the APRs on hardware in which
> +    a GIC without the security extensions expose group 0 and group 1 active
> +    priorities in separate register groups, whereas we show a combined view
> +    similar to GICv2's GICH_APR.
> +
>      For historical reasons and to provide ABI compatibility with userspace we
>      export the GICC_PMR register in the format of the GICH_VMCR.VMPriMask
>      field in the lower 5 bits of a word, meaning that userspace must always
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 37522e6..b3d4a10 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -303,6 +303,51 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
>  	vgic_set_vmcr(vcpu, &vmcr);
>  }
>  
> +static unsigned long vgic_mmio_read_apr(struct kvm_vcpu *vcpu,
> +					gpa_t addr, unsigned int len)
> +{
> +	int n; /* which APRn is this */
> +
> +	n = (addr >> 2) & 0x3;
> +
> +	if (kvm_vgic_global_state.type == VGIC_V2) {
> +		/* GICv2 hardware systems support max. 32 groups */
> +		if (n != 0)
> +			return 0;
> +		return vcpu->arch.vgic_cpu.vgic_v2.vgic_apr;
> +	} else {
> +		struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +		if (n > vgic_v3_max_apr_idx(vcpu))
> +			return 0;
> +		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
> +		return vgicv3->vgic_ap1r[n];
> +	}
> +}
> +
> +static void vgic_mmio_write_apr(struct kvm_vcpu *vcpu,
> +				gpa_t addr, unsigned int len,
> +				unsigned long val)
> +{
> +	int n; /* which APRn is this */
> +
> +	n = (addr >> 2) & 0x3;
> +
> +	if (kvm_vgic_global_state.type == VGIC_V2) {
> +		/* GICv2 hardware systems support max. 32 groups */
> +		if (n != 0)
> +			return;
> +		vcpu->arch.vgic_cpu.vgic_v2.vgic_apr = val;
> +	} else {
> +		struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +		if (n > vgic_v3_max_apr_idx(vcpu))
> +			return;
> +		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
> +		vgicv3->vgic_ap1r[n] = val;
> +	}
> +}
> +
>  static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
> @@ -364,7 +409,7 @@ static const struct vgic_register_region vgic_v2_cpu_registers[] = {
>  		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
> +		vgic_mmio_read_apr, vgic_mmio_write_apr, 16,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
>  		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
> 
> 

I'd appreciate a tested-by on these patches with your configuration.

Thanks,
-Christoffer
