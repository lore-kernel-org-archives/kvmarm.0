Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962E8BE7C
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691170762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6weKQD+ozqNv4G1UIrG5/+1TB5PpQPCo1dFnfE0/XVA=;
	b=P2xgtiJVhUiJAG5ZhKfuwkNVlEl7hj5aZTWIERghhkpvBeJ0j2Unt92zpV+HoO913ts0WG
	i6pGDslegnMMUKdFaB8GN1SVEm8kkFM0SEgvmqtrpVfePiISD0vVcR0rMimh5vXVin6Xm8
	lPxilSO0o/VLO6D0QxCDYycw799pMUg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-FgleTTbPOmW_7u-o0k7aFw-1; Fri, 04 Aug 2023 13:39:21 -0400
X-MC-Unique: FgleTTbPOmW_7u-o0k7aFw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5226eaba9e9so1494195a12.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 10:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691170760; x=1691775560;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6weKQD+ozqNv4G1UIrG5/+1TB5PpQPCo1dFnfE0/XVA=;
        b=XwgX/pTyL1oKdq7jBlO+s9kX9UaPB4w672fhLRykykDcFCXMeEDn0wHC6Ehfyia7f3
         6Zu8Yr1mfbUqAgo++eOrGt3K4GA5FP0MyPKpA/Pqst7bwyqDikS4ZDxi5axK12n/r0kD
         hAqtNPBzCG7DYzYQjv6cluoNVNgdFIEeqm7mff8+fhgM+6ngZXqCbNB3W8SXmshaEXge
         zcngjHi2x2mDPCAwaqQ1RgL1GRXitwfvOp5iuShuVxJ6dgYJGjZGDzt54drhr4Nbf2FP
         AwhkTOe3a49Oi+OnZwE8M2segcrzLjiyuEPVdOqAVbZlAIQj/cJ2tV1Rrh7WfyJhFub5
         NfNw==
X-Gm-Message-State: AOJu0YzilOdY2MKwOuQMSHbVG0iwyYGCy9BTMx2Cjq3oSuJTLA6omM8U
	bCJGI4Z3UWaaumuhmD3Rje6eBNbH4xVe/IYELcsmBUba84Yt9/wQaak82HKEWqKRvSNon7mu4Lf
	HVzTDNvQpiSvIdDcA
X-Received: by 2002:aa7:dc0a:0:b0:522:79e8:e51b with SMTP id b10-20020aa7dc0a000000b0052279e8e51bmr2125747edu.32.1691170760213;
        Fri, 04 Aug 2023 10:39:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaZEd7/x6GR64ZWOyj478PsDoZMJscVQ1zgnGO6VSfQ5aurf8cwVNnAso80Blhq7blvq+CHg==
X-Received: by 2002:aa7:dc0a:0:b0:522:79e8:e51b with SMTP id b10-20020aa7dc0a000000b0052279e8e51bmr2125736edu.32.1691170759962;
        Fri, 04 Aug 2023 10:39:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id i22-20020a50fc16000000b0051d9de03516sm1516807edr.52.2023.08.04.10.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 10:39:19 -0700 (PDT)
Message-ID: <4d97b4bf-26a4-1222-a1e4-04c3f33a8170@redhat.com>
Date: Fri, 4 Aug 2023 19:39:18 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.5, part #2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, rananta@google.com, tabba@google.com, arnd@arndb.de,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <ZMi/EkSLgRymQZzN@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZMi/EkSLgRymQZzN@thinky-boi>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/23 10:15, Oliver Upton wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.5-2

Pulled (but not pushed yet), thanks.

Paolo

