From: Manish Jaggi <mjaggi@caviumnetworks.com>
Subject: Re: [RFC] [PATCH] kvm: arm: Introduce error code KVM_EINVARIANT
Date: Sat, 10 Nov 2018 22:18:47 +0000
Message-ID: <4bbb4e76-b714-eafe-f95b-aca1a258e9fe@caviumnetworks.com>
References: <1540290099-146109-1-git-send-email-mjaggi@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1540290099-146109-1-git-send-email-mjaggi@caviumnetworks.com>
Content-Language: en-US
Content-ID: <F68F58C3B2C67048AE1B1BEA85F7EBB5@namprd07.prod.outlook.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "Jaggi, Manish" <Manish.Jaggi@cavium.com>, "quintela@redhat.com" <quintela@redhat.com>, "dgilbert@redhat.com" <dgilbert@redhat.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "Nair, Jayachandran" <Jayachandran.Nair@cavium.com>, "Nowicki, Tomasz" <Tomasz.Nowicki@cavium.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu


CCing a larger audience.
Please review.

On 10/23/2018 03:51 PM, Jaggi, Manish wrote:
> From: Manish Jaggi <manish.jaggi@cavium.com>
>
> This patch introduces an error code KVM_EINVARIANT which is returned
> by KVM when userland tries to set an invariant register.
>
> The need for this error code is in VM Migration for arm64.
> ARM64 systems use mainly -machine virt -cpu host as parameter to qemu.
> Migration requires both Source and destination machines to have same
> physical cpu. There are cases where the overall architecture of CPU is
> same but the next version of the chip with some bug fixes which have no
> effect on qemu operation. In such cases invariant registers like MIDR
> have a different value.
> Currently Migration fails in such cases.
>
> Rather than sending a EINVAL, a specifc error code will help
> userland program the guest invariant register by querying the migrated
> host machines invariant registers.
>
> Qemu will have a parameter -hostinvariant along with checking of this
> error code. So it can be safely assumed that the feature is opt-in
>
> Corresponding Qemu patchset can be found at :
> https://lists.gnu.org/archive/html/qemu-devel/2018-10/msg05048.html
>
>
> Signed-off-by: Manish Jaggi <manish.jaggi@cavium.com>
> ---
>   arch/arm64/kvm/sys_regs.c     | 9 ++++-----
>   include/uapi/linux/kvm_para.h | 1 +
>   2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 22fbbdb..78ffc02 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1111,7 +1111,7 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
>   
>   	/* This is what we mean by invariant: you can't change it. */
>   	if (val != read_id_reg(rd, raz))
> -		return -EINVAL;
> +		return -KVM_EINVARIANT;
>   
>   	return 0;
>   }
> @@ -2254,9 +2254,8 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
>   		return err;
>   
>   	/* This is what we mean by invariant: you can't change it. */
> -	if (r->val != val)
> -		return -EINVAL;
> -
> +	if (r->val != val)	
> +		return -KVM_EINVARIANT;
>   	return 0;
>   }
>   
> @@ -2335,7 +2334,7 @@ static int demux_c15_set(u64 id, void __user *uaddr)
>   
>   		/* This is also invariant: you can't change it. */
>   		if (newval != get_ccsidr(val))
> -			return -EINVAL;
> +			return -KVM_EINVARIANT;
>   		return 0;
>   	default:
>   		return -ENOENT;
> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> index 6c0ce49..4358669 100644
> --- a/include/uapi/linux/kvm_para.h
> +++ b/include/uapi/linux/kvm_para.h
> @@ -17,6 +17,7 @@
>   #define KVM_E2BIG		E2BIG
>   #define KVM_EPERM		EPERM
>   #define KVM_EOPNOTSUPP		95
> +#define KVM_EINVARIANT          96
>   
>   #define KVM_HC_VAPIC_POLL_IRQ		1
>   #define KVM_HC_MMU_OP			2
