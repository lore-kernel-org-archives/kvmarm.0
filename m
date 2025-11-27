Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C4D31C58A
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 12:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764245982; cv=none; b=cKOlxC2pbzVr3mgjnvSCZNu23SiCULuYKL5s/MKXTCvlnIEdpRQxH5kr6JvvRPR6FC9DIINeOGZEGIpFu2r5qiBmKeIPziFAVNSSaItMcqM+OWG97oTh1+VH0o7SYAmY+yYtXp3VTz3rk4cbS7UxD5mIRZJhVh8D7GH85pLJx7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764245982; c=relaxed/simple;
	bh=snZXMi5nl6bhO3bavkCW1Qz0MKVCdtQuiiIe7fUMeyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pA/J1kx3AnSFhtyVFkNQ8sC7HsnMJDNgzF/a40tB57bXllJTyw5LoPBwTwHlivCpUCEUvbqwOIgEu7yaCqFqjXgzuKzo7P5rEJHqi2Do3U5Y9B/sCwZoW4cL8FxS66lgLDXUkilM+SwO48ikYvogRBYi+lR7BEg5jpjoPZcxEF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=lKZ9LeXx; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="lKZ9LeXx"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sCqC+fclu7sVj3OwwC1i530gr1DeutuEQFpGVVDViMk=;
	b=lKZ9LeXxwYKYStN9OpegM65caAjplSYELRYcUJBgbaugcgD2arrB/ko9W3OFbDFbbE8+sulxZ
	jAk7JoizZvEuam+puoFHejWnCvGRdArR5YC7oCybHL/+sbSYkxcjUffBujTKjQRXidwaskmWIPD
	/D9T8hAePRWITIin+aUTtS8=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dHFmf3BMvzpStk;
	Thu, 27 Nov 2025 20:17:22 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A8D01804F6;
	Thu, 27 Nov 2025 20:19:31 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 27 Nov 2025 20:19:30 +0800
Message-ID: <9fab5f94-33f2-419b-b0fb-200c7dbc8912@huawei.com>
Date: Thu, 27 Nov 2025 20:19:30 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] KVM: arm64: Support set the DBM attr during memory
 abort
To: Marc Zyngier <maz@kernel.org>, Tian Zheng <zhengtian10@huawei.com>
CC: <oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<pbonzini@redhat.com>, <will@kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-3-zhengtian10@huawei.com>
 <86v7j2qlc8.wl-maz@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <86v7j2qlc8.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 2025/11/22 20:54, Marc Zyngier wrote:
> On Fri, 21 Nov 2025 09:23:39 +0000,
> Tian Zheng <zhengtian10@huawei.com> wrote:
>>
>> From: eillon <yezhenyu2@huawei.com>
>>
>> Add DBM support to automatically promote write-clean pages to
>> write-dirty, preventing users from being trapped in EL2 due to
>> missing write permissions.
>>
>> Since the DBM attribute was introduced in ARMv8.1 and remains
>> optional in later architecture revisions, including ARMv9.5.
> 
> What is the relevance of this statement?
> 
I will remove this statement in v3.
>>
>> Support set the DBM attr during user_mem_abort().
> 
> I don't think this commit message accurately describes what the code
> does. This merely adds support to the page table code to set the DBM
> bit in the S2 PTE, and nothing else.
> 
Yes, this patch only adds support to set the DBM attr in the S2 PTE
during user_mem_abort(), and does not implement automatic promote
write-clean pages to write-dirty.

I will reward commit message of this patch like:

This patch adds support to set the DBM attr in S2 PTE during
user_mem_abort(). As long as add the DBM bit, it enable hardware
automatically promote write-clean pages to write-dirty, preventing
users from being trapped in EL2 due to missing write permissions.

> 	M.
> 

