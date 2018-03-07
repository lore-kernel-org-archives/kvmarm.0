From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 2/2] kvm: arm/arm64: vgic-v3: Tighten synchronization for
 guests using v2 on v3
Date: Wed, 7 Mar 2018 16:06:09 +0000
Message-ID: <7c494456-adc9-b8d4-208c-7a5dded8a790@arm.com>
References: <20180307124055.13800-1-marc.zyngier@arm.com>
 <20180307124055.13800-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180307124055.13800-3-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 07/03/18 12:40, Marc Zyngier wrote:
> On guest exit, and when using GICv2 on GICv3, we use a dsb(st) to
> force synchronization between the memory-mapped guest view and
> the system-register view that the hypervisor uses.
> 
> This is incorrect, as the spec calls out the need for "a DSB whose
> required access type is both loads and stores with any Shareability
> attribute", while we're only synchronizing stores.
> 
> We also lack an isb after the dsb to ensure that the latter has
> actually been executed before we start reading stuff from the sysregs.
> 
> The fix is pretty easy: turn dsb(st) into dsb(sy), and slap an isb()
> just after.

It's a shame that the spec indeed asks for the biggest available hammer,
but: so be it!

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index f5c3d6d7019e..b89ce5432214 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -215,7 +215,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  	 * are now visible to the system register interface.
>  	 */
>  	if (!cpu_if->vgic_sre) {
> -		dsb(st);
> +		dsb(sy);
> +		isb();
>  		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
>  	}
>  
> 
