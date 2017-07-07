From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [Qemu-devel] [PATCH v3 1/4] ACPI: Add APEI GHES Table Generation
 support
Date: Fri, 7 Jul 2017 16:32:09 +0800
Message-ID: <dbbab7f6-18c4-9b6c-799e-8267797a31bd@huawei.com>
References: <1493530506-26833-1-git-send-email-gengdongjiu@huawei.com>
 <4dde45bb-a730-82b1-dc49-ad00a6b73d85@redhat.com>
 <accf8880-f4b0-85f1-9f33-4103c8c26d7a@redhat.com>
 <e90c5fb8-e68b-a620-9023-f4fcfdd68e97@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3D1F40CE6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jul 2017 04:32:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FGohKL4LVjLc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jul 2017 04:32:24 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88AC640427
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jul 2017 04:32:22 -0400 (EDT)
In-Reply-To: <e90c5fb8-e68b-a620-9023-f4fcfdd68e97@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Laszlo Ersek <lersek@redhat.com>
Cc: mtsirkin@redhat.com, kvm@vger.kernel.org, tbaicar@codeaurora.org, qemu-devel@nongnu.org, wangxiongfeng2@huawei.com, ben@skyportsystems.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, huangshaoyu@huawei.com, songwenjun@huawei.com, wuquanming@huawei.com, marc.zyngier@arm.com, qemu-arm@nongnu.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, imammedo@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Laszlo,
   sorry for my late response.

On 2017/6/3 20:01, Laszlo Ersek wrote:
> On 05/22/17 16:23, Laszlo Ersek wrote:
>> Keeping some context:
>>
>> On 05/12/17 23:00, Laszlo Ersek wrote:
>>> On 04/30/17 07:35, Dongjiu Geng wrote:
> 
>> (68) In the code below, you are not taking an "OVMF header probe
>> suppressor" into account.
>>
>> But, we have already planned to replace that quirk with a separate,
>> dedicated allocation hint or command, so I'm not going to describe what
>> an "OVMF header probe suppressor" is; instead, I'll describe the
>> replacement for it.
>>
>> [...]
> 
> So, the NOACPI allocation hint is a no-go at the moment, based on the
> discussion in the following threads:
> 
> http://mid.mail-archive.com/20170601112241.2580-1-ard.biesheuvel@linaro.org
> 
> http://mid.mail-archive.com/c76b36de-ebf9-c662-d454-0a95b43901e8@redhat.com
> 
> Therefore the header probe suppression remains necessary.
> 
> In this case, it is not hard to do, you just have to reorder the
> following two ADD_POINTER additions a bit:
 Ok, it is no problem.

> 
>>>> +
>>>> +        bios_linker_loader_add_pointer(linker, GHES_ERRORS_FW_CFG_FILE,
>>>> +                                sizeof(uint64_t) * i, sizeof(uint64_t),
>>>> +                                GHES_ERRORS_FW_CFG_FILE,
>>>> +                                MAX_ERROR_SOURCE_COUNT_V6 * sizeof(uint64_t) +
>>>> +                                i * MAX_RAW_DATA_LENGTH);
> 
> This one should be moved out to a separate loop, after the current loop.
> 
>>>> +        bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
>>>> +                    address_registers_offset
>>>> +                    + i * sizeof(AcpiGenericHardwareErrorSource),
>>>> +                    sizeof(uint32_t), GHES_ERRORS_FW_CFG_FILE,
>>>> +                    i * sizeof(uint64_t));
> 
> This one should be kept in the first (i.e., current) loop.
> 
> The idea is, when you first point the HEST/GHES_n entries in
> ACPI_BUILD_TABLE_FILE to the "address registers" in
> GHES_ERRORS_FW_CFG_FILE, all those address registers will still be
> zero-filled. This will fail the ACPI table header probe in
> OvmfPkg/AcpiPlatformDxe, which is what we want.
> 
> After this is done, the address registers in GHES_ERRORS_FW_CFG_FILE
> should be pointed to the error status data blocks in the same fw_cfg
> blob, in a separate loop. (Those error status data blocks will again be
> zero-filled, so no ACPI table headers will be mistakenly recognized in
> them.)
I understand your idear. but I have a question:
how about we exchange the two function's place, such as shown below:
then it still meets ours needs, the change is easy.
For every loop:
(1)when patch address in ACPI_BUILD_TABLE_FILE to the "address registers", the address register is zero-filed.
(2)when patch address in GHES_ERRORS_FW_CFG_FILE to the error status data blocks, the error status data block is still zero-filed.

    for (i = 0; i < GHES_ACPI_HEST_NOTIFY_RESERVED; i++) {
        .....................................
        bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
                    address_registers_offset
                    + i * sizeof(AcpiGenericHardwareErrorSource),
                    sizeof(uint32_t), GHES_ERRORS_FW_CFG_FILE,
                    i * sizeof(uint64_t));


        bios_linker_loader_add_pointer(linker, GHES_ERRORS_FW_CFG_FILE,
                                sizeof(uint64_t) * i, sizeof(uint64_t),
                                GHES_ERRORS_FW_CFG_FILE,
                                MAX_ERROR_SOURCE_COUNT_V6 * sizeof(uint64_t) +
                                i * MAX_RAW_DATA_LENGTH);
	.........................................

     }

thanks

> 
> Thanks
> Laszlo
> 
> 
> .
> 
