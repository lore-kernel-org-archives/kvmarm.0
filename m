Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E75C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 18:02:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E581060F4F
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 18:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E581060F4F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 560C54B0C5;
	Mon, 27 Sep 2021 14:02:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KD9JhfVqbZQa; Mon, 27 Sep 2021 14:02:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 363304B0A0;
	Mon, 27 Sep 2021 14:02:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED88440C88
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 12:59:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3HtaPCEudci5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 12:59:19 -0400 (EDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCA874086F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 12:59:19 -0400 (EDT)
Received: by mail-lf1-f49.google.com with SMTP id u8so79267333lff.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 09:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=boyhOy7c3Zv3+YHD3yPMRV9jTZZHINKXKipnorJKcwg=;
 b=EFsgbbFE2kAt7wByLaFcasmCsfVIgNxk/m8G/nDr+HQQCPZquhtvMBtAa+Duc5+kXQ
 UtY1CeMLlZTD94anpjzQv4K2YgUm9xVsItVLuyYt7PzuN+o60dJjWiO6ZURLbhkP7mzD
 l/1wphgAzzIFt+bnAvBUh1vmO0XgUCFQbkR5nyhNqwPHp4lRcD3QYQpAbbn7KH5W/ysv
 OQmlCYcjYrF8BVfGjUkclx0OrNnd/IdHMhsMfPOv7/HS8Qxd6WyABtIhI1iDB0FR5uaE
 W0Ua9w0Kzy0A9r7i69bL0pt1y0fFyfV6OwYtL3O/7ZJwWx+dXki0Z+PUBsXBMwLQP/I9
 ShZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=boyhOy7c3Zv3+YHD3yPMRV9jTZZHINKXKipnorJKcwg=;
 b=uA2naR7OsIE/Hy8lYn3aObkmZymJ9p5JfnnIjumZjL+DCxUucLn2s9G7Onqo/mzlvQ
 JCRIZxHdGvaTfzbkUeCPGU85gLVLd1MSHqzwJysHyRSGIMnTjtudwNOw6HUq52ZjoL0v
 gmb+fwcmgfhmtjOQOiRIhEMR53t5RI3K+XdiY/Px0IArJsPaVA10jg+snoNUyiGJrVa9
 6pDlMPdwQIazz7cb6NRLb+AsrEFYkQFDBr5VT/khoJKkgvb98wE5QfDiS7FPiq6/8TCm
 y1xJiKak0dI7HN54xtoS1j/4vOKeEYdZwx9gSXyZqn+OPJcYsmdbTnxhilo9kSl4LMzk
 p3VQ==
X-Gm-Message-State: AOAM533txBJElSvIwz+FWk8lJqIpzFhkhHlvs0KN+ceSiGhq01PYnBpp
 KUPPcXJa6vV2t7LOWKOXgS8d3x3EQoHS7i5ibel4Uw==
X-Google-Smtp-Source: ABdhPJyvrc2iIXbcC8YaiVkzYO41Psj9zevIrEPYYOmLf26TIPB4wujR7R6xkm6OJn238QJWJUKaISQGVYiRf4/ylng=
X-Received: by 2002:a19:c349:: with SMTP id t70mr843112lff.102.1632761958145; 
 Mon, 27 Sep 2021 09:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
 <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
In-Reply-To: <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Sep 2021 09:58:51 -0700
Message-ID: <CALzav=cxeYieTkKJhT0kFZOjdv6k5eCZXKWs=ZQGCJg0x-oFjQ@mail.gmail.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To: Christian Borntraeger <borntraeger@de.ibm.com>
X-Mailman-Approved-At: Mon, 27 Sep 2021 14:02:49 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm list <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Sep 27, 2021 at 8:17 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> Am 27.09.21 um 17:03 schrieb Paolo Bonzini:
> > On 27/09/21 16:59, Sean Christopherson wrote:
> >>> commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
> >>> Author:     David Matlack<dmatlack@google.com>
> >>> AuthorDate: Fri Apr 17 15:14:46 2020 -0700
> >>> Commit:     Paolo Bonzini<pbonzini@redhat.com>
> >>> CommitDate: Fri Apr 24 12:53:17 2020 -0400
> >>>
> >>>      kvm: add capability for halt polling
> >>>
> >>> broke the possibility for an admin to disable halt polling for already running KVM guests.
> >>> In past times doing
> >>> echo 0 > /sys/module/kvm/parameters/halt_poll_ns
> >>>
> >>> stopped polling system wide.
> >>> Now all KVM guests will use the halt_poll_ns value that was active during
> >>> startup - even those that do not use KVM_CAP_HALT_POLL.
> >>>
> >>> I guess this was not intended?
> >
> > No, but...
> >
> >> I would go so far as to say that halt_poll_ns should be a hard limit on
> >> the capability
> >
> > ... this would not be a good idea I think.  Anything that wants to do a lot of polling can just do "for (;;)".

I agree. It would also be a maintenance burden and subtle "gotcha" to
have to increase halt_poll_ns anytime one wants to increase
KVM_CAP_HALT_POLL.

> >
> > So I think there are two possibilities that makes sense:
> >
> > * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that
>
> what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.

None of these options would cover Christian's original use-case
though. (Write to module to disable halt-polling system-wide.)

What about adding a writable "enable_halt_polling" module parameter
that affects all VMs? Once that is in place we could also consider
getting rid of halt_poll_ns entirely.

> >
> > * just make halt_poll_ns read-only.
> >
> > Paolo
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
