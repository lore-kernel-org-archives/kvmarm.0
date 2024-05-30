Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D8A174EE1
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 11:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717068248; cv=none; b=oy5MOnTppgavkyBFFOwxx2QyMhNn0cw2a49sLU5RR9SAOwhK2L1CxqXHysOD4Dc/M/zyVHdvXxGv6JNrnAQ/qHSAukeJEbj76vnmi599BQtrPw7Bx4Eo5jOMssmnFYCENxwiT7K5hXf+Y8ZlwzXXLxVc73iEFRfYuyDom2bz1aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717068248; c=relaxed/simple;
	bh=sNrG5GtduqAbl3w2tWvygq9AB0AJPR/OLaPsZbcXii4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jVMuggs10JZcpLkb9BkXiDFwr6EjD5r9HNs3VFuWMlI6NTDvUeN3932qROVhFsJQPkE5qSWlDwKXGH0qH62wHZQxukUdj+by6EhfPvjF/dug5K9wMX2HhrzOpkm4Bgcuxcy8O7ZLA4POvxQIFnptn9OgtlzBvP2J7hyzJAYDU8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OzIOmrRA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OzIOmrRA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717068245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q/8pBmUJMwOhM1MwppK6WjUaOZ3O4giQHKY4X7HbrT8=;
	b=OzIOmrRAynfOLdceDY6sxVhEgBS5huu+Mi6+laHuZ0e6gZMO0akADM5oZBXmFQehda8tJd
	QGVxm6NVyV1Iz20KKLYjvhLaklV3d7EOqA/Bs4ltsEAuSyT1R1a1rPVae8sfrJltKKzhri
	jnIP2s8iuY0mWsfcywca47mEyOWdwSc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-XLPSkxwvPMGaAfvb7WE2Jg-1; Thu, 30 May 2024 07:24:04 -0400
X-MC-Unique: XLPSkxwvPMGaAfvb7WE2Jg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35dcb3f1ab3so239745f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 04:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717068243; x=1717673043;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NyFVukIA+6eMErT5jIwX1F/VfLDC/ji7PYywadLXOr0=;
        b=rNIz9KIkrogWRpqLjmLG7mLEGLyP8WoUdMcqEIT86p5/wSdEKmH6/jrB1qXDh3JWoU
         Eow8OcZdng9PakM6Z09CErrQZmItt90NVyVmneAvgaUsJ2qFdMHOhZSEaLEPqF/gVgXA
         5zCQKlhoPk0KZZ9lkSENni8CGZUMSmduY5bHDfdJfjHIPjYCDpJ+pK+jJjiJrqt+SzGE
         V5MkCWV1VgWPSMdw4GrNs8l9TUeDPkmOaiElJ5VESetZJjz2DVGXaMejq56zwLxz0hJC
         CB/Ei7mtTTCWIfsn+hs8OModbiG3UK+n6daJ8Pn7NYBwJ2BsyOrHjXO4jLvHeSmEfJ2k
         q5LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCAeLxPfyFKgfSDGFQC4gNh94I8/Ylt4SQgMjXs/Ck6uFCJ6QASmsq76DW8obgjxTl/o8w8F1EIiNX+4qdnKjvJbsl+OXy
X-Gm-Message-State: AOJu0YxexjV7kSiDhos95tYaVdjOq10h43boEeu+V8vBc8xr8Acz4WPg
	E4744vDckOILiv6Iow/3jPnGLTnUkxhBVIIGrxECqZV96O9RE8/D7e0WjflghOO3M7QrmvaLUdS
	o2E4TuVX9kaICoHuSvanWY3wMPupCLIinjnj+JwQYYOukPZRbx4aXdA==
X-Received: by 2002:adf:ef0c:0:b0:357:ce05:7533 with SMTP id ffacd0b85a97d-35dc0099613mr1211457f8f.40.1717068242862;
        Thu, 30 May 2024 04:24:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOLwH0ZFTriyl8uzTdycdGfXdQu8TChCl2APlRFv5WkN/IIPx8ecBsis+IyjdEMOUVvO8E2A==
X-Received: by 2002:adf:ef0c:0:b0:357:ce05:7533 with SMTP id ffacd0b85a97d-35dc0099613mr1211444f8f.40.1717068242417;
        Thu, 30 May 2024 04:24:02 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3579354abd1sm13832465f8f.59.2024.05.30.04.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 04:24:02 -0700 (PDT)
Date: Thu, 30 May 2024 13:24:01 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eauger@redhat.com>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 2/6] KVM: arm64: maintain per VM value for CTR_EL0
In-Reply-To: <2dcfc174-9384-4746-833d-1442bcfb6d11@redhat.com>
Message-ID: <a0295969-eff9-5330-cd1f-1e41b8f43eee@redhat.com>
References: <20240514072252.5657-1-sebott@redhat.com> <20240514072252.5657-3-sebott@redhat.com> <edbe3039-ed42-432e-8309-5a0a46cc2d5c@redhat.com> <90e53cc7-039f-5abc-f94c-cf53a1602a2a@redhat.com> <2dcfc174-9384-4746-833d-1442bcfb6d11@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463795790-1183132592-1717068242=:11201"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463795790-1183132592-1717068242=:11201
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 29 May 2024, Eric Auger wrote:
> On 5/29/24 17:51, Sebastian Ott wrote:
>> On Wed, 29 May 2024, Eric Auger wrote:
>>>> @@ -3557,6 +3557,13 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>>>>      struct kvm *kvm = vcpu->kvm;
>>>>      unsigned long i;
>>>>
>>>> +    if (!kvm_vcpu_initialized(vcpu))
>>> at this stage of the reading, why is the above check needed?
>>
>> To make sure that a later call to this function doesn't overwrite
>> the value provided by userspace. (See e016333745c "KVM: arm64: Only
>> reset vCPU-scoped feature ID regs once").
> but isn't it overwritten through the .reset=reset_ctr() that is
> populated in next patch?

No, this is done via reset_vcpu_ftr_id_reg() and also guarded by
kvm_vcpu_initialized().

Sebastian
---1463795790-1183132592-1717068242=:11201--

