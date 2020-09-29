Return-Path: <SRS0=H5U9=DG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327CDC4727C
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 17:46:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5DEE62145D
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 17:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANSra6H4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DEE62145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B35674B255;
	Tue, 29 Sep 2020 13:46:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F6u89--QwJmF; Tue, 29 Sep 2020 13:46:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B134B239;
	Tue, 29 Sep 2020 13:46:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 105F34B226
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 13:46:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7B-6jab0DDM4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2020 13:46:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 056094B223
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 13:46:27 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B1485207F7;
 Tue, 29 Sep 2020 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601401585;
 bh=Eygb0b3lGWlgqkHSLZz5ftXfR6UVNqbZY53CkkEuGME=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ANSra6H4xGSHUFI7hYAnAt1P73+jiHWeE3tEvS93Fzj96VdhSDsD+vcopQcIBnEj2
 njZKuVe2AWaCC63qSJT/rItjjfCKlWU+gpuBoHKnJHy3xWJ5zmaY2qyjFrIBOS/M9L
 slpvSN2E7Mo9Vf01eUrE3jhf05OCf8mXPaUkBjBw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kNJhn-00FxNf-Tk; Tue, 29 Sep 2020 18:46:24 +0100
MIME-Version: 1.0
Date: Tue, 29 Sep 2020 18:46:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 05/10] kvm: arm64: Remove hyp_adr/ldr_this_cpu
In-Reply-To: <20200929173407.GC14317@willie-the-truck>
References: <20200922204910.7265-1-dbrazdil@google.com>
 <20200922204910.7265-6-dbrazdil@google.com>
 <20200929173407.GC14317@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <2221d6a88c4077b7e0a4ce2ac5f50a45@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, dbrazdil@google.com,
 kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, dennis@kernel.org,
 tj@kernel.org, cl@linux.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kernel-team@android.com, ascull@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On 2020-09-29 18:34, Will Deacon wrote:
> On Tue, Sep 22, 2020 at 09:49:05PM +0100, David Brazdil wrote:
>> The hyp_adr/ldr_this_cpu helpers were introduced for use in hyp code
>> because they always needed to use TPIDR_EL2 for base, while
>> adr/ldr_this_cpu from kernel proper would select between TPIDR_EL2 and
>> _EL1 based on VHE/nVHE.
>> 
>> Simplify this now that the hyp mode case can be handled using the
>> __KVM_VHE/NVHE_HYPERVISOR__ macros.
>> 
>> Acked-by: Andrew Scull <ascull@google.com>
>> Acked-by: Will Deacon <will@kernel.org>
>> Signed-off-by: David Brazdil <dbrazdil@google.com>
>> ---
>>  arch/arm64/include/asm/assembler.h | 29 +++++++++++++++++++----------
>>  arch/arm64/include/asm/kvm_asm.h   | 14 +-------------
>>  arch/arm64/kvm/hyp/hyp-entry.S     |  2 +-
>>  3 files changed, 21 insertions(+), 24 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/assembler.h 
>> b/arch/arm64/include/asm/assembler.h
>> index 54d181177656..86e0ef79a799 100644
>> --- a/arch/arm64/include/asm/assembler.h
>> +++ b/arch/arm64/include/asm/assembler.h
>> @@ -218,6 +218,23 @@ lr	.req	x30		// link register
>>  	str	\src, [\tmp, :lo12:\sym]
>>  	.endm
>> 
>> +	/*
>> +	 * @dst: destination register (32 or 64 bit wide)
> 
> nit: this comment is wrong as I don't think mrs can take a W register
> as the destination argument. I'm assuming Marc can fix that up.

Indeed. I'll fix it locally.

Another thing is that this patch is going to clash with the Ghostbuster
branch (the hyp-entry.S hunk goes), but we can deal with that.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
