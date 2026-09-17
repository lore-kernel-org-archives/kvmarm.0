Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42DB4C754C
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 11:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789645672; cv=pass; b=HsM3fbFLkO6U7YCw7rmQo0EZ004QyE2QIYpZqkrmBSR+kep+LVC1Wl5efqFLy3mQW1JDPU1OmQGDbcCpsP1fL8vpaIj1cSv9pwJpA3Mkts1h8cIRCqfolWkJGKLVMSWqf5zC9Al3TK44hWqgO/ABb7xoZbu6hx7FZPuvIse4gAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789645672; c=relaxed/simple;
	bh=FzFQy2j7fd5eTJJCXIk006/qLEE8a/Xai2F79n9BXDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AW+eWu9O4Q4xuAjlf1Srz0wL8cq66W3xsbavGGHBE683l8MeHbco9/THiJ3qadvUoiQd6fBhzrmE6TPdz4cHlzT4O3wxbdappTQMneID7ojedgoI1YoJfbuqfiNjNyReHySlUGNTW05Qx0isFflG6L5jEsRZretP4Lg00zrmZ8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DkAzJqLx; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkAzJqLx"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b778bdb5b8so992e87.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 04:47:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789645669; cv=none;
        d=google.com; s=arc-20260327;
        b=mSR7UT5qt4glaKi7xIFGqLQSGaSCPndOhPMVoPrqRwgXweWgYHMCELyRkvsETyiI4o
         +ldbIjUzx2FSNuERQBWrJIUufHKfj3daT5CRlonTsX/wyHXtwBDMs5BCYrQCr0uaklKM
         5Vdf8tC1X1vZ17v03s62MnGC5ATRAKX/y7l1En+1KI7OQ6YwkuVmEXwMJoNLszbzJVka
         fnMdbj8/GRCR15K/p/NEpslLc7PWaqbW6RrlGPcS44/UUj2lYh3ExorYCruSUOoVcage
         VaOPtGMIcgqvWn0+irfOgkq9+7+Uk3mcldgqhiGHJik3vloFlodOhKGO0UwmzK9+5zgZ
         O7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AuZmGKQOozDdYhExUfv4iQ5oFoGABaotqoRByOfZs54=;
        fh=Tf7zCn0jjMWOLW346XPsCRDh0CJ0BMVtup9sON1IBd4=;
        b=P2xpyM8ehlkHz3v6kMygVyvsCl+4q4CQbtM0DLh48pto0y5L1rBHnUISLcdgjsDchF
         FY6CLNUtKxwlzi2rQZUwOPDOVXIxbGghYhc73qq2M8/YFZ6cwGe08UxKbtuijtOzy501
         Vnx+xRu2tzoJasOLPbsjNXBTYzZqOVjumcq0iKuB5Nlnu5EuhLl1UhFkEQGrZAOEwNU+
         AZxYg/VQNvYhevdTng+46YksS7AU0y6wjOEoa9ps/y52dKyiVlZc3ogxGUfnfbaHfNS8
         4Po4JsLwWI0GmcKgtqKQ5kJbxQx4I2Bx4xAlmaSGV4O4YZ77WEUUbB0X0fXINgqTVTzc
         jWOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789645669; x=1790250469; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AuZmGKQOozDdYhExUfv4iQ5oFoGABaotqoRByOfZs54=;
        b=DkAzJqLx5PBxOVP+7z9Onvf3mow5z+g+aEhrzJ7uhKLefOIieou8rauw1QkzndNxKZ
         peCJcEAXKJgOBiIylTYGp/5HuPgrHoVvBUNJjLxU4P59VDZP1NJR++DZUf+Q6IOkNVxS
         AWbOjIcqdnnjI8h/sSUuHYkg6cUHdUD21UwjC/a/JWqqwFXQImEq1QCgvWKEkEPqe/fn
         5dIZpVIXHBDFECdMouYrw8CXuQhcDJ47LyH6amwu9hqIzoxpPwt7SXerbjU5SieVyQex
         iD0c024igF9c9fsNaOzJHk+LlAW+Ose31fx6qny88g1rMpsjA5hK2XRfTDWP5J0yKI33
         CHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789645669; x=1790250469;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AuZmGKQOozDdYhExUfv4iQ5oFoGABaotqoRByOfZs54=;
        b=ObyNLMniUbtp0bZ7BkqJsQWrkdajdEiKgh2yyzKYlY2XS/ABf3q4KdVBgI8/Clw6eU
         +6FXuN8ip/ClYozYfgerJ/dO/gwnASBm6Q4Weh6CDNua1SnZ4ZUIPGNdZvy8npe0Mjol
         H4XGvoUdl1kt71BR9otAb0W7yl2xhj62QmW2u6VmR9+WgoPmMj8zewGY2aqWyCe6j9Kk
         sxinjRSDWTbTTwBnekZ8ZvnKfjakjNwf9hHWLm+wDLQVYZvv7a0tbUnP4LoglfIFS5Zq
         ouMW+NoQgwCvVVoE3xcb4SS9rwurVwC5EBFySIR0WMF1fgdSIJuFVepGjbQT7WWPFd6T
         8eVA==
X-Forwarded-Encrypted: i=1; AKwUvBwACMwwJ2DNN9RWDrc11SICkuwxUdRDaLWBO0HeUgs5JdlJFyKP2xDJTMWWZ05MjCGMHfXAsxc=@lists.linux.dev
X-Gm-Message-State: AFuF++k7AsVL+7bRTOpjcIVT2JIKTr+9ZJHI4G4FWEIUECyLrzKJp1bT
	iZ71GjZsVo83zuXMeL3RwIZEUvOW2KYmboPm5UqV3SP2OMdKajjS7s8Pjq0x9aBvu89oq6vILfT
	bn9Xm1DuhK0+/X9HEuZd5TvKI03jbWAOIAsT4yngt
X-Gm-Gg: AYBFou0VD2NFQIZpWGBvYgPg1f6iVnnqE6+r8kmmSnvBZfA30+v8FmeWe4PuDpuoY+V
	U4C56QABAc262g7sGPIWVyEHXU7Yli8OEs6d3eftaONSNg6WS3BjC5jzRTyaAYc5V0cNDYEKmCb
	vSZLVks2gcPVjiHE3Rd7QGB/WViRa3My7JScgmBidys6CzCyL9rQyeIfKVzydo6UFmO9ClTptgl
	CXiZguympV8UbWF0cBB10e/zFupgIwqN5W+TKO4k5FyHqtCYR4PUK3sru1iH+d+yWZGJ1uOwY9A
	/e2hJi0F6QzY/I650LC5ooF68gjr+F2hPo2VPb+DOYOb3JwhYI7q3bOzyQJyxHt0RwFs0Fbw1qL
	HyI9TkHqSzURVpw==
X-Received: by 2002:a05:6512:3c86:b0:5ae:b726:5f1f with SMTP id
 2adb3069b0e04-5b8bff2c01dmr18224e87.8.1789645668434; Thu, 17 Sep 2026
 04:47:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915160141.3543048-1-suzuki.poulose@arm.com> <20260915160141.3543048-12-suzuki.poulose@arm.com>
In-Reply-To: <20260915160141.3543048-12-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 17 Sep 2026 12:47:12 +0100
X-Gm-Features: AcwNN1UOph-dvwenB_bEiuZFqzb6gytAI9_L8AUcm8oP9DDQEKK-aUQXatB0jDI
Message-ID: <CA+EHjTzOR7xczcb1HbUAi3H7K8ta=pFcdjxJb7UixZEh7QS-Eg@mail.gmail.com>
Subject: Re: [PATCH v18 11/23] KVM: arm64: Use kvm_vm_is_unprotected() for !kvm_vm_is_protected()
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 15 Sep 2026 17:01:29 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
[...]
> @@ -490,7 +490,7 @@ static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_index)
>  {
>          int exception_code = ARM_EXCEPTION_CODE(exception_index);
>
> -        if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm))
> +        if (!kvm_vm_is_unprotected_pkvm(vcpu->kvm))
>                  return;

Could the two pKVM-only helpers keep the static key in front? With
`is_protected_kvm_enabled() &&` inside kvm_vm_is_unprotected_pkvm()
and kvm_vm_is_protected_pkvm(), as kvm_vm_is_protected() had it before
patch 5, the boot-patched branch skips the load again for every user.
This runs on every exit: the old test is a cpucap, so on a host
without pKVM the function returns straight away, while the new one
loads vcpu->kvm->arch.vm_flavor on every host. The wide
kvm_vm_is_protected() can't have it, since Realms run without pKVM.

Cheers,
/fuad
