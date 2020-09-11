Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E93C433E2
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 15:04:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24F6C2244C
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 15:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVtgmmJ0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24F6C2244C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86C224B185;
	Fri, 11 Sep 2020 11:04:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PUfZbRtuDrfC; Fri, 11 Sep 2020 11:04:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3909C4B18B;
	Fri, 11 Sep 2020 11:04:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0AF64B177
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 11:04:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gpY+fLcQWFTj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 11:04:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A339C4B172
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 11:04:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 625AB2245F;
 Fri, 11 Sep 2020 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599836671;
 bh=bnviOPmTfMgGHd62yRWNqKOXo3hYQwcQqrnx5xUlhjs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EVtgmmJ0CPy7gL73cWh9h9zw/3Zt/ZdJwhG8W5mgh7xlPmX+CBk9rnrVN5ShdU63o
 geXEkW9cq2dEDKtjNVuB3Q4Aln928mH9Mlia8EpQL4JAEMiOYT7NSpDn2nwDhZS2Qp
 LvmXZLg83NVfU4m/5pgnDbVrr/q6HWzPvEQNNkGc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kGkbF-00B16w-HX; Fri, 11 Sep 2020 16:04:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v5 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
Date: Fri, 11 Sep 2020 16:04:23 +0100
Message-Id: <159983659550.1978092.16804121328891667872.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911132529.19844-1-will@kernel.org>
References: <20200911132529.19844-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 kernel-team@android.com
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

On Fri, 11 Sep 2020 14:25:08 +0100, Will Deacon wrote:
> It's me again, with version five of the KVM page-table rework previously
> seen at:
> 
>   v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
>   v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
>   v3: https://lore.kernel.org/r/20200825093953.26493-1-will@kernel.org
>   v4: https://lore.kernel.org/r/20200907152344.12978-1-will@kernel.org
> 
> [...]

As for last time, I've just pushed that it -next so that it simmers
for a while.

[01/21] KVM: arm64: Remove kvm_mmu_free_memory_caches()
        commit: 9af3e08baa7c20ee69b7fc18e720e08a091493b9
[02/21] KVM: arm64: Add stand-alone page-table walker infrastructure
        commit: b1e57de62cfb4d05f45ab848bb893fbcff9557d3
[03/21] KVM: arm64: Add support for creating kernel-agnostic stage-1 page tables
        commit: bb0e92cbbcd1f91411d0a7241f8febe2c8c5b078
[04/21] KVM: arm64: Use generic allocator for hyp stage-1 page-tables
        commit: 0f9d09b8e29bc8166f6584279aedc4a7a4038f68
[05/21] KVM: arm64: Add support for creating kernel-agnostic stage-2 page tables
        commit: 71233d05f4b5e3560f0d3d5607d01e9beff8dcbd
[06/21] KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table
        commit: 6d9d2115c48027132a69477c98d812be669f5b9b
[07/21] KVM: arm64: Convert kvm_phys_addr_ioremap() to generic page-table API
        commit: 02bbd374ce4a8aad36c022fd1203cb9f11b52ee3
[08/21] KVM: arm64: Convert kvm_set_spte_hva() to generic page-table API
        commit: e9edb17ae0a2634bfa5dac529229c06f97f2b669
[09/21] KVM: arm64: Convert unmap_stage2_range() to generic page-table API
        commit: 52bae936f0e7be4b4c088505aecb8f04121f1dee
[10/21] KVM: arm64: Add support for stage-2 page-aging in generic page-table
        commit: e0e5a07f3f5adca259ffa8ad3f4153ab448a4115
[11/21] KVM: arm64: Convert page-aging and access faults to generic page-table API
        commit: ee8efad7994ce204806260bc0261c7e103f704c1
[12/21] KVM: arm64: Add support for stage-2 write-protect in generic page-table
        commit: 73d49df2c3e7cad5bf64c92ec03ce9e3823898b9
[13/21] KVM: arm64: Convert write-protect operation to generic page-table API
        commit: cc38d61cace392a5f064f2981ce6009bb158de21
[14/21] KVM: arm64: Add support for stage-2 cache flushing in generic page-table
        commit: 93c66b40d728178722706a306df15ce92c819cd6
[15/21] KVM: arm64: Convert memslot cache-flushing code to generic page-table API
        commit: 8d5207bef6913b5fac91cb58e509711e406c160d
[16/21] KVM: arm64: Add support for relaxing stage-2 perms in generic page-table code
        commit: adcd4e23291e67575be0c8b08eed04fbe7fd9e77
[17/21] KVM: arm64: Convert user_mem_abort() to generic page-table API
        commit: 6f745f1bb5bf2914be2344b0dd7781d0528b3e42
[18/21] KVM: arm64: Check the pgt instead of the pgd when modifying page-table
        commit: 063deeb1f2c234ca5e9d156c7a86825fc5377477
[19/21] KVM: arm64: Remove unused page-table code
        commit: 3f26ab58e3272ceada11279c2e90894d4995cf79
[20/21] KVM: arm64: Remove unused 'pgd' field from 'struct kvm_s2_mmu'
        commit: 74cfa7ea66a7e54a5ea1d8ad1fb74a5e832ed867
[21/21] KVM: arm64: Don't constrain maximum IPA size based on host configuration
        commit: c9b69a0cf0b4336fe7d2e35c46273debc68910fd

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
