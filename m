From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/2] arm: KVM: Do not update PC if the trap handler has
 updated it
Date: Thu, 07 Jan 2016 08:50:21 +0000
Message-ID: <568E26CD.8020500@arm.com>
References: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com> <1450778118-12715-2-git-send-email-marc.zyngier@arm.com> <CAFEAcA8F2TJuRR5ELvit0FPa3XFMJ847S8WK25i5aVdGBU=PUA@mail.gmail.com> <20151222143947.GA5631@cbox> <CAFEAcA9dALQv8Xcyg5FLAvRaJfH5UT2u4jrLjofLh5Ff2yo=8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA9dALQv8Xcyg5FLAvRaJfH5UT2u4jrLjofLh5Ff2yo=8Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, Shannon Zhao <shannon.zhao@linaro.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 14:50, Peter Maydell wrote:
> On 22 December 2015 at 14:39, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
>> On Tue, Dec 22, 2015 at 11:08:10AM +0000, Peter Maydell wrote:
>>> Won't this result in our incorrectly skipping the first insn
>>> in the fault handler if the original offending instruction
>>> was itself the first insn in the fault handler?
>>>
>> Wouldn't that then loop with the exception forever?
> 
> Yes, but so would real hardware...

Indeed. As it is, this patch is not doing what it should. On the other
hand, I came to the conclusion that we do not need to fix this just yet,
as long as we only let KVM inject an UNDEF, and that's what the PMU code
requires.

I'll comment on the PMU thread, but the gist of it is:
1) fix the arm64 UNDEF/PABRT/DABRT code to properly account for the the
source EL (Table D1-7 of the ARMv8 ARM).
2) instead of crafting an exception that modifies the PC, fail the
sysreg access and let KVM inject an UNDEF.

I'll post another patch today to address 1), and I'll finish reviewing
the PMU thread (I have a separate patch addressing 2)).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
