Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4768BE2
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 12:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690807430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJVOiifSKqg3nLbgg7S3p9Y1lh8OIZxrU3xoQ6MEvUQ=;
	b=AGmQmlVh1E93n8EloUMKb2XsG6zREYvLWxhwt6AjcyYQ3rYLD1jOauU7UR96D5p+rnNKqy
	5MgtTMHoon9/qPtjkA6fS6pxT3xLdUsiUCaAgA/e0mptqcGsYlJ0mzkQc/1Ghd5w0JRLbj
	hSCHmlT2XLJvcIZzmkfF/sg5D//yFH8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-MwQL3gfuNmujpYtcnmiAwg-1; Mon, 31 Jul 2023 08:43:49 -0400
X-MC-Unique: MwQL3gfuNmujpYtcnmiAwg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-51dcec9425bso751653a12.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 05:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690807428; x=1691412228;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EJVOiifSKqg3nLbgg7S3p9Y1lh8OIZxrU3xoQ6MEvUQ=;
        b=lZHiVwCma8L+JF5KGCyyAaMjdApjZqXExm+mF+GHgRiYmCd6oL9aTPkGNzbc8Wynkb
         2JR3h2/irU/i4HxNBB7uGzKOZDVPyHqzVFT4cBQrz/7lBI4+EYrdqS9ukcGU3JGyOgHJ
         5z7E44e4F5d3PlIPi+uC2oDWS4lo3tzZ51uGJK6LM+/+eFLA506c7TEbE+2aCMp1stYI
         6dEzuur0mlMZGLquxXO8XIEDx9mlQcwfmr0q5wVG6em2s22e03S/Q1/EFG6kYq+mKILS
         LqCgQyKIjsOhMb1HHupkYY1aupnFqdOBQGK7bOTk9Z4y42ghGLFBsRCPOADaUtGS674M
         IYJw==
X-Gm-Message-State: ABy/qLZ+F7dJgmdkzDePr/eZlXfZK8vNJjRCBmYFY0jYI2rB6S+lESGn
	4srWO8+JUlNQkNnZkCII4Oyh6SrnKtBfm1zU6Jvca9mbiroRGGldpyIoI+ni0y9MOwMWCj7/Lte
	oCFOqaFwsmg7CvesW
X-Received: by 2002:a05:6a00:4397:b0:677:bb4c:c321 with SMTP id bt23-20020a056a00439700b00677bb4cc321mr8220450pfb.0.1690807428339;
        Mon, 31 Jul 2023 05:43:48 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGLdC+KxPsvQvv44Qq7TtHjMJ6Pbcb5BXPBbR5vT3tQqosU/nNGKSPgWx015P2wu/g0nE7nDQ==
X-Received: by 2002:a05:6a00:4397:b0:677:bb4c:c321 with SMTP id bt23-20020a056a00439700b00677bb4cc321mr8220432pfb.0.1690807428013;
        Mon, 31 Jul 2023 05:43:48 -0700 (PDT)
Received: from [10.72.12.26] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c12-20020aa781cc000000b00679d3fb2f92sm7509701pfn.154.2023.07.31.05.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 05:43:47 -0700 (PDT)
Message-ID: <84e864b1-9b50-af18-1d1c-1021adb6cb92@redhat.com>
Date: Mon, 31 Jul 2023 20:43:43 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v1] KVM: arm64: Remove redundant kvm_set_pfn_accessed()
 from user_mem_abort()
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com
References: <20230731114110.2673451-1-tabba@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230731114110.2673451-1-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/31/23 19:40, Fuad Tabba wrote:
> The function user_mem_abort() calls kvm_release_pfn_clean(),
> which eventually calls kvm_set_page_accessed(). Therefore, remove
> the redundant call to kvm_set_pfn_accessed().
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> 
> ---
> 
> Based on 6.5-rc4
> 
> The call to kvm_set_pfn_accessed() was originally introduced in
> 35307b9a5f7e ("arm/arm64: KVM: Implement Stage-2 page aging"). At
> the time, kvm_release_pfn_clean() did not set accessed (neither
> directly nor indirectly).
> 
>   arch/arm64/kvm/mmu.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d3b4feed460c..137b775d238b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1541,7 +1541,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   
>   out_unlock:
>   	read_unlock(&kvm->mmu_lock);
> -	kvm_set_pfn_accessed(pfn);
>   	kvm_release_pfn_clean(pfn);
>   	return ret != -EAGAIN ? ret : 0;
>   }
> 
> base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4

-- 
Shaoqin

