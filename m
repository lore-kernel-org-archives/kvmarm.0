Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118B4DA9A
	for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 19:26:48 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id b26-20020a5d805a000000b0074cfe3a44aeso2968426ior.10
        for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 11:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678476408;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3xiptOW379c+WJSVr4OZVP651WWtVFvTnTJlCDNw7uE=;
        b=hzSnr7bKqZiXcaQnZjqqB6VhgFKbujEGgfI8DSYixtRg5qBNAufeHnIEN8Bl6/jD6b
         KvzgHbrahGIAvPvLldEZZkngcWqfjN4IyDYBU0oQz3DOFZ+5d744o+GGeteiabw0M/0i
         OOQ+DHMi1dlg+qnBsMUzm4/As0EkhilrcC4f4vymyCnrYTcL/ZxM+ezJBimnvDUaxAbE
         f5xtcMrFv6Z9b6rE0sdswqothIVKNjLYHQFDaMovcbXjkm9DUtJtcvdA/kOYPmhQ8N41
         SBcEn5l0tNnPBYfaTOlwNTgLKvFL6KjFP7f3DS9RRSBhmfMUhwILl8NnFteuEWRBdzlj
         SsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678476408;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xiptOW379c+WJSVr4OZVP651WWtVFvTnTJlCDNw7uE=;
        b=PBYKLCwSZu4y0KMpNcyObrqmOhBBJKl2PWKKZa9n8wgYsxvBSFbXmwCMv0OJ/qB5H5
         pjYjpnnYaFM7xJP8LfTEQaRaq2oINuf7ScyOtClGFFoesfuu+6rWe/TriL0AKNtimhsa
         fB96UJDEC8bv4C0j7/ilaKLUdBSGBNjylCYca9BhWrLK90RLVgrLX2t1kKxM9mXfLTv2
         jw6CzkIL68lIVZ6L7w+Wyosd11ZcxYjhcr1bFHR+n39tAnINra+1NO+1y0i8B69DfIct
         xOVHnngS4BSPvQDVj8tE/4v5/sObKufK1p4w+ZOkW9VxZ3s30iLQt+U9jpgh6pkk1W6E
         IYhw==
X-Gm-Message-State: AO0yUKXXXtSI8pzaJlcsFywUSeX6iMaG9JJmYECQfxqKsVx60shT7B9o
	MbFQSEaMCPtsHEL0lqeDZ73YJEAEhEUhd/wHYg==
X-Google-Smtp-Source: AK7set/by6XyVUVEGlfmMRempE8cjhEA6Eltjb83l/8OnevFCfFJyvA89CV59vJN3ML48t1sS2VV7iyW9bJFFLB3DQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:630b:0:b0:3c5:14ca:58c6 with SMTP
 id j11-20020a02630b000000b003c514ca58c6mr12832803jac.4.1678476408094; Fri, 10
 Mar 2023 11:26:48 -0800 (PST)
Date: Fri, 10 Mar 2023 19:26:47 +0000
In-Reply-To: <87a60m9u3a.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 09 Mar 2023 09:01:29 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntcz5gcsqw.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 15/16] KVM: arm64: selftests: Augment existing timer test
 to handle variable offsets
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Marc Zyngier <maz@kernel.org> writes:

>> mvbbq9:/data/coltonlewis/ecv/arm64-obj/kselftest/kvm#
>> ./aarch64/arch_timer -O 0xffff
>> ==== Test Assertion Failure ====
>>    aarch64/arch_timer.c:239: false
>>    pid=48094 tid=48095 errno=4 - Interrupted system call
>>       1  0x4010fb: test_vcpu_run at arch_timer.c:239
>>       2  0x42a5bf: start_thread at pthread_create.o:0
>>       3  0x46845b: thread_start at clone.o:0
>>    Failed guest assert: xcnt >= cval at aarch64/arch_timer.c:151
>> values: 2500645901305, 2500645961845; 9939, vcpu 0; stage; 3; iter: 2

> The fun part is that you can see similar things without the series:

> ==== Test Assertion Failure ====
>    aarch64/arch_timer.c:239: false
>    pid=647 tid=651 errno=4 - Interrupted system call
>       1  0x00000000004026db: test_vcpu_run at arch_timer.c:239
>       2  0x00007fffb13cedd7: ?? ??:0
>       3  0x00007fffb1437e9b: ?? ??:0
>    Failed guest assert: config_iter + 1 == irq_iter at  
> aarch64/arch_timer.c:188
> values: 2, 3; 0, vcpu 3; stage; 4; iter: 3

> That's on a vanilla kernel (6.2-rc4) on an M1 with the test run
> without any argument in a loop. After a few iterations, it blows.

These things are different failures. The first I've only ever found when
setting the -O option. What command did you use to trigger the second if
there were any non-default options?

Another interesting finding is that I can't reproduce any problems using
ARM's emulated platform. There is a possibility these errors are
ultimately down to individual hardware quirks, but that's still worth
understanding since everyone uses hardware and not emulators.

> The problem is that I don't understand enough of the test to make a
> judgement call. I hardly get *what* it is testing. Do you?

My understanding is the test validates timer interrupts are occuring
when the ARM manual says they should. It sets a comparison value (cval)
at some point a few miliseconds into the future and waits for the
counter (xcnt) to be greater than or equal to the comparison value, at
which point an interrupt should fire.

The failure I posted occurs at a line that says

GUEST_ASSERT_3(xcnt >= cval, xcnt, cval, xcnt_diff_us);

The counter was less than the comparison value, which implies the
interrupt fired early. Do we care? I don't know. I think it's weird that
this occurs when I set a physical offset with -O and no other time.

I've also noticed that the greater the offset I set, the greater the
difference between xcnt and cval. I think the physical offset is not
being accounted for every place it should. At the very least, that
indicates change is required in the test.

The failure you posted occurs at a line that says

GUEST_ASSERT_2(config_iter + 1 == irq_iter,
		config_iter + 1, irq_iter);

I gather from context that the values were unequal because an expected
interrupt never fired or was not counted. Do we care? I don't know. I
think someone should.
