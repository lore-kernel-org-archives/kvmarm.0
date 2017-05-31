From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [edk2] [Qemu-devel] [PATCH v3 1/4] ACPI: Add APEI GHES Table
 Generation support
Date: Wed, 31 May 2017 10:13:38 +0800
Message-ID: <80b71fec-cd6d-fed7-1a86-195deffcdbb0@huawei.com>
References: <0184EA26B2509940AA629AE1405DD7F2014105CD@DGGEMA503-MBS.china.huawei.com>
 <3a791060-170d-9eb7-b2c4-f1cdbb55501f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.01.org>
In-Reply-To: <3a791060-170d-9eb7-b2c4-f1cdbb55501f@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/edk2-devel/>
List-Post: <mailto:edk2-devel@lists.01.org>
List-Help: <mailto:edk2-devel-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.01.org
Sender: "edk2-devel" <edk2-devel-bounces@lists.01.org>
To: Laszlo Ersek <lersek@redhat.com>
Cc: Michael Tsirkin <mtsirkin@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Wuquanming <wuquanming@huawei.com>, "wangxiongfeng (C)" <wangxiongfeng2@huawei.com>, Christoffer Dall <cdall@linaro.org>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "Leif.Lindholm@linaro.com" <Leif.Lindholm@linaro.com>, Huangshaoyu <huangshaoyu@huawei.com>, "vladimir.murzin@arm.com" <vladimir.murzin@arm.com>, Xiexiuqi <xiexiuqi@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, "andre.przywara@arm.com" <andre.przywara@arm.com>, "edk2-devel@lists.01.org" <edk2-devel@lists.01.org>, "nd@arm.com" <nd@arm.com>, linux-arm-kernel@lis
List-Id: kvmarm@lists.cs.columbia.edu

Laszlo,
   very sorry for that, it was my mistake that missing your name.
when I reply mail, I copy the "CC" list to the mail reply list, but forget to copy the "To" list.
I will check your comments in detailed later and reply you. thanks again.



On 2017/5/30 0:03, Laszlo Ersek wrote:
> Hi,
> 
> did you remove me from the To: / Cc: list intentionally, or was that an
> oversight? I caught your message in my list folders only by luck.
> 
> Some followup below:
> 
> On 05/29/17 17:27, gengdongjiu wrote:
> 
>>> (46) What is "physical_addr" good for? Below I can only see an 
>>> assignment to it, in ghes_update_guest(). Where is the field read?
> 
>> this "physical_addr" address is the physical error address in the
>> CPER. such as the physical address that happen hwpoison, this address
>> is delivered by the KVM and QEMU transfer this address to physical.
> I understand that in the ghes_update_guest() function, you accept a
> parameter called "physical_address", and you pass it on to
> ghes_generate_cper_record(). That makes sense, yes.
> 
> However, you also assign the same value to "ges.physical_addr". And that
> structure field is never read. So my point is that the
> "GhesErrorState.physical_addr" field is superfluous and should be removed.
> 
> I checked the other three patches in the series and they don't seem to
> read that structure member either. Correct me if I'm wrong.
> 
>>> (55) What happens if you run out of the preallocated memory?
> 
>> if it run out of the preallocated memory. it will overwrite other 
>> error source. every block's size is fixed. so it does not easy
>> dynamically extend the size if it is overflow. Anyway I will add a
>> error report if it happens overwrite.
> I understand (and agree) that dynamic allocation is not possible here.
> 
> But that doesn't justify overwriting the error status data block that
> belongs to a different data source. (Worse, if this happens with the
> last error status data block, for error source 10, you could overwrite
> memory that belongs to the OS.)
> 
> If an error status data block becomes full, then we should either wrap
> back to the start of the same data block, or else stop forwarding errors
> for that error source.
> 
> Does the ACPI spec say anything about this? I.e., about the case when
> the system runs out of the memory that was reserved for recording
> hardware errors?
> 
>>>>> +
>>>>> +    mem_err = (struct cper_sec_mem_err *) (gdata + 1);
>>>>> +
>>>>> +    /* In order to simplify simulation, hardcode the CPER section to memory
>>>>> +     * section.
>>>>> +     */
>>>>> +    mem_err->validation_bits |= CPER_MEM_VALID_ERROR_TYPE;
>>>>> +    mem_err->error_type = 3;
>>>
>>> (58) Is this supposed to stand for "Multi-bit ECC" (from "N.2.5 Memory 
>>> Error Section" in UEFI 2.6)? Should we have a macro for that?
> 
>> Yes, it is. What do you mean a macro?
> 
> A #define for the integer value 3.
> 
>> For all the errors that happen in the guest OS, in order to simulate
>> easy, I abstract all the error section to memory section, even though
>> the error section is processor or other section.
> Why is that a valid thing to do? (I'm not doubting it is valid, I'm just
> asking.) Will that not confuse the ACPI subsystem of the guest OS?
> 
>> I do not know whether do you have some suggestion for that.
> Well I would have thought (without any expertise on the subject) that
> hardware errors from the host side should be mapped to the guest more or
> less "type correct". IOW, it looks strange that, say, a CPU error is
> reported as a memory error. But this is just an uneducated guess.
> 
>>>>> +    mem_err->validation_bits |= CPER_MEM_VALID_CARD | CPER_MEM_VALID_MODULE |
>>>>> +            CPER_MEM_VALID_BANK | CPER_MEM_VALID_ROW |
>>>>> +            CPER_MEM_VALID_COLUMN | CPER_MEM_VALID_BIT_POSITION;
>>>>> +    mem_err->card = 1;
>>>>> +    mem_err->module = 2;
>>>>> +    mem_err->bank = 3;
>>>>> +    mem_err->row = 1;
>>>>> +    mem_err->column = 2;
>>>>> +    mem_err->bit_pos = 5;
>>>
>>> (60) I have no idea where these values come from.
> 
>> For all the errors that happen in the guest OS, in order to simulate
>> easy, I abstract all the error section to memory section, and hard
>> code the memory section error value as above.
> Sure, but why is that safe? Will the guest OS not want to do something
> about these error details? If we are feeding the guest OS invalid error
> details, will that not lead to confusion?
> 
>>> (64) What does "reqr" stand for?
>> It stand for the request size.
> Can you please call it "req_size" or something similar? The English
> expression
> 
>   request size
> 
> contains only one "r" letter, so it's hard to understand where the
> second "r" in "reqr" comes from.
> 
> Thanks,
> Laszlo
> 
> .
> 
