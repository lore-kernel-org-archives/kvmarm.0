Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BD5C433E1
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 07:52:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 730502250E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 07:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAuLLRAG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 730502250E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C5524B8EB;
	Tue, 28 Jul 2020 03:52:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZFhgeHbcLr42; Tue, 28 Jul 2020 03:52:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 069BC4B8E0;
	Tue, 28 Jul 2020 03:52:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA43B4B8DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 03:52:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 36on0qILguRA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 03:52:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A08554B8D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 03:52:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7966E20714;
 Tue, 28 Jul 2020 07:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595922744;
 bh=T3T/i9s4kjXiGBww2mdjvGIltFK2CfgJhwpaoNpxtYs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=JAuLLRAGqGuJBARRLhEZRnOsDgzjPBZnogBSZIG3DOc04fB1pr/xvSrGUZJvIoCCP
 50Bd94dzrgSr1A97/tpE8AREwFufG/ifQ05pfUIqNVttmCCXymptLX/6Jhe6145i3X
 gp8esyQfdvx25uGba2IeA9i/j5JJU73LU4d5fv/o=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k0KPP-00Fa5B-3X; Tue, 28 Jul 2020 08:52:23 +0100
MIME-Version: 1.0
Date: Tue, 28 Jul 2020 08:52:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: zhukeqian <zhukeqian1@huawei.com>
Subject: Re: [PATCH v2 0/8] KVM: arm64: Support HW dirty log based on DBM
In-Reply-To: <884bd32d-c8ba-6237-82f6-1769a83289f5@huawei.com>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
 <e120ec04-24d5-f1cb-3aa2-8baf3d6da1db@huawei.com>
 <015847afd67e8bd4f8a158b604854838@kernel.org>
 <4eee3e4c-db73-c4ce-ca3d-d665ee87d66a@huawei.com>
 <87mu43xy94.wl-maz@kernel.org>
 <884bd32d-c8ba-6237-82f6-1769a83289f5@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <2a81b2a0e1bd1e7523760a8074b9ec6e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

On 2020-07-28 03:11, zhukeqian wrote:
> Hi Marc,

[...]

>> But you are still reading the leaf entries of the PTs, hence defeating
>> any sort of prefetch that the CPU could do for you. And my claim is
>> that reading the bitmap is much faster than parsing the PTs. Are you
>> saying that this isn't the case?
> I am confused here. MMU DBM just updates the S2AP[1] of PTs, so dirty
> information
> is not continuous. The smallest granularity of read instruction is one
> byte, we must
> read one byte of each PTE to determine whether it is dirty. So I think
> the smallest
> reading amount is 512 bytes per 2MB.

Which is why using DBM as a way to implement dirty-logging doesn't work.
Forcing the vcpu to take faults in order to update the dirty bitmap
has the benefit of (a) telling you exactly what page has been written 
to,
(b) *slowing the vcpu down*.

See? no additional read, better convergence ratio because you are not
trying to catch up with a vcpu running wild. You are in control of the
dirtying rate, not the vcpu, and the information you get requires no
extra work (just set the corresponding bit in the dirty bitmap).

Honestly, I think you are looking at the problem the wrong way.
DBM at S2 is not a solution to anything, because the information is
way too sparse, and  it doesn't solve the real problem, which is
the tracking of dirty pages caused by devices.

As I said twice before, I will not consider these patches without
a solution to the DMA problem, and I don't think DBM is part of
that solution.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
