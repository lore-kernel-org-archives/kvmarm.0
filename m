From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 2/2] KVM: doc: add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
Date: Fri, 22 Feb 2019 17:16:38 +0000
Message-ID: <32ae20c4-d2fc-db76-6f2c-368f8cbad0ed@arm.com>
References: <20190222121818.30164-1-andre.przywara@arm.com>
 <20190222121818.30164-3-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190222121818.30164-3-andre.przywara@arm.com>
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
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Dave Martin <dave.martin@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/02/2019 12:18, Andre Przywara wrote:
> Add documentation for the newly defined firmware registers to save and
> restore any vulnerability migitation status.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Documentation/virtual/kvm/arm/psci.txt | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
> index aafdab887b04..fe8930765cc7 100644
> --- a/Documentation/virtual/kvm/arm/psci.txt
> +++ b/Documentation/virtual/kvm/arm/psci.txt
> @@ -28,3 +28,27 @@ The following register is defined:
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
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: Workaround active for the guest.
> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED: The workaround is not
> +      available and not needed.

This definition of "unaffected" doesn't match the definition in ARM
DEN-0070A - specifically a value of "1" means:

  SMCCC_ARCH_WORKAROUND_1 can be invoked safely on all PEs in the
  system.
  The PE on which SMCCC_ARCH_FEATURES is called does not require
  firmware mitigation for CVE-2017-5715.

i.e. the workaround *is* available - just not needed.

This difference is important if/when we allow migration from an "AVAIL"
host to an "UNAFFECTED" host - the workaround calls can still be made
even though they are redundant.

Steve

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
