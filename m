Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58267C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 12:06:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B08FB64E8F
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 12:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B08FB64E8F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26F9B4B1C1;
	Mon,  1 Feb 2021 07:06:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T2Ag7O9hyCLr; Mon,  1 Feb 2021 07:06:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A38114B398;
	Mon,  1 Feb 2021 07:06:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BADF4B1C1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 07:06:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XAhc98weAqOr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 07:06:40 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 558F94B1BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 07:06:40 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2174D64E2A;
 Mon,  1 Feb 2021 12:06:39 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l6XyX-00BGJG-1M; Mon, 01 Feb 2021 12:06:37 +0000
MIME-Version: 1.0
Date: Mon, 01 Feb 2021 12:06:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 4/8] KVM: arm64: Generate hyp relocation data
In-Reply-To: <20210201104251.5foc64qq3ewgnhuz@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
 <20210105180541.65031-5-dbrazdil@google.com>
 <20210129214325.GA195322@roeck-us.net> <87r1m2lets.wl-maz@kernel.org>
 <20210201104251.5foc64qq3ewgnhuz@google.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <12ccab367048c0df8c6bf1bf7e7d0c4f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, linux@roeck-us.net,
 kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, ardb@kernel.org,
 julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Guenter Roeck <linux@roeck-us.net>
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

Hi David,

On 2021-02-01 10:42, David Brazdil wrote:
> Thanks for writing the fix, Marc! There are no corner cases in this 
> code so
> if it boots, that should be a good indicator that all BE inputs were 
> converted.
> 
> Just one little thing I noticed below, otherwise:
> Acked-by: David Brazdil <dbrazdil@google.com>
> 
>>  arch/arm64/kvm/hyp/nvhe/Makefile     |  1 +
>>  arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 57 
>> ++++++++++++++++++++--------
>>  2 files changed, 42 insertions(+), 16 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile 
>> b/arch/arm64/kvm/hyp/nvhe/Makefile
>> index 268be1376f74..09d04dd50eb8 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
>> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
>> @@ -7,6 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
>>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
>> 
>>  hostprogs := gen-hyprel
>> +HOST_EXTRACFLAGS += -I$(srctree)/include
> This should be $(objtree), autoconf.h is generated.

Ah, well spotted. I build things in place, so it obviously never showed 
up.
Now fixed and pushed out with your Ack.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
