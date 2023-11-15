Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C5156C3
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZktU7jr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700062303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/U++RP8J87fTpffNLluzx5XIExdTU9ynmak8Mre+P4=;
	b=RZktU7jr49koGscOk+YZGcJZn45sRaj4nqUQEDdRqRhmo/X9YFfVy/E0vjCxK0+zXp8/wX
	V5kQhgoa2VVligDeznTggXjrL9525P5RhbYNwu10beVLdiKVC+wZqPtcMyQAW/0hmCvOph
	n+OCKWcVE7Tr/aFrqvZjbFgEUA63I7A=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-jmelvw4rNq-9iXFADBC2mA-1; Wed, 15 Nov 2023 10:31:41 -0500
X-MC-Unique: jmelvw4rNq-9iXFADBC2mA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6bdc140103bso1690487b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 07:31:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700062300; x=1700667100;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/U++RP8J87fTpffNLluzx5XIExdTU9ynmak8Mre+P4=;
        b=ww2ggZhEJeAWN6MH34n2CfA7PCrEDINkYArhAf1yrlG68CMCH862/qyNIbD3UG1mHk
         bp9oJONIzfRCoeAE/mv8m/718qmU8u9AlNXBcnd+LsmHMCiqrDzMR++QWuRvEKI7i4LM
         aJ0BVX7YdTmxNnSO8Z/AoOEuH+bt4fDCGZ1QuTiuRHR08dhYL9R7cDetDP3FjTWwOLNj
         S/rs3tdyMKo1cLkfFdRS0udQ3OY72YOvY3RMpiVH+j8YrEE/uvV58F19goyVMzTRijJn
         ZE4t/iIiSWDC0tMAy6/z/CSuL2J68JH1wJWCTAB9Z3CrzYqSGBQCcZwxKGNIhPZCINSz
         TfVA==
X-Gm-Message-State: AOJu0YwE5qv6RyZqVIw3gMf04uZPVxpBrZkTUYuPgzC6upfX/8yJo5z/
	vBF62mDfrlWteDKPuaeE+S2Jt2xoaDGnpv96VMh3/xv9KGLA5GSfng7T0phe+ncZTi51WSSfEQn
	oENAkZQAc5VWDUWSH
X-Received: by 2002:a05:6a00:6894:b0:6c0:81a3:fe4c with SMTP id hr20-20020a056a00689400b006c081a3fe4cmr2631604pfb.3.1700062299858;
        Wed, 15 Nov 2023 07:31:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6wTglBWhG4nljh27JjPWJF2LXSzDl20T4s5YweTj0uHIb6TdJ4bD03xIAZOHx+3l4vNETfQ==
X-Received: by 2002:a05:6a00:6894:b0:6c0:81a3:fe4c with SMTP id hr20-20020a056a00689400b006c081a3fe4cmr2631564pfb.3.1700062299414;
        Wed, 15 Nov 2023 07:31:39 -0800 (PST)
Received: from [10.72.112.25] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e12-20020a6558cc000000b0058ee60f8e4dsm1174195pgu.34.2023.11.15.07.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 07:31:39 -0800 (PST)
Message-ID: <f3f467bf-40d7-dd4d-7ee1-eef95eeed36d@redhat.com>
Date: Wed, 15 Nov 2023 23:31:35 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: arm64: selftests: Clean up the GIC[D,R]_BASE_GPA
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231115104757.15710-1-shahuang@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231115104757.15710-1-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/15/23 18:47, Shaoqin Huang wrote:
> The GIC[D,R]_BASE_GPA has been defined in multiple files with the same
> value, define it in one place to make the code clean.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   tools/testing/selftests/kvm/aarch64/arch_timer.c   | 3 ---
>   tools/testing/selftests/kvm/aarch64/vgic_irq.c     | 3 ---
>   tools/testing/selftests/kvm/dirty_log_perf_test.c  | 3 ---
>   tools/testing/selftests/kvm/include/aarch64/vgic.h | 3 +++

Oops. Forget the kvm/aarch64/vpmu_counter_access.c. I will update a new one.

>   4 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> index 274b8465b42a..818854007bfd 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -59,9 +59,6 @@ static struct test_args test_args = {
>   
>   #define msecs_to_usecs(msec)		((msec) * 1000LL)
>   
> -#define GICD_BASE_GPA			0x8000000ULL
> -#define GICR_BASE_GPA			0x80A0000ULL
> -
>   enum guest_stage {
>   	GUEST_STAGE_VTIMER_CVAL = 1,
>   	GUEST_STAGE_VTIMER_TVAL,
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index 2e64b4856e38..a48aff110fb6 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -19,9 +19,6 @@
>   #include "gic_v3.h"
>   #include "vgic.h"
>   
> -#define GICD_BASE_GPA		0x08000000ULL
> -#define GICR_BASE_GPA		0x080A0000ULL
> -
>   /*
>    * Stores the user specified args; it's passed to the guest and to every test
>    * function.
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index d374dbcf9a53..4971e8f77a0a 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -22,9 +22,6 @@
>   #ifdef __aarch64__
>   #include "aarch64/vgic.h"
>   
> -#define GICD_BASE_GPA			0x8000000ULL
> -#define GICR_BASE_GPA			0x80A0000ULL
> -
>   static int gic_fd;
>   
>   static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
> diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> index 0ac6f05c63f9..9dbb342fd808 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> @@ -33,4 +33,7 @@ void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu);
>   
>   #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
>   
> +#define GICD_BASE_GPA		0x08000000ULL
> +#define GICR_BASE_GPA		0x080A0000ULL
> +
>   #endif // SELFTEST_KVM_VGIC_H

-- 
Shaoqin

