Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACEE56B99
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 13:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I6KEN0tN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702561976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=47QTLpQUD6l8Dml/WreIBJeaYCFjo5y0akXYerqAVwk=;
	b=I6KEN0tNiXe7PwSN+30VTWoUTyYPcXyYKkZtHGke+skoP644j78FrQU/dbHJ1pkdDNllRZ
	94KjUuZVI/aF6wVf6wG8NKI0P9xlSjMkxBfOG/ro1/WXnT6zLb6JU5M1W6kryvH8rzMWgw
	+4E6Ff4G3ZH/hF1bv9kqwAjmvQ7Uc5Q=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-1j1PPE5sNrio7Ok1oYQUsA-1; Thu, 14 Dec 2023 08:52:54 -0500
X-MC-Unique: 1j1PPE5sNrio7Ok1oYQUsA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4257de8a5f4so104752511cf.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 05:52:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702561974; x=1703166774;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47QTLpQUD6l8Dml/WreIBJeaYCFjo5y0akXYerqAVwk=;
        b=DZ7/VmmOz48nKZ/05nsYi3eUDvkjS9l5jbtCjSDdBuYje/KArelBekg498bpyLN2eQ
         ZxsEgr2bGyKhzyR80ssw+0bFgYGSJTuD6LePbXR4MQjtnAG7ZBoz8ZJcaTYiYAsdKDhz
         ggTwgQG10hckpxzecCBiyds0P8EvBu3YnjfUEl+gBttI65yDBOM0FWSRK3YICPqlzn/p
         KfqviwR31erKq+aM+t9qJIvkzFlfm1W3yu1rX9QR9a1nlHwnd5Yuwa/ZnXoFmByMjA0m
         0lG0wWLLcpQJZ5bOsjBDIkIxvgtgk7VSbUa4lhdOT+vnB4tnj3Xq+xin9g4eR6y8nS/Z
         IpmQ==
X-Gm-Message-State: AOJu0YzSy/HvK6+CyYAMWlAR4iKXePzK4Q1OErdt38bVtO7DtjRxskLf
	GgJx+NYLWw1M+bSTuM/BHCimoONwctuSF0H4+aFSgNXizjMVUEZsbyVU6jGqHaz8LC1eksBeIaS
	0df1ATqoBwzU6Y+Vn
X-Received: by 2002:a05:622a:1352:b0:425:85b7:a784 with SMTP id w18-20020a05622a135200b0042585b7a784mr14471925qtk.53.1702561974441;
        Thu, 14 Dec 2023 05:52:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHpWkcb1WNBFDGT8fdgkiTcGoAQitzYeJZ2HpypjaPY5jt72qe2FYW2BYR+o3li4uteK49vkQ==
X-Received: by 2002:a05:622a:1352:b0:425:85b7:a784 with SMTP id w18-20020a05622a135200b0042585b7a784mr14471902qtk.53.1702561974139;
        Thu, 14 Dec 2023 05:52:54 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ca25-20020a05622a1f1900b004259ba7bc08sm5760603qtb.42.2023.12.14.05.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 05:52:53 -0800 (PST)
Message-ID: <7b1c4163-31e8-490e-9f19-3abceeeb2d7d@redhat.com>
Date: Thu, 14 Dec 2023 14:52:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] KVM: selftests: aarch64: Add invalid filter test
 in pmu_event_filter_test
To: Shaoqin Huang <shahuang@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231129072712.2667337-1-shahuang@redhat.com>
 <20231129072712.2667337-6-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231129072712.2667337-6-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin

On 11/29/23 08:27, Shaoqin Huang wrote:
> Add the invalid filter test to double check if the KVM_ARM_VCPU_PMU_V3_FILTER
> will return the expected error.
... in which situations? filter beyond the 16b event space or incorrect
action.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  .../kvm/aarch64/pmu_event_filter_test.c       | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
> index 0e652fbdb37a..4c375417b194 100644
> --- a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
> @@ -7,6 +7,7 @@
>   * This test checks if the guest only see the limited pmu event that userspace
>   * sets, if the guest can use those events which user allow, and if the guest
>   * can't use those events which user deny.
> + * It also checks that setting invalid filter ranges return the expected error.
>   * This test runs only when KVM_CAP_ARM_PMU_V3, KVM_ARM_VCPU_PMU_V3_FILTER
>   * is supported on the host.
>   */
> @@ -197,6 +198,39 @@ static void for_each_test(void)
>  		run_test(t);
>  }
>  
> +static void set_invalid_filter(struct vpmu_vm *vm, void *arg)
> +{
> +	struct kvm_pmu_event_filter invalid;
> +	struct kvm_device_attr attr = {
> +		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
> +		.attr	= KVM_ARM_VCPU_PMU_V3_FILTER,
> +		.addr	= (uint64_t)&invalid,
> +	};
> +	int ret = 0;
> +
> +	/* The max event number is (1 << 16), set a range large than it. */
larger
> +	invalid = __DEFINE_FILTER(BIT(15), BIT(15)+1, 0);
doc says
must fit within the event space defined by the PMU
architecture (10 bits on ARMv8.0, 16 bits from ARMv8.1 onwards).

> +	ret = __vcpu_ioctl(vm->vcpu, KVM_SET_DEVICE_ATTR, &attr);
> +	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter range "
> +		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
> +		    ret, errno);
> +
> +	ret = 0;
> +
> +	/* Set the Invalid action. */
> +	invalid = __DEFINE_FILTER(0, 1, 3);
> +	ret = __vcpu_ioctl(vm->vcpu, KVM_SET_DEVICE_ATTR, &attr);
> +	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter action "
> +		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
> +		    ret, errno);
> +}
> +
> +static void test_invalid_filter(void)
> +{
> +	vpmu_vm = __create_vpmu_vm(guest_code, set_invalid_filter, NULL);
> +	destroy_vpmu_vm(vpmu_vm);
> +}
> +
>  static bool kvm_supports_pmu_event_filter(void)
>  {
>  	int r;
> @@ -228,4 +262,6 @@ int main(void)
>  	TEST_REQUIRE(host_pmu_supports_events());
>  
>  	for_each_test();
> +
> +	test_invalid_filter();
>  }

Eric

