Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D59C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 18:52:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1768D20722
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 18:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKqrhl5k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1768D20722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B64C94B2A7;
	Thu,  3 Sep 2020 14:52:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4VhGyw5qg2ub; Thu,  3 Sep 2020 14:52:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D23664B2A2;
	Thu,  3 Sep 2020 14:52:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CFF54B286
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 14:52:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w7VwBZLOG5ew for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 14:52:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ED624B27C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 14:52:24 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DF3B320722;
 Thu,  3 Sep 2020 18:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599159143;
 bh=33H24bKLlrDl9qa1jfvRvjubHBUhhWCEM9F6yvV+zdQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=NKqrhl5khwJ8mZIQbZcC+skUExLxcQ3AmbM619x8Cs+/b7F+hZlwGfJWSQ90RD2dI
 vq3IS1gFFZmleMVYplnnynivRCgEP/Be+J2FmAod5R0DNbRXAGQoYR8q4P3RtJGpVK
 Ev0KPd8NoNxJlEv0YN3AhTEDnlEdKEEDIgObP3xw=
Date: Thu, 3 Sep 2020 19:52:19 +0100
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu, gshan@redhat.com,
	alexandru.elisei@arm.com
Subject: Re: [PATCH v3 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
Message-ID: <20200903185218.GA8176@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200825093953.26493-1-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Alex, Gavin,

On Tue, Aug 25, 2020 at 10:39:32AM +0100, Will Deacon wrote:
> This is version three of the KVM page-table rework that I previously posted
> here:
> 
>   v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
>   v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
> 
> Changes since v2 include:
> 
>   * Rebased onto -rc2, which includes the conflicting OOM blocking fixes
>   * Dropped the patch trying to "fix" the memcache in kvm_phys_addr_ioremap()

I'm away tomorrow, so I'll post a v4 next week. However, in the meantime,
I've pushed a branch which I think incorporates all of your comments here:

https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/pgtable

so if you want to kick the tyres, that's the one to use.

Cheers, and have a good weekend.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
