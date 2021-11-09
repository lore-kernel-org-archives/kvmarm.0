Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78451C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 20:37:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE9CD611AF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 20:37:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE9CD611AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ED7D4B0CE;
	Tue,  9 Nov 2021 15:37:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yqVBWaKtwE42; Tue,  9 Nov 2021 15:37:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C3594B210;
	Tue,  9 Nov 2021 15:37:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F35C14B1AA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 15:37:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p7S8WL3MEl34 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 15:37:51 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 619DB4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 15:37:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636490271;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gojg4VWkO45Ypb84clQ7fAq1QopxKBZsDHgCryO6+cM=;
 b=Cw+VHWeSiqV3SzFHuMJJmFc0nHRJt9kE5u/AgLMGMNCuuWG9j3Ij5zTAb6LYtZ5L9ZMN+T
 1TLkggIWOCVE8CKVKrl5jpnse55jP4bqXBEVBR7g/LnOPke/xML1i9U3+4NsJkj73SyCbc
 bzQpQS0JiA+6kb6qFKBFANgVMrlq5rQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-NomSxMIEPvah2eLo9fw_pA-1; Tue, 09 Nov 2021 15:37:48 -0500
X-MC-Unique: NomSxMIEPvah2eLo9fw_pA-1
Received: by mail-wm1-f69.google.com with SMTP id
 z138-20020a1c7e90000000b003319c5f9164so1936071wmc.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 12:37:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=gojg4VWkO45Ypb84clQ7fAq1QopxKBZsDHgCryO6+cM=;
 b=VXceAGAnG3P45b7mXcncxXhWMKIxU1UDNSpzMVSqWkuVA0lK6dbnlESj4JoX4aC7eA
 iIG5n+N0VO4YXYxUEX3YI+j3V+pvmnS6oQUSYlvjBuoYcMODLvYTZFBdcLwtGhVRjcHg
 RokGV8dMAoBJJWDjogoXW1tA+AQOoWI3kCONTn0NdHUw58+qqh2+xCrsRdO1cjR53VPm
 iOA41e2go2ZnxBREGEvDjFfB/j/1CL2XJJ4wqhQhGVWsf2EkzYbqFr0YvTM8h0eWdsp+
 whCryOEhhX3bfzmENwxuSXTXWkDF2G8TBunu2hxa36iHWLkp4zkIFvbntWtcEdnnjLca
 gCIg==
X-Gm-Message-State: AOAM531vPTA5LUBHfuAhtDFbtmAJ5Ic+6VdR2I9wKYY3I1woBl+tpYBC
 ObZ2ZJIfXz8K16yfkbFi8j9tr87YYgR1LaPdHqmqZkdpzVfq5KYqdFYUPEhfhltllpQxWLJjeJH
 PdEUTexYDpTUIerACHnE1FN7R
X-Received: by 2002:a7b:c76e:: with SMTP id x14mr10545302wmk.27.1636490266894; 
 Tue, 09 Nov 2021 12:37:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzo6H+ZdYALE/GrXI74xIQHssW56Lq2WYRl3ECCaurkx5wEG9IUIS+rpCPn8YUhWjFj3YDoZA==
X-Received: by 2002:a7b:c76e:: with SMTP id x14mr10545277wmk.27.1636490266685; 
 Tue, 09 Nov 2021 12:37:46 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id y12sm20922993wrn.73.2021.11.09.12.37.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 12:37:46 -0800 (PST)
Subject: Re: [PATCH v4 12/21] KVM: arm64: Support SDEI_{PRIVATE, SHARED}_RESET
 hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-13-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <a4b91fa5-12b0-afeb-4449-c2acb59e8cd7@redhat.com>
Date: Tue, 9 Nov 2021 21:37:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-13-gshan@redhat.com>
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



On 8/15/21 2:13 AM, Gavin Shan wrote:
> This supports SDEI_{PRIVATE, SHARED}_RESET. They are used by the
> guest to purge the private or shared SDEI events, which are registered
to reset all private SDEI event registrations of the calling PE (resp.
PRIVATE or SHARED)
> previously.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 3fb33258b494..62efee2b67b8 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -582,6 +582,29 @@ static unsigned long kvm_sdei_hypercall_mask(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_reset(struct kvm_vcpu *vcpu,
> +					      bool private)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	unsigned int mask = private ? (1 << SDEI_EVENT_TYPE_PRIVATE) :
> +				      (1 << SDEI_EVENT_TYPE_SHARED);
> +	unsigned long ret = SDEI_SUCCESS;
> +
> +	/* Sanity check */
> +	if (!(ksdei && vsdei)) {
> +		ret = SDEI_NOT_SUPPORTED;
> +		goto out;
> +	}
> +
> +	spin_lock(&ksdei->lock);
> +	kvm_sdei_remove_kvm_events(kvm, mask, false);
With kvm_sdei_remove_kvm_events() implementation, why do you make sure
that events which have a running handler get unregistered once the
handler completes? I just see the refcount check that prevents the "KVM
event object" from being removed.
> +	spin_unlock(&ksdei->lock);
> +out:
> +	return ret;
> +}
> +
>  int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	u32 func = smccc_get_function(vcpu);
> @@ -626,8 +649,14 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  		break;
>  	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
>  	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
> +		ret = SDEI_NOT_SUPPORTED;
> +		break;
>  	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
> +		ret = kvm_sdei_hypercall_reset(vcpu, true);
> +		break;
>  	case SDEI_1_0_FN_SDEI_SHARED_RESET:
> +		ret = kvm_sdei_hypercall_reset(vcpu, false);
> +		break;
>  	default:
>  		ret = SDEI_NOT_SUPPORTED;
>  	}
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
