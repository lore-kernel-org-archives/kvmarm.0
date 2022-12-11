Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E70C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 11 Dec 2022 10:44:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2CC4BEB9;
	Sun, 11 Dec 2022 05:44:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4gav5sco9T64; Sun, 11 Dec 2022 05:44:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40CE84BF06;
	Sun, 11 Dec 2022 05:44:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C928F4BD0E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 05:44:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9fxt2GrVx-w1 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Dec 2022 05:44:44 -0500 (EST)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71C7E4BCFC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 05:44:44 -0500 (EST)
Received: by mail-pg1-f180.google.com with SMTP id 62so6350706pgb.13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 02:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=CSYO6GAYJ35zt05esIXClHwHgXyrpJY8FQ1q/9ql0Ik=;
 b=o8yWru14C7LAzgaEbMCM+XlM98edDtEjBJPRlbubJWIzppNLaaX4IYJMTKwGUG90MW
 1REzJ5zSA561ChWvAAksM6ZLtUFd1TMXfPcKXADZ4aLFl10YnuJLMw7ZZrMj2rA8tsKC
 BZUt57ieMxpp+sc1+HLFT7sNyrpJ5vidumnuetBlem3ytR/xQrPMPuaYn6/UAZmQyAnj
 tZ7BkkauRszeNLXTU2/deWIMM/ew/3ZniXljE8mobJBWBePT2+oQ9cjYAXiLxdRFnvIq
 9sWEOtSZ03Dd/Wu2hseMWqkSNdO9RJJtMIy9rt1VekUTK/5NurSapCckdpKFdXSL+t2r
 Eb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=CSYO6GAYJ35zt05esIXClHwHgXyrpJY8FQ1q/9ql0Ik=;
 b=62lNeAn+OsUghKioP2n/sUNewyCdGiwQ+ns04DMHHEKN7uQFX7N2yzTB/7n69qnDPI
 X1agxOrEZfSyH24nhSxbanu56PLHSULvBCmwAXNYMyxnX/ox8vJoia+8OoUudN6j0lVG
 GD4/i77VEFNfGQhBwF6v9IRuys/zLS9kVukVOhk6lJmP25yvm6cicdCoUaPJYLWPx/Wz
 zG4HeGEnPpCiOzwlwlLvz80Ik3yMbXyzuAu3zBLzCLTe/fVmo1sWw698RXKi/J0Xv/cj
 GfsJomFz6NC11saad7BF2gSLb9fmMJxFEsAxeJ2y5uQnpHypcl0HnFOz0pkkrJhf07Wl
 fhYQ==
X-Gm-Message-State: ANoB5plRco3T11uraa3ymJfboxH0yNB1UKncDitTnbBKUL0Eb7xDdsxY
 zduKNLg8oQTM0oWScfXTB1DEwA==
X-Google-Smtp-Source: AA0mqf5eX2lf/4q7qzuxUq3FEVAm6RQVyQCcLkQOi+sgu7W9izRnftAzN2PHf6Ua2g5Wuza37Ubw2A==
X-Received: by 2002:aa7:8492:0:b0:576:ebfe:e9c1 with SMTP id
 u18-20020aa78492000000b00576ebfee9c1mr11487490pfn.20.1670755483463; 
 Sun, 11 Dec 2022 02:44:43 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:7b99:f7c3:d084:f1e2?
 ([2400:4050:c360:8200:7b99:f7c3:d084:f1e2])
 by smtp.gmail.com with ESMTPSA id
 r7-20020aa79ec7000000b005765df21e68sm3949433pfq.94.2022.12.11.02.44.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 11 Dec 2022 02:44:43 -0800 (PST)
Message-ID: <634e1d66-12f5-0b6c-7917-dc7982072711@daynix.com>
Date: Sun, 11 Dec 2022 19:44:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
To: Marc Zyngier <maz@kernel.org>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org>
 <50499ee9-33fe-4f5d-9d0a-76ceef038333@daynix.com>
 <87lenqu37t.wl-maz@kernel.org>
 <525ff263-90b3-5b12-da31-171b09f9ad1b@daynix.com>
 <87h6yeta8b.wl-maz@kernel.org>
 <d54e7e38-cdf6-ef5d-a6e6-e30ad8a59034@gmail.com>
 <87bkojtdvy.wl-maz@kernel.org>
 <88bdcca8-4df4-15ff-2e88-c53255b1fe30@daynix.com>
 <868rjeqm0d.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <868rjeqm0d.wl-maz@kernel.org>
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Will Deacon <will@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 asahi@lists.linux.dev, Akihiko Odaki <akihiko.odaki@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2022/12/11 19:21, Marc Zyngier wrote:
> On Sun, 11 Dec 2022 05:25:31 +0000,
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2022/12/04 23:57, Marc Zyngier wrote:
>>> On Fri, 02 Dec 2022 09:55:24 +0000,
>>> Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
>>>>
>>>> On 2022/12/02 18:40, Marc Zyngier wrote:
>>>>> On Fri, 02 Dec 2022 05:17:12 +0000,
>>>>> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>>>
>>>>>>>> On M2 MacBook Air, I have seen no other difference in standard ID
>>>>>>>> registers and CCSIDRs are exceptions. Perhaps Apple designed this way
>>>>>>>> so that macOS's Hypervisor can freely migrate vCPU, but I can't assure
>>>>>>>> that without more analysis. This is still enough to migrate vCPU
>>>>>>>> running Linux at least.
>>>>>>>
>>>>>>> I guess that MacOS hides more of the underlying HW than KVM does. And
>>>>>>> KVM definitely doesn't hide the MIDR_EL1 registers, which *are*
>>>>>>> different between the two clusters.
>>>>>>
>>>>>> It seems KVM stores a MIDR value of a CPU and reuse it as "invariant"
>>>>>> value for ioctls while it exposes the MIDR value each physical CPU
>>>>>> owns to vCPU.
>>>>>
>>>>> This only affects the VMM though, and not the guest which sees the
>>>>> MIDR of the CPU it runs on. The problem is that at short of pinning
>>>>> the vcpus, you don't know where they will run. So any value is fair
>>>>> game.
>>>>
>>>> Yes, my concern is that VMM can be confused if it sees something
>>>> different from what the guest on the vCPU sees.
>>>
>>> Well, this has been part of the ABI for about 10 years, since Rusty
>>> introduced this notion of invariant, so userspace is already working
>>> around it if that's an actual issue.
>>
>> In that case, I think it is better to document that the interface is
>> not working properly and deprecated.
> 
> This means nothing. Deprecating an API doesn't mean we don't support
> it and doesn't solve any issue for existing userspace.
> 
> I'd rather not change anything, TBH. Existing userspace already knows
> how to deal with this,
> 
>>
>>>
>>> This would be easily addressed though, and shouldn't result in any
>>> issue. The following should do the trick (only lightly tested on an
>>> M1).
>>
>> This can be problematic when restoring vcpu state saved with the old
>> kernel. A possible solution is to allow the userspace to overwrite
>> MIDR_EL1 as proposed for CCSIDR_EL1.
> 
> That would break most guests for obvious reasons. At best what can be
> done is to make the MIDR WI.

Making MIDR WI sounds good to me. Either keeping the current behavior or 
making it WI, the behavior is better to be documented, I think. The 
documentation obviously does not help running existing userspace code 
but will be helpful when writing new userspace code or understanding how 
existing userspace code works.

Regards,
Akihiko Odaki

> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
