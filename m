Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E01DC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB3D4B106;
	Wed, 23 Mar 2022 05:57:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KB2DvmNfFa+v; Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE814A0FE;
	Wed, 23 Mar 2022 05:57:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55ADA49EED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:21:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oS9NNj4IHi4u for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:21:58 -0400 (EDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3094A49EE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:21:58 -0400 (EDT)
Received: by mail-lf1-f50.google.com with SMTP id k21so14701285lfe.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WAKfsHYufu3U00AAQ3K6rkkqvblKGp7U0moxttx1nDc=;
 b=g2Mo8JicfcFH/ca4r/k8qwzNmJcqohXhHSc8ZN1vggO+ws0hE9XyigO2hPYcPZWWtk
 wNEza19s0fPDjH5GX8/kKgwDj/AAV9pY4XeHmvC71+6Y6ICWamfbXU6C9YM9stEziAjS
 Pyzvv0cV9b5kaL2Vw0X3sHjwvfQugdxpBZP6WpNszpT8tGNVYT59NDnhX2XhWEiAEB2q
 R6auCiZeG6hXuo36MJY34i1dlEJGkAos2ZUzCMTTS5Ma09OmY4Ad9S5p/J99OkWTba+X
 viy50q5OpxBRGYxh9kdfQAiI1GToU553m9eY93dV6MAHbc4QHm6K6V/UCEWO+8O6FNPA
 Fxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WAKfsHYufu3U00AAQ3K6rkkqvblKGp7U0moxttx1nDc=;
 b=4ZSB1seoYKS51VRlDzoqQ7Wa0CZYQlsCiwxuIA9SGVBZzKfPFSD5gWHZsUEv9nJONF
 lJXvj08YLqkE5Z2lHHH9qjePKFBeTp7UYxd9zgZBsVW5QknMJSkv4EFquFKhbGPH4mzD
 rxTYeURbNcFCLK9RKtGEFwfR1vYrGLmCQ/91h82t3ywzERXIzjCga+PJqv+4XQPO3X8b
 cgfiv3RwF32XgK3SEA8hLhuiAq3kTlWUbzM5IS5mCxg9xZjWfaibEkV0Y1ppll1FI3l+
 gomc2uwtA7ajg4n78ao5xyCwOMFmkK5/Lp8rSo0m2G1IT2qlGagxPjtGGEXdZWmHGI1X
 aU5A==
X-Gm-Message-State: AOAM533cD8mJSz18LeWQKBaLiVqj/NZdwWDMZFFiUt2r+Wu6KPUCndVY
 5UuNeKKTCB2VjTaMvjXsoIBaqLFASsgzH8A3roBLYg==
X-Google-Smtp-Source: ABdhPJyrSF1plRNyRh9A7BhcuZu0NWWd/cVBt3Nl5hNQUOvH0RUPVILChyti/fD/O7GaiC+DirE+BwoMtfWc3XC9kZI=
X-Received: by 2002:a05:6512:1114:b0:448:388c:b79f with SMTP id
 l20-20020a056512111400b00448388cb79fmr19109715lfg.250.1647973316603; Tue, 22
 Mar 2022 11:21:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-3-dmatlack@google.com>
 <YjBEWm3YsuSKj+ES@xz-m1.local>
In-Reply-To: <YjBEWm3YsuSKj+ES@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 11:21:30 -0700
Message-ID: <CALzav=cMFL=ZZyV5uckbhb3RqC0LhOnnooiJGKKN26F69TF63A@mail.gmail.com>
Subject: Re: [PATCH v2 02/26] KVM: x86/mmu: Use a bool for direct
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Wed, 23 Mar 2022 05:57:13 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, Mar 15, 2022 at 12:46 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:04AM +0000, David Matlack wrote:
> > The parameter "direct" can either be true or false, and all of the
> > callers pass in a bool variable or true/false literal, so just use the
> > type bool.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> If we care about this.. how about convert another one altogether?
>
> TRACE_EVENT(kvm_hv_stimer_expiration,
>         TP_PROTO(int vcpu_id, int timer_index, int direct, int msg_send_result),
>         TP_ARGS(vcpu_id, timer_index, direct, msg_send_result),

My preference would be to keep this commit specific to uses of
"direct" that are related to shadow pages.

The parameter `direct` in trace_kvm_hv_stimer_expiration() looks like
it could be converted as well, but is a different concept altogether
despite having the same variable name.

>
> Thanks,
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
