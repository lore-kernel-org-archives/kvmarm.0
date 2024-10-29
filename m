Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB172200BBB
	for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 03:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730174307; cv=none; b=I3lcYLHrnK1uBixInuNeK5+W6y8q/JuOS6MnwARxBbRvUJNhrw2euUwt8bs5p9K0SvkrcTUIHxjx4Rcur1UEhjZiJq7JFPWtxqBSBHP9sNxCaTXgPyZ2lWuMCag3o8QLMVTMqgAWxFqLrBV6RqV1awt3eBgoOEpKjSs6drWkNH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730174307; c=relaxed/simple;
	bh=7Ekd/O0QaKIGILJf+qxzuOHaVva0jz6qGgmLyhbE2qE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SDCKVLe7iCRPLzKsVcItIJ8z8xZnmc03YoTIToYqxCoZzBHWMHXZw+vsIDtL+Pvu079enXO1+KevQZVIdre0bOb5ItiMNjGyCcIpdK6hiVkKHCCPiyU9Mguey5KolfqsheEP1YIgowXp0O9APho3Tgbp7WdjATjxgf6sGY/TsOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XcxJs71rnz2DdVN;
	Tue, 29 Oct 2024 11:56:45 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id 737D31A016C;
	Tue, 29 Oct 2024 11:58:16 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 29 Oct 2024 11:58:15 +0800
Subject: Re: [PATCH -next] KVM: arm64: Fix possible null-ptr-deref in
 idregs_debug_show
To: Marc Zyngier <maz@kernel.org>
CC: <oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<sebott@redhat.com>, <wangweiyang2@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
References: <20241024083350.2828920-1-cuigaosheng1@huawei.com>
 <86wmhx3l34.wl-maz@kernel.org>
From: cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <f14c747d-6dc4-839c-def5-ea4f0f726e37@huawei.com>
Date: Tue, 29 Oct 2024 11:58:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86wmhx3l34.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200011.china.huawei.com (7.221.188.251)

On 2024/10/24 17:29, Marc Zyngier wrote:
> On Thu, 24 Oct 2024 09:33:50 +0100,
> Gaosheng Cui <cuigaosheng1@huawei.com> wrote:
>> The idregs_debug_show() maybe return nullptr, we need to check desc
>> before dereference it to avoid possible null pointer dereferences.
>>
>> Fixes: 410db103f6eb ("KVM: arm64: Make idregs debugfs iterator search sysreg table directly")
>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
>> ---
>>   arch/arm64/kvm/sys_regs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index ff8c4e1b847e..b1c59773b9c0 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -4135,7 +4135,7 @@ static int idregs_debug_show(struct seq_file *s, void *v)
>>   
>>   	desc = idregs_debug_find(kvm, kvm->arch.idreg_debugfs_iter);
>>   
>> -	if (!desc->name)
>> +	if (!desc || !desc->name)
>>   		return 0;
>>   
>>   	seq_printf(s, "%20s:\t%016llx\n",
> Can you show a case where this happens in practice?
>
> The check for NULL is already in idregs_debug_next(), and I don't see
> how this can actually be triggered.

I haven't found a scenario that can trigger this problem，this patch was
discovered during code review，I will try to prove it.

Thanks for your work.

>
> Thanks,
>
> 	M.
>
