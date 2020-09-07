Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B8EC433E2
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 17:16:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88789206B8
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 17:16:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yk5M0fI5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88789206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0193D4B3EB;
	Mon,  7 Sep 2020 13:16:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OucW9ZiUkfGe; Mon,  7 Sep 2020 13:16:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E46784B4FD;
	Mon,  7 Sep 2020 13:16:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 843EF4B3EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 13:16:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CLMX+YMz3FHX for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 13:16:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4199D4B2AC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 13:16:22 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 21A9C206B8;
 Mon,  7 Sep 2020 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599498981;
 bh=bmf82iVJDze/Gx3l5Jj18tk+88NRQUUddltkFnmZ+aM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=yk5M0fI5pSwRwAK2VbvHZ0tbfm27lEvpjWo62A/tEIkxl4v6/bRfQhS2JISlTprOZ
 a4kpXpG5WLUz7j474hKWDLpPqfGqP/he8/VlFb/PjPBOmzIOKJRgisruE/WpNnQn2n
 Wt9pPUAs+mkXl3WPnRiaRJY6xlYx2V8STFxdzOLI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kFKkd-009qYX-1B; Mon, 07 Sep 2020 18:16:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
Date: Mon,  7 Sep 2020 18:16:14 +0100
Message-Id: <159949883707.112892.18214784615282984595.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907152344.12978-1-will@kernel.org>
References: <20200907152344.12978-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, 7 Sep 2020 16:23:23 +0100, Will Deacon wrote:
> Here's version four of the KVM page-table rework I previously posted here:
> 
>   v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
>   v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
>   v3: https://lore.kernel.org/r/20200825093953.26493-1-will@kernel.org
> 
> Changes since v3 include:
> 
> [...]

I have provisionally applied this to kvmarm/next in order to give it
some exposure. Please have a look at the conflict resolution with
the latest fixes though.

[01/21] KVM: arm64: Remove kvm_mmu_free_memory_caches()
        commit: 4ae8bc9bde11b8d33cba71097d0ad078310f5696
[02/21] KVM: arm64: Add stand-alone page-table walker infrastructure
        commit: 872b7ac07aca4d475b5580611d2a901c3cf81734
[03/21] KVM: arm64: Add support for creating kernel-agnostic stage-1 page tables
        commit: b12d0b7c5f340dcfb40e02a323e0c1304ac739c9
[04/21] KVM: arm64: Use generic allocator for hyp stage-1 page-tables
        commit: d0568315c2c777e38a2d6643e8ddd4f1a1135c88
[05/21] KVM: arm64: Add support for creating kernel-agnostic stage-2 page tables
        commit: b0742113046c4958d7d86ee5d5c2802aeb0b0b98
[06/21] KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table
        commit: 21c40390c7f75846f086451336245c10ae8da576
[07/21] KVM: arm64: Convert kvm_phys_addr_ioremap() to generic page-table API
        commit: 63cb38a43c88f679e58821b80c886a7bdb8e57fa
[08/21] KVM: arm64: Convert kvm_set_spte_hva() to generic page-table API
        commit: da1a8a88d33405556dfc19d90515ff548c413642
[09/21] KVM: arm64: Convert unmap_stage2_range() to generic page-table API
        commit: 7715a065a804933c050f4a2aaffd3eb1e1a8aec6
[10/21] KVM: arm64: Add support for stage-2 page-aging in generic page-table
        commit: 6b7311f0e727cb8f06a62e694a0a9a11b16475f2
[11/21] KVM: arm64: Convert page-aging and access faults to generic page-table API
        commit: 7769a437f471da1ce6482613d83e4ba2815d8a3f
[12/21] KVM: arm64: Add support for stage-2 write-protect in generic page-table
        commit: b4efa09299c0d23fde593d670e4de92ac292f72f
[13/21] KVM: arm64: Convert write-protect operation to generic page-table API
        commit: 98258e3a1f3078e8458f3216d446e8306b6d9c9a
[14/21] KVM: arm64: Add support for stage-2 cache flushing in generic page-table
        commit: 68e974981a7526551cd0a0c975578a5c65881017
[15/21] KVM: arm64: Convert memslot cache-flushing code to generic page-table API
        commit: 45fef5ebfad012b546786886dda47112960c6cdc
[16/21] KVM: arm64: Add support for relaxing stage-2 perms in generic page-table code
        commit: ecec724683c6359a66786cd4f10cb2b6b5b2eec4
[17/21] KVM: arm64: Convert user_mem_abort() to generic page-table API
        commit: 62a763bccca7ca55666650c2340c1eeb0cabbf16
[18/21] KVM: arm64: Check the pgt instead of the pgd when modifying page-table
        commit: d8267676b4bdd18fe9799f3ef4073c5719d4f596
[19/21] KVM: arm64: Remove unused page-table code
        commit: 480fc5a53118335767c56cb9836bb5fcb87e1197
[20/21] KVM: arm64: Remove unused 'pgd' field from 'struct kvm_s2_mmu'
        commit: 593411fee44965e24b4f9cd560b6e40498917237
[21/21] KVM: arm64: Don't constrain maximum IPA size based on host configuration
        commit: f8883302774bf876a76583ca1a85b15bf3e180f9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
