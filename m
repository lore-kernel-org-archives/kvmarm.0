Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93997389472
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781444416; cv=pass; b=n4FULRldQw96XOpX3ehq9qfEmC8krBG/gUXepIlvAl8hklVLdTM+KsS/EsOGSyx9TSnn+glfoYD4iTN7XEEl4Wzmd/nz9X/zE4cKxxpu8M2Ub27Qced7UG/IXb0wEqulNsTMc2UEf2uNWnFvaKW+98IimNNn9meGaoKsdDoBrgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781444416; c=relaxed/simple;
	bh=zk83F/8vHYIQNlZxwg3mKpF+VwrS8oLYNcfg2wPjtrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hCcSHXflrgc9ABZ8jZcIA3Qb+vIh2S5X4VYjJreNgIK5Te93rL7O/DS248zewf/JYlolXkvp8uFz0k4W4LYamPH42Q02nN9iikh64UhHPcuipPQZsWt4Rl5Yj80MGXk0zbHToSf7uw8rwbrzXnEnKjn/gAaFqwTW+hGKhzwZdjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BZy4qRzD; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BZy4qRzD"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51765531803so661101cf.0
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 06:40:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781444413; cv=none;
        d=google.com; s=arc-20240605;
        b=Y+KD+RgNQJIYXY1aUXvqGIBEjjOkqTReOd055vixPHHTDbPKwsV+5GhbI22amXKFov
         pi4tfpmn0/lRdJnBMCMxGoCp+mHYCT09iUS4qwwuatTBpQf1RbQEUCY+oU1W5+7xpXoY
         wdPC+t1/mMaiujpFLkHaXtg2tirc58dQHDQX7+n5+jIHYLocUEKz/sQf0qp4qZ447g1f
         esIUZ/OJooAFPCT4d+Nnw0LSfoWibDlCf1qFNUqrG2E3+MaboYb+cBpHPD9MFAZFQLk4
         uGQ42RUWO1BBQHeAqZd9sW+oDrQFfJypp2TvP4kC7Ssfp+En1GiZeZUt5q7EZEvMmsMc
         jsvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5Ofr44S+ZyNvvuzy/mGDum3FtpyF4ahy6qr2J/oI/HI=;
        fh=oPv5E1z7Nn/v2wky3KQB6GZcJo2YPRp+ys6OLEpO5U8=;
        b=ERwM0qGcdfBmKCRktLY6n+ZW3SfFFQnWXdY4CHlotXEXXCy3BO+CZQBjGoj3AvQPAR
         0WOzIWWDzx3O+E9nkLNR9vOdm36dD+i5bV9hEcumfuWrn6qUpQyIzWXGuMekno2KE8qb
         wpkwvHQbLu/cHBp6VFrq9fkBBg+c5SFDxBCGXNMxKcnUrhZUosbPj7XedJtPyic8JDXE
         ZhmVAzjqLDOLmP+Dx+mxYOMQRRbJdfd5D02STFAD1mo+jljva0HNI1Ia+RFuhUS7nx4m
         taRM6SxqWwKbA2oOAwjofe/aYdgqhvrbzPNFrAcgXcjpz1IP+bTtNYC3kwtvgr/1pshz
         M6aA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781444413; x=1782049213; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5Ofr44S+ZyNvvuzy/mGDum3FtpyF4ahy6qr2J/oI/HI=;
        b=BZy4qRzD9JhVSXpH8wFm19OgXFTcRQB6er1wvlTwL3joFWvM/QMp9Ch5+HT8PoFBfq
         sIhj3NjZI1F4ITUsPwZxA8pHMD7ifAvak40JhdD2S0tCsUREaNLWYuw68SpLBNzsydo1
         kcHJXLgLGC/wGGGwrGic+bK2WQ3eP0qPZA9HHcIbJ7n2xpcUXcMkfMz1kCNcyOHXJow6
         2x8Qe2iZQKXexHdHorD/kHZgIr7Y+4yoX+ugu0nsEKjcd6QgyrWPn1R1/OWya5P8r2XR
         AsrA8bboN/xtCC48vZm4yvFnM1UHUxROS7Vlo+mF/zofiFmrKzcvfQUqgOsZWI/lR31C
         tedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781444413; x=1782049213;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Ofr44S+ZyNvvuzy/mGDum3FtpyF4ahy6qr2J/oI/HI=;
        b=iTB0KbvF3+3aRFMJ55AZkqCRZ3Z9speb6g2vzNG1X/Lg4KmP3HNWd2qO+SovpzMrt1
         +qW1pd3xWiFwUMSbrfNh9HpWSGar6FGoA+jScSr5oXAYYMCPbjbgpaWNHKYEWiw1uPOy
         pb6Gz2dje6iTh1wihwNwhuYl74qenZSfsHZiUcps3+/4oFGgTjP2Ur0qXF8+ylyT7f+D
         J0VWp4Y+zGFzxsfCgjWn5y/0UddRoY7jAGE9D9+0DBXBxlcADeWPifC7dAxMA2M5/CPm
         EmaZPDPxeZqjtU/hdvj0tN5nLGCwdOdu4rUe4NdLBtvBq9qig6hJYTAHRnIqfE5urAvm
         LOlQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xPxuf+6XKA/xrzDYjHurVE898P2qFNp2nJlbgFVPCDD0PLCocFfbQcpWqo3EcQZsPMTOMysk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwchAidd3nOxb3ofQbYoc0ast+0xUY+htvVTpxqaV8WqwrgmheR
	nE/gMAStNLY/TxoUUPG82tR7NPQwu2cS1E3yG6bkV/Q8qMXY4WYLY+qy/NI9EPnuYvX4/mkE50P
	w/wxXP3qj2JYLWRbDVDQJSIVk2lQPn7623V7E3EQgDIwmhexgLC6er8UE
X-Gm-Gg: Acq92OGYkZldRv2xlFqhFOpuC2JoeINxMLfTHz9DJ3gi+FYCu0Om8BqGvdj6jEtDPSW
	nUu1gew66BwkkXSzB8KeJa7ZBBSASifzHstn9SnUCwswGCOXKvFSMKLOrZlDKV/gogWa0Ey9PZq
	vGSWzExp2ccuTr1mNYj0INI9GV112P+Jix93WjICA0MXjjH/DnmTc0ekjs2H7IRX3WUu5+Rcaib
	tXIkK5rYTT03n2DYbM9dfZk6HOs++sHXkUgzRxJUEIvwMxLdsw3/GDs5o2ti3r3lwyKfab9La3z
	2ZVqTiUi
X-Received: by 2002:a05:622a:aa85:20b0:519:56a8:2693 with SMTP id
 d75a77b69052e-51956a836d2mr5146941cf.24.1781444407310; Sun, 14 Jun 2026
 06:40:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com> <20260612142245.1015744-2-vdonnefort@google.com>
In-Reply-To: <20260612142245.1015744-2-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 14 Jun 2026 14:39:30 +0100
X-Gm-Features: AVVi8CflkMLWEmJ-bRb05G8DCa-vXiyFOZ98Tj68-B2uYheEBh2bKJRUC_TcnVk
Message-ID: <CA+EHjTwSU67aNdgWvgR3ZGSB07Hu7wt4rUBkVGhrhoHKa_S1vw@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> The hypervisor tracing for pKVM relies on the __pkvm_host_share_hyp and
> __pkvm_host_unshare_hyp HVCs. In order to start tracing as early as
> possible, allow those two HVCs before the host is deprivileged.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

To my good friend Sashiko:
https://lore.kernel.org/all/20260529121755.2923500-1-tabba@google.com/

The hyp_trace_load() issue seems legit though.

As for this patch itself:

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 043495f7fc78..fb049c40d04f 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -89,12 +89,12 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
>         __KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
>         __KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
>
>         MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
>
>         /* Hypercalls that are available only when pKVM has finalised. */
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 06db299c37a8..f0c52667cf52 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -721,9 +721,9 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
>         HANDLE_FUNC(__vgic_v5_save_apr),
>         HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
> -
>         HANDLE_FUNC(__pkvm_host_share_hyp),
>         HANDLE_FUNC(__pkvm_host_unshare_hyp),
> +
>         HANDLE_FUNC(__pkvm_host_donate_guest),
>         HANDLE_FUNC(__pkvm_host_share_guest),
>         HANDLE_FUNC(__pkvm_host_unshare_guest),
> --
> 2.54.0.1136.gdb2ca164c4-goog
>
