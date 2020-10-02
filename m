Return-Path: <SRS0=jAo2=DJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1308C4727D
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 14:36:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C11D206FA
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 14:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UzyWzjrD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C11D206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C3B4B5C9;
	Fri,  2 Oct 2020 10:36:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G6iVkrMfIS3X; Fri,  2 Oct 2020 10:36:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1CA14B5AE;
	Fri,  2 Oct 2020 10:36:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 704E04B5AE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 10:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KxBZYMsdQwuO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2020 10:36:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1BD4B5AA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 10:36:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1601649414;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=RL9FkyEQEEDC7i4TxK7mLdt4FElF6i+ix0CGBCfcTBQ=;
 b=UzyWzjrD4uKqCnX55w7+tqwTnjOQpkMGOxJMB1MIWjwaH5hVjZSeYYKrNyJLwiwagkldt1
 HFs6yjc9bjWPrMbsaF+HxdI1vqUnJsABnjVMt8EvbMg2HWEpnCqcp/nYoNsHt0G6Dt2WFm
 IHaaOdUAH631K9jHmMW4kq/+vUob1Zc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-O7mBmVrVOh-mquDb9eronA-1; Fri, 02 Oct 2020 10:36:50 -0400
X-MC-Unique: O7mBmVrVOh-mquDb9eronA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0DEE8064BD;
 Fri,  2 Oct 2020 14:36:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4711660BE2;
 Fri,  2 Oct 2020 14:36:43 +0000 (UTC)
Date: Fri, 2 Oct 2020 16:36:40 +0200
From: Andrew Jones <drjones@redhat.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 0/2] MTE support for KVM guest
Message-ID: <20201002143640.uzsz3nhr45payhlb@kamzik.brq.redhat.com>
References: <20200925093607.3051-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200925093607.3051-1-steven.price@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
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

On Fri, Sep 25, 2020 at 10:36:05AM +0100, Steven Price wrote:
> Version 3 of adding MTE support for KVM guests. See the previous (v2)
> posting for background:
> 
>  https://lore.kernel.org/r/20200904160018.29481-1-steven.price%40arm.com
> 
> These patches add support to KVM to enable MTE within a guest. They are
> based on Catalin's v9 MTE user-space support series[1] (currently in
> next).
> 
> Changes since v2:
> 
>  * MTE is no longer a VCPU feature, instead it is a VM cap.
> 
>  * Being a VM cap means easier probing (check for KVM_CAP_ARM_MTE).
> 
>  * The cap must be set before any VCPUs are created, preventing any
>    shenanigans where MTE is enabled for the guest after memory accesses
>    have been performed.
> 
> [1] https://lore.kernel.org/r/20200904103029.32083-1-catalin.marinas@arm.com
> 
> Steven Price (2):
>   arm64: kvm: Save/restore MTE registers
>   arm64: kvm: Introduce MTE VCPU feature
> 
>  arch/arm64/include/asm/kvm_emulate.h       |  3 +++
>  arch/arm64/include/asm/kvm_host.h          |  7 +++++++
>  arch/arm64/include/asm/sysreg.h            |  3 ++-
>  arch/arm64/kvm/arm.c                       |  9 +++++++++
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 14 ++++++++++++++
>  arch/arm64/kvm/mmu.c                       | 15 +++++++++++++++
>  arch/arm64/kvm/sys_regs.c                  | 20 +++++++++++++++-----
>  include/uapi/linux/kvm.h                   |  1 +
>  8 files changed, 66 insertions(+), 6 deletions(-)
> 
> -- 
> 2.20.1
> 
>

Hi Steven,

These patches look fine to me, but I'd prefer we have a working
implementation in QEMU before we get too excited about the KVM
bits. kvmtool isn't sufficient since it doesn't support migration
(at least afaik). In the past we've implemented features in KVM
that look fine, but then issues have been discovered when trying
to enable them from QEMU, where we also support migration. This
feature looks like there's risk of issues with the userspace side.
Although these two patches would probably stay the same, even if
userspace requires more support.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
