Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70391CF8D
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 10:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YWhzyIOy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697450519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OuEOcL2qbq7eVck3MGPHSrjZwbWdqBjY6QVxzyLw4GU=;
	b=YWhzyIOyznHlzGi6dGO2tbwOABUoXe3f16LczUs2FPmBmf+Qmc79+Xyxwgpc5GIyQ0ftu8
	04i7X8r2I4xrRZm9B262/A60ak7Jh1SqWXckJ+fBiPEB/qTFghdPvzHoS5xzM66rlHqNU8
	KlebEUhE3C7Fo2RI7/t6TxZSBBxs5vw=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-5aJ3B6smOeC2f36hGdQYKA-1; Mon, 16 Oct 2023 06:01:53 -0400
X-MC-Unique: 5aJ3B6smOeC2f36hGdQYKA-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-457c7e76d30so1212847137.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 03:01:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697450512; x=1698055312;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Rvdf5GF7NssmVrOVN5fIpBg7Q/eJJlAGQ4ASt6ni/o=;
        b=IpDcxGF3mZvHLUyVIMXehPzKSOtpKcwXBTlSft9CZ3N0HME1CtAagciHRxSfApouJe
         7m1vL4UvVHthnBcUckJgUI31GyNgGexqFRJINFPNqcFz/+NSxRTLc8VLpaJw6ze3k6Pl
         i4G5wm9kRPhq4esUiuOGaD1c8CWP4qW8bhSFkUJ5Zaj1CB4iioa6b3LVRAd3//Fsx3nF
         hj/43glcLMoJ/aNtlDzVXRpvnWQJKgFYzawe6ovoUVaKylMa5yIzp6S9y8LjOImGZd0h
         jvh/54o4E+bjuTqjcgLhDc4cFeRooMGWG6zJFQ/mCbpRsqxovolJupwUAwtEmBbLGwa6
         4UPA==
X-Gm-Message-State: AOJu0YxpTJFbDElvIFJuhVEa7UmyIY5UpEafc3Pj82s037zL+4dF735T
	PdF+p4cU2DPPXROkHJWcNbk0QQvS8XMFxQ1xmqWKeVb+WW5cK2FkERBzmMY66sv5NVzb/fqefQD
	E+BGbioQcVY0UXf0T
X-Received: by 2002:a05:6102:1250:b0:458:16ac:bcad with SMTP id p16-20020a056102125000b0045816acbcadmr77253vsg.32.1697450512552;
        Mon, 16 Oct 2023 03:01:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6harqCGifXrM0+4AN5WIM0FRUrWBf8RWML7HaIo1VltVJ/nTSF6hWksPJbMyBcx5ZRlWB+Q==
X-Received: by 2002:a05:6102:1250:b0:458:16ac:bcad with SMTP id p16-20020a056102125000b0045816acbcadmr77235vsg.32.1697450512287;
        Mon, 16 Oct 2023 03:01:52 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id h4-20020ac87444000000b004179e79069asm2890615qtr.21.2023.10.16.03.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 03:01:52 -0700 (PDT)
Date: Mon, 16 Oct 2023 12:01:48 +0200 (CEST)
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
In-Reply-To: <CAJHc60zPc6eM+t7pOM19aKbf_9cMvj_LnPnG1EO35=EP0jG+Tg@mail.gmail.com>
Message-ID: <2714abd6-40a4-17f8-e997-843bc69d9319@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com> <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com> <65b8bbdb-2187-3c85-0e5d-24befcf01333@redhat.com>
 <CAJHc60zPc6eM+t7pOM19aKbf_9cMvj_LnPnG1EO35=EP0jG+Tg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463795790-956281928-1697450511=:6267"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463795790-956281928-1697450511=:6267
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 13 Oct 2023, Raghavendra Rao Ananta wrote:
> On Thu, Oct 12, 2023 at 8:02 AM Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Thu, 12 Oct 2023, Sebastian Ott wrote:
>>> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
>>>>  +/* Create a VM that has one vCPU with PMUv3 configured. */
>>>>  +static void create_vpmu_vm(void *guest_code)
>>>>  +{
>>>>  +   struct kvm_vcpu_init init;
>>>>  +   uint8_t pmuver, ec;
>>>>  +   uint64_t dfr0, irq = 23;
>>>>  +   struct kvm_device_attr irq_attr = {
>>>>  +           .group = KVM_ARM_VCPU_PMU_V3_CTRL,
>>>>  +           .attr = KVM_ARM_VCPU_PMU_V3_IRQ,
>>>>  +           .addr = (uint64_t)&irq,
>>>>  +   };
>>>>  +   struct kvm_device_attr init_attr = {
>>>>  +           .group = KVM_ARM_VCPU_PMU_V3_CTRL,
>>>>  +           .attr = KVM_ARM_VCPU_PMU_V3_INIT,
>>>>  +   };
>>>>  +
>>>>  +   /* The test creates the vpmu_vm multiple times. Ensure a clean state
>>>>  */
>>>>  +   memset(&vpmu_vm, 0, sizeof(vpmu_vm));
>>>>  +
>>>>  +   vpmu_vm.vm = vm_create(1);
>>>>  +   vm_init_descriptor_tables(vpmu_vm.vm);
>>>>  +   for (ec = 0; ec < ESR_EC_NUM; ec++) {
>>>>  +           vm_install_sync_handler(vpmu_vm.vm, VECTOR_SYNC_CURRENT, ec,
>>>>  +                                   guest_sync_handler);
>>>>  +   }
>>>>  +
>>>>  +   /* Create vCPU with PMUv3 */
>>>>  +   vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
>>>>  +   init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
>>>>  +   vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
>>>>  +   vcpu_init_descriptor_tables(vpmu_vm.vcpu);
>>>>  +   vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
>>>>  +                                   GICD_BASE_GPA, GICR_BASE_GPA);
>>>>  +
>>>>  +   /* Make sure that PMUv3 support is indicated in the ID register */
>>>>  +   vcpu_get_reg(vpmu_vm.vcpu,
>>>>  +                KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
>>>>  +   pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
>>>>  +   TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
>>>>  +               pmuver >= ID_AA64DFR0_PMUVER_8_0,
>>>>  +               "Unexpected PMUVER (0x%x) on the vCPU with PMUv3",
>>>>  pmuver);
>>>>  +
>>>>  +   /* Initialize vPMU */
>>>>  +   vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
>>>>  +   vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
>>>>  +}
>>>
>>> This one fails to build for me:
>>> aarch64/vpmu_counter_access.c: In function ‘create_vpmu_vm’:
>>> aarch64/vpmu_counter_access.c:456:47: error: ‘ID_AA64DFR0_PMUVER_MASK’
>>> undeclared (first use in this function); did you mean
>>> ‘ID_AA64DFR0_EL1_PMUVer_MASK’?
>>>   456 |         pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
>>>   dfr0);
>>
>> Looks like there's a clash with
>> "KVM: arm64: selftests: Import automatic generation of sysreg defs"
>> from:
>>         https://lore.kernel.org/r/20231003230408.3405722-12-oliver.upton@linux.dev
> Thanks for the pointer, Sebastian! Surprisingly, I don't see the patch
> when I sync to kvmarm/next.
>

Yea, sry - I've had both of these series applied locally.

Sebastian
---1463795790-956281928-1697450511=:6267--

