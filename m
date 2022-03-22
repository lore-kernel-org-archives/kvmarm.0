Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70B6C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 19:43:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 276E749F16;
	Tue, 22 Mar 2022 15:43:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 407Q+NQRO6VN; Tue, 22 Mar 2022 15:43:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 000AD49F18;
	Tue, 22 Mar 2022 15:43:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A964A49EDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 15:43:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eRqUn1DxXB3H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 15:42:59 -0400 (EDT)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3A1F49AF7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 15:42:59 -0400 (EDT)
Received: by mail-io1-f46.google.com with SMTP id k25so21387113iok.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 12:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kQfCViyvUcBGR9en7E9fM3gdNj6iSkExb9yK7Ef7nEA=;
 b=ftdIEVwRJDcINszz+pr2yi6zQaeeWx0v8sERiwy/J65J8gwYYBKlP0vwlFd4V5ivIc
 F5jbq0UkSMW398aYNBgLFHwNilRbIz06KMjmGGEPppjE1liHeZ8YIz4abvK4/IDPqSqx
 TuO8izyi0Uhf17++AoAFq/Uh2DkSuANy5cwZKf8MpMa8fvBCheNivveIFMwg4uu4AhTh
 d/Pn3MIRX6V0KKejM0KnbPVp95/pKJj/XVE1gvqMp1/r9fbwit46uZDi+g0DPNxaKWW4
 1NK6nhBEuWFlyN3/xcp/BfInF/UvkyZNzsupHUuK0LjCRMdbPg0PdOa1rJdrgWeNRVpp
 NERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kQfCViyvUcBGR9en7E9fM3gdNj6iSkExb9yK7Ef7nEA=;
 b=jCJqLr7coM21tLmJMj1YR7FCHkPGIKh0W7pLf903uI7gE3Iixlbm5zC4KVSzquXWaE
 fWqpP7TnwSeaKqU4WxrAXRDAnaG0tkhQv5Bc6Uoi+Uk7OEBRMHwF1IqVL5Q+uu26UEpb
 //AZreiCwoZgeJXDfD1LmHuEIj6Wp/8otqUh3bFr0kmA59WxmcXeaExpVphMomzwSS61
 8BvYi+oND6i+t/vNawKqAUlpD5i2D2r8WIC91R+hp3bfNPDmj9XVL396wX1r+qi9Ol8k
 lQHF/3zTBeQNYgR+GSTKWb1a3YF+VbW1fIWyQsi/o+Hx/8gI0kuWt9Sp9IE2TRRU2kn8
 /D7w==
X-Gm-Message-State: AOAM53360Lzh8t6lHBGZXpswup//kZHK1M4xD9Q71DZqAxB6tzuMeHw5
 b4jcCRC1EE1qKKhcDlAEVKcdTA==
X-Google-Smtp-Source: ABdhPJzbEmmA31pMa7o1H5I0WOaV1TzDfua9AcuuxEy8N/e12lQalCiP31/gC0kyxSNbn9HRDMpncQ==
X-Received: by 2002:a05:6638:1694:b0:31a:594:f4c7 with SMTP id
 f20-20020a056638169400b0031a0594f4c7mr13259160jat.139.1647978178814; 
 Tue, 22 Mar 2022 12:42:58 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 i12-20020a926d0c000000b002c3fa6cf756sm11169508ilc.25.2022.03.22.12.42.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 12:42:58 -0700 (PDT)
Date: Tue, 22 Mar 2022 19:42:54 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 01/22] KVM: arm64: Introduce template for inline
 functions
Message-ID: <YjomvjFNjGADmu6l@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220322080710.51727-2-gshan@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 22, 2022 at 04:06:49PM +0800, Gavin Shan wrote:
> The inline functions used to get the SMCCC parameters have same
> layout. It means these functions can be presented by an unified
> template, to make the code simplified. Besides, this adds more
> similar inline functions like smccc_get_arg{4,5,6,7,8}() to get
> more SMCCC arguments, which are needed by SDEI virtualization
> support.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  include/kvm/arm_hypercalls.h | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 0e2509d27910..d5144c852fe4 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -13,20 +13,20 @@ static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
>  	return vcpu_get_reg(vcpu, 0);
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
> +#define SMCCC_DECLARE_GET_ARG(reg)					\
> +static inline unsigned long smccc_get_arg##reg(struct kvm_vcpu *vcpu)	\
> +{									\
> +	return vcpu_get_reg(vcpu, reg);					\
>  }
>  
> -static inline unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
> -{
> -	return vcpu_get_reg(vcpu, 3);
> -}
> +SMCCC_DECLARE_GET_ARG(1)
> +SMCCC_DECLARE_GET_ARG(2)
> +SMCCC_DECLARE_GET_ARG(3)
> +SMCCC_DECLARE_GET_ARG(4)
> +SMCCC_DECLARE_GET_ARG(5)
> +SMCCC_DECLARE_GET_ARG(6)
> +SMCCC_DECLARE_GET_ARG(7)
> +SMCCC_DECLARE_GET_ARG(8)

Hmm. What if we specify a single inline function where the caller passes
the arg # as a parameter? We really just want to abstract away the
off-by-one difference between GP registers and SMCCC arguments.

Macros generally make me uneasy for template functions, but I may be in
the vocal minority on this topic :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
