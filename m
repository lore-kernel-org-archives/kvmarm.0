Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6982DF12F
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 10:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769596129; cv=pass; b=VU/YF2F6wRJW5Vo7+eNn4jWj3hn/25nt5Ajy03KYGSr6vQyBQdQblHWfPjRGYP+cuN6JGBOSvelIPDV+5zuyVAhMCPObH64oOlN34nT0kl02KU6sDWbeC0DtnBSBYl/rH9R+CkSUiDn4Pzf+Des7cKhowHpouG7p1KlFHB422aY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769596129; c=relaxed/simple;
	bh=TWpq0oCElre2qoxuaGV3eWiIi0GSeW1OgmW6PzbiAfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e588EPCc7lH7sGd+5kvM6Crn4bgdc1km5rlUwhYfkjK5ptPqFyjbNYx29AGjimfR1oddqk7FnJGidarB2ypsoTXM6h4nT4Hs6lE5hpsCBIimfZb3FwLtUUjU/VoJmSK38AiTmRLeNwLGAgbvgJwdkymM4RB2FkLJI3NUm/t1DrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fL231upf; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fL231upf"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b0b6eabso285641cf.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 02:28:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769596127; cv=none;
        d=google.com; s=arc-20240605;
        b=jdz1Mw4v6rm6o1FzcT9wBj3hBF2xka5eFQ9n7UdeztuLxga/ZE/aL1YJmtG2iH+v+1
         gUPVkIBvBtd1qqmQ4co9eazxD86wb5SM2s8Z9UwRNiuwCJPUBjxtOfW6mwXlYx0/NlFs
         +pioZWAEtobZJa++Z5zxdSBdd9kzMpQKtFbXKYlmtIhZveagfEsHt8+dEYRPHLrYRQ5I
         LKFD/V4XGIZXUHYuKLo5RS3bU0CV4WfoNlGbeQPW/nUJDRtURrWhQuQq2YIERwoEevZm
         L75fK6QUXl2YaSBeR2RlGzpr/VmoV2hs/o7JSpqWJhmrX57AYSmAYf8oPs6e7dM7lNnF
         /fvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JvMIIZbSd7GJ9fTBCuvSnMcKyzbKcHEdp97Gn+39oUI=;
        fh=OsVEnhpHfDtKQejlv1Bgs/tZPAfr3IJ2Ck5WUUi92Sc=;
        b=WHwbXcAqfYAw/dmhMMQTeehTu3OhNp7qxTDMNKWobYdlrOEHpAWg9GU8GdrMAqLyLL
         YjcU++g3zGhJ2OUH+Z9/FKNG30o0Z/lC+HLGnKmICRu9QMxu/Gj2f3a6MeWBr7VCMwsh
         AeypRdWdL+rLmX2UqArbecrV1/KJrvjaD65kDffe5f0UEO8DuhHNDbn/wFPezuOOpxgW
         B/od+F9VqBlsXT47YdtT5FatVZsWDpWej4cDAo2u8eDha9fCkA/fCw8dL9W7zKL5jM6P
         qZ0O8fp9//3h7LPg9CsyxfmdBKbGOT9JyD9N32TO0YChx5j+BIsSFKWys0N+0Gtw/lwv
         aaBQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769596127; x=1770200927; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JvMIIZbSd7GJ9fTBCuvSnMcKyzbKcHEdp97Gn+39oUI=;
        b=fL231upfl6Asb+6e3klqxDo6wR0x4WuIVWwW/tH5wWybiIXbwN6Dz7QYtgU2Sj2CFE
         kwLOfSxc6G3gtsAuEDz3zJZrBtS34A4Fs400+VCE7Dpc+g31jouaTt7cMWcPk8yvtLHI
         H4bpzI9VGHLjK8YMdnAThtfv58WVKB+MK8cBHMX8HqxtEq5Z1DKLBO9tT17IWFEMYAUW
         MQPce6nRf72C74klKmlwecgGL/B7imYaZhFGU08DNKodxYyJjJifOfLWyUSrXaZsBs8G
         EerSTtLQLiOadSpUrHLixnq+lgk5G6s2DHeoWrJv93R+aAHCcWqwBRx6ZztNYJV+vsZX
         lM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769596127; x=1770200927;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvMIIZbSd7GJ9fTBCuvSnMcKyzbKcHEdp97Gn+39oUI=;
        b=keA+ePAmWvqWMGSH6leVlgvlzwIudN+5ygnwnhsECydwdN9tDUeanG5au+h2ie6yCI
         Dvk0Y3o4HpPwK8F8KmsI8dcI01QyqU6OHTRuO6c0FA8GkYPS5eXNqtQE7p+ihW6R4lgY
         +oGZVYC2nYs4pSTk47X3C4BtZDmc+DZ3p+JM23JA6fGd9wFUmpceL9DH7py2cNIkp/dj
         KgGEmmy92NH9gmKlIIrJJJkPxLtqpgv1+aCelQqG99aetfYW+jKVaRdrmUquzAm4gzzG
         BUKp8SMK464wPxhOLeCXPHB6ZJeu6pg/p7eyvsd7SFfUHaJM13WYFhbPl5zUtKz7FquB
         IMKg==
X-Gm-Message-State: AOJu0YyQR5IcNOobBMRymCK3+msdlg/ADOzmmNLcX2Lkam/BElzo7Epf
	lJGTMbkYcdj3ymS+4YOohFlFOQrJHWSmDmtL0v3DbHGWM+s4wgwUllIegjCsqUX0QXAqvNsDrXt
	DVVJ7nUpT0LvCEWAhN3zJybWaYxEhJX5Xt25F+JO9
X-Gm-Gg: AZuq6aJZbFUVzqxFtuagtLbeK9TIisGPiBNFWZuM07iNtB7QIlnFXAe5piOLcQ/3rMO
	SmvLliQBvkSY1uZhq5aQh6QJ9mwKYWp15zZ3qO+0pbe9LGM4ZBbw0Uj3BlOKHNsU4d0/RxrpXif
	xBBSESso4fNOOOpkul7mHryhukramJkvPh3fosNz0/TAQLMy9bxi+7Z389RQXSo616SC4XGOxtq
	jx5EWlimn+GnRauWPCDWxlyKbhfWKDOu903e17VsNGkTTYppIvb0OYkvyTIy7OH7MWNtka3sAP7
	QUd1/MAY88yH9KiGDWfmECgBVg==
X-Received: by 2002:ac8:5743:0:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-5032f4dbbc4mr19998971cf.13.1769596126531; Wed, 28 Jan 2026
 02:28:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119124629.2563-1-will@kernel.org> <20260119124629.2563-23-will@kernel.org>
In-Reply-To: <20260119124629.2563-23-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 28 Jan 2026 10:28:09 +0000
X-Gm-Features: AZwV_Qjs-WnEBIs4c2hvuOliOYVNdOz8-aWQ2TuJZEGeO7jiPDjVSORPKTi82lk
Message-ID: <CA+EHjTzJ2=195bc4RwiOUY9Nt48fkHE8Oju6q0RwO76Eeq52aA@mail.gmail.com>
Subject: Re: [PATCH v2 22/35] KVM: arm64: Change 'pkvm_handle_t' to u16
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Jan 2026 at 12:48, Will Deacon <will@kernel.org> wrote:
>
> 'pkvm_handle_t' doesn't need to be a 32-bit type and subsequent patches
> will rely on it being no more than 16 bits so that it can be encoded
> into a pte annotation.
>
> Change 'pkvm_handle_t' to a u16 and add a compile-type check that the
> maximum handle fits into the reduced type.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c    | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3191d10a2622..60a5c87b0a17 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -247,7 +247,7 @@ struct kvm_smccc_features {
>         unsigned long vendor_hyp_bmap_2; /* Function numbers 64-127 */
>  };
>
> -typedef unsigned int pkvm_handle_t;
> +typedef u16 pkvm_handle_t;
>
>  struct kvm_protected_vm {
>         pkvm_handle_t handle;
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 9f0997150cf5..c5772417372d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -223,6 +223,7 @@ static struct pkvm_hyp_vm **vm_table;
>
>  void pkvm_hyp_vm_table_init(void *tbl)
>  {
> +       BUILD_BUG_ON((u64)HANDLE_OFFSET + KVM_MAX_PVMS > (pkvm_handle_t)-1);
>         WARN_ON(vm_table);
>         vm_table = tbl;
>  }
> --
> 2.52.0.457.g6b5491de43-goog
>
