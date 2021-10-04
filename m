Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E78FC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 11:22:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEEBA61373
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 11:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BEEBA61373
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3977F4B275;
	Mon,  4 Oct 2021 07:22:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CajiG2egUjou; Mon,  4 Oct 2021 07:22:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF7DB4B264;
	Mon,  4 Oct 2021 07:22:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 953724B264
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 07:22:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OH3UyS+4-pg2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 07:22:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 302CE4B256
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 07:22:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA8FA1FB;
 Mon,  4 Oct 2021 04:22:15 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 092B03F766;
 Mon,  4 Oct 2021 04:22:13 -0700 (PDT)
Message-ID: <6e50193e-95c4-e1fa-8287-1b909a714ebd@arm.com>
Date: Mon, 4 Oct 2021 12:23:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 2/5] KVM: arm64: Work around GICv3 locally generated
 SErrors
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20210924082542.2766170-1-maz@kernel.org>
 <20210924082542.2766170-3-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
In-Reply-To: <20210924082542.2766170-3-maz@kernel.org>
Cc: kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 9/24/21 09:25, Marc Zyngier wrote:
> The infamous M1 has a feature nobody else ever implemented,
> in the form of the "GIC locally generated SError interrupts",
> also known as SEIS for short.
>
> These SErrors are generated when a guest does something that violates
> the GIC state machine. It would have been simpler to just *ignore*
> the damned thing, but that's not what this HW does. Oh well.
>
> This part of of the architecture is also amazingly under-specified.
> There is a whole 10 lines that describe the feature in a spec that
> is 930 pages long, and some of these lines are factually wrong.
> Oh, and it is deprecated, so the insentive to clarify it is low.
>
> Now, the spec says that this should be a *virtual* SError when
> HCR_EL2.AMO is set. As it turns out, that's not always the case
> on this CPU, and the SError sometimes fires on the host as a
> physical SError. Goodbye, cruel world. This clearly is a HW bug,
> and it means that a guest can easily take the host down, on demand.
>
> Thankfully, we have seen systems that were just as broken in the
> past, and we have the perfect vaccine for it.
>
> Apple M1, please meet the Cavium ThunderX workaround. All your
> GIC accesses will be trapped, sanitised, and emulated. Only the
> signalling aspect of the HW will be used. It won't be super speedy,
> but it will at least be safe. You're most welcome.
>
> Given that this has only ever been seen on this single implementation,
> that the spec is unclear at best and that we cannot trust it to ever
> be implemented correctly, gate the workaround solely on ICH_VTR_EL2.SEIS
> being set.

I grepped for system error in Arm IHI 0069F, and turns out there's a number of
ways to make the GIC generate one:

- When programming the ITS

- On a write to ICC_DIR_EL1 (or the corresponding virtual CPU interface register)
with split priority drop/interrupt deactivation is not enabled.

- On a write to GICV_AEOIR or GICC_DIR.

ITS and the legacy GICv2 interface is memory mapped, so I am going to trust that
KVM emulates that correctly and avoids putting the GIC into a state that triggers
the SErrors.

The CPU interface registers are accessed directly by the guest, then changing that
to trap-and-emulate looks like the only way to avoid the guest from crashing the
host with an SError.

As for making the trap-and-emulate depend on the ICH_VTR_EL2.SEIS being set, that
sounds reasonable to me, considering that there were no reports so far of this
being implemented. And if it turns out that there are device which implement GIC
generated SErrors *correctly* and the trap-and-emulate cost is too much, then we
can always get an errata number from Apple and have the trapping depend on that,
right?

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 21a6207fb2ee..ae59e2580bf5 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -671,6 +671,14 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  		group1_trap = true;
>  	}
>  
> +	if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) {
> +		kvm_info("GICv3 with locally generated SEI\n");
> +
> +		group0_trap = true;
> +		group1_trap = true;
> +		common_trap = true;
> +	}
> +
>  	if (group0_trap || group1_trap || common_trap) {
>  		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s], reduced performance)\n",
>  			 group0_trap ? "G0" : "",
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
