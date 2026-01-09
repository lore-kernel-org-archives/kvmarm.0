Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178922737EB
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 06:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767938783; cv=none; b=uepChPF11Nma4nKCLlCqnE1k0GhUxzCwHaR4pSc+HhT4AeR2X4NcomaIqVLu+BxuvzlLlb1MdtpUAoMwhV57tfyPt370ixk92/UKXuOSXQeSYKzUz8ZIa5JU+opHQquSQuZJ3DruvcaBv/jmwBj1mskaLeKhOOfM0Rd+En3AKdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767938783; c=relaxed/simple;
	bh=vNqx6kqKBOimJsrj89LpYH4yxzxhesKzXCV8g4R6Kew=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gbRcJqZ+OLu+4WaCJbz8r2HD8Uwhqr1UQ6DzYHZgXuFeZc4sz8cFtoBIQRS8o+ea7O6DmMqTo/bCM3qSX8Wld+9oOyY1ym5yRD+0pnMTkKqxnawcuAG4t71QKZiak1n22kRuLZU+GCGGehqWnxPgbGT3Okt/7k8tRgxAPuGrLGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=5slUs5Wa; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="5slUs5Wa"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Qgp72385LGLdMRsHkh4r7fySKyjZ32QFPwk6d0+hg3k=;
	b=5slUs5WaTSoRNVYBRNm8hGG21c8xx6wabHJ42URk36SU0b7vUvKwMZ30+5zCNKtZNQKLBAXPw
	uyzqnfd7PkdsdUbnKsyrlUBFmi68/nc5ebQuIwCRxhDlb+yBvcizbd7vdMIUtTk8kKSzYSoVHwa
	gTyENKbD/kXNpPi1Xu8Wzbo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dnWQs4RxyzRhQQ;
	Fri,  9 Jan 2026 14:03:01 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 65D1240569;
	Fri,  9 Jan 2026 14:06:18 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Jan 2026 14:06:17 +0800
Subject: Re: [PATCH] KVM: arm64: remove unused vcpu_{clear,set}_wfx_traps()
To: Dongxu Sun <sundongxu1024@163.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20260109025837.754242-1-sundongxu1024@163.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d4f231b7-f170-c456-3fbd-0063891378fe@huawei.com>
Date: Fri, 9 Jan 2026 14:06:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260109025837.754242-1-sundongxu1024@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200017.china.huawei.com (7.202.194.83)

s/remove/Remove/ in the Subject.

On 2026/1/9 10:58, Dongxu Sun wrote:
> Function vcpu_{clear,set}_wfx_traps() are unused since
> commit 0b5afe05377d7 ("KVM: arm64: Add early_param to control WFx trapping")

checkpatch WARNING: Prefer a maximum 75 chars per line (possible
unwrapped commit description?)

> Remove it.
> 
> Signed-off-by: Dongxu Sun <sundongxu1024@163.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 16 ----------------
>  1 file changed, 16 deletions(-)

Otherwise,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks,
Zenghui
