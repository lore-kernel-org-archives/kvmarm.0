Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8D25F797
	for <kvmarm@lists.linux.dev>; Thu, 18 Dec 2025 10:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766054879; cv=none; b=Qd8WiRaZ6JLzrikfmsy/a5urjPn07WEqe9dOg8IhEbnzwWyNLEYtgH8ANJ6nWZB8930Zeo9zFhe/io+jf8FbvT7tKFBfq95uQ+BhfK1c2vLCheoNFNaT/0iYjJz+jNIk9+xaee6rnDn/4JvoxCq2sN6eiMqDb12YUXI/HKeeNS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766054879; c=relaxed/simple;
	bh=bC5rC0odBPaYGZvlXWgt5joBmxtgcwQdHn95OPKSfxk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UM1Wqx92eR8XC0i5aa3ZczHnqqRqZBsatVC3vdW0N6D7hCFYc9mdgYlztHr+7prNDZn5MHVEK1MUrvN0uVReboieIAn5ASlpU2c8PPCeaNNsVVZZkgQh9ag3JlFWUIwSh4Rur1zXZc6R5bQAcfxoWrDYxCEay7K9RXSaqIuWbeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chaCpu8v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chaCpu8v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766054876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pp9UhEKJ7Aa1makSg7Sp20zlDcbU41vV+Bf96yUQzM0=;
	b=chaCpu8vtcqvwqgKW7z4w+5/o3/+6f79bTJ19LgDuQ0/d+jsSB4BWxsP76wTNeey1kR6Qp
	qfiJMtTHJ8vvWRmgJu3lTtVDby+uXLI9e9W+xwyM/atOtbQw15w6yP03Qb+dIXYswriVOT
	dCpAJ3hNSXO8nQLawX9oOme7Hcd569Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-twF_mV5INsyWFaRFyvy1uw-1; Thu, 18 Dec 2025 05:47:55 -0500
X-MC-Unique: twF_mV5INsyWFaRFyvy1uw-1
X-Mimecast-MFC-AGG-ID: twF_mV5INsyWFaRFyvy1uw_1766054874
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42fb1c2c403so333896f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Dec 2025 02:47:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766054874; x=1766659674;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pp9UhEKJ7Aa1makSg7Sp20zlDcbU41vV+Bf96yUQzM0=;
        b=VQ6IVsNxGOVCEz6+KBfvb9LidP0AZNw5If+28OD+lta2gmnQsCaSwnQ20Y/SSTJIGZ
         gsiFhYwXiVoBe/dTB/QAroM1t9iDeTTN+X4c2CP+i9Z1ZT3Il1gb3ybuQseuYERNUXq2
         6e5vauvHbJ33QETAsQAp4DWCpB9WyFi5J9aF8MCfO2XIKOoYuq+Aaoqdr2+maNdvNNm1
         UZqowNqe6obXNSEHIDcc9Due9Dd/a3LKefLVIMpFfBpI5OpMEVVZkUCXHcHsBwi053ws
         /dhG4JCEldMZsRrFFCH9jGjT9uwXoZKmMvzDtFf0yFy4gTZnBNMOQA94BovF6iEBv3wk
         UjHA==
X-Forwarded-Encrypted: i=1; AJvYcCWq2/6tICzEwiobn/yPLF2l4r6sh4NhCoSChyKkJy+6WKPQlMbWOP9WWHgoR9rZZoxuZb5++j8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+n8MaJGs5V7MlN1NP1og7Ru1ugGgUH1dJBktOKyvx4WveNzwu
	zWe4beZTbNzCRopdCwnZkciDNohFSEaSDWnQ1FJa95WURZua1buCYpDaEXLwvUak4ykJ6qqaNfH
	nEOwQWksDl1rF74Sml/vvaB7nKsbPeGN9RxCGR4MqpqIQahL9+01NSBtvTw==
X-Gm-Gg: AY/fxX532EL6OU9YRsD7yXTpU8U9KcDbYZSDZKfWosO6hveVAqI2AHyhcGXcD5EtQ69
	WViqKgNFj3tV0y6dghHVcNRaDDm0cj4zW9bcGuQfMk4gnkKMBEmY+lTjDqecku7VQwrwuD0TToZ
	bbDTXjT7F7PBfleChprxle+YuENrdAPZaxke77z8yX2joRxEdCMEQyvtGpNkoLLbkWq1kvK0lRz
	svPfrJxuW4SK2CIMK5pkxT9827ebzcH4EXlRhfXnWENpzQ5THcR3QFLdAAP/jWkChoM6nbB8EHK
	APNPUIrvAwIpdYirxYSBXVPUc3RrY16De4llKxV1zSwXurYam6VAwGtEHSu1YV8js/5as0qZ+Og
	GkxsQhFpKWdKCrFbGzkMlx5VOJbQsgD73O4Ay09GfpVXQY/ngyXfSOtLdYQ==
X-Received: by 2002:a05:6000:2310:b0:431:c73:48a8 with SMTP id ffacd0b85a97d-4310c7349cfmr5741365f8f.29.1766054874046;
        Thu, 18 Dec 2025 02:47:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFuywpjPrOv/NfID+cPGxbswKBxASUTRoemJwfrew+cKOcN66jSr00yj2VRvWLEsTsvRQvgw==
X-Received: by 2002:a05:6000:2310:b0:431:c73:48a8 with SMTP id ffacd0b85a97d-4310c7349cfmr5741323f8f.29.1766054873556;
        Thu, 18 Dec 2025 02:47:53 -0800 (PST)
Received: from rh (p200300f6af0aa4009cef065b67c5ea88.dip0.t-ipconnect.de. [2003:f6:af0a:a400:9cef:65b:67c5:ea88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432449987a4sm4239256f8f.31.2025.12.18.02.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 02:47:53 -0800 (PST)
Date: Thu, 18 Dec 2025 11:47:52 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>
cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/2] arm: add kvm-psci-version vcpu property
In-Reply-To: <20251202160853.22560-1-sebott@redhat.com>
Message-ID: <ea9d0e28-27eb-be68-7292-780c0120f1c1@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z2Ahu7nD0luVU1ZQiU0yPEkJXOtAspKzZaj4f_wvIT4_1766054874
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hello Peter,

On Tue, 2 Dec 2025, Sebastian Ott wrote:
> This series adds a vcpu knob to request a specific PSCI version
> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>
> The use case for this is to support migration between host kernels
> that differ in their default (a.k.a. most recent) PSCI version.
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> Alternatively we could limit support to versions >=0.2 .
>
> Changes since V3 [3]:
> * changed variable name as requested by Eric
> * added R-B
> Changes since V2 [2]:
> * fix kvm_get_psci_version() when the prop is not specified - thanks Eric!
> * removed the assertion in kvm_get_psci_version() so that this also works
>  with a future kernel/psci version
> * added R-B
> Changes since V1 [1]:
> * incorporated feedback from Peter and Eric
>
> [1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
> [2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/
> [3] https://lore.kernel.org/kvmarm/20251112181357.38999-1-sebott@redhat.com/
>
> Sebastian Ott (2):
>  target/arm/kvm: add constants for new PSCI versions
>  target/arm/kvm: add kvm-psci-version vcpu property
>
> docs/system/arm/cpu-features.rst |  5 +++
> target/arm/cpu.h                 |  6 +++
> target/arm/kvm-consts.h          |  2 +
> target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
> 4 files changed, 76 insertions(+), 1 deletion(-)
>
> --

Anything else that needs to be done to get this merged?

Sebastian

