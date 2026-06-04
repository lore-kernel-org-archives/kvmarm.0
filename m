Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32FB305663
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 15:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780587036; cv=pass; b=dGFq9ifZxh73+LEipvimtpURIyPJoArm4gwDUhmvW+CUv64sjzv7YqdvCSecmh0S8EWDlv7rWR8pIGOeRPWeMC47MbeKww+D1qgiGjFzzuL+Fn7Qx/dppMbi3Qsg80agME7+3820AbYlQnvtuWu1Lq6CzUkifM4CSvcWvkabaVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780587036; c=relaxed/simple;
	bh=KqnYPj6rX5ufYoeTO/FnYYGGSEKEYSIS6stxD8Sn63g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GWAE+09VATeuHnu2CaVQ+Qy24TKVRKMPf65XBDcUwI3nPWgE+7pCa5jzZiDNkSi6OvwDv16FtP8wf/W9ixN5ufbrkFPKbBzZAuoI7lQ31HCX/roayTFALxcl0RAAzTJ9V0IdBiQ9Z79uxjgJUzfqhEKdmz6OdnITFwZiVGN36VY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dp9lQhSA; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dp9lQhSA"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51765331535so565771cf.1
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 08:30:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780587034; cv=none;
        d=google.com; s=arc-20240605;
        b=Jwlo4i4QXpWVWy3kkLHY2fzCm2Gy+7V/Q88eSyYhsNpzX72/LDmww6wKQrfsgjWOTo
         CrwarJTqMCWjSErv0QWVyoiJiIhumJWOalLZ4Xnz1q6DfSmMYm8UIS5g7reVbUI6Y5X6
         DdbctyyRxchLrdODPZSbh9asFPNMmkNtHkYWiMKIGabAONF+nOTqlH9S2l2WcgCcEHNh
         EkhZq0hNFUnELi373yiK7wo9AJNaFqX1nR4nnrXIySTnME2sQwO6iGDPx36an0y6EMM5
         btfmJVDPpnjhPw9HfoxWhbW9yJA2x16kDT0Ghdx5dJNTn/cXh37rc9jE1ZlyuB3Pntk9
         nWrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QzQ2Q92BkyZrcIbCUmXt/htpBaJmJbUACSBmA0TFGo0=;
        fh=VcRGLffnjslt3b0B1tjhzCfz/Cv43jcuBFly8/QIDWk=;
        b=BrqskYJIX95JIukfkuMHesKlqKb7PEzbOQkjwODMDkuOjh1l1GuETTkyM2aA45U/22
         mYzvcpweRukPSBKdGpZ5pXOMBnKR404sHVNNSPBQUQDX1WO4DhyaECBNXu5g1s/4cdtq
         XoZvjrQEkEksjPT7MnxGjcgLNF/kkFcNMqkBUim4o3w8iayLBgWmkypn8wRZmFrtM9ej
         pcTfn/lvCGlHLBo5VzLmnpu23YKyZvZbfnxxY1OU6H3wVHHoN81FIpaGRtqIwysM3cFg
         geDYZW2f78V13atoSykqajPDfZRbJLG2Cu10OwcS8OrDF+kPUXNSae2uSZYlfB7eVofK
         ySBg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780587034; x=1781191834; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QzQ2Q92BkyZrcIbCUmXt/htpBaJmJbUACSBmA0TFGo0=;
        b=Dp9lQhSAqM+dswAUWaxK2ik/KOMWaCP/gVitYPeS+7pjhpFx0i4zZJ/rdy4dFIhqlU
         l1ylVeUsbXdQK0mzon9QnKq87+elb7bFtds6CP6sVKGKNZKIiTjPPYCuqnE6RG+BOFmy
         YutIfqjq75vXEc1mQ8ugLTAbGWeMEPY4ZZctU0TIam4CG1wPUBV4bRpSwQUNPbpffamH
         4Pp81z5h1WXO/Lo52NthJVVCC+fmNXFEcCIx3K8t7u1kKMEztrMpKRYZSEopaXseG9ot
         S5XPUz7Jk5p+Pn3zZeOfwjKjUK1YUeLyMJD+eCvoUrp7t8rOQa5mqheJiMsa35zJ1c0O
         ND4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780587034; x=1781191834;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QzQ2Q92BkyZrcIbCUmXt/htpBaJmJbUACSBmA0TFGo0=;
        b=spen+ujJrt1yZ9YK2L4BhN5xCO23vU9i9vGQW8W4I7pjaAEs4KxXNlxf8P2Gj4iwpZ
         +sOHmzx2lifLEf8BcfsT+Rzpq3jQlaK0U4b69V3WJCtPULPshWdVK7190o0jm0e5tKxX
         ofODZgXBroOE5mbhuy7NaZfyQKZGe7pBkY3Jg57baX5pNx0VrH0tYRLfcQKMTDG8pI2L
         1OD6mmtlHf90Buz6X8GmB5qopr2We7QIbUdHm0m++H5bR8HzDqWcydPHYTA32J/mrkTP
         2PiWcheWS1GD0TYOokDYuTDqGW21n4CdSaBq/TfiFYyyNVkBiFx6mSy55tE2mnDTvA6n
         Y0Zw==
X-Forwarded-Encrypted: i=1; AFNElJ9v8DfTuSCR6p4sz1h+7jrToSG42eYCzbMSMSnzoI/n9Sxt3M6NHTO+D98FzYvTeYD8FwyNqLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqOc0MDovP8MabIbU18s7wvges7Fr61bfaoYP4gn30kxxMK8lL
	8KIJWxjQPc7rkViUKOOJeg8xRiZYpLp9wl0SgOn78DIwKx35BeAV13PoHQNrxfv4B1wuIaJQU2a
	3Eox2LlTVVDDBKygcH3pdXkDDgGrfr6qoYsTUYU06
X-Gm-Gg: Acq92OHOAFWrNscEFpGMOQyCBbxtlzV5Cpit4P2Rmh4tO5BctN1VOT3eWjIauChVlqe
	ApkJirLnPPAxR0ORB4bfZB6sYLdtar0wxWdrI69j66H9UosGSY1APN9n63yTDYoc2KbwGMV7Eh/
	US0fib22ZH6iMn0wOjejGgibOz/Y+8D3CPMqkajxvNDY7kNfCto8skEOCDbLODwyZIXtdSJRkQU
	UVBJkFLa3T9Rw6yfVKf/2/EyD1Ur7jIt4P0AcDmEGWBVXL4sryezRZpP4CkzQ3yrKwWhGNEK48U
	X7Ea70n9yLvs5xAKfF73SPJcZAEn8g==
X-Received: by 2002:a05:622a:1801:b0:516:4f62:85f1 with SMTP id
 d75a77b69052e-51787ab8be5mr8370021cf.22.1780587033025; Thu, 04 Jun 2026
 08:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260604151210.1304051-1-imv4bel@gmail.com>
In-Reply-To: <20260604151210.1304051-1-imv4bel@gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 4 Jun 2026 16:29:56 +0100
X-Gm-Features: AVVi8Cc2MXFGX13UgQv8KxsaFbLAfi1SrGkBO6c_9HOxSmMh56zuIxa4lndJTVw
Message-ID: <CA+EHjTwaz1fvnOKOPc94S-vdvMa8JMLafd=ZNJcbdN4AB+6M0Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Sanitise host vCPU fields copied in flush_hyp_vcpu()
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jun 2026 at 16:12, Hyunwoo Kim <imv4bel@gmail.com> wrote:
>
> flush_hyp_vcpu() copies the host vCPU context and vGIC state into the
> hyp's private vCPU on every run. This series sanitises two fields that
> it currently copies verbatim (host -> EL2): __hyp_running_vcpu is
> cleared in the guest context, and used_lrs is bounded by the number of
> implemented list registers.
>
> v1 -> v2: split into two patches, one per field, per review.

For the series:

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> Hyunwoo Kim (2):
>   KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
>   KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU
>
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> --
> 2.43.0
>
