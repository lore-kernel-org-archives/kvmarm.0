Return-Path: <SRS0=FDJp=HO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED58BC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Feb 2021 17:50:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 700B064E9C
	for <kvmarm@archiver.kernel.org>; Fri, 12 Feb 2021 17:50:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 700B064E9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E39AC4B3F9;
	Fri, 12 Feb 2021 12:50:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id awnKte2m2-4F; Fri, 12 Feb 2021 12:50:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6A534B390;
	Fri, 12 Feb 2021 12:50:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2087A4B3F9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2021 12:50:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7+8aQsCvWFGe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Feb 2021 12:50:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 533154B3F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2021 12:50:13 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DACB21063;
 Fri, 12 Feb 2021 09:50:12 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFDAE3F73B;
 Fri, 12 Feb 2021 09:50:11 -0800 (PST)
Subject: Re: [PATCH kvmtool 12/21] hw/vesa: Switch trap handling to use MMIO
 handler
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-13-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ca9d5ae8-9f16-ef7e-0a8b-2d389f56c3bc@arm.com>
Date: Fri, 12 Feb 2021 17:50:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-13-andre.przywara@arm.com>
Content-Language: en-US
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Andre,

On 12/10/20 2:28 PM, Andre Przywara wrote:
> To be able to use the VESA device with the new generic I/O trap handler,
> we need to use the different MMIO handler callback routine.
>
> Replace the existing dummy in and out handlers with a joint dummy
> MMIO handler, and register this using the new registration function.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/vesa.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/hw/vesa.c b/hw/vesa.c
> index 8659a002..7f82cdb4 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -43,21 +43,11 @@ static struct framebuffer vesafb = {
>  	.mem_size	= VESA_MEM_SIZE,
>  };
>  
> -static bool vesa_pci_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +static void vesa_pci_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> +		        u8 is_write, void *ptr)
>  {
> -	return true;
>  }
>  
> -static bool vesa_pci_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	return true;
> -}
> -
> -static struct ioport_operations vesa_io_ops = {
> -	.io_in			= vesa_pci_io_in,
> -	.io_out			= vesa_pci_io_out,
> -};
> -
>  static int vesa__bar_activate(struct kvm *kvm, struct pci_device_header *pci_hdr,
>  			      int bar_num, void *data)
>  {
> @@ -82,7 +72,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  	BUILD_BUG_ON(VESA_MEM_SIZE < VESA_BPP/8 * VESA_WIDTH * VESA_HEIGHT);
>  
>  	vesa_base_addr = pci_get_io_port_block(PCI_IO_SIZE);
> -	r = ioport__register(kvm, vesa_base_addr, &vesa_io_ops, PCI_IO_SIZE, NULL);
> +	r = kvm__register_pio(kvm, vesa_base_addr, PCI_IO_SIZE, vesa_pci_io,
> +			      NULL);
>  	if (r < 0)
>  		goto out_error;
>  
> @@ -116,7 +107,7 @@ unmap_dev:
>  unregister_device:
>  	device__unregister(&vesa_device);
>  unregister_ioport:
> -	ioport__unregister(kvm, vesa_base_addr);
> +	kvm__deregister_pio(kvm, vesa_base_addr);
>  out_error:
>  	return ERR_PTR(r);
>  }

Looks good:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
