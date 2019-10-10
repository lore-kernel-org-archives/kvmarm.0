Return-Path: <SRS0=9okY=YD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D593EC4360C
	for <kvmarm@archiver.kernel.org>; Thu, 10 Oct 2019 13:08:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A58D206B6
	for <kvmarm@archiver.kernel.org>; Thu, 10 Oct 2019 13:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A58D206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A1A4A82D;
	Thu, 10 Oct 2019 09:08:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t1Tejol2pKMj; Thu, 10 Oct 2019 09:08:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D1FB4A806;
	Thu, 10 Oct 2019 09:08:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 603954A806
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Oct 2019 09:08:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Jvu6zpEeYPh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Oct 2019 09:08:34 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E5494A68A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Oct 2019 09:08:34 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id AF8AC4877A4713569682;
 Thu, 10 Oct 2019 21:08:28 +0800 (CST)
Received: from [127.0.0.1] (10.133.216.73) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 10 Oct 2019
 21:08:22 +0800
Subject: Re: [RFC PATCH 12/12] virt/acpi: add SDEI table if SDEI is enabled
To: Igor Mammedov <imammedo@redhat.com>
References: <1569338511-3572-1-git-send-email-guoheyi@huawei.com>
 <1569338511-3572-13-git-send-email-guoheyi@huawei.com>
 <20191010111537.5e2dd584@redhat.com>
From: Guoheyi <guoheyi@huawei.com>
Message-ID: <3e889d37-b877-f7b5-7ee3-70cef6d8e9c1@huawei.com>
Date: Thu, 10 Oct 2019 21:08:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20191010111537.5e2dd584@redhat.com>
X-Originating-IP: [10.133.216.73]
X-CFilter-Loop: Reflected
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>,
 qemu-devel@nongnu.org, Dave Martin <Dave.Martin@arm.com>, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Thanks for your comments.

On 2019/10/10 17:15, Igor Mammedov wrote:
> On Tue, 24 Sep 2019 23:21:51 +0800
> Heyi Guo <guoheyi@huawei.com> wrote:
>
>> Add SDEI table if SDEI is enabled, so that guest OS can get aware and
>> utilize the interfaces.
>>
>> Signed-off-by: Heyi Guo <guoheyi@huawei.com>
>> Cc: Peter Maydell <peter.maydell@linaro.org>
>> Cc: Dave Martin <Dave.Martin@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Shannon Zhao <shannon.zhaosl@gmail.com>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Igor Mammedov <imammedo@redhat.com>
>> ---
>>   hw/arm/virt-acpi-build.c    | 16 ++++++++++++++++
>>   include/hw/acpi/acpi-defs.h |  5 +++++
>>   2 files changed, 21 insertions(+)
>>
>> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
>> index 6cdf156..1088214 100644
>> --- a/hw/arm/virt-acpi-build.c
>> +++ b/hw/arm/virt-acpi-build.c
>> @@ -32,6 +32,7 @@
>>   #include "trace.h"
>>   #include "hw/core/cpu.h"
>>   #include "target/arm/cpu.h"
>> +#include "target/arm/sdei.h"
>>   #include "hw/acpi/acpi-defs.h"
>>   #include "hw/acpi/acpi.h"
>>   #include "hw/nvram/fw_cfg.h"
>> @@ -475,6 +476,16 @@ build_iort(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>>   }
>>   
> here should be a comment describing purpose with a reference to spec
OK.

>
>>   static void
>> +build_sdei(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>> +{
>> +    int sdei_start = table_data->len;
>> +
>> +    (void)acpi_data_push(table_data, sizeof(AcpiSdei));
>> +    build_header(linker, table_data, (void *)(table_data->data + sdei_start),
>> +                 "SDEI", table_data->len - sdei_start, 1, NULL, NULL);
>> +}
> that's dummy table and doesn't match what spec describes,
> It doesn't look correct SDEI table.

Refer to below document, Appendix C, I see the definition of SDEI is 
really a dummy table, also it is said in the document: The table 
consists only of a basic header with revision 1.

http://infocenter.arm.com/help/topic/com.arm.doc.den0054a/ARM_DEN0054A_Software_Delegated_Exception_Interface.pdf

Do I miss anything?

>
>> +
>> +static void
>>   build_spcr(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>>   {
>>       AcpiSerialPortConsoleRedirection *spcr;
>> @@ -796,6 +807,11 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>>       acpi_add_table(table_offsets, tables_blob);
>>       build_spcr(tables_blob, tables->linker, vms);
>>   
>> +    if (sdei_enabled) {
>> +        acpi_add_table(table_offsets, tables_blob);
>> +        build_sdei(tables_blob, tables->linker, vms);
>> +    }
>> +
>>       if (ms->numa_state->num_nodes > 0) {
>>           acpi_add_table(table_offsets, tables_blob);
>>           build_srat(tables_blob, tables->linker, vms);
>> diff --git a/include/hw/acpi/acpi-defs.h b/include/hw/acpi/acpi-defs.h
>> index 57a3f58..0a2265d 100644
>> --- a/include/hw/acpi/acpi-defs.h
>> +++ b/include/hw/acpi/acpi-defs.h
>> @@ -634,4 +634,9 @@ struct AcpiIortRC {
>>   } QEMU_PACKED;
>>   typedef struct AcpiIortRC AcpiIortRC;
>>   
>> +struct AcpiSdei {
>> +    ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
>> +} QEMU_PACKED;
>> +typedef struct AcpiSdei AcpiSdei;
> we don't use packed structures for ACPI anymore, see build_rsdp() for
> example of how tables are composed and comment style required for each field.
Sure; will fix it in v2.

Thanks,

Heyi

>
>>   #endif
>
> .
>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
