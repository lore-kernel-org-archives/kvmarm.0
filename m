Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE42212B0A
	for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073004; cv=none; b=SxblaMuxXqOViMcaKATeMiKr7XkFqljdYbCZeIusQtpF/1UdLGh7QsPKCcKLrhZYW39yJi8gV4QreEl+PzY4cjqyv5pQSwF2BVBkhbCin7NpnjTt9necfhFAhqKWIIyyaAcU+MQ3DsbrD292fG+cCLdyCVTkRAzguZvFb6QAFPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073004; c=relaxed/simple;
	bh=kwe+tQSoGJcdPaF0wgLIDSLqOxgh5pk6T6ef3Yy9nVQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Arn2txEg5NjlEENNwmTlYk7WgoKiyVGBR3rxepB6wsykRSUu0hHm1w+oFSOoRsf1DX/M8QMNfo6WRGvBHlmNRQPdUKfkI7rWWmbZiF6+gS7bhOjROQaphZm8Cai7gt1kdUfajfbUfzYELg5oBCjAdTAHYYujWbWLPG3DI+TxyAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MYyvorWm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MYyvorWm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740073000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n15bf8E4w81YIQXcbn52KewH85spv07PWBoufUb1/Zw=;
	b=MYyvorWmWManwk1iS1Z/eBaLHsRdX/RoNBHai/2bZKkW0n8tNb6pD8WHlN3Hsx+luK6BsC
	oz42lZA1vzLXayeEFYChp7vg9WkdElbef2cqlJsjZ8PsetMUASfu6nyIRCRtBjA152hfuE
	MeGkqLOv/ZOkOimLe20PsELQ6uQ8Qs8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-XUVJz5qoNu6fuc-l__JFHw-1; Thu, 20 Feb 2025 12:36:38 -0500
X-MC-Unique: XUVJz5qoNu6fuc-l__JFHw-1
X-Mimecast-MFC-AGG-ID: XUVJz5qoNu6fuc-l__JFHw_1740072998
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4399c5baac3so8800415e9.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 09:36:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740072997; x=1740677797;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n15bf8E4w81YIQXcbn52KewH85spv07PWBoufUb1/Zw=;
        b=ZflR6y8VrRKtwldnwpBXGxBlz90fO7hUrq2koxQ3wVE0VkTjBCsUAilYmTiU5MhTwi
         15uoVXGYyPDcq0r+J+MVCX57NQLZTKint1fmu9EWkt1XcouuOqUkc/3M59vZavBu3egE
         KW+bQRf1jUa3vHzrM4QuBOtrD09aCgABlNrC2pjsgI0CYOSJ8A1vAANlfDPzRY7ErAPv
         bL1CBIkMlisCaE/1/qxLnkYJt9Z6LU3mSOGmswte0W5DE9BDKmBHuTAiXsjpWzwmrx8b
         4VazQSqHU2IsGWxwpvS4x4+efFaqtACjM8GhHiM9u3vl+fxui4ksLrHWNNWbZpzUaLyr
         XcBA==
X-Gm-Message-State: AOJu0YxCLiDpA3HmcfiY9WfoFegNofU+3nqcG1iR9pPUqR5OMxAugeGy
	6luMYmyQyZKGEihVH5T9ZHyEJ5bx5O/1HEmetCgm3YDZGMCSc8sevcwqi0b5H6CRwNKmSFj7Ztj
	N4BcyWo43OL3xtG4uzk8rujXds994mAZoj1DNQwzfMr16WRetmYcPbg==
X-Gm-Gg: ASbGnctDbuJyNjcb4qxutEL1Cyjd2Wlo3u7FFtjiYAlEeufHABDOr1uOydFqrl2z15q
	uaZ6KxqPqgT/yG4EAMH6nQyigcy0TfpztlJt1Lfm5ZC6NEItfJWvD2kYRygGeOD1PQgU/pMsiUa
	qn5vOAujDjXOhSrMJlv92PoNvQXz58YTHag9mapb2x1MCKwuSSDeGbm/hUaAwtsErrZdk/A/xa/
	sbc4BmUj0DMSxNCeodjcUxp96uxb82AxC4Mg3vGIMpe1mNeE07KM2WT1et7BuLu86bjjqN+XyIf
	hqubwtw08MXncWVWz3EmgfbRDT/u0+oMV78Px0Dt7ZSeTR/k/nnnaw==
X-Received: by 2002:a05:600c:4e8d:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-439ae189b90mr2045305e9.0.1740072997621;
        Thu, 20 Feb 2025 09:36:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHy5FnqR/8AjjY8RLPAgdr+NGtk75Kqe0crbyEx5UtstYLGj4EGzUk8OPNUhCk+6xcuGov9Tw==
X-Received: by 2002:a05:600c:4e8d:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-439ae189b90mr2044905e9.0.1740072997264;
        Thu, 20 Feb 2025 09:36:37 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4398872fa85sm117119635e9.28.2025.02.20.09.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 09:36:36 -0800 (PST)
Date: Thu, 20 Feb 2025 18:36:35 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>, gankulkarni@os.amperecomputing.com
Subject: Re: [PATCH v2 02/14] KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest
 and userspace
In-Reply-To: <20250220134907.554085-3-maz@kernel.org>
Message-ID: <af16f5bc-4300-54d3-b480-c559ec070a44@redhat.com>
References: <20250220134907.554085-1-maz@kernel.org> <20250220134907.554085-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wRJubcgLp5VhxO18zCq-ve4xt9XDrmEFO5LnPWV3_Qk_1740072998
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Marc,

On Thu, 20 Feb 2025, Marc Zyngier wrote:
> Since our take on FEAT_NV is to only support FEAT_NV2, we should
> never expose ID_AA64MMFR2_EL1.NV to a guest nor userspace.
>
> Make sure we mask this field for good.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/kvm/sys_regs.c | 1 +
> 1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 82430c1e1dd02..9f10dbd26e348 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1627,6 +1627,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
> 		break;
> 	case SYS_ID_AA64MMFR2_EL1:
> 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
> +		val &= ~ID_AA64MMFR2_EL1_NV;
> 		break;

This would cause issues when you update the host kernel while keeping the
guests register state. Could we allow to write (but ignore) the previously
valid value? Like it was handled in:
 	6685f5d572c2 KVM: arm64: Disable MPAM visibility by default and ignore VMM writes

Sebastian

