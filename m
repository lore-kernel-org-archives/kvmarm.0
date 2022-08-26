Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C529ECAAD8
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 21:38:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAFEA4D9D9;
	Fri, 26 Aug 2022 17:38:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qQnleAZQh2rN; Fri, 26 Aug 2022 17:38:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E944D9CF;
	Fri, 26 Aug 2022 17:38:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 755844A0FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 17:32:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZZg-KUREZOtc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Aug 2022 17:32:44 -0400 (EDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12EDD4D93B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 17:32:44 -0400 (EDT)
Received: by mail-lf1-f44.google.com with SMTP id q7so3575776lfu.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 14:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=fGX1OPYHOyAdnf6z71dmW2DwOr7H4Y5wRyKl79aJ7R0=;
 b=ZC1efQqpG/Yl12c9Sf0lbSneIvuydmkz6lD+4KwRibO24kQUatXopq6xrBTE+YeeyR
 q7A0vfCIleUquEfbTOnSyFHAwePTyBPeqv2/ma8GgFea/Ixx3aLVwoY9Fes1qIrjLDr1
 Nd6jCOOn88THmF7GLR+a8EWPAuq3Zz3zn1PzhUigNoDANZ/JbADf29mivcvkYSmlIyPY
 Mljmir8oMpLOPvbS8ez1m+7uKdlmCp6LGxmF12PPwjzauVS8cA/Z9xWvqjCO8f0T0wuz
 kyy+4B1CYpyEZxjTV7uWkKZFEeBcp8NRBYb+60p59rhCoYViV4f4TSJ6kjl/TbfqRvpL
 g1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=fGX1OPYHOyAdnf6z71dmW2DwOr7H4Y5wRyKl79aJ7R0=;
 b=qa9nHpvl/uLLdoAvQH93ok0iybvpCzZesb5WX2q5fIysIzs0aA+l6U4TZp8QhBMSes
 yDKPz6TtxcKD1RxTuCIDcw8GiUNThZDd+h6ph9Ng/dxpoUAZwqBu2TqlEkbOB12VNAq0
 FQnKwsmtPARJxJT5V+pXWrgvR9hNdVWzWjlY4APiZO++DmFdIagwID4qGCJ4RMS/HLbE
 6lWSnI2J0sNEpw7JxccTSyNf+jxuWJNjHUx/mew+lgJD161NVAouyd0zTlpC9l8gaD5e
 RjIIAp4PN2eCvGcKLbH2SV17e8hqwj6nD8IzKc9CQnq82vliCe2zIBM/RMZ9gZqN8ZMd
 CmbA==
X-Gm-Message-State: ACgBeo3XY3oCe7GPqkgVpnynT9RBHCO0MdESrWIvLgwkGE5uD4IiXJBE
 /tcSww6qtdyHHi/If3vmWE91YtmTGJQxnTt9A3t/sg==
X-Google-Smtp-Source: AA6agR4p8yZHknOzoft/51CAneJ1hrsnJGIMJ3qvD2H+dBtk7IsckDNc/Agfws5rxxUjM+VYCG98DW+qqx4b3NOZuyc=
X-Received: by 2002:ac2:4e15:0:b0:48b:3ad2:42c8 with SMTP id
 e21-20020ac24e15000000b0048b3ad242c8mr3415436lfr.391.1661549562159; Fri, 26
 Aug 2022 14:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220825232522.3997340-1-seanjc@google.com>
In-Reply-To: <20220825232522.3997340-1-seanjc@google.com>
From: Peter Gonda <pgonda@google.com>
Date: Fri, 26 Aug 2022 15:32:30 -0600
Message-ID: <CAMkAt6ryLh-gQYvmUYfxS3+CRwCLfK3Fby1W5NxxFLSK7M_v0w@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] KVM: selftests: Implement ucall "pool" (for SEV)
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Fri, 26 Aug 2022 17:38:28 -0400
Cc: kvm list <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Tom Rix <trix@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 llvm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, Andrew Jones <andrew.jones@linux.dev>,
 linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>,
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

On Thu, Aug 25, 2022 at 5:25 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Non-KVM folks, y'all got pulled in because of the atomic_test_and_set_bit()
> patch.
>
> Rework the ucall infrastructure to use a pool of ucall structs to pass
> memory instead of using the guest's stack.  For confidential VMs with
> encrypted memory, e.g. SEV, the guest's stack "needs" to be private memory
> and so can't be used to communicate with the host.
>
> Convert all implementations to the pool as all of the complexity is hidden
> in common code, and supporting multiple interfaces adds its own kind of
> complexity.
>
> Tested on x86 and ARM, compile tested on s390 and RISC-V.
>

Thanks for the help on the ucall-pool Sean!

I rebased the SEV selftests on these and everything works as before

TESTED-BY: Peter Gonda <pgonda@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
