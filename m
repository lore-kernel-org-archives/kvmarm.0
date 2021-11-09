Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996BDC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 15:37:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 143CB61053
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 15:37:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 143CB61053
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58FC74B219;
	Tue,  9 Nov 2021 10:37:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SrcKGFKFrnVk; Tue,  9 Nov 2021 10:37:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B95894B245;
	Tue,  9 Nov 2021 10:37:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE714B232
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 10:26:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4SJBD9aSAgwG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 10:26:05 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 334184B229
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 10:26:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636471565;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Wxou4MKPQ1jK4eND4O3g/qSLs6HMqmw3NMGLlftk3PU=;
 b=BAh0maAJxZTQ0hdv01LopCNwbQbmr3XkBzeplefl9BgAX74DDL0PmtdBsfCbC6VZrLC/i8
 mQzGNgPz4O5dbKgNx/nILCVp6F95S4oieF1ieOQPvWqE7Pn3/1bqwiAlQo3sDFHMYtiCY7
 UTtubtYyIsGIUIKn8AZw4GPExV27U10=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-4JpTGqAFOPqeGXVfwWX0jA-1; Tue, 09 Nov 2021 10:26:03 -0500
X-MC-Unique: 4JpTGqAFOPqeGXVfwWX0jA-1
Received: by mail-wm1-f71.google.com with SMTP id
 69-20020a1c0148000000b0033214e5b021so7897473wmb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 07:26:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Wxou4MKPQ1jK4eND4O3g/qSLs6HMqmw3NMGLlftk3PU=;
 b=8MaVmcR0bjQn183H7MpcxhAzq2hJWBp8wzTzH1tVfJvhQl3Jq6aIEfuQe6u3UIWyLs
 OS2NBd/gFSiDI0dtTlxudfC58fkuwZNk2BB1ZwPTiiBpond9GdN4dnM+sSjLOeXjMtFK
 jtDf22Bl2GTVxs9pzPfKWgngn4+UL3d16w1aarmg0DFDcBG0HMRhsjyBHMaxj2N6mfv5
 iYOj/G99KemmCOfqykZ4cC9bWW3yRqRwL8uHJRa3uJmCkTbdVAm4QI9rGI/XLf7rdzid
 hr8payk2yOzUQIisvdQz1G2F/zg6tB0dnX3INLfkWEgfFDya5vO3cjRYYEV0s3pPzluO
 UynA==
X-Gm-Message-State: AOAM532v57r9dKQ/m2bUnjbwGT9I9PcCGajYyvtfHdngUFrCXpw8sUDq
 rDKvmS982uvtAhVyZ1yzD6EUG83cU6+6Rs5u9R1OkuyUPjP/kD3eH6gbmuAgrrCYk17njw7RjjG
 4iZtDITf7jkBZpHOY0dZ9a4AX
X-Received: by 2002:a7b:c4c2:: with SMTP id g2mr7949012wmk.195.1636471562568; 
 Tue, 09 Nov 2021 07:26:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBnpOsut7rKZlaSBPduXJ5xAffRhNOu1HUeYRQRdK/um4HGi+o+P1Cz2Qt1sVLYNWJ5qGPUA==
X-Received: by 2002:a7b:c4c2:: with SMTP id g2mr7948982wmk.195.1636471562339; 
 Tue, 09 Nov 2021 07:26:02 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id u6sm2826590wmc.29.2021.11.09.07.26.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 07:26:01 -0800 (PST)
Subject: Re: [PATCH v4 01/21] KVM: arm64: Introduce template for inline
 functions
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-2-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <5112b3ba-d038-f622-c67f-e53695cbef37@redhat.com>
Date: Tue, 9 Nov 2021 16:26:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-2-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Mailman-Approved-At: Tue, 09 Nov 2021 10:37:47 -0500
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
> The inline functions used to get the SMCCC parameters have same
> layout. It means these functions can be presented by a template,
> to make the code simplified. Besides, this adds more similar inline
> functions like smccc_get_arg{4,5,6,7,8}() to visit more SMCCC arguments,
> which are needed by SDEI virtualization support.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  include/kvm/arm_hypercalls.h | 34 +++++++++++++++-------------------
>  1 file changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 0e2509d27910..ebecb6c68254 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -6,27 +6,21 @@
>  
>  #include <asm/kvm_emulate.h>
>  
> -int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> -
> -static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> -{
> -	return vcpu_get_reg(vcpu, 0);
> +#define SMCCC_DECLARE_GET_FUNC(type, name, reg)			\
> +static inline type smccc_get_##name(struct kvm_vcpu *vcpu)	\
> +{								\
> +	return vcpu_get_reg(vcpu, reg);				\
>  }
>  
> -static inline unsigned long smccc_get_arg1(struct kvm_vcpu *vcpu)
> -{
> -	return vcpu_get_reg(vcpu, 1);
> -}
> -
> -static inline unsigned long smccc_get_arg2(struct kvm_vcpu *vcpu)
> -{
> -	return vcpu_get_reg(vcpu, 2);
> -}
> -
> -static inline unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
> -{
> -	return vcpu_get_reg(vcpu, 3);
> -}
> +SMCCC_DECLARE_GET_FUNC(u32,           function, 0)
> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg1,     1)
> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg2,     2)
> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg3,     3)
> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg4,     4)
> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg5,     5)
> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg6,     6)
> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg7,     7)
> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg8,     8)
I think I would keep smccc_get_function() and add macros to get the
64-bit args. SMCCC_DECLARE_GET_FUNC is an odd macro name for a function
fetching an arg. I would suggest:

> +#define SMCCC_DECLARE_GET_ARG(reg)			\
> +static inline unsigned long smccc_get_arg##reg(struct kvm_vcpu *vcpu)	\
> +{								\
> +	return vcpu_get_reg(vcpu, reg);				\
>  }
>  
>  static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>  				    unsigned long a0,
> @@ -40,4 +34,6 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>  	vcpu_set_reg(vcpu, 3, a3);
>  }
>  
> +int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> +
spurious change?
>  #endif
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
