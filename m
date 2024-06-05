Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CF249644
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 10:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717582208; cv=none; b=oGTJoHfJLX9xmEZY36ix+r2kCIS5kIS/VI5Xvmd8CRSsDf7exK8XnYAlScWsy6RGzY+NL0w0JxUWvGFF9SXy1PTylFRd8l2CIrjy8lVmUgkI4FoK0fjv93DU6r94Vm8IygJkdYzCAbCSzHaiD8OxgJJi3UyiPjJa5fdEWq1oKNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717582208; c=relaxed/simple;
	bh=3ExLlaLSQ0sVOpTNVr+H4S8gegN+K4KWDZWR+pIud18=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MhTKZdiPCmB5UWC74jvAyVlTPAaUS3wdWNNcIsCC4giYsiJ6ynaqWtdZ4JkxGR5ZEw4+eCEHf6d3Og6qflq0EY46lALSgnzNJdTgRhuwvpZhO7J73iKxmILa0z20QWFP8WB8YsODp7ZOUqtE3ewO+B5iOPnfgmEDQSs/zjtdBjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4VvN4x6jpPz1xsK9;
	Wed,  5 Jun 2024 17:50:57 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 167121A0188;
	Wed,  5 Jun 2024 17:52:18 +0800 (CST)
Received: from [10.67.110.108] (10.67.110.108) by
 kwepemd200013.china.huawei.com (7.221.188.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 5 Jun 2024 17:52:16 +0800
Message-ID: <3f9f0ef1-7290-21df-ef01-dc56b34a0195@huawei.com>
Date: Wed, 5 Jun 2024 17:52:16 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v3 1/8] arm64/sysreg: Add definitions for immediate
 versions of MSR ALLINT
To: Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<tglx@linutronix.de>, <ardb@kernel.org>, <anshuman.khandual@arm.com>,
	<miguel.luis@oracle.com>, <joey.gouly@arm.com>, <ryan.roberts@arm.com>,
	<jeremy.linton@arm.com>, <ericchancf@google.com>,
	<kristina.martsenko@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<shijie@os.amperecomputing.com>, <akpm@linux-foundation.org>,
	<bhe@redhat.com>, <horms@kernel.org>, <mhiramat@kernel.org>,
	<rmk+kernel@armlinux.org.uk>, <shahuang@redhat.com>,
	<takakura@valinux.co.jp>, <dianders@chromium.org>, <swboyd@chromium.org>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <reijiw@google.com>,
	<akihiko.odaki@daynix.com>, <ruanjinjie@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
References: <20240415064758.3250209-1-liaochang1@huawei.com>
 <20240415064758.3250209-2-liaochang1@huawei.com>
 <ZjUKMWPknEhLYoK8@FVFF77S0Q05N> <Zjjz-tzLRC2nH51A@finisterre.sirena.org.uk>
 <cde4d448-dc9d-eaad-4a2d-a6d34bda4449@huawei.com>
 <ZjpALOdSgu-qhshR@finisterre.sirena.org.uk>
 <e632a9ed-7659-9336-6e7f-a43c4759a7a3@huawei.com>
 <9868a5ac-ae23-4481-afe6-ba3cd8dbfa47@sirena.org.uk>
From: "Liao, Chang" <liaochang1@huawei.com>
In-Reply-To: <9868a5ac-ae23-4481-afe6-ba3cd8dbfa47@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200013.china.huawei.com (7.221.188.133)

Hi, Mark

在 2024/6/4 21:29, Mark Brown 写道:
> On Mon, Jun 03, 2024 at 11:26:39AM +0800, Liao, Chang wrote:
> 
>> Mark, Is your concern is that the series of pstate related macro name in
>> sysregs.h are lack of self-explanatory nature, which make it diffuclt to
>> understand their functionality and purpose? If so, I daft some alternative
>> macro names in the code below, looking forward to your feedback, or if you
>> have any proposal for making these helpers discoverable.
> 
> ...
> 
>> -#define SET_PSTATE(x, r)               __emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
>> +#define MSR_PSTATE_ENCODE(x, r)                __emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
> 
> Possibly, yes?  TBH I was thinking of a comment but that does have "MSR"
> in it so might come up in greps.  Not sure what others would prefer.

I am going to push revision v4 of the interrupt masking patchset, this revision
involves several improvements based on feedback and further testing:

- Addressed feedback comes form Mark Brown.

- Enrich the commit messages of patch includes major changes to provide more
  detailed explanations of the implemenations, purpose and potential result.
  This aims to improve developer understanding and reviewing efficiency.

- Revising the function names of logical interrupt masking to better reflect
  their purpose.

- Fixed bugs during local testing on platform with FEAT_NMI support.

Additionally, i note you left a feedback as below.

>...I've started looking at this in the series. There are some subtleties here, and
>I don't think the helpers in this series are quite right as-is. I will try to
get back to you next week with a description of those; it'll take a short while
to write that up correctly and clearly...

I appreciate your time and look forward your further feedback at your convenience.

Thanks.

-- 
BR
Liao, Chang
