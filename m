Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC74813AD22
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 19:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738871155; cv=none; b=O+4CxNFnBL8C8bQkGebMICZgZ/XhVWzxPy39pYITDWjMfGQQUpngxahmo7xdKjHKmgFaZXUM5WJIX2BIiSobkQArfRk133iM16Qh7/8eC8VfKPE1BfPfpMbOzrmmzR8+iPwa2ju732DCA/ZLR8zWJ+n6Zlx33mV3bhO7HP0EQKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738871155; c=relaxed/simple;
	bh=O8clXKgjHAQejc7bfuCl6bjXFk1Ed3RO/7mnGfiKBpU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Uz4jomqbvxI4jB1C+F2D9VWFeverZkqw5glCNJH/JFc+MR5uCYj1Wr8xijP5/kVjPwpjkTp10GwuZqM10rWfBnhFUj7K4Wj3ykFo9cxQhswrJChg8L2Mg+bZoiHUJeWLDeKU5vij7a+5QqB2vhiChoeOg7wbRGL3Cg6oFNIiEFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=osgrw3X5; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="osgrw3X5"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-844d5c7d664so93682539f.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Feb 2025 11:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738871152; x=1739475952; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YbCfEtYjJ8HgdzmC6edBJv5q8C9brW4RxPoXoV16zfg=;
        b=osgrw3X5hiy+4eYvIzXS3ssYZ9q3sI5CUJBN9VJYOQMekH7/Ltus7KQPUGATnaS5hh
         Xi04oF/BZBiVVl0HbTI+98bvkSIb5i9HyxGxsMw3S2VyOCWDriAVWgSIZwomLFKo+/16
         xPfMaqW6nhcbrNsdSYULG+e10jR2GSi+MzrjKP7MwRfjyPXE2preBZWGH4DJwI51iD4s
         hbm5xWfa9KbBhxJvpG3L9ew2Sp5sWq1LSQkmCI+65scJFJfXPyeylQ4/6jWb87IZbnJt
         WdCNItfXym8dHpEjLhBzc8LETPjUA/gDbCQ6EojWRGhyKpZe81q+jo2a1zAhiyqHz19m
         Pn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738871152; x=1739475952;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YbCfEtYjJ8HgdzmC6edBJv5q8C9brW4RxPoXoV16zfg=;
        b=Q38LPXat9nD6QorV3GXm6gMGrgqRaw0UfGAYtceit86XzWAiW7Or0peNs4Gz/55UxO
         4W7qFLuRst0DnBCBtu+fpSKeDoaBFZi62xkf8kkzEnezy2NO7IYENNGLkTUQxzJoCN7i
         CvXHTU0k0rU40czruaNRHt7FPeC4OGSEjDChZpDaDtrWj7BJ4WB0UbKqMVmTl+XrzL0X
         oMuppO2gZ3jjSi4sJlJVAdw2IfdtC6EKAlvQxi+aeLdjgCmBbS6fa/8l6FJaJtxI2e5b
         BzHEjYO8c1dRdOLcq5flaEr5o3mD5vuK4HaQP25saZm2O7Bbw7Xk0FXUcBdewzgK+ZcA
         90Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWnTrD+UV+hGHvU0Gaih5klScITq4iFQhzco1+CyVdeU+Rid/BxFm3ben8I9sj8SBxk4vTqTqY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlADqK5B/v9V8+29yp6GgUl/UZuZqleQjKayRED0wqp1Mk1UAJ
	gJMjbuEpyaeKo5iRqK/aRCHhv9T8T5ZY5pUvPmxavbtCKzxU6TEPIyVwT1IxktjTCp3s5/xcDX1
	a+2HArNSpOoJnY1y2BpOp2A==
X-Google-Smtp-Source: AGHT+IFNNmO9kDGnCQ3Tcv/rO4jc58g75MwHio/abi5ncLytMBu/Tab1kPhA/Bby7F9V3R2isfkFKifDgylapF+8eQ==
X-Received: from ilmy18.prod.google.com ([2002:a92:d812:0:b0:3d0:ebcd:cf64])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c0e:b0:3d0:4e57:bbd3 with SMTP id e9e14a558f8ab-3d13dfa2297mr2468995ab.22.1738871151883;
 Thu, 06 Feb 2025 11:45:51 -0800 (PST)
Date: Thu, 06 Feb 2025 19:45:51 +0000
In-Reply-To: <87frkrtr4z.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 06 Feb 2025 08:27:08 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntmsey26xc.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2] KVM: arm64: Remove cyclical dependency in arm_pmuv3.h
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hey Marc, thanks for the review. I thought of a different solution at
the very bottom. Please let me know if that is preferable.

Marc Zyngier <maz@kernel.org> writes:

> Colton,

> On Thu, 06 Feb 2025 00:17:44 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
>> which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
>> causes confusing compilation problems why trying to use anything
>> defined in any of the headers in any other headers. Header guards is
>> the only reason this cycle didn't create tons of redefinition
>> warnings.

>> The motivating example was figuring out it was impossible to use the
>> hypercall macros kvm_call_hyp* from kvm_host.h in arm_pmuv3.h. The
>> compiler will insist they aren't defined even though kvm_host.h is
>> included. Many other examples are lurking which could confuse
>> developers in the future.

> Well, that's because contrary to what you have asserted in v1, not all
> include files are legitimate to use willy-nilly. You have no business
> directly using asm/kvm_host.h, and linux/kvm_host.h is what you need.

That's what I'm trying to fix. I'm trying to *remove* asm/kvm_host.h
from being included in asm/arm_pmu.h.

I agree with you that it *should not be included there* but it currently
is. And I can't drop-in replace the include with linux/kvm_host.h
because the that just adds another link in the cyclical dependency.


>> Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
>> because asm/kvm_host.h is huge and we only need a few functions from
>> it. Move the required declarations to a new header asm/kvm_pmu.h.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---

>> Possibly spinning more definitions out of asm/kvm_host.h would be a
>> good idea, but I'm not interested in getting bogged down in which
>> functions ideally belong where. This is sufficient to break the

> Tough luck. I'm not interested in half baked solutions, and "what
> belongs where" *is* the problem that needs solving.

Fair point, but a small solution is not half-baked if it is better than
what we have.

>> cyclical dependency and get rid of the compilation issues. Though I
>> mention the one example I found, many other similar problems could
>> confuse developers in the future.

>> v2:
>> * Make a new header instead of moving kvm functions into the
>>    dedicated pmuv3 header

>> v1:
>> https://lore.kernel.org/kvm/20250204195708.1703531-1-coltonlewis@google.com/

>>   arch/arm64/include/asm/arm_pmuv3.h |  3 +--
>>   arch/arm64/include/asm/kvm_host.h  | 14 --------------
>>   arch/arm64/include/asm/kvm_pmu.h   | 26 ++++++++++++++++++++++++++
>>   include/kvm/arm_pmu.h              |  1 -
>>   4 files changed, 27 insertions(+), 17 deletions(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_pmu.h

>> diff --git a/arch/arm64/include/asm/arm_pmuv3.h  
>> b/arch/arm64/include/asm/arm_pmuv3.h
>> index 8a777dec8d88..54dd27a7a19f 100644
>> --- a/arch/arm64/include/asm/arm_pmuv3.h
>> +++ b/arch/arm64/include/asm/arm_pmuv3.h
>> @@ -6,9 +6,8 @@
>>   #ifndef __ASM_PMUV3_H
>>   #define __ASM_PMUV3_H

>> -#include <asm/kvm_host.h>
>> -
>>   #include <asm/cpufeature.h>
>> +#include <asm/kvm_pmu.h>
>>   #include <asm/sysreg.h>

>>   #define RETURN_READ_PMEVCNTRN(n) \
>> diff --git a/arch/arm64/include/asm/kvm_host.h  
>> b/arch/arm64/include/asm/kvm_host.h
>> index 7cfa024de4e3..6d4a2e7ab310 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -1385,25 +1385,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu  
>> *vcpu);
>>   void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
>>   void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);

>> -static inline bool kvm_pmu_counter_deferred(struct perf_event_attr  
>> *attr)
>> -{
>> -	return (!has_vhe() && attr->exclude_host);
>> -}
>> -
>>   #ifdef CONFIG_KVM
>> -void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>> -void kvm_clr_pmu_events(u64 clr);
>> -bool kvm_set_pmuserenr(u64 val);
>>   void kvm_enable_trbe(void);
>>   void kvm_disable_trbe(void);
>>   void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest);
>>   #else
>> -static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr  
>> *attr) {}
>> -static inline void kvm_clr_pmu_events(u64 clr) {}
>> -static inline bool kvm_set_pmuserenr(u64 val)
>> -{
>> -	return false;
>> -}
>>   static inline void kvm_enable_trbe(void) {}
>>   static inline void kvm_disable_trbe(void) {}
>>   static inline void kvm_tracing_set_el1_configuration(u64  
>> trfcr_while_in_guest) {}
>> diff --git a/arch/arm64/include/asm/kvm_pmu.h  
>> b/arch/arm64/include/asm/kvm_pmu.h
>> new file mode 100644
>> index 000000000000..3a8f737504d2
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_pmu.h
>> @@ -0,0 +1,26 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +
>> +#ifndef __KVM_PMU_H
>> +#define __KVM_PMU_H
>> +
>> +void kvm_vcpu_pmu_resync_el0(void);
>> +
>> +#ifdef CONFIG_KVM
>> +void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>> +void kvm_clr_pmu_events(u64 clr);
>> +bool kvm_set_pmuserenr(u64 val);
>> +#else
>> +static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr  
>> *attr) {}
>> +static inline void kvm_clr_pmu_events(u64 clr) {}
>> +static inline bool kvm_set_pmuserenr(u64 val)
>> +{
>> +	return false;
>> +}
>> +#endif
>> +
>> +static inline bool kvm_pmu_counter_deferred(struct perf_event_attr  
>> *attr)
>> +{
>> +	return (!has_vhe() && attr->exclude_host);
>> +}
>> +
>> +#endif

> How does this solve your problem of using the HYP-calling macros?

This code does not directly solve that problem. It makes a solution to
that problem possible because it breaks up the cyclical dependency by
getting asm/kvm_host.h out of asm/arm_pmuv3.h while still providing the
declarations to arm_pmuv3.c

With a cyclical dependency the compiler gets confused if you try to use
anything from asm/kvm_host.h inside asm/arm_pmuv3.h (like HYP-calling
macros defined there for example). Again, I believe that inclusion
should not be there in the first place which is the motivation for this
patch.

But since it is included, here's what happens if you try:

When asm/kvm_host.h is included somewhere, it indirectly includes
asm/arm_pmuv3.h via the chain described in my commit message.
asm/arm_pmuv3.h is then effectively pasted into asm/kvm_host.h and due
to include guards is passed over this time, but this means that many
things in asm/kvm_host.h aren't defined yet so any symbols from
asm/kvm_host.h defined after the include of asm/arm_pmuv3.h are used
before their definition: boom, confusing compiler errors

You might argue: just don't do that, but I think it's a terrible
developer experience when you can't use definitions from a file that is
currently included. I spent hours puzzling over errors before realizing
a cyclical dependency was the root cause and want to save other devs
from the same fate.

>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 147bd3ee4f7b..2c78b1b1a9bb 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -74,7 +74,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
>>   struct kvm_pmu_events *kvm_get_pmu_events(void);
>>   void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>>   void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>> -void kvm_vcpu_pmu_resync_el0(void);

>>   #define kvm_vcpu_has_pmu(vcpu)					\
>>   	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))

>> base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b

> I'm absolutely not keen on *two* PMU-related include files. They both
> describe internal APIs, and don't see a good reasoning for this
> arbitrary split other than "it works better for me and I don't want to
> do more than strictly necessary".

I understand the point which is why v1 tried not to introduce a new
header file and I was advised to make a new header file.

> For example, include/kvm was only introduced to be able to share files
> between architectures, and with 32bit KVM/arm being long dead, this
> serves no purpose anymore. Moving these things out of the way would be
> a good start and would provide a better base for further change.

Good to know. I avoided doing that because it would be a lot of change
noise and I wasn't sure such changes would be welcome.

> So please present a rationale on what needs to go where and why based
> on their usage pattern rather than personal convenience, and then
> we'll look at a possible patch. But not the other way around.

My rationale is fixing a cyclical dependency due to an inclusion of
asm/kvm_host.h where we both seem to agree it shouldn't be. Cyclical
dependencies are really bad and cause nasty surprises when something
that seems like it should obviously work doesn't. Fixing things like
this makes programming here more conveneint for everyone, not just
me. So I thought it was worth a separate patch.

Another possible solution that avoids moving anything around is to take
asm/kvm_host.h out of asm/arm_pmuv3.h and do

#ifdef CONFIG_ARM64
#include <linux/kvm_host.h>
#endif

directly in arm_pmuv3.c which breaks the cycle while still providing the
correct declarations for arm_pmuv3.c (and admittedly many more than
necessary).

I find this conditional inclusion ugly and possibly you will have an
objection to it, but let me know.
