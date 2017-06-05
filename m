From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 03/25] KVM: arm64: Make kvm_condition_valid32()
 accessible from EL2
Date: Mon, 5 Jun 2017 09:13:53 +0100
Message-ID: <394ef6fd-1123-0a1f-f462-ed5cb52e24da@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-4-marc.zyngier@arm.com> <20170604121129.GB9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170604121129.GB9464@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/06/17 13:11, Christoffer Dall wrote:
> On Thu, Jun 01, 2017 at 11:20:55AM +0100, Marc Zyngier wrote:
>> As we're about to trap CP15 accesses and handle them at EL2, we
>> need to evaluate whether or not the condition flags are valid,
>> as an implementation is allowed to trap despite the condition
>> not being met.
>>
>> Tagging the function as __hyp_text allows this.
> 
> is the cc_map also guaranteed to work (by simple reference) in EL2 then?

Yes. By virtue of being const, this ends up in the read-only part of the
kernel, which we always map at EL2.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
