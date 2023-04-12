Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D141843
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 08:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681286446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4g6QUzYjZDk8OEDnQPnxop0+qkxyFNzVNyJaspo5AU=;
	b=cHp2I+pt4M17yY39jAsfIxObcd/8GXiHTW65QN/Ns0kiJ4t6ksF37YDb+8bEp9LNr88vKX
	GS6hM3eILcmYuh0OR+jsEaX5ZMQIgA3m7ZNpUb9CYrx+eNA/BsqmB/feVOJEgL0cMMcuF9
	WlQFHa/EjTUgHHA7tMhF+CV3e4otHww=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-jGCjOV69PGWRQIJPJhxnTg-1; Wed, 12 Apr 2023 04:00:45 -0400
X-MC-Unique: jGCjOV69PGWRQIJPJhxnTg-1
Received: by mail-qt1-f199.google.com with SMTP id u1-20020a05622a198100b003e12a0467easo8257296qtc.11
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 01:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681286444; x=1683878444;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U4g6QUzYjZDk8OEDnQPnxop0+qkxyFNzVNyJaspo5AU=;
        b=zAF5ce2yK8rAn3NZVsO/8ZAFjLHwhG1v0zM0cqDmxSp4WJ3aDp9BgSbhYMnsbXtvye
         zBqC3igeET4+aBkhDFI0ifpxTTRcY/ykTKQKV3GyLQ7+F3LTWq6RlJevAMg4SfrWuSIj
         Vi755kDKCxm90QI5ORhu8W0WfyhEhSZWbhLpCe3IREmY1HZQNjYsQCJU5jxm060wrGq2
         SqrkcdX+LrD081/DIYd/QFmOLy5/lOAJhWvOc0Nq/fcQq95ni91nCpD04p9ytk1LHI1L
         gfKUCmCLeXy8Dimo8CZniSi0k0/JS0bcllad1CFHdtQQJmLhaVcHN88nt1Zwmyu8Hklv
         gbdQ==
X-Gm-Message-State: AAQBX9cuvxGrajqOYdJ8uaG1pOF48ncfxDozUPdEkuCcHuu84mHF9S1O
	YU3g5hSRUQLJ0eIFfDhl6HEb9Vrmm4qANL6GvB4AOaJYK5dtVWiSZRhWvD7egXDuKHfdNtLU9d7
	H/euhj8whAXsHEhME
X-Received: by 2002:a05:622a:291:b0:3bf:d9f3:debe with SMTP id z17-20020a05622a029100b003bfd9f3debemr8785681qtw.59.1681286444630;
        Wed, 12 Apr 2023 01:00:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yx/y1BXsLLPlgiu2GmT+rcdMo/H/cpQuubvysf/bF2Xf5w9ZkU+yOUAnQKnQXcoBOIU+h9rQ==
X-Received: by 2002:a05:622a:291:b0:3bf:d9f3:debe with SMTP id z17-20020a05622a029100b003bfd9f3debemr8785670qtw.59.1681286444444;
        Wed, 12 Apr 2023 01:00:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a13-20020ac8720d000000b003e4e1dbdcc3sm4110037qtp.47.2023.04.12.01.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 01:00:43 -0700 (PDT)
Message-ID: <84aaa360-3f96-d648-0fe3-cb6667542bc7@redhat.com>
Date: Wed, 12 Apr 2023 10:00:40 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: pmu-chain-promotion kvm-unit-test failures in mainline
To: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com
References: <cdf922b3-1ac3-438d-8817-6c4d693b1fc3@sirena.org.uk>
 <861qkpmtw3.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <861qkpmtw3.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
On 4/12/23 09:39, Marc Zyngier wrote:
> On Tue, 11 Apr 2023 22:15:02 +0100,
> Mark Brown <broonie@kernel.org> wrote:
>>
>> [1  <text/plain; us-ascii (7bit)>]
>> Arm's internal test infrastructure has started seeing failures for the
>> pmu-chain-promption test in kvm-unit-tests on TX2 when running mainline
>> and kvm-unit-tests commit 2480430a36102f8ea276b3bfb1d64d5dacc23b8f
>> ("configure: Show the option in case it is not known").  The log I'm
>> seeing from the test runner is:
>>
>> TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
>> FAIL pmu-chain-promotion (7 tests, 2 unexpected failures)
>>
>> Unfortunately I don't have direct access to a TX2 so can't readily
>> alter the test run other than replacing the kernel.  I believe the
>> specific failures were:
>>
>> FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: CHAIN counter was incremented and overflow
>> FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: 32b->64b CHAIN counter was incremented and overflow
> 
> Is this related to [1]?
> 
> 	M.
> 
> [1] https://lore.kernel.org/r/20230315110725.1215523-1-eric.auger@redhat.com

Yes please let me know if it fixes your issue. I also tried bisection
but it did not lead to anything.

Thanks

Eric
> 

