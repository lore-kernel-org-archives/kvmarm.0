Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6FCC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 07:31:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E511960ED6
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 07:31:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E511960ED6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FF574B0CE;
	Fri,  8 Oct 2021 03:31:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fOv+72ngZuRI; Fri,  8 Oct 2021 03:31:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4724B103;
	Fri,  8 Oct 2021 03:31:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 338544B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 03:31:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id li7v4ohBHJ0f for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 03:31:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 344594086D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 03:31:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3F6F361039;
 Fri,  8 Oct 2021 07:31:13 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mYkLX-00FU0a-7G; Fri, 08 Oct 2021 08:31:11 +0100
MIME-Version: 1.0
Date: Fri, 08 Oct 2021 08:31:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Disable privileged hypercalls after
 pKVM finalisation
In-Reply-To: <20211008072722.GA32625@willie-the-truck>
References: <20211005113721.29441-1-will@kernel.org>
 <20211005113721.29441-6-will@kernel.org> <877depq9gw.wl-maz@kernel.org>
 <20211008072722.GA32625@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <cf74e6afcf1988ab7fcb87eb20bb2947@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, linux-arm-kernel@lists.infradead.org,
 qperret@google.com, catalin.marinas@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 2021-10-08 08:27, Will Deacon wrote:
> On Thu, Oct 07, 2021 at 01:56:47PM +0100, Marc Zyngier wrote:
>> On Tue, 05 Oct 2021 12:37:21 +0100,
>> Will Deacon <will@kernel.org> wrote:
>> >
>> This is no helping with the above, but can we *please* try to get rid
>> of this #define insanity before moving things around? I came up with
>> the following, which seems to build.
>> 
>> Thoughts?
>> 
>> 	M.
>> 
>> From 8a50c98489220d2ebaf02d4ffdbef3cf0d6634ee Mon Sep 17 00:00:00 2001
>> From: Marc Zyngier <maz@kernel.org>
>> Date: Thu, 7 Oct 2021 13:18:29 +0100
>> Subject: [PATCH] KVM: arm64: Turn __KVM_HOST_SMCCC_FUNC_* into an enum
>>  (mostly)
>> 
>> __KVM_HOST_SMCCC_FUNC_* is a royal pain, as there is a fair amount
>> of churn around these #defines, and we avoid making it an enum
>> only for the sake of the early init, low level code that requires
>> __KVM_HOST_SMCCC_FUNC___kvm_hyp_init to be usable from assembly.
>> 
>> Let's be brave and turn everything but this symbol into an enum,
>> using a bit of arithmetic to avoid any overlap.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/kvm_asm.h | 44 
>> +++++++++++++++++---------------
>>  1 file changed, 24 insertions(+), 20 deletions(-)
> 
> Looks fine to me:
> 
> Acked-by: Will Deacon <will@kernel.org>
> 
> Do you need me to respin my series on top of this?

If you don't mind, that'd make my life easier.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
