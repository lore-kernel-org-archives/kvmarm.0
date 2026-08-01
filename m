Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCF1372ED7
	for <kvmarm@lists.linux.dev>; Sat,  1 Aug 2026 06:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785566114; cv=none; b=FfW8vhcy5rVLezTy4kPrC0HeH3vo50MSr/L6WMOd0ycv3x0GmGrTReNNfFcXLhFsZHz3Qgju87vcWZCBKH3LPMOr77Yfr+jKM6yjPMX5LBVEmnV8l2fz4m0M/aYiVdES3dlZNzaqRi9MqOGqgCw+MKC9dxtj9125gVq4MZwuySw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785566114; c=relaxed/simple;
	bh=sobde0AGf3S5vrulxqXSeE8Yr9d4n8k+fI0Q3+tlJuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HWN1sBlS+juAW86zuT63GQRnJvHwcl4v0o0G0VU+dJaoVZU+CmRofGfIFagV5xJN0nASDu8IoHt1bBWELp01Ai2u+yBGHb27287hgmgeNW1fVFxLs2/Zal0KXfvMqxwGwlXajDF8P6mFp2XOg2rp9+yJFa7ugvLHUuChzxitHP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=K2XFECkA; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="K2XFECkA"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 6716YCSG018797
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 1 Aug 2026 15:34:12 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=xJoh3FskZlMZXN0frCV7KCjMR5sn7IPdvl3P81QRqzo=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1785566053; v=1;
        b=K2XFECkA0Z9J1wXM376KVU1kqybglUVyvN9n43lQWKGqRyrvg+1wAHFpXKrsJyTv
         7dO28hIdlCPUIKivvDpx66LiaWaMiUf1eMwX6HKnwGFy0BQRI/ZPqLF3hJ52UeoK
         9AP8hhhgXc9PTpW4Zl0NUnJo17Epe0Or63UjaIvExn2v2BtXF+fsswayy25CM5r7
         A6r0MtMXHSxU1bBIFTHXchDGmoYOLmKCHLdg5MhGoVcYXjwTa2rvghFY1qORzTYk
         LMgUJyt3SOTNzfKJTvTGqH9iBdkizXE0bRzs4ZGh1kMGUExnDgbs3mZYI8tjnGuQ
         I5KG078+99SmfBTRnx/1lg==
Message-ID: <417908e2-c226-46a3-9dbe-a7a2432d1662@rsg.ci.i.u-tokyo.ac.jp>
Date: Sat, 1 Aug 2026 15:34:11 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/11] arm64: errata: Require Apple IMPDEF PMUv3 traps
 on all CPUs
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas
 <catalin.marinas@arm.com>,
        Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <20260710-hybrid-v8-4-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <amzSTp3cUCMuwJKf@google.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <amzSTp3cUCMuwJKf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/08/01 1:50, Will Deacon wrote:
> On Fri, Jul 10, 2026 at 08:14:58PM +0900, Akihiko Odaki wrote:
>> KVM relies on ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS as a system-wide
>> precondition for PMUv3 emulation on affected Apple CPUs. A local CPU
>> erratum is too weak for that: once the workaround is enabled, a late CPU
>> that misses it may still be onlined.
>>
>> Make the workaround an all-early-CPU capability instead. The matcher is
>> still local because it depends on MIDR_EL1, but the capability is only
>> advertised if all early CPUs match, and late CPUs that miss it are
>> rejected once the capability is enabled.
>>
>> Assisted-by: Codex:gpt-5.5
>> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>> ---
>>   arch/arm64/kernel/cpu_errata.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> index 476a37c82108..14ce49d693c4 100644
>> --- a/arch/arm64/kernel/cpu_errata.c
>> +++ b/arch/arm64/kernel/cpu_errata.c
>> @@ -964,7 +964,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>>   	{
>>   		.desc = "Apple IMPDEF PMUv3 Traps",
>>   		.capability = ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS,
>> -		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
>> +		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
> 
> I always get tangled in knots with this code, but does this correctly
> handle the case where the boot/early CPUs don't have the impdef PMU
> feature but late-onlined CPUs do? I'm not sure we configure the traps
> correctly in that case but this is all gloriously undocumented.
It's not only you but Fuad and Sashiko also had the same question:
https://lore.kernel.org/qemu-devel/4cf2911c-610e-4cf1-9c42-cc5792265a89@rsg.ci.i.u-tokyo.ac.jp/

The answer is that we simply don't enable hypervisor traps. Accessing 
PMUv3 registers will be UNDEFINED on all CPUs, enforcing the 
architectural behavior system-wide.

I plan to change the patch message to clarify this in the next version.

Regards,
Akihiko Odaki
