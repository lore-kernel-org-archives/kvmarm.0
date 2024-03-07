Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26591292CD
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 12:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814841; cv=none; b=vEYry9/oWQdbNRHc8Mt/PEMXByECY8k5FBu3YVg7ZaaZBq7QZKkG0POls/LvxLRh+9gbWDisztEG3ghJSiarIlhczFIfxBehKsejWKEbQ4Q01fihbnc/fecZY63V3ogC5KTAEmGiBcSuhYL523fOPdOKoa3MGbwjDX54jVbDleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814841; c=relaxed/simple;
	bh=tBVMQocFCdgEsVfZEib1tw6nut/DbDWv21ZFG844fuc=;
	h=Subject:From:To:CC:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fs78LUiTbEcAoRqQV0yki98o3KiYpv8YvwZjtVN3ZqBr/Io3cwdx7/oWWkWHzUm0bR+3U6g2dnkVuhijsmbejAjuztbIs2xeFI2nK0tYEFm6vkAkb6XIT7uPPEBqzBg3bJFOglIV1/dEGfQlM95Mp+iyreFSRWEThiPf1hzFjjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Tr7yL6BQXz1FLwR;
	Thu,  7 Mar 2024 20:33:46 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 259F81A016C;
	Thu,  7 Mar 2024 20:33:56 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 20:33:55 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Don't load pending state when
 enabling LPIs on RD
From: Zenghui Yu <yuzenghui@huawei.com>
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, <kvmarm@lists.linux.dev>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Eric
 Auger <eric.auger@redhat.com>
References: <20240228000117.2297982-1-oliver.upton@linux.dev>
 <db2920fd-9fe8-1ff4-3f00-34dc4afdcdd5@huawei.com>
 <86o7bq1hhd.wl-maz@kernel.org>
 <453f7cef-2b53-ccc6-40d2-6e147353f220@huawei.com>
Message-ID: <c7f730d9-5a9b-5beb-61c6-6ca341c058c6@huawei.com>
Date: Thu, 7 Mar 2024 20:33:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <453f7cef-2b53-ccc6-40d2-6e147353f220@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/3/7 20:13, Zenghui Yu wrote:
>> Of course, there is a grey area, in the sense that when we restore an
>> LPI via the restore interface, we are actually consuming pending bits
>> before EnableLPIs is set to 1.
> 
> The restore path is clear to me now. VMM follows the "ITS Restore
> Sequence" of arm-vgic-its.rst, KVM then restores pending status for all
> LPIs via vgic_its_restore_ite()/vgic_v3_lpi_sync_pending_status().

And as ITSes are restored after redistributors, we actually consume
pending bits _after_ EnableLPIs is set to 1, right?
