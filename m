Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD82FC388F9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 09:27:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1ABED20829
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 09:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6WUVsDR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ABED20829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60D644B539;
	Tue, 27 Oct 2020 05:27:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W-UHvAbuptxH; Tue, 27 Oct 2020 05:27:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 256944B541;
	Tue, 27 Oct 2020 05:27:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4A24B539
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 05:27:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xqRILABOrXOq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 05:27:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBBAB4B536
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 05:27:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AB1A820829;
 Tue, 27 Oct 2020 09:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603790827;
 bh=f/ketDv8qKEZPA7zp6NOFmUJYAFaLLPyH4EprjHh4xo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=F6WUVsDR26+F/rmvgwz1Z1P1g9xDG0fezHgdPUb110gz050drGPPGHKKsH4PY0pCy
 C/qBH66+Giz8ySjnoV4lbYt31McxK+8deGnGHND3FZ9PbRFVdCHGCrD13IREgkb0Ns
 z3YUxwLEk7Wz2d4972vqZFiKt2qJQQmiFVyHX5Hc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kXLFx-004d9q-RW; Tue, 27 Oct 2020 09:27:05 +0000
MIME-Version: 1.0
Date: Tue, 27 Oct 2020 09:27:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Allocate stage-2 pgd pages with
 GFP_KERNEL_ACCOUNT
In-Reply-To: <962c401d-4376-7ecf-1a8b-b6ad91ecfe68@redhat.com>
References: <20201026144423.24683-1-will@kernel.org>
 <962c401d-4376-7ecf-1a8b-b6ad91ecfe68@redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <bb240736aae6315df28c90463e1c8801@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
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

On 2020-10-26 23:41, Gavin Shan wrote:
> Hi Will,
> 
> On 10/27/20 1:44 AM, Will Deacon wrote:
>> For consistency with the rest of the stage-2 page-table page 
>> allocations
>> (performing using a kvm_mmu_memory_cache), ensure that __GFP_ACCOUNT 
>> is
>> included in the GFP flags for the PGD pages.
>> 
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Quentin Perret <qperret@google.com>
>> Signed-off-by: Will Deacon <will@kernel.org>
>> ---
>>   arch/arm64/kvm/hyp/pgtable.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
> 
> The patch itself looks good to me:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> Another question is why the page-table pages for hyp mode aren't
> allocated with __GFP_ACCOUNT in kvm_pgtable_hyp_init and 
> hyp_map_walker()?

Why user task would you account the hypervisor mappings to? The page 
tables
used for HYP code and data are definitely not attributable to any task.

The kvm and kvm_vcpu mappings *could* be attributed to a user task, but
the page tables are likely shared with other tasks. So who gets the 
blame?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
