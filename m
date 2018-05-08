From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 10/14] KVM: arm64: Save host SVE context as appropriate
Date: Tue, 8 May 2018 12:57:56 +0100
Message-ID: <ab34071f-1808-f33a-e9a0-3067afa815af@arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
 <1525449935-31424-11-git-send-email-Dave.Martin@arm.com>
 <0c616c43-3bff-1c93-0463-fae1c53c0e51@arm.com>
 <20180508112514.GE7753@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32929400D4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 May 2018 07:48:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EDhNUPHfD5IG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 May 2018 07:48:00 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F1C340458
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 May 2018 07:48:00 -0400 (EDT)
In-Reply-To: <20180508112514.GE7753@e103592.cambridge.arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/05/18 12:25, Dave Martin wrote:
> On Tue, May 08, 2018 at 11:38:05AM +0100, Marc Zyngier wrote:
>> On 04/05/18 17:05, Dave Martin wrote:
>>> This patch adds SVE context saving to the hyp FPSIMD context switch
>>> path.  This means that it is no longer necessary to save the host
>>> SVE state in advance of entering the guest, when in use.
>>>
>>> In order to avoid adding pointless complexity to the code, VHE is
>>> assumed if SVE is in use.  VHE is an architectural prerequisite for
>>> SVE, so there is no good reason to turn CONFIG_ARM64_VHE off in
>>> kernels that support both SVE and KVM.
>>>
>>> Historically, software models exist that can expose the
>>> architecturally invalid configuration of SVE without VHE, so if
>>> this situation is detected this patch warns and refuses to create a
>>> VM.  Doing this check at VM creation time avoids race issues
>>> between KVM and SVE initialisation.
>>>
>>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>>> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
>>> ---
>>>  arch/arm64/Kconfig          |  7 +++++++
>>>  arch/arm64/kvm/fpsimd.c     |  1 -
>>>  arch/arm64/kvm/hyp/switch.c | 21 +++++++++++++++++++--
>>>  virt/kvm/arm/arm.c          | 18 ++++++++++++++++++
>>>  4 files changed, 44 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>> index eb2cf49..b0d3820 100644
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -1130,6 +1130,7 @@ endmenu
>>>  config ARM64_SVE
>>>  	bool "ARM Scalable Vector Extension support"
>>>  	default y
>>> +	depends on !KVM || ARM64_VHE
>>
>> In that case, should we consider making ARM64_VHE "default y" as well,
>> as KVM is "default y" too?
> 
> Surely ARM64_VHE has always been default y?
> 
> 1f364c8c48a0 ("arm64: VHE: Add support for running Linux in EL2 mode")

Hmmm. I have no idea who this Zyngier guy from 2014 is. Oh well.

>> Otherwise, I fear we end-up regressing existing configurations. Also,
>> you still have to check for the configuration at run time, so I'm not
>> immediately getting the point of this particular change.
> 
> We check for the configuration, but the penalty is severe (i.e., can't
> create VMs) and it doesn't appear to make sense to put effort into
> working around that: the user has an easy fix in the form of setting
> ARM64_VHE=y.
> 
> Is there some value to supporting this configuration that I'm missing?
> SVE and VHE are both default y.

I had the (obviously wrong) idea that VHE didn't default to y.

> 
> [...]
> 
>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>> index 6cf499b..a7be7bf 100644
>>> --- a/virt/kvm/arm/arm.c
>>> +++ b/virt/kvm/arm/arm.c
>>> @@ -16,6 +16,7 @@
>>>   * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
>>>   */
>>>  
>>> +#include <linux/bug.h>
>>>  #include <linux/cpu_pm.h>
>>>  #include <linux/errno.h>
>>>  #include <linux/err.h>
>>> @@ -41,6 +42,7 @@
>>>  #include <asm/mman.h>
>>>  #include <asm/tlbflush.h>
>>>  #include <asm/cacheflush.h>
>>> +#include <asm/cpufeature.h>
>>>  #include <asm/virt.h>
>>>  #include <asm/kvm_arm.h>
>>>  #include <asm/kvm_asm.h>
>>> @@ -120,6 +122,22 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>  	if (type)
>>>  		return -EINVAL;
>>>  
>>> +	/*
>>> +	 * VHE is a prerequisite for SVE in the Arm architecture, and
>>> +	 * Kconfig ensures that if system_supports_sve() here then
>>> +	 * CONFIG_ARM64_VHE is enabled, so if VHE support wasn't already
>>> +	 * detected and enabled, the CPU is architecturally
>>> +	 * noncompliant.
>>> +	 *
>>> +	 * Just in case this mismatch is seen, detect it, warn and give
>>> +	 * up.  Supporting this forbidden configuration in Hyp would be
>>> +	 * pointless.
>>> +	 */
>>> +	if (system_supports_sve() && !has_vhe()) {
>>> +		kvm_pr_unimpl("Cannot create VMs on SVE system without VHE.  Broken cpu?");
>>> +		return -ENXIO;
>>> +	}
>>
>> You might as well fail the boot KVM initialization altogether, and not
>> wait for a VM to be created.
> 
> I was concerned that the SVE and KVM initialisation might happen in
> an unpredictable order.
> 
> KVM is initialised via module_init(), which I'm guessing is later than
> cpufeatures (?)  If so then yes, kvm_arch_init() would be a reasonable
> place to do this.

CPU features are set in stone very early, right after we've booted all
the CPUs that can be discovered before running userspace. KVM itself
relies on that, so you should be able to move that check pretty early.

>> But I'm more concerned with the fact that we're now have a configuration
>> that drops functionalities on the floor, one way or another.
> 
> Is this still a problem if that configuration is forbidden by Kconfig?
> 
> Can you describe a scenario in which the problem config (KVM=y, VHE=n,
> SVE=y) would be wanted?

Not really. I guess it is just me being paranoid and not realising we
had VHE on by default already.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
