From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 28 Mar 2017 14:40:10 +0100
Message-ID: <58DA67BA.8070404@arm.com>
References: <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com> <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox> <58D17AF0.2010802@arm.com>
 <20170321193933.GB31111@cbox> <58DA3F68.6090901@arm.com>
 <20170328112328.GA31156@cbox> <20170328115413.GJ23682@e104320-lin>
 <b1c6e747-2fa7-b7a1-60d5-4a9c480b9dc9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ECE940B40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:38:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PZInw1siLVUy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 09:38:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 307FF40A6A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:38:34 -0400 (EDT)
In-Reply-To: <b1c6e747-2fa7-b7a1-60d5-4a9c480b9dc9@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, Achin Gupta <achin.gupta@arm.com>, will.deacon@arm.com, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com, Leif.Lindholm@linaro.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, nd@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 28/03/17 13:16, gengdongjiu wrote:
> On 2017/3/28 19:54, Achin Gupta wrote:
>> On Tue, Mar 28, 2017 at 01:23:28PM +0200, Christoffer Dall wrote:
>>> On Tue, Mar 28, 2017 at 11:48:08AM +0100, James Morse wrote:
>>>> On the host, part of UEFI is involved to generate the CPER records.
>>>> In a guest?, I don't know.
>>>> Qemu could generate the records, or drive some other component to do it.
>>>
>>> I think I am beginning to understand this a bit.  Since the guet UEFI
>>> instance is specifically built for the machine it runs on, QEMU's virt
>>> machine in this case, they could simply agree (by some contract) to
>>> place the records at some specific location in memory, and if the guest
>>> kernel asks its guest UEFI for that location, things should just work by
>>> having logic in QEMU to process error reports and populate guest memory.
>>>
>>> Is this how others see the world too?
>>
>> I think so!
>>
>> AFAIU, the memory where CPERs will reside should be specified in a GHES entry in
>> the HEST. Is this not the case with a guest kernel i.e. the guest UEFI creates a
>> HEST for the guest Kernel?
>>
>> If so, then the question is how the guest UEFI finds out where QEMU (acting as
>> EL3 firmware) will populate the CPERs. This could either be a contract between
>> the two or a guest DXE driver uses the MM_COMMUNICATE call (see [1]) to ask QEMU
>> where the memory is.
> 
> whether invoke the guest UEFI will be complex? not see the advantage. it seems x86 Qemu
> directly generate the ACPI table, but I am not sure, we are checking the qemu
logical.
> let Qemu generate CPER record may be clear.

At boot UEFI in the guest will need to make sure the areas of memory that may be
used for CPER records are reserved. Whether UEFI or Qemu decides where these are
needs deciding, (but probably not here)...

At runtime, when an error has occurred, I agree it would be simpler (fewer
components involved) if Qemu generates the CPER records. But if UEFI made the
memory choice above they need to interact and it gets complicated again. The
CPER records are defined in the UEFI spec, so I would expect UEFI to contain
code to generate/parse them.


Thanks,

James
