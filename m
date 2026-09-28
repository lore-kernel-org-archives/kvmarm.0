Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222664CE697
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 13:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602517; cv=none; b=IpdArFaoJBQYUD7DBrMjPBvfLLxiobLjNJzPpwNRSCv6N9jTIcJOtF1gFAafRTcrtCAgsNDfNJEOrcUe9ofnHUpZDY6c6qd0kYk8IAISnbGhqovSoZbHdtq49u7eCJVRjYB950tj3EDpt+t4Ba9uA3mKjDKnwC9Ctu9ZC/NUTak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602517; c=relaxed/simple;
	bh=2bLWTRPj0TM3JaTt8eQVRloUePNthi+fCH9sFfQRCPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onI/J4A9hegF6u6ysYZsKOlNmEgH4qaafChPy1wf0w7l2jMYGJW0KigOVtWTn/BLuVjPsF5z0bssc5NDu4KuUx02cZhafZwQG/8dRYCGjv2S3DQlPKNr4Xrc6S2FPa5BKdiIYuzU/oVdZ6//TBpSwHG3jzHJbE5whMOIBUusMP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BPBzmOjp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BPBzmOjp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790602515;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4w92S56W1hEAvyaUrn5PHeutHX5AaS6SnxPCoFTbVlI=;
	b=BPBzmOjpNXh+3LS4zlBC3s/fVGWjXjNrRHtTUKzpYoCmtSk8HZVn0IjGnE/Hi3ajBb6fAT
	gEyd+/IatTANo8Z2FV2/rYYpYwwEh+0auB0CONoX2II7v1nBhdm5BrVa/PIR25xQZViyJl
	f2x12h10s+CLOlnu68UDT89Cx7zYxbE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-OZGLBwm2MW6veQ0z9D5o9w-1; Mon, 28 Sep 2026 09:35:13 -0400
X-MC-Unique: OZGLBwm2MW6veQ0z9D5o9w-1
X-Mimecast-MFC-AGG-ID: OZGLBwm2MW6veQ0z9D5o9w_1790602513
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48aec0407daso420360f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 06:35:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602512; x=1791207312;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4w92S56W1hEAvyaUrn5PHeutHX5AaS6SnxPCoFTbVlI=;
        b=XWe+Rhf1nJ04HBH/K8FIH8mkddZizUrzvJDk9D+HNiDaQBcrKzlzmhymJvLlFNH3Di
         0T4wB4+BksRZilX7cJBVKM7Qcl6AvsDautOJeANFTWAZgUWv6tikN+n5RQ4TK+JojtUt
         AMUwv4baOW7f4eYRt8/55YXjztW+UM9Tulbsj37CYgAvcSeMoYd8cGtU5FAvrQ8oor1q
         pkGbWdqGyOHZG05F9O4PQ7+jNM0NG/UvSa3QCljBlooGe++zPlxGNPvJSfGDOMLNYaGY
         ZmLeVGj1LcwgfPZ6Cyqm8gXUg7KMNP53rxofuM3LyO7l7U4zkdHazxrAziZUVptqr/Ek
         QerQ==
X-Forwarded-Encrypted: i=1; AKwUvBzdwivLQNg5XKGfVDs/a9QfMvFyBPHc7fernk7x6xOvYzvoBrn7KEG3skQv9pbyAVxSpX589tI=@lists.linux.dev
X-Gm-Message-State: AFq9FYI3JPFxHrxeVaFY1Dno719ucv0jh1NNCz+t+o00vHOyjGS3ktPQ
	vzqe/iug56mpGqTpPb/fY8eKx7/WcgEKMImWGO8YJzG8KhftDcdyfvXOPGhnClMT/jGEXEBuhRt
	IReJm9Yb3JnfLQ6b33gHqekRt7m9qqUHsPpxLmgFqxB4kwqnwCoTPVzwXqK/i1QkRZQ==
X-Gm-Gg: AYBFou18GpbVTO3MkLSHkDSD80EazsEW3aPPocJuhtyZTVT+ImSWUALmX9bgIrrM6wF
	j/Jme6/IkFIPi+KG5lrfydINkTZE+KYks77ClyvoI4vFulcgheWsDeoFijPHtHokFnm474ehj71
	o2vUPFbfUm5DNzlgS5gJSTcnO4yaqGyPByhUn1j8hjVt2YdC1uUmAJs+SOLB79o47XeDnjYPMb2
	fQzFxA81GcED12c3kZFTusbkjJubohhxD5v+clO3zJsFR9CI/Ii1IGWUyuazUxvd2wb77z/Cq5i
	izIhgI0Zg4y+B8q/delYjCPuUm/Iy91hSGpBJrDneN68XlYF1DGhqavfCIC0flpPzP2DA6teDvC
	i7hZTRJNwcsNHI+MeZuKog53sXL64okFktPiQxUlOBnnchxaG
X-Received: by 2002:a05:6000:4310:b0:488:8b1d:1784 with SMTP id ffacd0b85a97d-4888b1d18f6mr11552346f8f.26.1790602512514;
        Mon, 28 Sep 2026 06:35:12 -0700 (PDT)
X-Received: by 2002:a05:6000:4310:b0:488:8b1d:1784 with SMTP id ffacd0b85a97d-4888b1d18f6mr11552281f8f.26.1790602512135;
        Mon, 28 Sep 2026 06:35:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a35607bsm25441448f8f.16.2026.09.28.06.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 06:35:11 -0700 (PDT)
Message-ID: <08465df1-4e14-4859-8ecc-b38ad8898506@redhat.com>
Date: Mon, 28 Sep 2026 15:35:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 18/26] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-19-eric.auger@redhat.com>
 <8C14A4F3-BD37-4754-981A-829464016DE0@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <8C14A4F3-BD37-4754-981A-829464016DE0@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5R2pucgaYj7y_eDT43r5YVRz8W51jHXbfkNUb15CNP4_1790602513
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/28/26 3:26 PM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> If the host supports KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES and
>> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl successfully retrieved the mask
>> of writable fields for all ID regs, expose uint64 SYSREG properties
>> for all the writable ID reg fields exposed by the host kernel which
>> can be matched in target/arm/cpu-idregs.h.inc.
>>
>> Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
>> being those used ARCHMRS Registers.json.
>>
>> When such properties are set, they override the default field value
>> retrieved from the host and reinjected into KVM. Then the actual value
>> being applied at KVM depends on the register, ie. it can be sanitized.
>> In case the field value is rejected by KVM, the vpcu init fails.
>>
>> Anyway there is a first attempt to write back this value into KVM.
>>
>> Then legacy CPU options (virtualization, secure, ...) can still
>> override the previous value. So low level IDREG field properties
>> apply before the legacy ones.
>>
>> An example of invocation is:
>> -cpu host,SYSREG_ID_AA64MMFR0_EL1_ECV=0x0
>> which sets ECV field of ID_AA64MMFR0_EL1 to 0 (enhanced counter
>> virtualization).
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>>
> Hi Eric,
>
> The commit message needs an update :)

right! Thank you for spotting this

Eric
>
>> ---
>> v5 -> v6:
>> - do not check writable_map anymore
>>
>> v4 -> v5:
>> - get rid of ret local variable, dynamically allocate and free writable_map
>>  here
>> ---
>> target/arm/cpu64.c | 5 +++++
>> 1 file changed, 5 insertions(+)
>>
>> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
>> index 4e8c472530..e04062e848 100644
>> --- a/target/arm/cpu64.c
>> +++ b/target/arm/cpu64.c
>> @@ -37,6 +37,7 @@
>> #include "hw/core/qdev-properties.h"
>> #include "internals.h"
>> #include "cpu-features.h"
>> +#include "cpu-idregs.h"
>>
>> /* convert between <register>_IDX and SYS_<register> */
>> #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
>> @@ -807,6 +808,10 @@ void aarch64_host_initfn(Object *obj)
>>     kvm_arm_set_cpreg_mig_tolerances(cpu);
>>     kvm_arm_set_cpu_features_from_host(cpu);
>>     aarch64_add_sve_properties(obj);
>> +
>> +    /* generate SYSREG properties according to writable masks */
>> +    kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
>> +
>> #elif defined(CONFIG_HVF)
>>     hvf_arm_set_cpu_features_from_host(cpu);
>> #elif defined(CONFIG_WHPX)
>> -- 
>> 2.53.0
>>

