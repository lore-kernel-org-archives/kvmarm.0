Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654A2C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 18:26:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E40CF4B230;
	Thu,  6 Jan 2022 13:26:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Tlqz6CZfX4q; Thu,  6 Jan 2022 13:26:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6104B211;
	Thu,  6 Jan 2022 13:26:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A034B202
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 13:26:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 62J0iGQ1Yhns for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jan 2022 13:26:31 -0500 (EST)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE18C4B1F4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 13:26:31 -0500 (EST)
Received: by mail-pj1-f42.google.com with SMTP id
 r14-20020a17090b050e00b001b3548a4250so1112399pjz.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Jan 2022 10:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=HlaWOyLJWUxC/fcMDwyvfjC8xT8OixmJxKEiGSjvP78=;
 b=wnYu2Su9FUNALxqI5H57lVrouxwCAxjS9z9uEp0cHC5tBU9whcr8F+OGJwvsPlpB1c
 k0tlBUjFz2sOB95QW9wG2x3zBrquvqrafRV4ZkIkrk7JYXTKrRFdpUU12s84soPbOmwj
 wusCLLM5bU/UrpBMtNmJD1pknx6bc4ytVUxW//VVKqjZP3lZ840xYsfEEsmsE66OwnFl
 IUKqtEDsGGC89wRoLwE972yS+Yt/8aYGHJDswJxBt+QU9oHR2O7tDplNFVyvtErZKpGc
 mcGyO4buYHutNvSG9+Osf1VGUVgt0ywDZGZkJxfu7y2+lpd/ETIrYa6Qhj/lGlo00rDp
 A8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=HlaWOyLJWUxC/fcMDwyvfjC8xT8OixmJxKEiGSjvP78=;
 b=gWszoMIDfmLbcB59wiVNU+OwZsWz+dBtXEkd5x9aRjpMrlRwg9wrBcoJeKwzfgR4Xq
 wgmSOc3VMCyPET8f15u22FQLe6ssD6CG8DKQ5QLJxp+Sltb55J27IkLm/h9zvvXIoU7X
 YKnjYg+Oa98jIlTQ6WnnULfgu2F2kajOndA/zczFXB3jzAj1VO4nPZAYfJfeETFlH2Cg
 +UiLys2m/a9Qd9F9FSiY0BT7oaE3zsRok9NLfu0i89ClB1uYX8AitcOB2nR7NieE3V6t
 ip4aTxIemXMs4fm3H0+MNW6u1d1EqmkWjP9RyMACuZXB7evpcEuJUMg2byHp+GRDJR16
 ClXA==
X-Gm-Message-State: AOAM530IKmIwOf5gLwTXbO21VPUXg6yNQGaO48MXBiVcshrxGldF8HWz
 BHA2zNDd+NF/EYavDxBhQg0Rtg==
X-Google-Smtp-Source: ABdhPJxoQ3eVXISS6TugVeDxoCB53qQ/yNRF/WUAW9yzPhsSj1SmdwcZJEgtVSWbLiTQugXVAbFPpA==
X-Received: by 2002:a17:90a:f316:: with SMTP id
 ca22mr11527272pjb.171.1641493590872; 
 Thu, 06 Jan 2022 10:26:30 -0800 (PST)
Received: from [192.168.1.13] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
 by smtp.gmail.com with ESMTPSA id 72sm3129138pfu.70.2022.01.06.10.26.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 06 Jan 2022 10:26:30 -0800 (PST)
Subject: Re: [PATCH v2] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
To: Marc Zyngier <maz@kernel.org>
References: <20220103180507.2190429-1-maz@kernel.org>
 <c5bedb8e-55e3-877f-31aa-92d59e5aba34@linaro.org>
 <87czl5usvb.wl-maz@kernel.org>
 <3db95713-2f05-3c70-82b1-7e12c579d3e2@linaro.org>
 <875yqwvkm1.wl-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <364fc879-4b13-cf37-53e0-628a843c7bfa@linaro.org>
Date: Thu, 6 Jan 2022 10:26:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <875yqwvkm1.wl-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On 1/6/22 9:29 AM, Marc Zyngier wrote:
> On Thu, 06 Jan 2022 17:20:33 +0000,
> Richard Henderson <richard.henderson@linaro.org> wrote:
>>
>> On 1/6/22 1:16 AM, Marc Zyngier wrote:
>>>>> +static bool kvm_arm_pauth_supported(void)
>>>>> +{
>>>>> +    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
>>>>> +            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
>>>>> +}
>>>>
>>>> Do we really need to have them both set to play the game?  Given that
>>>> the only thing that happens is that we disable whatever host support
>>>> exists, can we have "pauth enabled" mean whatever subset the host has?
>>>
>>> The host will always expose either both features or none, and that's
>>> part of the ABI. From the bit of kernel documentation located in
>>> Documentation/virt/kvm/api.rst:
>>>
>>> <quote>
>>> 4.82 KVM_ARM_VCPU_INIT
>>> ----------------------
>>> [...]
>>>           - KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>>>             for arm64 only.
>>>             Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
>>>             If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
>>>             both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>>>             KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
>>>             requested.
>>>
>>>           - KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>>>             for arm64 only.
>>>             Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
>>>             If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
>>>             both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>>>             KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
>>>             requested.
>>> </quote>
>>>
>>> KVM will reject the initialisation if only one of the features is
>>> requested, so checking and enabling both makes sense to me.
>>
>> Well, no, that's not what that says.  It says that *if* both host
>> flags are set, then both guest flags must be set or both unset.
> 
> Indeed. But KVM never returns just one flag. It only exposes both or
> none.

Mm.  It does beg the question of why KVM exposes multiple bits.  If they must be tied, 
then it only serves to make the interface more complicated than necessary.  We would be 
better served to have a single bit to control all of PAuth.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
