Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7027CF30
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 21:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919541; cv=none; b=gahiJxA3NRB37WwvLY1Cri6ojjMVYbp/nYdiFm7Wu6h4Mf2O+UX+IXbFpUjiC9C1uzRy3mmgD82zckQTWzAh/k2VFE/6VaKegkd2lITSLs4TQzynOJnHiYUzTEgtXMgD24/mjpmE+vjf7/iojKUz4SSWoWXzmzYLfFLttWr+xr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919541; c=relaxed/simple;
	bh=pZKcp2KjROFs5m+dNQhzmstRd9CXjOvJLB+wgD77Bjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DOogQLVBrwmghZrMQGtaSW9tKtUtt1SkNFge3Q/LTSrsn1buuX+zvQDw/Jh/jUq2GwyVp/W94pcG2+YDbQFgttduyhjBDD0xA1oLGUbtRFvLfCjqNNtWDKvw1ClhafhfWGo/JP7uUuBah9GF35XQLk1FFz9bxkpwKrQ8Im5PWZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e6Vbw1EX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e6Vbw1EX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718919539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zcCrJcJNw8XqeadPeigXiSYqxup6xczi5xzkF2vw+To=;
	b=e6Vbw1EX0cVUDFqQMydQdV/L+TpONgDxrU8SZGbjdKd73cjUyLE41T10oS8Dtyb9MzEqF/
	3RYjpVv1ZbDwKKjl3Umc0NoDxUNUzBwcCN9o3M7hcjhKZrhfMFeaLxddxFWC2hDNPzGVi8
	M4z0HayImpX5s4L71F/LmpAPiKjD6v8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-iRzgX_v-My6Uo7zmtcwGSQ-1; Thu, 20 Jun 2024 17:38:57 -0400
X-MC-Unique: iRzgX_v-My6Uo7zmtcwGSQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52c94ad861aso921556e87.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 14:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718919536; x=1719524336;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zcCrJcJNw8XqeadPeigXiSYqxup6xczi5xzkF2vw+To=;
        b=rX/KckA3/kvuBPa+g6iEr2iD7Ge2VZ0l+RPKhjShnEZ6UkRMVPBpY/L9HsRFUAbOS1
         PtMntmu1x6iPRHN9jpv3DhDfMMaS5jdsyyuaCopRABgnmzgjv2EwBvg+1wf7EcVi+RKc
         FFGuJQktaKgRsbXMEpkKabpbk7DgiK9BcWeCIz/aiO/Y2mgkV9ISirUZPxwztKSexVrD
         mQnB1P/GGooZIu2g9fD6yv9paQwLuMkH82yNuJjekeskc3BA9w7a2fSq2/9SYJeB6hxm
         tC+JzbHkiEiIG2PveWiZ41zsKXKu1gof/8JpOgSXAL5PxKltK/pvPEeaK+VvOnqnfOay
         0yLw==
X-Forwarded-Encrypted: i=1; AJvYcCXueBZmMXtyspXck1lSLTZcj16L9iP5k077POgk9if3EVEmwD5wE3isrubnxbp1BNeNpjkcYuvX3A8H0cJChIo34MSHPxaX
X-Gm-Message-State: AOJu0Yzy80/hW84XvGqShYm8eWdFVklguN8zm7Xi2Dnv9P/ixGB2eQQK
	mjx2qDuOde0oYvoQziS3T3Lz9K5aZbqHhmA6oek7xFBXX1SnjPu7O22dYpI+DsIvHj2Gx1EEY0v
	oEOVa+LYq7ePS6h6jg0Yao4NPsX1UXqNn0HLV6WxsGKR+oiP9HOMYdQ==
X-Received: by 2002:a05:6512:1096:b0:52c:cb5a:a60d with SMTP id 2adb3069b0e04-52ccb5aa69cmr4531994e87.8.1718919535940;
        Thu, 20 Jun 2024 14:38:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzApSTysMjc5uyP4aPwfENejVJ+ORH7fNXVjT1VWSpbyJ9BNWe/RLF7pqUtPifgQjSvmTiew==
X-Received: by 2002:a05:6512:1096:b0:52c:cb5a:a60d with SMTP id 2adb3069b0e04-52ccb5aa69cmr4531983e87.8.1718919535592;
        Thu, 20 Jun 2024 14:38:55 -0700 (PDT)
Received: from [192.168.10.81] ([151.62.196.71])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a6fcf42a72fsm12670066b.31.2024.06.20.14.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 14:38:55 -0700 (PDT)
Message-ID: <035d7a2e-4b4b-473d-9a52-3699ff2dbec7@redhat.com>
Date: Thu, 20 Jun 2024 23:38:54 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.10, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Alexander Potapenko <glider@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Sudeep Holla <sudeep.holla@arm.com>,
 Vincent Donnefort <vdonnefort@google.com>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20240611184839.2382457-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240611184839.2382457-1-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/24 20:48, Marc Zyngier wrote:
> Paolo,
> 
> Here's a smaller set of fixes for 6.10. One vgic fix adressing a UAF,
> and a correctness fix for the pKVM FFA proxy.
> 
> Please pull,
> 
>          M.

Done now, thanks.

Paolo

> The following changes since commit afb91f5f8ad7af172d993a34fde1947892408f53:
> 
>    KVM: arm64: Ensure that SME controls are disabled in protected mode (2024-06-04 15:06:33 +0100)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.10-2
> 
> for you to fetch changes up to d66e50beb91114f387bd798a371384b2a245e8cc:
> 
>    KVM: arm64: FFA: Release hyp rx buffer (2024-06-11 19:39:22 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.10, take #2
> 
> - Fix dangling references to a redistributor region if
>    the vgic was prematurely destroyed.
> 
> - Properly mark FFA buffers as released, ensuring that
>    both parties can make forward progress.
> 
> ----------------------------------------------------------------
> Marc Zyngier (1):
>        KVM: arm64: Disassociate vcpus from redistributor region on teardown
> 
> Vincent Donnefort (1):
>        KVM: arm64: FFA: Release hyp rx buffer
> 
>   arch/arm64/kvm/hyp/nvhe/ffa.c      | 12 ++++++++++++
>   arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
>   arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 +++++++++++++--
>   arch/arm64/kvm/vgic/vgic.h         |  2 +-
>   4 files changed, 27 insertions(+), 4 deletions(-)
> 

