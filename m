Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF4277F2F
	for <kvmarm@lists.linux.dev>; Tue,  7 May 2024 07:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715067684; cv=none; b=kdzjJsc6hEVK9xHe8cjYWkKHaUL7rG9ZJ6/gXR/r6X539LsSvL8L9J6K/W7J4hMbZcYYfdw+840XTY63rVjoCWquRV6e2pLVM17gDnEj8N5I6cdkUsNf4naTWN8bgzHTJosiDjIBL55bHtTPzR7WBXbeg2H9PvjsFDlF+8tdLW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715067684; c=relaxed/simple;
	bh=s0uYKH7sT3FXzkClZdG3yO71HRP6nYGiBJTJ1UnI0KY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=W/nuxKVogSpQANeu4Gc6mA2LYznMsmzxuUKYKz2vBRddIHk48EaHVs+v3VFimsgWIOnhJdwxc7ejsi/JX3hBzRwqP0kWu4ewMtuHgxqbOS54i/7CMLEmSDgXvNrj4KN6WitXlXIkdn96OcaLywc3D+1rXcHIc5tlZ7nXQlRtwEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VYVWR58SCzNw23;
	Tue,  7 May 2024 15:38:27 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 343651403D2;
	Tue,  7 May 2024 15:41:13 +0800 (CST)
Received: from [10.67.110.108] (10.67.110.108) by
 kwepemd200013.china.huawei.com (7.221.188.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Tue, 7 May 2024 15:41:09 +0800
Message-ID: <cde4d448-dc9d-eaad-4a2d-a6d34bda4449@huawei.com>
Date: Tue, 7 May 2024 15:41:08 +0800
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
To: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <ardb@kernel.org>,
	<anshuman.khandual@arm.com>, <miguel.luis@oracle.com>, <joey.gouly@arm.com>,
	<ryan.roberts@arm.com>, <jeremy.linton@arm.com>, <ericchancf@google.com>,
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
From: "Liao, Chang" <liaochang1@huawei.com>
In-Reply-To: <Zjjz-tzLRC2nH51A@finisterre.sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200013.china.huawei.com (7.221.188.133)

Hi, Mark.

在 2024/5/6 23:15, Mark Brown 写道:
> On Fri, May 03, 2024 at 05:00:49PM +0100, Mark Rutland wrote:
>> On Mon, Apr 15, 2024 at 06:47:51AM +0000, Liao Chang wrote:
> 
>> +#define PSTATE_ALLINT                  pstate_field(1, 0)
> 
>> +#define set_pstate_allint(x)           asm volatile(SET_PSTATE_ALLINT(x))
> 
> Hrm, those helpers are not ideally discoverable, partly due to the
> system register description for ALLINT not providing any references to
> this being a general scheme (which is fixable there) and partly due to

Based on the Arm ISA reference manual, the instruction accessing the ALLINT
field of PSTATE uses the following encoding:
                    op0  op1   CRn    CRm    op2
MSR ALLINT, #<imm>  0b00 0b001 0b0100 0b000x 0b000

In this encoding, the 'x' represents the LSB of #<imm>, op1 is fixed as 0b001
and op2 is fixed as 0b000. With this understanding, those helpers seem like a
good approach for accessing the PSTATE.ALLINT field. I've aslo confirmed that
the binary encoding generated by those helpers is same with the encoding of v3.

> the use of __emit_inst() with a numeric literal - we should probably add
> a comment next to the __emit_inst() saying what instruction we are
> emitting
Arm Architecture Reference Manual for A-profile outlines two variants for
MSR instructions used to modify PSTATE fields direclty using immediate. The
major difference between these variants lies in the CRm field encoding:

- 4 bit immediate, examples include "MSR DAIFSET,#Imm4" and "MSR DAIFCLR,#Imm4".
  The CRm field in this variant uses the least 4 bits of immediate.
- 1 bit immediate, currently, only "MSR ALLINT,#Imm1" uses this variant.
  The CRm field uses only the least 1 bit of immediate.

The current implementation of the macro SET_PSTATE() defaults to the 1 bit
immediate variant (!!x << PSTATE_Imm_shift). Currently, this macro is used
to generate instructions accessing PAN, UAO, SSBS, TCO and DIT which require
1 bit immediate variant, hence I would say it also work for ALLINT as well.

Thanks.

-- 
BR
Liao, Chang
