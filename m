Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E7E5D8EE
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 03:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712804604; cv=none; b=qfqb4hAzH2QkndN7gCixms/lcp03SsDBUy5mE0bok6T9wSr9bEUfCe++RQvGFylMe87fr2Ud3G4Ncn7tV6XOQkVeXxbHjBj9RQ/9chJ04P3SbGHawbAggEoHWUb1IN7xCDkAH7lJ5K4HwGnXkpaBxgcmCCxiRQ+XNRD/LeQVTD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712804604; c=relaxed/simple;
	bh=xRMelfrmzzMwZWzOdXNiw55SjzYufb11MkWB8ITQ6cY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lFQ16SoynnCp1GxItP57FwLqMMh5ko9P+hIjmEnN5UyrgSloFJY1AfsnCSc5TkkEhajwkuaE7jqSm2urGXdxqbCuv6kgtBlpzdhcc5StYh7vu40TiwOr+uw5QAFUbUF+tsVocc7BMkQxXkzd+5diAvCZXIuDM2Jpl/39C5XEYo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4VFPZY5q3nz1RC4P;
	Thu, 11 Apr 2024 11:00:21 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 9CE0E180064;
	Thu, 11 Apr 2024 11:03:14 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 11:03:13 +0800
Subject: Re: [PATCH] KVM: arm64: Improve out-of-order sysreg table diagnostics
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
References: <20240410152503.3593890-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <806fc4cb-2f92-ac73-d230-c245a6cc92ab@huawei.com>
Date: Thu, 11 Apr 2024 11:03:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240410152503.3593890-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/4/10 23:25, Marc Zyngier wrote:
> Adding new entries to our system register tables is a painful exercise,
> as we require them to be ordered by Op0,Op1,CRn,CRm,Op2.
> 
> If an entry is misordered, we output an error that indicates the
> pointer to the entry and the number *of the last valid one*.
> 
> That's not very helpful, and would be much better if we printed the
> number of the *offending* entry as well as its name (which is present
> in the vast majority of the cases).
> 
> This makes debugging new additions to the tables much easier.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks.
