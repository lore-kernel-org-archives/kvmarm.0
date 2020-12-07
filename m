Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BB9C4361B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 11:40:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2192623356
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 11:40:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2192623356
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A12984B2B5;
	Mon,  7 Dec 2020 06:40:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GM+V5XcpFy1g; Mon,  7 Dec 2020 06:40:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B1EB4B2A3;
	Mon,  7 Dec 2020 06:40:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6E64B261
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 06:16:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rh1uc0tWu0rw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 06:16:42 -0500 (EST)
Received: from mail-oo1-f67.google.com (mail-oo1-f67.google.com
 [209.85.161.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 417084B12E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 06:16:42 -0500 (EST)
Received: by mail-oo1-f67.google.com with SMTP id i7so3092026oot.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2020 03:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nwG4TWcUm8pF7K4oTU7GITdAxYvneLQVCWtOQ4qnITI=;
 b=QzOPfJq6brPlWLhOGjRL7CH5U88bsg77NcVAzpg5l0Il+t1OSzHatKcSMZtU/Qooaz
 2aD8GmiRxXaUJ69wI3iyGydzWttl++3k/Eoe53ram5v0yjl2Ntz7ciqb3P5qUNgKtOyY
 ADreSu/REA/g5CL4IeqKcy3rqq5gE5PtMde5x57Ak+XQLiOCbUA/ZqHfSkXD4DiZLo03
 /r6eIMfz7bNYd1k0ANwqMFrV6uoTJ9OOF410RAIAPS2/ay34T9BMyPOC9gSbdM6P89On
 WPexdJ978FYCsGLdPRVglor7xKP8qZkl05v+9/4DHwYk7G4cTMmaz8U/F/Mh2pVveW8h
 dGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nwG4TWcUm8pF7K4oTU7GITdAxYvneLQVCWtOQ4qnITI=;
 b=DqLVw1L+goap/g1D6FlfltYKesUtyMaVQCaSf6oevIerL5QM7nxapBzfgwof5t9Dph
 OGqFeJx2C/F84oeazDj/3cGMErDNcpvNXzQjCjCnftitT3I8chO429QlUpr6nU0CCw/u
 SBJpXJ/Qs/IvKNGddJaNjPt7snOteFi8SlaTRn7kg7pQfpr99bPEBUujC8Dg8qiYOa0p
 ofo7BqkBKgq9o2EUqSEl4MPiplwSw7S783xNQnNR5WYvhr3Fih0q5kOiAv8VXrN1sp1v
 k+ZWyUCKOOhOpo0pte/3bSDViyslEi9fzFkrOtQs318UnUwYqBVrd2v0oH6zFlTNR8NY
 JUww==
X-Gm-Message-State: AOAM531pAdlskb9hXuDCE5V9g9BNyPRc2+lHw5p7001vLwYUBzrk7WeI
 jd3rJlnmeBoCubR+RWBgcYf3kYcbE5nQTulN+6zz4A==
X-Google-Smtp-Source: ABdhPJx9cbeSJ9V8Q7wlwxkuuRV1vY2gzAVhPdoz+VDDikcfYemu9rYcUksyIX7Bh/NZiRc8uaGfU+Ix0O6LwVqYwWY=
X-Received: by 2002:a4a:9e02:: with SMTP id t2mr12368409ook.42.1607339801572; 
 Mon, 07 Dec 2020 03:16:41 -0800 (PST)
MIME-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
 <CA+EHjTyJnZ8e=AN7H_k+oZb0VTWAgMicMY8Rqe2Di_3A87hm0A@mail.gmail.com>
 <X8p5kLSIq2MoQZ24@google.com>
In-Reply-To: <X8p5kLSIq2MoQZ24@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 7 Dec 2020 11:16:05 +0000
Message-ID: <CA+EHjTxW_z-P8bK7gCjGv2eBCAHFsvE873Gr2KyVq5-+_Mdv=g@mail.gmail.com>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Mon, 07 Dec 2020 06:40:40 -0500
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, Android KVM <android-kvm@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Fri, Dec 4, 2020 at 6:01 PM Quentin Perret <qperret@google.com> wrote:
>
> On Thursday 03 Dec 2020 at 12:57:33 (+0000), Fuad Tabba wrote:
> <snip>
> > > +int hyp_create_idmap(void);
> > > +int hyp_map_vectors(void);
> > > +int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
> > > +int hyp_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
> > > +int hyp_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> > > +int __hyp_create_mappings(unsigned long start, unsigned long size,
> > > +                         unsigned long phys, unsigned long prot);
> > > +unsigned long __hyp_create_private_mapping(phys_addr_t phys, size_t size,
> > > +                                          unsigned long prot);
> > > +
> >
> > nit: I also thought that the hyp_create_mappings function names are a
> > bit confusing, since there's the create_hyp_mappings functions which
> > use the aforementioned *hyp_pgtable.
>
> Sure, happy to re-name those (and hyp_pgtable above). Any suggestions?

Perhaps something to indicate that these are temporary, tmp_ or
bootstrap_ maybe?

Cheers,
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
