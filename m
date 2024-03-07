Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D693233
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 12:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709813629; cv=none; b=kBRyL2gBZNn33ki1J0y4m0dHZhvFCsY0Tq+f8/OAAHkfAngRKlBh4joDrStGPIWXIMGFFjEjbdJMQnpwRD9Q2JgeI50qsa4rHIfLpwyB6bqEsMFapzH1FwXPyK1Uu56lr0NuJVRQQnAVcGNLvx6QWGI57Kjd5nZfNdy/ZX0eHhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709813629; c=relaxed/simple;
	bh=/22fk4H/gqA/hl7Gc04COki3MYGl9Y4jrL7zU/diTxs=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dbjiwRgPauoDya3oLxHKFwtZ0I8/vE95oUHG7gPkniPHvBKKkS+P5MqeKhLWi/wwlbBrFjBV7DotvoO74CIxTXVBtCz1bevKLDS76IEcugLJPc2CLqHuk3iNoY/6q60mB+RxToJsM8eewMu8NC3zEVKHocXqvMmz3Yyo+nDxBSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Tr7SV6Lywz1QB0r;
	Thu,  7 Mar 2024 20:11:22 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 47F161A016C;
	Thu,  7 Mar 2024 20:13:45 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 20:13:44 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Don't load pending state when
 enabling LPIs on RD
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, <kvmarm@lists.linux.dev>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Eric
 Auger <eric.auger@redhat.com>
References: <20240228000117.2297982-1-oliver.upton@linux.dev>
 <db2920fd-9fe8-1ff4-3f00-34dc4afdcdd5@huawei.com>
 <86o7bq1hhd.wl-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <453f7cef-2b53-ccc6-40d2-6e147353f220@huawei.com>
Date: Thu, 7 Mar 2024 20:13:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86o7bq1hhd.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/3/7 18:09, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On Thu, 07 Mar 2024 09:00:42 +0000,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> So I've tested it with kvm-unit-tests and got failure with the
>> its-pending-migration case:
>>
>> INFO: gicv3: its-pending-migration: Migration complete
>> INFO: gicv3: its-pending-migration: expected 128 LPIs on PE #30, 0 observed
>> FAIL: gicv3: its-pending-migration: 128 LPIs on both PE0 and PE1 after
>> migration
>> SUMMARY: 1 tests, 1 unexpected failures
>>
>> where the guest SW directly writes to the pending table when
>> GICR_CTLR.EnableLPIs == 0. I seriously doubt there is any use case like
>> that in real world. But not sure whether it is a funky behaviour from
>> the architectural perspective.
> 
> Right, so this is *exactly* the thing I was worried about. A mapping
> has been established, the interrupt wasn't pending, all good. Now, an
> interrupt lands while GICR_CTLR.EnableLPIs == 0.
> 
> The spec says (4.7.3 "Effect of disabling interrupts")
> 
>   "When GICR_CTLR.EnableLPIs == 0, LPIs are never set pending."
> 
> which to me is a pretty damning indication that we shouldn't take
> these bits into account.

Ah, thanks for pointing it out! And I believe this is the rationale of
Oliver's patch.

What confused me is that the spec also says (5.1.2 "LPI Pending tables")

| "For physical LPIs, when GICR_CTLR.EnableLPIs is changed to 1, the
|  Redistributor must read the pending status of the physical LPIs from
|  the physical LPI Pending table."

which implicitly indicates that the pending table can contain some
pending bits (=1) when EnableLPIs == 0, which would be loaded by RD and
make the relevant LPIs pending when EnableLPIs is written from 0 to 1.

I have no idea how to interpret these rules ;-) .

> Of course, there is a grey area, in the sense that when we restore an
> LPI via the restore interface, we are actually consuming pending bits
> before EnableLPIs is set to 1.

The restore path is clear to me now. VMM follows the "ITS Restore
Sequence" of arm-vgic-its.rst, KVM then restores pending status for all
LPIs via vgic_its_restore_ite()/vgic_v3_lpi_sync_pending_status().

Removing vgic_enable_lpis()/its_sync_lpi_pending_table() (in this patch)
makes it much clearer.

> But I would tend to draw the line between an interrupt that is
> restored as part of rebuilding the KVM state, and an interrupt that is
> forcefully injected behind our back.

+1!

Thanks,
Zenghui
