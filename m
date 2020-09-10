Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24A9C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:58:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 34C1F20C09
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5o1zYFI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34C1F20C09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94EAC4B402;
	Thu, 10 Sep 2020 06:58:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jezoEifz0GBE; Thu, 10 Sep 2020 06:58:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 832144B38B;
	Thu, 10 Sep 2020 06:58:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B54FE4B36E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PGfdo9sQBmeE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 06:58:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C32484B280
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:58:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8582920BED;
 Thu, 10 Sep 2020 10:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599735485;
 bh=iy2v1yjQQcSFJxjJU4UyFSBo1dD7bDFl1ZPpkPlUjGc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=j5o1zYFID+vEAimlVN88FTfG9b7vC38TbqVKy0vEjmjOl/Ap7x+4QK0zIg2gBSeG9
 5O+01A0CmrZ/gE5NWMgchQWNzRK87lOCQup4v8LBN7GfnFr+Tu1w8/2HSvOx71Dsxz
 6SpjWsdNjVKN6+5nypa5Z7pjlnRETQ3hgiXCoa+Q=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kGKHD-00AeyH-GZ; Thu, 10 Sep 2020 11:58:03 +0100
MIME-Version: 1.0
Date: Thu, 10 Sep 2020 11:58:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 17/21] KVM: arm64: Convert user_mem_abort() to generic
 page-table API
In-Reply-To: <20200910105107.GA17887@willie-the-truck>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-18-will@kernel.org>
 <2ae77a66-9cc4-f4e1-9e98-a50d5891cf20@arm.com>
 <c2e5e055251db637327f81da452cea2c@kernel.org>
 <20200910105107.GA17887@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <8302f7defdcc90f74519024c3deea2a6@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, alexandru.elisei@arm.com,
 kvmarm@lists.cs.columbia.edu, qperret@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, gshan@redhat.com,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-09-10 11:51, Will Deacon wrote:
> On Wed, Sep 09, 2020 at 06:12:29PM +0100, Marc Zyngier wrote:
>> On 2020-09-09 15:20, Alexandru Elisei wrote:
>> > On 9/7/20 4:23 PM, Will Deacon wrote:
>> > > @@ -1610,62 +1605,31 @@ static int user_mem_abort(struct kvm_vcpu
>> > > *vcpu, phys_addr_t fault_ipa,
>> > >  	if (vma_pagesize == PAGE_SIZE && !force_pte)
>> > >  		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>> > >  							   &pfn, &fault_ipa);
>> > > -	if (writable)
>> > > +	if (writable) {
>> > > +		prot |= KVM_PGTABLE_PROT_W;
>> > >  		kvm_set_pfn_dirty(pfn);
>> > > +		mark_page_dirty(kvm, gfn);
>> >
>> > The previous code called mark_page_dirty() only if the vma_pagesize ==
>> > PAGE_SIZE
>> > (and writable was true, obviously). Is this supposed to fix a bug?
>> 
>> No, this is actually introducing one. mark_page_dirty() checks that 
>> there is
>> an
>> associated bitmap, and thus only happens when writing to a single 
>> page, but
>> we
>> shouldn't do it for R/O memslots, which the current code avoids. It 
>> should
>> be
>> guarded by logging_active.
> 
> gfn_to_pfn_prot() will set "writable" to false for R/O memslots, so I 
> think
> we're good here.

Ah, good point.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
