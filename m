From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 17/25] KVM: arm64/sve: Add SVE support to register
 access ioctl interface
Date: Fri, 18 Jan 2019 17:58:33 +0000
Message-ID: <74aad8f1-e9f0-689a-1f2b-60a30de41b65@arm.com>
References: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
 <1547757219-19439-18-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 378924A39D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 12:58:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eQhSxigWCKXC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 12:58:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EC074A33F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 12:58:37 -0500 (EST)
In-Reply-To: <1547757219-19439-18-git-send-email-Dave.Martin@arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 17/01/2019 20:33, Dave Martin wrote:
> This patch adds the following registers for access via the
> KVM_{GET,SET}_ONE_REG interface:
> 
>  * KVM_REG_ARM64_SVE_ZREG(n, i) (n = 0..31) (in 2048-bit slices)
>  * KVM_REG_ARM64_SVE_PREG(n, i) (n = 0..15) (in 256-bit slices)
>  * KVM_REG_ARM64_SVE_FFR(i) (in 256-bit slices)
> 
> In order to adapt gracefully to future architectural extensions,
> the registers are divided up into slices as noted above:  the i
> parameter denotes the slice index.
> 
> For simplicity, bits or slices that exceed the maximum vector
> length supported for the vcpu are ignored for KVM_SET_ONE_REG, and
> read as zero for KVM_GET_ONE_REG.
> 
> For the current architecture, only slice i = 0 is significant.  The
> interface design allows i to increase to up to 31 in the future if
> required by future architectural amendments.
> 
> The registers are only visible for vcpus that have SVE enabled.
> They are not enumerated by KVM_GET_REG_LIST on vcpus that do not
> have SVE.  In all cases, surplus slices are not enumerated by
> KVM_GET_REG_LIST.
> 
> Accesses to the FPSIMD registers via KVM_REG_ARM_CORE is not
> allowed for SVE-enabled vcpus: SVE-aware userspace can use the
> KVM_REG_ARM64_SVE_ZREG() interface instead to access the same
> register state.  This avoids some complex and pointless emluation

nit: emulation.

> in the kernel.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h |  10 +++
>  arch/arm64/kvm/guest.c            | 131 ++++++++++++++++++++++++++++++++++----
>  2 files changed, 129 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 97c3478..1ff68fa 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -226,6 +226,16 @@ struct kvm_vcpu_events {
>  					 KVM_REG_ARM_FW | ((r) & 0xffff))
>  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
>  
> +/* SVE registers */
> +#define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
> +#define KVM_REG_ARM64_SVE_ZREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> +					 KVM_REG_SIZE_U2048 |		\
> +					 ((n) << 5) | (i))
> +#define KVM_REG_ARM64_SVE_PREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> +					 KVM_REG_SIZE_U256 |		\
> +					 ((n) << 5) | (i) | 0x400)

Can we please have a name for this 0x400 bit?


> +#define KVM_REG_ARM64_SVE_FFR(i)	KVM_REG_ARM64_SVE_PREG(16, i)
> +
>  /* Device Control API: ARM VGIC */
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
>  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index ffa38d4..b8f9c1e 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -19,8 +19,10 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> +#include <linux/bits.h>
>  #include <linux/errno.h>
>  #include <linux/err.h>
> +#include <linux/kernel.h>
>  #include <linux/kvm_host.h>
>  #include <linux/module.h>
>  #include <linux/vmalloc.h>
> @@ -28,9 +30,12 @@
>  #include <kvm/arm_psci.h>
>  #include <asm/cputype.h>
>  #include <linux/uaccess.h>
> +#include <asm/fpsimd.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
> +#include <asm/kvm_host.h>
> +#include <asm/sigcontext.h>
>  
>  #include "trace.h"
>  
> @@ -210,6 +215,108 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	return err;
>  }
>  
> +struct kreg_region {
> +	char *kptr;

Should this rather be void * instead?

> +	size_t size;
> +	size_t zeropad;
> +};
> +
> +#define SVE_REG_SLICE_SHIFT	0
> +#define SVE_REG_SLICE_BITS	5
> +#define SVE_REG_ID_SHIFT	(SVE_REG_SLICE_SHIFT + SVE_REG_SLICE_BITS)
> +#define SVE_REG_ID_BITS		5
> +
> +#define SVE_REG_SLICE_MASK					\
> +	GENMASK(SVE_REG_SLICE_SHIFT + SVE_REG_SLICE_BITS - 1,	\
> +		SVE_REG_SLICE_SHIFT)
> +#define SVE_REG_ID_MASK							\
> +	GENMASK(SVE_REG_ID_SHIFT + SVE_REG_ID_BITS - 1, SVE_REG_ID_SHIFT)
> +
> +#define SVE_NUM_SLICES (1 << SVE_REG_SLICE_BITS)
> +
> +static int sve_reg_region(struct kreg_region *b,
> +			  const struct kvm_vcpu *vcpu,
> +			  const struct kvm_one_reg *reg)
> +{
> +	const unsigned int vl = vcpu->arch.sve_max_vl;
> +	const unsigned int vq = sve_vq_from_vl(vl);
> +
> +	const unsigned int reg_num =
> +		(reg->id & SVE_REG_ID_MASK) >> SVE_REG_ID_SHIFT;
> +	const unsigned int slice_num =
> +		(reg->id & SVE_REG_SLICE_MASK) >> SVE_REG_SLICE_SHIFT;
> +
> +	unsigned int slice_size, offset, limit;
> +
> +	if (reg->id >= KVM_REG_ARM64_SVE_ZREG(0, 0) &&
> +	    reg->id <= KVM_REG_ARM64_SVE_ZREG(SVE_NUM_ZREGS - 1,
> +					      SVE_NUM_SLICES - 1)) {
> +		slice_size = KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0));
> +
> +		/* Compute start and end of the register: */
> +		offset = SVE_SIG_ZREG_OFFSET(vq, reg_num) - SVE_SIG_REGS_OFFSET;
> +		limit = offset + SVE_SIG_ZREG_SIZE(vq);
> +
> +		offset += slice_size * slice_num; /* start of requested slice */
> +
> +	} else if (reg->id >= KVM_REG_ARM64_SVE_PREG(0, 0) &&
> +		   reg->id <= KVM_REG_ARM64_SVE_FFR(SVE_NUM_SLICES - 1)) {
> +		/* (FFR is P16 for our purposes) */
> +
> +		slice_size = KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0));
> +
> +		/* Compute start and end of the register: */
> +		offset = SVE_SIG_PREG_OFFSET(vq, reg_num) - SVE_SIG_REGS_OFFSET;
> +		limit = offset + SVE_SIG_PREG_SIZE(vq);
> +
> +		offset += slice_size * slice_num; /* start of requested slice */
> +
> +	} else {
> +		return -ENOENT;
> +	}
> +
> +	b->kptr = (char *)vcpu->arch.sve_state + offset;

I'm very uneasy with this pointer that, at this stage, may point to an
arbitrary location in memory, given that the slice number is controlled
by userspace. It feels like a disaster waiting to happen as a potential
spectre-v1 gadget.

And actually, we don't have any requirement to handle non-zero slices,
do we? The important thing is that you've nicely reserved extra space in
the encoding, and that we can expand the API in a very straightforward way.

So at this stage, I'd drop all support for non-zero slices and return an
error instead.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
