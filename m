Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E9B7E
	for <kvmarm@lists.linux.dev>; Sun, 22 Jan 2023 08:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674377520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fzh657eBEm//fFuVntHGMr/T1VXg/fCXtLpm1U/4LeE=;
	b=Y1zm91o52jczGEOLBtRmvPeTMMFB3A6F81YAxH2EzB2qasVL8MwSHhrWQDpx/ozeZJRICT
	67wXuQFniC1SLqshtqKxhAzv+8GigUJG5Q+iue7vQkXkpXkz8S4FTEzIGLYh9gbgs23a3T
	+6syhDgQdaLNsl5PcGMKPGQUMqMNOSo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-400-QCTsxWI9P2SfSbbr_YisfQ-1; Sun, 22 Jan 2023 03:51:59 -0500
X-MC-Unique: QCTsxWI9P2SfSbbr_YisfQ-1
Received: by mail-ej1-f71.google.com with SMTP id hr22-20020a1709073f9600b0086ffb73ac1cso6082267ejc.23
        for <kvmarm@lists.linux.dev>; Sun, 22 Jan 2023 00:51:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fzh657eBEm//fFuVntHGMr/T1VXg/fCXtLpm1U/4LeE=;
        b=gdngjlasb8+u2m5NAnobpLTxINpsC+Hrldpq7VSWMZSYTwWAtS74LCdLjiAlqRW4lq
         smVHFrywVgEiv7toEe9bMQ1fM0xICR/LDx2cDcxfaqhoTCJO1ShfCAkaamH4lGPtIcPc
         AlPPF38n1dBFFXJ6Xd17YtVUTMz3uUt6A//DrP2xxFFmAvnYDFr0i88Z39/Ydv79Qrjq
         c6S4KR0GNyfabWS6AVpWz8VB0XdAaPZ5/QiShrV4KXgw9UsYcboItRFHBeuImFurIqQp
         wdubwPbH1UzXvlqhAyYqleodbIutm9CjnXQ+VZNdLzYYr2IHztyHb3GtWrx6y42hknFD
         U6SQ==
X-Gm-Message-State: AFqh2kruGQDh+ftCpcFsMYlxtdnoVcxDAT3p5y3OzLAX5Q6pW3oJJlPo
	ug5+EB2/D/lyVrAX89og1Dnz/WgonyCtY4buPZRVYqMAVt0kgia9qI3i35HWlvU32gkhuLG3jqN
	Zo0QQvwv60uUXU0vF
X-Received: by 2002:a17:906:eb8e:b0:871:6b9d:dbc with SMTP id mh14-20020a170906eb8e00b008716b9d0dbcmr21834821ejb.21.1674377518406;
        Sun, 22 Jan 2023 00:51:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv6j1z/NsGELcDclZ9c0tzI8/Ywun4iDihWjYbScOETod/jzDf15vN9UEqbc3cuVk8YHfOYPQ==
X-Received: by 2002:a17:906:eb8e:b0:871:6b9d:dbc with SMTP id mh14-20020a170906eb8e00b008716b9d0dbcmr21834801ejb.21.1674377518112;
        Sun, 22 Jan 2023 00:51:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id c23-20020a170906155700b0084c7f96d023sm20826541ejd.147.2023.01.22.00.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 00:51:57 -0800 (PST)
Message-ID: <a292c1db-2592-ed4f-ed98-f5998746925a@redhat.com>
Date: Sun, 22 Jan 2023 09:51:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.2, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck
 <cohuck@redhat.com>, Oliver Upton <oliver.upton@linux.dev>,
 Shanker Donthineni <sdonthineni@nvidia.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20230121110837.3216901-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230121110837.3216901-1-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/23 12:08, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's a small set of important 6.2 fixes for KVM/arm64. We have a MTE
> fix after the recent changes that went into -rc1, as well as a GICv4.1
> fix for a pretty bad race that results in a dead host (a stable
> candidate).
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit de535c0234dd2dbd9c790790f2ca1c4ec8a52d2b:
> 
>    Merge branch kvm-arm64/MAINTAINERS into kvmarm-master/fixes (2023-01-05 15:26:53 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.2-2

Pulled, thanks.

Paolo

> 
> for you to fetch changes up to ef3691683d7bfd0a2acf48812e4ffe894f10bfa8:
> 
>    KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation (2023-01-21 11:02:19 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.2, take #2
> 
> - Pass the correct address to mte_clear_page_tags() on initialising
>    a tagged page
> 
> - Plug a race against a GICv4.1 doorbell interrupt while saving
>    the vgic-v3 pending state.
> 
> ----------------------------------------------------------------
> Catalin Marinas (1):
>        KVM: arm64: Pass the actual page address to mte_clear_page_tags()
> 
> Marc Zyngier (1):
>        KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation
> 
>   arch/arm64/kvm/guest.c        |  2 +-
>   arch/arm64/kvm/vgic/vgic-v3.c | 25 +++++++++++--------------
>   arch/arm64/kvm/vgic/vgic-v4.c |  8 ++++++--
>   arch/arm64/kvm/vgic/vgic.h    |  1 +
>   4 files changed, 19 insertions(+), 17 deletions(-)

