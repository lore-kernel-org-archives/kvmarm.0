Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC71AC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 16:24:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15E82615E4
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 16:24:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 15E82615E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68CB94B135;
	Wed, 29 Sep 2021 12:24:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kdfAsjGSlg44; Wed, 29 Sep 2021 12:24:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67BA04B0F1;
	Wed, 29 Sep 2021 12:24:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C94BA4B0F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 12:24:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XZNDiVg1BwuT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 12:24:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA51C4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 12:24:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632932673;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WPjpZB7ZKa4VEqgp/LOlyRjs9pgY0FjMtIXN/7uEb5A=;
 b=TPePhJWjKrHhO2Effw3O/myTN2P4ALYS7d2rLP5WGltXyYcKxcukEVsQntbDOs/G4jXuGB
 HWItieMR7LdVuFb5a2k8lT+avFh3SVpKdrhDTtfxSJMkGyEGpB7ZVOZcMMHEzAo2mC/6kx
 Pier8olLYZleqFzqxgFtgdcFzihjqSQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-0W8ap7kiOD2uu4J_OWDHBw-1; Wed, 29 Sep 2021 12:24:32 -0400
X-MC-Unique: 0W8ap7kiOD2uu4J_OWDHBw-1
Received: by mail-wr1-f72.google.com with SMTP id
 j15-20020a5d564f000000b00160698bf7e9so802096wrw.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=WPjpZB7ZKa4VEqgp/LOlyRjs9pgY0FjMtIXN/7uEb5A=;
 b=Rd8nqhduyOwnw+59UQDFkQMunamOslXGzDo00r9yhsZ4BBwsHWL6aCuZ7N6YP/pJo3
 FQ0TCxQjhRKeVgLm1ABdGBFSa6C+88M/e7iXx9q0l/T3PPhd4cQ0gWiS26SjuDwBSHcq
 xHH6gVxoFOg+B3pbeJVqtYBW0iga5D+WkL3z7edHnvcgzPfG9pPndTVjLRXABPtPOETW
 OL+0xaI7t9PKaQZ2vEerdFlJ4oWKfjMYOUWoN3+4p55r5jRn9uWStCzMwYG26i2rG0CV
 qNfDEzF8lkEESCvOuLPfdzrPrzqgANp3dQLDFLtXPGJAJX0/8K1VInc3btLMSwBZZGAb
 JYdQ==
X-Gm-Message-State: AOAM531gUW4Fszkf/0EskOcyCQW33twJvsET1TV9vCWAjlQHOsJjwg+L
 z/kmCb4nXNqdRksEYowH6Qjip5PQnjnY1EdkJ971XkU+lb59ZmagcF2JXRsgl20VDkx17rU+bsu
 wsrgohgc3mhFwOmhm99c6zU7i
X-Received: by 2002:a7b:c1d2:: with SMTP id a18mr11253724wmj.28.1632932671040; 
 Wed, 29 Sep 2021 09:24:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzuGBla69X4IO7m6rAp7nL6WSmtL324HkUosRDgfHqwWdWBE791/8ceRT5Q9xIMilR/CHJgA==
X-Received: by 2002:a7b:c1d2:: with SMTP id a18mr11253705wmj.28.1632932670885; 
 Wed, 29 Sep 2021 09:24:30 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id f63sm1734004wma.24.2021.09.29.09.24.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Sep 2021 09:24:30 -0700 (PDT)
Subject: Re: [PATCH v3 04/10] KVM: arm64: vgic-v3: Check ITS region is not
 above the VM IPA size
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-5-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <fc09a2a3-960a-9444-d736-7a6171d710af@redhat.com>
Date: Wed, 29 Sep 2021 18:24:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-5-ricarkol@google.com>
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



On 9/28/21 8:47 PM, Ricardo Koller wrote:
> Verify that the ITS region does not extend beyond the VM-specified IPA
> range (phys_size).
>
>   base + size > phys_size AND base < phys_size
>
> Add the missing check into vgic_its_set_attr() which is called when
> setting the region.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 61728c543eb9..321743b87002 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2710,8 +2710,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  		if (copy_from_user(&addr, uaddr, sizeof(addr)))
>  			return -EFAULT;
>  
> -		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
> -					addr, SZ_64K);
> +		ret = vgic_check_iorange(dev->kvm, &its->vgic_its_base,
> +					 addr, SZ_64K, KVM_VGIC_V3_ITS_SIZE);
>  		if (ret)
>  			return ret;
>  
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
