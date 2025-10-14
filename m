Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9FB2773FC
	for <kvmarm@lists.linux.dev>; Tue, 14 Oct 2025 06:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760425179; cv=none; b=Pckhq3rXU41MyJEZS3bkMpqIXuyD0xEazc4XBrNeilKqoZfSDWRBO3a82WmXFEmtmj6z0mH4T0obmGXWQVZW1DLvhu5syuG/v1HTkd9s2fLJ4dVa3OdX0S79GjvPXLBrGMZAvCNlj7MiFPQp/e5nQXFRpKf+ExEJvv80m8UOJwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760425179; c=relaxed/simple;
	bh=BSlWLMBtPi4wldcJDwfz0qmi04s95WosXdniMkHDPp0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=EHLcNjno8t/2s1tWnMEL9FldWkW1gKUDBf87f7DDJgBqMBZG42eA03IlijUb4V2H3YVPg60suT1oYJNbmyxYIHqbhsUvSfTnkUKRV2JcjAwoM6zkagTvKKwZ3rG0OGrNev2+RZe9SqI+Z0wcO+WZew/3yHlSi2SAz+MvVy7PrJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=zw/KdMpA; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="zw/KdMpA"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gzKL1XMF2X7NDYIZWTFtjqhUAQB7pXraoI6fG4GLHS4=;
	b=zw/KdMpAFTlf5zt4yJ0H+Z74xhTR52zV2PQrKVuVm98Z773lfrOGRba1Yj9GOKjTkkzmylSo6
	sqPOPOe8lIi5/hEPkvdMbeJaWNvk+aNRhZ3P7P/IUcjcs8cdoSbYm2pGsUHZ8aOksWkNtMPJhmL
	T8z+XFFt6TsZ+NPqTAMbln8=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4cm4nm3kwZz1K97v;
	Tue, 14 Oct 2025 14:59:08 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 6FBB4140135;
	Tue, 14 Oct 2025 14:59:27 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 14:59:26 +0800
Subject: Re: [PATCH] KVM: arm64: selftests: Sync ID_AA64PFR1, MPIDR, CLIDR in
 guest
To: Ben Horgan <ben.horgan@arm.com>
CC: Zenghui Yu <zenghui.yu@linux.dev>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>
References: <20251012154352.61133-1-zenghui.yu@linux.dev>
 <25a19af8-2026-45b6-8d0f-42c371c8ff95@arm.com>
 <75f13087-80fa-45cb-9327-aa85522203e0@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <f71d620a-87c9-7cd3-425b-e6052a38e268@huawei.com>
Date: Tue, 14 Oct 2025 14:59:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <75f13087-80fa-45cb-9327-aa85522203e0@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200017.china.huawei.com (7.202.194.83)

On 2025/10/14 0:14, Ben Horgan wrote:
> 
> 
> On 10/13/25 13:20, Ben Horgan wrote:
> > Hi Zenghui,
> >
> > On 10/12/25 16:43, Zenghui Yu wrote:
> > > We forgot to sync several registers (ID_AA64PFR1, MPIDR, CLIDR) in guest to
> > > make sure that the guest had seen the written value.
> > >
> > > Add them to the list.
> > >
> > > Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
> > > ---
> > >  tools/testing/selftests/kvm/arm64/set_id_regs.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> > > index 8ff1e853f7f8..5e24f77868b5 100644
> > > --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> > > +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> > > @@ -249,11 +249,14 @@ static void guest_code(void)
> > >  	GUEST_REG_SYNC(SYS_ID_AA64ISAR2_EL1);
> > >  	GUEST_REG_SYNC(SYS_ID_AA64ISAR3_EL1);
> > >  	GUEST_REG_SYNC(SYS_ID_AA64PFR0_EL1);
> > > +	GUEST_REG_SYNC(SYS_ID_AA64PFR1_EL1);
> > >  	GUEST_REG_SYNC(SYS_ID_AA64MMFR0_EL1);
> > >  	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
> > >  	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
> > >  	GUEST_REG_SYNC(SYS_ID_AA64MMFR3_EL1);
> > >  	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
> > > +	GUEST_REG_SYNC(SYS_MPIDR_EL1);
> > > +	GUEST_REG_SYNC(SYS_CLIDR_EL1);
> >
> > Why did you choose this position in the list for these 2?

Technically there are no restrictions on the order. I just want it to
look consistent with test_reset_preserves_id_regs().

> >
> >>  	GUEST_REG_SYNC(SYS_CTR_EL0);
> >>  	GUEST_REG_SYNC(SYS_MIDR_EL1);
> >>  	GUEST_REG_SYNC(SYS_REVIDR_EL1);
> >
> > Looks good to me.
> >
> > Reviewed-By: Ben Horgan <ben.horgan@arm.com>

Thanks!

> On running this, I note test_guest_reg_read() doesn't announce its
> presence. How about adding a ksft_test_result_pass("%s\n", __func__) and
> bumping the number of tests?

Yup, I agreed.

Thanks,
Zenghui
