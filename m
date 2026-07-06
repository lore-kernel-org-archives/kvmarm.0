Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340392D780C
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783373487; cv=none; b=ci/+iiFGpZ40rQooHvRGRgYGK1GoOiMjjRIPrO+qddWoCIQZ5w1jjqX9R6OVhAPH+sZ05hCf7Y01dhaWa6ymzKVtXjL2VNwO8UHU6ZuBbZQJTz5RWRUMjMeuszwjT0jwq14L05KrbStTorp1dDIiX5fdPwEqebacqxqUAZxhSTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783373487; c=relaxed/simple;
	bh=KNBWdwrXuVuLe1pGgzoYnnrur2xfF1tee4C4t7SlKBI=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=J8I7HL1AILwdNiTYsuVQYoA+5RTwNn9+gxek75doaZgDttV1KplL50w81v7UZy1cB0BcxepNgHV/yA66AZh3WmeVUaQaYFVHbgK0jwtwkKDSR0k8KAOtqYxrDkGc2/dVJgSc3Sebb9OyJbobfUR34xBZSd1gOIuZAcuI42pxZ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OwmPPM9j; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OwmPPM9j"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7e9e2db9914so8466a34.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 14:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783373484; x=1783978284; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wrEtuZnNKTHhXzzXH6FBZuUyiD4QdjI7aUV2ges9QRI=;
        b=OwmPPM9jtwdXw2F0YEStcGwszi8a1rlrAhkOkMy354jQDZB8EgDDhqEc7OBdq98ZYx
         1USioEAKFFNO1KLR7TLlm6zVNk6ss3ibXheCrA2XK/cnt5q2R4hz29T7Tj9jMs5MipsU
         JkzRNHkaq6xheoKWad8iJS77BVDOgsibJoH8jp2iw31IGEn7/+amsNi19UduOYUSLtP4
         pp1c65E8giws7kTtCrb4u4mJCWAXA6BjKu0Pu7bOvB0O2JlVWyahjl3RF6y9T6Hjp2Un
         J4eE1dUqb8vg870LEha5CuqVuh+TFIRHrSfrKR3cflzuVPiBxKPdZI7Z0M4pMP0s6hsQ
         tn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783373484; x=1783978284;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wrEtuZnNKTHhXzzXH6FBZuUyiD4QdjI7aUV2ges9QRI=;
        b=tEdmOUa9fWz8knM1gbz2y0S/IXV5A5DldjuPu5w6dw5a3+wZbAhDY8U5X9hF248BkY
         j3D/TC8jdtjx3DoPCkcgD52z8llXeZjjaUsSPkj3nJDxQenUSFymqZ1sZWscyYa4Z0r8
         64PiM3q/bHHxSwcl2dqCk7NqI9Sdm0jivsjDBTsHocU23f+4BS3URu2wMAGlmu+Wml01
         IXzCU053GB3fHwlAPmCb4d7DuHkL2ExfWPSFy7Kn8aWprqkM2DdWoyfEgAmw1jEd9xgc
         G5R2UcJbR2Hf/90xdSAGSO/OzmESe1sF4eOcVxEQ850o9RTTO6x8JpyIZ54iC5Om0qkg
         qUvQ==
X-Forwarded-Encrypted: i=1; AFNElJ/R9VdCE4R44cDF+1ceyAKJON4kcvLVgAYvzsZe1kBDB2rfojX5bvv04vh1o21h4lMYX/HOHT0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfenjCLQKGflvROIKWUObjbJ981DGitRPwQ07Hb3+T0Okri9NQ
	9NWZZ3y/kBlaYsEfV1hAE0YKHnR4J8EKDLBDw4jTkAtjRDXXKvEPF9vlLFReKyH7ThPMmUmp0Si
	fAiRyPW7o1XlrZZ8QpmFNdf4N0Q==
X-Received: from ioel1.prod.google.com ([2002:a05:6602:2761:b0:9a7:ea8a:6db6])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:c92:b0:6a1:93a5:cd70 with SMTP id 006d021491bc7-6a35c45cbfbmr12190eaf.31.1783373483917;
 Mon, 06 Jul 2026 14:31:23 -0700 (PDT)
Date: Mon, 06 Jul 2026 21:31:22 +0000
In-Reply-To: <akWhad3U5VNjWzxu@kernel.org> (message from Oliver Upton on Wed,
 1 Jul 2026 16:23:21 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntqzlf6c0l.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 0/5] Backport ARM64 VHE boot fixes to 6.6.y
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: stable@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mizhang@google.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Oliver, thanks for reviewing.

Oliver Upton <oupton@kernel.org> writes:

> The subject prefix should be "[PATCH 6.6 0/5]" so people know right up
> front where this is going.

I'll make sure to include that in the subject.


> On Wed, Jul 01, 2026 at 08:43:37PM +0000, Colton Lewis wrote:
>> This series backports VHE CPU boot fixes to the 6.6.y stable branch.

>> These fixes are already present in the 6.12.y stable branch (and
>> newer), but are missing in 6.6.y. They are required to enable booting
>> L1 guests with nested virtualization enabled (kvm-arm.mode=nested).

> It's a bit worse than this. The architecture retroactively made
> FEAT_E2H0 an optional feature, there are now implementations in the wild
> that do not support the feature.

Good to know. I'll include that context in my next cover letter.

>> Without these patches, a 6.6.y guest boots with HCR_EL2.E2H
>> incorrectly configured (because it misses VHE-only detection or early
>> initialization), causing early boot hangs/trap loops.

>> Conflict resolutions:
>> - Patch 4 (KVM: arm64: Initialize HCR_EL2.E2H early) had conflicts in
>>    arch/arm64/kvm/hyp/nvhe/hyp-init.S due to differences in state
>>    initialization. Resolved by extracting EL2 state initialization into
>>    __kvm_init_el2_state.
>> - Patch 5 (arm64: Revamp HCR_EL2.E2H RES1 detection) had conflicts in
>>    arch/arm64/include/asm/el2_setup.h. Resolved by using raw msr hcr_el2
>>    instead of the missing msr_hcr_el2 macro.


>> Marc Zyngier (4):
>>    arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
>>    arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is
>>      negative
>>    arm64: Fix early handling of FEAT_E2H0 not being implemented
>>    arm64: Revamp HCR_EL2.E2H RES1 detection

>> Mark Rutland (1):
>>    KVM: arm64: Initialize HCR_EL2.E2H early

>>   arch/arm64/include/asm/el2_setup.h | 52 ++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/head.S           | 17 +++-------
>>   arch/arm64/kvm/hyp/nvhe/hyp-init.S | 16 +++++++--
>>   arch/arm64/tools/sysreg            | 37 +++++++++++++++++++++
>>   4 files changed, 107 insertions(+), 15 deletions(-)


>> base-commit: d1cfde2d5d15be14123bdd1689162bd27f995a90
>> --
>> 2.55.0.rc2.803.g1fd1e6609c-goog

