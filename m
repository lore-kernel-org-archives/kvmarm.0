Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C705594807
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 18:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789066398; cv=pass; b=cgSNi1TUAJgBW5ti8UGJL97/tmKO2N0FPYbB9PGgMOqztcVZxvct7pAOwCDHpFNdoXbnC+l69z9gHUIhzO1q3AbeROHoKpAsMSYisEsnvF9vWzCzt2jUHSnd8CTaZxdWUWWOUSQ4pM5OaXbf36P9kMgMykK9akYMdr6DR+kHUVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789066398; c=relaxed/simple;
	bh=dT4FNCiiMtIXPLJOvuFJF0jefoKwdOcRJ3SvzlEgqv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Db02nnvRCzTuN6Lii/UgWrje7irnGeqT2qTNnRso2NvWU48oeYNhZNih3dXrewvuht9IEWFK6dGK3mvcwYA9QIReWgvmiH94vDldGzOVGE38jje2QnCNVnr2jYVWZE6IISdISdVjlajJwUZxHEGdP4JQ9INs3dCDpFOEU7/ki9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tBz/siXe; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tBz/siXe"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so9583e87.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789066392; cv=none;
        d=google.com; s=arc-20260327;
        b=AANPQVHjRzyLvFvuyTOWQTsoNjJkS+pr8CFS58XLlSb2IZ6g6bKmd0WN14U+BE9rhD
         ozIvPP2akBWgckMq0uYpBn8wcdhOrWiDLhMqjlCJVUIx4zXNOTgbE9ha46D7uZndY6JF
         rQyr5m3a9nzG79cIyxMJGxY9Qr/vwqbj8vqTaW9UPJElCt3D5Hbhwo1SxRHCAuay9Ler
         ZWb4wAyYRoMLfU+GY4QlYf/LvKxVSmcWP5rL36bMCXJ5uylwkQ0JIg5HNTcgp/FtLZsh
         rMiz59xQcvUnSCaH8uoQs/nO6Z6ZzXt26lAXoRC2FG1WYHVnkXxY5/RAfl/n3CUnUfUB
         E8Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uPA7h1yzQiskXY53xtPOVbRZgGvwK1v/3hUYMrYw/Xg=;
        fh=Z9nwqirYco4J93vgxwDcCDCQB5Vgh5LtwdGXIbVlw+4=;
        b=a77aNCAUQ3h/vF8UP572vhQ12EpvoaBgOhWALwi/SkG1TcWLOU/YIJx4jhf8233ZIS
         l7yWaXR3fSsTNCbGj2Uxrv+DabQ0lVn6olXjhdiS0dFfVSlUK7WWoWqmNYOMmjxDCnRY
         i1Mc/Rhw8Vplsfc67iSiWCbdSjsZ2ChTXjDM7ne4ht0jwkCCwcyILeGyFyDexf6cWg6w
         KlNV+zkSdCAl/jLhsTlUqe5B33jBfMVLDWgLN9MR9oIhRwUmXpirioYdyUJFpPwY5rKW
         iXadCa5iWgUkjnaOqLIJG4+P/Z1GyuVv471OtoYO9Z9GADKAevu+3LjlOR3BM0FrKksg
         xR0A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789066392; x=1789671192; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uPA7h1yzQiskXY53xtPOVbRZgGvwK1v/3hUYMrYw/Xg=;
        b=tBz/siXe7xStSRUZwd6eSAQKJ1gUz3GKEi1ii3BzGQ2Tmz/wD5QHAC7tMmhC+Wgkrw
         T+HCliEn7ePYD9fYVwseO1Yoks1+fZwpL87Anif/OhxwbM5GYhx6xfojjIfJaO0kW1no
         bKgfvmcKBNq5r05J80JrdxBOVjLHun03bv/KxbDjVeH6VQRfSGp7ln0hrvnfifJlEtlg
         vN/m9YaUWxIc8vfnKVkTJ8eS8pipmPwRvdAUPniFw0v4UvVSWvMy0fM6DPSRHXimh0I4
         g/Fq807ihMp0+9RQh96LZ1QIjOzpwOgelSM/U7Dn4MYBvachoChCLAFL/snVzCUKaGle
         jr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789066392; x=1789671192;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uPA7h1yzQiskXY53xtPOVbRZgGvwK1v/3hUYMrYw/Xg=;
        b=jFTowGVZ3CujtXIUk8w5kj7coYE/WwblrvhxdBHBRbtyX8jpgKifw/JhfoQ6kANWiA
         DuB9ghrtNmC2qni9ooG22yHKGkCBpWtdB9aFTAT5GwLs2BNYTxnAJaRSSKqLQ1X4bps+
         srBNs+T2A0SN4ZhngGT4O5J7Hg/nyofUpkqx5cXYnFOJGbQxoQkhXLZs8DYt3JI0tdaM
         rii8uZ3WVujNgu9bLjG+nbYmBjC/h8FJpG2jhriOEwxzWx8sXFUZWjsG+oqiS3oEOjO7
         SNqbgweH+MMMxxNldlMzG39KkbbK71nXJFSbCRye5gYYhtGY5CtG45ZkDgLglNUEly2L
         LV0A==
X-Forwarded-Encrypted: i=1; AKwUvBxtdC6mka4kEObgk8YWI+xGfFgznYBXyy1CX9j8s53dUppVhpIqoA/ueVVxSwb3XEVcEO4GJhk=@lists.linux.dev
X-Gm-Message-State: AFuF++l+1jX2FBEEIQMEE8x6ATpGXC9aNCsnqcmoe2bh6vr3nfRThybf
	zFJs44y2yrlQ01qAEWvpGSqnCANJv+y9xAgjLnJSuse0moKblJv/5Bb1hU8pJgK+kvZxxB0DHTA
	Nizy2Wybq69KlRe3zfNx64YiZUUFi2rSqMNtF3WXS
X-Gm-Gg: AYBFou1JDFoniy2CJECvw7mKkm8SjPBjTVV/cUKHx7o3pxQLeToYKL01JSx4JNETBIm
	aQYnmfjIFU/weAZniwHuDsjrHtRbcUaFhG5Se4LS4fjvO8k81oRgmlfJheRnQ8eWgqyUJUK4Hc3
	zENkuHIPg44Jci/3J8Hjp5zgBD9kodgiiAluhDoa6eXURpGkfT3Y6AFh53iACOatYC+FXgWcgyM
	HkNLRdjyIEHy1ub7A6Y6NxpqhQSJ7IF2ydlUVZvKsN389+Xg0Ni8ncaqs8dr4na4YQ4U9t1ntcU
	9t1HWv/O0UH0K5q6Z05qYWFpaeRNE1lu/sllzeYLcdJvRJUzPnBkgTz5kENezQSMjDnbkWx8Xto
	09ZX7UM6q31puPw==
X-Received: by 2002:a05:6512:4009:b0:5b1:4fd9:ac with SMTP id
 2adb3069b0e04-5b8a07a0e5fmr23463e87.3.1789066391400; Thu, 10 Sep 2026
 11:53:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org> <20260825-kvm-arm-prefault-v1-6-befe8947702e@kernel.org>
In-Reply-To: <20260825-kvm-arm-prefault-v1-6-befe8947702e@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 10 Sep 2026 19:52:35 +0100
X-Gm-Features: AcwNN1XPPeWtd-a0jzst6s0fMnTr0aHfMbhg6rA4kjyMckfbadgDOVe553duj-k
Message-ID: <CA+EHjTzOKHNrf=0n2c_E+vbt=pGquz6qzBpJ+eLJ5hjK_nyJMA@mail.gmail.com>
Subject: Re: [PATCH 6/8] KVM: selftests: Enable pre_fault_memory_test for arm64
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Aug 2026 at 17:01, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> From: Jack Thomson <jackabt@amazon.com>
>
> Enable the pre_fault_memory_test to run on arm64 by making it work with
> different guest page sizes and testing multiple guest configurations.
>
> Update the test_assert to compare against the UCALL_EXIT_REASON, for
> portability, as arm64 exits with KVM_EXIT_MMIO while x86 uses
> KVM_EXIT_IO.

The message says this updates the test_assert for portability, but the
parent has no exit-reason assert and no struct kvm_run; this patch
adds both, so there was no hardcoded KVM_EXIT_IO to make portable.

...

>  int main(int argc, char *argv[])
>  {
...
> +
>         TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
>
>         test_pre_fault_memory(0, false);

Would it be worth adding an arm64 case for gmem_abort()'s pre-fault path?

Cheers,
/fuad

>
> --
> 2.55.0
>
