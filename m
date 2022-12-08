Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3910C4708E
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 02:15:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 529E64B8B6;
	Wed,  7 Dec 2022 21:15:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZgqCaj0DHdju; Wed,  7 Dec 2022 21:15:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 039734B8D7;
	Wed,  7 Dec 2022 21:15:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E761B4B8AA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 21:15:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZ+hH+ZjImIF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 21:15:33 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6B774018F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 21:15:32 -0500 (EST)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.53])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NSHlw69hRzRpnZ;
 Thu,  8 Dec 2022 10:14:36 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 10:15:27 +0800
Subject: Re: [PATCH v14 16/39] arm64/sme: Implement traps and syscall handling
 for SME
To: Mark Brown <broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220419112247.711548-17-broonie@kernel.org>
 <e57552ea-37fb-07da-8560-e26bae8205cd@huawei.com>
 <Y5CgRPbjOChpHQEJ@sirena.org.uk>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <dfcbafc2-17e1-94e8-b890-8ced1c0bcdc8@huawei.com>
Date: Thu, 8 Dec 2022 10:15:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <Y5CgRPbjOChpHQEJ@sirena.org.uk>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Luca Salabrino <luca.scalabrino@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022/12/7 22:16, Mark Brown wrote:
> On Wed, Dec 07, 2022 at 10:00:17PM +0800, Zenghui Yu wrote:
>> On 2022/4/19 19:22, Mark Brown wrote:
> 
>>> +	/*
>>> +	 * If SME is active then exit streaming mode.  If ZA is active
>>> +	 * then flush the SVE registers but leave userspace access to
>>> +	 * both SVE and SME enabled, otherwise disable SME for the
>>> +	 * task and fall through to disabling SVE too.  This means
> 
>> It looks a bit confusing to me that in the current implementation, if
>> ZA is *not* active, we don't actually go to disable SME for the task
>> (which IMHO can be disabled as user-space is not actively using it now).
> 
> Unlike SVE there's no overhead from leaving SME enabled, the enable bits
> for SM and ZA tell us if there is extra register state to be saved so we
> don't have to worry about the costs there like we do with SVE.  The only
> reason for not just unconditionally enabling SME is the potentially
> large backing storage required for the registers, if a task isn't using
> SME there's no need to impose that overhead.  If we disable SME for
> userspace after the storage has been allocated then we just require an
> additional trip through EL1 to reenable it for any future usage which
> would hurt performance but not really gain us anything otherwise.  We
> don't want to discurage applications from disabling ZA when not in use
> given that there's likely to be physical overheads from keeping it
> enabled.

Ah, thanks a lot for the explanations. The comment itself can be
improved though (I think).

>>> +		if (svcr & SYS_SVCR_EL0_SM_MASK)
>>> +			sme_smstop_sm();
> 
>> As per the SME syscall ABI
> 
>> | On syscall PSTATE.SM will be cleared and the SVE registers will be
>> | handled as per the standard SVE ABI.
> 
>> and the SVE syscall ABI
> 
>> | On syscall, V0..V31 are preserved (as without SVE).  Thus, bits
>> | [127:0] of Z0..Z31 are preserved.  All other bits of Z0..Z31, and all
>> | of P0..P15 and FFR become zero on return from a syscall.
> 
>> Can we infer from the documentation that V0-V31 should be preserved on
>> return from a syscall? But with sme_smstop_sm(), all implemented bits of
>> Z0-Z31 are set to zero by hardware. Is this intentional?
> 
>> Please fix me up if I've mis-read things here.
> 
> No, the intention is to say that we exit streaming mode and then handle
> things as per the non-streaming ABI.  Exiting streaming mode has the
> effect of clearing the values as you say.

Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
