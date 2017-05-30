From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 30/31] KVM: arm64: Enable GICv3 common sysreg trapping via
 command-line
Date: Tue, 30 May 2017 15:41:56 +0100
Message-ID: <c7d726ba-2f5b-a97e-6df1-e0d90a38f546@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-31-marc.zyngier@arm.com>
 <1e6b1e3c-ec86-24ad-8704-59521dc0b159@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1e6b1e3c-ec86-24ad-8704-59521dc0b159@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/05/17 10:56, Auger Eric wrote:
> Hi,
> 
> On 03/05/2017 12:46, Marc Zyngier wrote:
>> Now that we're able to safely handle common sysreg access, let's
>> give the user the opportunity to enable it by passing a specific
>> command-line option (vgic_v3.common_trap).
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> What is the rationale behind trapping those common sysreg accesses. This
> is not enabled by default for some erratas. Is it to complete the
> trapping modality. May be worth to explain.

That's strictly for completeness. Let's assume some hypothetical HW has
a bug on the EOI path, where the physical interrupt wouldn't get
properly deactivated on the physical distributor. In order to deal with
that when EOImode==1 in the guest, you'd need to trap DIR as well. Same
thing if PMR was broken as well.

Also, we could implement some form of tracing of all the GICv3 accessors
if we wanted such a functionality (trying to find something more
gratifying than basic errata workaround here... ;-).

> 
> Besides
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
