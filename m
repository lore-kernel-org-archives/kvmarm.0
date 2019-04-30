Return-Path: <SRS0=HqKL=TA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FBCC04AA8
	for <kvmarm@archiver.kernel.org>; Tue, 30 Apr 2019 09:50:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16B412080C
	for <kvmarm@archiver.kernel.org>; Tue, 30 Apr 2019 09:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16B412080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 674DA4A4DC;
	Tue, 30 Apr 2019 05:50:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vXA--Q0PPjZv; Tue, 30 Apr 2019 05:50:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0FCB4A4E6;
	Tue, 30 Apr 2019 05:50:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E47C4A4DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Apr 2019 05:50:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lzNFkipfa8pX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Apr 2019 05:50:35 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3B224A4D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Apr 2019 05:50:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44D7080D;
 Tue, 30 Apr 2019 02:50:34 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EBDB3F5C1;
 Tue, 30 Apr 2019 02:50:33 -0700 (PDT)
Subject: Re: [PATCH kvmtool 05/16] ioport: pci: Move port allocations to PCI
 devices
To: Andre Przywara <andre.przywara@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
 <1551947777-13044-6-git-send-email-julien.thierry@arm.com>
 <20190404144537.6d2343fc@donnerap.cambridge.arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <4fff7a02-8d7f-0b00-bbc4-ddb667c1e302@arm.com>
Date: Tue, 30 Apr 2019 10:50:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190404144537.6d2343fc@donnerap.cambridge.arm.com>
Content-Language: en-US
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190430095030.hlxlibu19duSS0y7hxObywQx-wzkktZ-Rj9VhTuKDU4@z>

Hi,

On 04/04/2019 14:45, Andre Przywara wrote:
> On Thu, 7 Mar 2019 08:36:06 +0000
> Julien Thierry <julien.thierry@arm.com> wrote:
> 
> Hi,
> 
>> The dynamic ioport allocation with IOPORT_EMPTY is currently only used
>> by PCI devices. Other devices use fixed ports for which they request
>> registration to the ioport API.
>>
>> PCI ports need to be in the PCI IO space and there is no reason ioport
>> API should know a PCI port is being allocated and needs to be placed in
>> PCI IO space. This currently just happens to be the case.
>>
>> Move the responsability of dynamic allocation of ioports from the ioport
>> API to PCI.
>>
>> In the future, if other types of devices also need dynamic ioport
>> allocation, they'll have to figure out the range of ports they are
>> allowed to use.
>>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> ---
>>  hw/pci-shmem.c       |  3 ++-
>>  hw/vesa.c            |  4 ++--
>>  include/kvm/ioport.h |  3 ---
>>  include/kvm/pci.h    |  2 ++
>>  ioport.c             | 18 ------------------
>>  pci.c                |  8 ++++++++
>>  vfio/core.c          |  6 ++++--
>>  virtio/pci.c         |  3 ++-
>>  8 files changed, 20 insertions(+), 27 deletions(-)
>>
>> diff --git a/hw/pci-shmem.c b/hw/pci-shmem.c
>> index f92bc75..a0c5ba8 100644
>> --- a/hw/pci-shmem.c
>> +++ b/hw/pci-shmem.c
>> @@ -357,7 +357,8 @@ int pci_shmem__init(struct kvm *kvm)
>>  		return 0;
>>  
>>  	/* Register MMIO space for MSI-X */
>> -	r = ioport__register(kvm, IOPORT_EMPTY, &shmem_pci__io_ops, IOPORT_SIZE, NULL);
>> +	r = pci_get_io_port_block(IOPORT_SIZE);
>> +	r = ioport__register(kvm, r, &shmem_pci__io_ops, IOPORT_SIZE, NULL);
>>  	if (r < 0)
>>  		return r;
>>  	ivshmem_registers = (u16)r;
>> diff --git a/hw/vesa.c b/hw/vesa.c
>> index f3c5114..404a8a3 100644
>> --- a/hw/vesa.c
>> +++ b/hw/vesa.c
>> @@ -60,8 +60,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>  
>>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>>  		return NULL;
>> -
>> -	r = ioport__register(kvm, IOPORT_EMPTY, &vesa_io_ops, IOPORT_SIZE, NULL);
>> +	r = pci_get_io_space_block(IOPORT_SIZE);
> 
> I am confused. This is still registering I/O ports, right? And this
> (misnamed) function is about MMIO?
> So should it read r = pci_get_io_port_block(IOPORT_SIZE); ?
> 
>> +	r = ioport__register(kvm, r, &vesa_io_ops, IOPORT_SIZE, NULL);
>>  	if (r < 0)
>>  		return ERR_PTR(r);
>>  
>> diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
>> index db52a47..b10fcd5 100644
>> --- a/include/kvm/ioport.h
>> +++ b/include/kvm/ioport.h
>> @@ -14,11 +14,8 @@
>>  
>>  /* some ports we reserve for own use */
>>  #define IOPORT_DBG			0xe0
>> -#define IOPORT_START			0x6200
>>  #define IOPORT_SIZE			0x400
>>  
>> -#define IOPORT_EMPTY			USHRT_MAX
>> -
>>  struct kvm;
>>  
>>  struct ioport {
>> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
>> index a86c15a..bdbd183 100644
>> --- a/include/kvm/pci.h
>> +++ b/include/kvm/pci.h
>> @@ -19,6 +19,7 @@
>>  #define PCI_CONFIG_DATA		0xcfc
>>  #define PCI_CONFIG_BUS_FORWARD	0xcfa
>>  #define PCI_IO_SIZE		0x100
>> +#define PCI_IOPORT_START	0x6200
>>  #define PCI_CFG_SIZE		(1ULL << 24)
>>  
>>  struct kvm;
>> @@ -153,6 +154,7 @@ int pci__init(struct kvm *kvm);
>>  int pci__exit(struct kvm *kvm);
>>  struct pci_device_header *pci__find_dev(u8 dev_num);
>>  u32 pci_get_io_space_block(u32 size);
> 
> So I think this was already misnamed, but with your new function below
> becomes utterly confusing. Can we rename this to pci_get_mmio_space_block?

Yes, seems fair enough. I'll add a patch to rename that.

> 
>> +u16 pci_get_io_port_block(u32 size);
>>  void pci__assign_irq(struct device_header *dev_hdr);
>>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size);
>>  void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size);
>> diff --git a/ioport.c b/ioport.c
>> index a6dc65e..a72e403 100644
>> --- a/ioport.c
>> +++ b/ioport.c
>> @@ -16,24 +16,8 @@
>>  
>>  #define ioport_node(n) rb_entry(n, struct ioport, node)
>>  
>> -DEFINE_MUTEX(ioport_mutex);
>> -
>> -static u16			free_io_port_idx; /* protected by ioport_mutex */
>> -
>>  static struct rb_root		ioport_tree = RB_ROOT;
>>  
>> -static u16 ioport__find_free_port(void)
>> -{
>> -	u16 free_port;
>> -
>> -	mutex_lock(&ioport_mutex);
>> -	free_port = IOPORT_START + free_io_port_idx * IOPORT_SIZE;
>> -	free_io_port_idx++;
>> -	mutex_unlock(&ioport_mutex);
>> -
>> -	return free_port;
>> -}
>> -
>>  static struct ioport *ioport_search(struct rb_root *root, u64 addr)
>>  {
>>  	struct rb_int_node *node;
>> @@ -85,8 +69,6 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
>>  	int r;
>>  
>>  	br_write_lock(kvm);
>> -	if (port == IOPORT_EMPTY)
>> -		port = ioport__find_free_port();
>>  
>>  	entry = ioport_search(&ioport_tree, port);
>>  	if (entry) {
>> diff --git a/pci.c b/pci.c
>> index 9edefa5..cd749db 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -19,6 +19,14 @@ static u32 pci_config_address_bits;
>>   * PCI isn't currently supported.)
>>   */
>>  static u32 io_space_blocks		= KVM_PCI_MMIO_AREA;
>> +static u16 io_port_blocks		= PCI_IOPORT_START;
>> +
>> +u16 pci_get_io_port_block(u32 size)
>> +{
>> +	u16 port = ALIGN(io_port_blocks, IOPORT_SIZE);
> 
> Nit: Can we please have an empty line after the variable declaration?
> 

We can :) .

Thanks,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
