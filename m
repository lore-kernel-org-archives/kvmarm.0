Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47DCC2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 17:30:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF36F24654
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 17:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NqWJyVHo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF36F24654
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213574B87C;
	Tue, 17 Nov 2020 12:30:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bUjSoFiRpio8; Tue, 17 Nov 2020 12:30:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C52F4B810;
	Tue, 17 Nov 2020 12:30:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86F034B808
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 12:30:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qy5IjiM0Y4wk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 12:30:01 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63FA54B7F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 12:30:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605634201;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Vro1buifvm686BzsfyYs3/2N9XyBtnxtRecQ5TGBeE8=;
 b=NqWJyVHoXO7A4N5DhC/cOx9e1Ugd35cYKLj2+i2DqjmGzw8e6mWgPOy5DwZdHFWn7qLhWt
 LqnjDT3RNkWElHIaMWycqMg2VUqcCnN89otY7YtM4lZq6bwi1IHNyerYw9MfhbN4kiCATo
 EUds5dyAlR5zCHKH64GSQn++U+XhyMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-Ewue8X--PqmxoBXd4NNcFg-1; Tue, 17 Nov 2020 12:29:56 -0500
X-MC-Unique: Ewue8X--PqmxoBXd4NNcFg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAEEFF6CF5;
 Tue, 17 Nov 2020 17:29:54 +0000 (UTC)
Received: from [10.36.115.104] (ovpn-115-104.ams2.redhat.com [10.36.115.104])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E65B10013C4;
 Tue, 17 Nov 2020 17:29:51 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Drop the reporting of
 GICR_TYPER.Last for userspace
To: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org
References: <20201117151629.1738-1-yuzenghui@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <4c9c10f9-fc6d-2725-168e-db6442b74574@redhat.com>
Date: Tue, 17 Nov 2020 18:29:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201117151629.1738-1-yuzenghui@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

Hi Zenghui,

On 11/17/20 4:16 PM, Zenghui Yu wrote:
> It was recently reported that if GICR_TYPER is accessed before the RD base
> address is set, we'll suffer from the unset @rdreg dereferencing. Oops...
> 
> 	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
> 			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;
> 
> It's "expected" that users will access registers in the redistributor if
> the RD has been properly configured (e.g., the RD base address is set). But
> it hasn't yet been covered by the existing documentation.
> 
> Per discussion on the list [1], the reporting of the GICR_TYPER.Last bit
> for userspace never actually worked. And it's difficult for us to emulate
> it correctly given that userspace has the flexibility to access it any
> time. Let's just drop the reporting of the Last bit for userspace for now
> (userspace should have full knowledge about it anyway) and it at least
> prevents kernel from panic ;-)
> 
> [1] https://lore.kernel.org/kvmarm/c20865a267e44d1e2c0d52ce4e012263@kernel.org/
> 
> Fixes: ba7b3f1275fd ("KVM: arm/arm64: Revisit Redistributor TYPER last bit computation")
> Reported-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Given the state of last bit, it looks sensible atm.

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


> ---
> 
> This may be the easiest way to fix the issue and to get the fix backported
> to stable tree. There is still some work can be done since (at least) we
> have code duplicates between the MMIO and uaccess callbacks.
> 
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 52d6f24f65dc..15a6c98ee92f 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -273,6 +273,23 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>  	return extract_bytes(value, addr & 7, len);
>  }
>  
> +static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
> +						 gpa_t addr, unsigned int len)
> +{
> +	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +	int target_vcpu_id = vcpu->vcpu_id;
> +	u64 value;
> +
> +	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
> +	value |= ((target_vcpu_id & 0xffff) << 8);
> +
> +	if (vgic_has_its(vcpu->kvm))
> +		value |= GICR_TYPER_PLPIS;
> +
> +	/* reporting of the Last bit is not supported for userspace */
> +	return extract_bytes(value, addr & 7, len);
> +}
> +
>  static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
>  					     gpa_t addr, unsigned int len)
>  {
> @@ -593,8 +610,9 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
>  		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
>  		VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
> -		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
> +	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_TYPER,
> +		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi,
> +		vgic_uaccess_read_v3r_typer, vgic_mmio_uaccess_write_wi, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
