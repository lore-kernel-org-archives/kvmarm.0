Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCF91E47AD
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 20:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749070735; cv=none; b=DON+4orQplsHOfcb69tr4vzfsLgwOsCraqv74daXTMUazplDscoM5fva7meRti53djk6ztInNHmX4laZF93Fpk5YBZJuGwOfjswnDYdD8bKsgUMcubvjY1ZjoIb/zsNAIAcIbP+utt7/LB9KbUizB/N1QAIgrCEofPhR5SZgL5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749070735; c=relaxed/simple;
	bh=zYGIV8gUJFeESoLXphcUN3VcBCSW38+M6xGL/Gy3T2E=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=n/IqQQ/pYFHcZ4oyZR/HUfETocLFM0aKY8GYA3Q6WqWUkrC+gT81NWF6Vttpxd7yScS3pzDvaDinKpUcvYIrvHoan5r+H2E+2PKSui5yehONAfTsc4GfaQdlTet5KeMx2Rh2io1mWrFNdGqgzEFN/i68YbzMDuTm1TKAEteNLxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TFDFZFL+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TFDFZFL+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749070733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IjFlZ2/sUA2L86ngL9b3sMgbK1PseoDFjEohelsa5Jg=;
	b=TFDFZFL+GsUItRHvXrBj/obtIUzlsHneEF53B0uG20J4kfGSEI6FuAjuZf3WXQe8c/6YyO
	KyeAfL4sQzQzLFTOFy+CXfME2STbgTyBdelpdNUDabJFsj29hOHNLciudHJj4mzHMNM+xF
	IQx5V/5JKRksib3qljsKkzM3Lz8wfdU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-Ee5rujm8Ml-QVdhM_adYVQ-1; Wed, 04 Jun 2025 16:58:51 -0400
X-MC-Unique: Ee5rujm8Ml-QVdhM_adYVQ-1
X-Mimecast-MFC-AGG-ID: Ee5rujm8Ml-QVdhM_adYVQ_1749070730
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4ff581df3so138699f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Jun 2025 13:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749070730; x=1749675530;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjFlZ2/sUA2L86ngL9b3sMgbK1PseoDFjEohelsa5Jg=;
        b=uMUZ/vPC2EkcgP+d1qu6Kdo1HKS/2vQCHQDAnrP2wY6K8tgDkv8RfO9E6ywUY+W6cH
         UZDM7pC/+0DSdVXnYWfNlcXnjqm0v5HeszNeDXknAL7UayErQ1in31ioqQWUUHNl1SAy
         b9tEY9fQ3SO8VWTw2FS7khvEuK49DjgIiUlqywRnAPHadzVOsuWfeHd1E2LbodTQ4B8m
         zU0AJvvx6A+cyhnh1vKK1Un4qcgvzrGCFNJvfWkt6Sdo23Jf3tSYwlaPQPmlsS/8rdLS
         NNcsEGyFfSjedX/PJtaR2EJazJFf9l1gVL8JM+qCAUGVtKJ2DbpWMUY5oh0yyzXLzaIC
         QDcw==
X-Forwarded-Encrypted: i=1; AJvYcCWdvYsh7x3XqMBNePlGBw2sZoeXtVPsslZ2tpWVdvZ/GN/W4KNQP8iWmZ/HDUMAfWrnRqHbDAg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyByi4rU75KwUqZb75ostiJMK5A3QvqcwurzCJQe6yWoMyI0Sxp
	etVrgjKynF30YLFZY6NkUA0FF4nnyuaQ/Tk7kAh5gJa0ibhN6vpd+1jvDXmLQQh5Oi1MZ4pm0Dd
	Snyx+yMnva8gD4WuuHvUGt+aBz9Y3Mv8SCfNnXGApu7IdpBH5SR8WOyG1Gw==
X-Gm-Gg: ASbGncvZhutL/KVOn4Jphr8wbkMvjq0/9bjWLJk7J8WlT5B+dFf2+kIF7AaCvuQO5Y8
	sm+7TiHIMvNzFhKTNDA++tF2yFYanl3mZMMGHZXYALzOfMrO0oy/NgSRv2NNAQC85Rvb7DqfZaw
	ztwrQg5G65pibkMnGTGIYMjzL2usgliezeJQ+Bw4XqHrxfO6O6pnHpGQ4hQBZUUgQerr3H12qkm
	e3HR7FzEDzmW6jHPjHTy/Fvz3SFHw414pA3hiu0a2JvvcjK2+9mnycar/I2LSxLooDyljuHz0Ov
	w5RYWOvAn7IT2BegPOIz6hGcgZcrUJ1XowJU6MtdO8V73umSbF21Nk/RGi+x
X-Received: by 2002:a05:6000:2890:b0:3a4:e603:3d2 with SMTP id ffacd0b85a97d-3a526a84717mr847211f8f.0.1749070730444;
        Wed, 04 Jun 2025 13:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEa+Gezp8iiTLoB/KqZ3gWK809er5J18zOcbOHxYhrjEk3yJTf+o6JBeAedMNn9aSfhfWFJMQ==
X-Received: by 2002:a05:6000:2890:b0:3a4:e603:3d2 with SMTP id ffacd0b85a97d-3a526a84717mr847196f8f.0.1749070730088;
        Wed, 04 Jun 2025 13:58:50 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe754acsm23052362f8f.59.2025.06.04.13.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 13:58:49 -0700 (PDT)
Date: Wed, 4 Jun 2025 22:58:48 +0200 (CEST)
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
In-Reply-To: <adf8b877-7ca2-f60b-fb59-578c70d0e3c0@huawei.com>
Message-ID: <9b9f7099-4e81-9b74-a1ac-37cd4965675b@redhat.com>
References: <20250527142434.25209-1-sebott@redhat.com> <adf8b877-7ca2-f60b-fb59-578c70d0e3c0@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aU2N9BnUki0w_tAcjS-wbdBcsSneG-p4Jdjk4psAc6E_1749070730
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Zenghui,

On Tue, 3 Jun 2025, Zenghui Yu wrote:
> On 2025/5/27 22:24, Sebastian Ott wrote:
>> Some small fixes for arch_timer_edge_cases that I stumbled upon
>> while debugging failures for this selftest on ampere-one.
>>
>> Changes since v1: modified patch 3 based on suggestions from Marc.
>>
>> I've done some tests with this on various machines - seems to be all
>> good, however on ampere-one I now hit this in 10% of the runs:
>> ==== Test Assertion Failure ====
>>   arm64/arch_timer_edge_cases.c:481: timer_get_cntct(timer) >= DEF_CNT + (timer_get_cntfrq() * (uint64_t)(delta_2_ms) / 1000)
>>   pid=166657 tid=166657 errno=4 - Interrupted system call
>>      1  0x0000000000404db3: test_run at arch_timer_edge_cases.c:933
>>      2  0x0000000000401f9f: main at arch_timer_edge_cases.c:1062
>>      3  0x0000ffffaedd625b: ?? ??:0
>>      4  0x0000ffffaedd633b: ?? ??:0
>>      5  0x00000000004020af: _start at ??:?
>>   timer_get_cntct(timer) >= DEF_CNT + msec_to_cycles(delta_2_ms)
>>
>> This is not new, it was just hidden behind the other failure. I'll
>> try to figure out what this is about (seems to be independent of
>> the wait time)..
>
> Not sure if you have figured it out. I can easily reproduce it on my box
> and I *guess* it is that we have some random XVAL values when we enable
> the timer..

Yes, I think so, too.

> test_reprogramming_timer()
> {
> 	local_irq_disable();
> 	reset_timer_state(timer, DEF_CNT);

My first attempt was to also initialize cval here

>
> 	/* Program the timer to DEF_CNT + delta_1_ms. */
> 	set_tval_irq(timer, msec_to_cycles(delta_1_ms), CTL_ENABLE);
>
> 	[...]
> }
>
> set_tval_irq()
> {
> 	timer_set_ctl(timer, ctl);
>
> 	// There is a window that we enable the timer with *random* XVAL
> 	// values and we may get the unexpected interrupt.. And it's
> 	// unlikely that KVM can be aware of TVAL's change (and
> 	// re-evaluate the interrupt's pending state) before hitting the
> 	// GUEST_ASSERT().
>
> 	timer_set_tval(timer, tval_cycles);

Yes, I stumbled over this as well. I've always assumed that this order is
becauase of this from the architecture "If CNTV_CTL_EL0.ENABLE is 0, the 
value returned is UNKNOWN." However re-reading that part today I realized
that this only concerns register reads.

Maybe somone on cc knows why it's in that order?

I'm currently testing this with the above swapped and it's looking good,
so far.

> }
>
> I'm not familiar with the test so I'm not 100% sure that this is the
> root cause. But I hope this helps with your analysis ;-) .

It did, thanks!

Sebastian

