From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 31/31] KVM: arm64: vgic-v3: Log which GICv3 system
 registers are trapped
Date: Tue, 30 May 2017 11:56:21 +0200
Message-ID: <956dee52-6197-eb5a-7756-b6e10bd6ff32@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-32-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-32-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
On 03/05/2017 12:46, Marc Zyngier wrote:
> In order to facilitate debug, let's log which class of GICv3 system
> registers are trapped.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 717219ab58a2..9110657b502c 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -407,7 +407,10 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  #endif
>  
>  	if (group0_trap || group1_trap || common_trap) {
> -		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
> +		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s], reduced performance)\n",
> +			 group0_trap ? "G0" : "",
> +			 group1_trap ? "G1" : "",
> +			 common_trap ? "C"  : "");
>  		static_branch_enable(&vgic_v3_cpuif_trap);
>  	}
>  
> 
