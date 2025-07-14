Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31752594B4
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505398; cv=none; b=ZFjkbN2ao2M/+9Od98KHPuvib9aojxe2mFxOGhm5iQaYfuCB9XO8p0g7jCv79ZrvtW2/UZZ4qWW9cSYHXYb0eXWNSb8uRpoE2i8Ynsy4XCWZBwLIAMwetWfIq19hIVZCDENVta4HkoyVMOUPzBmSj8YRiR/NXlQJypM9FIuGHv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505398; c=relaxed/simple;
	bh=00urmYjW8pc35DZOTUag6LwkU8wwutdiWESS/gciJyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eOfySqmDJgy1dsojCzxEGNLN1NaCDklYzQWXBJ3vSavMOejib/cOsBTri//iySBlYTP//RSWCcqNVBhfdWPVfcUzkNMfc5rEmL6zImLD3/Ip3Kk8kC6bdOZxQrQUV4YhOIB/uw1GDsRjJoFn5ga8T4XSc/+xNoZBEpOnV+0dMnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ClXEpc8f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClXEpc8f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752505395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vLSZ6SrdTz2tPTlEdtXBPkChG5jvzYGcVPf50t/vIKw=;
	b=ClXEpc8fg9MzDL3zMIFYmj2LTF57QjU8Znwsg+/+rQfJXOmGnvCJZYixjvTlbcmRXn0V+1
	jiF16WTTSzbqYlDjdBfpMVdM+Ix9Y0SuOiuom3VFH/5/efkWo2/Ht7NxxGgHHvSF53IGpV
	7RcURoAM7A4va6w5c8B9R/eOV02gyX0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-JFHNqGD_NimIKlaeTcCMGw-1; Mon, 14 Jul 2025 11:03:14 -0400
X-MC-Unique: JFHNqGD_NimIKlaeTcCMGw-1
X-Mimecast-MFC-AGG-ID: JFHNqGD_NimIKlaeTcCMGw_1752505394
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455e9daab1cso5917725e9.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 08:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752505393; x=1753110193;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vLSZ6SrdTz2tPTlEdtXBPkChG5jvzYGcVPf50t/vIKw=;
        b=F6AitgEgKvrF6crwpfd2vHz4g4R2kbdtTa2pjIgBjWDF9ad/fEh9/4I6qKYxTLq+QJ
         Xn7f6JH98yPVaBGVLnVJxANDlZ8YzwVnnPQgL/VOLrm8r861+Vyv8v1YjVKCO6VwT+h3
         DFhlimFDVGXEbNzr1BfubD3c0Sysxhraqswy6PPuLXPQShpfbhppn097F5nBLt9ZGmuy
         FaTEomT6/xT8X7pmaJOpaQjDrGkncddfN+qGXEdXouPboMkaGoMLQm8RlluRd5ZNgLYM
         q1h4KR4oFhPL7ltd6A/p2JMJlJcFJk/OuCTkCuiZdAgt/ro8atAwrC7sdh0Fo0K0riO7
         7mgw==
X-Forwarded-Encrypted: i=1; AJvYcCWb/xQHKNjqpw48J205k46UbfLN4eQ7rAU7dNkBZVoB+RC6K+utD+bJhh0/oG3gnrm/Uf3RmSM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQH2pHYKMEwu4Ws/cvdp/CbXN3t+vwwdfrOXPWeU4ESX9xX/A6
	xyAyPJ1hqm6IKlzXnmDO4qcELbzwaxJZ4mo0ugaTZv3niuJi6tUUXv8ppyhkogO1+9alHB41BBI
	gpXNiC9A3+YUzds9Sb21nPPF/T16sG0DL7RKOA9BsGwbty8c7K6J2pnf1IQjJp86upQ==
X-Gm-Gg: ASbGnctH2L2iv/xGYCeN4mB0VRCcW9PKSzcOlVhx+4epmqZ0+hJXf+FWKJ+VKZQHgL1
	1v/pYWVChvdZZRy+CUFYFxYUvOJpqjuWHaDbwHkCp4e7SdeV/QcaAWQoFeflyO5k409uTDpu5cS
	S3HqkRVfM6jud3gvY5AKeUpcPkSNkuMVo5+Wz+rT/EuulVO3Mb6FOcx06J0i7KYNdC1V4JLH5Iq
	+YVaXmbKdUPctzNlkFj+ZVl4bCx6tgpiTw53cd1DykV2wP+YtRka/AszJLsGYYUW/OBws7CyhkT
	8gPSicX7oDSmJr4GEB0sg/jYFStxf+3uPABf+Tc4VFR6+W5s9BpKALgt7J1clCLcm+LglTgbqAh
	tvNmHaQ==
X-Received: by 2002:a05:600c:4684:b0:442:f97f:8174 with SMTP id 5b1f17b1804b1-454ec276b88mr136167315e9.18.1752505392819;
        Mon, 14 Jul 2025 08:03:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4rNgWsIS28aO+cHphO1eWWM+OrFLeoFyLAvbBQjS4LbLMSSmTpVyOcm7f6GgiZxKZFpLamg==
X-Received: by 2002:a05:600c:4684:b0:442:f97f:8174 with SMTP id 5b1f17b1804b1-454ec276b88mr136165315e9.18.1752505391437;
        Mon, 14 Jul 2025 08:03:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e1e285sm12488643f8f.76.2025.07.14.08.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 08:03:10 -0700 (PDT)
Message-ID: <a072d0c9-1831-4381-ae4d-2f5ce9960a43@redhat.com>
Date: Mon, 14 Jul 2025 17:03:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] KVM: arm64: selftests: Add test for nASSGIcap
 attribute
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Zhou Wang <wangzhou1@hisilicon.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-6-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20250709211417.2074487-6-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MKTkj2f59n8GFlHG9ygC5QTOonFvJP-y3_23-PK62Lo_1752505394
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/9/25 11:14 PM, Oliver Upton wrote:
> From: Raghavendra Rao Ananta <rananta@google.com>
> 
> Extend vgic_init to test the nASSGIcap attribute, asserting that it is
> configurable (within reason) prior to initializing the VGIC.
> Additionally, check that userspace cannot set the attribute after the
> VGIC has been initialized.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  tools/testing/selftests/kvm/arm64/vgic_init.c | 42 ++++++++++++++++++-
>  1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
> index b3b5fb0ff0a9..743351aa998e 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
> @@ -13,13 +13,12 @@
>  #include "kvm_util.h"
>  #include "processor.h"
>  #include "vgic.h"
> +#include "gic_v3.h"
>  
>  #define NR_VCPUS		4
>  
>  #define REG_OFFSET(vcpu, offset) (((uint64_t)vcpu << 32) | offset)
>  
> -#define GICR_TYPER 0x8
> -
>  #define VGIC_DEV_IS_V2(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V2)
>  #define VGIC_DEV_IS_V3(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V3)
>  
> @@ -675,6 +674,44 @@ static void test_v3_its_region(void)
>  	vm_gic_destroy(&v);
>  }
>  
> +static void test_v3_nassgicap(void)
> +{
> +	struct kvm_vcpu *vcpus[NR_VCPUS];
> +	bool has_nassgicap;
> +	struct vm_gic vm;
> +	u32 typer2;
> +	int ret;
> +
> +	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
> +	kvm_device_attr_get(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
> +			    GICD_TYPER2, &typer2);
> +	has_nassgicap = typer2 & GICD_TYPER2_nASSGIcap;
> +
> +	typer2 |= GICD_TYPER2_nASSGIcap;
> +	ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
> +				    GICD_TYPER2, &typer2);
> +	if (has_nassgicap)
> +		TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_DEVICE_ATTR_SET, ret));
> +	else
> +		TEST_ASSERT(ret && errno == EINVAL,
> +			    "Enabled nASSGIcap even though it's unavailable");
> +
> +	typer2 &= ~GICD_TYPER2_nASSGIcap;
> +	kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
> +			    GICD_TYPER2, &typer2);
> +
> +	kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
> +
> +	typer2 ^= GICD_TYPER2_nASSGIcap;
> +	ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
> +				    GICD_TYPER2, &typer2);
> +	TEST_ASSERT(ret && errno == EBUSY,
> +		    "Changed nASSGIcap after initializing the VGIC");
> +
> +	vm_gic_destroy(&vm);
> +}
> +
>  /*
>   * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
>   */
> @@ -730,6 +767,7 @@ void run_tests(uint32_t gic_dev_type)
>  		test_v3_last_bit_single_rdist();
>  		test_v3_redist_ipa_range_check_at_vcpu_run();
>  		test_v3_its_region();
> +		test_v3_nassgicap();
>  	}
>  }
>  

