Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9EDBA3C
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EjWRMk+7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697122926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jKaXXBt2+qIaeU2ajxDNKYR9u7kL2ReXZiI2k8PWqRI=;
	b=EjWRMk+7ud3Q2w3uopMVDrSC0fkVB7FAfwt7wJ8GDjVhoLWNDU6luJOQHKlehD2JLFl8aF
	wzKx6ZcyuzlKh0SpvV6Xauyk6wg5MesFYKXrkmz9ef/eHga/DNCy8cFf+3WEjcKEryWloF
	xaUbhSlmIjIfxsSAEChulNoziHCnKfM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-6TP5iVPEOEO-P7TBCjMLpA-1; Thu, 12 Oct 2023 11:02:02 -0400
X-MC-Unique: 6TP5iVPEOEO-P7TBCjMLpA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-668f04867deso11813056d6.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 08:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697122922; x=1697727722;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NqKWWi4N1dQcUV0pCxNw2tgDBfyOJnn+/IdI3vL5BCQ=;
        b=a6h5sh7S1b/LyJ5HRhpkQpdPF0yg4KSb8qjBfNUTa0iGluSuxeOemdP33Qaw49WOsI
         FxzXETquGdotpNemNDBEbTS2RKHmWhbXu6kS8PegSIZbDzGfLndSu7gGyJ0fhdFt5Ujt
         GSAjGzJKfuDoVdX6N07SlYzhJGz8ju65aumebsowmPYNIMQujAX4Esuukd+ysADvbRih
         KGZ+xPLV0MLgUopexYjVbW+jVdo587DfvH5EG7tZuW7JmqEfib3FTEc+ZqxH6XQLkUrF
         YKfue7p6adDvK6QSfzT96VoU6D3r6kJCQpFdu3SXtcqp9Z5dFEEVpj5p+00pjbRhV4Xz
         rFzA==
X-Gm-Message-State: AOJu0YxQlWJkX2i9SVbUod305PH107hDLCk/73d25wH9jCodN9Q9Zq4U
	0xdP59h+w1ncYgFuaq7cnI4iGSzN4kDuHJoJjZxaXSq2uNvCfTCAuovwy9K5ewFIaQMSjNniJmV
	TAd23Rq/cqsXpZ6Oi
X-Received: by 2002:a05:6214:5b03:b0:65d:1265:48c5 with SMTP id ma3-20020a0562145b0300b0065d126548c5mr25316333qvb.33.1697122921961;
        Thu, 12 Oct 2023 08:02:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjRHnSSwx/haWRgrBki1YsFkWJjXmdjCoMi0wMoPVGd/LNcVTz7v5WLv1JGQct9yRT+ZM1Mw==
X-Received: by 2002:a05:6214:5b03:b0:65d:1265:48c5 with SMTP id ma3-20020a0562145b0300b0065d126548c5mr25316134qvb.33.1697122919236;
        Thu, 12 Oct 2023 08:01:59 -0700 (PDT)
Received: from rh (p200300c93f266600211746b64b43cdf8.dip0.t-ipconnect.de. [2003:c9:3f26:6600:2117:46b6:4b43:cdf8])
        by smtp.gmail.com with ESMTPSA id o15-20020a0cfa8f000000b0066cfbe4e0f4sm2140112qvn.26.2023.10.12.08.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 08:01:58 -0700 (PDT)
Date: Thu, 12 Oct 2023 17:01:54 +0200 (CEST)
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
In-Reply-To: <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com>
Message-ID: <65b8bbdb-2187-3c85-0e5d-24befcf01333@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com> <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463795790-346822177-1697122918=:6347"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463795790-346822177-1697122918=:6347
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 12 Oct 2023, Sebastian Ott wrote:
> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
>>  +/* Create a VM that has one vCPU with PMUv3 configured. */
>>  +static void create_vpmu_vm(void *guest_code)
>>  +{
>>  +	struct kvm_vcpu_init init;
>>  +	uint8_t pmuver, ec;
>>  +	uint64_t dfr0, irq = 23;
>>  +	struct kvm_device_attr irq_attr = {
>>  +		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
>>  +		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
>>  +		.addr = (uint64_t)&irq,
>>  +	};
>>  +	struct kvm_device_attr init_attr = {
>>  +		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
>>  +		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
>>  +	};
>>  +
>>  +	/* The test creates the vpmu_vm multiple times. Ensure a clean state
>>  */
>>  +	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
>>  +
>>  +	vpmu_vm.vm = vm_create(1);
>>  +	vm_init_descriptor_tables(vpmu_vm.vm);
>>  +	for (ec = 0; ec < ESR_EC_NUM; ec++) {
>>  +		vm_install_sync_handler(vpmu_vm.vm, VECTOR_SYNC_CURRENT, ec,
>>  +					guest_sync_handler);
>>  +	}
>>  +
>>  +	/* Create vCPU with PMUv3 */
>>  +	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
>>  +	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
>>  +	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
>>  +	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
>>  +	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
>>  +					GICD_BASE_GPA, GICR_BASE_GPA);
>>  +
>>  +	/* Make sure that PMUv3 support is indicated in the ID register */
>>  +	vcpu_get_reg(vpmu_vm.vcpu,
>>  +		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
>>  +	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
>>  +	TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
>>  +		    pmuver >= ID_AA64DFR0_PMUVER_8_0,
>>  +		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3",
>>  pmuver);
>>  +
>>  +	/* Initialize vPMU */
>>  +	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
>>  +	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
>>  +}
>
> This one fails to build for me:
> aarch64/vpmu_counter_access.c: In function ¡create_vpmu_vm¢:
> aarch64/vpmu_counter_access.c:456:47: error: ¡ID_AA64DFR0_PMUVER_MASK¢ 
> undeclared (first use in this function); did you mean 
> ¡ID_AA64DFR0_EL1_PMUVer_MASK¢?
>   456 |         pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
>   dfr0);

Looks like there's a clash with
"KVM: arm64: selftests: Import automatic generation of sysreg defs"
from:
 	https://lore.kernel.org/r/20231003230408.3405722-12-oliver.upton@linux.dev
---1463795790-346822177-1697122918=:6347--

