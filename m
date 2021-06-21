Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96DDC48BC2
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 12:21:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 497B66112D
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 12:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 497B66112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E0F406DD;
	Mon, 21 Jun 2021 08:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EX25RPwhgW1z; Mon, 21 Jun 2021 08:21:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72CA240629;
	Mon, 21 Jun 2021 08:21:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FC34056A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 08:21:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TL9TGB7uAfZd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 08:21:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB40140212
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 08:21:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624278113;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VhDAKKgaNDrSL7iSXcPu9LD5gECJffFFHIw26sWyyR0=;
 b=EB4NhdvXbk8MaJC3Ss43fjYmDXmrttqEckL9cR3UI7uIFA+MbJB/aozcYf5ov0MNhgMQU+
 8QAvaYBRvJJoZOFFIsqomdD4UuWwHM3qVSceOegL/1ssg3k+MELf8c+KG9MnOzcKVlTHnB
 sB0x1zl6wqI4xTjKvGk2jD2Z2qrMVko=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-lmv3sSXIPF-u3fewO8THjQ-1; Mon, 21 Jun 2021 08:21:52 -0400
X-MC-Unique: lmv3sSXIPF-u3fewO8THjQ-1
Received: by mail-wr1-f70.google.com with SMTP id
 n2-20020adfb7420000b029010e47b59f31so8292791wre.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 05:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:subject:to:references:from:message-id
 :date:user-agent:mime-version:in-reply-to:content-transfer-encoding
 :content-language;
 bh=VhDAKKgaNDrSL7iSXcPu9LD5gECJffFFHIw26sWyyR0=;
 b=uV24uc5HupsIGSEL7fgx0fL4ItvMSACvByie9KSo9GpIVMPeUUdWkBHSKMh7R4NEww
 W11hPAiQvGLPEnQQFXtwInk1jWiDvgGVLshuw9jxZFZQdugXm5Smghadt9qt1zj/NH6h
 MqCbbDDRFmqFOX/P8eQieqVo+gKv/aQ5ivMmFsy27KD9Ocw84Bii/N/J9T1UiB8wNoJ+
 1xHPu25teADRIiKKzle4p+JWGEiCgDVXK909KOntaxKKiV7Hb3Fqs6kqRfKDBlcdQgHV
 1fjQdkx95Dlj5baTNF8NvdzzNSGBsO+zVhFSeB9shrFCgTE/XPvTLdKek9NgwbxmYQtW
 QJWg==
X-Gm-Message-State: AOAM532le3JBYYTStGD+HOIRgJCxUxBe1Kkcw9hzW361dlHBk5Mf4M/L
 6VaNyWG0/ZEfCBfXs07M4aoWWK+C2FidAr77VR3l8lTRBh4nqe8CSvWN8A/B2I40yh8WC2Yf1d9
 Ehd25+EIag+60Q9X7mVr4vZFHwuj6hS0ked3RoObwH7JCuMXD8N/qV02fKK6myPRZAbn843f0Iw
 pitVA=
X-Received: by 2002:a7b:ce8e:: with SMTP id q14mr12106035wmj.33.1624278110434; 
 Mon, 21 Jun 2021 05:21:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFLQpGIAVfisiyTY6nyCXRe3QRWDsB4/y9R3ja660K2K9yyGgRerGQ+R2pQj2G1e1aEWhFSw==
X-Received: by 2002:a7b:ce8e:: with SMTP id q14mr12106002wmj.33.1624278110220; 
 Mon, 21 Jun 2021 05:21:50 -0700 (PDT)
Received: from [192.168.43.95] ([37.173.110.237])
 by smtp.gmail.com with ESMTPSA id l23sm16824154wmc.5.2021.06.21.05.21.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 21 Jun 2021 05:21:49 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
To: eric.auger.pro@gmail.com, stable@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210621121839.792649-1-eric.auger@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <f8e6aab9-651c-9ef1-2621-6d61374704cc@redhat.com>
Date: Mon, 21 Jun 2021 14:21:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210621121839.792649-1-eric.auger@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

Hi,

On 6/21/21 2:18 PM, Eric Auger wrote:
> When reading the base address of the a REDIST region
> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
> redistributor region list to be populated with a single
> element.
>
> However list_first_entry() expects the list to be non empty.
> Instead we should use list_first_entry_or_null which effectively
> returns NULL if the list is empty.
>
> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
> Cc: <Stable@vger.kernel.org> # v4.19
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com

Maybe I should I prefixed the patch with [stable-4.19]. This is already
on master and in various stable but did not apply on 4.19

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 6ada2432e37c..71d92096776e 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -95,8 +95,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
>  			goto out;
>  		}
> -		rdreg = list_first_entry(&vgic->rd_regions,
> -					 struct vgic_redist_region, list);
> +		rdreg = list_first_entry_or_null(&vgic->rd_regions,
> +						 struct vgic_redist_region, list);
>  		if (!rdreg)
>  			addr_ptr = &undef_value;
>  		else

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
