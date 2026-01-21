Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379C52C21DD
	for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 09:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768988363; cv=none; b=nZemQtKYBQSjnfspikLfY8eklGM89SaR06kRMU8nAzv3dL8Gsg5RKD1KbTnQ8FO9KASzAjS7o3VrWHeDb1IT5mVFlTLTs6t2YtpR90EyVhsW+sqBjtfc91+k6bXmsMs1Kml4Y4BIe6G29pFUCzGH24B18zESTpwWHKzWpG4yjyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768988363; c=relaxed/simple;
	bh=6TUgpJxKh+r42S1F4Wrkpyb8Ir4NoTjV1eG8SILKXOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sL9Zl+b3N0jLRroeUq6HavLtopOBEuvchn9w+5r9lwps5l3IHro6FLDPGZLKqn4ZCDNeVYYodR3L7jwC5i7oey15uqNt0yksih+D2Nayn413OTicBxPG5QbRxXqllwgL3+xbxsFiJ94htEEosYI5+IJzooPvwtkVaCbTuitpByE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U37TlUUr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U37TlUUr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768988361;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t2/xT8iPwxVBhXyFiskTxjU+UnFqiORTdZoi4L7IpKI=;
	b=U37TlUUrrP15/sjXyEj2btYruaUPaIGK5UARPapHFfHXp52gxzO1r0sm41eVJiLLkCw49I
	6ggUWFF35VsPYhVgGzxmnEM6Mgf+XpIGF6NOGyQnzC3UZy4W8tlo1d2IGEHbEwgRiknA1n
	mtQ56c/S6dpqTqTdV9p8n5PE7SyJP8I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-1ssNS6VEOJ2oq6eEPmr6Qw-1; Wed, 21 Jan 2026 04:39:20 -0500
X-MC-Unique: 1ssNS6VEOJ2oq6eEPmr6Qw-1
X-Mimecast-MFC-AGG-ID: 1ssNS6VEOJ2oq6eEPmr6Qw_1768988359
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47d3c9b8c56so72917965e9.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 01:39:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768988359; x=1769593159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2/xT8iPwxVBhXyFiskTxjU+UnFqiORTdZoi4L7IpKI=;
        b=GxyzXP5ePDkF7MNHaXSrzVOgHsV82oOVmBC/3KGx6dJKGFsVQIWQwWPF1u1Mel1Skx
         fFDAyD3cwaS5jD3keE9dP+5ARuPeOeukKAOXZnoUDKvkCfpZiNRoFD/Nx/8lnx2mUGPi
         Fl9Hd9j+dSsOa6a2dZwMYm7pSho3uGqGrGydYCyxUhpKrhvr9uoXS+edi3WrvDm6Fnu1
         37W3dxz+ffDCOF1ARO9ZCSJPJBbqAV/JojNAp6vXlMKU/4nwVl3+wanqSAyg2ZD5WhuC
         Cc8JZY/Mh+/NCJrw5EvSE8/QJ8EXbFgdhYR0nOlbZ3e5cI57wbQIWqkG81f5kVWdswSy
         WVqg==
X-Forwarded-Encrypted: i=1; AJvYcCWTC5kVlxeOq3KU2UHJtp5wjYqYSdOf1AnBLbtUUKpXKCu5+eDvOWWfYB6nnxzW6RMNHBsIKDg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXdPKMsX9aTgZ7416wxehiTh+YuFH87LlQ4e4iFKmGfQ7eFUyZ
	Pbk8lgiY7mnae3jZtGUJo5VSpLzHsmrgzJ36uu/1AHT9azhaJEzaPTTG832ae/+e2KBOF6622yo
	skTGvKMvbEwipEQnDc1K6JRl5rWp3fhXP8DSEVPEA5QiECIWMXHtOkEkqIg==
X-Gm-Gg: AZuq6aJK6Jt9YImqv+CVLtrdBnbnRBtdSN7anZtpBhDK1bOHm0HIX4YhAtAWD7EU0b8
	tgjwxt8ua1mkkkkarTiQR6Sx6vXzf6b6GollCqhiF1S/4OwLhIBb++s/tzorWRqYHQab3EPfY6c
	YnrjO5DmJf3WC+dL/Rfv4BMPKHvPwk4744Myb83ieyoDxY13r+8eSnhor8A0KbByH23MOZQXCSm
	6q47U490LXDBiLw0pNmqzzuZ8U6GJ2RqyH5I/Gql0IfQAG12q4WhKM2cFBeNjWrWPjzi3KVQwUJ
	DUWsc2bjW8sWoXbTe7c9E1k/q/BYo13vkcaN7gAhqnkgXCwXdx9uA+ESy6kvEnDmDan6l68OrQu
	eRbJ12wEwWtJNZxwGgTbW01hB0c0YC6ZegELqi3wqjaiqs65JvMi21rInAg==
X-Received: by 2002:a05:600c:37c8:b0:47e:e87f:4bba with SMTP id 5b1f17b1804b1-4801eb0e1cfmr211975325e9.29.1768988358825;
        Wed, 21 Jan 2026 01:39:18 -0800 (PST)
X-Received: by 2002:a05:600c:37c8:b0:47e:e87f:4bba with SMTP id 5b1f17b1804b1-4801eb0e1cfmr211974895e9.29.1768988358401;
        Wed, 21 Jan 2026 01:39:18 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804245245esm20022655e9.0.2026.01.21.01.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 01:39:17 -0800 (PST)
Message-ID: <5fbdeab4-d8b2-487f-89e6-fb00037e5773@redhat.com>
Date: Wed, 21 Jan 2026 10:39:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251202160853.22560-1-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251202160853.22560-1-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vJROdwbYaCLqTruWI-5z5szQtbI0ktUu-XP2IyLLqbo_1768988359
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 12/2/25 5:08 PM, Sebastian Ott wrote:
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
>   with a future kernel/psci version
> * added R-B
> Changes since V1 [1]:
> * incorporated feedback from Peter and Eric
>
> [1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
> [2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/
> [3] https://lore.kernel.org/kvmarm/20251112181357.38999-1-sebott@redhat.com/
>
> Sebastian Ott (2):
>   target/arm/kvm: add constants for new PSCI versions
>   target/arm/kvm: add kvm-psci-version vcpu property
>
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 +++
>  target/arm/kvm-consts.h          |  2 +
>  target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>  4 files changed, 76 insertions(+), 1 deletion(-)
>
Feel free to add my
Tested-by: Eric Auger <eric.auger@redhat.com>

I was able to migrate from a host featuring "KVM: arm64: Add support for
PSCI v1.2 and v1.3" to an "old" one that doesn't using
,kvm-psci-version=1.1

Thanks

Eric

