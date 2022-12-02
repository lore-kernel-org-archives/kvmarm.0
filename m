Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88CBC4321E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 15:54:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B7B949E4B;
	Fri,  2 Dec 2022 10:54:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lt3Ug75B3Pfi; Fri,  2 Dec 2022 10:54:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E7049E34;
	Fri,  2 Dec 2022 10:54:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DC9C40C88
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 04:55:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b82iFadsVZE6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 04:55:31 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E433403C2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 04:55:31 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id q15so3407483pja.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Dec 2022 01:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
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
 b=nkY7yvKUhEOnxbHdKbGBnUaKtPDTamp5NaeQA49gfOSf98b7JISKfR7j611v/R0iBy
 4xKoaMM5vqyHsFI6Ps/aM8uVLr8yB84+2oq+dRiUvQwFPWtqqH6UCuOPREikuAo/xHY2
 nAhgdROc/D13kMx46P9S1ntrQ/0hWvHFesgmDwAoNk75odw7j2a6gFmhWghh4aSUumxI
 542Wj3SPZK3r0e0Xqv6FpQt3JfMUStIFDnwoWnPy+HjPyhtsWCeZSllaD2LZO9YXYlla
 rp4MF9W0mFIX1PAuEJDSL7AjrOde+PB4SGII5qbGWEQa05lX7csUO0GKz0M3EwKaehOs
 Qjgw==
X-Gm-Message-State: ANoB5pmdIYJQASFygpqAngv6SYECbYwKvVNhC7heM9z7ChY7Jj0wx1qp
 SJKYXxAp+kyFRRnzdTXSMHk=
X-Google-Smtp-Source: AA0mqf63Cfx6DN4ieT70IkDlzzYu/aJCUI5CVTk21hXSBeKgLZNTwJo7rTYDppkPPNMBI3gzxSB1qg==
X-Received: by 2002:a17:903:22c4:b0:184:cb7e:ba36 with SMTP id
 y4-20020a17090322c400b00184cb7eba36mr51321205plg.57.1669974930149; 
 Fri, 02 Dec 2022 01:55:30 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419?
 ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 133-20020a62148b000000b0056c3a0dc65fsm4675471pfu.71.2022.12.02.01.55.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Dec 2022 01:55:29 -0800 (PST)
Message-ID: <d54e7e38-cdf6-ef5d-a6e6-e30ad8a59034@gmail.com>
Date: Fri, 2 Dec 2022 18:55:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org>
 <50499ee9-33fe-4f5d-9d0a-76ceef038333@daynix.com>
 <87lenqu37t.wl-maz@kernel.org>
 <525ff263-90b3-5b12-da31-171b09f9ad1b@daynix.com>
 <87h6yeta8b.wl-maz@kernel.org>
From: Akihiko Odaki <akihiko.odaki@gmail.com>
In-Reply-To: <87h6yeta8b.wl-maz@kernel.org>
X-Mailman-Approved-At: Fri, 02 Dec 2022 10:54:09 -0500
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Will Deacon <will@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
