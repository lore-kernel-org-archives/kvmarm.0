Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C9E648
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 06:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680589402;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APNrYYwPBAuPO+GWb7+dbYKyxbTjRyfGmu8CPqknU3k=;
	b=DOGUrwFhCMSwi0eYWo8dNecfyfNHOOyMoTdW7S/hJHXTZrsSiGm3CqLufCepGvh/GzZ5qI
	ylC/SA2KkUy59zyabnLMEr9a2ZYzogAQdz6YUrdLq2ZTEd8PyGkZdaZKH2qGXIkueKUNI8
	epzysZ8CYiutoWb7RtyHyOUcYTtb/gI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-pB65kaY5NIW7kQMQ9MbQsw-1; Tue, 04 Apr 2023 02:23:21 -0400
X-MC-Unique: pB65kaY5NIW7kQMQ9MbQsw-1
Received: by mail-qt1-f197.google.com with SMTP id u22-20020a05622a011600b003dfd61e8594so21416074qtw.15
        for <kvmarm@lists.linux.dev>; Mon, 03 Apr 2023 23:23:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680589399;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=APNrYYwPBAuPO+GWb7+dbYKyxbTjRyfGmu8CPqknU3k=;
        b=yPmOQ151nhnMOM0o1/Z4CaqeSoqrWSWmPUds3+f49GND7wSnY+/SAn9HyIoh0smHRq
         dJT98snctlSJu0Y0CSEeCJ7AqhBfEeO8/4TZFcHokWzLl9pDuelL/vTHXR0Edht+8YS3
         w8M27AD5IG1WBoCwm2/i9BoLQw3BtMTzXi/k0QDJrVn/9ROHGo7rPUl1I3f66m5fhi3u
         NfxsC3jgG8GMvMSn+qMo+37lYgJpZzl6Mhf+5upKXXdsUbsHmiiyUvYTON2bfwLEJD2F
         Rrx8xbE4VQtJjRpfwWuOJpM93O1wu+FUhzP1gIDLaKnfNH9U0/zg3wdD8WFFXrWYH4zP
         5Icw==
X-Gm-Message-State: AAQBX9cuI8yZzw8uqVQEMO37gjhxhIsF9oAyuSk8kwgpQca1C5htRXfg
	FmAXJKeYhZthgOHP6d4pdKIT/HA9Dc5a/bST+9XaAl3xUfDXR33XQN1WZQYOPYFuXqByIKFoOv0
	fWmvqLgbbO03CKHgEgx7B9a1F
X-Received: by 2002:a05:6214:21a4:b0:56f:d8:dbb4 with SMTP id t4-20020a05621421a400b0056f00d8dbb4mr1943715qvc.2.1680589399746;
        Mon, 03 Apr 2023 23:23:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350azFYLEwDlMSgwwh8I9rqVxvJqaLdUyzLHmRZw0ztFX9U2/HybsX+OTx3X6c8SwpCBJw9wTYg==
X-Received: by 2002:a05:6214:21a4:b0:56f:d8:dbb4 with SMTP id t4-20020a05621421a400b0056f00d8dbb4mr1943700qvc.2.1680589399506;
        Mon, 03 Apr 2023 23:23:19 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ny4-20020a056214398400b005e37909a7fcsm2022912qvb.13.2023.04.03.23.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 23:23:18 -0700 (PDT)
Message-ID: <968a026e-066e-deea-d02f-f64133295ff1@redhat.com>
Date: Tue, 4 Apr 2023 08:23:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
To: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
 alexandru.elisei@arm.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230315110725.1215523-1-eric.auger@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/15/23 12:07, Eric Auger wrote:
> On some HW (ThunderXv2), some random failures of
> pmu-chain-promotion test can be observed.
>
> pmu-chain-promotion is composed of several subtests
> which run 2 mem_access loops. The initial value of
> the counter is set so that no overflow is expected on
> the first loop run and overflow is expected on the second.
> However it is observed that sometimes we get an overflow
> on the first run. It looks related to some variability of
> the mem_acess count. This variability is observed on all
> HW I have access to, with different span though. On
> ThunderX2 HW it looks the margin that is currently taken
> is too small and we regularly hit failure.
>
> although the first goal of this series is to increase
> the count/margin used in those tests, it also attempts
> to improve the pmu-chain-promotion logs, add some barriers
> in the mem-access loop, clarify the chain counter
> enable/disable sequence.
>
> A new 'pmu-memaccess-reliability' is also introduced to
> detect issues with MEM_ACCESS event variability and make
> the debug easier.
>
> Obviously one can wonder if this variability is something normal
> and does not hide any other bug. I hope this series will raise
> additional discussions about this.
>
> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v1

Gentle ping.

Thanks

Eric
>
> Eric Auger (6):
>   arm: pmu: pmu-chain-promotion: Improve debug messages
>   arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
>     values
>   arm: pmu: Add extra DSB barriers in the mem_access loop
>   arm: pmu: Fix chain counter enable/disable sequences
>   arm: pmu: Add pmu-memaccess-reliability test
>   arm: pmu-chain-promotion: Increase the count and margin values
>
>  arm/pmu.c         | 189 +++++++++++++++++++++++++++++++++-------------
>  arm/unittests.cfg |   6 ++
>  2 files changed, 141 insertions(+), 54 deletions(-)
>

