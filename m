Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018591D86C0
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 02:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736130777; cv=none; b=Ia/mIl8uT9RpUeIjoMe/hoFmtXHjMRRgW5B8Qh6fwStYetSiphVBeK3eGuGfl0KyiNr3qF7JP9cFsECJxnZRuTb7QcRNyxG71ks46u4gTDm9HAx6HUaYxMmQVFzXGb+xZixl9a2kPOnXMI3rOPrkjNfQPgSwkEZwBmbYF5r5jEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736130777; c=relaxed/simple;
	bh=7qa+op98IAU4gbyEANPQ1kB+n62Hq0ZlDURcfnIZoXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4MZFzqJzbud7DXL15J6JWkaMEyW/s9CISJKoLDlEufKsQ8eDH2Sftl5bGcFtBNH4B1o3//38tz1gww0Z9adfc8fR6DwriMqBsczQqG+eOhT+v8xS8pRihis/ZccVD3wXz47O59GHYyP6qRiaxDuceR+zVntATPjpKJ8/VLBjCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=gOc4x+Ir; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="gOc4x+Ir"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f441904a42so20300031a91.1
        for <kvmarm@lists.linux.dev>; Sun, 05 Jan 2025 18:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1736130773; x=1736735573; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hizUyDaKTky7G883O428eVAJirBV+mTazBL7cmKBgjA=;
        b=gOc4x+IrW8JkJ1QRFFXMmFLcaUoU43SXS7mYEm41XFWNhsxmKYp2RDIwaM3ep7UMMV
         PaTk8Arn74uGQwUUsUDHdJe495ddSLrDILgcY9Db/c9KIOMOjQ3rRPeqncIBS+pc8u1t
         Whx3CBpph8ZGBfcUaGHP7rNF7SCVo8jy5X+O16I7aqbbZXZoIcZpf+Vn23iyck9ppeW3
         q9jsghRXqYfDRb68LLEoLMkL9sfKppzxTRIsiOdw4zWwXMxTRBPD2viUYFDiM89Rt1R9
         npb4azTEzIlFv56MMQXoWMC3RzUx52yEBcfo+g/SNV2vf5V8rPrBosq5F86yC7QktTE2
         doLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736130773; x=1736735573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hizUyDaKTky7G883O428eVAJirBV+mTazBL7cmKBgjA=;
        b=d2wXkJIN955Bezpr/qfnZZJYyt3EHvUYDY3CX2eoWhtjMVFVFHjiypnBAMdvbh9AdE
         8ULXzTrF3JQinexDt9szVbLmas8CQelkNSc4LhQfvebxdbG/+9TQ2GOZIY6wyVxEdbmQ
         XT7SNH7DF4vFKkXyQejyS2qjNpMA2+oiY6L5Y4TUkv7TSbrzpjTk61wTHC8M2Hv8QS99
         f4INDlve9anJs7rFI9OntGb5c4JSUnY+go45ZrvsCZsxqlzIANtYm8XIXsRoXt71DVA6
         filAOFxWzmAp/PtMMmCpMXDHdQAjXydBy/z2e/oX2qE4qm+zCwLYVp0QCMbx2PnUDTjK
         WURQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsmhtl3QOQsJyObcLahT7niegofr91mkF9C2lkz26YrFtFp2oJEdByjObvjLmjeJfWr8Bu3Xs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzH5o0mPA3j2EwSXIBz5SBepmbZeRtJ1LqCqvJj5bW0xNNprfXn
	su4k5LDZCTvNpStHR4jY1x9Bj4O8F3j90Oek4uBLBaSpWcKecGYUYVeLkBnpObK4N0mVWldLcMd
	xvIW6onv4V+Q0qMbFPwVV8BFahpxeCtHSIJjM2YBhHX+Htzc=
X-Gm-Gg: ASbGncuHpI0sUXgZMNkBGV5Cjoizzx9m1n6KLuFHra/gWdVyGaVxkNfTbgom+ya0r4p
	TzBBGiG89QuJg7JGY+qm5bBjas3UwIamQz8wFIBmj0Q4vfJTJW/qjyclOCleGWXIGtJ4DbQsWtG
	5a9WjtTp248ovNwiHJjnniW+bpO/0xQgOgcX3BBa5+GU3R3J9XFzVEKAViLcTg5OvpW/DwpxgU+
	w/xArkBkqDRAV/U0hShW3PymWTn4JYbCpVOCrkMIjpAZTbU4h/BexngRcXkjUgjDAJb4lRv8Xzo
	CVo+Hd6bBtSioM7tJvM=
X-Google-Smtp-Source: AGHT+IFlKEWP1PZp3HGGHASjNs+dk5FEFAFR9mW7wibwp+bi2To37zelGhRWfoPjkS8UwpaDLhX/vg==
X-Received: by 2002:a17:90a:d647:b0:2ee:c9dd:b7ea with SMTP id 98e67ed59e1d1-2f452eb12famr84759397a91.24.1736130773115;
        Sun, 05 Jan 2025 18:32:53 -0800 (PST)
Received: from zenbook (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4478a9108sm36139009a91.43.2025.01.05.18.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 18:32:52 -0800 (PST)
Date: Mon, 6 Jan 2025 10:33:39 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Bjorn Andersson <andersson@kernel.org>, 
	Christoffer Dall <christoffer.dall@arm.com>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Chase Conklin <chase.conklin@arm.com>, Eric Auger <eauger@redhat.com>, r09922117@csie.ntu.edu.tw
Subject: Re: [PATCH v2 09/12] KVM: arm64: nv: Propagate
 CNTHCTL_EL2.EL1NV{P,V}CT bits
Message-ID: <qbmqsm3llnpy2t4ig3uyggkapwlbox2wnfu52gksbhcq4vfpqx@dz5bbn3asn5s>
References: <20241217142321.763801-1-maz@kernel.org>
 <20241217142321.763801-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217142321.763801-10-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi Marc and other KVM ARM developers,

I have a question while learning about NV and reading the code:

On Tue, Dec 17, 2024 at 02:23:17PM +0000, Marc Zyngier wrote:
> Allow a guest hypervisor to trap accesses to CNT{P,V}CT_EL02 by
> propagating these trap bits to the host trap configuration.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 6f04f31c0a7f2..e5951e6eaf236 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -824,6 +824,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
>  	 * Apply the enable bits that the guest hypervisor has requested for
>  	 * its own guest. We can only add traps that wouldn't have been set
>  	 * above.
> +	 * Implementation choices: we do not support NV when E2H=0 in the
> +	 * guest, and we don't support configuration where E2H is writable
> +	 * by the guest (either FEAT_VHE or FEAT_E2H0 is implemented, but
> +	 * not both). This simplifies the handling of the EL1NV* bits.

Previously I was not aware that KVM ARM has these constraints on guest's
view of NV and E2H, so I appreciate this comment very much. However,
after digging through the code I could not find anywhere where these
constraints are enforced, for example initially I thought I would find
ID_AA64MMFR2_EL1_NV being zeroed in limit_nv_id_regs(), or HCR_NV added
to the res0 mask of HCR_EL2, base on whether FEAT_VHE or FEAT_E2H0 is
available to the guest. But seems like in these places the code applies
constraints looking at the host's capabilities, not the guest's.
Do you mind providing some pointers for me to investigate the code mode?

Thank you so much, I'd appreciate any help.

Wei-Lin Chang

>  	 */
>  	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
>  		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
> @@ -834,6 +838,9 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
>  
>  		tpt |= !(val & (CNTHCTL_EL1PCEN << 10));
>  		tpc |= !(val & (CNTHCTL_EL1PCTEN << 10));
> +
> +		tpt02 |= (val & CNTHCTL_EL1NVPCT);
> +		tvt02 |= (val & CNTHCTL_EL1NVVCT);
>  	}
>  
>  	/*
> -- 
> 2.39.2
> 
