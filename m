Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF07A3F4DC3
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 11:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783422542; cv=none; b=fuA8FLxcciQLNVweOP1gonhUwzmHCwPIghDe8bzPXfoO6QML+eS3bccNxUb3xmN7a4ME8hWZ2MiWp6l+IBY6fW2JvWHKIApiG7RuHXsaNI80uq2osD62SQb6DF70zfM05NxGGmOP/PJLmFt+2DP+CnX97RyHisrbmsC43GCS4IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783422542; c=relaxed/simple;
	bh=iK7dKcjYUoHiHjp3U9/+pUN7cnRMsGs/EjDO7OFT2Cg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P4KCWdzFWp2tQH6+kfZECNX9lnuFuv7FGMqzG8LkSwT8qfK2UAMYmDMiioz0cQm8tuf6OFcVuUChQmLeSNbvk5IEzgVNsLaUwHumSrNU1bX4W2h7tKQT8csDHb9+kIGJU/L4i/SAdj6npg39PCSDEu8DUSd+tf3iifPfslcm1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=sT4HpAzG reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="sT4HpAzG"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 667B84DM000649
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 7 Jul 2026 20:08:04 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=g0ZGQJGJ1qWqh1QXg5+nZXDEWKnJXbLoKauNjx/PAYs=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1783422484; v=1;
        b=sT4HpAzGMYEhZYKHTkNka9jCpR9kdvZwWiGM6RHY8o5Jh50Xpv3CLKHIKN5BSGDP
         UO9T1j6Mo6pDZFawvG0JpSHS1WRGQgTcL5yPRrmCURV1XzeKV/H3TMAPnxTU9p1V
         BLHavpto5ibL75WXfBnQhvRrIXlF9L7zRvrsUE/sWBqGdW/n26udhLUkIK8iD6v2
         yiKor0wuTpnWYPkRduMdyP3Y5HN5FEhy/fSIctEA6OldtFope5KzYn0rd7aaALgB
         4kw5t2aTJC5oKb2k3QLKVcaLjYMySaA/rW8Xxp5xBwzj/GbXi2uJlJKHeUSBneYY
         1WxHlDXk9luvKXTDy+VdmA==
Message-ID: <e03f17b2-a765-4912-adf6-3da26e7eeecd@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 7 Jul 2026 20:08:03 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/7] KVM: arm64: Disallow vPMU when pPMUs do not cover
 all CPUs
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
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-1-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <akvgIWqBjAp_VA_A@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <akvgIWqBjAp_VA_A@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/07 2:04, Oliver Upton wrote:
> Hi,
> 
> On Mon, Jul 06, 2026 at 07:03:24PM +0900, Akihiko Odaki wrote:
>> Commit ec3eb9ed6081 ("KVM: arm64: PMU: Disallow vPMU on non-uniform
>> PMUVer") made KVM reject vPMU unless the system-wide PMUVer is usable.
>> That covers systems where PMUv3 is absent or non-uniform, as well as
>> systems where IMPDEF PMUv3 sysreg traps are unavailable.
>>
>> However, KVM can still accept vPMU when all CPUs uniformly trap PMUv3
>> sysregs, but the pPMUs registered with KVM only cover a subset of
>> possible CPUs.
>>
>> Reject vPMU unless the registered pPMUs cover every possible CPU.
>> This avoids carrying support for partial pPMU coverage into the
>> fixed-counters-only UAPI introduced later in the series.
> 
> Doesn't CPU hotplug screw this up? I could online a CPU that doesn't
> have a PMU after creating the VM.>
> I'd rather just change ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS to become a
> system feature. That way any CPU which breaks the system-wide assumption
> cannot be onlined.

ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS only says that IMPDEF PMUv3 sysregs 
are trapped. It does not say that KVM has a driver-backed PMU usable for 
PMUv3 emulation. This patch checks that extra requirement.

I re-checked CPU hotplug. Onlining a CPU without a PMU later does not 
make an accepted VM unsafe, since the check is against 
cpu_possible_mask. The problem is the reverse case on ACPI: this check 
can disable vPMU when a possible CPU is offline. DT populates 
supported_cpus at boot, while ACPI initially populates it only from 
online CPUs and grows it as matching CPUs come online.

That makes this patch too conservative. In practice, I do not expect 
systems to mix CPUs with and without a usable PMU. A better approach is 
probably to treat such a host as out of spec and add 
TAINT_CPU_OUT_OF_SPEC. We already do that for architectural PMUv3 by 
detecting mismatches in ID_AA64DFR0_EL1.PMUVer; we can do the same for 
ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS with non-standard PMUs.

Regards,
Akihiko Odaki
