Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F061805A
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 21:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749071844; cv=none; b=Z1QGf421Sn1UQPWBExUfFDSbNA08r410PmWc75U9B/Z+p0oVnapacNcTqkpiSKln1ZZKSy7Val4G5lYNS7uoiW19r9LvccrA64NM7ETVCllcUJ+ia5xlZv8NI1vypVN91DLcvAP+dlOPDl18u0Q7cx3WCFloTYcrDe//FWU1dmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749071844; c=relaxed/simple;
	bh=CXCvGL5hSf5ngZ4A2BceMmShZkAeoCIwyR3G4t932uk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JLnwpwmNeIkFcokzc7o8SVky1nQzdnnZwkCEEHjtG1ScbBayV6iH5hN5nsKdzZAi+efMhQh4nEaJ0q+B0qjph19lOsSm9bIZ7W96tKDkd7tyS/kRq0XRmZBnI7Ch+zLNk/vrgZ1RvvOqh14JXz3D+ippErrGITfSFyuzPS+7578=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=THqChL2T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="THqChL2T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749071841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3eaIlD6SgIwBKzFRuDf45UmSCQNYGCKtzx7DOTC83A8=;
	b=THqChL2ThGEpA70BM0FfBVlZLdnIyz+tRD3UJxT1Ifr7QiQLQEYogc8bGJZov92e8Kb9xx
	K2YGTOLFzI5facoMqgO2xKdpP1vqyPiYkPhZkFNCDvZwLsCdQFT7yVlHAbK+OEbnmD5YYE
	4e1Ap/JSnWJt/+ovhZsyY9Q6FkaIxps=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-UEUtdu-oPiCNreZ4nR5L4Q-1; Wed, 04 Jun 2025 17:17:18 -0400
X-MC-Unique: UEUtdu-oPiCNreZ4nR5L4Q-1
X-Mimecast-MFC-AGG-ID: UEUtdu-oPiCNreZ4nR5L4Q_1749071837
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so889505e9.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Jun 2025 14:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749071837; x=1749676637;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3eaIlD6SgIwBKzFRuDf45UmSCQNYGCKtzx7DOTC83A8=;
        b=pNGTVDHjwSOJN33J1xRP1xvUlbF0KAJtJC89/0bGR+PYNt8djvBK8iVDHbUQFr11u+
         GApjutBY12Y6b3UXojeckJ1dsAAw9lpfHN5fyZtvmj1TYqSME4tFSZC2w9taKbLMl13A
         GyXyZu8qbDDE+SmlB0pdcEvtasN0pMS7iaEJHEvQ2X7DE65zMAI0u+p6JP10yYl477+M
         yIAYbM46owpRdSORQ9/Cx6L4jr8a/6ufv9mbRg5/Dndk/4/3/fzxgun3D0SJN9axtECS
         56pNRd7p5h5PkQ/gLnouANS3pKwKVu3vlMm4PZWUVemxdfeZXHfSqkGgp6MvGO1EeMl/
         Jt5A==
X-Forwarded-Encrypted: i=1; AJvYcCVIofKFhB+9qAaoym3XHWjTZECfjyOWAsEZJmxURk7TEC6RDn29cP0xwUkrRXFdNqZOYJ9GmpY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiiQP5WRSO63BZe/0V6omnkkplsieoWqFzXtENyGRY2gEL/jPT
	sHB1ON0hUyRe/dc8pLcyQTbhE8FBFFKABtIk+13UEvDEIai6KuRpbUpWnZKRIHfCZvvRYJSHrpx
	rG0y5uaznD+elp0GqSULHTxj+iGWInuiYOksh40wUuxTsYnGFgXYrLmWOEw==
X-Gm-Gg: ASbGnctvL8phousl2Hf9Ky/9w6is0l5bkuFo4yUREQ3Zs4ziij87FaaBRwg9bp+M0W7
	qmcCrQmjEKM+EkPMtXM8EPadCVf6TTfN6CG+tTFc4K4NIJ5TOZKmfzjbUR5fZ5b3ez4lclYiTli
	Lw7DFAMnbyuy3hNyxIkzzGMVxfvVQgHB8g1RbIk1S5n1/cQj9zrj9FqGpQWrr8CFNfIr+jYxuOA
	YNkM3UlLPkHEJWIJ9RYdEaFgGS0bRExwylb60GQOhbnqKiVe3Ga/JOn7OpK6V+hbw9xzb1kZJOb
	jWDmj8L+gy+8pg4j3UwEDrsU/v3UZHdGHSLwWZf376fm7PJoQSy48zcWDlSq
X-Received: by 2002:a05:6000:2512:b0:3a4:d274:1d9b with SMTP id ffacd0b85a97d-3a51d92f84amr3541710f8f.25.1749071837463;
        Wed, 04 Jun 2025 14:17:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/w3mTJC6PzaXkAlaJcofTyt+hL5Id0Z9sQ5spOyW0fO3Rb3p4l0Y62I6sWoWE4eFRofNvzg==
X-Received: by 2002:a05:6000:2512:b0:3a4:d274:1d9b with SMTP id ffacd0b85a97d-3a51d92f84amr3541694f8f.25.1749071836994;
        Wed, 04 Jun 2025 14:17:16 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe6c842sm22506811f8f.29.2025.06.04.14.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 14:17:16 -0700 (PDT)
Date: Wed, 4 Jun 2025 23:17:15 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
    Colton Lewis <coltonlewis@google.com>, 
    Ricardo Koller <ricarkol@google.com>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: arm64: selftests: arch_timer_edge_cases
 fixes
In-Reply-To: <9b9f7099-4e81-9b74-a1ac-37cd4965675b@redhat.com>
Message-ID: <77f07e94-82a2-5dc4-2483-e2ecff151e66@redhat.com>
References: <20250527142434.25209-1-sebott@redhat.com> <adf8b877-7ca2-f60b-fb59-578c70d0e3c0@huawei.com> <9b9f7099-4e81-9b74-a1ac-37cd4965675b@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -kOIgwQkVAXmfOmab5gLVaDzyChmvqT1PTYPc4hf7r4_1749071837
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 4 Jun 2025, Sebastian Ott wrote:
> On Tue, 3 Jun 2025, Zenghui Yu wrote:
>>  On 2025/5/27 22:24, Sebastian Ott wrote:
>>>  Some small fixes for arch_timer_edge_cases that I stumbled upon
>>>  while debugging failures for this selftest on ampere-one.
>>>
>>>  Changes since v1: modified patch 3 based on suggestions from Marc.
>>>
>>>  I've done some tests with this on various machines - seems to be all
>>>  good, however on ampere-one I now hit this in 10% of the runs:
>>>  ==== Test Assertion Failure ====
>>>    arm64/arch_timer_edge_cases.c:481: timer_get_cntct(timer) >= DEF_CNT +
>>>    (timer_get_cntfrq() * (uint64_t)(delta_2_ms) / 1000)
>>>    pid=166657 tid=166657 errno=4 - Interrupted system call
>>>       1  0x0000000000404db3: test_run at arch_timer_edge_cases.c:933
>>>       2  0x0000000000401f9f: main at arch_timer_edge_cases.c:1062
>>>       3  0x0000ffffaedd625b: ?? ??:0
>>>       4  0x0000ffffaedd633b: ?? ??:0
>>>       5  0x00000000004020af: _start at ??:?
>>>    timer_get_cntct(timer) >= DEF_CNT + msec_to_cycles(delta_2_ms)
>>>
>>>  This is not new, it was just hidden behind the other failure. I'll
>>>  try to figure out what this is about (seems to be independent of
>>>  the wait time)..
>>
>>  Not sure if you have figured it out. I can easily reproduce it on my box
>>  and I *guess* it is that we have some random XVAL values when we enable
>>  the timer..
>
> Yes, I think so, too.
>
>>  test_reprogramming_timer()
>>  {
>>   local_irq_disable();
>>   reset_timer_state(timer, DEF_CNT);
>
> My first attempt was to also initialize cval here

Forgot to mention that I did this because my tests have shown
that the interrupt didn't only trigger early (like before the
reprogrammed delta) but instantly. This seemed to work but I think
the order in set_tval_irq() is the actual issue.


>
>>
>>   /* Program the timer to DEF_CNT + delta_1_ms. */
>>   set_tval_irq(timer, msec_to_cycles(delta_1_ms), CTL_ENABLE);
>>
>>  	[...]
>>  }
>>
>>  set_tval_irq()
>>  {
>>   timer_set_ctl(timer, ctl);
>>
>>   // There is a window that we enable the timer with *random* XVAL
>>   // values and we may get the unexpected interrupt.. And it's
>>   // unlikely that KVM can be aware of TVAL's change (and
>>   // re-evaluate the interrupt's pending state) before hitting the
>>   // GUEST_ASSERT().
>>
>>   timer_set_tval(timer, tval_cycles);
>
> Yes, I stumbled over this as well. I've always assumed that this order is
> becauase of this from the architecture "If CNTV_CTL_EL0.ENABLE is 0, the 
> value returned is UNKNOWN." However re-reading that part today I realized
> that this only concerns register reads.
>
> Maybe somone on cc knows why it's in that order?
>
> I'm currently testing this with the above swapped and it's looking good,
> so far.
>
>>  }
>>
>>  I'm not familiar with the test so I'm not 100% sure that this is the
>>  root cause. But I hope this helps with your analysis ;-) .
>
> It did, thanks!
>
> Sebastian
>

