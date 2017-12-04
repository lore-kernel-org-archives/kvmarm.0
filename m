From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 07/12] arm64: mm: Place kImage at bottom of VA space
Date: Mon, 4 Dec 2017 17:27:10 +0000
Message-ID: <CAKv+Gu9Mjd7f57ZZdv+1p70Vs-YD8p6-1P=pb4-KAUsxNVppGw@mail.gmail.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
 <20171204141313.31604-8-steve.capper@arm.com>
 <CAKv+Gu_A-fAMpheWbKZ+prEVKHR58er7sXz0L93Af1XhJrGZeQ@mail.gmail.com>
 <20171204171809.wvrqfd435bh7i5r4@capper-debian.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD56249D5E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 12:24:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NdtR9TvgAnbB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 12:24:03 -0500 (EST)
Received: from mail-ot0-f176.google.com (mail-ot0-f176.google.com
 [74.125.82.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8535D49D40
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 12:24:03 -0500 (EST)
Received: by mail-ot0-f176.google.com with SMTP id o23so15409519otd.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 09:27:11 -0800 (PST)
In-Reply-To: <20171204171809.wvrqfd435bh7i5r4@capper-debian.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steve Capper <steve.capper@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 4 December 2017 at 17:18, Steve Capper <steve.capper@arm.com> wrote:
> Hi Ard,
>
> On Mon, Dec 04, 2017 at 04:25:18PM +0000, Ard Biesheuvel wrote:
>> On 4 December 2017 at 14:13, Steve Capper <steve.capper@arm.com> wrote:
>> > Re-arrange the kernel memory map s.t. the kernel image resides in the
>> > bottom 514MB of memory.
>>
>> I guess this breaks KASLR entirely, no? Given that it adds an offset
>> in the range [0 ... sizeof(VMALLOC_SPACE) /4 ].
>
> Yes, yes it does. Sorry about this. I had very carefully tested KASLR
> with custom offsets... on my early page table code. I will have a think
> about this.
>
> From a KASLR side, my (renewed) understanding is that a virtual address
> as low as possible is desired for the kimage start as that affords the
> most wiggle room?
>

Well, the nice thing about the current arrangement is that the default
is adjacent to the vmalloc space so any non-zero [bounded] offset
produces a valid placement. Addition with subtraction is easy, so
which side the default placement happens to be at does not really
matter. Having to implement additional bounds checking in the early
KASLR init code to stay clear of the PCI I/O or fixmap regions sounds
a bit more cumbersome.

>>
>> In any case, it makes sense to keep the kernel VA space adjacent to
>> the VMALLOC space, rather than put stuff like PCI I/O and the fixmap
>> in between.
>>
>> > With the modules, fixed map, PCI IO space placed
>> > above it. At the very bottom of the memory map we set aside a 2MB guard
>> > region to prevent ambiguity with PTR_ERR/ERR_PTR.
>> >
>>
>> Interesting. In another thread, we discussed whether it is necessary
>> to prevent the linear map randomization code from allocating at the
>> very top [bottom in Steve-speak] of the kernel virtual address space,
>> and this is a thing I did not consider.
>>
>
> I'll adjust my nomenclature to be less confusing.
>

Thanks :-)

>> > Dynamically resizable objects such as KASAN shadow and sparsemem map
>> > are placed above the fixed size objects.
>> >
>>
>> The current placement of the sparsemem map was carefully chosen so
>> that virt_to_page/page_to_virt translations are extremely cheap. Is
>> that still the case?
>
> I will double check the virt_to_page/page_to_virt. I had adjuested virt_to_phys
> and phys_to_virt and I think this one escaped me.
>
> Cheers,
> --
> Steve
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
