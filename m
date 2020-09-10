Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4008CC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:01:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DCCB20882
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eHtit0kB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DCCB20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D26244B3FB;
	Thu, 10 Sep 2020 06:01:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sRK+yJdxlM-Z; Thu, 10 Sep 2020 06:01:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCB054B3E1;
	Thu, 10 Sep 2020 06:01:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E20C14B393
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:01:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z91E6taIe9Bn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 06:01:15 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F924B385
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:01:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599732074;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SAWVsQ1VutHeIxcMMMfasmStNBpMRCAzjajMGXTXbd0=;
 b=eHtit0kB4Q4gqxCFnvs2sI/d1zB45cvF+vS4fBVctNtQB7dyum3wgsgdHAVCkPqmajfyTV
 rK7w4uQVbZNby42gkseiqeFWLxHhIJQAaxPmg/ytNX3fzdBnNrGmLcV5j2FqP0Ql76DS7E
 DrRVbJBNULeZhT/RYaFKC4XS6Hxgjf8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-2ul8F2GxPr6_nDXiBcdcfQ-1; Thu, 10 Sep 2020 06:01:11 -0400
X-MC-Unique: 2ul8F2GxPr6_nDXiBcdcfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35E8C801FDF;
 Thu, 10 Sep 2020 10:01:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.124])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32A011002D5E;
 Thu, 10 Sep 2020 10:01:04 +0000 (UTC)
Date: Thu, 10 Sep 2020 12:01:01 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 2/2] arm64: kvm: Introduce MTE VCPU feature
Message-ID: <20200910100101.4c47ww4xniza7owi@kamzik.brq.redhat.com>
References: <20200904160018.29481-1-steven.price@arm.com>
 <20200904160018.29481-3-steven.price@arm.com>
 <20200909154804.mide6szbzgdy7jju@kamzik.brq.redhat.com>
 <CAFEAcA_1YnBg3HVmtrSMP8u7GqHY8mtDAJwVcZuNUhwA+q9q=w@mail.gmail.com>
 <20200910063854.vwhtn3lc5tei72fh@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200910063854.vwhtn3lc5tei72fh@kamzik.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: Peter Maydell <Peter.Maydell@arm.com>, Juan Quintela <quintela@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Dave Martin <Dave.Martin@arm.com>
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

On Thu, Sep 10, 2020 at 08:38:54AM +0200, Andrew Jones wrote:
> On Wed, Sep 09, 2020 at 04:53:02PM +0100, Peter Maydell wrote:
> > On Wed, 9 Sep 2020 at 16:48, Andrew Jones <drjones@redhat.com> wrote:
> > > We either need a KVM cap or a new CPU feature probing interface to avoid
> > > making userspace try features one at a time. It's too bad that VCPU_INIT
> > > doesn't clear all offending features from the feature set when returning
> > > EINVAL, because then userspace could create a scratch VCPU with everything
> > > it supports in order to see what KVM also supports in one go.
> > 
> > You could add one if you wanted -- add a new feature bit
> > TELL_ME_WHAT_YOU_HAVE. If the kernel sees that then on filure
> > it clears out feature bits it doesn't support and also clears
> > TELL_ME_WHAT_YOU_HAVE. If QEMU sees EINVAL and TELL_ME_WHAT_YOU_HAVE
> > is still set, then it knows it's dealing with an old kernel
> > and has to do one-at-a-time probing. If it sees EINVAL but not
> > TELL_ME_WHAT_YOU_HAVE then it knows it has a new kernel and
> > has just got all the info.
> >
> 
> That's a great proposal. I'll try to find time to send the patches.
>

We also have KVM_ARM_PREFERRED_TARGET, which is documented as

"""
...
The ioctl returns struct kvm_vcpu_init instance containing information
about preferred CPU target type and recommended features for it.  The
kvm_vcpu_init->features bitmap returned will have feature bits set if
the preferred target recommends setting these features, but this is
not mandatory.
...
"""

But, it says "recommended" features, not "all supported" features,
and the current implementation of KVM_ARM_PREFERRED_TARGET only
zeros out features. So, I think we should just leave
KVM_ARM_PREFERRED_TARGET as is and stick to the plan of extending
VCPU_INIT.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
