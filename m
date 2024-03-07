Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADA63134
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 09:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709802058; cv=none; b=MQ0Nz+oByBjR+6rdpDvKBTA7jA/mE81V0lTEkkHhJkDnjA0QV1nWkehZj5dRSu8s4u6c48pdrSWANE1xF47e7P4TThxakezEWUm00dvHCNmKkDirxRypg7yyyLBqREuDSVNfK3d86aCnu0pqRkg1AQ10OTCaoBFyYiL0Ecq+6ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709802058; c=relaxed/simple;
	bh=Hsr0nIAfoArzgXOGDRkv4h5nyU+bDolQ52DXoXzXd5w=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=M0uz3zV2fDZJ0jbbstz0iKzi1gyhytu8gNDrOHZOvAfiN2endmZEbcCl2Ipa4miExH8K/cAxEhkrQ2YKdOWuExvHXqkiJnad9FYEWz1F0rUBSaZYnTM9B7G6eKseH/V4/Cjd40YRv4h+AdtcchZgyP1QL2wSfTz5Lj3j0g57z94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Tr39y17qQz1h1fK;
	Thu,  7 Mar 2024 16:58:30 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id E080A1A0172;
	Thu,  7 Mar 2024 17:00:51 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 17:00:50 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Don't load pending state when
 enabling LPIs on RD
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Eric Auger
	<eric.auger@redhat.com>
References: <20240228000117.2297982-1-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <db2920fd-9fe8-1ff4-3f00-34dc4afdcdd5@huawei.com>
Date: Thu, 7 Mar 2024 17:00:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240228000117.2297982-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Oliver,

On 2024/2/28 8:01, Oliver Upton wrote:
> Reality check: KVM's GIC/ITS emulation does not handle pending LPI state
> to the letter of the architecture!
> 
> Although the GIC spec defines LPI pending state on a per-redistributor
> basis, KVM's view of the LPIs in a VM are global by design. This is
> intentional, as it is a massive simplification to the way KVM organizes
> interrupts and deals with the interactions between the vCPUs and ITSes.
> 
> So, with that in mind, the KVM emulation of PENDBASE is completely wrong,
> as unmapped INTIDs (i.e. not mapped in any ITS) are silently ignored,
> even though the expecatation is that IRQs would be generated in real
> hardware. Even more hilarious things can happen for the LPIs that are
> actually mapped, as an update to global LPI state can pend an interrupt
> on a different vCPU.

I don't fully understand this "hilarious" part. Could you please
elaborate a bit more on it?

> vgic_add_lpi() fetches pending state when creating the global
> representation of an LPI. Both VM save/restore and guest interactions
> with the ITS find their way here, so the pending state will get loaded
> into KVM one way or another. That flow is slightly more correct, as it
> consults the pending table of the targeted redistributor.

This looks reasonable. I remember I had looked several times at this
code path (vgic_enable_lpis()/its_sync_lpi_pending_table()) but hadn't
made any improvements or progress.

E.g., it purely does *nothing* on the guest restore path, as
redistributors are restored before ITS, so there is no LPI mapping at
all when we're at its_sync_lpi_pending_table().

It's just been a long time. I'll take another look and think about it.

> Anyway, it is clear that this code can never be correct and doesn't
> serve a purpose. If bisection led you here you've probably got a *very*
> funky guest, and should bring it up on the list...

So I've tested it with kvm-unit-tests and got failure with the
its-pending-migration case:

INFO: gicv3: its-pending-migration: Migration complete
INFO: gicv3: its-pending-migration: expected 128 LPIs on PE #30, 0 observed
FAIL: gicv3: its-pending-migration: 128 LPIs on both PE0 and PE1 after 
migration
SUMMARY: 1 tests, 1 unexpected failures

where the guest SW directly writes to the pending table when
GICR_CTLR.EnableLPIs == 0. I seriously doubt there is any use case like
that in real world. But not sure whether it is a funky behaviour from
the architectural perspective.

Thanks,
Zenghui
