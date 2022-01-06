Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3BCC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 17:20:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD6154B229;
	Thu,  6 Jan 2022 12:20:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TiDuk4oTU4PZ; Thu,  6 Jan 2022 12:20:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1E424B20F;
	Thu,  6 Jan 2022 12:20:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A63434B21E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 12:20:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QbmsvVd4czcE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jan 2022 12:20:36 -0500 (EST)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85E6E4B1F6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 12:20:36 -0500 (EST)
Received: by mail-pj1-f52.google.com with SMTP id pj2so1808121pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Jan 2022 09:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=UboDS31gi+6ezClBOANA8GrTYVa4ZNE97bilfoocy74=;
 b=n8ND/Yh2Aeh4upIOJUX6ItnoxdWH4/Fia63ZyKT+f9mMggMYBq+9LfDPbDYY6p6hKX
 zHSrMN2J9ulhYOs6eohgALG0aYLSdzT0x4fN0iTgAuxPFmeiJSW05vwzDiLtmUyDsz9C
 yCWEvtTzuR1o22D1y7a+jpQdXW5LsIpvs3bgtkWYLR6wwLr+p9FDdUDr99Wm984tpH7x
 0ATdeQQYJq/2e/0/o3sYf2qNZtTpVyGUn3jV8kFjk/c7SUjbPtaqt3XosRDBGK9Hp0Hr
 8q3I2+rE3Et28u7+6BdinfGw7WG70PnKcoJy/odrOJJ73K/AeulTRHnqjLQ3PUvXTeHm
 Givw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=UboDS31gi+6ezClBOANA8GrTYVa4ZNE97bilfoocy74=;
 b=jHBX8Hfga8/RUtZfzYgCukTkKEgWJSsUlKNuzYzH83IBbJ4vWgDdUEk7X+M3P8r7ry
 wT/AD7h0M1Xrty7RQSm96Oy3mGvlKBN88qrMR7SX1cuRf2zJxJ8mzOJUdD7NmEMzZLXF
 zdnvWjAdrZ2NF4l6za6WD5B9MKp6WmpYZD/fEdomXlQqyFdbRh8mM96GeEnkz3th8vtA
 bpMp2zO1G8ilWWT63ab2xUsXpRXADseqXmNbF7afYY8iVPuzNbuRKqy5RPM+ZZYCvFEU
 AJjkD6UH6rxafdRpyJXRcRcK+lKxaQg62hJRJnyfYxvV2DbMiWVh1fPTSvehub7OJTSW
 eLww==
X-Gm-Message-State: AOAM533pCGBauhAIAe2UX1E7J82z4fMrH/q3vU342lKI5C/QZVLbJ60M
 ETsBsSFFyB/2lTGwMcmBuj8Ocg==
X-Google-Smtp-Source: ABdhPJzlaKrZaIdz6LGH8kAr0gek22yp7m1zrUEHpl6K7zWOYBVHmwMbe6AvXQgA3sBeLh2fKPBozQ==
X-Received: by 2002:a17:90b:198d:: with SMTP id
 mv13mr11366930pjb.182.1641489635507; 
 Thu, 06 Jan 2022 09:20:35 -0800 (PST)
Received: from [192.168.1.13] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
 by smtp.gmail.com with ESMTPSA id y3sm2890860pju.37.2022.01.06.09.20.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 06 Jan 2022 09:20:35 -0800 (PST)
Subject: Re: [PATCH v2] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
To: Marc Zyngier <maz@kernel.org>
References: <20220103180507.2190429-1-maz@kernel.org>
 <c5bedb8e-55e3-877f-31aa-92d59e5aba34@linaro.org>
 <87czl5usvb.wl-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <3db95713-2f05-3c70-82b1-7e12c579d3e2@linaro.org>
Date: Thu, 6 Jan 2022 09:20:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87czl5usvb.wl-maz@kernel.org>
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

On 1/6/22 1:16 AM, Marc Zyngier wrote:
>>> +static bool kvm_arm_pauth_supported(void)
>>> +{
>>> +    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
>>> +            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
>>> +}
>>
>> Do we really need to have them both set to play the game?  Given that
>> the only thing that happens is that we disable whatever host support
>> exists, can we have "pauth enabled" mean whatever subset the host has?
> 
> The host will always expose either both features or none, and that's
> part of the ABI. From the bit of kernel documentation located in
> Documentation/virt/kvm/api.rst:
> 
> <quote>
> 4.82 KVM_ARM_VCPU_INIT
> ----------------------
> [...]
>          - KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>            for arm64 only.
>            Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
>            If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
>            both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>            KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
>            requested.
> 
>          - KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>            for arm64 only.
>            Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
>            If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
>            both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>            KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
>            requested.
> </quote>
> 
> KVM will reject the initialisation if only one of the features is
> requested, so checking and enabling both makes sense to me.

Well, no, that's not what that says.  It says that *if* both host flags are set, then both 
guest flags must be set or both unset.

It's probably all academic anyway, because I can't actually imagine a vendor implementing 
ADDR and not GENERIC, but in theory we ought to be able to support a host with only ADDR.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
