Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795463855;
	b=yGLiwfG4pTUHzx76GT9B7f0etr6cDtYCWXsGmg6E8l1YRtstBSJFaX0dZH8Boc3miBbx
	 ZyhtID6B+7rU38RawXk1I78/E86fYmh9jaN7YMuztOsE5qIzdgNSUkw07Gz2dsYh8gNR9
	 iWc/MioYMdwmwO78yz77wtcfL4/TYI2rvgtfucDpGSPYPHwUnljti2HHVBaL+Lfo5XvZ0
	 Zl/HTDbtEPNj+xTQFQR4H3ZUpTATvZuJqkZsB5STShAVT6VimWZv6FRPQBVQGJ/8D7gf2
	 g5i5DJpGj5p24j2tSbv6m5tTaEEKEFYeMgFi09xalpHhA4y8dEMPCWkuMzrMIuRWWpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795463855;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=wWziWSTeBoEeo7z7AajzcN/FvNVLiiTCaXNIHvNDjy8=;
	b=tolxg2DmJKEbP5iusOg1iPqYcxHYYzTofvyf8dU1jhKk7g3Jyl6q9DeJMN6H+mJ3PHxe
	 74vuX2UWjL0KfRZkaQ34t0o1NFUNFZ4m+/st9i3JuzUUThjj9nIJknQS0VqV4xSrXdk7i
	 qqkhiRBapsdGbFxT/4XIPSzUFlouDL+RqQoP1YeXAdo+jTq+yad7OcQv1G+fM4b1VzKwu
	 2KQkpeM4dBxxbwgTpMyhzteLaVLEujs6AqJbk8vWswufp9/CW78MntKvXbuHyvtSHgMkv
	 hvQjOqNxd1VyP/xBQwmgLzf0PgKIyCr574SwMITAlzgQi0hoOgaoT9wH0fNVlbc7ELA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lPuTevJ5;
	arc=none smtp.remote-ip=91.218.175.23
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2D5606A31E
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 19:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E2D5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lPuTevJ5
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=TlIRJjfDNJE45hvMPBudJSR47q++R49DsKUCdwnCWQ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795463852; v=1; x=1796068652;
 b=lPuTevJ5UAQyOYblWJoOXE0GgRJZWSDLFBQSk2g55loqNDT/y3upy9YXZX4WUN9Wt3RpgLm5
 mxqbQlHTpkikV2B/2kOhb+gUg8dwRZpUH9+MxbUmEEOXy8xhFcHqK68HalI7Lgpejrhiwt9thqq
 KmnU1OYIKEqcOidq3sHzG8EU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9e47379abad77115;
	Mon, 23 Nov 2026 19:57:32 +0000
X-Mizu-Trace-ID: 9e47379abad77115
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so12576e87.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:57:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFNwYEP3z/K8GsZ00ukCTBGTq8SNCZP6KyenaJMnyR2jOtKjSAfrV59qAS+nZ/MP/VmiHKYJGI=@lists.linux.dev
X-Gm-Message-State: APuU4Z/5ReVn9AtY5RcODTelWiO3XgVNGhNlIDXV9gPiK1yaWID0nfbS
	ACdvk4fHyJSj3AjIXtdhbPqXJqdZaw0acva8mV9SKgAhkT583HmwhT6OIJf36aQ8kLRre9gs7iy
	faphnjZDL9SFzgaJQEs3DtMJsUCqjCtvK59CB4Twp
X-Received: by 2002:a05:6512:32c8:b0:5bf:b994:6598 with SMTP id
 2adb3069b0e04-5c21a1ebb99mr278454e87.6.1795463845647; Mon, 23 Nov 2026
 11:57:25 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com> <20261117174403.58762-16-vdonnefort@google.com>
In-Reply-To: <20261117174403.58762-16-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 23 Nov 2026 19:56:49 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyzbeZ34bp-TnvVibHubgwZFuFbLZCRRSF-kbM1wXb=Wg@mail.gmail.com>
X-Gm-Features: Aa3M54r9LDW6mKOgcZNbLjoMHsuPqbG8zuF6ezqiECWli5T2bHoqhg9wWtfugXM
Message-ID: <CA+EHjTyzbeZ34bp-TnvVibHubgwZFuFbLZCRRSF-kbM1wXb=Wg@mail.gmail.com>
Subject: Re: [PATCH v4 15/23] KVM: arm64: Add a range to pKVM ownership selftest
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com, weilin.chang@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, 17 Nov 2026 17:43:54 +0000, Vincent Donnefort
<vdonnefort@google.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 4c80e0960154..ae53c701206a 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[...]
>  static void __init pkvm_ownership_selftest(void)
>  {
>          unsigned long pgtable_order = 5;
>          unsigned long pgtable = 0;
> -        unsigned long page = 0;
> -        long ret = -ENOMEM;
>
>          /* Memory for the VM page-table */
>          pgtable = __get_free_pages(GFP_KERNEL, pgtable_order);
>          if (!pgtable)
> -                goto out;
> +                return;
[...]
> +        __pkvm_ownership_selftest(0, pgtable, pgtable_order);
> +        __pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);

Could you skip the block case with a message when its allocation
fails? With 64K pages it's a 512MB contiguous allocation, and the
selftest prints a failure when it can't get one.

Cheers,
/fuad
