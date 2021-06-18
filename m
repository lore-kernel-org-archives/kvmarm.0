Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C6EC48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 15:43:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7637761245
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 15:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7637761245
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE33407F1;
	Fri, 18 Jun 2021 11:43:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XCQzr9GoDfvS; Fri, 18 Jun 2021 11:43:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEE2C4A51D;
	Fri, 18 Jun 2021 11:43:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E33B64A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 11:43:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZYe-RPCazt67 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 11:42:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C75FC407F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 11:42:59 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B71CF61222;
 Fri, 18 Jun 2021 15:42:58 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1luGe0-008TnC-Er; Fri, 18 Jun 2021 16:42:57 +0100
MIME-Version: 1.0
Date: Fri, 18 Jun 2021 16:42:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v16 1/7] arm64: mte: Handle race when synchronising tags
In-Reply-To: <20210618144013.GE16116@arm.com>
References: <20210618132826.54670-1-steven.price@arm.com>
 <20210618132826.54670-2-steven.price@arm.com>
 <20210618144013.GE16116@arm.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <3551d8ea9c9464e982d75acdd5f855b4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, steven.price@arm.com,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Dave.Martin@arm.com, mark.rutland@arm.com, tglx@linutronix.de,
 qemu-devel@nongnu.org, quintela@redhat.com, dgilbert@redhat.com,
 richard.henderson@linaro.org, peter.maydell@linaro.org, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 2021-06-18 15:40, Catalin Marinas wrote:
> On Fri, Jun 18, 2021 at 02:28:20PM +0100, Steven Price wrote:
>> mte_sync_tags() used test_and_set_bit() to set the PG_mte_tagged flag
>> before restoring/zeroing the MTE tags. However if another thread were 
>> to
>> race and attempt to sync the tags on the same page before the first
>> thread had completed restoring/zeroing then it would see the flag is
>> already set and continue without waiting. This would potentially 
>> expose
>> the previous contents of the tags to user space, and cause any updates
>> that user space makes before the restoring/zeroing has completed to
>> potentially be lost.
>> 
>> Since this code is run from atomic contexts we can't just lock the 
>> page
>> during the process. Instead implement a new (global) spinlock to 
>> protect
>> the mte_sync_page_tags() function.
>> 
>> Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped 
>> in user-space with PROT_MTE")
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> Although I reviewed this patch, I think we should drop it from this
> series and restart the discussion with the Chromium guys on what/if 
> they
> need PROT_MTE with MAP_SHARED. It currently breaks if you have two
> PROT_MTE mappings but if they are ok with only one of the mappings 
> being
> PROT_MTE, I'm happy to just document it.
> 
> Not sure whether subsequent patches depend on it though.

I'd certainly like it to be independent of the KVM series, specially
as this series is pretty explicit that this MTE lock is not required
for KVM.

This will require some rework of patch #2, I believe. And while we're
at it, a rebase on 5.13-rc4 wouldn't hurt, as both patches #3 and #5
conflict with it...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
