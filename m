Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231DD5CBE
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 07:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687938291;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gEFCO6LP8mfvqL0i/v3L1hgRp+ixmHtRy0L/FBujzDA=;
	b=T14eQtvyv+nQvCMLgbxuQLEl9iRUiB7yYGvA8t2b0VBfHRJ3o82z7MP/4KloBQnD9GKrTe
	1A/M5uB6n/E3kzY1lkBiGXqmWVdNb1RJMA2j5EXTCCfEK811Bygf63EDLHIMSPlbTeZeyM
	CLJThfuK4jHqVx61j6MQvOTVms9nHhY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-rs8ikHJSN6ajARuGFZs7wQ-1; Wed, 28 Jun 2023 03:44:50 -0400
X-MC-Unique: rs8ikHJSN6ajARuGFZs7wQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-40252a2fd0dso19215161cf.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 00:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687938289; x=1690530289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gEFCO6LP8mfvqL0i/v3L1hgRp+ixmHtRy0L/FBujzDA=;
        b=fNQ0Gn/R66S6vnOmHmMKRJXO78UaJz72bG+8AvVzkFemWDz+/0mGUAXWtF9YuF8DSB
         XzlXIomiNWjdnmeWQUah0sARoNxGPs+hh4bjP1E7YJoaf1S8rw9XKmpXspFVEHt63j2W
         bRB/zbzcWLKzLenKLR/U6xKOZX6zD8WpUkB2tGhTJccyDuU/+ARg7mngm5nyAwbnjpxY
         2b2BPIeeVhrARuwFBjBta1CDW73IrpbsOKGTChoUaG3xxfaCVA1Jj3XFUf/F3EcvLl4a
         ytTpvhklhHtt5lM8lOYRmfGbwM8q7gx8yuz4giqKsBT9BO21VZ2WG0U2U/PSGi9FQT+7
         Z3Jw==
X-Gm-Message-State: AC+VfDw0+f3pUKgE8tEtp4ye1p8qMorJC9qZcaG7+4BHDZgM0gEMV7rv
	qBfcyhKidpJ/bolbg3FrbiBc5R/AgxPkURtzf+0mqzkcmGrVtDxk/MLfTL6+7CAn/k4zTe8TAEo
	l+0YX195mAf8h2RT0
X-Received: by 2002:ac8:5a11:0:b0:3fd:eaa8:ec5e with SMTP id n17-20020ac85a11000000b003fdeaa8ec5emr35303836qta.20.1687938289509;
        Wed, 28 Jun 2023 00:44:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7tZCFozSAn4f8mm7MZh1tWv2n+U+GKLaivskq116PeuxTrtCfVJ34biBb/+bMKM6LiqyNV+A==
X-Received: by 2002:ac8:5a11:0:b0:3fd:eaa8:ec5e with SMTP id n17-20020ac85a11000000b003fdeaa8ec5emr35303818qta.20.1687938289224;
        Wed, 28 Jun 2023 00:44:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bn4-20020a05622a1dc400b004009f034a6csm4169643qtb.91.2023.06.28.00.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 00:44:48 -0700 (PDT)
Message-ID: <0aa48994-96b3-b5a1-e72b-961e6e892142@redhat.com>
Date: Wed, 28 Jun 2023 09:44:44 +0200
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
To: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
 alexandru.elisei@arm.com
Cc: mark.rutland@arm.com
References: <20230619200401.1963751-1-eric.auger@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230619200401.1963751-1-eric.auger@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru, Drew,

On 6/19/23 22:03, Eric Auger wrote:
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
> A new 'pmu-mem-access-reliability' is also introduced to
> detect issues with MEM_ACCESS event variability and make
> the debug easier.
>
> Obviously one can wonder if this variability is something normal
> and does not hide any other bug. I hope this series will raise
> additional discussions about this.
>
> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v3
>
> History:
>
> v2 -> v3:
> - took into account Alexandru's comments. See individual log
>   files
Gentle ping. Does this version match all your expectations?

Thanks

Eric
>
> v1 -> v2:
> - Take into account Alexandru's & Mark's comments. Added some
>   R-b's and T-b's.
>
>
> Eric Auger (6):
>   arm: pmu: pmu-chain-promotion: Improve debug messages
>   arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
>     values
>   arm: pmu: Add extra DSB barriers in the mem_access loop
>   arm: pmu: Fix chain counter enable/disable sequences
>   arm: pmu: Add pmu-mem-access-reliability test
>   arm: pmu-chain-promotion: Increase the count and margin values
>
>  arm/pmu.c         | 208 ++++++++++++++++++++++++++++++++--------------
>  arm/unittests.cfg |   6 ++
>  2 files changed, 153 insertions(+), 61 deletions(-)
>

