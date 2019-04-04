From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 14/27] KVM: Allow 2048-bit register access via ioctl
 interface
Date: Thu, 4 Apr 2019 23:11:31 +0200
Message-ID: <20190404211131.53ch4ohwon7ubrog@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-15-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1553864452-15080-15-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 01:00:39PM +0000, Dave Martin wrote:
> The Arm SVE architecture defines registers that are up to 2048 bits
> in size (with some possibility of further future expansion).
> =

> In order to avoid the need for an excessively large number of
> ioctls when saving and restoring a vcpu's registers, this patch
> adds a #define to make support for individual 2048-bit registers
> through the KVM_{GET,SET}_ONE_REG ioctl interface official.  This
> will allow each SVE register to be accessed in a single call.
> =

> There are sufficient spare bits in the register id size field for
> this change, so there is no ABI impact, providing that
> KVM_GET_REG_LIST does not enumerate any 2048-bit register unless
> userspace explicitly opts in to the relevant architecture-specific
> features.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> ---
>  include/uapi/linux/kvm.h | 1 +
>  1 file changed, 1 insertion(+)
> =

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6d4ea4b..dc77a5a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1145,6 +1145,7 @@ struct kvm_dirty_tlb {
>  #define KVM_REG_SIZE_U256	0x0050000000000000ULL
>  #define KVM_REG_SIZE_U512	0x0060000000000000ULL
>  #define KVM_REG_SIZE_U1024	0x0070000000000000ULL
> +#define KVM_REG_SIZE_U2048	0x0080000000000000ULL
>  =

>  struct kvm_reg_list {
>  	__u64 n; /* number of regs */
> -- =

> 2.1.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
