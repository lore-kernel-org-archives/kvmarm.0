Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793613419;
	b=tOtlaHMu3BdtoBzF+wminIUMyitD/gv49uchP19Y4q3bh/lnAaIXLjZT5XBj53B2fujs
	 toHmN8/IQp6IsQdVUm5LsLwd3dl1pVl58wnakg5zUHk1SrOn1SA5oK6C57MJcrrctWdtQ
	 2OruVUEeG4BzEeCiG6mp2C0MFaw7H9jTtS3pX+jKhAyw/dlmfefVe4rldOADGD+JeVzXD
	 3LB3WaxqqoMO76pMZBJbCICLNc9hx+AikfYsQuK3zauqWjjuXX0GSFWvy9TUVAs5BxCQd
	 qc5RwldEm6K6TuGqDo+c6vAbqCgi1D9Oat+cMVaMs3IpZ+yF2fmw+z9NAhATLKsJY4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793613419;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=vhiIK5PdTbwawB02fP2FOqUEIxrnLxsctWx372F2gzw=;
	b=fe+H6T82Bdp2SWg/svv+BJ3lUWBbXlE9ZC5HuDw9aWwgucw9uP+lrRSE2xDsyoSVC2cz
	 LxdzoHD/7sQN8LDKW5mq0OLdonFkJSctsHTVY11jPgtPfj7XTr7XXTrOHa1imS/dzfFcl
	 Ku5ImkA55DyD4muLtu5VjOcdk+cIQQf4SMcaL4jvxEPw5Vjd2dbDP/tpX77unGeS2BCEb
	 rEQ2TPfU86BYbpW27JapuNfs/YL3vl8YbFgtdh42D4RLgp+3W3hlo3mpbVEkKfzH/tCs1
	 ZccGer36T+YP9L8Gb7uET4yqOmGN84LPt8gIohNCDWRnWNdp985xhi33FqCy+s7HfWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=gccdexj1;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74CD606A330
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 09:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A74CD606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=gccdexj1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 069301595;
	Mon,  2 Nov 2026 01:56:54 -0800 (PST)
Received: from [10.57.66.79] (unknown [10.57.66.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CC263F59E;
	Mon,  2 Nov 2026 01:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613417; bh=41gNfj/3A8ki9t26Cg2dgECj8r+E6+sd8etdy9Thqd8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gccdexj1jX8rBkY14YBg4UcTDhTgWONWIbGeArCgbRMNdU0/2G6ZZ43/73JSxGiVV
	 7jKecXSJ+s1jgCav7JcsrTvW6tVxqbDJNiseB9CxPP2+6rmo1SUz8tZ8XOh/yIwWg/
	 jUYkUKUNJop5w32l1YPjfgU4MDwn6mfs1ZxeXTMc=
Message-ID: <5f82a68f-cb2c-4155-8f9f-cf287d5b00d6@arm.com>
Date: Mon, 2 Nov 2026 09:56:53 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] KVM: arm64: Clear the default PMU when
 kvm_setup_vcpu() fails
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jack Thomson <jackabt@amazon.com>,
 Congkai Tan <congkai@amazon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>
References: <20261102075843.2556018-1-fuad.tabba@linux.dev>
 <20261102075843.2556018-3-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261102075843.2556018-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/11/2026 07:58, Fuad Tabba wrote:
> Under KVM_ARM_VCPU_PMU_V3_STRICT, the VM has no PMU until userspace
> selects one, and initializing the PMU fails with -ENXIO until then.
> However, without STRICT, kvm_setup_vcpu() selects the default PMU
> before it prepares the vCPU for nested virtualization, and leaves it
> set when that preparation fails. After a retry with STRICT,
> initializing the PMU succeeds and the guest gets the PMU of the CPU
> the failed INIT ran on.
> 
> Drop the PMU and its number of counters along with the VM's feature
> bitmap. While KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED is clear, no vCPU
> has been initialized and the PMU attributes return -ENODEV, so only
> such a failure can have set them. Once the flag is set, every INIT has the
> features of the first one that succeeded, which either selected a PMU
> or had none to select, so kvm_setup_vcpu() doesn't select another.
> 
> Fixes: ad220e275c398 ("KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   arch/arm64/kvm/arm.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3e91e01b032c4..65194e02cdbc2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1857,9 +1857,12 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>   
>   	ret = kvm_setup_vcpu(vcpu);
>   	if (ret) {
> -		/* Clear the bitmap if setup fails on the first vCPU to be initialized. */
> -		if (!test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags))
> +		/* Clear the bitmap and PMU if setup fails on the first vCPU to be initialized. */
> +		if (!test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags)) {
>   			bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
> +			kvm->arch.arm_pmu = NULL;
> +			kvm->arch.nr_pmu_counters = 0;
> +		}

minor nit: While the above works, it looks a bit too much extracting the 
PMU details to arm.c. Alternatively we could do something like this:


diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e2b28dbc0451..7a669cccf912 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1088,6 +1088,11 @@ int kvm_arm_set_default_pmu(struct kvm *kvm)
         return 0;
  }

+int kvm_arm_clear_default_pmu(struct kvm *kvm)
+{
+       kvm_arm_set_pmu(kvm, NULL);
+}
+
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6b4a118d17ca..571c0ba8507c 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,6 +92,7 @@ void kvm_vcpu_pmu_resync_el0(void);
  u8 kvm_arm_pmu_get_pmuver_limit(void);
  u64 kvm_pmu_evtyper_mask(struct kvm *kvm);
  int kvm_arm_set_default_pmu(struct kvm *kvm);
+int kvm_arm_clear_default_pmu(struct kvm *kvm);
  u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);

  u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);



Either ways,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com

