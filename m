Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5CC260571
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 06:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751611486; cv=none; b=UuL6shkALhYBwZVUFxpfsB6qKkROs0zhnAZFKfYLtpkvsyNmDE8xYUswE3iiPi9VWmtZdiEh9xxoLnz4c2NMVWvkNygh3f5Aud1mo/YsueV4zVfheJTyPoZ/wXc1yUgrxF1Gmq0BsEywBBDbhysHHkhlsKU8VeWf42Vl03tz+gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751611486; c=relaxed/simple;
	bh=4jqv/tFlSpCT9VBH8J464fArP8r5d9j/6sOOfWltQDo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DZV9bE+NGCXapwlGIN1xS/gPhIDZa6E0toTlM8+hFKVPHLXU+VcmAPKlbWhHugHymDxJQhoi2Rg5kRPnB4P+J836A2lOF03gym/IT7+VsbpIOudqh/ImgwABEM9O2Oos0QXxid1dcISGOOo/RdBRl91TPi6Z1ko0f36DvAXdSOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bYPG45GX2z2BdVd;
	Fri,  4 Jul 2025 14:42:52 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id F24791A016C;
	Fri,  4 Jul 2025 14:44:40 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 4 Jul 2025 14:44:39 +0800
Subject: Re: [PATCH 1/2] KVM: arm64: Fix enforcement of upper bound on
 MDCR_EL2.HPMN
To: Ben Horgan <ben.horgan@arm.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yury.norov@gmail.com>, <linux@rasmusvillemoes.dk>,
	<linux-kernel@vger.kernel.org>, <james.morse@arm.com>,
	<stable@vger.kernel.org>
References: <20250703135729.1807517-1-ben.horgan@arm.com>
 <20250703135729.1807517-2-ben.horgan@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ca3054b2-b053-3859-a992-09499809d4d4@huawei.com>
Date: Fri, 4 Jul 2025 14:44:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250703135729.1807517-2-ben.horgan@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200017.china.huawei.com (7.202.194.83)

On 2025/7/3 21:57, Ben Horgan wrote:
> Previously, u64_replace_bits() was used to no effect as the return value
> was ignored. Convert to u64p_replace_bits() so the value is updated in
> place.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> Fixes: efff9dd2fee7 ("KVM: arm64: Handle out-of-bound write to MDCR_EL2.HPMN")
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 76c2f0da821f..c20bd6f21e60 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2624,7 +2624,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
>  	 */
>  	if (hpmn > vcpu->kvm->arch.nr_pmu_counters) {
>  		hpmn = vcpu->kvm->arch.nr_pmu_counters;
> -		u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);
> +		u64p_replace_bits(&val, hpmn, MDCR_EL2_HPMN);
>  	}
>  
>  	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks!
