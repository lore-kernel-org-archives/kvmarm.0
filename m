From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 09/27] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Thu, 4 Apr 2019 23:15:56 +0200
Message-ID: <20190404211556.pr7vr6sn3sw4yyft@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-10-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1553864452-15080-10-git-send-email-Dave.Martin@arm.com>
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

On Fri, Mar 29, 2019 at 01:00:34PM +0000, Dave Martin wrote:
> Since SVE will be enabled or disabled on a per-vcpu basis, a flag
> is needed in order to track which vcpus have it enabled.
> =

> This patch adds a suitable flag and a helper for checking it.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
> =

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 6d10100..ad4f7f0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -328,6 +328,10 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
>  #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
>  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
> +#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
> +
> +#define vcpu_has_sve(vcpu) (system_supports_sve() && \
> +			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>  =

>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  =

> -- =

> 2.1.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
