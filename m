Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD2752121D
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069970; cv=none; b=ZepO1BM4rtw2Jmx6HI7jm/aM8o6fAOI7yAr30Yo/w6tpgUVCXak36LvimFt0RiU21qeEYUKcQFkf/pGBFOwxTMzuQ2x/sBc5BsaOObM59FaBTeq8d4BADMfXIwC7d4tynYZ1gUHAKhMO7zraVvsarElJFeGIPmR3syp3hDNAmyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069970; c=relaxed/simple;
	bh=LJpH3bYFQC+/FEkkPLgmjr1LA7FSXeHEvsuG8NBPkhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eYDrC051T/Lz9sS/R/WmXKlARSCeo6RUucCbp3jL2rPOUPGUTFqfbFjSdt0y258kQEUii7TA4z1DM3DQNni9kQQ4UBmvVVnLx4SUFUH+B8yqWNwDG9nfEyOZ5rYQYLPRUtXYbnp1voncERWkabGksMOchkW8a1zSCm605uJKkXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z3OJi2Fs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z3OJi2Fs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792069968;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjkC2h+ZCfM2mKlA1Wlh748PEKb06peYkGGWGp6hhR4=;
	b=Z3OJi2FszWEVQWugbctorhuBgsTzo+Wu94Lu62NyG9OenCl/8lCKcEYNBM2WMzw1+du93e
	WFt+6oXUtSb0u/3SKymUc8OlaDKJQEsO8bhAHfTUmd53H+d5w/6EI/aswYlMji4bk2nie2
	Te9RbTbqbaJYZqUnjDnScOIzcslivak=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-p08n9mQsN3OhvPIk39DXZQ-1; Thu, 15 Oct 2026 13:12:47 +0000
X-MC-Unique: p08n9mQsN3OhvPIk39DXZQ-1
X-Mimecast-MFC-AGG-ID: p08n9mQsN3OhvPIk39DXZQ_1792069966
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a021b1b561so42990615e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 06:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792069966; x=1792674766;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SjkC2h+ZCfM2mKlA1Wlh748PEKb06peYkGGWGp6hhR4=;
        b=z0mmhW1wAOY4yYx2NAKOwpkMd3e9b7dcDSrD5aL/Nx5znXzT27Ioa7lwS7J1K0gArv
         +iJB/5xO155jC1SHzA6rfMaWfO+SoB3Rjnpz0nOYlWckkVWdmR06CqqLmn3la8ukFAx7
         64MTZ0xI7BAw0KuZYDdD9y+PSOPuVTccVVdpE2GiibX0loneL1z3KXGLmXkB347NGi3Q
         UCmfRonTDKHyxdMI/X7TNgsPv9rJhl9ryVjGnctlK5mZS6czbPODMb4Kx345b1maMoMr
         JVvqcgVVCQ4GLn26r84IO4FdkGHXhe7VhjSzUQJJEJMpf7rFQ/qkH14X7EgMv7NJhqyD
         iFIA==
X-Forwarded-Encrypted: i=1; AKwUvBywgFTTeEaW7dmm1VZOCd6tYO0jCTuOLh8E9M4VXJ+ayjzuJg48MjMtDZzyv+NhqchZQaXYfCY=@lists.linux.dev
X-Gm-Message-State: AFq9FYLoiXgdiXjdHjilLV2JvyzvTiibqnTURZOrHDX9fNPRH/IkALgC
	DDgn0vS3GUIf2WStZQQhKSQzc6oKDA41EhkinxMXnV99qWJR57SOjUoj+1D9t9ujlm/QSXr4H3I
	pEtbI94oNqhvblFQiqQ1F4xZWCsKV3MgW4ogt0jR6JtKgqDwZDzwQjzXyMA==
X-Gm-Gg: AYBFou2FzxR94D2k/Aaf/AjiRdbtgpkuYG1ktAD6gCt48BqpTters3HsV4cEzp7uYHa
	oyk9t0gvAkuODo1YqjhkRG6PgHqW6q+kRF0a7SmUdowUtb+nPJz8PISGd476DTiVvS1GOn/TlM0
	TlCVZP8xBv4CrHsrbNzYMQBPVlskeLGkO2bCIk5JX2j6t0Fh7NxQh/FsGjKa29A2803n4bppxvK
	tC5Wml4u6D6ehSKOo/lnrnad5s4Gg0V81DuYGt6a9jX52v1EywqPGjkFD/IKsHg/VC+z1epf9p9
	2lXk53TNnEINZm6w4mKORMRPCfY+sYdOQzwg91+XpQN58lTfWidzSEhHOLjwYDN8/lUi89Rka3O
	oEqT4vy87k0ZwmeS1QmRLHO48QozGnNje85tnAvdlAhDAfVsn
X-Received: by 2002:a05:600c:548c:b0:4a1:a7f8:c11f with SMTP id 5b1f17b1804b1-4a1a7f8c1cfmr185453165e9.9.1792069965725;
        Thu, 15 Oct 2026 06:12:45 -0700 (PDT)
X-Received: by 2002:a05:600c:548c:b0:4a1:a7f8:c11f with SMTP id 5b1f17b1804b1-4a1a7f8c1cfmr185452645e9.9.1792069965247;
        Thu, 15 Oct 2026 06:12:45 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0aaaa34sm18547051f8f.20.2026.10.15.06.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 06:12:44 -0700 (PDT)
Message-ID: <6e0b9a10-84c3-4948-8eef-3d2ea5c44a56@redhat.com>
Date: Thu, 15 Oct 2026 15:12:42 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 11/25] target/arm: disable PMU support for named
 CPU models
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 ping@khushitshah.com, sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-12-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-12-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iVmEYstKPsp9d6-Fgz2dG9RwtJhmTeg8LzEMlQbbS3E_1792069966
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> Under KVM, the guest PMU is backed by the host PMU (event set, PMCR.N,
> and PMCEID), which may not be portable across heterogeneous hosts.
>
> Disable PMU support for named CPU models by clearing ARM_FEATURE_PMU in
> the named-model init path so arm_cpu_post_init() does not create the
> "pmu" property.

To me it shall be possible to turn PMU on even on named model. I
understand it may create migration issues due to the HW adherence but yet.
I think on x86 you can use -cpu Haswell-IBRS,pmu=on.

Eric


>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/cpu-models.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
> index fed3197186..153ee10ae6 100644
> --- a/target/arm/cpu-models.c
> +++ b/target/arm/cpu-models.c
> @@ -159,6 +159,10 @@ static void arm_named_cpu_initfn(Object *obj)
>      /* 1.b Properly set RES1 fields. */
>      reset_res1_fields(cpu);
>  
> +    /* Disable PMU for named CPU models. */
> +    unset_feature(&cpu->env, ARM_FEATURE_PMU);
> +    cpu->has_pmu = false;
> +
>      /* 2. Add sveNNNN and SYSREG_ properties */
>      aarch64_add_sve_properties(obj);
>      aarch64_add_idregs_properties(obj);

