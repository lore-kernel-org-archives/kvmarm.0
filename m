From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Close VMID generation race
Date: Tue, 10 Apr 2018 11:51:19 +0100
Message-ID: <20180410105119.yzzzd4lyvlsvtbfy@lakrids.cambridge.arm.com>
References: <20180409170706.23541-1-marc.zyngier@arm.com>
 <20180409205139.GH10904@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180409205139.GH10904@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 09, 2018 at 10:51:39PM +0200, Christoffer Dall wrote:
> On Mon, Apr 09, 2018 at 06:07:06PM +0100, Marc Zyngier wrote:
> > Before entering the guest, we check whether our VMID is still
> > part of the current generation. In order to avoid taking a lock,
> > we start with checking that the generation is still current, and
> > only if not current do we take the lock, recheck, and update the
> > generation and VMID.
> > 
> > This leaves open a small race: A vcpu can bump up the global
> > generation number as well as the VM's, but has not updated
> > the VMID itself yet.
> > 
> > At that point another vcpu from the same VM comes in, checks
> > the generation (and finds it not needing anything), and jumps
> > into the guest. At this point, we end-up with two vcpus belonging
> > to the same VM running with two different VMIDs. Eventually, the
> > VMID used by the second vcpu will get reassigned, and things will
> > really go wrong...
> > 
> > A simple solution would be to drop this initial check, and always take
> > the lock. This is likely to cause performance issues. A middle ground
> > is to convert the spinlock to a rwlock, and only take the read lock
> > on the fast path. If the check fails at that point, drop it and
> > acquire the write lock, rechecking the condition.
> > 
> > This ensures that the above scenario doesn't occur.
> > 
> > Reported-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> > I haven't seen any reply from Shannon, so reposting this to
> > a slightly wider audience for feedback.
> > 
> >  virt/kvm/arm/arm.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index dba629c5f8ac..a4c1b76240df 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -63,7 +63,7 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
> >  static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
> >  static u32 kvm_next_vmid;
> >  static unsigned int kvm_vmid_bits __read_mostly;
> > -static DEFINE_SPINLOCK(kvm_vmid_lock);
> > +static DEFINE_RWLOCK(kvm_vmid_lock);
> >  
> >  static bool vgic_present;
> >  
> > @@ -473,11 +473,16 @@ static void update_vttbr(struct kvm *kvm)
> >  {
> >  	phys_addr_t pgd_phys;
> >  	u64 vmid;
> > +	bool new_gen;
> >  
> > -	if (!need_new_vmid_gen(kvm))
> > +	read_lock(&kvm_vmid_lock);
> > +	new_gen = need_new_vmid_gen(kvm);
> > +	read_unlock(&kvm_vmid_lock);
> > +
> > +	if (!new_gen)
> >  		return;
> >  
> > -	spin_lock(&kvm_vmid_lock);
> > +	write_lock(&kvm_vmid_lock);
> >  
> >  	/*
> >  	 * We need to re-check the vmid_gen here to ensure that if another vcpu
> > @@ -485,7 +490,7 @@ static void update_vttbr(struct kvm *kvm)
> >  	 * use the same vmid.
> >  	 */
> >  	if (!need_new_vmid_gen(kvm)) {
> > -		spin_unlock(&kvm_vmid_lock);
> > +		write_unlock(&kvm_vmid_lock);
> >  		return;
> >  	}
> >  
> > @@ -519,7 +524,7 @@ static void update_vttbr(struct kvm *kvm)
> >  	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
> >  	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid;
> >  
> > -	spin_unlock(&kvm_vmid_lock);
> > +	write_unlock(&kvm_vmid_lock);
> >  }
> >  
> >  static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> > -- 
> > 2.14.2
> > 
> 
> The above looks correct to me.  I am wondering if something like the
> following would also work, which may be slightly more efficient,
> although I doubt the difference can be measured:
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index dba629c5f8ac..7ac869bcad21 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -458,7 +458,9 @@ void force_vm_exit(const cpumask_t *mask)
>   */
>  static bool need_new_vmid_gen(struct kvm *kvm)
>  {
> -	return unlikely(kvm->arch.vmid_gen != atomic64_read(&kvm_vmid_gen));
> +	u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
> +	smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
> +	return unlikely(kvm->arch.vmid_gen != current_vmid_gen);
>  }
>  
>  /**
> @@ -508,10 +510,11 @@ static void update_vttbr(struct kvm *kvm)
>  		kvm_call_hyp(__kvm_flush_vm_context);
>  	}
>  
> -	kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
>  	kvm->arch.vmid = kvm_next_vmid;
>  	kvm_next_vmid++;
>  	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
> +	smp_wmb();
> +	kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
>  
>  	/* update vttbr to be used with the new vmid */
>  	pgd_phys = virt_to_phys(kvm->arch.pgd);
> 

I think we also need to update kvm->arch.vttbr before updating
kvm->arch.vmid_gen, otherwise another CPU can come in, see that the
vmid_gen is up-to-date, jump to hyp, and program a stale VTTBR (with the
old VMID).

With the smp_wmb() and update of kvm->arch.vmid_gen moved to the end of
the critical section, I think that works, modulo using READ_ONCE() and
WRITE_ONCE() to ensure single-copy-atomicity of the fields we access
locklessly.

Thanks,
Mark.
