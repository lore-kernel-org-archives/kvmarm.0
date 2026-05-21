Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475613CBE69
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368902; cv=pass; b=AU7L0SqjtnVwzGuq7eYfxoTcZWNqZFGO/SqVrpfCDdKLUjctnUuquulbKuZ6VwodGgNoeYze5PPSpZdMM0s19pP0MiHig+/bg6L5c9ls3muRdhCBcr0NYbWAP/nykISUSdN7SMKlvoaQI2dNuS3T6n0U23KGYNNNvxmK8qRqgms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368902; c=relaxed/simple;
	bh=oFlolGhbxQdlCS5Cn07/fSyxCv2xQU6i+7GOwIjdwDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDauYpsXR9HPvirT0zftmPvru7jOFExyZ33CNR8ADo9BB2w7EIgSgw0ktHW5zF+FIEsDYlax+3b/IpQjFnOcM66TH+mT9xahIla/0fdL6i3f/d8EMzJqZVL+CnosfO9cNIPgRIQsLe17vvz6MGdlAbokiMEuxdTN8AJzHUZ+RWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QOx23qxI; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QOx23qxI"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-515548f390fso18331cf.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:08:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779368900; cv=none;
        d=google.com; s=arc-20240605;
        b=DeKnmV9RZ+LRDOomISyKSKzBKrhgiyeye+U9sl439Q1rtyCsB9UsGzrfDNQXRa6J7D
         ejhd4HbGzIOoVeDcES9xmGxTreaJE3RgX3jX28855L1JF0vAPJZmt0IHeebojjwJG5RP
         Waj6Dg2O8Rs3SiGgzRepbtDhj0iYmCvG9rB6P9ajvkRYuXS7S5YZq1O7p28ahpm4IlvF
         kg1xkBfriPp1f9+/TiXXtrwmDrrEgXZO60aZa+iV0rrJokEJiU2N2o9H9lFncpw9SwF6
         3XR/uKWdCY8LAJDnY7Mea5zVg/1OJFyHRJGLn0FA3lLVO8UgW+wLensuC+A022SqimrU
         +Rjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=18hrApFzZzgIN45e6vff/pwk8Jz+2gi48Q/A4BxGBa8=;
        fh=+ZdJ3ygR18TPcvdmRyE4IfKASj3k3+4D6bmgwOLe2Fg=;
        b=HIGPjlwRpyvqrHDf26lLPPTS3o3RIWUboBipnsbRnResKsStOWDYGFoEKOdmoijWHU
         dU/F/GZk1Cw3XeRxBhupf0cQstX+24sczlN38I0eZKk2xBP4T04Z2/yplkS/OKLhJWyN
         jh+9lr2eVZsI3TyEsFoCkcyq4F0gavkD2p/ptZxmCTZQUVYPY2n8KsUru5cCsoAZbr9h
         99NflUEIeWfn26420wheAZ7UWHOQUP3ctGHQCPkaB1N9XPGBA4K5fAWHKYqlh025+urO
         SU/z6QEgiwjdmukIEWnaxZJh/yEZBQMFsBFrEiG9drYkWzFBUlaYsmx2wWmsvLLmvQhA
         11CA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779368900; x=1779973700; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=18hrApFzZzgIN45e6vff/pwk8Jz+2gi48Q/A4BxGBa8=;
        b=QOx23qxIVHi/bfnH2IFrzjXTh1FoF15xP8+6Eo0917VELvvAAHdftOhl9rDS1Kl5Pd
         NlUBDeJVkddb1TJ5ePwMpxFVpWVGjtlD2Pb8uZdw6H/8fj6LdgoeuNIr/wT1cTZO99v1
         rQFfuZIA+ZM30RnWO+Nz8OlLy6FcNkTRXhH9gBK2uNVAAWir6+nNRzqdYYVRp3bxc1R1
         ypS2lF6G2XiEzYVp7fRliGytBVw42UL4IMezws+y9WEDTRffDU0cXU4cs+1x+SJj4Ix/
         SR4da347fyOJ0UxwrQFEm5/2FZDKWCVtTK12631F8n0S3cI3nTqn558KZXesPTsMquTd
         cyog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779368900; x=1779973700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=18hrApFzZzgIN45e6vff/pwk8Jz+2gi48Q/A4BxGBa8=;
        b=ZzpzARuOfJWIclJyweEWQeLJhSpxr8huwY4HaAeJnyJhpdRiBPKP2u3y9fz4/KrLno
         EjWBFZOzmiDm9qzaORDVr41Xm8ehflJl0KeYbOzmJr08Jj0+lskoNfeUM+OQBl6Cuenj
         hj6JA1G/8Z+SfaYHg4IvuR3hPyI5jZ7xsWyHKP2TkQYhxbyx7AFEuPOm3efKYeEy4Wzb
         AlgbkuHWoCBlphE1Yb3xYng16Rm3bq4EV0nL0Ll49NGrGjuXnTuyn++0p+hticrtU873
         pPCy5P4mHYZ/hvX4fLC6dKCw1We/fniBudtVGW1PhYvHoB8oX7SOnQHIls7F/L6Pe0cb
         dY/A==
X-Forwarded-Encrypted: i=1; AFNElJ+ziGVF7NsmJY0R/wgxbdxmEbeiROUsqa+yEpX4gaEkSuW6tNYnuqkobvIjYEE83lw4p0dekMM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9fpfkpZFjAMIlB19DldCpQhbP6Ls4F3kUyU+c3R2Qp0kw8ZGu
	cTW7XeoEz0qlRMRA1W2bTOCLpltnyN0bobVKwa3Nz+hEj/uRfEAAV+cojQnjJelJ9HfFh/R8560
	rT6nhJF+WMbiISYKHbkS9D7QPZ63MGJjtHd7TLBxM
X-Gm-Gg: Acq92OGnZXc8Khlbabos084hWbbAv4DkzI+g5UNt1VsoJOH/BFeD2RSX6WO12DrBcjw
	uw4t9Odl9kjs8IRPuaXXREKv/diWNYM0xkKkbkcHcvHd4BBZgV/fhQDhUQtPVZPQy6Ef0SYbVgh
	I8qwLwB5gi78Wb3wmwUvidSJQFMkLZh9VDP6LtTWkxQYU/YXVLXsPwgfbH8nFdusaTkuGT2z+G/
	K41gFyMKLuVMt62tmyBfZ/YrNizIjyuiJDC4Sveopkz+xUlCXMNNcoREXv/qKAgf1resiK16kFB
	GfUbwSVZhDbea7+hmz4=
X-Received: by 2002:a05:622a:a94e:b0:516:4f62:85f1 with SMTP id
 d75a77b69052e-516c552fa38mr7271331cf.22.1779368899622; Thu, 21 May 2026
 06:08:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260521102149.804874-1-vdonnefort@google.com> <20260521102149.804874-4-vdonnefort@google.com>
In-Reply-To: <20260521102149.804874-4-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 14:07:40 +0100
X-Gm-Features: AVHnY4JJsPwlriAMlvCiGKk44PSS2scCNoIlEjeGoEEyPmlqjyWtKmSwSdabchs
Message-ID: <CA+EHjTwVF8k3EhTCqQNU-zcK1+1ctLE-cEBHCWzgNtudW1o2kA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Add fail-safe for refcounted pages in __pkvm_hyp_donate_host
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 May 2026 at 11:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> A previous bug in __pkvm_init_vm error path showed that the hypervisor
> could leak refcounted pages, (i.e. losing access to a page while its
> refcount is still elevated). This poses a threat to the pKVM state
> machine.
>
> Address this by introducing a fail-safe in n __pkvm_hyp_donate_host.

Stray n.

> Transitions are not a hot path so added security is worth the extra
> check.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 42b0b648f32f..bb97d05b9b25 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -855,6 +855,16 @@ static int __hyp_check_page_state_range(phys_addr_t phys, u64 size, enum pkvm_pa
>         return 0;
>  }
>
> +static int __hyp_check_page_count_range(phys_addr_t phys, u64 size)
> +{
> +       for_each_hyp_page(page, phys, size) {
> +               if (page->refcount)
> +                       return -EBUSY;
> +       }
> +
> +       return 0;
> +}
> +
>  static bool guest_pte_is_poisoned(kvm_pte_t pte)
>  {
>         if (kvm_pte_valid(pte))
> @@ -1053,7 +1063,6 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
>  int __pkvm_host_unshare_hyp(u64 pfn)
>  {
>         u64 phys = hyp_pfn_to_phys(pfn);
> -       u64 virt = (u64)__hyp_va(phys);
>         u64 size = PAGE_SIZE;
>         int ret;
>
> @@ -1066,10 +1075,9 @@ int __pkvm_host_unshare_hyp(u64 pfn)
>         ret = __hyp_check_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
>         if (ret)
>                 goto unlock;
> -       if (hyp_page_count((void *)virt)) {
> -               ret = -EBUSY;
> +       ret = __hyp_check_page_count_range(phys, size);
> +       if (ret)
>                 goto unlock;
> -       }
>
>         __hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
>         WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_OWNED));
> @@ -1132,6 +1140,10 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
>         if (ret)
>                 goto unlock;
>
> +       ret = __hyp_check_page_count_range(phys, size);
> +       if (ret)
> +               goto unlock;
> +
>         __hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
>         WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
>         WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
> --
> 2.54.0.746.g67dd491aae-goog
>
