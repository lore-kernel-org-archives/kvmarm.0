Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0073327EEC
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wn3mhE0H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697463346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yy1/cgxKgJiMUa1SJT7ozjNtxww425JfDJ39NondDok=;
	b=Wn3mhE0H5lCgsOHX46WCsSd2EWNgKldcKr/hn+qbe8F5m7nNk29PlDol4n4Y8AMYu3cnLt
	rBjIeRsuLyNvO4bvfmGsm4+CyBR1d8MkssQTQUpuv1CFrG2ZfjRRtDlHOqGW6ZrHER94XU
	kdfIN+atm7hyFDE6eul/i+f/nFOrjrQ=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-wlfQlKXYP0Ccy3mtbYxuUg-1; Mon, 16 Oct 2023 09:35:44 -0400
X-MC-Unique: wlfQlKXYP0Ccy3mtbYxuUg-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3b2b1ade9deso5233876b6e.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 06:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697463343; x=1698068143;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yy1/cgxKgJiMUa1SJT7ozjNtxww425JfDJ39NondDok=;
        b=LRyQPr5R6SqrVcI0PgDfK9ocAL+YJdKWl4M642ZBYB5RJtlrkrIJWBOHUzHd1rx7HE
         IOwPYY5q53xwdDtrnJOJg2HR0P8e87kZM+fIm9uFxuTancFH7sSU8CBxyCC8CWf/xaGp
         w0GTEiQR5groIwScHXR0P1QITtDp2Px/ivR9B+YC8IF8qonhLnsPC1T6vL2CDx3sSGNm
         u0uzVNVNB7v/MfCYJnqzvP+zeWtiq6Qapk5pKmYzeuFUdAZ6U9Ck0YLEtLXfPDVWJ/bF
         +6XCbl/HmnS3vVg0iHJS4qjvRXAAGMrp8xJzKAK0k6KRzNXGN8zYeIjCa75CZwGTfmZi
         oUSg==
X-Gm-Message-State: AOJu0YwwBVOMFWJnzSdTNexRTMH7sbSCeweUwDFxZ2+RibRfHDR4rBv+
	JihjWSsnfWjyedbgKSm/mHGLHEXEiT990x7DJRvJH4udFGPcHkG4ywMqFnTu/UH9CweRSpR5rsB
	KYwXUQoGcFNXtb6zTzPEGkDAIAas=
X-Received: by 2002:a05:6808:2112:b0:3af:6634:49b9 with SMTP id r18-20020a056808211200b003af663449b9mr45234731oiw.30.1697463343618;
        Mon, 16 Oct 2023 06:35:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE77paMQjv1E0tWECLik6rtZ5xsUdcoZNEFSPtcpxvsM02M0fanwTqgfdfIspb/jqxNklUPGQ==
X-Received: by 2002:a05:6808:2112:b0:3af:6634:49b9 with SMTP id r18-20020a056808211200b003af663449b9mr45234711oiw.30.1697463343313;
        Mon, 16 Oct 2023 06:35:43 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id dl15-20020ad44e0f000000b0066d1540f9ecsm3437870qvb.77.2023.10.16.06.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 06:35:43 -0700 (PDT)
Date: Mon, 16 Oct 2023 15:35:38 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
    Alexandru Elisei <alexandru.elisei@arm.com>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
    Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
    Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
In-Reply-To: <20231009230858.3444834-8-rananta@google.com>
Message-ID: <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> {
> -	return __vcpu_sys_reg(vcpu, PMCR_EL0);
> +	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0) &
> +			~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> +
> +	return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ff0f7095eaca..c750722fbe4a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> {
> 	u64 pmcr;
>
> -	/* No PMU available, PMCR_EL0 may UNDEF... */
> -	if (!kvm_arm_support_pmu_v3())
> -		return 0;
> -
> 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> -	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> +	pmcr = kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);

pmcr = ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
Would that maybe make it more clear what is done here?

