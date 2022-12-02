Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38141FA9;
	Fri,  2 Dec 2022 09:55:30 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so7838146pjc.3;
        Fri, 02 Dec 2022 01:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SiNH+J33VpyIQDYVvWeq7Cr+JtDYqACf4JbEasUl180=;
        b=F0CI7XedxSQCcnKRIkZSxjtelGz9DSWh5cWO9aQfJorTeZDaYnJynPxfX7GoFKQ29j
         cwVU0Rg0wtPS7tBi+6PcyAgITcvp2twH/fqGXXgRRgDfrwYcwwlJFAJsjJbvjHzyAeU6
         1T4TDvn8Lk9tP1hag0Go94jolQrB4VYh96lwa+q8QsMBJOQIvdYCwzbx5Ieuyfw1ZCxu
         Idzcl1YOFDobBWi3soxwWY+Vl5bQ043PDlSi+qRmotpkGrqC4uoo9FJCvou4wIgk9IQ2
         8mvyiz90lU2S/Sc3yJKVRMkTBws7x5m2A5aqM8d+CuFukjigIsn3cT8uLcBFkM7ewWls
         DmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SiNH+J33VpyIQDYVvWeq7Cr+JtDYqACf4JbEasUl180=;
        b=NbgUCRFuPuxGDjBlgogA5uCstBf9wrlE98zqhrvZj43SEr5wXbWI1N1b9NZSOIcMbW
         dE4Aex9Qbwgd3v0j8C5SHdAC1QYWAH8kk3Pw2IGBrvz1fZH9eXYLIjQheHPbf7hDhzjJ
         STh5JYJW/9eKcRPLT/qoJyMnZQtulE5C6/ynMg+X7DdB3t83ElkHLbgFCTEi6voA9V9u
         2I+Q4wzj3j+xbyw7bVW8pL7GYe/yQi+o8p3lQwPu+zE0cUd0ZT3cPrDGcY31nwr510bC
         yJI0V3SQmJdnTUs9Ge7f2UCDlF5q7qQuUWifzASBVOF+6VEZHRfzkZwIUiuzPYzOfL00
         72Xw==
X-Gm-Message-State: ANoB5pllN7eszhS5za1U9XTUvIx4kah8SAW6E/gmbl1h6LohC3qxsIGQ
	DNCPO23bDF913Rv6Gz5APut/bgxNj54SjQ==
X-Google-Smtp-Source: AA0mqf63Cfx6DN4ieT70IkDlzzYu/aJCUI5CVTk21hXSBeKgLZNTwJo7rTYDppkPPNMBI3gzxSB1qg==
X-Received: by 2002:a17:903:22c4:b0:184:cb7e:ba36 with SMTP id y4-20020a17090322c400b00184cb7eba36mr51321205plg.57.1669974930149;
        Fri, 02 Dec 2022 01:55:30 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419? ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id 133-20020a62148b000000b0056c3a0dc65fsm4675471pfu.71.2022.12.02.01.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 01:55:29 -0800 (PST)
Message-ID: <d54e7e38-cdf6-ef5d-a6e6-e30ad8a59034@gmail.com>
Date: Fri, 2 Dec 2022 18:55:24 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Sven Peter <sven@svenpeter.dev>,
 Hector Martin <marcan@marcan.st>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org>
 <50499ee9-33fe-4f5d-9d0a-76ceef038333@daynix.com>
 <87lenqu37t.wl-maz@kernel.org>
 <525ff263-90b3-5b12-da31-171b09f9ad1b@daynix.com>
 <87h6yeta8b.wl-maz@kernel.org>
From: Akihiko Odaki <akihiko.odaki@gmail.com>
In-Reply-To: <87h6yeta8b.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221202095524.tDvoo4Mg9FRq5fOhbCUTWMiYAnLNl_zBGgPb8G-NGEs@z>

On 2022/12/02 18:40, Marc Zyngier wrote:
> On Fri, 02 Dec 2022 05:17:12 +0000,
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>>>> On M2 MacBook Air, I have seen no other difference in standard ID
>>>> registers and CCSIDRs are exceptions. Perhaps Apple designed this way
>>>> so that macOS's Hypervisor can freely migrate vCPU, but I can't assure
>>>> that without more analysis. This is still enough to migrate vCPU
>>>> running Linux at least.
>>>
>>> I guess that MacOS hides more of the underlying HW than KVM does. And
>>> KVM definitely doesn't hide the MIDR_EL1 registers, which *are*
>>> different between the two clusters.
>>
>> It seems KVM stores a MIDR value of a CPU and reuse it as "invariant"
>> value for ioctls while it exposes the MIDR value each physical CPU
>> owns to vCPU.
> 
> This only affects the VMM though, and not the guest which sees the
> MIDR of the CPU it runs on. The problem is that at short of pinning
> the vcpus, you don't know where they will run. So any value is fair
> game.

Yes, my concern is that VMM can be confused if it sees something 
different from what the guest on the vCPU sees.

>> crosvm uses KVM on big.LITTLE processors by pinning
>> vCPU to physical CPU, and it is a real-world application which needs
>> to be supported.
>>
>> For an application like crosvm, you would expect the vCPU thread gets
>> the MIDR value of the physical CPU which the thread is pinned to when
>> it calls ioctl, but it can get one of another arbitrary CPU in
>> reality.
> 
> No. It will get the MIDR of the CPU it runs on. Check again. What you
> describing above is solely for userspace.

By "ioctl", I meant the value the VMM gets for the vCPU thread. The 
problem is that the guest on the vCPU and the VMM issuing ioctl on the 
same thread can see different values, and it doesn't seem quite right.

>> ...or we may just say the value of MPIDR_EL0 (and possibly other
> 
> I assume you meant MIDR_EL1 here, as MPIDR_EL1 is something else (and
> it has no _EL0 equivalent).

Yes, I meant MIDR_EL1.

> 
>> "invariant" registers) exposed via ioctl are useless and deprecated.
> 
> Useless? Not really. The all are meaningful to the guest, and a change
> there will cause issues.
> 
> CTR_EL0 must, for example, be an invariant. Otherwise, you need to
> trap all the CMOs when the {I,D}minLine values that are restored from
> userspace are bigger than the ones the HW has. Even worse, when the
> DIC/IDC bits are set from userspace while the HW has them cleared: you
> cannot mitigate that one, and you'll end up with memory corruption.
> 
> I've been toying with the idea of exposing to guests the list of
> MIDR/REVIDR the guest is allowed to run on, as a PV service. This
> would allow that guest to enable all the mitigations it wants in one
> go.
> 
> Not sure I have time for this at the moment, but that'd be something
> to explore.
> 
> [...]

I meant that the values exposed to the VMM via ioctls does not seem 
useful. They still need to be exposed to the guest as you say.

Regards,
Akihiko Odaki
