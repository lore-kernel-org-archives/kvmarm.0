Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83ABAC4332F
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 20:31:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 040F961186
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 20:31:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 040F961186
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3CD4B210;
	Tue,  9 Nov 2021 15:31:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UpfQzp3YWsRZ; Tue,  9 Nov 2021 15:31:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 279C54B212;
	Tue,  9 Nov 2021 15:31:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 215CB4B212
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 15:31:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gvFXlgmV6+6Y for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 15:31:36 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBEC14B210
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 15:31:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636489896;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IAm+Uh+IE22+DUbyhwUyZ8uYJG0ltyMl2q6EpG0f1c0=;
 b=RxDXQxFSyNTecqAdPw5XD7uTRejQxNc8smCxNe2XOs3j86g206f3bqOMGBwCOGyOgQGYVO
 ToZrQ8ouxaKt5lG4EhB/3UoXaqvHcYJ/0ibSZFYKfu472NBgdtinhSj/cxbpMdHdwKWjth
 6oOXG6b+J3aNmdT0qLZGERGScHr7kzs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-A_U_H3LWM1Or-0YjUv20Rg-1; Tue, 09 Nov 2021 15:31:35 -0500
X-MC-Unique: A_U_H3LWM1Or-0YjUv20Rg-1
Received: by mail-wm1-f72.google.com with SMTP id
 k6-20020a7bc306000000b0030d92a6bdc7so202869wmj.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 12:31:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=IAm+Uh+IE22+DUbyhwUyZ8uYJG0ltyMl2q6EpG0f1c0=;
 b=ULmyfmDDU8LsJUSoVQnRkmwNRsKZreSAsPjLyMk8E46Ub4nVme6Srw5dd86rgB4bp1
 TQLdzsKZz3DbpLwSeLOOLBOzCsOh+lzo2iGJ/tcsO24ZGDWKvLBgjSNVX+BU4OBUbzqO
 4tikAqXe2X0eaO9l4gSkmdk+CfGnJznD7yc0d8dQSoTIivNCfNdNa4NcS4pRdN2vp+lv
 vh/W9SLlv9go7X9W3eOkf577yTnzlsrNjumSa1l/wAVd6q7IqXWX8PeU7dyao00m5TZS
 0yGyB9XCm6ki46a5peijG+kTFoajoYYO5uZQs/kFV38Mx+8TCUN68IXuc8SxP7aI85f/
 LOAg==
X-Gm-Message-State: AOAM532EfEcFoPrzcWJmSNZDA1rqmwPe+iOUrmT6CVCuDdY6opLXnTU7
 RkdfTtZyr0BSedp/AYEzjltMsYrd1MjM5ip6UE3NVf3tt7/44ONk7I/sMzdiwaX60FHnbqYGqrr
 1HagS0EQczs6XMpHRKNko1A4K
X-Received: by 2002:adf:f209:: with SMTP id p9mr12748370wro.191.1636489894173; 
 Tue, 09 Nov 2021 12:31:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxe5lKaSE8vCkApCROWS0oJxDYib0FmnYoWXwNee2qMFilSc/uvd/npDY1fjsOp8y96Ktlw2A==
X-Received: by 2002:adf:f209:: with SMTP id p9mr12748342wro.191.1636489893975; 
 Tue, 09 Nov 2021 12:31:33 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id o26sm3494880wmc.17.2021.11.09.12.31.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 12:31:33 -0800 (PST)
Subject: Re: [PATCH v4 11/21] KVM: arm64: Support SDEI_PE_{MASK, UNMASK}
 hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-12-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <e5acdb48-fb16-ab18-4938-c03265c4cfbf@redhat.com>
Date: Tue, 9 Nov 2021 21:31:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-12-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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

Hi Gavin,

On 8/15/21 2:13 AM, Gavin Shan wrote:
> This supports SDEI_PE_{MASK, UNMASK} hypercall. They are used by
> the guest to stop the specific vCPU from receiving SDEI events.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 458695c2394f..3fb33258b494 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -551,6 +551,37 @@ static unsigned long kvm_sdei_hypercall_route(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_mask(struct kvm_vcpu *vcpu,
> +					     bool mask)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	unsigned long ret = SDEI_SUCCESS;
> +
> +	/* Sanity check */
> +	if (!(ksdei && vsdei)) {
> +		ret = SDEI_NOT_SUPPORTED;
> +		goto out;
> +	}
> +
> +	spin_lock(&vsdei->lock);
> +
> +	/* Check the state */
> +	if (mask == vsdei->state.masked) {
> +		ret = SDEI_DENIED;
are you sure? I don't this error documented in 5.1.12?

Besides the spec says:
"
This call can be invoked by the client to mask the PE, whether or not
the PE is already masked."
> +		goto unlock;
> +	}
> +
> +	/* Update the state */
> +	vsdei->state.masked = mask ? 1 : 0;
> +
> +unlock:
> +	spin_unlock(&vsdei->lock);
> +out:
> +	return ret;
In case of success the returned value is SUCESS for UNMASK but not for
MASK (see table in 5.1.12).

By the way I have just noticed there is a more recent of the spec than
the A:

ARM_DEN0054C

You should update the cover letter and [PATCH v4 02/21] KVM: arm64: Add
SDEI virtualization infrastructure commit msg


> +}
> +
>  int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	u32 func = smccc_get_function(vcpu);
> @@ -588,7 +619,11 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  		ret = kvm_sdei_hypercall_route(vcpu);
>  		break;
>  	case SDEI_1_0_FN_SDEI_PE_MASK:
> +		ret = kvm_sdei_hypercall_mask(vcpu, true);
> +		break;
>  	case SDEI_1_0_FN_SDEI_PE_UNMASK:
> +		ret = kvm_sdei_hypercall_mask(vcpu, false);
> +		break;
>  	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
>  	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
>  	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
