Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6327335A289
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606357; cv=none; b=fcU236rrJNNkmXQpLR4OAKjOJslfgKXfSHOWXj0oqQ7HmItUHGpYRUCeHjR6hcYtteuUNaiwgWpZZWCXWcDAbyzXXvhL7YNknmD9QIWEUAbxsEtFGqMsm9IAb0rGDZBN9v9bYDXiaE+pe6kQYS5eGqhpur11DQx2y4wTSp/gjuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606357; c=relaxed/simple;
	bh=+keLsDcloT+l1tCpllvPad+fvbNkbpnm2LprNAM9gj0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Lp13sbjpRZSNmC0F0F9lTFmUwzcPnPIhVqFfyRGRCMRCQLbQ5wxp+Bmn/BD50MRj1+KxchezRf1yKL7VL4diIPKLOQvelbZzbwNVwwqkg0f7YY+oWQzJH0V+w08s7FPiztcuIWMsmTdS7cfnbuQ8rrXOB8dsvRRmmes+QmaK0KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SOF8lDfV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SOF8lDfV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757606355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5Gl87lWcfunzoYrVE0pRSftB8AHiSUHljE7szKd1ws=;
	b=SOF8lDfVrWfTTzp53yPRKXlLjiRp2VBx6MftptPIP10BBq+fVnLRnwBOJccXerkkAzcDVS
	xjiMafgQH8qrN8B2Juno38aUtIA+WksjXklsdEsqqxo+vjXm+ZTP4/2f17DBHlJDsvyQYl
	ltpoadxoOgaIXrLUQB4EfYgL6jk3F4U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-nVCFIoxaPzO4pW-Mht91fg-1; Thu, 11 Sep 2025 11:59:14 -0400
X-MC-Unique: nVCFIoxaPzO4pW-Mht91fg-1
X-Mimecast-MFC-AGG-ID: nVCFIoxaPzO4pW-Mht91fg_1757606353
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e7634eb959so366373f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 08:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757606353; x=1758211153;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5Gl87lWcfunzoYrVE0pRSftB8AHiSUHljE7szKd1ws=;
        b=FUj17ObSAJsI3Hq8elag5WYVyPeTTnzX7027cj5NYL0pbsAJCAEhiOpfICgvJZzMdp
         A8YVbxDGotKVYeQ7S5ukTgCcgtRycIEbLir5bVh0Is3DrSG6p00PP4pzzwMTmYq7PV38
         rbCbVSg4CeXrxcWoRSCMwcZiyPZ3ObeoF4dKe2NUOUgCK1KMAgAiA09PkuShWBoDqfVe
         jT8ZKRxQQTAbBJoLIKzKZu4u+B4PylKI4PN4KWp5RfYxj5doitpbm1qZCTlEAxqfzsT6
         Rxqem0NZN7AzwzMfBA9N3zWYAczGJap/vv86eKVyGxH1XIQQc0cOs+nFW4x2Ow5tcFK8
         n8Tg==
X-Forwarded-Encrypted: i=1; AJvYcCXzm3fL18v8HDeRKkAtYfUuRN3w2dUAhBRZi0713ATrBeOeRqjyZ/J0hsCIyHs5rRNEaohNZw0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzFTLwkL6RRlc6XI2hiU98nwqwX7KYqvX36NcJKbdx7oqXFb3E
	CP00Gzz5fECoNDc4OkzYzZHO3slV8qa/GpcSreIDC5zG42e0MeNpCaTcFqp8xDEGiBpYLEO+/e1
	Wfi1dZMPMaqonQ38Wysoz6FrWoZExSJgpDc7lv6eVLE5zymUFSr+yGxYcjw==
X-Gm-Gg: ASbGncvLloxLILWZfFTxa22NIn9Fqw98mvVqKWcoiYR/fWJasQmHda+l1wBQn/OqHVY
	die89lse4CkPLEHjHG8pFRWK7JfHm0uUWzPFyXZ3o+iWoTeXmxU1VkLiKLAOAlNUMSflqtqyxuO
	y0duHXEzNi3jNbBqbl0emNz1sVHyV34i2kz+uhDD0PfFI7xGCiHwo16lSRneatKi8xa7M+ltT3y
	T3OjztGaHU8Uwcn1h4HHYSVktcOopwRzZyRgRyuz9uyyL+Pxdo9QCT3rFcAqIbmscjsa3ycj1tT
	8kcvx4em3gr/7QhZhdKlpF7Her2SL3BQwbKmAfaKBvqUPlPx4o0scmmFVBq3m0an+CGwH7M/jIT
	rozscj2nnG36zIQ==
X-Received: by 2002:a05:6000:2c0c:b0:3e7:468e:9327 with SMTP id ffacd0b85a97d-3e7468e96a8mr14020608f8f.2.1757606352713;
        Thu, 11 Sep 2025 08:59:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSrB5/to6QW2nPvAuUd/WlR4t/Ppb/lRN0E5cuL+7TESs6xG+MxArSdkCRJmxRGYUa2+tbqA==
X-Received: by 2002:a05:6000:2c0c:b0:3e7:468e:9327 with SMTP id ffacd0b85a97d-3e7468e96a8mr14020593f8f.2.1757606352333;
        Thu, 11 Sep 2025 08:59:12 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01865ff7sm16651975e9.2.2025.09.11.08.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 08:59:11 -0700 (PDT)
Date: Thu, 11 Sep 2025 17:59:10 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
In-Reply-To: <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
Message-ID: <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WyJq8p1Z_BoAGzXrLzjsO1Dc_D0os43lVncyLcmO4vA_1757606353
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 11 Sep 2025, Peter Maydell wrote:
> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> This series adds a vcpu knob to request a specific PSCI version
>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>>
>> Note: in order to support PSCI v0.1 we need to drop vcpu
>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>> Alternatively we could limit support to versions >=0.2 .
>>
>> Sebastian Ott (2):
>>   target/arm/kvm: add constants for new PSCI versions
>>   target/arm/kvm: add kvm-psci-version vcpu property
>
> Could we have some rationale, please? What's the use case
> where you might need to specify a particular PSCI version?

The use case is migrating between different host kernel versions.
Per default the kernel reports the latest PSCI version in the
KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
when that differs between source and target a migration will fail.

This property allows to request a PSCI version that is supported by
both sides. Specifically I want to support migration between host
kernels with and without the following Linux commit:
 	8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3

Regards,
Sebastian

