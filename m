Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799EA282F25
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989483; cv=none; b=P0uErZhHxpfKBIpXb+7Aa9Rer/2VkzzvI4TSQKNR5LgFZRInYbDLc6iNaxMW2sLQfUoQbaolTrabjODha3UXrFeDTTjqEx1uOSt3LgBqQV2EIN8kq1qgQ1A3giVmPl/U1TiErFRFNlomFzxmSQV8KqHMo4roF0x2I6VngE2ipic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989483; c=relaxed/simple;
	bh=/BOsi9QamalVG6jXM+i5gkiOleRVC9p4XJ2aNBEcyIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FZUgJBRPpoytozmoiDVAw/dIgdYS+B1AY052uZkx51kzUhVW7HET/yyr0RAI1z1pE1ZsRmnjVIue1ftnBpwklWes6vTI0oErq05xxL8Rh0bDD5brS17/OYl5iqK4OEhczpp0+GY+3250FRjXdcHxEOF2/fETTzIBdzt0EWDspFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QnoJzyU8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnoJzyU8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779989481;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M0MvIsOMtx2WQpp0fYhvBDybCxrQLnoGgi8za0wNTLo=;
	b=QnoJzyU8/m1uphSC8yQJAz7P3WnlLEBBiGW91ZStvGpDkW5/FwNXxj90r3cTFi3lfqHRXp
	RZJRUSSao0paPUoZs17H92ceTZ6mDCJkbu/97DWU/vZFkEGtKZVux+G0E7zScXC3GWw/WF
	NPhukWtvrwoUxTTfsHEx01BvLEv8Awg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-60AVTUY1MMCSuAOL0BLPSw-1; Thu, 28 May 2026 13:31:17 -0400
X-MC-Unique: 60AVTUY1MMCSuAOL0BLPSw-1
X-Mimecast-MFC-AGG-ID: 60AVTUY1MMCSuAOL0BLPSw_1779989476
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45e2f74da10so12093466f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 10:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779989476; x=1780594276;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0MvIsOMtx2WQpp0fYhvBDybCxrQLnoGgi8za0wNTLo=;
        b=FdtAL0ej5JyQ/tbUXMdOfj5zjvWlxn3JXwfeAcV7XpS4ZgfGazT/IXYf0j3QeWjQ9p
         3sMFMGNBKzmX1qpbb+nTdmLnoQkgNM7BudW+MXiBB27/DZKKU6Y0BNUXN4pmu6mWiKFr
         nBk4f3iEKC7SM8ZhLdgXlgUwi8gILFWEDPOQcnRQHQY6KTkJhZBc+5ZUe8m6xXy/s3rr
         1Lk62TLjEV4rMfOpyS1bFhIxED27G2Tm/wggXbS/xOw7xs+QFIQH78rgxuLGpgsTb/xM
         mF8L8yZHuB85kd+xdyqMakkJjMdKmO6SVILhcmNrdtx1prluoLMQZk0s/8WVtvMrhVLQ
         ++cw==
X-Forwarded-Encrypted: i=1; AFNElJ8Rt7MA1evtJm0tLv3L999ZeakkYHud7aZoq6ppJLFkjwHvukF/s/2c0AQi/Bbd828UF/7N+bM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyL9kWYiOIR7p2iM8NjEX0Pf/o3vHz3rzwiP5+EeZV4gFImSrBz
	v+djbxLVr//ke8QbVKySDaGCkfIgA485m8CNqCrcJe27VFz6L/ydypvhBo4aTrsmIHbMOEpm3Fm
	PHsbiOPOmsF4w/3EslrG1pVhacROueM5ZT8RVo1nQHvhdLXYfp/LKzOliRg==
X-Gm-Gg: Acq92OHhC4fLF2ujU8PgcdInXA0Dbrz88uMh7kdg0sDCx6pZV9DB6kYGZoN+IRkHaRJ
	oFnS58z2kNGbH61zNT+DFVD8zTTjynMd0EFHCvQUXAWVHtZGxoQdi8clWhJLLG8pOAO6PruXt0s
	K5GF0ygZjwNkCjTCN1qEBlw2KAwI++P3ScT3E6ejmoWtsvVT0i7DiKuPk7YUX6ZUpPuyS5Rt8B4
	kq0+WuGxw8Az0PBGBJNDe4vprIQSsu9Nn/9VuVuIDAt7ZZZniGyEBobQ7Sqz8KXcozSFROr2s9J
	DUgCC/lV8igzpsFSYXXwvFBxRBmGc6O3GV4CdMt/zULr/RtxsPUB1WwdbzmesOzcxeu0SFujIsf
	ul0OitHSGdAeWSIdgZu1xpsQ97SaaS6kI+bXatFgw104NzGq8DRNBfnhWi7waDG6LFV4gQspQst
	9aNLYC
X-Received: by 2002:a05:6000:4698:b0:45d:41e0:467b with SMTP id ffacd0b85a97d-45ef02895dcmr144948f8f.3.1779989476337;
        Thu, 28 May 2026 10:31:16 -0700 (PDT)
X-Received: by 2002:a05:6000:4698:b0:45d:41e0:467b with SMTP id ffacd0b85a97d-45ef02895dcmr144891f8f.3.1779989475906;
        Thu, 28 May 2026 10:31:15 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5b2bbfsm15454279f8f.32.2026.05.28.10.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 10:31:15 -0700 (PDT)
Message-ID: <ad70e8f8-0dbb-407c-828e-96b9da188974@redhat.com>
Date: Thu, 28 May 2026 19:31:13 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
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
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-17-eric.auger@redhat.com>
 <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
 <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
 <CA136979-E0CC-420E-9271-63CF27CD7DA5@nutanix.com>
 <2fd2057d-c74b-4bbe-b2d0-cb9ed092a37d@redhat.com>
 <6F6ECB0E-82A8-4FFA-8687-2D6E243A2096@nutanix.com>
 <8ee2b611-ef48-4805-aaf0-087856dc30f0@redhat.com>
 <7737B413-51C1-49FA-AC0C-31DCEE1FD45E@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <7737B413-51C1-49FA-AC0C-31DCEE1FD45E@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q2aplyFUQf7iZ4P8Tn7JchE7iJa9XTryNwdnRI11tdM_1779989476
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 5/28/26 7:29 AM, Khushit Shah wrote:
>
>> On 27 May 2026, at 10:50 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> My reasoning was:
>>
>> arm_cpu_post_init
>> ---> kvm_arm_add_vcpu_properties
>>     ---> set_sysreg_prop set the new value in cpu->isar.idregs
>> arm_cpu_finalize_features
>> ---> arm_cpu_sve_finalize
>> ---> arm_cpu_sme_finalize
>> ---> arm_cpu_pauth_finalize
>> ../..
>> those fonctions do some subsequent isar accesses
>>
>> So I think in general id reg field settings are applied before composite
>> legacy options
>>
>> Thanks
>>
>> Eric
>
>
> Nope, kvm_arm_add_vcpu_properties, just adds KVM specific properties.
right, wrong copy/paste. kvm_arm_add_vcpu_properties just registers the
props
>
> Right now, set_sysreg_prop are called along with legacy props during
Yes options are applied in order but the difference is ID reg field
props settings directly touch the isar array while others are stored in
some temporary field in either machine or cpu code and analyzed later,
for what I see in arm_cpu_realizefn(), either in
arm_cpu_finalize_features() or directly in the body. So isar access
related to compositive functions should be done after those related to
new SYSREG_REG_FIELD props. However I acknoledge the requires a case by
case check and testing.

Thanks

Eric


>
> The call stack is:
> machvirt_init
> ----> set cpu specific machine_props (has-el2, has-el3, mp-affinity)
> ----> dev_realize(cpu)
>   ----> set cmd cpu props (prop set in order they appear in cmdline)


>
>
> Warm Regards,
> Khushit

