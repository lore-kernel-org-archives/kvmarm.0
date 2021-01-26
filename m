Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF6DC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:18:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21F0C22B51
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21F0C22B51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A790E4B2CC;
	Tue, 26 Jan 2021 09:18:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eTPkKsPARZAS; Tue, 26 Jan 2021 09:18:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7954B2D2;
	Tue, 26 Jan 2021 09:18:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FB64B2CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:18:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c7BcO4XT5wFU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 09:18:25 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FD004B2C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:18:25 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EBD0822D58;
 Tue, 26 Jan 2021 14:18:23 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l4PAj-00A97b-WE; Tue, 26 Jan 2021 14:18:22 +0000
MIME-Version: 1.0
Date: Tue, 26 Jan 2021 14:18:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [RFC PATCH v1 0/5] Enable CPU TTRem feature for stage-2
In-Reply-To: <20210126134202.381996-1-wangyanan55@huawei.com>
References: <20210126134202.381996-1-wangyanan55@huawei.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <cc15dabd0d7e0cb25d58101803e2c9a4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangyanan55@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
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

Hi Yanan,

On 2021-01-26 13:41, Yanan Wang wrote:
> Hi all,
> This series enable CPU TTRem feature for stage-2 page table and a RFC 
> is sent
> for some comments, thanks.
> 
> The ARMv8.4 TTRem feature offers 3 levels of support when changing 
> block
> size without changing any other parameters that are listed as requiring 
> use
> of break-before-make. And I found that maybe we can use this feature to 
> make
> some improvement for stage-2 page table and the following explains what
> TTRem exactly does for the improvement.
> 
> If migration of a VM with hugepages is canceled midway, KVM will adjust 
> the
> stage-2 table mappings back to block mappings. We currently use BBM to 
> replace
> the table entry with a block entry. Take adjustment of 1G block mapping 
> as an
> example, with BBM procedures, we have to invalidate the old table entry 
> first,
> flush TLB and unmap the old table mappings, right before installing the 
> new
> block entry.

In all honesty, I think the amount of work that is getting added to
support this "migration cancelled mid-way" use case is getting out
of control.

This is adding a complexity and corner cases for a use case that
really shouldn't happen that often. And it is adding it at the worse
possible place, where we really should keep things as straightforward
as possible.

I would expect userspace to have a good enough knowledge of whether
the migration is likely to succeed, and not to attempt it if it is
likely to fail. And yes, it will fail sometimes. But it should be
so rare that adding this various stages of BBM support shouldn't be
that useful.

Or is there something else that I am missing?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
