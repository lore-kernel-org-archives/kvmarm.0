From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 2/4] arm: Add PMU test
Date: Thu, 1 Dec 2016 12:36:06 +0000
Message-ID: <CAFEAcA_XExkCohmGCp0sOKwQTOXN3=c-0-sXEAmuqLauKcjHrQ@mail.gmail.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-3-git-send-email-wei@redhat.com> <20161201090303.6vdo7iqlj2lfqqvv@kamzik.brq.redhat.com>
 <369668b9-d158-45dd-562d-cf25cdaaa749@arm.com> <CAFEAcA--kXnrDw3m1VCwOpJoHb-VBkJDakD2gZ+B6j_itQyJjA@mail.gmail.com>
 <dc301903-50b2-2155-7aad-d0308e3c292b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <dc301903-50b2-2155-7aad-d0308e3c292b@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>, Aaron Lindsay <alindsay@codeaurora.org>, kvm-devel <kvm@vger.kernel.org>, croberts@codeaurora.org, QEMU Developers <qemu-devel@nongnu.org>, Alistair Francis <alistair.francis@xilinx.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 December 2016 at 12:19, Andre Przywara <andre.przywara@arm.com> wrote:
> Hi,
>
> On 01/12/16 12:02, Peter Maydell wrote:
>> On 1 December 2016 at 11:28, Andre Przywara <andre.przywara@arm.com> wrote:
>>> I don't think so. At least here as a _variable_ type uint32_t is
>>> probably the right one, as the ARMv8 ARM explicitly says that PMCR is a
>>> 32-bit register, for both bitnesses.
>>
>> For 64-bit ARM this is strictly speaking just shorthand for "64-bit
>> register with the top 32-bit being RES0". It is in theory possible that
>> a future architecture extension might define uses for those RES0
>> bits.
>
> I trade: "in theory possible that a future architecture extension might"
> (that's four speculative terms, right?) against:
>
> ARMv8 ARM, D7.4.7  PMCR_EL0, Performance Monitors Control Register:
> Attributes
>             PMCR_EL0 is a 32-bit register.

As I say, this just means "64 bit with 32 RES0 bits". See DDI0487A.k
C5.1.1 "System register width":

# In AArch64 state, each encoding in the System instruction space can
# provide access to a 64-bit register. An AArch64 System register is
# described as either a 32-bit register or a 64-bit register. For
# a 32-bit register, the upper bits, bits[63:32], are RES0.

(ie the register is 64-bits, it's just "described as" 32-bits for
convenience.)

thanks
-- PMM
