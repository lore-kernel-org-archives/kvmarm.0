Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5AE1FDE04
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 07:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740124342; cv=none; b=DVzvEaFZUbDCYEEFP7dFmRQG1Q0F90cjuCK5RqoU5+BD0QyWRtO9c1W2+Yp9QlmiZUH8WCGutign6FSdnF36ztqulbgCZc34OQkDrg7j5dsSQnysFbUJrqtUAfDuDogqF9JHo8NkPf8yJSjVAfzoVRYFVW6Kg2OD/M6n3EBMEWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740124342; c=relaxed/simple;
	bh=RjnkR8CLqAhZybuqbBDTZjGpwudzdSm6aoF+/1gHzNI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TN8UZoikGAY44US4GIZrNT/nKZtnGPmLOO+/6b57B11uqfbR4m12i0nKh3Intd4vYBBrI7kOKHAigiot3t3n0oaZQn9rnS8AbOk5bsfkOMvaHxAL1O2Tl9/qvohE0b3nZcLSD/ovG8Kn8X4Z6edeGj4pyjljVI9fREQTXlOkLf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBcAWn9c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBcAWn9c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740124339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rOI7Z+k/jw/HwkIzU4wUrpSnIOnbW4yX7Ts578dd7m0=;
	b=bBcAWn9cGqy4H6qmy4L3R6rfw0RlLDCMFoGh/MIEwdo9cwuNSg1NXIutRdcMiRWVf+WCAR
	Atij/qMDaZ9tV/S7w4L7MqbKE6sZ62j1fLxM91oZYsBe9nYZplSshRYU3tpSXBpH5vAiu+
	pCwZwPvMITK8GkGbE/oZyq7/N2Q+jx4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-BBCMlurhOlGgJqlFp4ab6g-1; Fri, 21 Feb 2025 02:52:18 -0500
X-MC-Unique: BBCMlurhOlGgJqlFp4ab6g-1
X-Mimecast-MFC-AGG-ID: BBCMlurhOlGgJqlFp4ab6g_1740124337
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-439a0e28cfaso9462225e9.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 23:52:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740124337; x=1740729137;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOI7Z+k/jw/HwkIzU4wUrpSnIOnbW4yX7Ts578dd7m0=;
        b=EWst5mfvBh7jGjZOJ4gJ6mZ+aMgl5l1NaMqa3/HucmcvUlyviZcxl+jHrb5ekZ6npD
         2SUAemqvMm1HmcJyr1/8apU0+sFSTqXTL99Edr4YcjmdjyVyeeYGhkqyS4wyaAuYX1jm
         oaFnx5FhpUcHe+OnzTWh1bk2YtSG0pwSFT7bsIfVPvt7MWw2pMtduMVNN07WRZRpukG3
         z8lYqn1nVFS1kQLl63ijiS2ecjHEOK35v1gZIx0wDebVvOyUVV0FdLmuHo09wvMUWJyo
         Aes26eYMWS5YtZtCDXBHbecGvGjS2dBlB+qjGfTLyUl+PGxXJYp46d3Lx99dtKAq2GIG
         loCg==
X-Gm-Message-State: AOJu0YxueVz5urTENFC8PHkJxnCVgJ0UY9k3NwO476lJ/eNDxPjXhZXs
	qeqseGGXLYpmDgy73VsrbGBDxU+DxMoLqxUzg9HYMrHS2kp8k6oOueRik3+p5xYWcLgyk/CHGgF
	G6V9gGIgb++n8SPYQMWKjuMON3sqN6aray1xl6G8hVZoAUSGSGMpoYA==
X-Gm-Gg: ASbGnctDkLqPPHNuDiRTL46cjzNn0fLsXOBPsuzac9PkkmXJPbe2/44rs/d/Qtt9+dx
	vwZ4PR13P/jGP31PpBek8S+WfwXieusttg0/sawSqPtidG3jYH2YgFPDzZuwEz51z24hMa443EC
	YDH9T9pwDghncpc3W7BlmIB0UIyo0NEEK+0rRo9SfOBBDYpbwk7tlAbFx7GIMY2RLvjlTlyX7pC
	W8+HFmRcp1eoxDIqbejCf72WLMhXSEVwWchUeWIaCEctPaQvEcMbuePHxVUvMG9ub3z96Y/sdoc
	YMhoO/Qh5n4JhVUra1rT3nCm0sGgeWccv/dd9F792UCh3HVTGzAiqC/eRt2na1pH
X-Received: by 2002:a05:600c:5246:b0:439:9a40:aa09 with SMTP id 5b1f17b1804b1-439ae21d202mr13079595e9.25.1740124337019;
        Thu, 20 Feb 2025 23:52:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6RndQ6ymoZEFzvzfDt+1GKRpaPngpEuFYmDAHqGLJUcufH5YS8MWYZmZqlHO+/W+nddETwA==
X-Received: by 2002:a05:600c:5246:b0:439:9a40:aa09 with SMTP id 5b1f17b1804b1-439ae21d202mr13079435e9.25.1740124336660;
        Thu, 20 Feb 2025 23:52:16 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02ce735sm9240925e9.3.2025.02.20.23.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 23:52:16 -0800 (PST)
Date: Fri, 21 Feb 2025 08:52:15 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>, gankulkarni@os.amperecomputing.com
Subject: Re: [PATCH v2 02/14] KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest
 and userspace
In-Reply-To: <86r03squ0w.wl-maz@kernel.org>
Message-ID: <5f9699c5-ccc8-9339-bfca-1ace8d7f86b6@redhat.com>
References: <20250220134907.554085-1-maz@kernel.org> <20250220134907.554085-3-maz@kernel.org> <af16f5bc-4300-54d3-b480-c559ec070a44@redhat.com> <86r03squ0w.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xvSpRdEZ7xOPwe3alW94sFtDM3ixVhWordvR71coiIo_1740124337
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 20 Feb 2025, Marc Zyngier wrote:
> On Thu, 20 Feb 2025 17:36:35 +0000,
> Sebastian Ott <sebott@redhat.com> wrote:
>> On Thu, 20 Feb 2025, Marc Zyngier wrote:
>>> Since our take on FEAT_NV is to only support FEAT_NV2, we should
>>> never expose ID_AA64MMFR2_EL1.NV to a guest nor userspace.
>>>
>>> Make sure we mask this field for good.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> arch/arm64/kvm/sys_regs.c | 1 +
>>> 1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 82430c1e1dd02..9f10dbd26e348 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1627,6 +1627,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
>>> 		break;
>>> 	case SYS_ID_AA64MMFR2_EL1:
>>> 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
>>> +		val &= ~ID_AA64MMFR2_EL1_NV;
>>> 		break;
>>
>> This would cause issues when you update the host kernel while keeping the
>> guests register state. Could we allow to write (but ignore) the previously
>> valid value? Like it was handled in:
>> 	6685f5d572c2 KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
>
> Yeah, this falls into the same "shouldn't have exposed this the first
> place" bucket. Annoying. Something like the diff below?

Yes, thanks!

