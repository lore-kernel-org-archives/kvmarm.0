Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBA443AB3
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 15:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mudzlkr3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697557704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rakr0vS7xpMkHkymSTKEpL4VGLpPuEArnF01cq9l1Gs=;
	b=Mudzlkr3uG4CcToWj4af3bfI1u7v93DIsTw9ItnWDFcfhV/Kx2t6vVAQNHz8CJsHZK77QB
	nv8daDyHI96ayQnsU1eG/g2d4DmaYLdW+ajJMwPxG/jEg84bMFfqasp13rKjtdYBQZkD8b
	0yBPhMnKKj5Tm0vmy9eYVCFEheL3oH4=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-kh2TNfA0MkmtIs2zA918Kg-1; Tue, 17 Oct 2023 11:48:16 -0400
X-MC-Unique: kh2TNfA0MkmtIs2zA918Kg-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3b2a6655ee2so8903388b6e.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 08:48:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697557696; x=1698162496;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rakr0vS7xpMkHkymSTKEpL4VGLpPuEArnF01cq9l1Gs=;
        b=hLH35IEU1DSsw8iP9/yikLO6fDy5BohU5S8AvdLrFf7jyzfF4CdLkADj/bYJcOKdtH
         aGbY0RusF4Un14K/XlKOjJFKwQVPtiYHEFctxTyyzDdXfjoPhFB2VteEO5wjIq9aLQ+d
         VfvqnvTLtXnxU9O5HrSQCOxeoS1mpRN7iNCSXgqRucyWV6v9GExu5EWQj+AAJkjxk9AR
         dr57QqcaLGP56cWPhQ2CJCd8rxMwErOceQ7ueQueaI3fq2aexEQ3TF9T5s2v+UFa4Gr8
         xDgu36RDBV2S4qaYBXFu2wAUPNMoxn4gXmBHJwTMq5ZO/KNLw6Oo82IGgLUsMYF93aF7
         ksdw==
X-Gm-Message-State: AOJu0YxFVMze26vQX1o/zU5Ixx55UKp9QieW/2XZhaNG6VTdJEj2TxYt
	gpcGh839RZSSf+iS8EIfUjb1QPb4+8g/L2fk5tqTK+pVI5I1wVYlBH+LhiBJUlyHtGkAOXNOA7n
	pv5Js9wm+O+ltLH15
X-Received: by 2002:a05:6808:178e:b0:3af:9851:4d32 with SMTP id bg14-20020a056808178e00b003af98514d32mr3308988oib.7.1697557696069;
        Tue, 17 Oct 2023 08:48:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj5Zx5Gy8DmigS+K6YA2nZSBjYa71w34REhv1lOtWsOhC2mMlp35j9iNTJ82axlaS6tHkBcQ==
X-Received: by 2002:a05:6808:178e:b0:3af:9851:4d32 with SMTP id bg14-20020a056808178e00b003af98514d32mr3308965oib.7.1697557695835;
        Tue, 17 Oct 2023 08:48:15 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id x11-20020a0cfe0b000000b0065b1f90ff8csm653839qvr.40.2023.10.17.08.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 08:48:15 -0700 (PDT)
Date: Tue, 17 Oct 2023 17:48:11 +0200 (CEST)
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
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce vpmu_counter_access
 test
In-Reply-To: <20231009230858.3444834-11-rananta@google.com>
Message-ID: <e0fdb0ea-2f08-6343-1765-afe32510f3a7@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com>
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
> +static void guest_code(uint64_t expected_pmcr_n)
> +{
> +	uint64_t pmcr, pmcr_n;
> +
> +	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
> +			"Expected PMCR.N: 0x%lx; ARMv8 general counters: 0x%lx",
> +			expected_pmcr_n, ARMV8_PMU_MAX_GENERAL_COUNTERS);
> +
> +	pmcr = read_sysreg(pmcr_el0);
> +	pmcr_n = get_pmcr_n(pmcr);
> +
> +	/* Make sure that PMCR_EL0.N indicates the value userspace set */
> +	__GUEST_ASSERT(pmcr_n == expected_pmcr_n,
> +			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
> +			pmcr_n, expected_pmcr_n);

Expected vs read value is swapped.


Also, since the kernel has special handling for this, should we add a
test like below?

+static void immutable_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	uint64_t sp, pmcr, pmcr_n;
+	struct kvm_vcpu_init init;
+
+	create_vpmu_vm(guest_code);
+
+	vcpu = vpmu_vm.vcpu;
+
+	/* Save the initial sp to restore them later to run the guest again */
+	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	pmcr_n = get_pmcr_n(pmcr);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	aarch64_vcpu_setup(vcpu, &init);
+	vcpu_init_descriptor_tables(vcpu);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+
+	/* Update the PMCR_EL0.N after the VM ran once */
+	set_pmcr_n(&pmcr, 0);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
+
+	/* Verify that the guest still gets the unmodified value */
+	run_vcpu(vcpu, pmcr_n);
+
+	destroy_vpmu_vm();
+}

