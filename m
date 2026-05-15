Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69633FF1BE
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 15:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860501; cv=none; b=hn3DsQRG8wV1BJ9VbUI8d69sg9urCZ1dfFCKdHPZNHUu4GkUyMfUGLef5ueh9nuLguGGdscx6XuzWY49A9+1rtXwfwssCRf3hi9lZi/GGhiLCKiAOLfF5jQ/CoTVZxWOZDKtbLB5qA14L0opQNRYgo97ibsrkNvj+9yRsOAB4F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860501; c=relaxed/simple;
	bh=00sEO2i94r5Y6gzqYVUF4Qa8xCq8C+CyHg+E67WOLPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VKOAo4iCMJj48sv2lbUJDk20nVbZQjBVS9NCiEXa3zkKfmu8E59rot7XLAklKondpjSNZNt9ZR2pjQHviZYL9GrV89NG/GqKfjAkogcWCiisU/NZYuEvD8Ogse29JF1BoYAQCZfL7TjsPl40dGxs9PGhQtkGWsv8AzLCqGpk2FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NS2hX1Ba; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NS2hX1Ba"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778860499;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A97hbXYKzUL1GQXcULFqEomdMtwQ7TyYIOUUyECdXM8=;
	b=NS2hX1Ba79JzrP+fffepBxNaZDSPKFj6gpilMcTZ9WLK1LwWtvcgvAwWYkkazLITKgCG84
	XL7O5/nqD2kJOcv0FZI9IDJNsPMLStchunw6c/ux8TfLxgy5WhkvLcMDmb0Nhg431ItvDw
	EZaCkEE22v0ct6n7DB/dQtNNY4oOp2s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-Av3ZViiEMjqCoOC9IgQmMg-1; Fri, 15 May 2026 11:54:57 -0400
X-MC-Unique: Av3ZViiEMjqCoOC9IgQmMg-1
X-Mimecast-MFC-AGG-ID: Av3ZViiEMjqCoOC9IgQmMg_1778860496
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48fdacff6d2so16188355e9.2
        for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 08:54:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778860496; x=1779465296;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A97hbXYKzUL1GQXcULFqEomdMtwQ7TyYIOUUyECdXM8=;
        b=ne2FNvUz4guX/cFWXm7u3jgSceq7KtndCYJfSXcHG6U3hgPldTwycA5ccB15WSBEEx
         lEq9R6acxScQiUVNE2YgbmXULl2+Q1s4Btg7JYnVmz4InTOunlowGLImILzjfgE1yBGA
         x4We3Laa4cFcW5uhcg9Bg2rNlTCx4ccoZk2hiKQD4zcbt1F+aqFw/v/Iev9Iq7qOqP1w
         8Ea0jLfhNt/B5k0vCN3/HNNEStuI2BMLi/TgfkVx/F7X2nWJGyO/xcsWDKUQ524kLfBn
         KpzcuS+RaYOySYreaAVPd0rlHU/Bln228JqAkp1GWYtK9habMYl7XDaCwskNNKuYhD05
         ia0w==
X-Forwarded-Encrypted: i=1; AFNElJ+Jd+L4Ppm2kNP1VbA7H0SSOOi1qO0h99eYP1gFVGKJEStEY65jwLqLd3rryO6ilbB4EsMNiS0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQGJF6Gp2ZniAQrpbfPdeehVdavcycbLCW9EmpZMg7rZ26hpyD
	cNBfm1YgzMazYi99p5gEeoIH9GRbfSQaLbsRyNGsi6J/PcbgKgvHLcZ/7wPx3VNBodC7OljX1zo
	tDmGmDqFvSukYIsjL3xQVgo3oGtr3hCL19vi5Jd1FFmyWfFIAJHwFYa1xow==
X-Gm-Gg: Acq92OEy5lYiALOnKyE8SrjZmwU/Tc7drlLa7NWykWUQoUTR7q6l+q2DePbcnO8jQBp
	QVIvYQDvtXdDQUlpRGGJb408LaUL4d3GObDPnbbZqu7rsdDvZbhOPfr9A3X/7aY0cXolUWKEcpb
	/TjapdeZHtUIf0JzbEGRquQlh81cQRQmW4dKzJThq1LIHBJLp8lNZZGSjgztyAU4/qf3aL4zI1J
	UhWv3305UeAi7zIY0cegT/42/AYmPFevQ+GRahc5s0zO/b1BaR+XQ7wSRVRTs1ifa6m3ilDsQd2
	g9X34iiskWFKAM+OrdhWLCh4gjBRFWywrzv5MYf+yL1Atwy4ZEZiJpWW5W8O36aJIRYUoOP4ics
	MquTwt/tn3+omSkD5kKrGiyergbBPACIXUHJMOfDBAe50gk3FXPK/sbAoT9y6xPLKjnhURA==
X-Received: by 2002:a05:600c:4692:b0:48a:592c:e632 with SMTP id 5b1f17b1804b1-48fe6325f18mr69509115e9.16.1778860496312;
        Fri, 15 May 2026 08:54:56 -0700 (PDT)
X-Received: by 2002:a05:600c:4692:b0:48a:592c:e632 with SMTP id 5b1f17b1804b1-48fe6325f18mr69508315e9.16.1778860495789;
        Fri, 15 May 2026 08:54:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a1a22csm14852814f8f.19.2026.05.15.08.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 08:54:55 -0700 (PDT)
Message-ID: <1d4360a0-0611-4b3d-a7a6-3815d57a1d6d@redhat.com>
Date: Fri, 15 May 2026 17:54:53 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v1 02/13] target/arm: named_cpu_model: Add ID Register
 Fields
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: Shaju Abraham <shaju.abraham@nutanix.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Prerna Saxena <prerna.saxena@nutanix.com>, Jon Kohler <jon@nutanix.com>,
 Jonathan Davies <jond@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-3-shaju.abraham@nutanix.com>
 <0b9d0320-96ab-4ccd-9440-0c0494af5aaa@redhat.com>
 <189B12F2-68DF-4442-8657-D5F295F710DC@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <189B12F2-68DF-4442-8657-D5F295F710DC@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g5e-3k9H3zNgLnw0sWczZzKSJepvrjmT0oEytszdQa0_1778860496
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/15/26 5:27 PM, Khushit Shah wrote:
>> On 5/13/26 6:33 PM, Shaju Abraham wrote:
>>> Add a declarative description of every architecturally defined field in the
>>> Arm64 ID registers in cpu-idregs.h.inc file. This file will be included
>>> multiple times with different definitions to build the per-field arch values,
>>> per-register field descriptor arrays, arm-idregs table etc. The architecturely
>>> defined values for each ID register field is extracted from kernel's
>>> arch/arm64/tools/sysreg file. The safe-value tags and default values are
>> In the past we were rather advised to use AARCHMRS instead of sysreg.
>> This is what is currently done in [PATCH v4 00/17] kvm/arm: Introduce a
>> customizable aarch64 KVM host model.
> I am not sure if we can get safe rules from AARCHMRS. Otherwise it’s fine.
I don't think it is there.
>
>>> derived from the kernel's ftr_bits array. Aarch32 ID registers are added
>>> with dummy field so they can be defaulted to 0 by later commits.
>>>
>>> X-macro structure:
>>> IDREG_START(REG)
>>> IDREG_FIELD_START(REG, FIELD, SHIFT, LENGTH, SAFE_RULE, DEFAULT_VAL)
>> Why do you need SAFE_RULE/DEFAULT_VAL? As far as I understand this is
>> used when we have different flavours of CPUS in SMP and we face
>> mismatches between CPU features. Why do we care here?
>>
>> I don't see safe_rule used anywhere.
>> I see arm_idregs_reset_to_defaults() uses the default value though.
>> Should we use the Registers.json reset value instead?
> Kernel uses safe_rules to show a common denominator of cpu features in SMP and same rules are
> used by KVM to verify if certain field value is valid to show to guest on the given host.
> KVM_SET_ONE_REG validates the writable fields with the SAFE_RULE defined in ftr_bits table.
OK so you plan to duplicate the logic at both qemu and KVM level. Can't
we simply rely on KVM which already implements that logic. Also if the
check is against a given host, is it relevant here? I need to look again
at the kernel logic though.
>
> So, SAFE_RULE will be used in v2 to validate idregs even before we writeback to the KVM, and to
> pass supported field values for a property on a given host to management stack (libvirt). Something like
> feat_AES supports (off, aes, pmull) on this host.
>
> Registers.json can probably be used for default_vals, but I will need to check further on this.
Registers.json gives the reset value and not the safe value, as far as I
know.

Manual import of those values from the kernel looks tedious and error
prone to me.

Eric


>
> In short: default_vals -> show no feature.
>                safe_rule -> valid values for guest given host values.
>
>> taking FHM field if I compare with sysreg I have:
>> UnsignedEnum    51:48   FHM
>>         0b0000  NI
>>         0b0001  IMP
>>         0b0010  F16F32DOT
>>         0b0011  F16F32MM
>> So why do we miss some values?
> The table was created based on sysreg file in 6.18.
> A script added the arch values. Register, Fields, safe values and default values are
> maintained manually.
>
> Warm Regards,
> Khushit
>
>

