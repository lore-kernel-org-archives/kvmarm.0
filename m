Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E236A34DB47
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763483933; cv=none; b=BX4uAj6xny0H3xejrUNUb3CAT8b0d8/PSus+cK0sg3U3ae7P+vHj1FrnaU5ZZM+uoSMkh8+2AvracW38XNEYWXbPKcZmuKydOS+z4FEq8WU8SLUbm6ZrhUI7HuxhBr3eUH1mRqi4zZXua6vDc9B3Sd8UP05fMJcZQiE9iqW5d1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763483933; c=relaxed/simple;
	bh=tjzFIyvBA/l1cVOfrA57AItu/RhSVfv+Cq8LcODc5Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OBxtP92FlUxxPpwh1sKBpaSSXHyRy26KAvJVi8xwvNL9nyskkfDq8p+rrH69SF+hAPBwCbu/bhu0ZAN2gXgGBo/PoNXKHQWE4XL+SM4hT+mxuGZoJmgPQ4sR3q4LNQvsczBReNYZUmCwAVcAGxk0gFbBM4y6vgAPzYw6QCwfDkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hwq4JRU6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hwq4JRU6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763483930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CyDkLmPEbdh4EVyfKiiEMb3jmOinKJvABWPtOOckPaE=;
	b=hwq4JRU6AboFu70lZgHr0GW/2lhxeMB8ewNtgSh9FhvjI5n9Awur3m4iYirxdxd6i2XiPh
	JmnnruXzx2y37M0PQC3di7GnVdJcocSZUZiiQEQguzQtwXQ3QpY39VWOMc3ZXr57CPmdkJ
	qI+yP6McxSEmAYDZRMWxdKIMlLSbOZw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-w3q1dhuEOsmmdSvyRoArtw-1; Tue, 18 Nov 2025 11:38:47 -0500
X-MC-Unique: w3q1dhuEOsmmdSvyRoArtw-1
X-Mimecast-MFC-AGG-ID: w3q1dhuEOsmmdSvyRoArtw_1763483926
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b739b3d8997so222881366b.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 08:38:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763483926; x=1764088726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyDkLmPEbdh4EVyfKiiEMb3jmOinKJvABWPtOOckPaE=;
        b=ZDEI+m9aT5jePM3CaZ1K5YXQeZ4OVZbbS0zzQTkYLqbh5zWZDvHPoPxyN4qFLee355
         0KoHVMd6GLntyrIUOfZsf7zzKhff0C9Cz1akYUw9N+eQOkxTuciNCEfhu/LftrcwJ3hH
         jM+zPsqpobEkpzxFGSf/7M0SNji0Fh8/aDKoi2AeKPpKujYmKcWN0b8kOZqokd9wTqVe
         N9Ct5Aw/E9k9vixSpObVmfenu4kDq3h90ZmIRga0NL4yjTef9MsYzkd34JmW9IVjg0GM
         LFRvgSMdhMTjJ7GlIT4tP0Wi8EzZB8mw6rSUk1jD1hmOi/r7nxKx2TtoPUy4ry23Ez3/
         REuA==
X-Forwarded-Encrypted: i=1; AJvYcCV/BigAdCe5ZdYBjgUszK+GRgND/quWuTBuum2y2rLZ/Biz4Y/KZgne2m5uTPyeDw0onp7e31w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvmylZygPXkVfNhV7QAqz9+2/RrM7VKT0Exs2DXH6T/IuB19GP
	rSQobo/zk8n8q+ZHnnidnnn9ghYxLS5PXJgeIGL4rY4ImGDBIm6JIcgUxmhcKmcrXsRJa2/wWJF
	DKIflQnuCotmaoH4spbm3hrLKrjbIuOb2UbVqeNRX7PuRC9DSOT3XrQeQ7g==
X-Gm-Gg: ASbGncsn/NkVJNryx4jsvnpC/CHC2weMKzea96e4WlTf17HABuk4ThEFz30DBMg3a4s
	2XHeIqfsvcltKSd42iy9J+W/BX3LX/idNXi+r+yOzLsFB/7UXl2YAXvzczr/F2ejtCMy63Aeqjt
	KAI3ALHpK3pODc2RupNUqXARF1JT2dxIsbNslMjFugWzGF3JtW76Sc0uRdQef6jWGDAfWFMk9Qd
	32F9RqVWcDxvLmfOsDJ3qxi0FQh5x2qujBPbYSKkGVucCFBzELYIt6WvVcVeRHg2Xv5kMwjXv3v
	ExCOICKA3EYwW2TW8kFfXCvPtWk9F/Qn0VqqgejFLUZq/Z9coC6gllrxUAb22o4HJxJLO+PUM60
	XNkrkOYyc+7TAo8ycb3pFdjvJx0MsxfTG01MHoSqE9RfYPz3ieWGEiAXBQjwetkShapP42qZNaJ
	+103FkPLHSR3u12/k=
X-Received: by 2002:a17:907:7f02:b0:b76:31e6:2ee1 with SMTP id a640c23a62f3a-b7631e62f01mr102265766b.18.1763483926305;
        Tue, 18 Nov 2025 08:38:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMe3P2lDhvef1j0kFOUzz5ARTSXWKhfn0W9nGpOzbOGXUPzG/TeDHySCcVXMMmB9qwSapzbA==
X-Received: by 2002:a17:907:7f02:b0:b76:31e6:2ee1 with SMTP id a640c23a62f3a-b7631e62f01mr102262566b.18.1763483925892;
        Tue, 18 Nov 2025 08:38:45 -0800 (PST)
Received: from [192.168.10.81] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b734fa81172sm1377513166b.15.2025.11.18.08.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 08:38:45 -0800 (PST)
Message-ID: <62dc0550-340e-4126-8368-1869609bbd68@redhat.com>
Date: Tue, 18 Nov 2025 17:38:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 fix for 6.18, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Mark Brown <broonie@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20251114113415.3217950-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251114113415.3217950-1-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7vWzw4zUTp9B6DDde9hjW947PpxtupeVenMPHkUs73M_1763483926
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/25 12:34, Marc Zyngier wrote:
> Paolo,
> 
> I'm back with my weekly routine of collecting patches, plugging
> another couple of regressions (the FGT one is particularly annoying).
> I hope this is the last one for this cycle, but my gut feeling is that
> we're not quite finished with it yet...
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 4af235bf645516481a82227d82d1352b9788903a:
> 
>    MAINTAINERS: Switch myself to using kernel.org address (2025-11-08 11:21:20 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.18-3
> 
> for you to fetch changes up to 85592114ffda568b507bc2b04f5e9afbe7c13b62:
> 
>    KVM: arm64: VHE: Compute fgt traps before activating them (2025-11-12 10:52:58 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.18, take #3
> 
> - Only adjust the ID registers when no irqchip has been created once
>    per VM run, instead of doing it once per vcpu, as this otherwise
>    triggers a pretty bad conbsistency check failure in the sysreg code.
> 
> - Make sure the per-vcpu Fine Grain Traps are computed before we load
>    the system registers on the HW, as we otherwise start running without
>    anything set until the first preemption of the vcpu.

Pulled, thanks.

Paolo

