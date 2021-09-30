Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEEFC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 07:02:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E4AE617E4
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 07:02:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8E4AE617E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05B20407F1;
	Thu, 30 Sep 2021 03:02:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ft7SCSN2cl1z; Thu, 30 Sep 2021 03:02:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD154B0DB;
	Thu, 30 Sep 2021 03:02:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2884086C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 03:02:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mHk5qiBmsD6L for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 03:02:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 736B2407F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 03:02:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632985338;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ZHSiUrkZvCsxOeU5xfKaRYm9wqLGK3XFjTD1F2kLbP0=;
 b=dZhgHeO8bL3OpuZkrBWk/zsx1rnFrQM5tR/RIGbM2jUNUPnId4pxZ1InD+BtWW7hzElCz2
 D3rQDUObKUbqwWYRxk2HSrYia9LRyIxGfTqaq7OknsQ5qxOtmCS4x/Vp4xFm9AQUSFtKhL
 aL6iTNDvY8IGNE2yB5npmaN36bfyZFg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-6Oa823B_MAGJbfVyM-z7DA-1; Thu, 30 Sep 2021 03:02:16 -0400
X-MC-Unique: 6Oa823B_MAGJbfVyM-z7DA-1
Received: by mail-wm1-f69.google.com with SMTP id
 y142-20020a1c7d94000000b0030cdc76dedeso3890223wmc.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 00:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=ZHSiUrkZvCsxOeU5xfKaRYm9wqLGK3XFjTD1F2kLbP0=;
 b=fqFW7LY7w6kBsI1i8oIdh3P6OZpQNwY1yvNuDXvsPdpcWc5ANZ175hzyUG5awyANPT
 ohkXW0rLAsoSBYEuI9PKTDAKQaNE34Kg+hK2TAYyjk68XuLVvlKC1ZqNFfoU1qt770LW
 1qG2FnUsg8TP0omKNwfYDt46MXWXRdG3S0YvvL/DNgxrpTdI9kQnq67RHMqFA9IkCvEM
 IpAd32Vq5tHLZhVYVO6XPlxRYri0R6p3by3nSt0wybizwo4By+qCr2DyOTH4i5r6IFvM
 JO/tkBbPwrcEzgF04K5tJgDjbkMpBYRbLkiQWaR7FPBtGFp2ATSoKkV2Sj89StMcgUJI
 ukLg==
X-Gm-Message-State: AOAM531NlQul4/G6sYzwox3yCXSCFXGqM2jrL2h0ZSaQwarFiBt8r1U9
 UJj1KdO8rO+MoQomgqoMuYqroiJG8o7VI6nV1IAeR97NpncL+jX4VVNYYLERZqeZ7Ci9fRnjoIr
 vdTNWvEz0J0EpMd2ixeUp04jl
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr3707475wmc.14.1632985335366;
 Thu, 30 Sep 2021 00:02:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxF78XOIE/kiNSNg9Ko30J2+7Orfs0VyPIx6WyeXUiutZXvna7Xlsl7/OC8dJdC85oi6yDVfg==
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr3707452wmc.14.1632985335175;
 Thu, 30 Sep 2021 00:02:15 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id w17sm1878500wmi.42.2021.09.30.00.02.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Sep 2021 00:02:14 -0700 (PDT)
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
To: Ricardo Koller <ricarkol@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
 <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
 <YVTX1L8u8NMxHAyE@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <1613b54f-2c4b-a57a-d4ba-92e866c5ff1f@redhat.com>
Date: Thu, 30 Sep 2021 09:02:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YVTX1L8u8NMxHAyE@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On 9/29/21 11:17 PM, Ricardo Koller wrote:
> On Wed, Sep 29, 2021 at 06:29:21PM +0200, Eric Auger wrote:
>> Hi Ricardo,
>>
>> On 9/28/21 8:47 PM, Ricardo Koller wrote:
>>> Add the new vgic_check_iorange helper that checks that an iorange is
>>> sane: the start address and size have valid alignments, the range is
>>> within the addressable PA range, start+size doesn't overflow, and the
>>> start wasn't already defined.
>>>
>>> No functional change.
>>>
>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
>>>  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
>>>  2 files changed, 26 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>>> index 7740995de982..f714aded67b2 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>>> @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>>>  	return 0;
>>>  }
>>>  
>>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
>>> +		       phys_addr_t addr, phys_addr_t alignment,
>>> +		       phys_addr_t size)
>>> +{
>>> +	int ret;
>>> +
>>> +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
>> nit: not related to this patch but I am just wondering why we are
>> passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to
>>
>> vgic_check_iorange()? This must be a leftover of some old code?
>>
> It's used to check that the base of a region is not already set.
> kvm_vgic_addr() uses it to make that check;
> vgic_v3_alloc_redist_region() does not:
>
>   rdreg->base = VGIC_ADDR_UNDEF; // so the "not already defined" check passes
>   ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
Yes but I meant why a pointer?

Eric
>
> Thanks,
> Ricardo
>
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	if (!IS_ALIGNED(size, alignment))
>>> +		return -EINVAL;
>>> +
>>> +	if (addr + size < addr)
>>> +		return -EINVAL;
>>> +
>>> +	if (addr + size > kvm_phys_size(kvm))
>>> +		return -E2BIG;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static int vgic_check_type(struct kvm *kvm, int type_needed)
>>>  {
>>>  	if (kvm->arch.vgic.vgic_model != type_needed)
>>> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
>>> index 14a9218641f5..c4df4dcef31f 100644
>>> --- a/arch/arm64/kvm/vgic/vgic.h
>>> +++ b/arch/arm64/kvm/vgic/vgic.h
>>> @@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
>>>  int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>>>  		      phys_addr_t addr, phys_addr_t alignment);
>>>  
>>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
>>> +		       phys_addr_t addr, phys_addr_t alignment,
>>> +		       phys_addr_t size);
>>> +
>>>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>>>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>>>  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
>> Besides
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Eric
>>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
