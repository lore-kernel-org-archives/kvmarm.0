Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0818D184
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 04:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751428918; cv=none; b=ZZH3GGwoELbaefNx5U5wRnWfX4sbq/YfcAaVmn8/djdZkY2PaUlTjM8meFxcrPy6+tNHlPjhjmRuSuLebsf5M8IMleRuJOQqp9Tz7kS8cirocWnH5bQRFCT+cVNpxiTu3502LGCy8jV0uAWzYPjfT25PmtfGlLtAQQY1fI7IpFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751428918; c=relaxed/simple;
	bh=CcpPp5pw635DYlx/P7hWy6YsZ4cf/X1zVQAdS4x/iBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EU0roL/ChZDzdHgcIJPS9BghW6Iy6CqD5kr+JivM2jfJU6Vw/J8A6sowjP3Mr2G5cG5oE9wyXVd4axNLLLHZbkznqZqRpn7EGjTu06BTn92FZXWAJaWzXR/9FQ7pkuS+kfjbUt2bXEShFj/mWzMahgZlUryWMY5rQ4MGM+P+dd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bX5k90cbgz1R8Bn;
	Wed,  2 Jul 2025 11:59:13 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 06DE4140278;
	Wed,  2 Jul 2025 12:01:44 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 dggpemf500013.china.huawei.com (7.185.36.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 2 Jul 2025 12:01:42 +0800
Message-ID: <ae3f4d26-7a1a-418c-b303-2ed1d9ced4ba@huawei.com>
Date: Wed, 2 Jul 2025 12:01:41 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] arm/kvm: write back modified ID regs to KVM
To: Cornelia Huck <cohuck@redhat.com>, <eric.auger.pro@gmail.com>,
	<eric.auger@redhat.com>, <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
	<kvmarm@lists.linux.dev>, <peter.maydell@linaro.org>,
	<richard.henderson@linaro.org>, <alex.bennee@linaro.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <sebott@redhat.com>,
	<shameerali.kolothum.thodi@huawei.com>, <armbru@redhat.com>,
	<berrange@redhat.com>, <abologna@redhat.com>, <jdenemar@redhat.com>, Zhou
 Wang <wangzhou1@hisilicon.com>, liuyonglong <liuyonglong@huawei.com>
CC: <agraf@csgraf.de>, <shahuang@redhat.com>, <mark.rutland@arm.com>,
	<philmd@linaro.org>, <pbonzini@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-8-cohuck@redhat.com>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <20250414163849.321857-8-cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500013.china.huawei.com (7.185.36.188)


On 2025/4/15 0:38, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
>
> We want to give a chance to override the value of host ID regs.
> In a previous patch we made sure all their values could be fetched
> through kvm_get_one_reg() calls before their modification. After
> their potential modification we need to make sure we write back
> the values through kvm_set_one_reg() calls.
>
> Make sure the cpreg_list is modified with updated values and
> transfer those values back to kvm.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   target/arm/kvm.c        | 44 ++++++++++++++++++++++++++++++++++++++++-
>   target/arm/trace-events |  1 +
>   2 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index b07d5f16db50..9e4cca1705c8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1083,6 +1083,39 @@ void kvm_arm_cpu_post_load(ARMCPU *cpu)
>       }
>   }
>   
> +static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
> +{
> +    if (!cpu->writable_map) {
> +        return;
> +    }
> +    for (int i = 0; i < NR_ID_REGS; i++) {
> +        uint64_t writable_mask = cpu->writable_map->regs[i];
> +        uint64_t *cpreg;
> +
> +        if (writable_mask) {
> +            uint64_t previous, new;
> +            int idx = kvm_idx_to_idregs_idx(i);
> +            ARM64SysReg *sysregdesc;
> +            uint32_t sysreg;
> +
> +            if (idx == -1) {
> +                /* sysreg writable, but we don't know it */
> +                continue;
> +            }
> +            sysregdesc = &arm64_id_regs[idx];
> +            sysreg = sysregdesc->sysreg;
> +            cpreg = kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
> +            previous = *cpreg;
> +            new = cpu->isar.idregs[idx];
> +            if (previous != new) {
> +                *cpreg = new;
> +                trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
> +                                                            previous, new);
> +            }
> +        }
> +    }
> +}
> +
>   void kvm_arm_reset_vcpu(ARMCPU *cpu)
>   {
>       int ret;
> @@ -2050,7 +2083,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       }
>       cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
>   
> -    return kvm_arm_init_cpreg_list(cpu);
> +    ret = kvm_arm_init_cpreg_list(cpu);
> +    if (ret) {
> +        return ret;
> +    }
> +    /* overwrite writable ID regs with their updated property values */
> +    kvm_arm_writable_idregs_to_cpreg_list(cpu);
> +
> +    write_list_to_kvmstate(cpu, 3);
> +
> +    return 0;
>   }

Hi,

When I was testing this series, I found a problem. On the host, 
SYSREG_ID_AA64MMFR3_EL1_TCRX=0x1,
I configured it to 0x0 in qemu, and qemu cannot start.
The ID_AA64MMFR3_EL1 TCRX field controls whether the TCR2_EL1 and 
TCR2_EL2 registers are used.
In the kernel, when TCRX is 0, TCR2_EL1 is invisible to the guest, and 
when it is 1, it is visible. When we
configure this field segment to 0, the configuration is not yet written 
to KVM, but the cpreg list is initialized,
adding TCR2_EL1 to the cpreg list. Therefore, after writing the 
QEMU-configured registers to KVM, the
cpreg list needs to be updated again.

@@ -2227,7 +2229,7 @@ int kvm_arch_init_vcpu(CPUState *cs)

      write_list_to_kvmstate(cpu, 3);

-    return 0;
+    return kvm_arm_init_cpreg_list(cpu);
  }

The above modification can solve the problem, but it may not be the best 
way.

Thanks,
Jinqian


>   
>   int kvm_arch_destroy_vcpu(CPUState *cs)
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 17e52c0705f2..955149ee1ac4 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -14,3 +14,4 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>   # kvm.c
>   kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>   get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
> +kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
