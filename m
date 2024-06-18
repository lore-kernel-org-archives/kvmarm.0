Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7731C13A3E9
	for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 07:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718695238; cv=none; b=k98EeJc7U5FSEEOuncjbz8Kh3WS4FLrL7UoRIzqWXbSdHT5JRUNqkJ772c9RooRzofRcTW/K/GggofvLbHV0+p9kt2fHdgGJF4cT76pxLV7eNZtIcPt9fhW5PEM/MZPEeYgjv+igRHBSl3/PXbexSooaeCxweqGYoixtKTjhl28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718695238; c=relaxed/simple;
	bh=7+n3kW2jaX5vi3EV2n3+TXiAkc91JFM8ynm4fYCf7SU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VfK7n67rqxHPWmoGAFTQhXPWzuJt87UlNiSPz8fI0YxMyi/bdXN3i0WGPRk/8Eha61zeR6uveFjKU5SjMejaWpBPIMk05Ck9EQuaL/3+gGvgZlq+eSzZV6lyKyo6joEeGErHoY0tgUVDsQbs8ZLmZavp6eKV5DEp68aFWJgCP7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C8xoeGVx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8xoeGVx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718695235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+MZvD0c6jZAbOwtBsBdVea8BAt9Pk1x19oYnj2/Pfs=;
	b=C8xoeGVxONIz9J7dEHtdBJFKIYRvu1rB9IH2OZKFcdYw4kU7m1Bdiw4cP1/JzYBEeJhhUJ
	9/vLEhVUHiW0QhPtaw9wwD0aqsE0EGLaFD7qZcSZ6TI6RBH2R4YEBBREhOAQHXzNmJSjzc
	z2JCR+FsPV6URYRSJJT9/XBMscW22xY=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-eE6w2uLWM8O96AL7K818sQ-1; Tue, 18 Jun 2024 03:20:33 -0400
X-MC-Unique: eE6w2uLWM8O96AL7K818sQ-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-257ea28fa66so964755fac.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 00:20:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718695233; x=1719300033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S+MZvD0c6jZAbOwtBsBdVea8BAt9Pk1x19oYnj2/Pfs=;
        b=mWI5XMAKfvZEwwZwqBnUKq8AvHfXJ9MTjVjbJJKlDrz1phMmlkJNmqdPOTfyqQ2lZV
         MtcjKsQBwIRb3jTDTqwr9TFB8rpvA4odO6PsbZ5W/Y7FDaEEUO4Zr9PsTWqQdTk6atO7
         Zg7NAseHG2m9Za6yvd5Lhhss4hHhXIM3tE4NM8NYa8I8tlSenZH+TCQvrBgGKjPDCtp8
         rWo64W2cvMFM/+auyD4wNeSpp1rMjS2oPKyvuyWcfmyCYtk54oL7AaVseu2IX61fKfEh
         sVVjAW6Cssl071xJ4b1K6QowDlHb3K+VEnYx44eVzxTJPiM5/qXYSjSJAuKmbO3ojlnJ
         L27A==
X-Forwarded-Encrypted: i=1; AJvYcCWeOawRVm4oFsI9V/2pK6d6bWcZfi68h1KQGF3noMwZFTqdXZNw97fH0Mlkq6V4qjgYl9hb0vf30g87DDBBo7lnUwtEiFK0
X-Gm-Message-State: AOJu0YzojVGCZgVAi2D2DZHEsZa+YOMTShxhegO6l9To8+2sYO16sOjo
	aqliD/+4T+egqD6swY2sAYG/k3aLfzX2S6xCjwyVz1P9/CFSKaCigkxLYhC6AQONvegoFfyKweX
	YXF1k1a0PSMw5hWdNHV006PkGOm3y8fR1wukfHvIWj9H2pPJOGJi0Ww==
X-Received: by 2002:a05:6870:472c:b0:254:abd6:1a3d with SMTP id 586e51a60fabf-25842c4d336mr12855716fac.4.1718695232654;
        Tue, 18 Jun 2024 00:20:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOPqkcgbIKP9DQkszgI9BP4bpi27+YzHI5LkL7RDuPvbhH5VsAbpRdW0WQgV71WAmyOeyUHw==
X-Received: by 2002:a05:6870:472c:b0:254:abd6:1a3d with SMTP id 586e51a60fabf-25842c4d336mr12855697fac.4.1718695232295;
        Tue, 18 Jun 2024 00:20:32 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc91dd11sm8363871b3a.43.2024.06.18.00.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 00:20:31 -0700 (PDT)
Message-ID: <7617ca12-6538-4638-a2ab-a90d06a3a7f0@redhat.com>
Date: Tue, 18 Jun 2024 15:20:27 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/3] KVM: selftests: aarch64: Introduce
 pmu_event_filter_test
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20240613082345.132336-1-shahuang@redhat.com>
 <20240613082345.132336-3-shahuang@redhat.com>
 <CAJHc60y67Be=XcJuy__2RN43WyN6YgukSAb0=T6TGwYHw+YpHg@mail.gmail.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60y67Be=XcJuy__2RN43WyN6YgukSAb0=T6TGwYHw+YpHg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Raghavendra,

Thanks for helping review this series.

On 6/18/24 08:01, Raghavendra Rao Ananta wrote:
> Hi Shaoqin
> 
> 
> On Thu, Jun 13, 2024 at 1:28 AM Shaoqin Huang <shahuang@redhat.com> wrote:
> 
>> +static void prepare_expected_pmce(struct kvm_pmu_event_filter *filter)
>> +{
>> +       struct pmu_common_event_ids pmce_mask = { ~0, ~0 };
>> +       bool first_filter = true;
>> +       int i;
>> +
>> +       while (filter && filter->nevents != 0) {
> Do you also want to add a check to ensure we aren't running over
> FILTER_NR (I'd expect a compiler warning/error though)?

The FILTER_NR is only used to assign the length of the filter array, if 
the defined filter array length is larger than the FILTER_NR, I believe 
there will be a compiling warning.

> 
>> +               if (first_filter) {
>> +                       if (filter->action == KVM_PMU_EVENT_ALLOW)
>> +                               memset(&pmce_mask, 0, sizeof(pmce_mask));
>> +                       first_filter = false;
>> +               }
> nit: Probably we can make the 'first_filter' part a little cleaner by
> checking this outside the loop.
> 
> if (filter && filter->action == KVM_PMU_EVENT_ALLOW)
>          memset(&pmce_mask, 0, sizeof(pmce_mask));
> 
> while (filter && filter->nevents != 0) {
>      ...
> }

Thanks, this looks much better and I will change the code to it.

> 
>> +static struct test_desc tests[] = {
>> +       {
>> +               .name = "without_filter",
>> +               .filter = {
>> +                       { 0 }
>> +               },
>> +       },
>> +       {
>> +               .name = "member_allow_filter",
>> +               .filter = {
>> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_SW_INCR, 0),
> In terms of readability, do you think it's better to use
> KVM_PMU_EVENT_{ALLOW|DENY}, instead of 0 and 1?
> 
> Or, if that's coming out to be too long, may be create another wrapper
> over DEFINE_FILTER, and simply use that in the array:
> 
> #define EVENT_ALLOW(event) DEFINE_FILTER(event, KVM_PMU_EVENT_ALLOW)
> #define EVENT_DENY(event) DEFINE_FILTER(event, KVM_PMU_EVENT_DENY)
> 
> .filter = {
>      EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_SW_INCR),
> 

Pretty good idea. I will take your code which looks much clean.

>> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_INST_RETIRED, 0),
>> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_BR_RETIRED, 0),
>> +                       { 0 },
>> +               },
>> +       },
> 
>> +       {
>> +               .name = "cancel_filter",
>> +               .filter = {
>> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, 0),
>> +                       DEFINE_FILTER(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, 1),
>> +               },
> Since the initial filter map depends on the event being allowed or
> denied, do you think another "cancel_filter" case to first deny and
> then allow would also be better?

Yes. That would be better, I will add another test which first deny and 
then allow it.

> 
>> +       },
>> +       {
>> +               .name = "multiple_filter",
>> +               .filter = {
>> +                       __DEFINE_FILTER(0x0, 0x10, 0),
>> +                       __DEFINE_FILTER(0x6, 0x3, 1),
>> +               },
>> +       },
>> +       { 0 }
>> +};
>> +
>> +static void run_tests(void)
>> +{
>> +       struct test_desc *t;
>> +
>> +       for (t = &tests[0]; t->name; t++)
>> +               run_test(t);
>> +}
>> +
>> +int used_pmu_events[] = {
> nit: static int used_pmu_events[] = {
> 

Got it.

Thanks,
Shaoqin

> Thank you.
> Raghavendra
> 
> 
>> +       ARMV8_PMUV3_PERFCTR_BR_RETIRED,
>> +       ARMV8_PMUV3_PERFCTR_INST_RETIRED,
>> +       ARMV8_PMUV3_PERFCTR_CHAIN,
>> +};
>> +
>> +static bool kvm_pmu_support_events(void)
>> +{
>> +       struct pmu_common_event_ids used_pmce = { 0, 0 };
>> +
>> +       create_vpmu_vm(guest_get_pmceid);
>> +
>> +       memset(&max_pmce, 0, sizeof(max_pmce));
>> +       sync_global_to_guest(vpmu_vm.vm, max_pmce);
>> +       run_vcpu(vpmu_vm.vcpu);
>> +       sync_global_from_guest(vpmu_vm.vm, max_pmce);
>> +       destroy_vpmu_vm();
>> +
>> +       for (int i = 0; i < ARRAY_SIZE(used_pmu_events); i++)
>> +               set_pmce(&used_pmce, KVM_PMU_EVENT_ALLOW, used_pmu_events[i]);
>> +
>> +       return ((max_pmce.pmceid0 & used_pmce.pmceid0) == used_pmce.pmceid0) &&
>> +              ((max_pmce.pmceid1 & used_pmce.pmceid1) == used_pmce.pmceid1);
>> +}
>> +
>> +int main(void)
>> +{
>> +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
>> +       TEST_REQUIRE(kvm_pmu_support_events());
>> +
>> +       run_tests();
>> +}
>> --
>> 2.40.1
>>
>>
> 

-- 
Shaoqin

