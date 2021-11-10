Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6379FC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 13:55:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C31F7610FC
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 13:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C31F7610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A5FE4B2F2;
	Wed, 10 Nov 2021 08:55:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NZJtxDUcF9Eu; Wed, 10 Nov 2021 08:55:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BA8B4B2E4;
	Wed, 10 Nov 2021 08:55:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C73E4B2DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 08:55:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qEd2P3LZM2On for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 08:55:14 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC1654B2B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 08:55:14 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636552514;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yZoEdq1cAEDDdjqXmBuOIaZKRp+qKO19UTUs+iGQkGE=;
 b=gJiR1Vd9nDEFok2mXrifQRSDIiC6uJFYr1STB5BoP74E6LJE4l4HUHoH3/hdKbySAKfj13
 jvn95rNaCm2kcQYNlXWDPZVnmB0XSAxoKjVq6IyGD3zxW5hyh8Oj/7+OkE/B6dKXQrePsp
 c8dQ7L7yuzthdMXH7pAS+wO90yJTsNk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-djDL9XTHP7OhhKrGFaz0pQ-1; Wed, 10 Nov 2021 08:55:13 -0500
X-MC-Unique: djDL9XTHP7OhhKrGFaz0pQ-1
Received: by mail-wr1-f71.google.com with SMTP id
 v17-20020adfedd1000000b0017c5e737b02so428096wro.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 05:55:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=yZoEdq1cAEDDdjqXmBuOIaZKRp+qKO19UTUs+iGQkGE=;
 b=WVrLIKDuca48kK0TupJMn8eqaQ4qt12yehfuYDl3Py7T3om6SkG+E02dn+4FafQ3kb
 3lGxSEbdzT755NZ3qZc/a+omWWBUSUkRMJ+b/Trt8zyCWIV3ETV2xwi/HdqKf9AnpIWN
 8bGUcWh+bNuhELMetuS+A9V7oZpocJEcu/XzwBXpDiykXD88LNqjv1qsieA3ceIBukK8
 ypWP9LLArTVa+KQZw4uabu35G2CTU9hwfYQocSBBmq4zniDA4CFnhJF78RpjRg9YvNSl
 2qWx/Pv/cNxb8400xuS76EfjX7rS8EQjvudws4/3q4CPCKBDhE+KT+vItfpKWcci8fbl
 ysDg==
X-Gm-Message-State: AOAM531n5/Z8v4qcIC/RRVIO6osFPrg3oRgDIPRvtRRZvXlcTrXyU9+F
 o60WtIwD/JHrAhKCCZK6/Fhgf09CU0BDcwk6AXOl70WFE2QNBI9pACzTxywmOpZk8C/ijdkycHH
 km5GZruClTpcnAiKufPARi0PK
X-Received: by 2002:a1c:7c02:: with SMTP id x2mr16615843wmc.165.1636552512442; 
 Wed, 10 Nov 2021 05:55:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzatmcpB1eUzSgZYGxlp7SFChMiFKPXI4SL7EZgVGC7UzmTfba/sBwxlAcTQPukVt/SkxY3jA==
X-Received: by 2002:a1c:7c02:: with SMTP id x2mr16615791wmc.165.1636552512138; 
 Wed, 10 Nov 2021 05:55:12 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id z5sm7918884wmp.26.2021.11.10.05.55.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 05:55:11 -0800 (PST)
Subject: Re: [PATCH v4 20/21] KVM: arm64: Export SDEI capability
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-21-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <90fd5226-0889-6a7c-1586-732015943863@redhat.com>
Date: Wed, 10 Nov 2021 14:55:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-21-gshan@redhat.com>
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
> The SDEI functionality is ready to be exported so far. This adds
> new capability (KVM_CAP_ARM_SDEI) and exports it.

Need to be documented in
kvm/api.rst
as the rest of the API

Eric
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/arm.c     | 3 +++
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 215cdbeb272a..7d9bbc888ae5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -278,6 +278,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
>  		r = system_has_full_ptr_auth();
>  		break;
> +	case KVM_CAP_ARM_SDEI:
> +		r = 1;
> +		break;
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8cf41fd4bf86..2aa748fd89c7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_BINARY_STATS_FD 203
>  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>  #define KVM_CAP_ARM_MTE 205
> +#define KVM_CAP_ARM_SDEI 206
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
