From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: Virt MM DEBUG_LL support arm32
Date: Mon, 12 Oct 2015 09:16:48 -0700
Message-ID: <561BDCF0.7080201@samsung.com>
References: <5614683A.1010007@samsung.com>
 <CAFEAcA9ShOzMG7kk9hQRgizJ_u2=Y2B5v6SXi678M1RMZQcPVA@mail.gmail.com>
 <56154AF4.60206@samsung.com>
 <CAFEAcA8RWhh8agbfAR8JARXU6BY7PyLt3Z9UPzEh7xvJsev7Ng@mail.gmail.com>
 <5616E928.1090705@samsung.com> <20151010105148.GA29128@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96C43412A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 12:14:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yQTiQMNX4JDw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Oct 2015 12:14:40 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A594741145
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 12:14:40 -0400 (EDT)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NW40026T7W23K80@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 12 Oct 2015 12:16:50 -0400 (EDT)
In-reply-to: <20151010105148.GA29128@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



On 10/10/2015 3:51 AM, Christoffer Dall wrote:
> Hi Mario,
> 
> On Thu, Oct 08, 2015 at 03:07:36PM -0700, Mario Smarduch wrote:
>>
>>
>> On 10/7/2015 2:05 PM, Peter Maydell wrote:
>>> On 7 October 2015 at 17:40, Mario Smarduch <m.smarduch@samsung.com> wrote:
>>>> On 10/7/2015 12:07 AM, Peter Maydell wrote:
>>>>> On 7 October 2015 at 01:32, Mario Smarduch <m.smarduch@samsung.com> wrote:
>>>>>> Hi Peter,
>>>>>>    I noticed that icedcc, and 8250 don't work
>>>>>> with DEBUG_LL early debug print. And the kernel dies if
>>>>>> these are selected. Besides PL011 is there any other
>>>>>> serial devices that can be used for early debug with Virt MM?
>>>>>> Maybe some additional options are needed?
>>>>>
>>>>> PL011 and semihosting are the obvious choices for early
>>>>> debug output. There's no 8250 in the virt board so that
>>>>> definitely isn't going to work. We don't currently implement
>>>>> the ICE DCC channel, though I think Edgar was considering
>>>>> connecting it up to a chardev backend.
>>>>>
>>>>> Really though, I think the UART and semihosting should
>>>>> be enough for whatever the guest wants to do in the way
>>>>> of early debug. Why do you need more options?
>>>
>>>> No actually I was thinking of limiting choices to the ones that work for
>>>> Virt MM during kernel config. But thought that maybe others may be
>>>> supported through some options. Form me PL011 alone is enough.
>>>
>>> 8250 I think is what kvmtool uses, which is why that is a
>>> permitted option. Not sure who's implementing ICE DCC
>>> (though as I say QEMU might eventually).
>>
>> I see thanks for pointing that out.
>>
>>>
>>> thanks
>>> -- PMM
>>>
>>
>> I came across the issue of selecting wrong UART for DEBUG_LL while
>> trying to boot arm32 on arm64. ARCH_VIRT system type defaults
>> for 'Kernel low-level debugging port' are not too clear.
>>
>> I'm wondering if it would make sense to add entries for virtual
>> system types (like QEMU Virt or kvmtool virt) and enhance
>> help section with possible UART_PHYS address, also set a default
>> port. It appears like hard coding is going to be deprecated.
>>
>> This is not a major enhancement but when you're out of options
>> and you just see a blank screen anything helps. Especially for virtual
>> host where you may start suspecting the host system as well. Since I
>> tripped over it, I took a closer look.
>>
> I agree that it is particularly discouraging when you just get a blank
> screen, and it is in fact one of the top support questions I get from
> new users in private as well.
Yes a momentum killer :)
> 
> I think there were some discussions with Rob and Grant in the past about
> some way for Linux to discover the location of the UART for early
> printk, but I have forgotten the details and where that landed.
I'll double check but I believe ARM reference models support this
and have a nice detailed interface
> 
> I personally think it would be a good idea with *any* viable easy method
> to configure a kernel to support earlyprintk for our two virtual
> platforms: QEMU's virt board and kvmtool's platform.

Will do and get the kernel folks input, it's just mostly menu
selection that needs a little cleanup.

Thanks
- Mario
> 
> -Christoffer
> 
