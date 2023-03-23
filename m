Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC2819E
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 22:45:46 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C3D54B3;
	Thu, 23 Mar 2023 15:46:28 -0700 (PDT)
Received: from [192.168.122.164] (U203867.austin.arm.com [10.118.30.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 674C23F766;
	Thu, 23 Mar 2023 15:45:37 -0700 (PDT)
Message-ID: <34b6da04-7742-cd80-b840-460c52ad73c4@arm.com>
Date: Thu, 23 Mar 2023 17:45:35 -0500
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 2/4] KVM: arm64: Avoid lock inversion when setting the
 VM register width
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>
References: <20230316211412.2651555-1-oliver.upton@linux.dev>
 <20230316211412.2651555-3-oliver.upton@linux.dev>
 <5b355d9f-0191-2631-9745-5ed2d10af0e1@arm.com> <ZBy6f1XoO1b4zts1@linux.dev>
From: Jeremy Linton <jeremy.linton@arm.com>
In-Reply-To: <ZBy6f1XoO1b4zts1@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/23/23 15:45, Oliver Upton wrote:
> Jeremy,
> 
> On Thu, Mar 23, 2023 at 03:09:54PM -0500, Jeremy Linton wrote:
>> Hi,
>>
>> On 3/16/23 16:14, Oliver Upton wrote:
>>> kvm->lock must be taken outside of the vcpu->mutex. Of course, the
>>> locking documentation for KVM makes this abundantly clear. Nonetheless,
>>> the locking order in KVM/arm64 has been wrong for quite a while; we
>>> acquire the kvm->lock while holding the vcpu->mutex all over the shop.
>>>
>>> All was seemingly fine until commit 42a90008f890 ("KVM: Ensure lockdep
>>> knows about kvm->lock vs. vcpu->mutex ordering rule") caught us with our
>>> pants down, leading to lockdep barfing:
>>
>> Thanks for looking at this! It had a bit of fuzz applying to -rc3, did I
>> miss a required patch?
>>
>> This patch makes the lockdep warnings I was seeing go away but I'm seeing
>> similar lockdep problem while running the kvm kselftests. In particular I
>> think it was "selftests: kvm: debug-exceptions" which threw the warning.
> 
> Hmm, that's odd. IIRC the only test that exploded for me w/o the commit
> below was arch_timer.
> 
>> So, i'm not sure its completely fixed. I ran the previous one a couple weeks
>> back before you respun it, and IIRC didn't see any errors.
> 
> Thanks for taking this for a spin! This series depends on commit 47053904e182
> ("KVM: arm64: timers: Convert per-vcpu virtual offset to a global value")
> which is only present in kvmarm/fixes at the moment. I had sent out a PR for
> this last week but Paolo has yet to pull.
> 
> With both Marc's patch and this series I'm unable to reproduce lockdep
> warnings w/ selftests or kvmtool. If it isn't too much trouble can you
> give kvmarm/fixes plus this series a whirl and see if everything is
> addressed?
> 
> Otherwise you may have stumbled into some more crud we'll need to
> address :)

Ok, I reran everything, including with the latest arm/kvm patches and it 
seems I created the problem. Which I realized almost immediately after 
sending the original comment, as is too frequently the case.

I will put the tested by on the main set, although it should be noted 
the selftest doesn't complete cleanly on armv8.0 machines because of the:

GUEST_ASSERT(guest_check_lse()) line in guest_cas().

So, this error was largely noise.


Thanks,


