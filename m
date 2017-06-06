From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 25/25] KVM: arm64: vgic-v3: Log which GICv3 system
 registers are trapped
Date: Tue, 6 Jun 2017 15:23:13 +0200
Message-ID: <20170606132313.GC9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-26-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-26-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:17AM +0100, Marc Zyngier wrote:
> In order to facilitate debug, let's log which class of GICv3 system
> registers are trapped.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 636f1258d217..e0b530f4b1e6 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -499,7 +499,10 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
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
> -- 
> 2.11.0
> 
