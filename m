Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8B9C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 16:29:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE8D2613DA
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 16:29:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE8D2613DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 721DA4B10A;
	Wed, 29 Sep 2021 12:29:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8KWe2eVoOeW3; Wed, 29 Sep 2021 12:29:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 154734B132;
	Wed, 29 Sep 2021 12:29:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE934B12F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 12:29:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4pn0lcnt+fdg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 12:29:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BF7C4B10A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 12:29:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632932966;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NQx2xj6HF67LAuBQdKdhBIXW5cGRVi2ucKp6xvBgZPA=;
 b=esuHkilKVoE1XNfa6/GXBIjq5ZnIU+zChP7oKlaHLQVRPe48g6e3c1mlzmbzxk0K42eyuB
 1X96WjBPsctFnh93OyHC8jakM7JR5k4zrirlcH42klrCcEASZPfHGcfnaCExcehTP0SDdM
 YoDU/W/9LR4fj9k4I7jnZFwXQRkObOU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-wIrcTXkuMS64mEJz15Xb3A-1; Wed, 29 Sep 2021 12:29:25 -0400
X-MC-Unique: wIrcTXkuMS64mEJz15Xb3A-1
Received: by mail-wm1-f72.google.com with SMTP id
 a137-20020a1c7f8f000000b0030cda9c0feeso1464747wmd.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=NQx2xj6HF67LAuBQdKdhBIXW5cGRVi2ucKp6xvBgZPA=;
 b=8OALqWqMvon9IPuNqKs7Xic5A/xEwpmx026UulJx+9hyzklr3VtglEIkUnchKUA0PM
 MoxOnZ+FRDaPNzn+HhzRnQnllMunJk/+Zu+kRsCDETzXe9LaSwAe6T303RkSauVU5g/9
 Q/eqZiPRcReGiGPPA8jHrypuoarfGGRLE/qgy2+LZzxQLlU2zBMsMpOF9fA8xdr0dt4S
 FBZVOg1bPJw5bzQqS2Y80qfa2cYGe1yhSu5ZAvMit2FHPJy89o96FuskSzdPkehYdrhk
 Ga+JIl3qAS/VTOOxDsZ0hRHAxQTJwqTS05M35K4qW9qbm/JTQFaHVRwTpz2zQJVTDK9v
 Hrew==
X-Gm-Message-State: AOAM533wgYv4g7xXq5Jiiyyj1XvDLisaw4m7JAC9MPNiltchrTVwwC1K
 PPF8ZmKXgfKe3lCDQ26JkErnQGdJOYpZItgSSvr6CLtywKGNO6nslG4Pti+nkEv82XpQIfInL5f
 5R3FeWBB0N8myU0Sv6Nk4c42q
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr10532335wmc.114.1632932964305; 
 Wed, 29 Sep 2021 09:29:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjPYG2GldBAGUDiZVvrsb69nxkr4sn6oQ/M0aRFiAmWdoOXqQa1HfuXqlT+QG3rv5j6MMwAA==
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr10532307wmc.114.1632932964083; 
 Wed, 29 Sep 2021 09:29:24 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id c185sm346633wma.8.2021.09.29.09.29.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Sep 2021 09:29:23 -0700 (PDT)
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
Date: Wed, 29 Sep 2021 18:29:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-2-ricarkol@google.com>
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

On 9/28/21 8:47 PM, Ricardo Koller wrote:
> Add the new vgic_check_iorange helper that checks that an iorange is
> sane: the start address and size have valid alignments, the range is
> within the addressable PA range, start+size doesn't overflow, and the
> start wasn't already defined.
>
> No functional change.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
>  2 files changed, 26 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 7740995de982..f714aded67b2 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>  	return 0;
>  }
>  
> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> +		       phys_addr_t addr, phys_addr_t alignment,
> +		       phys_addr_t size)
> +{
> +	int ret;
> +
> +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
nit: not related to this patch but I am just wondering why we are
passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to

vgic_check_iorange()? This must be a leftover of some old code?

> +	if (ret)
> +		return ret;
> +
> +	if (!IS_ALIGNED(size, alignment))
> +		return -EINVAL;
> +
> +	if (addr + size < addr)
> +		return -EINVAL;
> +
> +	if (addr + size > kvm_phys_size(kvm))
> +		return -E2BIG;
> +
> +	return 0;
> +}
> +
>  static int vgic_check_type(struct kvm *kvm, int type_needed)
>  {
>  	if (kvm->arch.vgic.vgic_model != type_needed)
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 14a9218641f5..c4df4dcef31f 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
>  int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>  		      phys_addr_t addr, phys_addr_t alignment);
>  
> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> +		       phys_addr_t addr, phys_addr_t alignment,
> +		       phys_addr_t size);
> +
>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
