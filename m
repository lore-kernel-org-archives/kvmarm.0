From: Igor Mammedov <imammedo@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v11 2/6] ACPI: Add APEI GHES Table
 Generation support
Date: Fri, 1 Sep 2017 13:51:21 +0200
Message-ID: <20170901135121.57ca6a04@nial.brq.redhat.com>
References: <1503066227-18251-1-git-send-email-gengdongjiu@huawei.com>
 <1503066227-18251-3-git-send-email-gengdongjiu@huawei.com>
 <20170829122053.36cf550c@nial.brq.redhat.com>
 <dfaeb539-8006-85d6-35b2-0af31f5a0675@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B719440D16
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Sep 2017 07:49:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PQMxoKhNicwr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Sep 2017 07:49:16 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2115640CE9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Sep 2017 07:49:16 -0400 (EDT)
In-Reply-To: <dfaeb539-8006-85d6-35b2-0af31f5a0675@huawei.com>
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
Cc: kvm@vger.kernel.org, mst@redhat.com, will.deacon@arm.com, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu, zjzhang@codeaurora.org, mingo@kernel.org, linux-acpi@vger.kernel.org, huangshaoyu@huawei.com, huangdaode@hisilicon.com, bp@suse.de, lersek@redhat.com, wuquanming@huawei.com, marc.zyngier@arm.com, edk2-devel@lists.01.org, john.garry@huawei.com, linuxarm@huawei.com, qemu-arm@nongnu.org, jonathan.cameron@huawei.com, zhengqiang10@huawei.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com, pbonzini@redhat.com, shiju.jose@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 1 Sep 2017 17:58:55 +0800
gengdongjiu <gengdongjiu@huawei.com> wrote:

> Hi Igor,
> 
> On 2017/8/29 18:20, Igor Mammedov wrote:
> > On Fri, 18 Aug 2017 22:23:43 +0800
> > Dongjiu Geng <gengdongjiu@huawei.com> wrote:
[...]
> >   
> >> +void ghes_build_acpi(GArray *table_data, GArray *hardware_error,
> >> +                                            BIOSLinker *linker)
> >> +{
> >> +    uint32_t ghes_start = table_data->len;
> >> +    uint32_t address_size, error_status_address_offset;
> >> +    uint32_t read_ack_register_offset, i;
> >> +
> >> +    address_size = sizeof(struct AcpiGenericAddress) -
> >> +        offsetof(struct AcpiGenericAddress, address);  
> > it's confusing name for var,
> > AcpiGenericAddress::address is fixed unsigned 64 bit integer per spec
> > also, I'm not sure why it's needed at all.  
>  it is because other people have concern about where does the "unsigned 64 bit integer"
>  come from, they are confused about the "unsigned 64 bit integer"
>  so they suggested use sizeof. anyway I will directly use unsigned 64 bit integer.
Maybe properly named macro instead of sizeof(foo) would do the job


[...]
> >> +
> >> +        /* Build error status address*/
> >> +        build_address(table_data, linker, error_status_address_offset + i *
> >> +            sizeof(AcpiGenericHardwareErrorSourceV2), i * address_size,
> >> +            AML_SYSTEM_MEMORY, 0x40, 0, 4 /* QWord access */);  
> > just do something like this instead of build_address():
> > build_append_gas()
> > bios_linker_loader_add_pointer()  
> Thanks for the suggestion.
> 
> > 
> > also register width 0x40 looks suspicious, where does it come from?
> > While at it do you have a real hardware which has HEST table that you re trying to model after?
> > I'd like to see HEST and other related tables from it.  
> 
> Igor, what is your suspicious point? The register width 0x40 come from our host BIOS record to the System Memory space.

maybe s/0x40/ERROR_STATUS_BLOCK_POINTER_SIZE/

[...]
