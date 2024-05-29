Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3797815A863
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717002459; cv=none; b=eRPou3M7YVhkt+snsg3OAWYVwKGsJEL0eXi1RAhMFyFlFFi99jflGBX/Fg3irCKGG6RMYqX5ts2Xp2+6h85mAGNkC1ctkTlrFB69wnI4pcUjsjwEh5VEFEA6jxI6RxBspKALEReysocDJnvRMsBCAQIG7MLW2wxuD4CV0CH7r7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717002459; c=relaxed/simple;
	bh=FR8yYe75HWYrYeY/1bStScRCW8IABhMCe4gz0rDrl+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GxKC5KGVEfKJs3vVQYlJGbVPmXjVn1YZoK7iLsbPDS7FWsc5wt6e469axq85ny3tumBYfgwEmEO87B4Ew9wLN/5M4lxagDr0nDdKb2Xy2IBJ12DdixXuB0Bzu512OWYz+08LGsNKkQveQhrp8E1sueNHPw/YexI2H3D9LeoPYfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gUZ6A+kW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gUZ6A+kW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717002457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcsPFJDOY4WvNKS218Ds2wH8/diG1/Nx2QoDq1sbdEw=;
	b=gUZ6A+kWDJ7XfhZKienz82Zku0X9S9xIQUY4uQeBYvlDcmXoIvmANRR/tyFVMfL4a2l9Pn
	i6QUxBWnsor7A7phxjr7Si1Ze25m7uT8uvNpmyDt0WMoWtvq+9sTkoD+hxvF3GFbAgoxKQ
	cc/rq3SvR7ll7Ak14CqAiLFdiY9KU34=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-132eNLr6Naa0_nE4MnLZQg-1; Wed, 29 May 2024 13:07:35 -0400
X-MC-Unique: 132eNLr6Naa0_nE4MnLZQg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-794ab0a4c4cso279222885a.2
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 10:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717002455; x=1717607255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vcsPFJDOY4WvNKS218Ds2wH8/diG1/Nx2QoDq1sbdEw=;
        b=E1ggVg4sWX486OHOlTwdM8eUF8n2iUk03Qe7DomvySsankeLeukHAKavJ7dC2fOfpj
         G6zVdCwh8URgZIQj1sYQyCwr591s7Vy+8vQMCMFjaD3qU4U5J5DjV8zinC02abBZCNVt
         6JJfUHyK+H6MK99vXANYeoHbgE8cJwyQSRnB0nmJ25JNQ44ca3+7xPVcpIZ+brgZC6pI
         bbuHuW0MgGvhMUvexIp7y79HZ+h8aEJkLUcIDozG0qlI4cNO3gLGUWa/4V2B5Hk+LOYS
         obM3BFuFkVRSJ0+OPCw4i6Dw86rQHvq/7JQ7OlRdbV27FIakjJ7CvO4m5Fd5QZRX86cf
         tA1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHz6vNF+Pz/Sd4S9G6G3kxOktMqeiAYFzdEX98yOIc8l8uE+4sWbQxT3AVfNS5+r1itoaNw8wsPeeV2oAw96CFa8es9hBS
X-Gm-Message-State: AOJu0YymvsXtif7UVQqCJWKlx7d+iM6WPpubphcpfpca4cNRVEZFhx7W
	Ov3gqAMQqmshimOeIppZmfZ7W/3t/4H+9duxYa3xonM6Uduip2NE77p6aNxSJjpv65SBoBtkH93
	qgjQvvJXC/MaYLFppQOSg/ogR3Gw5GvgEVy9SQiEn77pNVXGC3mZlSw==
X-Received: by 2002:a05:620a:5dcb:b0:792:c524:c67a with SMTP id af79cd13be357-794ab053910mr1638680685a.2.1717002455160;
        Wed, 29 May 2024 10:07:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKjn8rn4gwlhs28dVyWvkBZLPmaJ15NOY/2o2GdYFzO6vL1OT/ySs4/cIF7RhqxM0QEP1QGQ==
X-Received: by 2002:a05:620a:5dcb:b0:792:c524:c67a with SMTP id af79cd13be357-794ab053910mr1638675385a.2.1717002454607;
        Wed, 29 May 2024 10:07:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-794db33d9f8sm107027885a.134.2024.05.29.10.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 10:07:34 -0700 (PDT)
Message-ID: <535bc49d-1b8c-4dae-8ee1-1b7815473524@redhat.com>
Date: Wed, 29 May 2024 19:07:31 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] KVM: selftests: arm64: Test writes to CTR_EL0
To: Sebastian Ott <sebott@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20240514072252.5657-1-sebott@redhat.com>
 <20240514072252.5657-7-sebott@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240514072252.5657-7-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/14/24 09:22, Sebastian Ott wrote:
> Test that CTR_EL0 is modifiable from userspace, that changes are
> visible to guests, and that they are preserved across a vCPU reset.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric


> ---
>  .../testing/selftests/kvm/aarch64/set_id_regs.c  | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> index a7de39fa2a0a..9583c04f1228 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -219,6 +219,7 @@ static void guest_code(void)
>  	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
> +	GUEST_REG_SYNC(SYS_CTR_EL0);
>  
>  	GUEST_DONE();
>  }
> @@ -490,11 +491,25 @@ static void test_clidr(struct kvm_vcpu *vcpu)
>  	test_reg_vals[encoding_to_range_idx(SYS_CLIDR_EL1)] = clidr;
>  }
>  
> +static void test_ctr(struct kvm_vcpu *vcpu)
> +{
> +	u64 ctr;
> +
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), &ctr);
> +	ctr &= ~CTR_EL0_DIC_MASK;
> +	if (ctr & CTR_EL0_IminLine_MASK)
> +		ctr--;
> +
> +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), ctr);
> +	test_reg_vals[encoding_to_range_idx(SYS_CTR_EL0)] = ctr;
> +}
> +
>  static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
>  	test_clidr(vcpu);
> +	test_ctr(vcpu);
>  
>  	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &val);
>  	val++;
> @@ -525,6 +540,7 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
>  		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg);
>  
>  	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
> +	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0);
>  
>  	ksft_test_result_pass("%s\n", __func__);
>  }

