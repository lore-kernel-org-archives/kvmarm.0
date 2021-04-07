Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22317C43460
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 13:46:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F9D8613D4
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 13:46:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F9D8613D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3CA84B8C2;
	Wed,  7 Apr 2021 09:46:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tliYMyFHOscA; Wed,  7 Apr 2021 09:46:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A524B8B4;
	Wed,  7 Apr 2021 09:46:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63F574B8B1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 09:46:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id amogMJW4Maye for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 09:46:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 752B74B8A1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 09:46:44 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4CA1361382;
 Wed,  7 Apr 2021 13:46:43 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lU8W1-0065Ei-5i; Wed, 07 Apr 2021 14:46:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Minor page fault handler improvement
Date: Wed,  7 Apr 2021 14:46:38 +0100
Message-Id: <161780318317.1871386.15067995969870728434.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316041126.81860-1-gshan@redhat.com>
References: <20210316041126.81860-1-gshan@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, gshan@redhat.com,
 shan.gavin@gmail.com, linux-kernel@vger.kernel.org, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com
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

On Tue, 16 Mar 2021 12:11:23 +0800, Gavin Shan wrote:
> The series includes several minior improvements to stage-2 page fault
> handler: PATCH[1/2] are cleaning up the code. PATCH[3] don't retrieve
> the memory slot again in the page fault handler to save a bit CPU cycles.
> 
> Changelog
> =========
> v2:
>    * Rebased to 5.12.rc3 and include r-bs from Keqian  (Gavin)
>    * Drop patch to fix IPA limit boundary issue        (Keqian)
>    * Comments on why we use __gfn_to_pfn_memslot()     (Keqian)
> 
> [...]

Applied to kvm-arm64/memslot-fixes, thanks!

[1/3] KVM: arm64: Hide kvm_mmu_wp_memory_region()
      commit: eab62148478d339a37c7a6b37d34182ccf5056ad
[2/3] KVM: arm64: Use find_vma_intersection()
      commit: c728fd4ce75e9c342ea96facc5a2fe5ddb976a67
[3/3] KVM: arm64: Don't retrieve memory slot again in page fault handler
      commit: 10ba2d17d2972926c60e01dace6d7a3f8d968c4f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
