From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/7] lib: arm: Remove warning about
 uart0_base mismatch
Date: Fri, 25 Jan 2019 16:36:13 +0000
Message-ID: <ffcc5f60-c5a0-c7f1-7fb1-658d8eea6fc4@arm.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-3-alexandru.elisei@arm.com>
 <20190124115943.12296810@donnerap.cambridge.arm.com>
 <20190124123740.v52nkbcki5dp2hpq@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCECE4A3B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 11:36:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 88hWjrbQn8lB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 11:36:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B3B4A3B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 11:36:16 -0500 (EST)
In-Reply-To: <20190124123740.v52nkbcki5dp2hpq@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 1/24/19 12:37 PM, Andrew Jones wrote:
> On Thu, Jan 24, 2019 at 11:59:43AM +0000, Andre Przywara wrote:
>> On Thu, 24 Jan 2019 11:16:29 +0000
>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>
>>> A warning is displayed if uart0_base is different from what the code
>>> expects qemu to generate for the pl011 UART in the device tree.
>>> However, now we support the ns16550a UART emulated by kvmtool, which
>>> has a different address. This leads to the  warning being displayed
>>> even though the UART is configured and working as expected.
>>>
>>> Now that we support multiple UARTs, the warning serves no purpose, so
>>> remove it.
>> Mmh, but we use that address before, right? So for anything not
>> emulating an UART at this QEMU specific address we write to some random
>> (device) memory?
>>
>> Drew, how important is this early print feature for kvm-unit-tests?
> The setup code passes through quite a few asserts before getting through
> io_init() (including in uart0_init), so I think there's still value in
> having a guessed UART address. Maybe we can provide guesses for both
> QEMU and kvmtool, and some selection method, that would be used until
> we've properly assigned uart0_base from DT?
>
>> Cheers,
>> Andre.
>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  lib/arm/io.c | 6 ------
>>>  1 file changed, 6 deletions(-)
>>>
>>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>>> index 35fc05aeb4db..87435150f73e 100644
>>> --- a/lib/arm/io.c
>>> +++ b/lib/arm/io.c
>>> @@ -61,12 +61,6 @@ static void uart0_init(void)
>>>  	}
>>>  
>>>  	uart0_base = ioremap(base.addr, base.size);
>>> -
>>> -	if (uart0_base != (u8 *)UART_EARLY_BASE) {
>>> -		printf("WARNING: early print support may not work. "
>>> -		       "Found uart at %p, but early base is %p.\n",
>>> -			uart0_base, (u8 *)UART_EARLY_BASE);
>>> -	}
>>>  }
> This warning is doing what it should, which is pointing out that the
> UART_EARLY_BASE guess appears to be wrong. If we can provide a way
> to support more than one guess, then we should keep this warning but
> adjust it to match one of any of the guesses.
>
> Thanks,
> drew

I'm not really sure how to implement a selection method. I've looked at
splitting io_init() into uart0_init() and chr_testdev_init() and calling
uart0_init() very early in the setup process, but uart0_init() itself uses
printf() and assert().

I've also thought about adding another function, something like
uart0_early_init(), that is called very early in setup() and gets the base
address from the dtb bootargs. But that means calling dt_init() and
dt_get_bootargs(), which can fail.

One other option that could work is to make it a compile-time configuration.

What do you think?
