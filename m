Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A96DDC0
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685987229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5iLi3jtMH3pv25shVoS1M19DqH5czvIVbGKZ38f9SgI=;
	b=KfC5Y2851oLNK7EhJEmW9LUmxoz4bRmMVpW2m9dDgqI7MdnrHsa5Z7pHvNK/OUk+fMeN4f
	sCKPdd2ijIG+PEQJyL5ZU7UMG767CWJ3Upa+V4j/Dm8tz6Wrj0kvAPOcIJHl+2PPhGZ/vh
	UikQTNTVWacoJrlp625OIgOFiEQmgK4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-N6eaz_S3ODq13N5Z5mhW-w-1; Mon, 05 Jun 2023 13:47:07 -0400
X-MC-Unique: N6eaz_S3ODq13N5Z5mhW-w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f739a73ba4so7300905e9.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Jun 2023 10:47:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987225; x=1688579225;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5iLi3jtMH3pv25shVoS1M19DqH5czvIVbGKZ38f9SgI=;
        b=XkdX2UdYDILoDVsRAk0WXFn8yKVCnhaqVkP0u3yJEVlsZ9/amnSeFFjDfFTrYfL3fx
         gfFmii6DJFHcLzxEvg67aB7nhrOcMSxb71FH9gY2UpaR5GsJFhoOtQpGAlTFfwdFgjWn
         bIzOl48w6qtHXJmotUzlRQ9hxfbOunlpMo/3/lBH3oyQAKKWmQ2IRxgN8qtxsXbouYc4
         1K+OyVnuxRUBZMGb+TGBCahYKk+07qcCcRqwOWvlpgUj8nnmHwJ4kdoa/QsryAeFf6Vu
         5/j6h5SQ6ixfPSLgjo1zBq2JPUt2PuF3SqN4OH7WJWPnl8NjmM55j1i/yTCEYpFFNsRs
         0r2w==
X-Gm-Message-State: AC+VfDxCgULb6e/tOCxx2kAUGb8rJodWnhLpMlKfOz6LSbyzkrtLMZei
	mTcOOe5uwOs6EBMsx+ssxrQYlGCLBbiPJWBIQ1qHRA5/rEl/YusYeh2Ugf+HkGPxApn7Vs/qhlP
	e5B1/xaO+7B2WFnm+NnBcVpPT
X-Received: by 2002:a7b:c393:0:b0:3f1:bb10:c865 with SMTP id s19-20020a7bc393000000b003f1bb10c865mr7533762wmj.38.1685987225217;
        Mon, 05 Jun 2023 10:47:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6B0Cs6zzo6oIgwlLySYoIkjk+orU3QvOqFyuJdQOvJSP4BCdq/9MS6Cxk79w18ygpPeTKjZg==
X-Received: by 2002:a7b:c393:0:b0:3f1:bb10:c865 with SMTP id s19-20020a7bc393000000b003f1bb10c865mr7533750wmj.38.1685987224927;
        Mon, 05 Jun 2023 10:47:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id o7-20020a05600c4fc700b003f71ad792f2sm20825874wmq.1.2023.06.05.10.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 10:47:04 -0700 (PDT)
Message-ID: <80471a31-8b91-de37-f368-b50bdb6eb7c0@redhat.com>
Date: Mon, 5 Jun 2023 19:47:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 04/59] arm64: Add missing ERXMISCx_EL1 encodings
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <20230515173103.1017669-5-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-5-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 5/15/23 19:30, Marc Zyngier wrote:
> We only describe ERXMISC{0,1}_EL1. Add ERXMISC{2,3}_EL1 for a good measure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 071cc8545fbe..71305f7425db 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -239,6 +239,8 @@
>  #define SYS_ERXADDR_EL1			sys_reg(3, 0, 5, 4, 3)
>  #define SYS_ERXMISC0_EL1		sys_reg(3, 0, 5, 5, 0)
>  #define SYS_ERXMISC1_EL1		sys_reg(3, 0, 5, 5, 1)
> +#define SYS_ERXMISC2_EL1		sys_reg(3, 0, 5, 5, 2)
> +#define SYS_ERXMISC3_EL1		sys_reg(3, 0, 5, 5, 3)

>  #define SYS_TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
>  #define SYS_TFSRE0_EL1			sys_reg(3, 0, 5, 6, 1)
>  
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

