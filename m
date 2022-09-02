Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5ACC38145
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 14:05:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F214083E;
	Fri,  2 Sep 2022 10:05:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YDcYeSgv9hEW; Fri,  2 Sep 2022 10:05:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F81405AA;
	Fri,  2 Sep 2022 10:05:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC1364052C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:05:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RfuBuwZdiRKS for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 10:05:31 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58A7E404FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:05:31 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D1BA4B82C10;
 Fri,  2 Sep 2022 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1319C433D7;
 Fri,  2 Sep 2022 14:05:26 +0000 (UTC)
Date: Fri, 2 Sep 2022 15:05:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v3 0/7] KVM: arm64: permit MAP_SHARED mappings with MTE
 enabled
Message-ID: <YxINo9qLJkrVk9/J@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
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

On Wed, Aug 10, 2022 at 12:30:26PM -0700, Peter Collingbourne wrote:
> I rebased Catalin's series onto -next, addressed the issues that I
> identified in the review and added the proposed userspace enablement
> patches after the series.
> 
> [1] https://lore.kernel.org/all/20220705142619.4135905-1-catalin.marinas@arm.com/
> 
> Catalin Marinas (3):
>   arm64: mte: Fix/clarify the PG_mte_tagged semantics
>   KVM: arm64: Simplify the sanitise_mte_tags() logic
>   arm64: mte: Lock a page for MTE tag initialisation
> 
> Peter Collingbourne (4):
>   mm: Add PG_arch_3 page flag

BTW, I rebased these for patches on top of 6.0-rc3 and hopefully
addressed the review comments. I pushed them here:

git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux devel/mte-pg-flags

You may have rebased them already but just in case you haven't, feel
free to pick them up from the above branch.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
