Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2A71E515
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 06:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785393429; cv=none; b=FFFz2J5R2nN2D7hFYygdfSrRfaQaTjLk0oYQm3lEUhG+5b+pzMZ0ezM4R5uDCDcOIk6X3o6Gbgjo4P4sd2BQUx0HkSouJ7KBVyKaAtkjiGH91Y5wUcAl/12jG4w1noyUwFhFPpzqWZO1Ak1ht2jtRYEr+guDIQ3rn2w+xXIirXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785393429; c=relaxed/simple;
	bh=d6cqkNkrA6VgWVaf8YHHsunGkY2K7fvI3djAUWPPOJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XRkSRuT+1CS6NydP4Rq0F03Gt5TT+PwN1m5s2+gVcnc6A52sTaKC8RKRjTUs4QvQgOZuRkAbNqdHjSZugOpntBWjqzL2X4FxKiaoo9nfeWKoZkvL0103JvJtCs8tRW55p3R7gM7TMK4wsSfTKja/UIWWnsVykAbdIS0w6fMs5lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=CR02EmMJ; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="CR02EmMJ"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66U6aH4o056545
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 30 Jul 2026 15:36:17 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=/MaMi87RWhMSAus5qN4EIk8TtDM9x9f0bzGDNP+s4l8=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1785393378; v=1;
        b=CR02EmMJ6YJKNFkKLren40kXzZGtLt35yQRS20Az0NGX7Jm0IItpOIiJ48tk4D+j
         rVeOUQaPTaJLIRQMGQGPymW+FcXh4R5wmIxwBqX6xun4O/ZABjohzvFq452q1ev/
         YrSg6ACGWGVzhxeqB01mYofr+/ZJgWbwtqkkbmyAAP/YRm1+e7Rz3/UVkgzaU6Wt
         dr0B0wZv9b+dBkyktdOfUGGcH10DMnIhloYmuEY1CnDswT7VJRMVYCyf8ra5Kb4s
         ZKZderu/9rHc0ARcUKa3rC1OPfvFkqbg9UXc7WcR4S+1DZISyboyD9RQ+jn0zfbV
         viziw2KISB01Nbt8FTXigQ==
Message-ID: <e023d791-38c3-47b4-9b09-3420fe78d9ea@rsg.ci.i.u-tokyo.ac.jp>
Date: Thu, 30 Jul 2026 15:36:15 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/16] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas
 <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-14-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <CA+EHjTx0zNQ_yPCz38vGYpBssshE4b3KWaoUxjzuerGgzB=JSQ@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <CA+EHjTx0zNQ_yPCz38vGYpBssshE4b3KWaoUxjzuerGgzB=JSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/07/30 3:18, Fuad Tabba wrote:
> Hi Akihiko,
> 
> On Mon, 20 Jul 2026 at 06:39, Akihiko Odaki
> <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
> ...
> 
>> +/**
>> + * kvm_pmu_create_perf_event - create a perf event for a counter
>> + * @pmc: Counter context
>> + */
>> +static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>> +{
>> +       struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>> +       struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
>> +
>> +       if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
>> +               do {
>> +                       arm_pmu = kvm_pmu_probe_armpmu(READ_ONCE(vcpu->cpu));
>> +
>> +                       if (!arm_pmu) {
>> +                               pr_warn_once("kvm: Unsupported PMU variation detected.\n");
>> +                               add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
>> +                               return;
>> +                       }
> 
> Sashiko flagged that this can leave the perf event out of sync with
> the sysreg, which looks plausible: on a pCPU with no registered pPMU
> this returns without recreating the event, so a guest event-type
> change there updates the sysreg but not the event, and after migrating
> back to a pCPU the original pPMU covers, kvm_pmc_enable_perf_event()
> re-enables the stale event instead of recreating it.
> 
> I know you treat the no-pPMU case as out of spec, but the dropped
> update lands once the vCPU is back on a normal pCPU. Is this intended?

"[PATCH v9 06/16] KVM: arm64: PMU: Recreate events after MDCR_EL2 
changes" calls kvm_pmu_stop_counter() in kvm_vcpu_reload_pmu(), so it 
does not matter whether this function calls kvm_pmu_stop_counter().

The other changes that require recreating the event are currently not 
handled at all as Sashiko complains [1]. I'll fix that as done in 
MDCR_EL2 setters in the next version.

That said, I do not intend to add any extra complexity to provide any 
guarantee for a system with unsupported PMU variation except that the 
user can notice and react to that (i.e., the taint is reported and no 
oops happens due to NULL dereference). The patch message is somewhat 
misleading in this aspect so I'm going to fix that in the next version.

[1] 
https://sashiko.dev/#/patchset/20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=6

Regards,
Akihiko Odaki
