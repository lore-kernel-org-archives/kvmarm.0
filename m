From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: Increase GICV size to 64KB so !4KB page-size kernels are able to
 initialize KVM
Date: Thu, 23 Jun 2016 12:17:03 +0900
Message-ID: <a168054f-b71c-944e-c91a-9a6a00404aa6@riken.jp>
References: <8b9c3e26-97b1-307f-8227-5ca3a4966c84@riken.jp>
 <576A630E.10800@arm.com> <57f56525-119a-8566-8d9b-43b7bcb23a49@riken.jp>
 <576A8298.20704@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E18B149B37
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 23:12:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VhQEQ5NJbzAh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 23:12:10 -0400 (EDT)
Received: from postman.riken.jp (postman1.riken.jp [134.160.33.83])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 456D149B36
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 23:12:09 -0400 (EDT)
In-Reply-To: <576A8298.20704@arm.com>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 6/22/16 9:20 PM, Marc Zyngier wrote:
> I'm only using DT, which works just fine on Overdrive, even with 64kB
> pages.
>
> I think I understand the issue you're having, which is not what I
> was thinking of. The issue is that because ACPI doesn't tell us
> anything about the size of the GICV region, we have to assume that
> it is 8kB, and cannot distinguish a safe platform from an unsafe
> one, failing the size test on 64kB.

Is it likely in the future specification of ACPI the size information
stored in the GIC subtable? In 6.1 or earlier, it seems optional to me.
I also had to allow the not page-aligned physical address of GICV, below
is an excerpt of apic.dsl

[054h 0084   8]     Virtual GIC Base Address : 00000000E116F000
[05Ch 0092   8]  Hypervisor GIC Base Address : 00000000E1140000
[064h 0100   4]        Virtual GIC Interrupt : 00000019
[068h 0104   8]   Redistributor Base Address : 0000000000000000
[070h 0112   8]                    ARM MPIDR : 0000000000000000

>
> Oh well.
>
> How about this:
>
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index e31405e..8aac59b 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -315,12 +315,10 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
>  		return -ENXIO;
>  	}
>
> -	if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
> -		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> +	if (!PAGE_ALIGNED(resource_size(&info->vcpu)))
> +		kvm_warn("GICV size 0x%llx not a multiple of page size 0x%lx, system may be unsafe\n",
>  			(unsigned long long)resource_size(&info->vcpu),
>  			PAGE_SIZE);
> -		return -ENXIO;
> -	}
>
>  	kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,
>  						   resource_size(&info->vctrl));
>
> Thanks,
>
> 	M.
>
