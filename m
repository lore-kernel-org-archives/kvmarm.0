From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 03/40] KVM: arm64: Avoid storing the vcpu pointer on
 the stack
Date: Wed, 21 Feb 2018 18:32:00 +0100
Message-ID: <20180221173200.6vfv6a4hytibos3p@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-4-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-4-christoffer.dall@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 15, 2018 at 10:02:55PM +0100, Christoffer Dall wrote:
> We already have the percpu area for the host cpu state, which points to
> the VCPU, so there's no need to store the VCPU pointer on the stack on
> every context switch.  We can be a little more clever and just use
> tpidr_el2 for the percpu offset and load the VCPU pointer from the host
> context.
> 
> This does require us to calculate the percpu offset without including
> the offset from the kernel mapping of the percpu array to the linear
> mapping of the array (which is what we store in tpidr_el1), because a
> PC-relative generated address in EL2 is already giving us the hyp alias
> of the linear mapping of a kernel address.  We do this in
> __cpu_init_hyp_mode() by using kvm_ksym_ref().
> 
> This change also requires us to have a scratch register, so we take the
> chance to rearrange some of the el1_sync code to only look at the
> vttbr_el2 to determine if this is a trap from the guest or an HVC from
> the host.  We do add an extra check to call the panic code if the kernel
> is configured with debugging enabled and we saw a trap from the host
> which wasn't an HVC, indicating that we left some EL2 trap configured by
> mistake.
> 
> The code that accesses ESR_EL2 was previously using an alternative to
> use the _EL1 accessor on VHE systems, but this was actually unnecessary
> as the _EL1 accessor aliases the ESR_EL2 register on VHE, and the _EL2
> accessor does the same thing on both systems.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v3:
>      - Reworked the assembly part of the patch after rebasing on v4.16-rc1
>        which created a conflict with the variant 2 mitigations.
>      - Removed Marc's reviewed-by due to the rework.
>      - Removed unneeded extern keyword in declaration in header file
>     
>     Changes since v1:
>      - Use PC-relative addressing to access per-cpu variables instead of
>        using a load from the literal pool.
>      - Remove stale comments as pointed out by Marc
>      - Reworded the commit message as suggested by Drew
> 
>  arch/arm64/include/asm/kvm_asm.h  | 14 ++++++++++++++
>  arch/arm64/include/asm/kvm_host.h | 15 +++++++++++++++
>  arch/arm64/kernel/asm-offsets.c   |  1 +
>  arch/arm64/kvm/hyp/entry.S        |  6 +-----
>  arch/arm64/kvm/hyp/hyp-entry.S    | 31 +++++++++++++------------------
>  arch/arm64/kvm/hyp/switch.c       |  5 +----
>  arch/arm64/kvm/hyp/sysreg-sr.c    |  5 +++++
>  7 files changed, 50 insertions(+), 27 deletions(-)
> 

I'm not clear on the motivation for this patch. I assumed it enabled
simpler patches later in the series, but I did a bit of reading ahead
and didn't see anything obvious. I doubt it gives a speedup, so is it
just to avoid stack use? Making it easier to maintain these assembly
functions that span a couple files? If so, should it be posted separately
from this series? If not, could you please add some more text to the
commit message helping me better understand the full motivation?

Besides my confusion on motivation, it looks good to me

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew
