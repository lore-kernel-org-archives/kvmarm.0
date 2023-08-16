Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B721840
	for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 06:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692169099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=coMx+qrk3+nAFJq/8MLLAKSoS+skVzUmoa64bBG+3v8=;
	b=DK1bTv5j0PmS/Z/f3eitGYNzUnW6Gb7+dHVxM3oYmJUPFwGwmeJ7u0NpuYGSf3LV3kKGrN
	0n4QcoygYKp0I040nShANji/dzWL/1tEcpmFf9Yr2lkFlYkYYeIe+WPxuapzQ52cBBJgA3
	2FIG4XbdbMe+WHB47xB7FkXyxmg6DWU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-Pa9lsJWsMEGGcKuZi2P0FQ-1; Wed, 16 Aug 2023 02:58:18 -0400
X-MC-Unique: Pa9lsJWsMEGGcKuZi2P0FQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1bd9e1c9575so11563855ad.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 23:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692169097; x=1692773897;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=coMx+qrk3+nAFJq/8MLLAKSoS+skVzUmoa64bBG+3v8=;
        b=SaZs6Ar3dlc+jvik/w2ZRzkQ6wkqNS6w6DMaLEvfWrcDArYy/emZxxY/2cN6ZZ1k64
         APTl2fxyrm8Au5RdV93WakIPAAbd2lxOFlLLukunTn8iFd9fmgBxupNZRv8C029gzvqh
         oHtnO+I+DWH/PsNu6OwvVkyPVIH4PQv3n5TzKmGzcRLAmmkGiZ3fJ4HKgV6hBCD15zh9
         51El9CIKqhsDmD1qYeUGwKzmy3AX2iJUFuFbeBb6QkOVSKc5fS1niieO+DuYG0GS4vUq
         A4JcORJAucx5+vAFmW42YAmzkVvTrxr2geMC+VUOmGxL88A8sqhCsgBviJZkfusOIWA/
         LkAQ==
X-Gm-Message-State: AOJu0YxE9q+Y+S3ZUu29G4+Q6ZUbtN1ISm9LXvEz3EG5srPeX5tLXlu8
	+PjafrYK3MmvtFCGu2mLYctxycU/ieEoia3d02/BHGiRMGxzfXikGXZub6Bu05+dQRsDNFggYAe
	a6OAgmXySXEMXb5IU
X-Received: by 2002:a17:902:d2c1:b0:1bb:9e6e:a9f3 with SMTP id n1-20020a170902d2c100b001bb9e6ea9f3mr1275661plc.4.1692169097047;
        Tue, 15 Aug 2023 23:58:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkQ6TEk2n+Vw3400DfBNV4tQEKHqCod2o55k2tbJS/5J/3qoq6lE5clV2Y5xNar/cYRPaAng==
X-Received: by 2002:a17:902:d2c1:b0:1bb:9e6e:a9f3 with SMTP id n1-20020a170902d2c100b001bb9e6ea9f3mr1275646plc.4.1692169096760;
        Tue, 15 Aug 2023 23:58:16 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b001bb9bc8d232sm12229560plg.61.2023.08.15.23.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 23:58:16 -0700 (PDT)
Message-ID: <268054f7-e2f5-37fb-187c-3b2cca41b31a@redhat.com>
Date: Wed, 16 Aug 2023 14:58:11 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 11/11] KVM: arm64: selftests: Test for setting ID
 register from usersapce
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.linux.dev>,
 ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>,
 Reiji Watanabe <reijiw@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-12-jingzhangos@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230807162210.2528230-12-jingzhangos@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jing,

On 8/8/23 00:22, Jing Zhang wrote:
> Add tests to verify setting ID registers from userapce is handled
> correctly by KVM. Also add a test case to use ioctl
> KVM_ARM_GET_REG_WRITABLE_MASKS to get writable masks.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/aarch64/set_id_regs.c       | 453 ++++++++++++++++++
>   2 files changed, 454 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
> 
> +
> +static void test_guest_reg_read(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +	bool done = false;
> +
> +	while (!done) {
> +		vcpu_run(vcpu);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_SYNC:
> +			uint64_t val;
aarch64/set_id_regs.c:408:4: error: a label can only be part of a 
statement and a declaration is not a statement.

I can encounter a compiler error at this line. Why not just put the 
uint64_t at the beginning of the function.

Thanks,
Shaoqin

> +
> +			/* Make sure the written values are seen by guest */
> +			vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(uc.args[2]), &val);
> +			ASSERT_EQ(val, uc.args[3]);
> +			break;
> +		case UCALL_DONE:
> +			done = true;
> +			break;
> +		default:
> +			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> +		}
> +	}
> +}
> +
> +int main(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	bool aarch64_only;
> +	uint64_t val, el0;
> +	int ftr_cnt;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	/* Check for AARCH64 only system */
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> +	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
> +	aarch64_only = (el0 == ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
> +
> +	ksft_print_header();
> +
> +	ftr_cnt = ARRAY_SIZE(ftr_id_aa64dfr0_el1) + ARRAY_SIZE(ftr_id_dfr0_el1)
> +		  + ARRAY_SIZE(ftr_id_aa64pfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr0_el1)
> +		  + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr2_el1)
> +		  + ARRAY_SIZE(ftr_id_aa64mmfr3_el1) - ARRAY_SIZE(test_regs);
> +
> +	ksft_set_plan(ftr_cnt);
> +
> +	test_user_set_reg(vcpu, aarch64_only);
> +	test_guest_reg_read(vcpu);
> +
> +	kvm_vm_free(vm);
> +
> +	ksft_finished();
> +}

-- 
Shaoqin

