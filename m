Return-Path: <SRS0=6MoU=NW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 249D9C432BE
	for <kvmarm@archiver.kernel.org>; Tue, 31 Aug 2021 11:11:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9192C600D4
	for <kvmarm@archiver.kernel.org>; Tue, 31 Aug 2021 11:10:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9192C600D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CC284B091;
	Tue, 31 Aug 2021 07:10:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9VDVlxDhfIzR; Tue, 31 Aug 2021 07:10:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25DAB4B191;
	Tue, 31 Aug 2021 07:10:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8E2E4B12B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Aug 2021 07:10:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6hRWgm6YJJ3z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Aug 2021 07:10:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD9E4B091
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Aug 2021 07:10:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43EF01FB;
 Tue, 31 Aug 2021 04:10:51 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EAD43F694;
 Tue, 31 Aug 2021 04:10:50 -0700 (PDT)
Date: Tue, 31 Aug 2021 12:10:35 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH][kvmtool] virtio/pci: Size the MSI-X bar according to
 the number of MSI-X
Message-ID: <20210831121035.6b5c993b@slackpad.fritz.box>
In-Reply-To: <20210827115405.1981529-1-maz@kernel.org>
References: <20210827115405.1981529-1-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, 27 Aug 2021 12:54:05 +0100
Marc Zyngier <maz@kernel.org> wrote:

Hi Marc,

> Since 45d3b59e8c45 ("kvm tools: Increase amount of possible interrupts
> per PCI device"), the number of MSI-S has gone from 4 to 33.
> 
> However, the corresponding storage hasn't been upgraded, and writing
> to the MSI-X table is a pretty risky business. Now that the Linux
> kernel writes to *all* MSI-X entries before doing anything else
> with the device, kvmtool dies a horrible death.
> 
> Fix it by properly defining the size of the MSI-X bar, and make
> Linux great again.
> 
> This includes some fixes the PBA region decoding, as well as minor
> cleanups to make this code a bit more maintainable.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Many thanks for fixing this, it looks good to me now. Just some
questions below:

> ---
>  virtio/pci.c | 42 ++++++++++++++++++++++++++++++------------
>  1 file changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/virtio/pci.c b/virtio/pci.c
> index eb91f512..41085291 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -7,6 +7,7 @@
>  #include "kvm/irq.h"
>  #include "kvm/virtio.h"
>  #include "kvm/ioeventfd.h"
> +#include "kvm/util.h"
>  
>  #include <sys/ioctl.h>
>  #include <linux/virtio_pci.h>
> @@ -14,6 +15,13 @@
>  #include <assert.h>
>  #include <string.h>
>  
> +#define ALIGN_UP(x, s)		ALIGN((x) + (s) - 1, (s))
> +#define VIRTIO_NR_MSIX		(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG)
> +#define VIRTIO_MSIX_TABLE_SIZE	(VIRTIO_NR_MSIX * 16)
> +#define VIRTIO_MSIX_PBA_SIZE	(ALIGN_UP(VIRTIO_MSIX_TABLE_SIZE, 64) / 8)
> +#define VIRTIO_MSIX_BAR_SIZE	(1UL << fls_long(VIRTIO_MSIX_TABLE_SIZE + \
> +						 VIRTIO_MSIX_PBA_SIZE))
> +
>  static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
>  {
>  	return pci__bar_address(&vpci->pci_hdr, 0);
> @@ -333,18 +341,27 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
>  	struct virtio_pci *vpci = vdev->virtio;
>  	struct msix_table *table;
>  	u32 msix_io_addr = virtio_pci__msix_io_addr(vpci);
> +	u32 pba_offset;
>  	int vecnum;
>  	size_t offset;
>  
> -	if (addr > msix_io_addr + PCI_IO_SIZE) {

Ouch, the missing "=" looks like another long standing bug you fixed, I
wonder how this ever worked before? Looking deeper it looks like the
whole PBA code was quite broken (allowing writes, for instance, and
mixing with the code for the MSIX table)?

> +	BUILD_BUG_ON(VIRTIO_NR_MSIX > (sizeof(vpci->msix_pba) * 8));
> +
> +	pba_offset = vpci->pci_hdr.msix.pba_offset & ~PCI_MSIX_TABLE_BIR;

Any particular reason you read back the offset from the MSIX capability
instead of just using VIRTIO_MSIX_TABLE_SIZE here? Is that to avoid
accidentally diverging in the future, by having just one place of
definition?

> +	if (addr >= msix_io_addr + pba_offset) {
> +		/* Read access to PBA */
>  		if (is_write)
>  			return;
> -		table  = (struct msix_table *)&vpci->msix_pba;
> -		offset = addr - (msix_io_addr + PCI_IO_SIZE);
> -	} else {
> -		table  = vpci->msix_table;
> -		offset = addr - msix_io_addr;
> +		offset = addr - (msix_io_addr + pba_offset);
> +		if ((offset + len) > sizeof (vpci->msix_pba))
> +			return;
> +		memcpy(data, (void *)&vpci->msix_pba + offset, len);

Should this be a char* cast, since pointer arithmetic on void* is
somewhat frowned upon (aka "forbidden in the C standard, but allowed as
a GCC extension")?

Cheers,
Andre

> +		return;
>  	}
> +
> +	table  = vpci->msix_table;
> +	offset = addr - msix_io_addr;
> +
>  	vecnum = offset / sizeof(struct msix_table);
>  	offset = offset % sizeof(struct msix_table);
>  
> @@ -520,7 +537,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  
>  	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
>  	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
> -	msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
> +	msix_io_block = pci_get_mmio_block(VIRTIO_MSIX_BAR_SIZE);
>  
>  	vpci->pci_hdr = (struct pci_device_header) {
>  		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
> @@ -543,7 +560,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
>  		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
>  		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
> -		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
> +		.bar_size[2]		= cpu_to_le32(VIRTIO_MSIX_BAR_SIZE),
>  	};
>  
>  	r = pci__register_bar_regions(kvm, &vpci->pci_hdr,
> @@ -560,8 +577,9 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	vpci->pci_hdr.msix.cap = PCI_CAP_ID_MSIX;
>  	vpci->pci_hdr.msix.next = 0;
>  	/*
> -	 * We at most have VIRTIO_PCI_MAX_VQ entries for virt queue,
> -	 * VIRTIO_PCI_MAX_CONFIG entries for config.
> +	 * We at most have VIRTIO_NR_MSIX entries (VIRTIO_PCI_MAX_VQ
> +	 * entries for virt queue, VIRTIO_PCI_MAX_CONFIG entries for
> +	 * config).
>  	 *
>  	 * To quote the PCI spec:
>  	 *
> @@ -570,11 +588,11 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	 * For example, a returned value of "00000000011"
>  	 * indicates a table size of 4.
>  	 */
> -	vpci->pci_hdr.msix.ctrl = cpu_to_le16(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG - 1);
> +	vpci->pci_hdr.msix.ctrl = cpu_to_le16(VIRTIO_NR_MSIX - 1);
>  
>  	/* Both table and PBA are mapped to the same BAR (2) */
>  	vpci->pci_hdr.msix.table_offset = cpu_to_le32(2);
> -	vpci->pci_hdr.msix.pba_offset = cpu_to_le32(2 | PCI_IO_SIZE);
> +	vpci->pci_hdr.msix.pba_offset = cpu_to_le32(2 | VIRTIO_MSIX_TABLE_SIZE);
>  	vpci->config_vector = 0;
>  
>  	if (irq__can_signal_msi(kvm))

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
