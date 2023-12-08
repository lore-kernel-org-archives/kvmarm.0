Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D2D37D3E
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 21:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T+to0IRk"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-daf702bde7eso2738155276.3
        for <kvmarm@lists.linux.dev>; Fri, 08 Dec 2023 13:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702069292; x=1702674092; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cPvsp4vtrotIomPKqq2ImuA44XLC/C4iYoGwJqvn3h8=;
        b=T+to0IRkohELp9qoh0Xq8M8IV3eFow0hADROFccT6RCX7bzhCd6HVbWUa2b8PeGpbP
         c1w0O4g/aYn5qWCp61ChECYq77XkCL3Shh3nCtO3zJoWA3ZNokt2iU2Mx3Zc7ekR3EFM
         4+ejOUb/U39sBK6Oc2OcyLAgKtcs7CukLHfkrysQqWxYR1NTc6YXNj4+PjI4m3rQceLB
         729N0x8tFAARIemwLcSnIXVQN+zcx6b7e3bVN0PChOLnEQ2KlfBWXd+LuQNEbUQak5cV
         YLdbkmxHzcOtoW+gLZDyjSRLeAR3VqE9N2N9j+LV9b1uxoGDdEjBBrPPjBg5MrXlMQvf
         ptQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702069292; x=1702674092;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cPvsp4vtrotIomPKqq2ImuA44XLC/C4iYoGwJqvn3h8=;
        b=LDlB4QO0T1GG0Hxsi8uijDnSvh67XULT8pmHYQUv11yog08dze4sSUIRfzV1wLovUf
         D7rPwi1P/FWfYBUySOJDskZ8K8jTfplRM5pzqq51TfxiIUQeDhaDFfkeJp/gGKtS0nrr
         iE2xVTXLBeMF1OE34UfZ4yWj/B7h8zUOva/H/Sd4nHOne18VPn9ERFyGWQCwGBgx/Oyb
         z7gy7hmPGxtIZwgrnQ3mQBitVqhWbEuVKhwbZv471wry/3ISgv3rzb4gb8Bi+/Pb+dyp
         lT1MeKofMG+z+q8KxaxWfeXYIdbA8KD7qcFbAnGRzhPQnBdvI+DjRcByJpA9I6vsLyJz
         A0ig==
X-Gm-Message-State: AOJu0YyuBtljRg0vfKGPuK9wgux+6mydQ95DdZ7UsmZp/yXQpRojV6lR
	eBt/aBpX5lZR6vGZsYzWhsVmLo37VVrSvqYvSA==
X-Google-Smtp-Source: AGHT+IE2+v2iURbPda/UkDDifecJeozbvSa31F1K3eqBpsYJtjPo/blaA3H9UAXge83pUxWRcqNIFPEBrorUs01B8g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:b94e:0:b0:db4:4df:8c0d with SMTP
 id s14-20020a25b94e000000b00db404df8c0dmr4660ybm.11.1702069291893; Fri, 08
 Dec 2023 13:01:31 -0800 (PST)
Date: Fri, 08 Dec 2023 21:01:30 +0000
In-Reply-To: <ZV4924juGGCk2cjf@linux.dev> (message from Oliver Upton on Wed,
 22 Nov 2023 17:43:55 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt7clov26t.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 1/3] KVM: arm64: selftests: Standardize GIC base addresses
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Fri, Nov 03, 2023 at 07:29:13PM +0000, Colton Lewis wrote:
>> Use default values during GIC initialization and setup to avoid
>> multiple tests needing to decide and declare base addresses for GICD
>> and GICR. Remove the repeated definitions of these addresses across
>> tests.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> <snip>

>> -void gic_init(enum gic_type type, unsigned int nr_cpus,
>> +void _gic_init(enum gic_type type, unsigned int nr_cpus,
>>   		void *dist_base, void *redist_base)
>>   {
>>   	uint32_t cpu = guest_get_vcpuid();
>> @@ -63,6 +63,11 @@ void gic_init(enum gic_type type, unsigned int  
>> nr_cpus,
>>   	gic_cpu_init(cpu, redist_base);
>>   }

>> +void gic_init(enum gic_type type, unsigned int nr_cpus)
>> +{
>> +	_gic_init(type, nr_cpus, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
>> +}
>> +

> </snip>

>> -int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t  
>> nr_irqs,
>> +int _vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t  
>> nr_irqs,
>>   		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
>>   {
>>   	int gic_fd;
>> @@ -79,6 +79,11 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int  
>> nr_vcpus, uint32_t nr_irqs,
>>   	return gic_fd;
>>   }

>> +int vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t  
>> nr_irqs)
>> +{
>> +	return _vgic_v3_setup(vm, nr_vcpus, nr_irqs, GICD_BASE_GPA,  
>> GICR_BASE_GPA);
>> +}
>> +

> What's the point of having the internal implementations of these
> functions that still take addresses? If we're standardizing GIC
> placement then there's no need for allowing the caller to provide
> different addresses.

I wasn't sure if there might be a reason for that allowance I was
unaware of since that's what the original interface was so I erred on
the side of flexibility. I'll delete it.
