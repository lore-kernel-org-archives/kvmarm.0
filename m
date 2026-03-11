Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D4F1A0BE0
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 12:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773233367; cv=pass; b=nrEmg+nf+eNY009nxYkHtldzug3IK0pY/MreiOSv7oVkzZJwsqbhs3XWRQNFN9DF+i1lm9ifutxsTcmrBn4yMwd/+BNXPEuqUgnwgm0/xat85f6oKUq9BQl7wYwuyG6/qy83FigYcdqMndKiIS+2Kpv7ns4sVDReW8+shmTbELk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773233367; c=relaxed/simple;
	bh=rNpoudwbQhqfjzgLjrJvrXAL9G+5D/A/mpRyfu8z//Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AzSP4mbResDvA1FKTPdMfY0dou3ZQvD8g+fhYqOitq0w7mHUIBN4Foz1KmCmXsLb6o7ZLNoL1PY+6cuU5t8eG5zoBcWpljrg2LZoXji066Z1LByXvedQyUWWuQib5D0Fl0XHZioHy61C9YgLoOx6yILQgtSCdVlTov33Pjl6Xj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kajZrLP7; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kajZrLP7"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509069a7a7fso571011cf.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 05:49:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773233365; cv=none;
        d=google.com; s=arc-20240605;
        b=b9wmRj0ap1xMH+otAJShc3LoaloziDPR/JKQUogUp7WYYTz/f1mOg874qcasNFRyHg
         pdAkYBI3oaKTLd4M9rgzh6CM5gTyMcCgDurfm+n07kqzBjI20zCc/ibEiNy+Ybbze/gq
         Yibv5kn6foF2aWj19Sza46LYKDuCEm0Tm4O90MkRQ0smL4cNWCTkmOM93kbStT+oazKH
         RUhI+XcRzUJboZKlv6nBNqG4xl4NF4ZIa1gUK3miA1iLtCbQIegjVeFPNajzl0yq7kYZ
         2LKsGtyqUsSt6X1nClr7AEQreyTYjtPDbL4lJNxasJNwwFdK1+jL06Z4oH63nB966xD0
         xexQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GSaBdCQfIX4ykm/kooU6o0hfTQH51S+BH/0JwAXTVxA=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=Rpnyo7XyRWfY4CbiQgPhOt2TIe7kg+7ykBxSf7QHeP14d04FrCTqPk7j3KegSDlhMp
         6/hKA/dB7ocnmuvRA09fE4GJKnhnHOOZou/en7CJwmL1JgrTQK/uVSK2PH/RnfNHzUjl
         ABdasac+twGcHOceRxH8HzrozOMM9hUgzsEJavv9xDb+KiktH5IkdZBAMLWqH+ur4oYD
         zRUvP+MSkqSUUDlgXu+EOi4Xwx+dhm/92htlqnQjaqYWXxcQZ3Eo3AvLRL6sw6K8Pib6
         NysEOBrwPl9Ino7M3TDqD5cQXaEPzkPBec3tG34Wrd0+fEi/rXDHLFhCtvXz5L1NfRKy
         nfDg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773233365; x=1773838165; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GSaBdCQfIX4ykm/kooU6o0hfTQH51S+BH/0JwAXTVxA=;
        b=kajZrLP7827+RMPjUK8wdVOoHw4Jfr1JxEXgNpdoV8CuKyGD1cxI1ixKqP7Z52fRAe
         Vmk/DAO6Ur7m/L8lVeem4S/iHrMhsJhzYH3x+V0JSRddhG0tg8CX9OU5C+45i2uBXOEc
         PDcB+3laWd52lFir+BliE6LQ/bI4ZO2k8oiCIjYPYIfsThNFE+Xr+h/D0vfTV/xWrhg0
         zTHs123T13v4OC8y+SRyQo3zgbdvwEoVdMPv/YD8d9qST0KrvsIrl65UsgTJuXNta7E6
         pYbXgbbVM0WgsFNt1mPZt3kfh6UsZO/bjcqM010DpprLdLPfisl2RuIF2M5L1VgohMMM
         3agA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773233365; x=1773838165;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSaBdCQfIX4ykm/kooU6o0hfTQH51S+BH/0JwAXTVxA=;
        b=uypu3IrX/K1n5ytPDADMQqAnhX2N/wCkebOn32Z4xE++3XR9mxDt34bDd+HBO/eT+H
         gF4vkGpxybjPM9+L9OZvK2dJL3Lkjogu6V2MvF9ObwWRmGlynb29A7fJOdA8j5qgyFD2
         y1XRt31Po4huBsfzt/qHMqZh812axI/lCer7WizeSGSjEfC/ryDyp9xk4A0rj37Tr5lw
         mRLdEHmab5+r5YuiPhS/XTIDNEhYVIFbJh72n2ac3s8v3+wjyo8/nd/EPw2SIA1I+2vx
         S01ThPFn5Z05gzdgHViii/pnJxlgcPvm5BOzjUlgO77raiPkd96rQxqsHBzNy1kdeb3W
         bG3g==
X-Gm-Message-State: AOJu0Yy4joyzGD65xIeR/lp6eW/R8vieYE3+35lUu8BWqN+UAKSruvgk
	kAAY+XkBDU9P1MAicfZAsR3B/+I7xSbGmb3AVmUwbmbSq0rLEKd5NnEnHivTF+yz9nRDYZahrKB
	CeYxUMG0I0c1v5aqKrGbCAA/L0v2nXYt0oQVEpaCN
X-Gm-Gg: ATEYQzy02lwosqvktyb9auWQRESwptdr/Evd4Tk8LrDNvlJqYUSGIFvU9DJxmE07BTi
	Hnq1/+nF+JI5Uhuf+hjdDJpYxABYNBg2lT81837B6BkceweXH33H/lksQ+lUCXPwhxMSLbRfEuH
	iLMxTFtOqpFr2p1ROgm3TU0Lx5wgRKEpGpPWMhChBIZ5W+p0q0nuVuH9xXLTkUe6dA8XKbkjpo1
	JO38hCm1ZOKqtW2g2tqwEPJ3V2wDoUwA300fldrvjUJ6aVYa3YShgJJfH8lS4iroJ6WW2yHiY88
	nx7/MBzkRZcSTH2qt5xWKHxj/m9UzrrzFjSnUQ==
X-Received: by 2002:a05:622a:188f:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-5093827a1ffmr13477151cf.14.1773233364451; Wed, 11 Mar 2026
 05:49:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-2-will@kernel.org>
In-Reply-To: <20260305144351.17071-2-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 12:48:47 +0000
X-Gm-Features: AaiRm507dMxugKBWMEcPWC5syr4fU1IS8EgUvWNIOKeQMcukExaumFF3n86UIpM
Message-ID: <CA+EHjTw2W3d472j0ywobH=4Fn6jXZBZAKWkBh1dJPA=Q+tTCLw@mail.gmail.com>
Subject: Re: [PATCH v3 01/36] KVM: arm64: Don't leak stage-2 page-table if VM
 fails to init under pKVM
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> If pkvm_init_host_vm() fails, we should free the stage-2 page-table
> previously allocated by kvm_init_stage2_mmu().
>
> Cc: Fuad Tabba <tabba@google.com>
> Fixes: 07aeb70707b1 ("KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()")
> Signed-off-by: Will Deacon <will@kernel.org>

Thanks for catching this!

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/arm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 410ffd41fd73..3589fc08266c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -236,7 +236,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>                  */
>                 ret = pkvm_init_host_vm(kvm);
>                 if (ret)
> -                       goto err_free_cpumask;
> +                       goto err_uninit_mmu;
>         }
>
>         kvm_vgic_early_init(kvm);
> @@ -252,6 +252,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>
>         return 0;
>
> +err_uninit_mmu:
> +       kvm_uninit_stage2_mmu(kvm);
>  err_free_cpumask:
>         free_cpumask_var(kvm->arch.supported_cpus);
>  err_unshare_kvm:
> --
> 2.53.0.473.g4a7958ca14-goog
>
