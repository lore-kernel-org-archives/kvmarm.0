From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: vgic-v2: Fix proxying of cpuif access
Date: Fri, 4 May 2018 16:19:16 +0100
Message-ID: <c6406079-78eb-aa7d-dde4-2676aa27b91e@arm.com>
References: <20180427145102.5645-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9354B49FA9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 11:12:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0-f00L6z9tss for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 May 2018 11:12:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5F4640192
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 11:12:27 -0400 (EDT)
In-Reply-To: <20180427145102.5645-1-marc.zyngier@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 27/04/18 15:51, Marc Zyngier wrote:
> Proxying the cpuif accesses at EL2 makes use of vcpu_data_guest_to_host
> and co, which check the endianness, which call into vcpu_read_sys_reg...
> which isn't mapped at EL2 (it was inlined before, and got moved OoL
> with the VHE optimizations).
> 
> The result is of course a nice panic. Let's add some specialized
> cruft to keep the broken platforms that require this hack alive.
> I'd rather kill BE support, but hey, just in case...

I have this a spin on Juno with a big-endian host and 64K pages:
Trying to boot a BE guest hangs.
Trying to boot a LE guest hangs.


> @@ -64,14 +88,11 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	addr += fault_ipa - vgic->vgic_cpu_base;
>  
>  	if (kvm_vcpu_dabt_iswrite(vcpu)) {
> -		u32 data = vcpu_data_guest_to_host(vcpu,
> -						   vcpu_get_reg(vcpu, rd),
> -						   sizeof(u32));
> +		u32 data = __guest_to_host_u32(vcpu, vcpu_get_reg(vcpu, rd));
>  		writel_relaxed(data, addr);
>  	} else {
> -		u32 data = readl_relaxed(addr);
> -		vcpu_set_reg(vcpu, rd, vcpu_data_host_to_guest(vcpu, data,
> -							       sizeof(u32)));
> +		u32 data = __host_to_guest_u32(vcpu, readl_relaxed(addr));
> +		vcpu_set_reg(vcpu, rd, data);
>  	}

This happens because readl()/writel() are doing their own swabbing on
big-endian, even if the guest had already done this.

As I've trampled all over this patch, I'll post a v2...


Thanks,

James
