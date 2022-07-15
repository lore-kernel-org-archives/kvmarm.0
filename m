Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509C4C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 16 Jul 2022 09:32:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B828F4C977;
	Sat, 16 Jul 2022 05:32:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ugnUgsjg-s+C; Sat, 16 Jul 2022 05:32:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A74F4C979;
	Sat, 16 Jul 2022 05:32:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 091954C046
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 15:32:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oXlVDAPFkC9k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 15:32:19 -0400 (EDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com
 [209.85.208.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B36E44C045
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 15:32:19 -0400 (EDT)
Received: by mail-lj1-f177.google.com with SMTP id u14so6774936ljh.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 12:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=62LisgB4vdQ1c8/8kKz4C1ZR0gAFFmPHrTTuWUasxRc=;
 b=I357LQfZoWHINcZeQOB0qENb6Wm1+23xXnjo8XkSmZKLJEzFpspjbAypIfyusq4IOA
 wtLfUE0E++I5ViHa1WBkjLsa9pRMaElsmGv9UeCg0DKFIlwSeg+Z4ApouD1x3KxU6o8U
 2nhnwZS2bJkJtVL+/iBuaLnZ/t45wrQKFA07cDsGQFFEAE7qQBCKyf6CPrXSzMCu3vKt
 mNc12vbFt0QU05MaHiKUS3CHtj3JaHPZD+LQO3uxjyqezzuZkg98BA92P93zrogwpQkC
 UAnCSDmbQo/DHTuq932KrHsIAiCZcfsSifethSJe5MVFC2xJ+yn+05GRU7W9gSopiH2C
 S3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=62LisgB4vdQ1c8/8kKz4C1ZR0gAFFmPHrTTuWUasxRc=;
 b=OknZW67Ur1LIlzcaNkh5vn1m7Iz3KBAkMCjaMmv7Dbiuee5PPGqX6LalPG9LchQtQw
 1wuN4WdQyuRY1ZGuyTwUxgpLzm4FdJn9Mbf1s3tlef2ZK5C+E0AmgnRcfyq4XSaAJ1UT
 dZPRNrSKClelSVD9oi+DI8U146vlCHkcM2HDUjW32jgkG/obwQ6xWMjvrPRFR2JbrzQ+
 2vSJ3jTtoocprUSsBWj0L17XFqTxJdDdcYjzG+H0+mcrrsLcKMBlBP6fLuTUGpTvzWTC
 qNxZ/H7irsvtg8jPxm6ROphf6RGOeSl9p5O+DuSL3MMTh0/Xc1zsPeE/VefvI7hJwn1k
 5hYQ==
X-Gm-Message-State: AJIora8WjD11PhOF6RdagNXo7JUAHOkQgzpQwCDzWFVqDaFjIAI8Oa6E
 eZ2N6v2ZB8ZdLzki85Wox2wUMlM1W5xXI92huaPS7A==
X-Google-Smtp-Source: AGRyM1vXl7wBE94PXzXIhMJnnOOI4FEuJNATilHuOmLU7pVA4YVkFPgDacg8SvhrLvy+nbmyEgKcJLDK1Vj/rnk63u8=
X-Received: by 2002:a2e:be22:0:b0:25d:6179:4439 with SMTP id
 z34-20020a2ebe22000000b0025d61794439mr7834488ljq.369.1657913538165; Fri, 15
 Jul 2022 12:32:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220618001618.1840806-1-seanjc@google.com>
 <19bba1a0-8fb7-2aae-a65a-1111e29b92d3@redhat.com>
 <YrHbml1HAfDtvMfn@google.com>
In-Reply-To: <YrHbml1HAfDtvMfn@google.com>
From: Peter Gonda <pgonda@google.com>
Date: Fri, 15 Jul 2022 13:32:06 -0600
Message-ID: <CAMkAt6p8_OUQ5rv7DsSjPX6_EUQV6TUn0L3Q4uT1B23e32PkSQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: selftests: Consolidate ucall code
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Sat, 16 Jul 2022 05:32:11 -0400
Cc: kvm list <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Colton Lewis <coltonlewis@google.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Andrew Jones <drjones@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Atish Patra <atishp@atishpatra.org>, linux-arm-kernel@lists.infradead.org,
 LKML <linux-kernel@vger.kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>
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

On Tue, Jun 21, 2022 at 8:55 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 20, 2022, Paolo Bonzini wrote:
> > On 6/18/22 02:16, Sean Christopherson wrote:
> > > Consolidate the code for making and getting ucalls.  All architectures pass
> > > the ucall struct via memory, so filling and copying the struct is 100%
> > > generic.  The only per-arch code is sending and receiving the address of
> > > said struct.
> > >
> > > Tested on x86 and arm, compile tested on s390 and RISC-V.
> >
> > I'm not sure about doing this yet.  The SEV tests added multiple
> > implementations of the ucalls in one architecture.  I have rebased those
> > recently (not the SEV part) to get more familiar with the new kvm_vcpu API
> > for selftests, and was going to look at your old review next...
>
> I had forgotten about that code.  My idea of a per-VM list[*] would fit nicely on
> top, though maybe drop the last patch from this series.
>
> [*] https://lore.kernel.org/all/Yc4gcJdhxthBKUUd@google.com

I just sent an RFC of SEV selftesting using Sean's suggestion built on
the first 2 patches in this series. I think they work well with the
encrypted VMs ucalling.

https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
