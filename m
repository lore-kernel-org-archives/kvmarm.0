Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC554FD280
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061101; cv=none; b=F6xL8pc6RQIEN+8cipBX51bhrznRiykwkBLLK5ehercvIgcPl5R0J7NxckmBy98zAnsZAgBz2wrLgtFz5mehx5NhujHLp5/sKqi99gwTFJQdl1cr+KgCZyNGAbE7K5VRdTOfdYxB2jbTQGgbophX+O/oYGvwt09G8nTRD6pfJPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061101; c=relaxed/simple;
	bh=7NV2/dPlabk4dE/ISiIN6mRrLG4mHifu6XdIsUTFFVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iLJy0bLSEhNiAW9VX4mJ8XRbD2B5RCmyYVlh4prSCOKrkvsao4xH38bsQIeF4e6p5/f15jIDK1ghfAHUXjAPSIsNxljtb4TsLWZD0dv3HhVQdWJDjEy/enoJrh8tP3u0lvHywojKfeXDfR2VwSHTdb+jGZDEX42t+xFFKI+dFV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=PIX6HpEs; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="PIX6HpEs"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68M758Hb079658
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 22 Sep 2026 16:05:08 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=T90uQyrwOkRtULqcM/E6YsXMU8ThCL+v0Olp5Ari6hs=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1790060708; v=1;
        b=PIX6HpEsycuGjgwF+yYJEKbW2YxRThaU7EHQIZGK5L/lQ22qD4JgBSnRVBDQshf3
         Q3mYoWJmW61Zd5jCJ807XJD2ckYUsNMMIXCSMfO3rjw3vVrifWt7ncSg/BcZLQee
         vauZt/VF/clNeVik7NWRPYJayqFARm8MwM5cGkxhQxUiIbeZXzoUmlqIS4wwB/Z1
         L9juduXuRjjajH+awmMnM4mU2p2Wc8O5mzkj7ZBN8yYxCqEsBehxz/Zx/ZmpXuRn
         E65YvkFWnuPiZxTFsySrYR4F8I5XKjB/kakCvhD6gHlnvsKt28tJjrobhpK/KeGG
         whouyOtt7HDBh8h9zxg5/g==
Message-ID: <fe6ddd43-7de2-4715-819b-952296456fca@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 22 Sep 2026 16:05:06 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/21] Revert "KVM: arm64: PMU: Reload when resetting"
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
        Steffen Eiden <seiden@linux.ibm.com>,
        Andrew Jones <andrew.jones@oss.qualcomm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Randy Dunlap
 <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920-hybrid-v11-8-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <arIjhlqqzt4AKTOr@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <arIjhlqqzt4AKTOr@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/09/22 15:43, Oliver Upton wrote:
> Hi Akihiko,
> 
> On Sun, Sep 20, 2026 at 08:15:49PM +0900, Akihiko Odaki wrote:
>> This reverts commit fe53538069bb4f625bc8734103ba044a83138fea.
>>
>> Restore PMU event teardown before system-register reset so existing
>> perf events cannot retain configuration from the previous run. All
>> counters are disabled by the reset PMCR_EL0 and MDCR_EL2 values, so
>> reset does not need to request a PMU reload.
> 
> Sorry, I'm not following the intent here. KVM_REQ_RELOAD_PMU should
> already be discarding + recomputing perf events based on the state of
> the vPMU. What's the problem?

Hi Oliver,

A plain KVM_REQ_RELOAD_PMU does not discard existing perf events. 
kvm_pmu_reprogram_counter_mask() enables or disables them, and 
kvm_pmc_enable_perf_event() only creates an event if none exists.

For example, an existing cycle-counter event may exclude EL0 counting. 
Reset sets PMCCFILTR_EL0 to zero, but the subsequent reload only 
disables that event. If the guest then enables cycle counting without 
rewriting the filter or counter, the old event is enabled again and 
still excludes EL0, despite PMCCFILTR_EL0 reading as zero.

The earlier "Recreate events after reset" patch addressed this by 
setting events_need_recreate. Sashiko then pointed out that stopping the 
old events after resetting the registers adds their accumulated counts 
to the reset counter values:

https://sashiko.dev/#/message/20260914-hybrid-v10-7-92788053a691%40rsg.ci.i.u-tokyo.ac.jp

The revert restores teardown before system-register reset and fixes the 
stale configuration.

Regards,
Akihiko Odaki
