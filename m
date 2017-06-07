From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] arm64: KVM: Allow unaligned accesses at EL2
Date: Wed, 7 Jun 2017 10:16:29 +0100
Message-ID: <73f039f7-7597-fd34-367c-1cc6fdda3673@arm.com>
References: <20170606180835.14421-1-marc.zyngier@arm.com>
 <20170606180835.14421-3-marc.zyngier@arm.com> <20170606200912.GQ9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170606200912.GQ9464@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/06/17 21:09, Christoffer Dall wrote:
> On Tue, Jun 06, 2017 at 07:08:34PM +0100, Marc Zyngier wrote:
>> We currently have the SCTLR_EL2.A bit set, trapping unaligned accesses
>> at EL2, but we're not really prepared to deal with it. So far, this
>> has been unnoticed, until GCC 7 started emitting those (in particular
>> 64bit writes on a 32bit boundary).
>>
>> Since the rest of the kernel is pretty happy about that, let's follow
>> its example and set SCTLR_EL2.A to zero. Modern CPUs don't really
>> care.
> 
> Why do we set the A flag via SCTLR_ELx_FLAGS in the first place, only to
> drop that flag later on for both EL1 and EL2 ?

That flag is always cleared at EL1, never set. Actually, only EL2 uses
that macro to *set* flags. An alternative would be to do away with the
macro and use the individual flags, like the 32bit side does.

What do you think?

	M.
-- 
Jazz is not dead. It just smells funny...
