Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE67C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 07:56:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE91360FE8
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 07:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CE91360FE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 595C34B2BC;
	Tue,  5 Oct 2021 03:56:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eUpb9KZ-kCh2; Tue,  5 Oct 2021 03:56:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46DA74B2AD;
	Tue,  5 Oct 2021 03:56:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 916FB4B286
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 03:56:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z9rhCZWXmytB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 03:56:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C6DC4B26D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 03:56:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633420590;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uxcsc9+/ALGMdXirECAEtPRw+buxJ+mONYYMojv18BA=;
 b=G+OFhBmEDJbeM0vpZeMeZzSr36n3CsueGYchkxTgdr10zwrZkE4HoK6NNvRZeoT7zQ2Ec1
 gGHe9GW7arkA/ptIRR5E27sxU9i/B/MX3FitlsE5IS5SODOnifWKOh30xYX9XyPsaRi+Rv
 z35j6YqCf1ehNlsga/dLzb/iCP3JnWE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-zlXea4r5NJCbCfFBFkXp3A-1; Tue, 05 Oct 2021 03:56:28 -0400
X-MC-Unique: zlXea4r5NJCbCfFBFkXp3A-1
Received: by mail-wm1-f70.google.com with SMTP id
 p63-20020a1c2942000000b0030ccf0767baso944621wmp.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 00:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=uxcsc9+/ALGMdXirECAEtPRw+buxJ+mONYYMojv18BA=;
 b=dnU1Zo0pNSo1IhZTvZ1M1IZSpvr846RYQV/68z8UP24A3zkTA/SoP+lXCou4xv/sGs
 fO5C/hdMmWhb0Og7SmsPBOEi0UqQFY7PqMSIL/CbhnQzPS6f9z8jV/pG7ZDpQW0JEunZ
 lLZMO4QrE3r8hM/pM0yQpGJgsMqHAA3DMOj4/YHpozXcuExDoOksigOQhoQAJg64C4u2
 yBo5ZLWaznFr4PzLagsshTwBP9bKgb7KTBWciwLZ6sxH3+Wo3/VhrWE/zmF66ekDSnEL
 84nwKjvwDdlCs1w9IGeru+m+iSrvBm3Uvprcob92qB+wCRl26BEddWUf/p/y7uIOtUxs
 R8UA==
X-Gm-Message-State: AOAM533cgZmNdDjJOoVMAEIBozqFVX4RyhwW6oIMK9uYqgJ2/U+IWBmV
 mlBrPAUDy2aGYOfjrd8MC6xi+fKMjmeOVuoD6SeoOFhDH1wQ8DyAcXWKaiO77vNf8zpfTXQZmLl
 TiyMBdXxhqS4uLwIXyFH8Cxxv
X-Received: by 2002:a05:600c:1553:: with SMTP id
 f19mr1867651wmg.66.1633420587310; 
 Tue, 05 Oct 2021 00:56:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq2lzHQkf14bsNcBYPLOhdihVC1Vma+u2W+yn9GkssSn4fsp8+uC08Zbe0RKlILdRfGdfvBA==
X-Received: by 2002:a05:600c:1553:: with SMTP id
 f19mr1867634wmg.66.1633420587115; 
 Tue, 05 Oct 2021 00:56:27 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l17sm16929611wrx.24.2021.10.05.00.56.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Oct 2021 00:56:26 -0700 (PDT)
Subject: Re: [PATCH v4 05/11] KVM: arm64: vgic: Drop vgic_check_ioaddr()
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-6-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <a6a69648-0fc3-3d94-0e65-dc82693ce4c7@redhat.com>
Date: Tue, 5 Oct 2021 09:56:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-6-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

Hi Ricardo,

On 10/5/21 3:19 AM, Ricardo Koller wrote:
> There are no more users of vgic_check_ioaddr(). Move its checks to
> vgic_check_iorange() and then remove it.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 26 ++++----------------------
>  arch/arm64/kvm/vgic/vgic.h            |  3 ---
>  2 files changed, 4 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 08ae34b1a986..0d000d2fe8d2 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -14,38 +14,20 @@
>  
>  /* common helpers */
>  
> -int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> -		      phys_addr_t addr, phys_addr_t alignment)
> -{
> -	if (addr & ~kvm_phys_mask(kvm))
> -		return -E2BIG;
> -
> -	if (!IS_ALIGNED(addr, alignment))
> -		return -EINVAL;
> -
> -	if (!IS_VGIC_ADDR_UNDEF(*ioaddr))
> -		return -EEXIST;
> -
> -	return 0;
> -}
> -
>  int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
>  		       phys_addr_t addr, phys_addr_t alignment,
>  		       phys_addr_t size)
>  {
> -	int ret;
> -
> -	ret = vgic_check_ioaddr(kvm, &ioaddr, addr, alignment);
> -	if (ret)
> -		return ret;
> +	if (!IS_VGIC_ADDR_UNDEF(ioaddr))
> +		return -EEXIST;
>  
> -	if (!IS_ALIGNED(size, alignment))
> +	if (!IS_ALIGNED(addr, alignment) || !IS_ALIGNED(size, alignment))
>  		return -EINVAL;
>  
>  	if (addr + size < addr)
>  		return -EINVAL;
>  
> -	if (addr + size > kvm_phys_size(kvm))
> +	if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
>  		return -E2BIG;
>  
>  	return 0;
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 4be01c38e8f1..3fd6c86a7ef3 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -172,9 +172,6 @@ void vgic_kick_vcpus(struct kvm *kvm);
>  void vgic_irq_handle_resampling(struct vgic_irq *irq,
>  				bool lr_deactivated, bool lr_pending);
>  
> -int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> -		      phys_addr_t addr, phys_addr_t alignment);
> -
>  int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
>  		       phys_addr_t addr, phys_addr_t alignment,
>  		       phys_addr_t size);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
