Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D71199939
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 17:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762968054; cv=none; b=YCsCoqh8WKDBqhSx4Jcvw6LNd/osw/n4BDs7DT3yiIwq3Adw3rH3GnliHwgwz7qv5Vw4MLnP1cK50vSfow5/vjm9W5dyi1RLIX7s1BPMJjR8oT1aFWWeSofEFq/Am+Ae9OI49JIKekOCFcRk50yELkKFoR07a6Q9qGAO4i0RG3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762968054; c=relaxed/simple;
	bh=zJTdw02ZMR3CZwXE3qzjXwrbZ0YYx/7A2oWWe0tCmMU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lqHL98URMYbMEU9TVPRaNsofjny+j+46JOm+nPA85CqvQVmfr6w8t5XQY8TSEe7ZB9U57Vf8IK/hueA1mQ+0HQOahstLFdgADiUAkPAO7gWMA3lLe2H73Ly69bB+wb4dnCA5EJ4C4Bcheza17StfwiVFwRcd3G6kPjLfc/k4fpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R5b6uVFW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5b6uVFW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762968051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yMxVuvAqoApe1n3kwx4U0GfXYBdIm/dWnshoZeslIHg=;
	b=R5b6uVFWQYeR+nk0uOXuWZ1rlIXyAwvAt/L8Ygp6M1wdBQ2bkHugCqmuH+xT14iDghKNt/
	pcYGjxgXQpzu0YM1LlYTtsC7lAKuV2KXJO4/gXgM94wq8F5093g5lORaw3BV7p/kK+J3uW
	BxV8BxQbDCaFiHr/rtLFp8mOfWo4ZvM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-hv9278RnPLGYTvkv319BNw-1; Wed, 12 Nov 2025 12:20:50 -0500
X-MC-Unique: hv9278RnPLGYTvkv319BNw-1
X-Mimecast-MFC-AGG-ID: hv9278RnPLGYTvkv319BNw_1762968049
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4775fcf67d8so11454295e9.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:20:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762968049; x=1763572849;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yMxVuvAqoApe1n3kwx4U0GfXYBdIm/dWnshoZeslIHg=;
        b=BDneMLA2Wt2Se6m9O078r5DEEEQbMmkZV6gX8tHBBtj69LTWjJuYgvcXHYCTYpAlkA
         dEenbldBTFKiNDa7T5r+ZNheKMNia44VGbyhyw4cuxma8pXhIaa6gPj5sc8LZcEa4nPb
         7r9AhkT9OjiSfTS5bPt4RmTWmCqwNBZQ0v+v8eUZ6wyvL6z/RDwRcFoRZjXewoCSxd7b
         95e3BQHdIaawJA0/mKeVxnvI5VfN6YSNFvoB2QC5P0OV9nCoME7IdFL/pPQat4yyIfRI
         hLSh+GTSc9Ju1PkQx4Zqog9m3Oc3fMWMCOi1CatGMJo1aJ5gPyov/o/sXfir8XYzJwgb
         camg==
X-Forwarded-Encrypted: i=1; AJvYcCW4VR8BoJbEDz/LL5cqhn/CoDodrGHLk941sADao+cBT1QztGKxCbsoofarniKyODOawOqa+C4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzvg9UT49/WueJaU13MFvSCgCSShDHDg8SauHPdsvwflGIbsxsU
	NCDqqgmu19TbT9zN1WAR5Fof/bR89a/82DBIiP8W8YR/o9LsHVpnCZ6oylJ5Bz2TpvrTWt6RrpN
	NDZSqDRChVz17M89kKETUA+5pGXrOa/BeYusy0iQSGVgAri68GrHEpTSFlw==
X-Gm-Gg: ASbGncs0z46XdJk/cQAcyt/phj42Ap5TUjxFQAhzEB+IOjlNKRdI36yuEb2PWtdXwOJ
	Fc/BeTH9eY2XfF7b9miQ8ZXRkuSq+2JhkRFzNOfBCgigV+sLU+5JUdBMz8zQWINCiJDd7LHFcIw
	xtfZRCZ2otLGtCKjP0av9sTOckWsvv7Xf5gzXWfLLDp0Id0SCESRiqXQt38XgR962nLthruZ898
	i7bu38Tw8rPCfwLse0FXxSnA0y4ye7Z7AX3Jb/l1XIST85Y1XkjjpAroyyEk0sw1wcnJSJscHCe
	kJbIazvgbRcn/2e1GKKUKxvE3TdtXv7ZRrUYEKf9tT/1strKTI7cRWHZOJsAeTm+8D5srrrILcC
	j5MyWSNZEi/7677S8iDuvD/uhe1T4wEwNqp47FhSB40ecBsPg
X-Received: by 2002:a05:600c:6305:b0:477:7a95:b971 with SMTP id 5b1f17b1804b1-477870a99d9mr38482885e9.31.1762968049292;
        Wed, 12 Nov 2025 09:20:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEegzjrPUmLH9up7bKJ2Gnf4SouhSesuQw86AewfqbDWeqLNOhar2BDeK/AVLyrimDmRdJciA==
X-Received: by 2002:a05:600c:6305:b0:477:7a95:b971 with SMTP id 5b1f17b1804b1-477870a99d9mr38482625e9.31.1762968048885;
        Wed, 12 Nov 2025 09:20:48 -0800 (PST)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e3a656sm46533675e9.2.2025.11.12.09.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 09:20:48 -0800 (PST)
Date: Wed, 12 Nov 2025 18:20:47 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <0795ff4a-50d1-4b2d-84bf-e1bc9da11ba6@redhat.com>
Message-ID: <cff8ff25-f4a6-6b90-8b90-10b8da7972ac@redhat.com>
References: <20251030165905.73295-1-sebott@redhat.com> <20251030165905.73295-3-sebott@redhat.com> <0795ff4a-50d1-4b2d-84bf-e1bc9da11ba6@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zkTtXPBnO5haW1ceOm4LxzAcWM_SGvhqJOZIV3tQ7A0_1762968049
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 11 Nov 2025, Eric Auger wrote:
> On 10/30/25 5:59 PM, Sebastian Ott wrote:
>> Provide a kvm specific vcpu property to override the default
>> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
[...]
>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    const struct psci_version *ver;
>> +
>> +    for (ver = psci_versions; ver->number != -1; ver++) {
>> +        if (ver->number == cpu->prop_psci_version)
> I still have the same question/comment as on v1. In case the end user
> does not override the psci version I think you want to return the
> default value, retrieved from KVM through KVM_REG_ARM_PSCI_VERSION and
> which populates cpu->psci_version. So to me you should use
> cpu->psci_version instead

Sry, I didn't get your question the first time and double checked that the
VM uses the default/most recent version when the property is not set.

I just found out how to actually call this function (via qom-get) and
you're right: the VM uses the correct version but we report something
different here - and in this version even trigger the assertion. Ouch.

[...]
>> @@ -1959,7 +2008,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>      if (cs->start_powered_off) {
>>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
>>      }
>> -    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
>> +    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
> I don't understand what this change stands for. Please document it
> through both a comment and a commit msg explanation

The explanation is in the cover letter - I'll move it to this patch.

Thanks,
Sebastian

