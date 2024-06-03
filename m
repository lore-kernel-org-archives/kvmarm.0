Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358ABF4FA
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 03:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717385213; cv=none; b=eWxz4vhMu5/qBjSa7Z9Z/mtX1Ol6t2Bgfnm0IT0ENOyLWh6ffnAXdvL5MO48rARq14yzU8CdPdFuAqLqHzyff3KWvY2sLpjtLa+wtF50EZeHJoiToljCn1QLy7aFFfMhUMdpt3zc0f6k10NSSGYG6gCAUo6BE6485sJq93Dj9zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717385213; c=relaxed/simple;
	bh=4AxKANIPQDldK4oFGsXikmc5DVLnqvzkXVQP6Ec3lKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dnQe01KdE/Gx+KzGaKRJV6lBroO/v3zm9Mwu7RhnwoWfthBrBD0IObVAya5ETbbAqSqsh20hjJo/QrXH+eSAfL2etKVo2IndqEUAWHt91CfVbJZXjTfLmNdyI5jNDUigMdSXjtikyKqqkQTQw1t3wYwOfXqSLLEzXexDtYZr6xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VszYz3Y5CzxRJd;
	Mon,  3 Jun 2024 11:22:47 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id B3C08180085;
	Mon,  3 Jun 2024 11:26:41 +0800 (CST)
Received: from [10.67.110.108] (10.67.110.108) by
 kwepemd200013.china.huawei.com (7.221.188.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 3 Jun 2024 11:26:40 +0800
Message-ID: <e632a9ed-7659-9336-6e7f-a43c4759a7a3@huawei.com>
Date: Mon, 3 Jun 2024 11:26:39 +0800
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
From: "Liao, Chang" <liaochang1@huawei.com>
In-Reply-To: <ZjpALOdSgu-qhshR@finisterre.sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200013.china.huawei.com (7.221.188.133)

Hi, Mark

在 2024/5/7 22:52, Mark Brown 写道:
> On Tue, May 07, 2024 at 03:41:08PM +0800, Liao, Chang wrote:
>> 在 2024/5/6 23:15, Mark Brown 写道:
>>> On Fri, May 03, 2024 at 05:00:49PM +0100, Mark Rutland wrote:
> 
>>>> +#define set_pstate_allint(x)           asm volatile(SET_PSTATE_ALLINT(x))
> 
>>> Hrm, those helpers are not ideally discoverable, partly due to the
>>> system register description for ALLINT not providing any references to
>>> this being a general scheme (which is fixable there) and partly due to
> 
>> Based on the Arm ISA reference manual, the instruction accessing the ALLINT
>> field of PSTATE uses the following encoding:
> 
> I'm not saying the suggestion is wrong, I'm saying that between the ARM
> and the way the code is written the helpers aren't as discoverable as
> they should be, like I say from a code point of view that's mainly
> because...
> 
>>                     op0  op1   CRn    CRm    op2
>> MSR ALLINT, #<imm>  0b00 0b001 0b0100 0b000x 0b000
> 
> ...we only have the encoding for the MSR and don't mention the letters
> 'msr' anywhere.  We should improve that to say what we're encoding in
> the code (in general I'd say that's true for any __emit_inst(), not just
> these ones).

Oh, I apologize any confusion in my previous message.

Mark, Is your concern is that the series of pstate related macro name in
sysregs.h are lack of self-explanatory nature, which make it diffuclt to
understand their functionality and purpose? If so, I daft some alternative
macro names in the code below, looking forward to your feedback, or if you
have any proposal for making these helpers discoverable.

----8<----
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 643e2ad73cbd..4f514bdfb1bd 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -90,7 +90,7 @@
  */
 #define pstate_field(op1, op2)         ((op1) << Op1_shift | (op2) << Op2_shift)
 #define PSTATE_Imm_shift               CRm_shift
-#define SET_PSTATE(x, r)               __emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
+#define MSR_PSTATE_ENCODE(x, r)                __emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))

 #define PSTATE_PAN                     pstate_field(0, 4)
 #define PSTATE_UAO                     pstate_field(0, 3)
@@ -99,18 +99,18 @@
 #define PSTATE_TCO                     pstate_field(3, 4)
 #define PSTATE_ALLINT                  pstate_field(1, 0)

-#define SET_PSTATE_PAN(x)              SET_PSTATE((x), PAN)
-#define SET_PSTATE_UAO(x)              SET_PSTATE((x), UAO)
-#define SET_PSTATE_SSBS(x)             SET_PSTATE((x), SSBS)
-#define SET_PSTATE_DIT(x)              SET_PSTATE((x), DIT)
-#define SET_PSTATE_TCO(x)              SET_PSTATE((x), TCO)
-#define SET_PSTATE_ALLINT(x)           SET_PSTATE((x), ALLINT)
-
-#define set_pstate_pan(x)              asm volatile(SET_PSTATE_PAN(x))
-#define set_pstate_uao(x)              asm volatile(SET_PSTATE_UAO(x))
-#define set_pstate_ssbs(x)             asm volatile(SET_PSTATE_SSBS(x))
-#define set_pstate_dit(x)              asm volatile(SET_PSTATE_DIT(x))
-#define set_pstate_allint(x)           asm volatile(SET_PSTATE_ALLINT(x))
+#define MSR_PSTATE_PAN(x)              MSR_PSTATE_ENCODE((x), PAN)
+#define MSR_PSTATE_UAO(x)              MSR_PSTATE_ENCODE((x), UAO)
+#define MSR_PSTATE_SSBS(x)             MSR_PSTATE_ENCODE((x), SSBS)
+#define MSR_PSTATE_DIT(x)              MSR_PSTATE_ENCODE((x), DIT)
+#define MSR_PSTATE_TCO(x)              MSR_PSTATE_ENCODE((x), TCO)
+#define MSR_PSTATE_ALLINT(x)           MSR_PSTATE_ENCODE((x), ALLINT)
+
+#define msr_pstate_pan(x)              asm volatile(MSR_PSTATE_PAN(x))
+#define msr_pstate_uao(x)              asm volatile(MSR_PSTATE_UAO(x))
+#define msr_pstate_ssbs(x)             asm volatile(MSR_PSTATE_SSBS(x))
+#define msr_pstate_dit(x)              asm volatile(MSR_PSTATE_DIT(x))
+#define msr_pstate_allint(x)           asm volatile(MSR_PSTATE_ALLINT(x))
---->8----

Thanks.

-- 
BR
Liao, Chang
