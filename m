Return-Path: <SRS0=O4n2=IX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA7AC433C1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 15:31:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA03261A1A
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 15:31:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA03261A1A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42A264B1B0;
	Thu, 25 Mar 2021 11:31:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jME1Q1AfEsDI; Thu, 25 Mar 2021 11:31:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E954B451;
	Thu, 25 Mar 2021 11:31:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAE724B44C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 11:31:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fnMydEpGP7HM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 11:31:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FA1C4B44A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 11:31:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1616686300;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=9lOheegThOe4f6tto8O/gDarjNWvBXusi2vH5rKfbyc=;
 b=dV8MyI0/BCG4lfGN3CvzrqDQVrE5gV22Z4XxnJngyVWnRyRvUxIteoQw0HaUWC6eSQWMy+
 AqXqkBxdfMoMXf7SDlt0+0ukNN6vMTEN8uyKbuPK5MtC3b/aYwjX5WTWsTUkTmmo7RkBh3
 2qVw9tEhuD6oHJyGVNft/ctQtdG9Ydw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-17YbFbogPT-bI07iPINu9w-1; Thu, 25 Mar 2021 11:31:35 -0400
X-MC-Unique: 17YbFbogPT-bI07iPINu9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DF2B8EDBE1;
 Thu, 25 Mar 2021 15:31:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B6AF010013D7;
 Thu, 25 Mar 2021 15:31:32 +0000 (UTC)
Date: Thu, 25 Mar 2021 16:31:29 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/6] Misc assembly fixes and cleanups
Message-ID: <20210325153129.lgeffmlqfrrkinra@kamzik.brq.redhat.com>
References: <20210322150641.58878-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210322150641.58878-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Mon, Mar 22, 2021 at 03:06:35PM +0000, Alexandru Elisei wrote:
> This series is mostly fixes and cleanups for things I found when playing
> with EFI support. Most of them I hope are fairly self-explanatory.
> 
> What is clearly aimed at running on baremetal is patch #2 ("arm/arm64:
> Remove dcache_line_size global variable"), which is needed because the
> startup environment is different for EFI apps and we're going to need to do
> cache maintenance before setup() is run.
> 
> Patch #4 ("lib: arm64: Consolidate register definitions to sysreg.h") is
> there to make importing register definitions and other header files from
> Linux (like el2_setup.h) easier by switching to the same layout. And arm
> is already using sysreg.h for SCTLR fields.
> 
> Changes in v2:
> * Gathered Reviewed-by tags, thank you!
> * For patch #2 ("arm/arm64: Remove dcache_line_size global variable"), I've
>   modified the commit message to mention the change in parameters for
>   dcache_by_line_op, I've added the proper header guards to
>   lib/arm/asm/assembler.h and I've changed raw_dcache_line_size to use ubfx
>   instead of ubfm.
> 
> Alexandru Elisei (6):
>   arm64: Remove unnecessary ISB when writing to SPSel
>   arm/arm64: Remove dcache_line_size global variable
>   arm/arm64: Remove unnecessary ISB when doing dcache maintenance
>   lib: arm64: Consolidate register definitions to sysreg.h
>   arm64: Configure SCTLR_EL1 at boot
>   arm64: Disable TTBR1_EL1 translation table walks
> 
>  lib/arm/asm/assembler.h       | 53 ++++++++++++++++++++++++++++++++++
>  lib/arm/asm/processor.h       |  7 -----
>  lib/arm64/asm/arch_gicv3.h    |  6 ----
>  lib/arm64/asm/assembler.h     | 54 +++++++++++++++++++++++++++++++++++
>  lib/arm64/asm/pgtable-hwdef.h |  1 +
>  lib/arm64/asm/processor.h     | 17 -----------
>  lib/arm64/asm/sysreg.h        | 24 ++++++++++++++++
>  lib/arm/setup.c               |  7 -----
>  arm/cstart.S                  | 19 ++----------
>  arm/cstart64.S                | 28 +++++++-----------
>  10 files changed, 145 insertions(+), 71 deletions(-)
>  create mode 100644 lib/arm/asm/assembler.h
>  create mode 100644 lib/arm64/asm/assembler.h
> 
> -- 
> 2.31.0
>

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
