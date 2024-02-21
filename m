Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C79E3C492
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 08:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708504650; cv=none; b=l6a5EyTco73H6zfoLSJGdxSGOROlAziBXL65bOSiLsYlW/tMhTEoyAtsTq3x3Vmsn2OeNtv3qcgayzbwB/8WG93Q8LU4RXhei24/na7azKibSTQyvLg1ol5K5WgGVoIlS8Ub3jtN5Z8cCI+emgXP7hVKgekvvPovoQuEkxyVUpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708504650; c=relaxed/simple;
	bh=2XWyxN00EFfYTYtzTseDSDHHVqgSLhtubiTpTmEktVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gemjNNr37QJoso5eOAXebHZGNemYV7JlnRPGXY6Tryvq2LKoMReqm2K7cySSbTzOma+O94RLH9pfmh6iUXbtpt/hsTAjtpwsGYg2B80jwH5fdwWobkX4PwT+/x320P6edORaKc8IIy1XTPAlnDcaYtxx3hgoCNE/aimOQo68tlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=niWXiXGl; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="niWXiXGl"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-2184133da88so3627490fac.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 00:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708504646; x=1709109446; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MMnw9vKJcK+lbDT8FYPd91pzbpe6XkA1QZvMTkaziM0=;
        b=niWXiXGlVkXIW2690EeW6mQjmrCKDpiybfvqP7VKfUXP3lKc4P6ARfodTvSU2z5JUN
         7sWv1EHRVmuRbH3SD3JNM4JoL4oIb5Kv0r1LWsPpMeTrfOvLhYhfdAiYUdX6I7MSsZVh
         IqbZY5hWDCYDBTO+iW/CefVB+sNodhWdAt4hqGhm/x8UwyfvIXIEZTACq0QIFw5SfSva
         VyhnnCYNML+UH+b68enlVCUbSXkqXR7vRlNrEyEp0FvdqjLKG4MobnTXppGAqKY2nwKX
         bObrp8jCY7bi6zE3zhp0itlipeiWneNKN1rH6nYOCHOtt/j9CBFhRveYVtpWdr0eBxhH
         K0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708504646; x=1709109446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MMnw9vKJcK+lbDT8FYPd91pzbpe6XkA1QZvMTkaziM0=;
        b=ry00TDm27qRoR5NMDYwnRBrctKIVYoe0CXD0u4jevtcybW2Ec1waVnk4nMa2vSOvIG
         XUMGFn0apXavjcZQdERKHj3IVJgKyt485dIvIJhU4984vrbmHvLgenslx41kt9eixKqL
         TUsNF5x/VyE7CXi+kuTAMyhrnS+0ijc556tFRZn7jxij404ttSjSaV+5mmErzGb6TlNw
         miFhrFCqZ1/X1wn9lU6qKpi+zKvx8Re29FtqkEnopflP+CGonTilZt/CYnuvspAupUTf
         moqYxtaFW7ASuzTpCXN8YrjxFZpTC7QA6pLpVY5D9a/f0V1NWnal+OZDumqEnZRQ0Ryb
         0i9A==
X-Forwarded-Encrypted: i=1; AJvYcCWj1Mi5Ow7ogtHclJyJs0gYAhx8DupENDarn3zM38LTqnKi0aWfz3SOx1hqknyo/7eM2IOpcdrc1i6kLdqjFwVQmXrrAz4K
X-Gm-Message-State: AOJu0YxZJn/NFFpVgvdao+RU9jeZILLOKbqoddew3pcwIW3p/NKmRyIo
	kZuQOo/+HcDDtKZmrphAM6rWsyK7cNZX1u98B0VNVIoC6bR2SRytpLE2K5CFeKo=
X-Google-Smtp-Source: AGHT+IGwSgsjE3CPVeonNtgWRogjIsKu+qKysC/zJGjHtavZzYR//zpXfv8521DVEpjsYdm9vUOFzw==
X-Received: by 2002:a05:6871:1cc:b0:21a:43e6:9479 with SMTP id q12-20020a05687101cc00b0021a43e69479mr19017547oad.25.1708504646344;
        Wed, 21 Feb 2024 00:37:26 -0800 (PST)
Received: from [172.16.0.18] (c-67-188-2-18.hsd1.ca.comcast.net. [67.188.2.18])
        by smtp.gmail.com with ESMTPSA id h6-20020a63c006000000b0059b2316be86sm8040427pgg.46.2024.02.21.00.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 00:37:25 -0800 (PST)
Message-ID: <2c96c61a-2685-4cee-9cef-963ed833bf92@rivosinc.com>
Date: Wed, 21 Feb 2024 00:37:21 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/12] KVM: riscv: selftests: Change vcpu_has_ext to a
 common function
Content-Language: en-US
To: Haibo Xu <xiaobo55x@gmail.com>, Atish Patra <atishp@atishpatra.org>
Cc: Haibo Xu <haibo1.xu@intel.com>, ajones@ventanamicro.com,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Conor Dooley <conor.dooley@microchip.com>,
 Samuel Holland <samuel@sholland.org>,
 Minda Chen <minda.chen@starfivetech.com>, Jisheng Zhang
 <jszhang@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>,
 Vipin Sharma <vipinsh@google.com>, Thomas Huth <thuth@redhat.com>,
 Aaron Lewis <aaronlewis@google.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <cover.1705916069.git.haibo1.xu@intel.com>
 <68856b86a93a4188558e5d0ebac0dd6aac8e404c.1705916069.git.haibo1.xu@intel.com>
 <CAOnJCULwRTSnrQkR2o1P53R=tJ3TAxX+y+XRBesW6OFEzgFv2g@mail.gmail.com>
 <CAJve8om2oOLg5-wKX7m7cBTgzwqiMcb35x=nDi1edY8evXjyMw@mail.gmail.com>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <CAJve8om2oOLg5-wKX7m7cBTgzwqiMcb35x=nDi1edY8evXjyMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/20/24 18:13, Haibo Xu wrote:
> On Wed, Feb 21, 2024 at 7:03 AM Atish Patra <atishp@atishpatra.org> wrote:
>>
>> On Mon, Jan 22, 2024 at 1:48 AM Haibo Xu <haibo1.xu@intel.com> wrote:
>>>
>>> Move vcpu_has_ext to the processor.c and rename it to __vcpu_has_ext
>>> so that other test cases can use it for vCPU extension check.
>>>
>>> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
>>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>>> ---
>>>   tools/testing/selftests/kvm/include/riscv/processor.h |  2 ++
>>>   tools/testing/selftests/kvm/lib/riscv/processor.c     | 10 ++++++++++
>>>   tools/testing/selftests/kvm/riscv/get-reg-list.c      | 11 +----------
>>>   3 files changed, 13 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
>>> index b68b1b731a34..bd27e1c67579 100644
>>> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
>>> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
>>> @@ -42,6 +42,8 @@ static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t idx,
>>>   #define RISCV_ISA_EXT_REG(idx) __kvm_reg_id(KVM_REG_RISCV_ISA_EXT, \
>>>                                               idx, KVM_REG_SIZE_ULONG)
>>>
>>> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
>>> +
>>>   struct ex_regs {
>>>          unsigned long ra;
>>>          unsigned long sp;
>>> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
>>> index 39a1e9902dec..dad73ce18164 100644
>>> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
>>> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
>>> @@ -15,6 +15,16 @@
>>>
>>>   static vm_vaddr_t exception_handlers;
>>>
>>> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
>>> +{
>>> +       unsigned long value = 0;
>>> +       int ret;
>>> +
>>> +       ret = __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
>>> +
>>> +       return !ret && !!value;
>>> +}
>>> +
>>
>> Not sure what was the base patch on which this was rebased. The actual
>> commit in the queue branch looks different.
>>
> 
> This patch set was based on 6.7-rc8.
> 
>> https://github.com/kvm-riscv/linux/commit/5563517cc2012e3326411b360c9924d3f2706c8d
>>
>> Both seem to have the same bug though the tests fail now and require
>> the following fix.
>> The ext id should be uint64_t and we need to pass ext directly so that
>> SBI extension tests can also pass.
>>
> 
> It's weird that 6.7-rc8 has already included Andrew's change on the ISA ext reg,
> but this patch was not generated against his change.
> 
> commit bdf6aa328f137e184b0fce607fd585354c3742f1
> Author: Andrew Jones <ajones@ventanamicro.com>
> Date:   Wed Dec 13 18:09:58 2023 +0100
> 
>      RISC-V: KVM: selftests: Treat SBI ext regs like ISA ext regs
> 
> Anyway, your changes were right. Please go ahead to include them when merging.
> 

I am not sure what happened. Probably, a merge conflict issue.

I just realized I forgot to copy paste another fix in arch timer

+++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
@@ -85,7 +85,7 @@ struct kvm_vm *test_vm_create(void)
         int nr_vcpus = test_args.nr_vcpus;

         vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
-       __TEST_REQUIRE(__vcpu_has_ext(vcpus[0], KVM_RISCV_ISA_EXT_SSTC),
+       __TEST_REQUIRE(__vcpu_has_ext(vcpus[0], 
RISCV_ISA_EXT_REG(KVM_RISCV_ISA_EXT_SSTC)),


> Thanks,
> Haibo
> 
>>
>> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
>> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
>> @@ -48,7 +48,7 @@ static inline uint64_t __kvm_reg_id(uint64_t type,
>> uint64_t subtype,
>> KVM_REG_RISCV_SBI_SINGLE, \
>> idx, KVM_REG_SIZE_ULONG)
>>
>> -bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
>> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext);
>>
>> struct ex_regs {
>> unsigned long ra;
>> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c
>> b/tools/testing/selftests/kvm/lib/riscv/processor.c
>> index 282587cd4bbc..ec66d331a127 100644
>> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
>> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
>> @@ -15,12 +15,12 @@
>>
>> static vm_vaddr_t exception_handlers;
>>
>> -bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
>> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
>> {
>> unsigned long value = 0;
>> int ret;
>>
>> - ret = __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
>> + ret = __vcpu_get_reg(vcpu, ext, &value);
>>
>> return !ret && !!value;
>> }
>>
>> With the above the fix, Both SBI/ISA extension tests pass.
>> # ./get-reg-list
>> sbi-base: PASS
>> sbi-sta: PASS
>> sbi-pmu: PASS
>> sbi-dbcn: PASS
>> aia: PASS
>> fp_f: PASS
>> fp_d: PASS
>> 1..0 # SKIP - h not available, skipping tests
>> smstateen: PASS
>> sscofpmf: PASS
>> sstc: PASS
>> 1..0 # SKIP - svinval not available, skipping tests
>> 1..0 # SKIP - svnapot not available, skipping tests
>> 1..0 # SKIP - svpbmt not available, skipping tests
>> zba: PASS
>> zbb: PASS
>> zbc: PASS
>> 1..0 # SKIP - zbkb not available, skipping tests
>> 1..0 # SKIP - zbkc not available, skipping tests
>> 1..0 # SKIP - zbkx not available, skipping tests
>> zbs: PASS
>> zfa: PASS
>> 1..0 # SKIP - zfh not available, skipping tests
>> 1..0 # SKIP - zfhmin not available, skipping tests
>> zicbom: PASS
>> zicboz: PASS
>> zicntr: PASS
>> 1..0 # SKIP - zicond not available, skipping tests
>> zicsr: PASS
>> zifencei: PASS
>> zihintntl: PASS
>> zihintpause: PASS
>> zihpm: PASS
>>
>>
>>>   static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>>>   {
>>>          return (v + vm->page_size) & ~(vm->page_size - 1);
>>> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
>>> index 25de4b8bc347..ed29ba45588c 100644
>>> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
>>> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
>>> @@ -75,15 +75,6 @@ bool check_reject_set(int err)
>>>          return err == EINVAL;
>>>   }
>>>
>>> -static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
>>> -{
>>> -       int ret;
>>> -       unsigned long value;
>>> -
>>> -       ret = __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
>>> -       return (ret) ? false : !!value;
>>> -}
>>> -
>>>   void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
>>>   {
>>>          unsigned long isa_ext_state[KVM_RISCV_ISA_EXT_MAX] = { 0 };
>>> @@ -111,7 +102,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
>>>                  __vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(s->feature), 1);
>>>
>>>                  /* Double check whether the desired extension was enabled */
>>> -               __TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
>>> +               __TEST_REQUIRE(__vcpu_has_ext(vcpu, s->feature),
>>>                                 "%s not available, skipping tests\n", s->name);
>>>          }
>>>   }
>>> --
>>> 2.34.1
>>>
>>
>>
>> --
>> Regards,
>> Atish

