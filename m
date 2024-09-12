Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE61922EE
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726134077; cv=none; b=mQqyo+O5nLHpfZLCncUR8I3zV2pyLnlkJZC6zQ4Ru6MHggtpdxI9WxfetZbIVC251moEeDHqH9acxoukIJAb92ky5M58srdgftzQEH/ieRZmFylMuLqCmKwsLfG8ZiBtEt4hwX0rWK5RGMRhhzmewxAWZiwVFr7QQnAJyuepcBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726134077; c=relaxed/simple;
	bh=j4p7rekU9XpaxoYQxOygTZbro1GDTOZAkbJ5AtXBJiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWKynibO/w81XXFk3BOs7PJD1ipucwPxHqyyZcFktKhJz6ivxo/W240qOsKkg+L6EKroBCe/vsgCAYGaeGerHVvLzHnChiG07JVdlOxbhYAK7TtzfXOHQL7hjlAa7MxxGLLVFWPP7bLCdEffJjGgJ16aVmPhIVEYgTyXbzPsZ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SX9wgmNe; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SX9wgmNe"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53659867cbdso1057966e87.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 02:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726134073; x=1726738873; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aiemgFzmdlVArSRtl/VBHqqgaU54TtFT6LBWQAz3Kr8=;
        b=SX9wgmNeReb7qOp/9sD5Xjza59b2EyHR3jYpfqLmnSBozRbtX4JFwuRleFGD4ePGoT
         3ZleL+9VS90/8pKMEnOfIVRroKzNyJabvDgk+KyS5WSu0cYNjjcl4570ZRQoWxYLV7au
         ZZsOSaEsVF6jYWenDmKgD+I8NyVdXiH200i994vHTGdVpLwMIt/y/ttv48raW/VLlfJG
         KKGz3iOCdFZwEDjLIcdUuClZrum2vARm3j2kBH+K59O7xdvqMit3YHU9DDqNPUO2/8u/
         NlTOg7R7jDg872+fCWVOVZk8qDDLuk3rorLMPZomsPU3SBSCBdpZVvdXyyjPMQqf/XKj
         AFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726134073; x=1726738873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiemgFzmdlVArSRtl/VBHqqgaU54TtFT6LBWQAz3Kr8=;
        b=N/6ANRCWtEH+JsQOz/RBhvXis8Sr8BZb0jitGvX3u+YXgX47p6A0AbpPCKAEl0LtwW
         j5MceDkA7sv3fOJkAgLfippkKYV5GwI3cI2gXrE7RG2AJE81HzOCJxTSzh46HBYjpstc
         VR6OjIP64eKDMI9ovEf7fr5NVWU9hiKPAwPOwy15MfrZv+a16UB3sc13H000ktGtqJfs
         O4s77PAowU46/WGU2hiYqUjPyoeE0i72MS4rb/cGaUGL2CkqoA3nIxKJA8d0mutMmU0F
         cx5+Yk2aG/S9H569d3pw/KgRr2Yw6UC0WToZMRgOCV/uc3dohdEz9WVpecAjoR/SgZ6X
         /g8A==
X-Forwarded-Encrypted: i=1; AJvYcCXx2XlMooO1s2bPKut1I3TE3MX6+cdQwEjksSUP/I2GqqqANwS+/T4qUBswKyB/Ad9EygbvuNQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs03OXsLGwohTQXizWY3TaFENNkIDVTZA5Wp5VzW2RgjMd0hC5
	esrpfs8Fohn53IfLz55+AyMXUvBiR6LJ/CZ40HdNyYTsmUKzrBkXsCRNGR7C+gM=
X-Google-Smtp-Source: AGHT+IE8hrIDE8jMWqmlxIeW/6mf22/C3WP/B4LyK9EfIJcAxDLa0UZEL1XXRZvbqP4WfQWiTVCnKg==
X-Received: by 2002:a05:6512:31d3:b0:536:5509:8857 with SMTP id 2adb3069b0e04-53678fb7196mr1697881e87.21.1726134072038;
        Thu, 12 Sep 2024 02:41:12 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72757sm721848266b.103.2024.09.12.02.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 02:41:11 -0700 (PDT)
Date: Thu, 12 Sep 2024 11:41:10 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Subject: Re: [PATCH v2 04/13] KVM: selftests: Assert that vcpu_{g,s}et_reg()
 won't truncate
Message-ID: <20240912-75f992936cd9878d0e507498@orel>
References: <20240911204158.2034295-1-seanjc@google.com>
 <20240911204158.2034295-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911204158.2034295-5-seanjc@google.com>

On Wed, Sep 11, 2024 at 01:41:49PM GMT, Sean Christopherson wrote:
> Assert that the the register being read/written by vcpu_{g,s}et_reg() is
> no larger than a uint64_t, i.e. that a selftest isn't unintentionally
> truncating the value being read/written.
> 
> Ideally, the assert would be done at compile-time, but that would limit
> the checks to hardcoded accesses and/or require fancier compile-time
> assertion infrastructure to filter out dynamic usage.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 429a7f003fe3..80230e49e35f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -683,6 +683,8 @@ static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
>  	uint64_t val;
>  	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
>  
> +	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
> +
>  	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
>  	return val;
>  }
> @@ -690,6 +692,8 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val
>  {
>  	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
>  
> +	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
> +
>  	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
>  }
>  
> -- 
> 2.46.0.598.g6f2099f65c-goog
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Shouldn't patches 3 and 4 come before patch 2 in this series?

Thanks,
drew
