From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 2/4] arm: Add PMU test
Date: Thu, 1 Dec 2016 12:19:21 +0000
Message-ID: <dc301903-50b2-2155-7aad-d0308e3c292b@arm.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-3-git-send-email-wei@redhat.com>
 <20161201090303.6vdo7iqlj2lfqqvv@kamzik.brq.redhat.com>
 <369668b9-d158-45dd-562d-cf25cdaaa749@arm.com>
 <CAFEAcA--kXnrDw3m1VCwOpJoHb-VBkJDakD2gZ+B6j_itQyJjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA--kXnrDw3m1VCwOpJoHb-VBkJDakD2gZ+B6j_itQyJjA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>, Aaron Lindsay <alindsay@codeaurora.org>, kvm-devel <kvm@vger.kernel.org>, croberts@codeaurora.org, QEMU Developers <qemu-devel@nongnu.org>, Alistair Francis <alistair.francis@xilinx.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 01/12/16 12:02, Peter Maydell wrote:
> On 1 December 2016 at 11:28, Andre Przywara <andre.przywara@arm.com> wrote:
>> I don't think so. At least here as a _variable_ type uint32_t is
>> probably the right one, as the ARMv8 ARM explicitly says that PMCR is a
>> 32-bit register, for both bitnesses.
> 
> For 64-bit ARM this is strictly speaking just shorthand for "64-bit
> register with the top 32-bit being RES0". It is in theory possible that
> a future architecture extension might define uses for those RES0
> bits.

I trade: "in theory possible that a future architecture extension might"
(that's four speculative terms, right?) against:

ARMv8 ARM, D7.4.7  PMCR_EL0, Performance Monitors Control Register:
Attributes
            PMCR_EL0 is a 32-bit register.

If this ever gets extended, we would need extra code to deal with the
new bits, so we would need to touch the code anyway. And again, it's
just a local variable, not an interface.

Cheers,
Andre.

P.S. We really should save this discussion for a Friday afternoon ;-)
