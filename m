Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04217274FE3
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778677407; cv=none; b=p/wiul1iRC9f00gUB/A1fe87rmqG7n1i/Mk0AOPYkc2Gn0hI5yrHtiT2ah1cOcRuxQ+RFC9LDvVI4/BIYSn7pmlEdujocDEuoL1+fL5blq8WjTzOpk9+V3e5sUKs9rRsRt8a7C9rnjZVAT+0U7tzHTKZEU78PiWdxzHP3l6uA6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778677407; c=relaxed/simple;
	bh=47RwooVING59/ooQWdA7SNr7Zs32TKeNO1snt4GymBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isgLppsCbOwoudC2cnFoOYFO2lD1hgNxtV/omI0yOgDeiz8J/A6U/6W6I47/EiiDQ4RB7nQslHG4Z4Bi3aTqVKil35w0CQ1mz6TIayyWv43tq6SGs+iqT2xZ/iMYiE4OFw8ONcyP9+GpahIBrdUp4cRvVfIxPViIkN2taKih/g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sh+jvyOV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sh+jvyOV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778677405;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=47RwooVING59/ooQWdA7SNr7Zs32TKeNO1snt4GymBg=;
	b=Sh+jvyOV6L/5Zzneg8gthRT3BPLvAe5HBY7Vt9iFnqP2rM2HQLZ5sXRF1lKAhKwKqKJiTH
	gqb3oZQ9PHuqZ0JYnD1Wzh5AHs08lnG8MS9OXX9hNScsIS7JzVk2jVXnQ0rUGc3WQkwTC4
	h21AFncJDuLTmjk7pnlMc780cJ44LXg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-NbmLJ-a_NLWoTHF1Cbo43A-1; Wed, 13 May 2026 09:03:21 -0400
X-MC-Unique: NbmLJ-a_NLWoTHF1Cbo43A-1
X-Mimecast-MFC-AGG-ID: NbmLJ-a_NLWoTHF1Cbo43A_1778677401
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48fd0f1ef7dso4648465e9.3
        for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 06:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677400; x=1779282200;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47RwooVING59/ooQWdA7SNr7Zs32TKeNO1snt4GymBg=;
        b=EMdu7DYOa/odJqjIZGGTYTL5cS59cRiyeDxISzHhcQ5yF8Us047NoZghJMBfQc1jF0
         XkHqN+9TsB9RCWN2TX2LnXouS79sBXRDg4A1Di+GTUCfkuApEb59LBrw5quZsvBsRpu1
         /WZHPcJcGV7PMK9vBNdYaXe5jwFUfnVIRx2w0qq+8rlVfPbq/xv2a0HiqY9w62lmVii6
         sXbKp2LeQG8YRLhqqed8wnH+v0b7y1GWYts5PRwhtXERy3hGItRrzdJ5+2Apni128VwW
         8jZTZ5IS2WWlwM0OvriV75d+ATkyZjMpycWPDvOD1t1rdpMsMWhiC/DPedPtu1ZYFwzG
         Muew==
X-Forwarded-Encrypted: i=1; AFNElJ9G+yV3xlGONb7sZY8WNfhJNVgBxxe1CzwMER9RwP2SInEWocWzTLLG/LxwoFPwLgBu7LIhRbA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxr1xEifPEq3OwPjJ8hqjBAYvJw3hPoO6meA9JN97RimqUohiR3
	QMAYF9FbjubXfWJgzMWFxrpoLR7ctUeWjwQjXrHoZ5LjtFMHp7lh3RwXNpS7GdATVCBEPdRA149
	ezfUq5bZ1T+W0SaAABpuGVm1Q3vy+hfDGl5xRc7RQCvI08FXqSCdVSjP/4g==
X-Gm-Gg: Acq92OE5VuQudweRJLNHlvjmoo3TVx5CneltN17GRv62zwNwrnyZeBO1suuKuasUIzD
	ajgsubnrEXGXs9qXX7uVz15BY5Agvx/ef/ZegnM78Uq2a9oap6zMuk7Emor4PfuyV9oOqXKMta+
	iljQy2+mJDOiGsKtcngfbst4dHwp4iBuLWUsR9f3SHG9/b8+7Us95VVMpSuRrSKuoyvIPjwopan
	0V48FgqLG90TSuZtoz7+n7N/NYIZuKh5HmFotyN2IoJfYYc7+vvSK4OT5fewWWglKpb6/xWPOA/
	xr/Y5N2yzKJlpYAGoVvsAmT8Q2SUUoHhnOLG404SsENKP3zxzW3F1KQZnYljAagjXvkvFJTpDJ6
	RLqCUVf81VoDRZvtvwaM/zuWwRMcN8o60MS/qH+6F3H91Pz68BfkStCYu6gywhmg3yAMVVg==
X-Received: by 2002:a05:600c:19cd:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-48fce9e1a34mr42450515e9.19.1778677400537;
        Wed, 13 May 2026 06:03:20 -0700 (PDT)
X-Received: by 2002:a05:600c:19cd:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-48fce9e1a34mr42449655e9.19.1778677399778;
        Wed, 13 May 2026 06:03:19 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4549120f1f9sm41638565f8f.24.2026.05.13.06.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 06:03:19 -0700 (PDT)
Message-ID: <c3848d24-f924-497b-b5e7-3ef3a07c3a6b@redhat.com>
Date: Wed, 13 May 2026 15:03:16 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility
 expectations
To: Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Marc Zyngier <maz@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>, Kees Cook <kees@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com>
 <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com>
 <86h5obya2r.wl-maz@kernel.org>
 <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
 <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: buSO9AuoMY0sil29oPF5k261gu0q4Nwc2i26FAuPz-0_1778677401
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 5/13/26 2:43 PM, Paolo Bonzini wrote:
> On 5/13/26 11:24, David Woodhouse wrote:
>> On Wed, 2026-05-13 at 09:42 +0100, Marc Zyngier wrote:
>>> If userspace is not a total joke, it will read all the ID registers,
>>> and configure what it wants to see, assuming it is a feature that can
>>> be configured (not everything can, because the architecture itself is
>>> not fully backward compatible).
>>>
>>> Yes, this is buggy at times, because the combinatorial explosion of
>>> CPU capabilities and supported features makes it pretty hard to test
>>> (and really nobody actually does). But overall, it works, and QEMU is
>>> growing an infrastructure to manage it in a "user friendly" way.
>>
>> Yes, that is precisely what I'm asking for. I'm prepared to deal with
>> the fact that KVM/Arm64 is not a stable and mature platform like x86
>> is, and that userspace has to find all the random changes from one
>> version to the next, and explicitly pin things down to be compatible.
>>
>> All I'm asking for is that KVM makes it *possible* to pin things down
>> to the behaviour of previously released Linux/KVM kernels.
>>
>>> But really, this isn't what David is asking. He's demanding "bug for
>>> bug" compatibility. For that, we have two possible cases:
>>
>> No, I am not asking you to meet that bar. I merely observed that x86
>> does and that it would be nice. But we are a *long* way from that.
>
> x86 doesn't do bug-for-bug compatibility, thankfully - we have quirks
> but only 11 of them, or about one per year since we started adding
> them.  We only add quirks, generally speaking, when 1) we change the
> way file descriptors are initialized, 2) guests in the wild were
> relying on it, or 3) it prevends restoring state saved from an old
> kernel.  Is there anything else?
>
> So you're asking something not really far from this:
>
>>> - this is a behaviour that is not allowed by the architecture: we fix
>>>    it for good. We do that on every release. Some minor, some much more
>>>    visible. And there is no way we will add this sort of "bring the
>>>    bugs back" type of behaviours. Specially when it is really obvious
>>>    that no SW can make any reasonable use of the defect. We allow
>>>    userspace to keep behaving as before, but the guest will not see a
>>>    non-compliant behaviour.
>
> ... where for example
> https://lore.kernel.org/kvm/e03f092dfbb7d391a6bf2797ba01e122ba080bcd.camel@infradead.org/
> is an example of a bug that "no SW can make any reasonable use of".
>
>> Marc, this is complete nonsense and you should know better.
>> Once a behaviour is present in a released version of Linux/KVM, we
>> can't just declare it "wrong" and unilaterally impose a change in
>> guest-visible behaviour on *running* guests as a side-effect of a
>> kernel upgrade.
>>
>> The criterion for *KVM* to remain compatible is "once it has been in a
>> released version of the kernel". Not "once it is in the architecture".
>
> That is *also* obviously nonsense though, isn't it (see example
> above)? The truth is in the middle, "once it is in the architecture"
> is likely too narrow but "once it is in a Linux release" is way too
> broad.  And besides, both miss the point of *configurability* which is
> the basis of it all.
>
> The main difference between x86 and Arm is the default state at
> creation; x86 defaults to a blank slate, mostly; and when we didn't do
> that, we regretted it later (cue the STUFF_FEATURE_MSRS quirk).  It's
> too late to change the behavior for Arm, but I think we can agree that
> patches such as
> https://lore.kernel.org/kvm/20260511113558.3325004-2-dwmw2@infradead.org/
> ("KVM: arm64: vgic: Allow userspace to set IIDR revision 1") are what
> the letter and spirit of this proposal is about.
>
> Marc did not mention having to deal with guests in the wild.  Let's
> ignore it for now because even defining "guests in the wild" is hard;
> and anyway it's not related to the patch that triggered the discussion.
>
> So we have the third case, "restoring state saved from an old kernel".
> If this case arises, I do believe that Arm will have to deal with it
> and introduce quirks or KVM_GET/SET_REG hacks.  Maybe it hasn't
> happened yet, lucky you. 

for info, this qemu series was merged laterly.

[PATCH v10 0/7] Mitigation of "failed to load
cpu:cpreg_vmstate_array_len" migration failures <https://lore.kernel.org/all/20260420140552.104369-1-eric.auger@redhat.com/#r>
https://lore.kernel.org/all/20260420140552.104369-1-eric.auger@redhat.com/#r

It brings an infrastructure to mitigate some migration failures accross different kernel versions.

Also there is [PATCH v4 00/17] kvm/arm: Introduce a customizable aarch64 KVM host model, under review
https://lore.kernel.org/all/20260503073541.790215-1-eric.auger@redhat.com/

This series aims at beeing able to offer the capacity to set writable ID regs on the host passthrough vcpu model.

Thanks

Eric


>
> Overall, even if we may disagree about the details, are we really on
> terribly distant grounds, or are we not?
>
> Paolo
>

