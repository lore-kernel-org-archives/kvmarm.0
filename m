Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849BBC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 00:10:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1DA86124D
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 00:10:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F1DA86124D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF9B4B18F;
	Thu, 23 Sep 2021 20:10:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id STG0M9qhBfZs; Thu, 23 Sep 2021 20:10:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 837C34B156;
	Thu, 23 Sep 2021 20:10:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C3F14B0F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 20:10:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L1nU2Ng6D06U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 20:10:37 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 826094B089
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 20:10:37 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id g41so32895674lfv.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 17:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VxZeFbR4E7xxPJCmTTyjYQKyIz5peux0bk1U/xy3G6I=;
 b=l+AunnTgJrQqJkKsILPKbax24xaGk0dIslYaSBTg0MSiwnIfTGn/sFyPZx1A6uYQlc
 oouqtsvvmdVQLni8Wwnz+mN7Z5nlf9bSQmQgzM7jXncTdwTcbLM5HvLC4scq/2tqE2pT
 wyzpEYtDJGmw69mfPtldn3shuvRrFLVsz67+nw9nroJbapyT1ACRqW1Gg/mhOd7Joe57
 u4SLavD9gqSYYuf2YGc+fswPti1Qo7i1Ct3z28ySHyr67morY8UaxoPeXCQV8Utv5z94
 boG6d1YT93QdiMcJIkR53+gpWVqvOgfQBxW8Rk4mOD6dz1wVyaCH6KYJjKuvMmsGkUQT
 v9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VxZeFbR4E7xxPJCmTTyjYQKyIz5peux0bk1U/xy3G6I=;
 b=6G0Inb3JYaBeyFCRhNc77Wnxnba/n/7CQld4g9nVy5Z3nRoXGPLG5OKdH6rkeW3Fwp
 x3wANlEhJNThG7JQmZrVZPEmfJaWJTrVBNk5swBWwh8d931lJrFz637bLfFluYHpei0C
 irHmF755PWLtsr0u5HQOSYB8fgZ3udPjiqYEgq/JqQ/v/3q6Jv00gyNKghxfD6bd5tq9
 audg0daZffsbPdR22qGYhgbzudL0zDzXPw5BpHsFG7EB/PjbjlDMMDB6bgW/Qilf/7rk
 nO1KPc2QptOFFyTdOKXUtuZ4VCIJA/kUSuJGAvMb8k/Hxm9UwxFQkNlV5eZmaKPifMKT
 fMfg==
X-Gm-Message-State: AOAM533pK8txW/ukLVE8RzWIpNvqLZhH9AYuqQCc3s430CVtpagtux8p
 7CUK+JIKU7tL5k9N6RYFADd+6qWZUlRu4o74+1S63w==
X-Google-Smtp-Source: ABdhPJwNJGRAfmMrQR4DFQ6LLjl4z3IwJ+nmfkcZS2ytMg1WLwXuftcrJlYDFN+Ld3LoJBq/yOXW7gjRs4KlLHvUbjY=
X-Received: by 2002:ac2:488f:: with SMTP id x15mr501645lfc.553.1632442235973; 
 Thu, 23 Sep 2021 17:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
In-Reply-To: <YU0XIoeYpfm1Oy0j@google.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 23 Sep 2021 17:10:24 -0700
Message-ID: <CAOQ_QsgScBRB+BEMC0Ysdq8EjLx3SLB9=pV=P4kQ3bfchm15Mw@mail.gmail.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 23, 2021 at 5:09 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 23, 2021, Oliver Upton wrote:
> > While x86 does not require any additional setup to use the ucall
> > infrastructure, arm64 needs to set up the MMIO address used to signal a
> > ucall to userspace. rseq_test does not initialize the MMIO address,
> > resulting in the test spinning indefinitely.
> >
> > Fix the issue by calling ucall_init() during setup.
> >
> > Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  tools/testing/selftests/kvm/rseq_test.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > index 060538bd405a..c5e0dd664a7b 100644
> > --- a/tools/testing/selftests/kvm/rseq_test.c
> > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
> >        * CPU affinity.
> >        */
> >       vm = vm_create_default(VCPU_ID, 0, guest_code);
> > +     ucall_init(vm, NULL);
>
> Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
> going to remember to add this next time I write a common selftest, arm64 is the
> oddball here.

I think that is best, I was planning on sending out a fix that does
this later on. Just wanted to stop the bleeding with a minimal patch
first.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
