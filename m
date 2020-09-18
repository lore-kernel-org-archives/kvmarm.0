Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3789EC43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 08:01:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E8C320773
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 08:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NshXunTz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E8C320773
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9E924B406;
	Fri, 18 Sep 2020 04:01:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TZcwQ63jK-dB; Fri, 18 Sep 2020 04:01:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF0314B41E;
	Fri, 18 Sep 2020 04:01:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B8CF4B407
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 04:01:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p0bNSvXxVZBo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 04:01:22 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E14C4B406
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 04:01:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600416082;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=GVFinjKpebbOcYbTtDAH+8ZTpHrKqsTQijsV2GuanqY=;
 b=NshXunTzyNC45NfLB8DXisZ8xuFphFdjKFkiHeLkXH3VWzSZzAWEQiU/j7ZvqZl6X4PK1M
 kKM99gU+6eWZs0gt9N4MC2VnR9/Tgxn/5xI24gdEfj0qr5SmjfkwUIIS/WnJcsYpl/n0nE
 b+cjF0vMurb8457pqjFqH0tmL/ZNNTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-3QxO-G4LMpK-m_HA6ew9Aw-1; Fri, 18 Sep 2020 04:01:18 -0400
X-MC-Unique: 3QxO-G4LMpK-m_HA6ew9Aw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2B6A6408F;
 Fri, 18 Sep 2020 08:01:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CC237881C;
 Fri, 18 Sep 2020 08:01:08 +0000 (UTC)
Date: Fri, 18 Sep 2020 10:01:06 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC v2 0/7] kvm: arm64: emulate ID registers
Message-ID: <20200918080106.5c6jqarj3mhwi3mv@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-1-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 17, 2020 at 08:00:54PM +0800, Peng Liang wrote:
> In AArch64, guest will read the same values of the ID regsiters with
> host.  Both of them read the values from arm64_ftr_regs.  This patch
> series add support to emulate and configure ID registers so that we can
> control the value of ID registers that guest read.
> 
> v1 -> v2:
>  - save the ID registers in sysreg file instead of a new struct
>  - apply a checker before setting the value to the register
>  - add doc for new KVM_CAP_ARM_CPU_FEATURE
> 
> Peng Liang (7):
>   arm64: add a helper function to traverse arm64_ftr_regs
>   arm64: introduce check_features
>   kvm: arm64: save ID registers to sys_regs file
>   kvm: arm64: introduce check_user
>   kvm: arm64: implement check_user for ID registers
>   kvm: arm64: make ID registers configurable
>   kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
> 
>  Documentation/virt/kvm/api.rst      |   8 +
>  arch/arm64/include/asm/cpufeature.h |   4 +
>  arch/arm64/include/asm/kvm_coproc.h |   2 +
>  arch/arm64/include/asm/kvm_host.h   |   3 +
>  arch/arm64/kernel/cpufeature.c      |  36 +++
>  arch/arm64/kvm/arm.c                |   3 +
>  arch/arm64/kvm/sys_regs.c           | 481 +++++++++++++++++++++++++++-
>  arch/arm64/kvm/sys_regs.h           |   6 +
>  include/uapi/linux/kvm.h            |   1 +
>  9 files changed, 532 insertions(+), 12 deletions(-)
> 
> -- 
> 2.26.2
>

Hi Peng,

I'd much rather see a series of patches where each patch converts a single
ID register from using ID_SANITISED() to having its own table entry, where
its own set_user() and reset() functions take into account its features
using high level arm64_ftr* functions. Any ID registers that can still
share code can certainly do so with some post-conversion refactoring.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
