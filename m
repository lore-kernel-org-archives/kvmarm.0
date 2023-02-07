Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF8CBD1C
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 05:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675746173;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RoQGnbJ8HFpoGfIwHkEQlUee8Iihx10rYBZkVDXH4r8=;
	b=IwSDBablH9uAdgchQLU/tQJlK9PQHwRT7SSHT94JuEAFM3HzbhhCHy9UrloKgP0O+8ceJ0
	5DGPoH2Mn9bWOoesQGW3GVKr6NYkdTZH8GOyYu2jj7JIgerJorlrxsXJktbrrL97r1CJio
	ldFew86Aa3iiQOlDqH3XHtm3PmUpIGw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-A2SQgcvKPP6PROvyMcQ0ow-1; Tue, 07 Feb 2023 00:02:47 -0500
X-MC-Unique: A2SQgcvKPP6PROvyMcQ0ow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3352585CBE6;
	Tue,  7 Feb 2023 05:02:47 +0000 (UTC)
Received: from [10.64.54.63] (vpn2-54-63.bne.redhat.com [10.64.54.63])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD744440BC;
	Tue,  7 Feb 2023 05:02:44 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Mark some VM-scoped allocations as
 __GFP_ACCOUNT
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230206235229.4174711-1-oliver.upton@linux.dev>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ebdbfb5a-7068-a253-2b6e-b26218d4ba34@redhat.com>
Date: Tue, 7 Feb 2023 16:02:41 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230206235229.4174711-1-oliver.upton@linux.dev>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2/7/23 10:52 AM, Oliver Upton wrote:
> Generally speaking, any memory allocations that can be associated with a
> particular VM should be charged to the cgroup of its process.
> Nonetheless, there are a couple spots in KVM/arm64 that aren't currently
> accounted:
> 
>   - the ccsidr array containing the virtualized cache hierarchy
> 
>   - the cpumask of supported cpus, for use of the vPMU on heterogeneous
>     systems
> 
> Go ahead and set __GFP_ACCOUNT for these allocations.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
> 
>   Applies to github.com/oupton/linux kvm-arm64/virtual-cache-geometry
> 
>   arch/arm64/kvm/arm.c      | 2 +-
>   arch/arm64/kvm/sys_regs.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9c5573bc4614..3619f1e472f5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -146,7 +146,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	if (ret)
>   		goto err_unshare_kvm;
>   
> -	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
> +	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL_ACCOUNT)) {
>   		ret = -ENOMEM;
>   		goto err_unshare_kvm;
>   	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6a742af8010f..5dc13d02721e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -160,7 +160,7 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
>   		if (val == get_ccsidr(vcpu, csselr))
>   			return 0;
>   
> -		ccsidr = kmalloc_array(CSSELR_MAX, sizeof(u32), GFP_KERNEL);
> +		ccsidr = kmalloc_array(CSSELR_MAX, sizeof(u32), GFP_KERNEL_ACCOUNT);
>   		if (!ccsidr)
>   			return -ENOMEM;
>   
> 

