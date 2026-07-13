Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160BC26F2B0
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 21:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783978331; cv=none; b=JbSPU6khKdeZENOrUIqVp4x6N8C3LdB+pKOdU4GiR53FzB8UBiEnhNJTO/0Y543bjAzqWAv1jnHRKvkwIqmqMMuOZqWqZT5ZcPwlqsIpXEhCdDi0T++oMfW0Z/O40UuOuaN4EuQSwPrEeu0W9XwtEWExiD7mGoug1qtg4FyiG2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783978331; c=relaxed/simple;
	bh=Z0sMSCAgLgyNWSE7K/gg8WQciaf2vPqoggdSKX7+Z/4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=T67Bi7nm70AcpwxxAZhjwkWhfYO49DY9JwgSzy8tU+Bg/Wuhpbym6GKYJXdd0hZIZ5iTC+poZ9CW/b2Z2FI8ionT/xoTy+UWi8HvzocgaBKXOZTdMBkYrI+zL9h3L0+SxvcQRmEuZdvl1mWHmia4Ek8UsaHY78WCHPPQ9IuHF70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=FMjG4TN5 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="FMjG4TN5"
Received: from [192.168.10.145] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66DLVGmU018090
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 14 Jul 2026 06:31:16 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=7vu1Cqv1kY9MENEn9rk5xVTv4OyzC50IlKtSKEl+6V4=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1783978277; v=1;
        b=FMjG4TN5ZC4Lzu6aXdhRf2FxBZecWOyitGLFQbs5P8rBoBKp/nTv9LnXYVx8oAxD
         HioMIzBQr+XCM+O6fR/Pvg6nKp/eg6Ob+S2qp3XmTrIy8hywhIiaoHUcPKYfv4L1
         tnJOgYvDpM6/vO3n6m3GEtGPLislK5pioqa1KHKC6Q0HGtPyPrQQPbRtYqbyqL/X
         Rk/vz4oWXClhNVmeJpbg4C1yARqOa+eOIntlSDqXm/NIVdc9unvml6NsgkKFMRVm
         gCD0Q0c/NpMtRSfDmGd1egtNS9hNUbih+ffwx9egfb+j+Dm1fBhkUBrr5KtBQr9w
         PiCYTiHTQ1815xOjwOQfSQ==
Message-ID: <3389f9d7-15cb-4bf8-804b-7dcaee2d252e@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 14 Jul 2026 06:31:16 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH v8 01/11] KVM: arm64: Serialize userspace MDCR_EL2 access
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
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
 <20260710-hybrid-v8-1-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <alSU0ZoIQ3sMLo0p@kernel.org>
Content-Language: en-US
In-Reply-To: <alSU0ZoIQ3sMLo0p@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/13 16:33, Oliver Upton wrote:
> Hi,
> 
> On Fri, Jul 10, 2026 at 08:14:55PM +0900, Akihiko Odaki wrote:
>> kvm_arm_set_nr_counters() updates MDCR_EL2.HPMN for every vCPU while
>> holding kvm->arch.config_lock. However, KVM_SET_ONE_REG currently writes
>> MDCR_EL2 through the generic sysreg path without taking the same lock.
>> Concurrent PMU configuration and register restore can therefore race and
>> lose updates to unrelated MDCR_EL2 bits.
> 
> Ugh, we should just stop updating MDCR_EL2.HPMN altogether. Since this
> overwrites the previous value (rather than clamping it) we could discard
> a legal value set by userspace.
> 
>  From the UAPI POV all we need to do is ensure the reset value is sane.
> The documentation says that system registers are reset to their warm
> reset values when KVM_ARM_VCPU_INIT is called. Which in this would mean
> HPMN is reset to the number of implemented counters at the time of the
> ioctl.
> 
> If userspace changes the number of counters afterwards, that's their
> problem.

One wrinkle is that KVM_ARM_VCPU_PMU_V3_SET_PMU and 
KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS can only be used after 
KVM_ARM_VCPU_INIT. Thus, either change necessarily occurs after the
initial MDCR_EL2.HPMN reset value has been established. Userspace can 
issue KVM_ARM_VCPU_INIT again to reset HPMN from the new counter count.

This is awkward, but reflects the ordering imposed by the current UAPI. 
On real hardware, the counter count is fixed before the CPU is reset, 
whereas the UAPI configures it after the initial vCPU reset. 
Reinitializing the vCPU is at least consistent with the documented warm
reset semantics.

I'll update the next version to stop rewriting MDCR_EL2.HPMN after vCPU 
initialization. This also removes the need to serialize userspace 
MDCR_EL2 access or reject HPMN values.

Regards,
Akihiko Odaki

> 
>> Add explicit userspace accessors for MDCR_EL2. Serialize them with
>> config_lock so whole-register userspace writes cannot race with HPMN
>> rewrites, reject HPMN values above the configured PMU counter count, and
>> request a PMU reload when HPME changes to match guest trap behavior.
>>
>> Fixes: c8823e51b534 ("KVM: arm64: Fix MDCR_EL2.HPMN reset value")
>> Closes: https://sashiko.dev/#/patchset/20260706-hybrid-v8-0-de459617b59d%40rsg.ci.i.u-tokyo.ac.jp?part=6
>> Assisted-by: Codex:gpt-5.5
>> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>> ---
>>   arch/arm64/kvm/sys_regs.c | 39 ++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 38 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index d217530359ba..2b2ea33159e9 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2949,6 +2949,42 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
>>   	return true;
>>   }
>>   
>> +static int get_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>> +		    u64 *val)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +
>> +	guard(mutex)(&kvm->arch.config_lock);
> 
> Hrm... I would strongly prefer that we *not* take the config_lock for
> this register since there's no way for userspace to avoid lock
> contention. ID registers are special and documented as VM-scoped, so an
> aware VMM could potentially set these once (avoiding the lock).
> 
>> +	*val = __vcpu_sys_reg(vcpu, MDCR_EL2);
>> +
>> +	return 0;
>> +}
>> +
>> +static int set_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>> +		    u64 val)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	u64 old, hpmn = FIELD_GET(MDCR_EL2_HPMN, val);
>> +
>> +	guard(mutex)(&kvm->arch.config_lock);
>> +
>> +	if (hpmn > vcpu->kvm->arch.nr_pmu_counters)
>> +		return -EINVAL;
> 
> KVM allows userspace to write whatever it wants right now, we can't
> start rejecting values that were previously valid. The architecture also
> allows anything to be written to the field, just that unimplemented
> values have UNKNOWN behavior.
> 
> Thanks,
> Oliver

