From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/5] arm64: KVM: Do not use stack-protector to compile EL2 code
Date: Tue, 2 May 2017 15:48:15 +0100
Message-ID: <CAKv+Gu9O-vAfVV0GWoja1jVsDuU1fizeAAACJKpEcWFv8YZA1A@mail.gmail.com>
References: <20170502133041.10980-1-marc.zyngier@arm.com> <20170502133041.10980-2-marc.zyngier@arm.com>
 <20170502144029.GB29224@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170502144029.GB29224@e104818-lin.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, KVM devel mailing list <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 May 2017 at 15:40, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Tue, May 02, 2017 at 02:30:37PM +0100, Marc Zyngier wrote:
>> We like living dangerously. Nothing explicitely forbids stack-protector
>> to be used in the EL2 code, while distributions routinely compile their
>> kernel with it. We're just lucky that no code actually triggers the
>> instrumentation.
>>
>> Let's not try our luck for much longer, and disable stack-protector
>> for code living at EL2.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/Makefile | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>> index aaf42ae8d8c3..14c4e3b14bcb 100644
>> --- a/arch/arm64/kvm/hyp/Makefile
>> +++ b/arch/arm64/kvm/hyp/Makefile
>> @@ -2,6 +2,8 @@
>>  # Makefile for Kernel-based Virtual Machine module, HYP part
>>  #
>>
>> +ccflags-y += -fno-stack-protector
>> +
>
> While you are at it, should we have a -fpic here as well? The hyp code
> runs at a different location than the rest of the kernel.
>

-fpic almost guarantees you will get position dependent but runtime
relocatable code (i.e., symbol references indirected via GOT entries
which need to be fixed up at runtime etc), unless you play around with
hidden visibility etc. For the same reason, the EFI stub does not
support being built with -fpic either.

Adding -mcmodel=small explicitly is much more likely to do anything
meaningful here, but only in case we need to set it to 'large'
globally in the future.
