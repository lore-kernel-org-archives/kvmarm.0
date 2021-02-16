Return-Path: <SRS0=hAGT=HS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC87C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Feb 2021 14:47:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D804264E41
	for <kvmarm@archiver.kernel.org>; Tue, 16 Feb 2021 14:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D804264E41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55BC54B432;
	Tue, 16 Feb 2021 09:47:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w4OQn3RQZpCD; Tue, 16 Feb 2021 09:47:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 357584B529;
	Tue, 16 Feb 2021 09:47:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8856C4B432
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Feb 2021 09:47:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FsyCZaqO14Ac for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Feb 2021 09:47:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 391274B346
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Feb 2021 09:47:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFD9931B;
 Tue, 16 Feb 2021 06:47:21 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B64413F694;
 Tue, 16 Feb 2021 06:47:20 -0800 (PST)
Subject: Re: [PATCH kvmtool 15/21] vfio: Refactor ioport trap handler
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-16-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d5a594dc-f916-d472-7504-f1bf3aa0f67a@arm.com>
Date: Tue, 16 Feb 2021 14:47:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-16-andre.przywara@arm.com>
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

Looks good, one nitpick below.

On 12/10/20 2:29 PM, Andre Przywara wrote:
> With the planned retirement of the special ioport emulation code, we
> need to provide an emulation function compatible with the MMIO prototype.
>
> Adjust the I/O port trap handler to use that new function, and provide
> shims to implement the old ioport interface, for now.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  vfio/core.c | 51 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 15 deletions(-)
>
> diff --git a/vfio/core.c b/vfio/core.c
> index 0b45e78b..f55f1f87 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -81,15 +81,12 @@ out_free_buf:
>  	return ret;
>  }
>  
> -static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> -			   u16 port, void *data, int len)
> +static bool _vfio_ioport_in(struct vfio_region *region, u32 offset,
> +			    void *data, int len)
>  {
> -	u32 val;
> -	ssize_t nr;
> -	struct vfio_region *region = ioport->priv;
>  	struct vfio_device *vdev = region->vdev;
> -
> -	u32 offset = port - region->port_base;
> +	ssize_t nr;
> +	u32 val;
>  
>  	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_READ))
>  		return false;
> @@ -97,7 +94,7 @@ static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
>  	nr = pread(vdev->fd, &val, len, region->info.offset + offset);
>  	if (nr != len) {
>  		vfio_dev_err(vdev, "could not read %d bytes from I/O port 0x%x\n",
> -			     len, port);
> +			     len, offset);

To keep things functionally identical, shouldn't that be offset +
region->port_base? I think it's easier to identify the device when we have the PCI
ioport address.

Thanks,

Alex

>  		return false;
>  	}
>  
> @@ -118,15 +115,13 @@ static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
>  	return true;
>  }
>  
> -static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> -			    u16 port, void *data, int len)
> +static bool _vfio_ioport_out(struct vfio_region *region, u32 offset,
> +			     void *data, int len)
>  {
> -	u32 val;
> -	ssize_t nr;
> -	struct vfio_region *region = ioport->priv;
>  	struct vfio_device *vdev = region->vdev;
> +	ssize_t nr;
> +	u32 val;
>  
> -	u32 offset = port - region->port_base;
>  
>  	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_WRITE))
>  		return false;
> @@ -148,11 +143,37 @@ static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
>  	nr = pwrite(vdev->fd, &val, len, region->info.offset + offset);
>  	if (nr != len)
>  		vfio_dev_err(vdev, "could not write %d bytes to I/O port 0x%x",
> -			     len, port);
> +			     len, offset);
>  
>  	return nr == len;
>  }
>  
> +static void vfio_ioport_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> +			     u8 is_write, void *ptr)
> +{
> +	struct vfio_region *region = ptr;
> +	u32 offset = addr - region->port_base;
> +
> +	if (is_write)
> +		_vfio_ioport_out(region, offset, data, len);
> +	else
> +		_vfio_ioport_in(region, offset, data, len);
> +}
> +
> +static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> +			    u16 port, void *data, int len)
> +{
> +	vfio_ioport_mmio(vcpu, port, data, len, true, ioport->priv);
> +	return true;
> +}
> +
> +static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> +			   u16 port, void *data, int len)
> +{
> +	vfio_ioport_mmio(vcpu, port, data, len, false, ioport->priv);
> +	return true;
> +}
> +
>  static struct ioport_operations vfio_ioport_ops = {
>  	.io_in	= vfio_ioport_in,
>  	.io_out	= vfio_ioport_out,
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
