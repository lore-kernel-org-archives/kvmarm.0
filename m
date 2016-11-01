From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 2/3] arm64: Add hypervisor safe helper for checking
 constant capabilities
Date: Tue, 1 Nov 2016 14:34:54 +0000
Message-ID: <abe24e99-41bc-bbb9-bbdf-05ebea791684@arm.com>
References: <1477929825-5907-1-git-send-email-suzuki.poulose@arm.com>
 <1477929825-5907-3-git-send-email-suzuki.poulose@arm.com>
 <20161101140359.GF22791@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32BD3402A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 10:34:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id siTGXvrOMT3t for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2016 10:34:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF662402A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 10:34:46 -0400 (EDT)
In-Reply-To: <20161101140359.GF22791@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/11/16 14:03, Will Deacon wrote:
> On Mon, Oct 31, 2016 at 04:03:44PM +0000, Suzuki K Poulose wrote:
>> The hypervisor may not have full access to the kernel data structures
>> and hence cannot safely use cpus_have_cap() helper for checking the
>> system capability. Add a safe helper for hypervisors to check a constant
>> system capability, which *doesn't* fall back to checking the bitmap
>> maintained by the kernel.
>>
>>
>> +/* System capability check for constant caps */
>> +static inline bool cpus_have_const_cap(int num)
>> +{
>> +	if (__builtin_constant_p(num))
>> +		return static_branch_unlikely(&cpu_hwcap_keys[num]);
>> +	BUILD_BUG();
>
> I think you'll already get a build failure if you pass a non-const num
> to static_branch_unlikely, so this seems unnecessary. Furthermore, if
> we're going to introduce a "const-only" version of this function, maybe
> it's best to kill the __builtin_constant_p checks altogether, including
> in the existing cpus_have_cap code? That way, the caller can make the
> decision about whether or not they want to use static keys.

I didn't think that non-const to  static_branch_* would trigger a build
failure. Thanks for that hint. Yes, with that we can safely kill the builtin
checks and define the const version to simply use the static keys.

>
>> +	/* unreachable */
>> +	return false;
>> +}
>> +
>>  static inline bool cpus_have_cap(unsigned int num)
>>  {
>>  	if (num >= ARM64_NCAPS)
>
> It seems odd to check aginst ARM64_NCAPS here, but not in your new function.
> Is the check actually necessary in either case? If so, we should probably
> duplicate it for consistency.

Thanks for catching that. It is needed to make sure we don't access beyond the
size of the bitmask (and the static key array). So it is required. I will fix
those.

Suzuki
