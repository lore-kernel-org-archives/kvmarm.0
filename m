Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7017160793
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 10:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715338179; cv=none; b=E2xxcWgxz0baOI69+4McJFHEQ3d89+3KYxqrETrNT/Pln4AhfZhyDT68zgm9lYD+cQr78LJUG7Y51twkyJFOmgM86rodCy51m4nLGRvo+TIWcXIz/TmmvmVoPeVQkV4Tvpq+3XqhiPGmD6kFyCDLeiTRtWBi5lCZLPi/tPMDTPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715338179; c=relaxed/simple;
	bh=BtINqOStDRilCaGDjwEvjvG1MUov81NU+KIxhB/Tg6g=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V7fg8Jcm2Vsmrej8sqQ61PI9FbZPrlncdaET/vm9uSEagwtzlVRmcbYud4TYhVF0yMeGpR84BGoTCQV+8HEYIJbu39PjmTGQXTdXQz3QegjJhWYKlf2vE6W3K5AMKT+hgQ4VOLiDXnAbk1eOm7ipd1sJxUXB2P8PHfreGi3c6Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4VbQbC2QMpz1xrJT;
	Fri, 10 May 2024 18:48:23 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 05FB314038F;
	Fri, 10 May 2024 18:49:32 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 10 May 2024 18:49:30 +0800
Subject: Re: [PATCH v4 01/30] KVM: arm64: Initialize the kvm host data's
 fpsimd_state pointer in pKVM
To: Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <will@kernel.org>, <qperret@google.com>,
	<seanjc@google.com>, <alexandru.elisei@arm.com>, <catalin.marinas@arm.com>,
	<philmd@linaro.org>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<oliver.upton@linux.dev>, <mark.rutland@arm.com>, <broonie@kernel.org>,
	<joey.gouly@arm.com>, <rananta@google.com>, <smostafa@google.com>
References: <20240423150538.2103045-1-tabba@google.com>
 <20240423150538.2103045-2-tabba@google.com>
 <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com>
 <CA+EHjTwPWP1exm_bb_bSKF154W4doZvKxk5=AqFrBkUy_UsvaQ@mail.gmail.com>
 <d1435598-9a4d-1fc0-3355-9db78e6a7e27@huawei.com>
 <CA+EHjTzoD4wXhiG-uQ2xzrZkw5fLqjdOsiE87EdY5Z1qfvF7_g@mail.gmail.com>
 <86ttj6p062.wl-maz@kernel.org>
 <CA+EHjTyFanD2R2QXy005RujcXeT3GTPRw+e4yfS77KfWbxTVRg@mail.gmail.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <f00baf9c-bdda-3bab-6f40-14900f96982b@huawei.com>
Date: Fri, 10 May 2024 18:49:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CA+EHjTyFanD2R2QXy005RujcXeT3GTPRw+e4yfS77KfWbxTVRg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/5/10 16:00, Fuad Tabba wrote:
> Hi Marc,
> 
> On Fri, May 10, 2024 at 8:59 AM Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Fri, 10 May 2024 07:44:42 +0100,
>> Fuad Tabba <tabba@google.com> wrote:
>>>
>>> Hi,
>>>
>>> On Fri, May 10, 2024 at 3:40 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
>>>>
>>>> I asked that in protected mode, how do we save the host state? It looks
>>>> to me that we only save it into EL2's private
>>>> kvm_host_data->host_ctxt.fp_regs which the host kernel isn't aware of.
>>>> How can host kernel restore the state for the current task later (e.g.,
>>>> for host userspace accesses)? What am I missing?
>>>
>>> What I'm going to say applies only to protected VMs in protected mode,
>>> i.e., non-protected VM's in protected mode use the mechanism above
>>> (kvm_arch_vcpu_load_fp()).
>>>
>>> Also, the upstream code for pKVM isn't complete yet as we're still
>>> upstreaming it, so you not being able to find something is our fault
>>> not yours :) You can find my branch of pKVM, based on the latest
>>> kvmarm/next here [1].

Thanks for sharing the details!

>>> For protected VMs, we don't want to lazily save/restore the host's
>>> fpsimd state, because that could leak information to the host that the
>>> protected guest is using fpsimd. Therefore, for protected VMs, the
>>> host fpsimd state is maintained (saved/restored) in hyp (at EL2),
>>> without the host needing to know or do anything about it.
>>
>> But I think that's a regression from the current status. It looks like
>> now that the state is really private to EL2, nothing will restore the
>> FP context on exit, while this was the case before we reworked this.

My question and concern exactly. Thanks both for confirmation.

>> It'd be good to plug this in 6.10, as this is a regression.
> 
> You're right. I'll send a patch to fix this.

Zenghui
