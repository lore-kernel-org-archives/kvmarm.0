Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793340116;
	b=Ziy4zFiwo2hZgePlNmJDzxn7ADP20bWp9+TAzR2afpxvIADtunfgrQdUXSj5P55cLIeA
	 ZTOgzhLxVwpGPnIhbUENfW/qr4oPsFlnG/55Ua+HJJC9Q0OvelA+J4Vwbdh95uzda+keX
	 baqJMMKIrcjDNCa5NPEWuO0+GjQ0pP+fZJN6fLcyCvu+qUNYOgQ7lVtf776Tj+32Sh3uh
	 mFdDcY5EURJOjBCyvlPWSN2O7kbIgFyoosbC7vcEGxSURS2w8iciBYyGIgXDtbTqDU/4F
	 PcWb7EtQksjD8IVJrEGgagJlXmXVqT2cSQ3rJ56sH+xev9jhBG/wBoe7ZuzRbXIY/Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793340116;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=QV64RGtqfAWvcrVEQ/J8fVuvfalRZ9xgiHmT8AuAPYU=;
	b=2eKCMsGRxOKdYYEdEUZzqUnKqg9d0baDgV/f+KkVPh3lA2RYDh20Y9q/ziwQ4+W6Kh4Q
	 JQnW/IqYbvhOuWUFerN8CEvK6HU0NV1hE/3NGZAaoCmR2gkgKcmBYgrFsZWiXMx0Imbnl
	 yZ7siULmZUNrCxMTZEfvetjkTMoyLpUh7x0FaXR9iFwpBwnlCTl09QyPSQ9gbP9gYcR3j
	 Zu97AjeWc/UgwSuiG9H6jnClaJUdagIbEkBGP14/8FdROErBkE+P7FuzaPFoX5WcO+BEN
	 JBhlHrkcCI1YIWaT7Cdcx4a4UFjtlqpRLooc+FQDRz157mo/aeksvJTclljpSoRkdbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=WrESf68H;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D1606A331
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 06:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A6D1606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=WrESf68H
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QV64RGtqfAWvcrVEQ/J8fVuvfalRZ9xgiHmT8AuAPYU=;
	b=WrESf68Hs0YRccK+XTYqrJfLNsgVzD1tFRK4UfgJfK6v9eiCHydujqzBqR/Bwks32HSm99JSJ
	yvt1zNYgJBR5nwE/R2ciu1QBW/2WrpfgPrq3hPiw3I9XbIs1YCBbapoRe4nlDW26KEOxSrwn3Pt
	DdlrRNDetKULhgh6Sk4aBhw=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jG9Tg2GvTz1cySS;
	Fri, 30 Oct 2026 14:01:43 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 3C4D840563;
	Fri, 30 Oct 2026 14:01:51 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 30 Oct 2026 14:01:50 +0800
Message-ID: <b8f76a0a-8b1e-4167-81cc-b3a4ee79fb6b@huawei.com>
Date: Fri, 30 Oct 2026 14:01:49 +0800
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
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on
 migration
To: Leonardo Bras <leo.bras@arm.com>
CC: liuyonglong <liuyonglong@huawei.com>, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>
References: <aqneWnlsdpocLIl6@kernel.org> <aqqhDs3NyjtkZzXK@LeoBrasDK>
 <aqsl1_IqnV2r8kUL@kernel.org> <aqvt2gnlBZeNsaf4@LeoBrasDK>
 <as-mH36YSMxAosND@LeoBrasDK>
 <3e464bef-8dfe-44a3-afea-3c276ae87cd8@huawei.com>
 <attMtUqxNsuPooix@LeoBrasDK>
 <8eaaba87-7881-49c4-a76a-51dec2f29ffc@huawei.com>
 <auCPEQmnFwWldTaM@LeoBrasDK>
 <52945586-8c5c-4991-bd92-fe02aaf79fbe@huawei.com>
 <auM0CWJTPzYUTknh@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <auM0CWJTPzYUTknh@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 10/29/2026 7:54 PM, Leonardo Bras wrote:
> On Thu, Oct 29, 2026 at 10:54:24AM +0800, Tian Zheng wrote:
>> Hi Leo,
>>
>> I've read your discussion with Oliver on DBM RFC v2. As a suggestion,
>> maybe we should go with Oliver's approach, i.e. revert to the v1 scheme
>> and continue fixing from there.
> 
> Hi Tian,
> I have been reading a bit more about permission indirection to try figuring
> out a way that the change may work for both ways.
> 
> The problem with the previous approach is that it assume DBM=write at all
> times, which is not architecturally correct. Having DBM=write only on
> HAFDBS=on as suggested would require us to transverse the whole pagetable
> to convert encodings when we enable/disable it, which can be quite
> expensive.
> 
> One option would be to always enable HAFDBS when system supports HDBSS, but
> I still have to figure out if that causes any performance regression before
> suggesting.
> 
> The option I am pursuing is thinking on an unified code path for direct
> permissison (both HACDBS=on and HACDBS=off) so we don't have to convert
> between them, neither worry about the impact of HAFDBS=on on performance.
> 
> I will reply on the thread once I figure one of those options out.
> 
> Thanks!
> Leo

Hi Leo,

Sounds good. I'll wait for your next version and review it once it's
posted.

Thanks,
Tian
