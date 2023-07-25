Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDB61F173
	for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690299192;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M/jYtmMtGkG0hmXFdCqZpADpJ+V9me7HzfGXEew3QqE=;
	b=M3SNgymsD+bCIQqVhKTGJLQLDNxj5e7b2gy9VjZknkkikGhYYfm5qePFnCRGh8sH+8vzKB
	hqKfv8twNoNlAmT9nhX1Oqi/1eV7jlnWWBk1JoiKwEVC81FCVeMYMEPXV56XgKCZOW9LFq
	+weSR4BVeNHzdkx7nfrwIV3bLOgJ9Rk=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-Z_s5k__COnyE9WxKqKYCOA-1; Tue, 25 Jul 2023 11:33:10 -0400
X-MC-Unique: Z_s5k__COnyE9WxKqKYCOA-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6bb1a153d8fso6983112a34.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 08:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690299190; x=1690903990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/jYtmMtGkG0hmXFdCqZpADpJ+V9me7HzfGXEew3QqE=;
        b=k+nPLtA36k9gz0ntIDXfsFr7VNOSX/l+AaCcxVsoEy6IymCsU7M+BQqJVlfhYdwnf2
         jfEwzlzEwxUBrS5T0OEvJtoQUp7zeRy0PJCM2/ZWHFYojeR6xmBaTq24wV35BrWXe7Nc
         ZNKRrEJCFCo3mODG7/jvcIlWUXUUUsZGsfuGfz4gpufrtqBpBiiCwXxbO8hMQGpGs7Nq
         lk/spCwNDub7761C4dz23ucRfLu7fq90RTg9FhQ1Mq0OzK/vxytWkSJLEj4gMmZ6rgcq
         L9x3Wbz2JnAAF2jQmRx5IY8yAEo/baHpln5B5pJWhI5L2vYqzhR1L3x+gadPm9S06IhE
         ytfg==
X-Gm-Message-State: ABy/qLbT98VLLugm3v2XPQqNPNuYkAIGERKy8gNhMQaavTks1R8cSGa4
	GzFYZO1I9lq/ykzv76NK1/t3n+zk2q0q+fk78qdw7+MpkZVg3lwf1Bvo0YSfNFuAshl86FZxcw/
	wqbvVuY1yLZvlD9e7
X-Received: by 2002:a05:6830:19ea:b0:6b9:70c9:e1c8 with SMTP id p42-20020a05683019ea00b006b970c9e1c8mr9491941otp.5.1690299190307;
        Tue, 25 Jul 2023 08:33:10 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGwfD9i4saEq5guvbIWPCxEwI68/tV8TiZIrRY5wvsOxzfEZyHvgM2q/hdbebuHSMMnAyAXgQ==
X-Received: by 2002:a05:6830:19ea:b0:6b9:70c9:e1c8 with SMTP id p42-20020a05683019ea00b006b970c9e1c8mr9491923otp.5.1690299190029;
        Tue, 25 Jul 2023 08:33:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id d28-20020a05620a137c00b0076c44db9b08sm1407701qkl.113.2023.07.25.08.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 08:33:09 -0700 (PDT)
Message-ID: <6a0fc302-e78f-1a17-5b3c-421771b90b73@redhat.com>
Date: Tue, 25 Jul 2023 17:33:05 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] arm64: Define name for the original
 RES1 bit but now functinal bit
To: Shaoqin Huang <shahuang@redhat.com>, andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
References: <20230724073949.1297331-1-shahuang@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230724073949.1297331-1-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 7/24/23 09:39, Shaoqin Huang wrote:
> According the talk[1], because the architecture get updated, what used to be a
> RES1 bit becomes a functinal bit. So we can define the name for these bits, this
> also increase the readability.
>
> [1] lore.kernel.org/ZLZQ6r4-9mVdg4Ry@monolith.localdoman
>
> v1:
> https://lore.kernel.org/all/20230719031926.752931-1-shahuang@redhat.com/
> Thanks, Eric for the suggestions:
> - Rephrase the commit title in patch 1.
> - Use the _BITULL().
> - Delete the SCTLR_EL1_RES1 and unwind its definition into
> INIT_SCTLR_EL1_MMU_OFF.
>
> Shaoqin Huang (2):
>   arm64: Use _BITULL() to define SCTLR_EL1 bit fields
>   arm64: Define name for these bits used in SCTLR_EL1

for the series
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

>
>  lib/arm64/asm/sysreg.h | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
>

