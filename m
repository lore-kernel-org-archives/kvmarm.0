From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v5 3/3] KVM: doc: add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
Date: Mon, 15 Apr 2019 15:06:08 +0100
Message-ID: <7186c743-46fd-e358-21c4-82883d9b8819@arm.com>
References: <20190415111542.119788-1-andre.przywara@arm.com>
 <20190415111542.119788-4-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E36A94A4BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 10:06:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AJ1894tsB54W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 10:06:12 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 746CA4A4B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 10:06:12 -0400 (EDT)
In-Reply-To: <20190415111542.119788-4-andre.przywara@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/04/2019 12:15, Andre Przywara wrote:
> Add documentation for the newly defined firmware registers to save and
> restore any vulnerability mitigation status.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Steven Price <steven.price@arm.com>

Thanks,

Steve

> ---
>  Documentation/virtual/kvm/arm/psci.txt | 31 ++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
> index aafdab887b04..a876c1baa56e 100644
> --- a/Documentation/virtual/kvm/arm/psci.txt
> +++ b/Documentation/virtual/kvm/arm/psci.txt
> @@ -28,3 +28,34 @@ The following register is defined:
>    - Allows any PSCI version implemented by KVM and compatible with
>      v0.2 to be set with SET_ONE_REG
>    - Affects the whole VM (even if the register view is per-vcpu)
> +
> +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> +  Holds the state of the firmware support to mitigate CVE-2017-5715, as
> +  offered by KVM to the guest via a HVC call. The workaround is described
> +  under SMCCC_ARCH_WORKAROUND_1 in [1].
> +  Accepted values are:
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: KVM does not offer
> +      firmware support for the workaround. The mitigation status for the
> +      guest is unknown.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: The workaround HVC call is
> +      available to the guest and required for the mitigation.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED: The workaround HVC call
> +      is available to the guest, but it is not needed on this VCPU.
> +
> +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +  Holds the state of the firmware support to mitigate CVE-2018-3639, as
> +  offered by KVM to the guest via a HVC call. The workaround is described
> +  under SMCCC_ARCH_WORKAROUND_2 in [1].
> +  Accepted values are:
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: A workaround is not
> +      available. KVM does not offer firmware support for the workaround.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: The workaround state is
> +      unknown. KVM does not offer firmware support for the workaround.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: The workaround is available,
> +      and can be disabled by a vCPU. If
> +      KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is set, it is active for
> +      this vCPU.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED: The workaround is always
> +      active on this vCPU or it is not needed.
> +
> +[1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> 
