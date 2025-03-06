Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7416753BE
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 10:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741258350; cv=none; b=Hx0BSOnbKYDfew3CHejTbl2Gyc2YzxZyirg21UrbmkXjoqUI5IqmMeFQjLnwXJ2rgpnUn9gNMFgE/M/cf9UXpL8rKIelcpj99QPpiXp7w+T5QdeanQRJJ3t21utgbAo5UZYSVafGjj5jsHw6vemka804JbglD1mNx7hyFMTgpfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741258350; c=relaxed/simple;
	bh=xNN68TsoHbzLWy6HVfjss4orjPSDGafBkOo4Pbm5GHQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=C3Y5YQjz9dfVK5tT5CYdSr9nq6ojTYZeoCwaANE+LQ1pTlfUPrn9J3DiUFvFszpYvuMQRA1qepC3N41Do8+1E84oMDgSAKvj3m+XpiQHJ6408jTPxyCJp2I/nSvWbUIIGBkKc04NaBfOQoALytYjoEA/Ozi7VWQGRpY+uNe1fmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eS24Wq+G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eS24Wq+G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741258347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bzHbDsjqw0csLRfE011QXaM8Dt0kPd4HEXCq5kIGsvA=;
	b=eS24Wq+GRUqNC/H163PFVa8KLsjvLKB8Q4BPkmVMVArNMSd9Pwcqyc6i3nP2J/aYPGCLpA
	A4o0N7I2HMUGqX7uHSUliq5dS5bidP3bzWE8VxMtroiu7Zp4nV0IR00R5MMMc6iybfM3on
	vWyfSdZPdsLo5AQEH3buw4ktrXrFgKw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-fGpxeoSSMnadqViD-b0__Q-1; Thu, 06 Mar 2025 05:52:24 -0500
X-MC-Unique: fGpxeoSSMnadqViD-b0__Q-1
X-Mimecast-MFC-AGG-ID: fGpxeoSSMnadqViD-b0__Q_1741258343
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-390f6aa50c5so322756f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 02:52:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741258343; x=1741863143;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzHbDsjqw0csLRfE011QXaM8Dt0kPd4HEXCq5kIGsvA=;
        b=Z9v5/Ab9W9lAnXyJvBkznd8U5aMCZY7RGTo/pWTdP6kalgPpIG5waUK464rT6jmRVn
         24y7qyJLcYlLUdQmYQuP9L/Av+MQzrkX5YH7ZwhLcjRA9r2jZqYAorNXYTPUyctpUct5
         K8txk6h3WwFXWvwTQmmAIklcONKkGUwyfBAyaDUkOM7eMY5Lhih/lYisAfnY1HlMWvR2
         IfJHlgcyrSvXtCNxrgDXGBSk9oRcg907/EIZnGAtbPBdK9Sa9OlZA6aQ5hQHaopmDiaq
         pQG+6tF1D9OEUrQ9AP6zSTaPNFP/xj4gtyfXMOfMEt+Q5QOFVZPqXUsGMCGnzofJ+Aid
         uekg==
X-Gm-Message-State: AOJu0Yw9jTaO/rJa20iXc6O4iczPE6K+jkoNDC27w8I0CIB7D7xswmNV
	lj1U8Pf/LxT2sHqM0DuARn+lBd1XGCACfkJKdb98e4uPakVrgBTfRTgIGuN7CbLsKcJY4Bce1bJ
	7AH8gVKqXawJXKGIZx7jc8v1TfJLJN+qfBaH9rCkzF1+BZnHULudw/Q==
X-Gm-Gg: ASbGncs9oxf8KD4SE+vPZrqS1izCLH+9/wbzS/GUjCSl88EiPiF5rurzqe+KNarHZdQ
	kp7eQRiyaoPGTY3rGlnYdUexstVQNJLIpvVV9RLOqr3WBRSi1Pxlg9gPs3AdYnyt+Zfv3FC9NKK
	Ul9yCsVVsY24XJEH4kDCo2Y+XN+Lk9VBiRzgnTE8423t+9FFmXfzsbeYn9WKsW4YtnBymE7tF/o
	kgeraz87q+SOd+TO1AbUd9u7P6z+T3ig5nqETO9sdMtOD3cQBf4A/RRTL7JGVDSqcjFVbeMlKSd
	WNR1djXK9dr1kpc+kJ6PabY3/uVZ3JR+paApKGVhw6fA8EzxSUB39uvO/tVrbQkS
X-Received: by 2002:a5d:5889:0:b0:390:f745:bbfb with SMTP id ffacd0b85a97d-3911f74256dmr5721166f8f.26.1741258342830;
        Thu, 06 Mar 2025 02:52:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXycTTQgETYnX1IKYBRw0+Ro2kebi3WrMMhzYsXSafw8QcrmEQAMKu5FphBCpZVnpsBBhkDg==
X-Received: by 2002:a5d:5889:0:b0:390:f745:bbfb with SMTP id ffacd0b85a97d-3911f74256dmr5721146f8f.26.1741258342463;
        Thu, 06 Mar 2025 02:52:22 -0800 (PST)
Received: from rh (p200300f6af284000f9ca1328aeaacdd4.dip0.t-ipconnect.de. [2003:f6:af28:4000:f9ca:1328:aeaa:cdd4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4292b06sm46218315e9.14.2025.03.06.02.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 02:52:22 -0800 (PST)
Date: Thu, 6 Mar 2025 11:52:21 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Copy MIDR_EL1 into hyp VM when it is
 writable
In-Reply-To: <20250305230825.484091-3-oliver.upton@linux.dev>
Message-ID: <b63660c7-53e6-f2d3-bd4d-b9ef67987397@redhat.com>
References: <20250305230825.484091-1-oliver.upton@linux.dev> <20250305230825.484091-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jZ4wVexMbKAl-o-__5Iv41QjWdzYYqOJgPDWnBZWkTk_1741258343
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 5 Mar 2025, Oliver Upton wrote:
> KVM recently added a capability that allows userspace to override the
> 'implementation ID' registers presented to the VM. MIDR_EL1 is a special
> example, where the hypervisor can directly set the value when read from
> EL1 using VPIDR_EL2.
>
> Copy the VM-wide value for MIDR_EL1 into the hyp VM for non-protected
> guests when the capability is enabled so VPIDR_EL2 gets set up
> correctly.
>
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://lore.kernel.org/kvmarm/ac594b9c-4bbb-46c8-9391-e7a68ce4de5b@sirena.org.uk/
> Fixes: 3adaee783061 ("KVM: arm64: Allow userspace to change the implementation ID registers")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
> arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 +++
> 1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 2e2975248cd3..afc1b5c403c9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -376,6 +376,9 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
> 	hyp_vm->kvm.arch.flags = 0;
> 	pkvm_init_features_from_host(hyp_vm, host_kvm);
> 	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
> +
> +	if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &hyp_vm->kvm.arch.flags))
> +		hyp_vm->kvm.arch.midr_el1 = host_kvm->arch.midr_el1;
> }

Oh, I didn't even think that all that's missing was to update the trusted
kvm instance ... I was looking on where to set VPIDR_EL2 for pkvm.

Thanks for the fix, I guess I'll have some more code reading todo...

Sebastian

