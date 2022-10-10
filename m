Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFDF1FB2
	for <kvmarm@lists.linux.dev>; Mon, 10 Oct 2022 04:10:35 +0000 (UTC)
Date: Mon, 10 Oct 2022 04:10:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1665375028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cmx7UC5ERbZvs6NltikBKO+6xKGttyQo1AEh/wBpODM=;
	b=mWnNl9esZ4y1R7iZLuV38Ia7gZTlaSRQxos7LCRu9JrUofDzcFj4pgoUkfZa9sSZtDlTEx
	u1tilWLnPq16Hnl1a0BT5mPphvQ9yAzQe3k7kzjl1eNBcFcSqnXYXeDgFNYSa0RM55JLGO
	RHyqL7uUKo6dN+egY/xOYyt/ETSk4GY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org,
	andrew.jones@linux.dev, james.morse@arm.com,
	alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	pbonzini@redhat.com, seanjc@google.com, wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: selftests: Fix multiple versions of GIC
 creation
Message-ID: <Y0ObL7C7/93Q8d5T@google.com>
References: <20221009033131.365-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009033131.365-1-yuzenghui@huawei.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221010041023.AMSt5fEmyQzmWM8pJJ_vxZ5wa1BZ-lKpWtMg9Yi92co@z>

On Sun, Oct 09, 2022 at 11:31:31AM +0800, Zenghui Yu wrote:
> Commit 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to
> separate helper") wrongly converted a "real" GIC device creation to
> __kvm_test_create_device() and caused the test failure on my D05 (which
> supports v2 emulation). Fix it.
> 
> Fixes: 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separate helper")
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

> ---
>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index e05ecb31823f..9c131d977a1b 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -662,8 +662,8 @@ int test_kvm_device(uint32_t gic_dev_type)
>  					     : KVM_DEV_TYPE_ARM_VGIC_V2;
>  
>  	if (!__kvm_test_create_device(v.vm, other)) {
> -		ret = __kvm_test_create_device(v.vm, other);
> -		TEST_ASSERT(ret && (errno == EINVAL || errno == EEXIST),
> +		ret = __kvm_create_device(v.vm, other);
> +		TEST_ASSERT(ret < 0 && (errno == EINVAL || errno == EEXIST),
>  				"create GIC device while other version exists");
>  	}
>  
> -- 
> 2.33.0
> 
> 
