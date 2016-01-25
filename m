From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/21] arm64: Virtualization Host Extension support
Date: Mon, 25 Jan 2016 16:23:37 +0000
Message-ID: <56A64C09.4060702@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <2703557.vyWRuMlGU2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <2703557.vyWRuMlGU2@wuerfel>
Sender: kvm-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 25/01/16 16:15, Arnd Bergmann wrote:
> On Monday 25 January 2016 15:53:34 Marc Zyngier wrote:
>> host and guest, reducing the overhead of virtualization.
>>
>> In order to have the same kernel binary running on all versions of the
>> architecture, this series makes heavy use of runtime code patching.
>>
>> The first 20 patches massage the KVM code to deal with VHE and enable
>> Linux to run at EL2. The last patch catches an ugly case when VHE
>> capable CPUs are paired with some of their less capable siblings. This
>> should never happen, but hey...
>>
>> I have deliberately left out some of the more "advanced"
>> optimizations, as they are likely to distract the reviewer from the
>> core infrastructure, which is what I care about at the moment.
> 
> One question: as you mention that you use a lot of runtime code patching
> to make this work transparently, how does this compare to runtime patching
> the existing kernel to run in EL2 mode without VHE? Is that even possible?

I haven't explored that particular avenue - by the look of it, this
would require a lot more work, as v8.0 EL2 lacks a number of features
that Linux currently requires (like having two TTBRs, for example).

> My interpretation so far as always been "that's too complicated to
> do because it would require a lot of runtime patching", but now we seem
> to get that anyway because we want to run a hypervisor-enabled kernel in
> either EL1 or EL2 depending on the presence of another feature.

The kernel itself is mostly untouched (what runs at EL1 also runs at EL2
without any patching, because the new EL2 is now a superset of EL1). It
is the hypervisor code that gets a beating with the code-patching stick.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
