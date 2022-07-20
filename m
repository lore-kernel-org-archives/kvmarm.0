Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0895C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 09:45:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F4F4D005;
	Wed, 20 Jul 2022 05:45:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p6wp8VvZYVH6; Wed, 20 Jul 2022 05:45:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 279984CFDA;
	Wed, 20 Jul 2022 05:45:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56CDA4D749
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 21:07:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mzfdIasFv8A1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 21:07:08 -0400 (EDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6D7E4D745
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 21:07:08 -0400 (EDT)
Received: by mail-wr1-f41.google.com with SMTP id bv24so121724wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 18:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RnduJRWap81e4hsQGNaqE2KBoYp4jqdU1O2gWYXksrg=;
 b=V3L6saNcxDkw3rVUZoKMT+z27A12bbuMUQUtYUo52WpG05ad/Q3Lae9kO9Ssfq5E+o
 YzXt4abwxGv+dwxD19q182Tuv+jEQ90ytCYm2jfFd5xxWwmkZBRohif67QZtCceM83oi
 NUU4ZOjD12l69pg3MEeq0C/RyCjh9aJsInnixGl/o8nH/XrKnDYI86aiat2qCbQxSf38
 THILLSqte2NlbrOatnLA0liVuydqbpDMtkQWGZdtcz8RmPPLV7Aq4cNotneTAkvZev6r
 y2dWrfTCTjX2uGv83f5rxxPvXeio8xcWjnvuLCng4BNiGhbO0l7uJp80yX01OHGv+h/M
 nrqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RnduJRWap81e4hsQGNaqE2KBoYp4jqdU1O2gWYXksrg=;
 b=6R0m2Hx1qx+7RdymKiQ8q2xjUcoOFKDeIClVIb4FUA5K1TuKg+MrQOcqBHw0FJ1JyO
 gtxA3B1AvCh2myABPqwZz/mER/uRaNwXBX627hPPLoT5sUg0L9pSA8ry3uSts3AuWNxg
 KiW8alLHVafHsIXsV1mo47mLcc8rDJOOvhGxsEACPr9mZMwHcKPjsnoFoEQLBr+OWvzu
 1Ar5KITClO0+tUQA8GyJYNujcQ10Pd5bz1IMRNQ0oTe4TP0gn8zBrCu+ab1RILTGVTKh
 l80dJLynOGsy1bWQzkwaVrHCJOQKM/ho/MZFDTBvWQCWXb3ovB+7yZA96s0XN6BQfbRY
 uRZQ==
X-Gm-Message-State: AJIora/cakBnD8tMj3sxf+U13CHX3Jv054sDcW61VXABMDX4OiZ01h7l
 HhoN+mI3XmLI7TEkVvluawAlhvwsQFu2/F8KaXiNww==
X-Google-Smtp-Source: AGRyM1tjfS0I06AEG0F/LzOUouITmNkWGASNHqEfxR822WYDad6jgo6sBqyj7LcYSIIG+kLVswqWoffKMtf3O1YoCYM=
X-Received: by 2002:a05:6000:81d:b0:21d:a495:6e3 with SMTP id
 bt29-20020a056000081d00b0021da49506e3mr28760355wrb.502.1658279227451; Tue, 19
 Jul 2022 18:07:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220708212106.325260-1-pcc@google.com>
 <877d49p36n.fsf@redhat.com>
In-Reply-To: <877d49p36n.fsf@redhat.com>
From: Peter Collingbourne <pcc@google.com>
Date: Tue, 19 Jul 2022 18:06:55 -0700
Message-ID: <CAMn1gO65DJs8QyMs4YTmq7_b01qjLgBRhM3OLZ7aKaobEGMXDw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
To: Cornelia Huck <cohuck@redhat.com>
X-Mailman-Approved-At: Wed, 20 Jul 2022 05:45:52 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Evgenii Stepanov <eugenis@google.com>, Michael Roth <michael.roth@amd.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Tue, Jul 19, 2022 at 7:50 AM Cornelia Huck <cohuck@redhat.com> wrote:
>
> On Fri, Jul 08 2022, Peter Collingbourne <pcc@google.com> wrote:
>
> > Hi,
> >
> > This patch series contains a proposed extension to pKVM that allows MTE
> > to be exposed to the protected guests. It is based on the base pKVM
> > series previously sent to the list [1] and later rebased to 5.19-rc3
> > and uploaded to [2].
> >
> > This series takes precautions against host compromise of the guests
> > via direct access to their tag storage, by preventing the host from
> > accessing the tag storage via stage 2 page tables. The device tree
> > must describe the physical memory address of the tag storage, if any,
> > and the memory nodes must declare that the tag storage location is
> > described. Otherwise, the MTE feature is disabled in protected guests.
> >
> > Now that we can easily do so, we also prevent the host from accessing
> > any unmapped reserved-memory regions without a driver, as the host
> > has no business accessing that memory.
> >
> > A proposed extension to the devicetree specification is available at
> > [3], a patched version of QEMU that produces the required device tree
> > nodes is available at [4] and a patched version of the crosvm hypervisor
> > that enables MTE is available at [5].
>
> I'm unsure how this is supposed to work with QEMU + KVM, as your QEMU
> patch adds mte-alloc properties to regions that are exposed as a
> separate address space (which will not work with KVM). Is the magic in
> that new shared section?

Hi Cornelia,

The intent is that the mte-alloc property may be set on memory whose
allocation tag storage is not directly accessible via physical memory,
since in this case there is no need for the hypervisor to do anything
to protect allocation tag storage before exposing MTE to guests. In
the case of QEMU + KVM, I would expect the emulated system to not
expose the allocation tag storage directly, in which case it would be
able to set mte-alloc on all memory nodes without further action,
exactly as my patch implements for TCG. With the interface as
proposed, QEMU would need to reject the mte-shared-alloc option when
KVM is enabled, as there is currently no mechanism for KVM-accelerated
virtualized tag storage.

Note that these properties are only relevant for guest kernels running
under an emulated EL2 in which pKVM could conceivably run, which means
that the host would need to implement FEAT_NV2. As far as I know there
is currently no support for NV2 neither in QEMU TCG nor in the Linux
kernel, and I'm unaware of any available hardware that supports both
NV2 and MTE, so it'll be a while before any of this becomes relevant.

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
