From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [edk2] [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Fri, 7 Apr 2017 11:21:41 +0200
Message-ID: <09c64b28-5eb5-4efd-6cb8-035b69313a99@redhat.com>
References: <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox> <58D17AF0.2010802@arm.com>
 <20170321193933.GB31111@cbox> <58DA3F68.6090901@arm.com>
 <20170328112328.GA31156@cbox> <20170328115413.GJ23682@e104320-lin>
 <b1c6e747-2fa7-b7a1-60d5-4a9c480b9dc9@huawei.com> <58DA67BA.8070404@arm.com>
 <5b7352f4-4965-3ed5-3879-db871797be47@huawei.com>
 <20170329103658.GQ23682@e104320-lin>
 <2a427164-9b37-6711-3a56-906634ba7f12@redhat.com>
 <7c5c8ab7-8fcc-1c98-0bc1-cccb66c4c84d@huawei.com>
 <6ac1597a-2ed5-36b2-848d-5fd048b16d66@redhat.com>
 <55546a4b-c33b-37b9-dafe-15ce75bc1b62@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.01.org>
In-Reply-To: <55546a4b-c33b-37b9-dafe-15ce75bc1b62@huawei.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/edk2-devel/>
List-Post: <mailto:edk2-devel@lists.01.org>
List-Help: <mailto:edk2-devel-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.01.org
Sender: "edk2-devel" <edk2-devel-bounces@lists.01.org>
To: gengdongjiu <gengdongjiu@huawei.com>, Achin Gupta <achin.gupta@arm.com>
Cc: Michael Tsirkin <mtsirkin@redhat.com>, kvm@vger.kernel.org, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, qemu-devel@nongnu.org, wuquanming@huawei.com, wangxiongfeng2@huawei.com, Christoffer Dall <cdall@linaro.org>, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, Leif.Lindholm@linaro.com, huangshaoyu@huawei.com, vladimir.murzin@arm.com, xiexiuqi@huawei.com, Marc Zyngier <marc.zyngier@arm.com>, andre.przywara@arm.com, edk2-devel@lists.01.org, nd@arm.com, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/07/17 04:52, gengdongjiu wrote:
> 
> On 2017/4/7 2:55, Laszlo Ersek wrote:

>> I'm unsure if, by "not fixed", you are saying
>>
>>   the number of CPER entries that fits in Error Status Data Block N is
>>   not *uniform* across 0 <= N <= 10 [1]
>>
>> or
>>
>>   the number of CPER entries that fits in Error Status Data Block N is
>>   not *known* in advance, for all of 0 <= N <= 10 [2]
>>
>> Which one is your point?
>>
>> If [1], that's no problem; you can simply sum the individual error
>> status data block sizes in advance, and allocate "etc/hardware_errors"
>> accordingly, using the total size.
>>
>> (Allocating one shared fw_cfg blob for all status data blocks is more
>> memory efficient, as each ALLOCATE command will allocate whole pages
>> (rounded up from the actual blob size).)
>>
>> If your point is [2], then splitting the error status data blocks to
>> separate fw_cfg blobs makes no difference: regardless of whether we try
>> to place all the error status data blocks in a single fw_cfg blob, or in
>> separate fw_cfg blobs, the individual data block cannot be resized at OS
>> runtime, so there's no way to make it work.
>>
> My Point is [2]. The HEST(Hardware Error Source Table) table format is here:
> https://wiki.linaro.org/LEG/Engineering/Kernel/RAS/APEITables#Hardware_Error_Source_Table_.28HEST.29
> 
> Now I understand your thought.

But if you mean [2], then I am confused, with regard to firmware on
physical hardware. Namely, even on physical machines, the firmware has
to estimate, in advance, the area size that will be needed for CPERs,
doesn't it? And once the firmware allocates that memory area, it cannot
be resized at OS runtime. If there are more CPERs at runtime (due to
hardware errors) than the firmware allocated room for, they must surely
wrap around in the preallocated buffer (like in a ring buffer). Isn't
that correct?

On the diagrams that you linked above (great looking diagrams BTW!), I
see CPER in two places (it is helpfully shaded red):

- to the right of BERT; the CPER is part of a box that is captioned
"firmware reserved memory"

- to the right of HEST; again the CPER is part of a box that is
captioned "firmware reserved memory"

So, IMO, when QEMU has to guesstimate the room for CPERs in advance,
that doesn't differ from the physical firmware case. In QEMU maybe you
can let the user specify the area size on the command line, with a
machine type property or similar.

Thanks
Laszlo
