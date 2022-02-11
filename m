Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D455CC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 05:04:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5186149F3E;
	Fri, 11 Feb 2022 00:04:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1+FKEy3+1Hu9; Fri, 11 Feb 2022 00:04:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CBEF49F2C;
	Fri, 11 Feb 2022 00:04:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93AEC49F0B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 00:04:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l64id8LxP7jS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Feb 2022 00:04:31 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66E1249EF3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 00:04:31 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id
 v5-20020a17090a4ec500b001b8b702df57so10827094pjl.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 21:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hafp+SZmlpr9AIwlLC0AjbdundomKkMQTM3i7h5hOko=;
 b=HEmqti9TBXPB3AgN69donMmH29Y5xqziF2WLDQcCD96zK0fU5P6wypu/8lgYF25myR
 di+zV3FTrLjipVxiPY3X97CT5YE0pRdBQxNXOuSNGi/8pzZeZYIlHFcCB5Hlm0Q9FWSm
 qnuH2jYgA9ahhyiMcZ7St/2u2UiHo17yD9ZKPYWJFtj72/Vu26fHu6/3PGqB32j481UI
 Z3isYpTw7Hcq35PSpqRSkqualueaMF/Kfv9Mx5P4VYlO5OgpNLs+GQqoE8okm9BHvjPx
 YlSuNiDxiaWm5eDr7gcCdbpie6pq/crRlk5RMcnwa/TJwY+A2h0HoD/jPoeOzspyyeNb
 LUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hafp+SZmlpr9AIwlLC0AjbdundomKkMQTM3i7h5hOko=;
 b=UgYG12euISjwtU+IGCgiMlTWuIsyxSoRl5uGlpPAPmH81wZ0xEM9v1/yxdYxAbwTRz
 ueEcaz9lpk0qYX87NfIz31iReqWX4lGaecPKbnPuh25cFmyaZJsVbqV1JrjO2gErnvlA
 tik2z8y+Tf1IqZaZC84nxoJdVuOW2UX0bAxqulLb+m4XObf4+Od7KKo0uBUiPlMgExqu
 i6BeCf23J+aNs2taHWw+4eW5DSG0C+raWhXu7lScHMml8xSlPJkno5BEnY5LMOqh32ez
 Z09bbHeISPCjNShFkxdVLIdUB7kQlZJNwi5SGTT+Sso4E0QHeJ3snXiLzvCtTpeVdMUF
 VU8g==
X-Gm-Message-State: AOAM533qfmYWXx2qiiauvIBFtWNYGABxCvKRznsNtr9Xh5rLo8+ryUJl
 uAhC07KhP4wGSGV5bHhkgJxYwuFoQlGbRWznAmmurg==
X-Google-Smtp-Source: ABdhPJxVpz+4mZJs01nTXHzISx4FfZlba+M0gcEsKqH63dBrGFwxdQMBlt246gsdjFdx9ihmmFqnpFYoybH0AaYSP78=
X-Received: by 2002:a17:90b:3c6:: with SMTP id
 go6mr912970pjb.230.1644555870192; 
 Thu, 10 Feb 2022 21:04:30 -0800 (PST)
MIME-Version: 1.0
References: <20220118041923.3384602-1-reijiw@google.com>
 <87a6f15skj.wl-maz@kernel.org>
 <CAAeT=FwjcgTM0hKSERfVMYDvYWqdC+Deqd=x2xT=-Zymb6SLtA@mail.gmail.com>
 <875ypo5jqi.wl-maz@kernel.org>
 <CAAeT=FwF=agQH-2u0fzGL4eUzz5-=6M=zwXiaxyucPf+n_ihxQ@mail.gmail.com>
 <87wni33td7.wl-maz@kernel.org>
In-Reply-To: <87wni33td7.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 10 Feb 2022 21:04:14 -0800
Message-ID: <CAAeT=FzGP6jcsDbhZsNZVCUib8UQ4zc+y6s0TrsaKjAKx9WSWg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Hi Marc,

> > > Also, we really should turn all these various bits in the kvm struct
> > > into a set of flags. I have a patch posted there[1] for this, feel
> > > free to pick it up.
> >
> > Thank you for the suggestion. But, kvm->arch.el1_reg_width is not
> > a binary because it needs to indicate an uninitialized state.  So, it
> > won't fit perfectly with kvm->arch.flags, which is introduced by [1]
> > as it is. Of course it's feasible by using 2 bits of the flags though...
>
> 2 bits is what I had in mind (one bit to indicate that it has already
> been initialised, another to carry the actual width).

Understood. Then, I will take the patch and will work on v3.
Thank you for all the comments!

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
