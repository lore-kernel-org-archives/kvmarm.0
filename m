From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 2/2] KVM: doc: add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
Date: Thu, 21 Mar 2019 13:33:18 +0100
Message-ID: <60c2e180-03aa-1b9e-f19c-90d890b99d15@redhat.com>
References: <20190228234334.20456-1-andre.przywara@arm.com>
 <20190228234334.20456-3-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB8D34A2B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 08:33:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pQB1+adC8RFW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Mar 2019 08:33:23 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BF6749F94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 08:33:23 -0400 (EDT)
In-Reply-To: <20190228234334.20456-3-andre.przywara@arm.com>
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
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 3/1/19 12:43 AM, Andre Przywara wrote:
> Add documentation for the newly defined firmware registers to save and
> restore any vulnerability migitation status.
s/migitation/mitigation
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
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
> +  CVE-2017-5715, as described under SMCCC_ARCH_WORKAROUND_1 in [1].> +  Accepted values are:
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: Workaround not available.
> +      The mitigation status for the guest is unknown.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: The workaround HVC call is
> +      available to the guest and required for the mitigation.
It is unclear to me why we don't report the actual enable status too as
for WA2. Assuming the mitigation is not applied on the source (ie. AVAIL
but SMCCC_ARCH_WORKAROUND_1 not called), do we need it on the destination?
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED: The workaround HVC call
> +      is available to the guest, but it is not needed on this VCPU.
> +
> +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +  Holds the state of the firmware controlled workaround to mitigate
> +  CVE-2018-3639, as described under SMCCC_ARCH_WORKAROUND_2 in [1].
This does not really match the terminology used in [1]. At least it is
not straightforward to me.
> +  Accepted values are:
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: Workaround not available.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: Workaround state unknown.
both included in NOT_SUPPORTED. By the way why did we need to be more
precise here? Seems WA1 also has the UNKNOWN state as part of
UNSUPPORTED. Why isn't it homogeneous?
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: Workaround available, and can
> +      be disabled by a vCPU. If KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is
> +      set, it is active for this vCPU.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED: Workaround always active
NOT_REQUIRED or 1?
> +      or not needed.
> +
> +[1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> 
Thanks

Eric
