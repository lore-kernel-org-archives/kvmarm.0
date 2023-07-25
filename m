Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201F13C23
	for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 16:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690303504;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wvn6KHlfQDuo3hpCXTqrMNakv6fvts1e1JRxx8Q4D20=;
	b=U0nMqayUQesdVuI3k9w24kwrsIjIBWZuklLprJE0Km0DT+4SD553AyXP7YT/gOVlI/Qjy1
	BtvjonaTRpdGjQ14FStg5QN+CCxo1CkMJcqo7RuVcj51/V0Ak8v9RyzeEMuJU1hUAY/fkH
	TjBJyO5BLQC9rYGqIMayNxCqqxFenZg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-us19QqxAOgq6Likbx8fpGw-1; Tue, 25 Jul 2023 12:45:01 -0400
X-MC-Unique: us19QqxAOgq6Likbx8fpGw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4fbcdca9082so4914503e87.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 09:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690303500; x=1690908300;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wvn6KHlfQDuo3hpCXTqrMNakv6fvts1e1JRxx8Q4D20=;
        b=KPFc3Trgyes3376YzE7dUgo+eXu3gE9XY24NwzdNwV7DclsnrbXjapL2SqJwwLow2L
         D7YMHTwIXyMyn0Bn2cofvIAMO9S2vFZauz/uSa0lYt8GnOgbKtkjrvcKw2ZzNcR9BbYr
         JI9gEMySCuIOY5Mh2HGkFPAvbuVHF1mvjl7/rsKIEDJm7lBZnRtSUikA+8LZXC4y6E6i
         fpW16Uu2f0mWGTF+1m5EWM6bAFP4/5eYhFSPmXsXhGkAEaTWxuTBckirU1x4wkzzcBjB
         0kkE72pkNQCaTLcALFDNBmRc9Qz+BZ8cpoHjZjnMEGYnkquGLRwpIiwOSjaZKIXXwkSx
         D37g==
X-Gm-Message-State: ABy/qLZKZTFxJv2DrM6DXStzcZ/vn9cUBkgXm6AYSE6Z/fkBD9u0z9n4
	JMiS5lCtZ9uLGOSrO0Isj3dWFuWAsvpWMsHNFXKDTmHIndtfuTl6O2QkvBBtFOs/7rtwrhrMPno
	f+VZv/2BJAViUy/Et
X-Received: by 2002:ac2:5239:0:b0:4fc:6e21:ff50 with SMTP id i25-20020ac25239000000b004fc6e21ff50mr7111888lfl.55.1690303500073;
        Tue, 25 Jul 2023 09:45:00 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEby/vcaKSjGkDJ1lyXqDzRuHrqzwbjpqloRTr9TiHpIvTT/1kpST/4Zd3MSPrUL8HU9FBzgQ==
X-Received: by 2002:ac2:5239:0:b0:4fc:6e21:ff50 with SMTP id i25-20020ac25239000000b004fc6e21ff50mr7111854lfl.55.1690303499680;
        Tue, 25 Jul 2023 09:44:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id t2-20020adfeb82000000b0031759e6b43fsm9082752wrn.39.2023.07.25.09.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 09:44:59 -0700 (PDT)
Message-ID: <b8189658-4fa9-d3b9-8d24-bf04781ad0cd@redhat.com>
Date: Tue, 25 Jul 2023 18:44:57 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 17/27] KVM: arm64: nv: Expose FEAT_EVT to nested guests
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-18-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-18-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/12/23 16:58, Marc Zyngier wrote:
> Now that we properly implement FEAT_EVT (as we correctly forward
> traps), expose it to guests.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 315354d27978..7f80f385d9e8 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -124,8 +124,7 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>  		break;
>  
>  	case SYS_ID_AA64MMFR2_EL1:
> -		val &= ~(NV_FTR(MMFR2, EVT)	|
> -			 NV_FTR(MMFR2, BBM)	|
> +		val &= ~(NV_FTR(MMFR2, BBM)	|
>  			 NV_FTR(MMFR2, TTL)	|
>  			 GENMASK_ULL(47, 44)	|
>  			 NV_FTR(MMFR2, ST)	|

