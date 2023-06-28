Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36FFBA32
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 11:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687952721;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gG34vBszsSTsXv424f+J6wft9r6cv3NSWGV4K4eT1m0=;
	b=gsZEG3XbO+ydB20VNpWaA0mW94DqU/vfS+h81qTwUvHy2ThfwxiPynmsnKXSpdF+CxeLYT
	SYldf9EdHTuwQyjqVaI0TGTPZk9eR5I9g/E3Kf9qDZPZo2MoVq7a8IwIe0aIfbuASru6w8
	t/H7oJsESOqn95qFr4huLdqQSU9YAH8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-QbVWgnuxNXSdUQcatz-i3g-1; Wed, 28 Jun 2023 07:45:20 -0400
X-MC-Unique: QbVWgnuxNXSdUQcatz-i3g-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6351121aa10so49076576d6.0
        for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 04:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687952719; x=1690544719;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gG34vBszsSTsXv424f+J6wft9r6cv3NSWGV4K4eT1m0=;
        b=fUpjB/GuZuS1WNW0YjIm8wOVGGz8yqSm/xHyC0mypHP2Ib3vKfTjaHigBlomhD/teY
         I6ASIBhANdNPSE38QXflXFe14/B17IQkvwESYoeCrqnn/BXa0p8mPinxvHufKuVHBWNF
         7lkyg5Wx+hQG3FXUjaNCzMNmfEx0PxScHjhnyNBlIOUnaEzU9V+nLvH+5C+7EG8YCSOe
         RUNCxdPfKjF2Da+jld62MTZOUSf3mP5UN5KRs4iGuGUwYqCd/3lobxWmRM2TzVUIcUyG
         h5dnNFTJ1vRecPw7inlqNQZB372dNk5NmrB+YHxK3PsNScLMLerembZbstYFGDPw3dcr
         V1IQ==
X-Gm-Message-State: AC+VfDz3Mdgfx2ogoZH76QUYZryMM3uFN/6GKBB27VRR32unOfrFTH6r
	WRCya3OcLulaTGpKyO8FGwFGbuVgGY77KZ0Ih7ReSelOuqEXAlv4k05gG8yI5NzHJC9YMNmoSYC
	JwigYGV1DtY8aUR5Q
X-Received: by 2002:ad4:5b81:0:b0:61a:197b:605 with SMTP id 1-20020ad45b81000000b0061a197b0605mr40853447qvp.1.1687952719556;
        Wed, 28 Jun 2023 04:45:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5IuyO6xm/7d6GVxqbgTrPYJusJ78jlvdgLFF7AKVoRvQjl0Q/qvORJnqPEtUaAlb7IFTttAg==
X-Received: by 2002:ad4:5b81:0:b0:61a:197b:605 with SMTP id 1-20020ad45b81000000b0061a197b0605mr40853410qvp.1.1687952719223;
        Wed, 28 Jun 2023 04:45:19 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id du7-20020a05621409a700b006301d31e315sm5714148qvb.10.2023.06.28.04.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 04:45:18 -0700 (PDT)
Message-ID: <e570fe02-3018-cb8f-ee21-b9f6e9ee11b9@redhat.com>
Date: Wed, 28 Jun 2023 13:45:14 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
 mark.rutland@arm.com
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <0aa48994-96b3-b5a1-e72b-961e6e892142@redhat.com>
 <ZJwI45VTkf6TppBm@monolith.localdoman>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZJwI45VTkf6TppBm@monolith.localdoman>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,

On 6/28/23 12:18, Alexandru Elisei wrote:
> Hi,
>
> On Wed, Jun 28, 2023 at 09:44:44AM +0200, Eric Auger wrote:
>> Hi Alexandru, Drew,
>>
>> On 6/19/23 22:03, Eric Auger wrote:
>>> On some HW (ThunderXv2), some random failures of
>>> pmu-chain-promotion test can be observed.
>>>
>>> pmu-chain-promotion is composed of several subtests
>>> which run 2 mem_access loops. The initial value of
>>> the counter is set so that no overflow is expected on
>>> the first loop run and overflow is expected on the second.
>>> However it is observed that sometimes we get an overflow
>>> on the first run. It looks related to some variability of
>>> the mem_acess count. This variability is observed on all
>>> HW I have access to, with different span though. On
>>> ThunderX2 HW it looks the margin that is currently taken
>>> is too small and we regularly hit failure.
>>>
>>> although the first goal of this series is to increase
>>> the count/margin used in those tests, it also attempts
>>> to improve the pmu-chain-promotion logs, add some barriers
>>> in the mem-access loop, clarify the chain counter
>>> enable/disable sequence.
>>>
>>> A new 'pmu-mem-access-reliability' is also introduced to
>>> detect issues with MEM_ACCESS event variability and make
>>> the debug easier.
>>>
>>> Obviously one can wonder if this variability is something normal
>>> and does not hide any other bug. I hope this series will raise
>>> additional discussions about this.
>>>
>>> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v3
>>>
>>> History:
>>>
>>> v2 -> v3:
>>> - took into account Alexandru's comments. See individual log
>>>   files
>> Gentle ping. Does this version match all your expectations?
> The series are on my radar, I'll have a look this Friday.

OK thanks :-)

Eric
>
> Thanks,
> Alex
>
>> Thanks
>>
>> Eric
>>> v1 -> v2:
>>> - Take into account Alexandru's & Mark's comments. Added some
>>>   R-b's and T-b's.
>>>
>>>
>>> Eric Auger (6):
>>>   arm: pmu: pmu-chain-promotion: Improve debug messages
>>>   arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
>>>     values
>>>   arm: pmu: Add extra DSB barriers in the mem_access loop
>>>   arm: pmu: Fix chain counter enable/disable sequences
>>>   arm: pmu: Add pmu-mem-access-reliability test
>>>   arm: pmu-chain-promotion: Increase the count and margin values
>>>
>>>  arm/pmu.c         | 208 ++++++++++++++++++++++++++++++++--------------
>>>  arm/unittests.cfg |   6 ++
>>>  2 files changed, 153 insertions(+), 61 deletions(-)
>>>

