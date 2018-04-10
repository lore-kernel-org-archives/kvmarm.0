From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Close VMID generation race
Date: Tue, 10 Apr 2018 16:24:20 +0100
Message-ID: <20180410152419.inzprhuqhx26keuq@lakrids.cambridge.arm.com>
References: <20180409170706.23541-1-marc.zyngier@arm.com>
 <20180409205139.GH10904@cbox>
 <20180410105119.yzzzd4lyvlsvtbfy@lakrids.cambridge.arm.com>
 <20180410150540.GK10904@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180410150540.GK10904@cbox>
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

On Tue, Apr 10, 2018 at 05:05:40PM +0200, Christoffer Dall wrote:
> On Tue, Apr 10, 2018 at 11:51:19AM +0100, Mark Rutland wrote:
> > I think we also need to update kvm->arch.vttbr before updating
> > kvm->arch.vmid_gen, otherwise another CPU can come in, see that the
> > vmid_gen is up-to-date, jump to hyp, and program a stale VTTBR (with the
> > old VMID).
> > 
> > With the smp_wmb() and update of kvm->arch.vmid_gen moved to the end of
> > the critical section, I think that works, modulo using READ_ONCE() and
> > WRITE_ONCE() to ensure single-copy-atomicity of the fields we access
> > locklessly.
> 
> Indeed, you're right.  I would look something like this, then:
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 2e43f9d42bd5..6cb08995e7ff 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -450,7 +450,9 @@ void force_vm_exit(const cpumask_t *mask)
>   */
>  static bool need_new_vmid_gen(struct kvm *kvm)
>  {
> -	return unlikely(kvm->arch.vmid_gen != atomic64_read(&kvm_vmid_gen));
> +	u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
> +	smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
> +	return unlikely(READ_ONCE(kvm->arch.vmid_gen) != current_vmid_gen);
>  }
>  
>  /**
> @@ -500,7 +502,6 @@ static void update_vttbr(struct kvm *kvm)
>  		kvm_call_hyp(__kvm_flush_vm_context);
>  	}
>  
> -	kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
>  	kvm->arch.vmid = kvm_next_vmid;
>  	kvm_next_vmid++;
>  	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
> @@ -509,7 +510,10 @@ static void update_vttbr(struct kvm *kvm)
>  	pgd_phys = virt_to_phys(kvm->arch.pgd);
>  	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
>  	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
> -	kvm->arch.vttbr = pgd_phys | vmid;
> +	WRITE_ONCE(kvm->arch.vttbr, pgd_phys | vmid);
> +
> +	smp_wmb(); /* Ensure vttbr update is observed before vmid_gen update */
> +	kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
>  
>  	spin_unlock(&kvm_vmid_lock);
>  }

I think that's right, yes.

We could replace the smp_{r,w}mb() barriers with an acquire of the
kvm_vmid_gen and a release of kvm->arch.vmid_gen, but if we're really
trying to optimize things there are larger algorithmic changes necessary
anyhow.

> It's probably easier to convince ourselves about the correctness of
> Marc's code using a rwlock instead, though.  Thoughts?

I believe that Marc's preference was the rwlock; I have no preference
either way.

Thanks,
Mark.
