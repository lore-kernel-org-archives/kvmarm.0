Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3A823C3
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 07:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681889414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K8vn0+E6RKyGrC20fweJ1u1FF1sQ5jsPGqFvCpepot0=;
	b=NM19Oq9uxkGJldwINtgQn6EvUWaQXgKKcavEmZxwO6G37YKZtLt5mRc9U2OQQKRaRks+In
	+9FPZJK3aoyWDDQ3phAVxkaXPB2M3BifIhjnUapCt6hC7zgOXg3O6CERcVoxqAWgGVAc+H
	CIS3vFGWdhhDFehT6iqNJD8aE6qMX1E=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-D469qEOTNgyfLOMHqMxzeg-1; Wed, 19 Apr 2023 03:30:13 -0400
X-MC-Unique: D469qEOTNgyfLOMHqMxzeg-1
Received: by mail-qt1-f200.google.com with SMTP id y5-20020a05622a004500b003e3979be6abso21764382qtw.12
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 00:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681889412; x=1684481412;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K8vn0+E6RKyGrC20fweJ1u1FF1sQ5jsPGqFvCpepot0=;
        b=K8ByUW1AY+sF5OZogOcgeY/lKyLR4lZ2UlG0ofa72OrZxi3GwbuYpXkL/ZQjGqNjyJ
         n3Ift4d2kHZBT1Q1Oa4Iyie7sPGmBYlIkONOrhqu+W3cklrFwn+Ji+CyKyk7uPl3xRwF
         pOM6BFKvullqpR9Al2jM+77nUFjyBXcj8Hw5QbuYpu99SbpN9Iubnlo8it99LZZKvCf0
         i+0OiN16qOpcpKNP4RZy6MJuDj9bfi6nXSJT8qH3ekOZ257P5E29RkQKKuxVWAeYz3D8
         tzuDKMFkeuHM/rUN6fIEQCqkDxN4OiCVDe/uvhdxMWc9A1j9o5aFIHC5sY7ZD/7LU049
         wJ+w==
X-Gm-Message-State: AAQBX9eHdVl8/C2sPZdK1c2X9b3gnZvTJyvhTibYXzjr1bJy2J5MiiQm
	MajXkpBvIgzGG0tpwkfBhhXlYEVYT32tXhU7ok5cfgQRXS8t8yDqHnjNFpQbZJzAv1ceYpQiEHv
	sJHLb2nGgeqvH8VRp
X-Received: by 2002:a05:622a:1b9e:b0:3ef:41af:81d6 with SMTP id bp30-20020a05622a1b9e00b003ef41af81d6mr2811435qtb.56.1681889412659;
        Wed, 19 Apr 2023 00:30:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350YqSqpR5je2lJl/G37kvc26FEFitP+QhWnIyAAyzZ2canyOI1ojuGxg0lQlXaFGQqIe0kRdfw==
X-Received: by 2002:a05:622a:1b9e:b0:3ef:41af:81d6 with SMTP id bp30-20020a05622a1b9e00b003ef41af81d6mr2811408qtb.56.1681889412441;
        Wed, 19 Apr 2023 00:30:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t7-20020a05621405c700b005dd8b9345bcsm4236888qvz.84.2023.04.19.00.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 00:30:11 -0700 (PDT)
Message-ID: <7f3ce441-c9ab-6f26-1fc6-693a9740a43c@redhat.com>
Date: Wed, 19 Apr 2023 09:30:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: pmu-chain-promotion kvm-unit-test failures in mainline
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
References: <cdf922b3-1ac3-438d-8817-6c4d693b1fc3@sirena.org.uk>
 <861qkpmtw3.wl-maz@kernel.org>
 <84aaa360-3f96-d648-0fe3-cb6667542bc7@redhat.com>
 <ZDZwex6uCrEwS6ds@FVFF77S0Q05N>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <ZDZwex6uCrEwS6ds@FVFF77S0Q05N>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 4/12/23 10:48, Mark Rutland wrote:
> On Wed, Apr 12, 2023 at 10:00:40AM +0200, Eric Auger wrote:
>> Hi,
>> On 4/12/23 09:39, Marc Zyngier wrote:
>>> On Tue, 11 Apr 2023 22:15:02 +0100,
>>> Mark Brown <broonie@kernel.org> wrote:
>>>>
>>>> [1  <text/plain; us-ascii (7bit)>]
>>>> Arm's internal test infrastructure has started seeing failures for the
>>>> pmu-chain-promption test in kvm-unit-tests on TX2 when running mainline
>>>> and kvm-unit-tests commit 2480430a36102f8ea276b3bfb1d64d5dacc23b8f
>>>> ("configure: Show the option in case it is not known").  The log I'm
>>>> seeing from the test runner is:
>>>>
>>>> TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
>>>> FAIL pmu-chain-promotion (7 tests, 2 unexpected failures)
>>>>
>>>> Unfortunately I don't have direct access to a TX2 so can't readily
>>>> alter the test run other than replacing the kernel.  I believe the
>>>> specific failures were:
>>>>
>>>> FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: CHAIN counter was incremented and overflow
>>>> FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: 32b->64b CHAIN counter was incremented and overflow
>>>
>>> Is this related to [1]?
>>>
>>> 	M.
>>>
>>> [1] https://lore.kernel.org/r/20230315110725.1215523-1-eric.auger@redhat.com
>>
>> Yes please let me know if it fixes your issue. I also tried bisection
>> but it did not lead to anything.
> 
> FWIW, that worked for me; I replied there with a Tested-by (and test results).

Thank you for testing!

Eric
> 
> Thanks,
> Mark.
> 

