Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0012A25B305
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 15:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774626242; cv=none; b=OoWzxqyBNyIvL/vmT4E04k4tPgPy0U4/Qs8Ra5ZX2C4mpInqE8MGicozbQeaHX8fJBaMB2epd5aPCh+/D+Nsw4QOcFL3znyeMx0T/IafQGfKwhlt9toLx2NInEcrt4+THB7VH9fCUI9atjlaZX8S02dCjXz+2lo55fo+HVPU9Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774626242; c=relaxed/simple;
	bh=fXE/MMx0uspFWIA7+vc5yZepzmHZLk/t7ZU20s4vGXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NHogAoGmZNEikIVOHCcg1DPOmHkZIHfBK/09fqXbKzCBv4d+Em3/I4xpHgOU7/4ZwyKSZJO9F+zwgMeW7KwzPWmCrMYDCOuwFw81qXj4PrgC0qvnfjTbJSyCgeKKvoKpO0VSep1/UgETcRTkU7QAL7BnbFuLc6o8ruId0SOGiKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pQwBST6p; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pQwBST6p"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F7D635DA;
	Fri, 27 Mar 2026 08:43:54 -0700 (PDT)
Received: from [10.1.196.96] (eglon.cambridge.arm.com [10.1.196.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FC413F99C;
	Fri, 27 Mar 2026 08:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774626240; bh=fXE/MMx0uspFWIA7+vc5yZepzmHZLk/t7ZU20s4vGXU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pQwBST6pz7nGtDPhVdMnNALUQEZ94wtULP23dBhrMtku0oTJxCUoWxhDttFy/aGE2
	 4oj1qXg2dySXUmgwRgjjvOMc2PuLIs7RKPl6khpDGBGuQnUwLX9OtCHiTAN6laLIet
	 EHbCSPeejkvicgScGMfBbJwRB8MQwjD+v70FvM6k=
Message-ID: <f310e638-900e-42ec-adcf-6b42c30d9caf@arm.com>
Date: Fri, 27 Mar 2026 15:43:51 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/40] arm64: mpam: Drop the CONFIG_EXPERT restriction
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-9-ben.horgan@arm.com>
Content-Language: en-GB
From: James Morse <james.morse@arm.com>
In-Reply-To: <20260313144617.3420416-9-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ben,

On 13/03/2026 14:45, Ben Horgan wrote:
> In anticipation of MPAM being useful remove the CONFIG_EXPERT restriction.

Useful - ha! I've added a second paragraph describing why this was done, just
so it doesn't look odd in 5 years time.

| This was done to prevent the driver being enabled before the user-space
| interface was wired up.



Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
