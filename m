Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00209C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFE484BB3F;
	Thu, 10 Nov 2022 09:52:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WgL7djMPsnzX; Thu, 10 Nov 2022 09:52:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE394BB82;
	Thu, 10 Nov 2022 09:51:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4BC54BA22
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 18:00:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3aOpMvoSwY3B for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 18:00:27 -0500 (EST)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE3C24BA1C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 18:00:27 -0500 (EST)
Received: by mail-qk1-f175.google.com with SMTP id z30so152355qkz.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 15:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=cmFG+lMjzf/ZVIEgSvSUi/Kw8nPzVjb1fGFMbu/W5vY=;
 b=dudkNi4O683uD+TNndcPtPCeCpa9QA7FbrHjaVOmIRg+UIGVhAfjaXmH9wBmtQDeLP
 uNHcUO7j+uCpDHYxGSZ329F4Pqk6v23Tz3bL13gqm3RiGz3qJQ/5WwLouTw/AcT5Af9A
 rQwCxIpQ+YDTTjArHhx2QEoIvvIdpsL61e+NndZ9oI8EQss2i6rc9Xfaom1mQcgOEuKg
 X725WqyvZrKDxE82nLTfL2duzd2WFlc4dcdajM8jpWTqjR8pxMwjOHMgSw7/94Xya4Fw
 OtHNgVbPfchbdE78tQKPU3oB9S3RIz76UsqxoZzTcwc1Vr43CTJ+spRrWppH+q9QCzYf
 4lBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=cmFG+lMjzf/ZVIEgSvSUi/Kw8nPzVjb1fGFMbu/W5vY=;
 b=OTolMPUxI4gxCxuizbzH19ABNm92kMAOK4q8LPNClbBW4t3QOav3BfcNkT7sqocVUC
 snbmclTRjgcdk+xc4wqPNKH9CptfzI7BaU46w63KzzvUj8MHj9NistvumiJzcFJAjOfK
 LDnCBzel8kp4zEHNbcnYFxavOj6nhMGuJatPJjbEqQqxxUGqWU8iCFrklamagipJD3Zo
 Ng3Uq7fHigrfGTw6dxTMdQcOJbdc19r8be7h+/X4ecJI/itrSBFRUksiiv5yjSgagFdG
 NPodmXwDbaNnS3Xsi3N99C0+jLnk+Xe7iCj292nMLAMu5OHiJdvUnLSri/bK1eUAsHfA
 ZOwg==
X-Gm-Message-State: ACrzQf1aYGknUiYBKC/6O/eBUlDSZhSpmwifHtI+8kK82YVMtNCjL4ob
 UvzKVeirmtdR2AuRDz6rqh6wfcpOT42kwAkbpSZ66A==
X-Google-Smtp-Source: AMsMyM4kdVFylTXfA6FM8xY8axVjaBWiaQEF+FUnFYjRSXBpMV5wYMwqbp4Gdq5EBHSBdeNF/gET466fMdMwNRFqj/U=
X-Received: by 2002:ae9:eb48:0:b0:6fa:d61:4510 with SMTP id
 b69-20020ae9eb48000000b006fa0d614510mr43595869qkg.768.1668034827137; Wed, 09
 Nov 2022 15:00:27 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-10-oliver.upton@linux.dev>
 <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
 <Y2wswsHgDHIIXram@google.com>
In-Reply-To: <Y2wswsHgDHIIXram@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 15:00:16 -0800
Message-ID: <CANgfPd_=6r1pmuNbrEdiom4JpryUBkVxxxmKTCN+xfiAQYrP0w@mail.gmail.com>
Subject: Re: [PATCH v5 09/14] KVM: arm64: Atomically update stage 2 leaf
 attributes in parallel walks
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Nov 9, 2022 at 2:42 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 09, 2022, Ben Gardon wrote:
> > On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > @@ -1054,7 +1066,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
> > >  bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> > >  {
> > >         kvm_pte_t pte = 0;
> > > -       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
> > > +       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);
> >
> > Would be nice to have an enum for KVM_PGTABLE_WALK_EXCLUSIVE so this
> > doesn't just have to pass 0.
>
> That's also dangerous though since the param is a set of flags, not unique,
> arbitrary values.  E.g. this won't do the expected thing
>
>         if (flags & KVM_PGTABLE_WALK_EXCLUSIVE)
>
> I assume compilers would complain, but never say never when it comes to compilers :-)

Yeah, I was thinking about that too. IMO using one enum for multiple
flags is kind of an abuse of the enum. If you're going to put multiple
orthogonal flags in an int or whatever, it would probably be best to
have separate enums for each flag. That way you can define masks to
extract the enum from the int and only compare with == and != as
opposed to using &.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
