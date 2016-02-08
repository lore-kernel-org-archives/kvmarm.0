From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [GIT PULL] KVM/ARM updates for 4.5-rc2
Date: Mon, 8 Feb 2016 15:31:09 +0000
Message-ID: <56B8B4BD.3080904@arm.com>
References: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
 <56B8B2DB.9020407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56B8B2DB.9020407@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/02/16 15:23, Paolo Bonzini wrote:
> 
> 
> On 28/01/2016 11:30, Marc Zyngier wrote:
>> Hi Paolo,
>>
>> Please find below the KVM/ARM updates for 4.5-rc2. Mostly fixes as a
>> result of Shannon's work on PMU emulation, which has outlined a few
>> nits here and there, plus a correctness fix from Dave.
>>
>> Please pull!
>>
>> Thanks,
>>
>> 	M.
>>
>> The following changes since commit 92e963f50fc74041b5e9e744c330dca48e04f08d:
>>
>>   Linux 4.5-rc1 (2016-01-24 13:06:47 -0800)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.5-rc2
>>
>> for you to fetch changes up to 6327f35a2010c06a3bc2bfb14202a38764fb9920:
>>
>>   arm64: KVM: Fix guest dead loop when register accessor returns false (2016-01-24 21:56:01 +0000)
>>
>> ----------------------------------------------------------------
>> KVM/ARM fixes for v4.5-rc2
>>
>> A few random fixes, mostly coming from the PMU work by Shannon:
>>
>> - fix for injecting faults coming from the guest's userspace
>> - cleanup for our CPTR_EL2 accessors (reserved bits)
>> - fix for a bug impacting perf (user/kernel discrimination)
>> - fix for a 32bit sysreg handling bug
>>
>> ----------------------------------------------------------------
> 
> Finally pulled, thanks.

Thanks Paolo. I'll send another PR in a couple of days for another fix
that landed last week.

	M.
-- 
Jazz is not dead. It just smells funny...
