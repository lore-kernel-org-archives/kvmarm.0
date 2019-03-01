From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v5 06/26] arm64/sve: Check SVE virtualisability
Date: Fri, 1 Mar 2019 12:39:52 +0000
Message-ID: <d8d4d25d-13b7-be23-77bb-7cf498c8463a@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-7-git-send-email-Dave.Martin@arm.com>
 <64764e35-c243-e642-a868-5b9e221813c7@arm.com>
 <20190226120630.GH3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE364A429
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 07:40:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NHUF4Xc75keU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Mar 2019 07:40:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B6F84A408
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 07:40:02 -0500 (EST)
In-Reply-To: <20190226120630.GH3567@e103592.cambridge.arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 26/02/2019 12:06, Dave Martin wrote:
> On Wed, Feb 20, 2019 at 11:12:49AM +0000, Julien Thierry wrote:
>> Hi Dave,
>>
>> On 18/02/2019 19:52, Dave Martin wrote:
>>> Due to the way the effective SVE vector length is controlled and
>>> trapped at different exception levels, certain mismatches in the
>>> sets of vector lengths supported by different physical CPUs in the
>>> system may prevent straightforward virtualisation of SVE at parity
>>> with the host.
>>>
>>> This patch analyses the extent to which SVE can be virtualised
>>> safely without interfering with migration of vcpus between physical
>>> CPUs, and rejects late secondary CPUs that would erode the
>>> situation further.
>>>
>>> It is left up to KVM to decide what to do with this information.
>>>
>>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>>> ---
>>>  arch/arm64/include/asm/fpsimd.h |  1 +
>>>  arch/arm64/kernel/cpufeature.c  |  2 +-
>>>  arch/arm64/kernel/fpsimd.c      | 86 ++++++++++++++++++++++++++++++++++-------
>>>  3 files changed, 73 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
>>> index dd1ad39..964adc9 100644
>>> --- a/arch/arm64/include/asm/fpsimd.h
>>> +++ b/arch/arm64/include/asm/fpsimd.h
>>> @@ -87,6 +87,7 @@ extern void sve_kernel_enable(const struct arm64_cpu_capabilities *__unused);
>>>  extern u64 read_zcr_features(void);
>>>  
>>>  extern int __ro_after_init sve_max_vl;
>>> +extern int __ro_after_init sve_max_virtualisable_vl;
>>>  
>>>  #ifdef CONFIG_ARM64_SVE
>>>  
>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>> index f6d84e2..5eaacb4 100644
>>> --- a/arch/arm64/kernel/cpufeature.c
>>> +++ b/arch/arm64/kernel/cpufeature.c
>>> @@ -1825,7 +1825,7 @@ static void verify_sve_features(void)
>>>  	unsigned int len = zcr & ZCR_ELx_LEN_MASK;
>>>  
>>>  	if (len < safe_len || sve_verify_vq_map()) {
>>> -		pr_crit("CPU%d: SVE: required vector length(s) missing\n",
>>> +		pr_crit("CPU%d: SVE: vector length support mismatch\n",
>>>  			smp_processor_id());
>>>  		cpu_die_early();
>>>  	}
>>> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
>>> index 62c37f0..64729e2 100644
>>> --- a/arch/arm64/kernel/fpsimd.c
>>> +++ b/arch/arm64/kernel/fpsimd.c
>>> @@ -18,6 +18,7 @@
>>>   */
>>>  
>>>  #include <linux/bitmap.h>
>>> +#include <linux/bitops.h>
>>>  #include <linux/bottom_half.h>
>>>  #include <linux/bug.h>
>>>  #include <linux/cache.h>
>>> @@ -48,6 +49,7 @@
>>>  #include <asm/sigcontext.h>
>>>  #include <asm/sysreg.h>
>>>  #include <asm/traps.h>
>>> +#include <asm/virt.h>
>>>  
>>>  #define FPEXC_IOF	(1 << 0)
>>>  #define FPEXC_DZF	(1 << 1)
>>> @@ -130,14 +132,18 @@ static int sve_default_vl = -1;
>>>  
>>>  /* Maximum supported vector length across all CPUs (initially poisoned) */
>>>  int __ro_after_init sve_max_vl = SVE_VL_MIN;
>>> +int __ro_after_init sve_max_virtualisable_vl = SVE_VL_MIN;
>>>  /* Set of available vector lengths, as vq_to_bit(vq): */
>>>  static __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
>>> +/* Set of vector lengths present on at least one cpu: */
>>> +static __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
>>>  static void __percpu *efi_sve_state;
>>>  
>>>  #else /* ! CONFIG_ARM64_SVE */
>>>  
>>>  /* Dummy declaration for code that will be optimised out: */
>>>  extern __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
>>> +extern __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
>>>  extern void __percpu *efi_sve_state;
>>>  
>>>  #endif /* ! CONFIG_ARM64_SVE */
>>> @@ -623,12 +629,6 @@ int sve_get_current_vl(void)
>>>  	return sve_prctl_status(0);
>>>  }
>>>  
>>> -/*
>>> - * Bitmap for temporary storage of the per-CPU set of supported vector lengths
>>> - * during secondary boot.
>>> - */
>>> -static DECLARE_BITMAP(sve_secondary_vq_map, SVE_VQ_MAX);
>>> -
>>>  static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
>>>  {
>>>  	unsigned int vq, vl;
>>> @@ -650,6 +650,7 @@ static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
>>>  void __init sve_init_vq_map(void)
>>>  {
>>>  	sve_probe_vqs(sve_vq_map);
>>> +	bitmap_copy(sve_vq_partial_map, sve_vq_map, SVE_VQ_MAX);
>>>  }
>>>  
>>>  /*
>>> @@ -658,25 +659,58 @@ void __init sve_init_vq_map(void)
>>>   */
>>>  void sve_update_vq_map(void)
>>>  {
>>> -	sve_probe_vqs(sve_secondary_vq_map);
>>> -	bitmap_and(sve_vq_map, sve_vq_map, sve_secondary_vq_map, SVE_VQ_MAX);
>>> +	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
>>> +
>>> +	sve_probe_vqs(tmp_map);
>>> +	bitmap_and(sve_vq_map, sve_vq_map, tmp_map, SVE_VQ_MAX);
>>> +	bitmap_or(sve_vq_partial_map, sve_vq_partial_map, tmp_map, SVE_VQ_MAX);
>>>  }
>>>  
>>>  /* Check whether the current CPU supports all VQs in the committed set */
>>>  int sve_verify_vq_map(void)
>>>  {
>>> -	int ret = 0;
>>> +	DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
>>> +	unsigned long b;
>>>  
>>> -	sve_probe_vqs(sve_secondary_vq_map);
>>> -	bitmap_andnot(sve_secondary_vq_map, sve_vq_map, sve_secondary_vq_map,
>>> -		      SVE_VQ_MAX);
>>> -	if (!bitmap_empty(sve_secondary_vq_map, SVE_VQ_MAX)) {
>>> +	sve_probe_vqs(tmp_map);
>>> +
>>> +	bitmap_complement(tmp_map, tmp_map, SVE_VQ_MAX);
>>> +	if (bitmap_intersects(tmp_map, sve_vq_map, SVE_VQ_MAX)) {
>>>  		pr_warn("SVE: cpu%d: Required vector length(s) missing\n",
>>>  			smp_processor_id());
>>> -		ret = -EINVAL;
>>> +		return -EINVAL;
>>>  	}
>>>  
>>> -	return ret;
>>> +	if (!IS_ENABLED(CONFIG_KVM) || !is_hyp_mode_available())
>>> +		return 0;
>>> +
>>> +	/*
>>> +	 * For KVM, it is necessary to ensure that this CPU doesn't
>>> +	 * support any vector length that guests may have probed as
>>> +	 * unsupported.
>>> +	 */
>>> +
>>> +	/* Recover the set of supported VQs: */
>>> +	bitmap_complement(tmp_map, tmp_map, SVE_VQ_MAX);
>>> +	/* Find VQs supported that are not globally supported: */
>>> +	bitmap_andnot(tmp_map, tmp_map, sve_vq_map, SVE_VQ_MAX);
>>> +
>>> +	/* Find the lowest such VQ, if any: */
>>> +	b = find_last_bit(tmp_map, SVE_VQ_MAX);
>>> +	if (b >= SVE_VQ_MAX)
>>> +		return 0; /* no mismatches */
>>> +
>>> +	/*
>>> +	 * Mismatches above sve_max_virtualisable_vl are fine, since
>>> +	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
>>> +	 */
>>> +	if (sve_vl_from_vq(bit_to_vq(b)) <= sve_max_virtualisable_vl) {
>>> +		pr_warn("SVE: cpu%d: Unsupported vector length(s) present\n",
>>
>> Nit: might be good to specify that the vector length is unsupported for
>> virtualisation.
>>
>> Also, since KVM is the one deciding what to do with the information,
>> should we have a warning here? But I can understand that knowing which
>> CPUs are introducing unsupported vector length, maybe using pr_devel()
>> instead of pr_warn()
> 
> These warnings are really for consumption by SoC vendors, not users:
> my aim is to flag up systems that we consider broken (or at least,
> unsuitable for running KVM).
> 
> So I prefer to make this noisy and limit the amount of "useful"
> information people might be tempted to programmatically scrape from
> dmesg.
> 
> cpufeatures uses pr_warn("SANITY CHECK: [...]") here.  Maybe I should
> stick "SANITY CHECK" in here too?  I will also try to make the commit
> message more explicit and/or add comments to make the intent of the code
> clearer.
> 
> It may also make sense to make this noise even if KVM isn't enabled
> (which is a rare case anyhow).
> 
> Thoughts?

As I explained later in the patch series, I missed the fact that this
function was for late secondary CPUs. I think things are fine like this
(just add the bit about the vector lenght not being supported for
virtualisation).

Cheers,

-- 
Julien Thierry
