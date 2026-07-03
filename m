Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1272430AAA9
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783097986; cv=none; b=BeqTLNlxz4EVpRzq95JGJvw0Tz60cyOOjkI9KsjQtGdTcGYUcvm1oO77BQBpRKpQq9SsaZC0+/2fUInoNZtn8TrzUWSIEg8HPJJ/5q/u0etL9vEjIiehM9T2+CJM4UZCp2ejFwDR1bpej0BMENM+Ma+yxhQIp3VSiOjmmG9Ue8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783097986; c=relaxed/simple;
	bh=GhvYuaKuUbXy3HURFqiFYavYDk6NV309cJWWu68JA/M=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=PSn/OeDlKBLXWFpv5JvQb//vPs7iEFNChyE/CnPR8yNUAJua2U42kOmWMQqzJmv7y2AyGtl771cDB7vS1a2k/tjZdvullYCGYBzpSw8A7simMXLdP4rsl0AhQMFLC0OHk13+wxoyRMdnE3KJZMaOB0auXe/HyOUuhe/XgSITto4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=nSoV1OlA; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="nSoV1OlA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1783097973;
	bh=j4fjgNakpX6GsuTiddiSQxuWPFVXr9GRxsHhqq40J8g=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=nSoV1OlAteAOdyTDmN43NkMQNImXQf/VyY0mHwKTVicJhqOaDdDvgJYw8irq19BHW
	 /SLnWpPTpOF4iuIQqnifHUEdcbkPVP9gpVIhZ5Zt1RKMTZYyBV+3+pGQXMbOHPAfzB
	 NgiMV3q9ZWh2D+os60pWqlr+NSGSGEooUbmnlffE=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4gsKjd5HYwz1154;
	Fri, 03 Jul 2026 16:59:33 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4gsKjd1qdPz1141;
	Fri, 03 Jul 2026 16:59:33 +0000 (UTC)
Date: Fri, 03 Jul 2026 17:59:32 +0100
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>
CC: Leonardo Bras <leo.bras@arm.com>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Quentin Perret <qperret@google.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4=5D_KVM=3A_arm64=3A_Record_whe?=
 =?US-ASCII?Q?ther_pKVM_stage_2_mapping_is_cacheable?=
In-Reply-To: <86pl15pfqa.wl-maz@kernel.org>
References: <20260701192428.17430-1-include@grrlz.net> <86qzllpy1g.wl-maz@kernel.org> <akZJIm6mTza7qAuu@LeoBrasDK> <6495D546-8FC7-4A31-B18C-88F34E1B64BB@grrlz.net> <86pl15pfqa.wl-maz@kernel.org>
Message-ID: <A209F36E-52C2-4094-9034-9046AF6CB342@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On July 2, 2026 4:34:53 PM GMT+01:00, Marc Zyngier <maz@kernel.org> wrote:
>On Thu, 02 Jul 2026 15:52:14 +0100,
>Bradley Morgan <include@grrlz.net> wrote:
>> 
>> I'll test it. If it's good. I'll do
>> 
>> Suggested-by? Or co-developed by?
>
>Sb if you want, definitely not Cdb. More importantly, I expect to you
>to follow the process described at [1]. Nothing there is optional.
>
>Thanks,
>
>	M.
>
>[1]
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst
>
>


Hey, I've reviewed your code, LGTM, in a week (or when you tell me
discussion
is over)

I'll do V5! :)

I'll see if there is any modifications I can do to shorten
it, (of course if it fixes the bug)

Thanks maz for writing the fixed patch.

Thanks!
