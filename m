Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A738C6377B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 21:43:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BD4461283
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 21:42:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BD4461283
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDC604A32E;
	Wed, 21 Jul 2021 17:42:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JQc2r0oioCTU; Wed, 21 Jul 2021 17:42:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF7044B0DD;
	Wed, 21 Jul 2021 17:42:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 241A74A32E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 17:42:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tWFUoObSJ7ho for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 17:42:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5173649F83
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 17:42:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626903769;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=EgnuYo/9YupwfYuRzS/3EAJrECOCz9JZzyHEzGBP/Do=;
 b=Os4Pq/yX6SU5pRGKAMrzEK4C3EBkYn67OLfEn/OfeJulgBJNUhB+lmvI2TkQDAuynv/o86
 t9ZrKcOd8g4BOra2wSVLoYIFnmew2PQin7Ea8owRcjeQLuNZBJ5baL527Z6frHNv37y704
 3oZN3c59TNyNGGXySrJDMnumcTsVUTY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-LeyQeO6iOSipwLf44T781g-1; Wed, 21 Jul 2021 17:42:47 -0400
X-MC-Unique: LeyQeO6iOSipwLf44T781g-1
Received: by mail-io1-f71.google.com with SMTP id
 e24-20020a5d8e180000b02904dd8a55bbd7so2488551iod.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 14:42:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EgnuYo/9YupwfYuRzS/3EAJrECOCz9JZzyHEzGBP/Do=;
 b=TOpSvlCRO4XT+mG/Ia5rvD207N5YpfPy4AO4AfzCj4xpa3wBgTcoTmkNptlJRMwTTg
 5Nv28WGRulUY4LjdrQDnXxaj5XB3HyJVdOwHDlNv9O9ZtV+9jFUnEf3Qi8vSWW3pgtLr
 Kante1oOuQ0D1p1UWJdWmDLpW9E37tNDuTF06XQug/xRX+TGJDQYjL43ua6CuHX1o7es
 rxMqkpbWHYmJc3UIt48mNEBPxNNORXvjDRAv2ELj2FFc+xZgUqyiYEz0+Qa4KtAw8tnR
 gd4C8TPq6Q2jzs+ADtmGp4nA1Zg9dDviwIrC09GW8yAHsgy9+XwZ4o4tOX+WBplaLnqv
 p96Q==
X-Gm-Message-State: AOAM532oFrJVrixz1OhrfqpRiYT6kMIYi+Ped/Qa5PpgHKcKzoeAxj+1
 hJoXbydNzrsh9gyg8rKzOjEPdrwXkU7ha/vWQWph7A6BTcFo2oQQyrB3sblyx9W9zbd7VS2G4+v
 pW47ekWmxUhfVM2Wzz9bB8Eu1
X-Received: by 2002:a92:cb06:: with SMTP id s6mr26042736ilo.87.1626903767248; 
 Wed, 21 Jul 2021 14:42:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7rBCtquDD6lbxgOm4tFTVO+wR+CyYZ/EAkJBC/eHDwdFdEua1cvqGXWw7KmnzajQrtWPbOw==
X-Received: by 2002:a92:cb06:: with SMTP id s6mr26042710ilo.87.1626903766552; 
 Wed, 21 Jul 2021 14:42:46 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id h13sm12599982ila.44.2021.07.21.14.42.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 14:42:45 -0700 (PDT)
Date: Wed, 21 Jul 2021 23:42:43 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 00/16] KVM: arm64: MMIO guard PV services
Message-ID: <20210721214243.dy6d644yznuopuqx@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210715163159.1480168-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, will@kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Jul 15, 2021 at 05:31:43PM +0100, Marc Zyngier wrote:
> KVM/arm64 currently considers that any memory access outside of a
> memslot is a MMIO access. This so far has served us very well, but
> obviously relies on the guest trusting the host, and especially
> userspace to do the right thing.
> 
> As we keep on hacking away at pKVM, it becomes obvious that this trust
> model is not really fit for a confidential computing environment, and
> that the guest would require some guarantees that emulation only
> occurs on portions of the address space that have clearly been
> identified for this purpose.

This trust model is hard for me to reason about. userspace is trusted to
control the life cycle of the VM, to prepare the memslots for the VM,
and [presumably] identify what MMIO ranges are valid, yet it's not
trusted to handle invalid MMIO accesses. I'd like to learn more about
this model and the userspace involved.

> 
> This series aims at providing the two sides of the above coin:
> 
> - a set of PV services (collectively called 'MMIO guard' -- better
>   name required!) where the guest can flag portion of its address
>   space that it considers as MMIO, with map/unmap semantics. Any
>   attempt to access a MMIO range outside of these regions will result
>   in an external abort being injected.
> 
> - a set of hooks into the ioremap code allowing a Linux guest to tell
>   KVM about things it want to consider as MMIO. I definitely hate this
>   part of the series, as it feels clumsy and brittle.
> 
> For now, the enrolment in this scheme is controlled by a guest kernel
> command-line parameters, but it is expected that KVM will enforce this
> for protected VMs.
> 
> Note that this crucially misses a save/restore interface for non
> protected VMs, and I currently don't have a good solution for
> that. Ideas welcome.
> 
> I also plan to use this series as a base for some other purposes,
> namely to trick the guest in telling us how it maps things like
> prefetchable BARs (see the discussion at [1]). That part is not
> implemented yet, but there is already some provision to pass the MAIR
> index across.
> 
> Patches on top of 5.14-rc1, branch pushed at the usual location.
> 
> [1] 20210429162906.32742-1-sdonthineni@nvidia.com

The fun never stops.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
