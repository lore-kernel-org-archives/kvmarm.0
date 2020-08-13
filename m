Return-Path: <SRS0=hhnY=BX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657C9C433E3
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 09:14:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12DDE20791
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 09:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HsWi7iTD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12DDE20791
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A69F4B8FB;
	Thu, 13 Aug 2020 05:14:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aWbfZJiw3yZk; Thu, 13 Aug 2020 05:14:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823654B94B;
	Thu, 13 Aug 2020 05:14:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2349A4B864
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 05:14:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DiJ8DDaOU3-M for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Aug 2020 05:14:29 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3151A4B8FB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 05:14:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597310069;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6Z5XW7mWY8zQjZYUVfkbmt75rJ+EgHpK68scfbUtXRs=;
 b=HsWi7iTD6fznNmHAbldP0IUBE1awutK8Y5kNY1Wvh7+Ie/Qu8P7JP+ud9ICWoufq/e3IkW
 dBbr7O+SGMfo+888YOjfepn5txSWaR/2L5FiytqQQfulurEx2vIiG8KLzc2iRGFVYQiDvg
 ySDpDLD+Wvm97Zx2myLBXRcDry9Yfp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-j--nvjLKM0uRSgYCMAAlfw-1; Thu, 13 Aug 2020 05:14:25 -0400
X-MC-Unique: j--nvjLKM0uRSgYCMAAlfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBE46E91A;
 Thu, 13 Aug 2020 09:14:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1F3219D7B;
 Thu, 13 Aug 2020 09:14:20 +0000 (UTC)
Date: Thu, 13 Aug 2020 11:14:17 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC 0/4] kvm: arm64: emulate ID registers
Message-ID: <20200813091417.othxkpko42y3thr4@kamzik.brq.redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200813060517.2360048-1-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, zhang.zhanghailiang@huawei.com
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

On Thu, Aug 13, 2020 at 02:05:13PM +0800, Peng Liang wrote:
> In AArch64, guest will read the same values of the ID regsiters with
> host.  Both of them read the values from arm64_ftr_regs.  This patch
> series add support to emulate and configure ID registers so that we can
> control the value of ID registers that guest read.
> 
> Peng Liang (4):
>   arm64: add a helper function to traverse arm64_ftr_regs
>   kvm: arm64: emulate the ID registers
>   kvm: arm64: make ID registers configurable
>   kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
> 
>  arch/arm64/include/asm/cpufeature.h |  2 ++
>  arch/arm64/include/asm/kvm_host.h   |  2 ++
>  arch/arm64/kernel/cpufeature.c      | 13 ++++++++
>  arch/arm64/kvm/arm.c                | 21 ++++++++++++
>  arch/arm64/kvm/sys_regs.c           | 50 ++++++++++++++++++++++-------
>  include/uapi/linux/kvm.h            | 12 +++++++
>  6 files changed, 89 insertions(+), 11 deletions(-)
> 
> -- 
> 2.18.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

Hi Peng,

I'm glad to see an effort has started in trying to prepare for CPU models,
allowing migration beyond identical hosts. How have you tested this
series? I.e. what userspace did you use and with what additional patches?
KVM changes like these are also easily tested with KVM selftests[*]. Have
you considered posting a selftest?

[*] Linux repo: tools/testing/selftests/kvm/

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
