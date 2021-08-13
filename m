Return-Path: <SRS0=HTLS=NE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3066C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 13 Aug 2021 17:46:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FA0F6103A
	for <kvmarm@archiver.kernel.org>; Fri, 13 Aug 2021 17:46:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2FA0F6103A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938734A319;
	Fri, 13 Aug 2021 13:46:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vtoF4qOS5H2G; Fri, 13 Aug 2021 13:46:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A12244B0BA;
	Fri, 13 Aug 2021 13:46:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27B064A319
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 13:46:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id InyvwSOo0VHe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 13:46:23 -0400 (EDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
 [209.85.208.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B0844086D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 13:46:23 -0400 (EDT)
Received: by mail-lj1-f176.google.com with SMTP id h11so16673923ljo.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 10:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=f8Holqm94msH8zwwttqnwNNIb5GP1G9/99qvE2v+dcU=;
 b=FPBviLCHTYpGAqgTfZCCThlPsy3SvDQxjuebC13p0iXhj0OeNzcrk8YOeVtI5XtpMF
 Uz75WPbJwSvlgpLB3W9qk6PHRin4VdhT9qA8BJG5ghCMldOJLsqDkm82fAq0EG8X/9BU
 8X0Jhf6XqawQsbRgFF6RRyadIjhI2BKj4pTGDmuYTJyYsiQMyLxObkqnuD976ng/AB8v
 NgMtefW1nPUJFOW/t+mhBlXgdY58Unh1X9nWpqYWjWqlYtWMHQ7OFlwxbWE6Xg1lIYrk
 MK78YUyYD35s7G1H9/bmzRptli+3Oa4ZmwL653IleMYkjHZaiwFDmBcZfA+TZ/gXbrXs
 WVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=f8Holqm94msH8zwwttqnwNNIb5GP1G9/99qvE2v+dcU=;
 b=Ojfru4IJxLIDPZLRtHyJ7Ix9e8ob+JpFofIDBY4wiwBtbILl0dC2EeF27mF9H0mqnv
 51c+HWk/jM7ZS/tx8vdso00PCJIwztJxfHYWwgiSKjvbHPlccyGRrb2l478QwV0YCopH
 0dIvW39q/rBjCtReQFzAJxHMC/+s0GicC/fVwjsQnAGqhizzHo94Ko0HsNkHv5I46+oj
 kBAFbB1R2Gv+QMEds/bwOKQe5W0e57AIDyXHyiAX6at8u7zn94bST33/kzKAoPd4KW7E
 L8CewqzrvwNFZznEFnAcH9DRUdEXSMSo78Y4LQTkZggzD4LCjtr9wCLFttbTzkcvGowj
 UC1A==
X-Gm-Message-State: AOAM533Jn1Us9ujUvbEHWbCsJj9uZ1Enuypce4HIqWrWnYExdu7eNjOL
 QI1hJudByE02wj6Fk29uxNtefWzhiOzRvb3fNYg8CA==
X-Google-Smtp-Source: ABdhPJx8HrYl3U2RpJvJAW94Qnm4I1248XWC/aFD75EZtnwMe+a7ZCPJypazWWRAKqrHLiT2BB63moMkioDJPlkcPDc=
X-Received: by 2002:a2e:a5c1:: with SMTP id n1mr2653235ljp.65.1628876781486;
 Fri, 13 Aug 2021 10:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-2-oupton@google.com>
 <78eeaf83-2bfa-8452-1301-a607fba7fa0c@redhat.com>
 <CAOQ_QsiwzKpaXUadGR6cWC2k0pg1P4QgkAxNdo0gpVAP1P3hSQ@mail.gmail.com>
 <0b415872-7a67-d38b-ae01-62c38b365be0@redhat.com>
In-Reply-To: <0b415872-7a67-d38b-ae01-62c38b365be0@redhat.com>
From: Oliver Upton <oupton@google.com>
Date: Fri, 13 Aug 2021 10:46:10 -0700
Message-ID: <CAOQ_Qsjs7MOeh8ZGx3_CdgpedFwb9pYG_tQ4insdPwaqhAY=6g@mail.gmail.com>
Subject: Re: [PATCH v6 01/21] KVM: x86: Fix potential race in KVM_GET_CLOCK
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Fri, Aug 13, 2021 at 3:44 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/08/21 12:39, Oliver Upton wrote:
> > Might it make sense to fix this issue under the existing locking
> > scheme, then shift to what you're proposing? I say that, but the
> > locking change in 03/21 would most certainly have a short lifetime
> > until this patch supersedes it.
>
> Yes, definitely.  The seqcount change would definitely go in much later.
>   Extracting KVM_{GET,SET}_CLOCK to separate function would also be a
> patch of its own.  Give me a few more days of frantic KVM Forum
> preparation. :)

Sounds good :-) I'm probably going to send this out once more, in
three separate series:

- x86 (no changes, just rebasing)
- arm64 (address some comments, bugs)
- selftests (no changes)

--
Thanks,
Oliver

> Paolo
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
