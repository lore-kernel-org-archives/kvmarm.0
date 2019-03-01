From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v4 2/2] KVM: doc: add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
Date: Fri, 1 Mar 2019 15:19:27 +0000
Message-ID: <f5ab7286-1728-2827-eec0-bf800afe91a1@arm.com>
References: <20190228234334.20456-1-andre.przywara@arm.com>
 <20190228234334.20456-3-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 693E64A44F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 10:19:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yyTtd4a7n6SX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Mar 2019 10:19:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28BC94A3BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 10:19:31 -0500 (EST)
In-Reply-To: <20190228234334.20456-3-andre.przywara@arm.com>
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
Cc: kvm@vger.kernel.org, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 28/02/2019 23:43, Andre Przywara wrote:
> Add documentation for the newly defined firmware registers to save and
> restore any vulnerability migitation status.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  Documentation/virtual/kvm/arm/psci.txt | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
> index aafdab887b04..1ed0f0515cd8 100644
> --- a/Documentation/virtual/kvm/arm/psci.txt
> +++ b/Documentation/virtual/kvm/arm/psci.txt
> @@ -28,3 +28,28 @@ The following register is defined:
>    - Allows any PSCI version implemented by KVM and compatible with
>      v0.2 to be set with SET_ONE_REG
>    - Affects the whole VM (even if the register view is per-vcpu)
> +
> +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> +  Holds the state of the firmware controlled workaround to mitigate
> +  CVE-2017-5715, as described under SMCCC_ARCH_WORKAROUND_1 in [1].
> +  Accepted values are:
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: Workaround not available.
> +      The mitigation status for the guest is unknown.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: The workaround HVC call is
> +      available to the guest and required for the mitigation.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED: The workaround HVC call
> +      is available to the guest, but it is not needed on this VCPU.
> +
> +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +  Holds the state of the firmware controlled workaround to mitigate
> +  CVE-2018-3639, as described under SMCCC_ARCH_WORKAROUND_2 in [1].
> +  Accepted values are:
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: Workaround not available.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: Workaround state unknown.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: Workaround available, and can
> +      be disabled by a vCPU. If KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is
> +      set, it is active for this vCPU.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED: Workaround always active
> +      or not needed.
> +
> +[1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> 
