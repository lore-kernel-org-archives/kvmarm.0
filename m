From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 10/16] KVM: Move vcpu_load to arch-specific
 kvm_arch_vcpu_ioctl_translate
Date: Wed, 29 Nov 2017 18:44:52 +0100
Message-ID: <d8bcffcc-5ffc-ed6d-1920-b3c9fb5d6c9a@redhat.com>
References: <20171129164116.16167-1-christoffer.dall@linaro.org>
 <20171129164116.16167-11-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C584049D75
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 12:42:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z9y3Kkg8f3f5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Nov 2017 12:42:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1375B49D6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 12:42:03 -0500 (EST)
In-Reply-To: <20171129164116.16167-11-christoffer.dall@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org
Cc: linux-mips@linux-mips.org, Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, Cornelia Huck <cohuck@redhat.com>, kvm-ppc@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>, Alexander Graf <agraf@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 29.11.2017 17:41, Christoffer Dall wrote:
> Move vcpu_load() and vcpu_put() into the architecture specific
> implementations of kvm_arch_vcpu_ioctl_translate().
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/powerpc/kvm/booke.c | 2 ++
>  arch/x86/kvm/x86.c       | 3 +++
>  virt/kvm/kvm_main.c      | 2 --
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index cdf0be0..1b491b8 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -1793,7 +1793,9 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
>  {
>  	int r;
>  
> +	vcpu_load(vcpu);
>  	r = kvmppc_core_vcpu_translate(vcpu, tr);
> +	vcpu_put(vcpu);
>  	return r;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ee357b6..eb70974 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7661,6 +7661,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
>  	gpa_t gpa;
>  	int idx;
>  
> +	vcpu_load(vcpu);
> +
>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>  	gpa = kvm_mmu_gva_to_gpa_system(vcpu, vaddr, NULL);
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> @@ -7669,6 +7671,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
>  	tr->writeable = 1;
>  	tr->usermode = 0;
>  
> +	vcpu_put(vcpu);
>  	return 0;
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f360005..0a8a490 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2627,9 +2627,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		r = -EFAULT;
>  		if (copy_from_user(&tr, argp, sizeof(tr)))
>  			goto out;
> -		vcpu_load(vcpu);
>  		r = kvm_arch_vcpu_ioctl_translate(vcpu, &tr);
> -		vcpu_put(vcpu);
>  		if (r)
>  			goto out;
>  		r = -EFAULT;
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
