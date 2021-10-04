Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4309C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 18:27:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E2B361251
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 18:27:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2E2B361251
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9DCF4B267;
	Mon,  4 Oct 2021 14:27:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HS+meYDIFVBl; Mon,  4 Oct 2021 14:27:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B63AB4B2A6;
	Mon,  4 Oct 2021 14:27:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA67A4B278
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 14:27:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tAMABLd6pSX6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 14:27:08 -0400 (EDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com
 [209.85.219.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A790A4B267
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 14:27:08 -0400 (EDT)
Received: by mail-yb1-f172.google.com with SMTP id z5so39902584ybj.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 11:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PIqLRUwkpWrhqoIb+2LbHIi6YwYZzYCnePRyYQW7lLY=;
 b=gjvD3+vx4+r4kREI+kJyLRqAt3T9ueCkkwyrIGXw4kVjsxk4B+g3/MppZhl7N6wTiV
 PMJqtTnyCh8HPiYVaClZKX6vsiy/6Hky+sKMa3Lv0KbQMju9xs4Np2wLdKgAB0JjT9Od
 WKQmaL+SK4LQ59q2qi8GLJ4pEsOTqRJWOl1nQNfc6qULxZIsXFlxrSF4fWxTsGlbaevw
 2YN7Xw8DA2tlSfBVpAcffPslrlDJrVUOjvu3UqCLjaEuFPaWwtlUYBZRaMkFjY1QzZ/Z
 uDOdzZ5anwcBpaqRWOz2jV0W6w/UdOifflY5/OMNNvn9JP/fumSBYvDtWLn74afG0khE
 2vwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PIqLRUwkpWrhqoIb+2LbHIi6YwYZzYCnePRyYQW7lLY=;
 b=o0fBSVRJHFpfgDU9Yupuc1V/wHzfdRzxkHpgXdJa1HdvGP+gTRkv/ZpmgXZcQSJ1Hu
 uXX/zhzjE7FD6/OMTvnBqaR5LlTUoqdlJQeIGxVH8DMtHgLMfr06K7cYBLtWU0OS2ccQ
 hFReU2Q/8td3yXIGcY0OaOGNecTAGWiila/pCW2J6YL9/Okhbi268SjWAYZQNI2I8WEE
 nHBpZoszpNHF3wePw9kLChI1xZ1R1CswhVLwRiTfmeZgx5u+bK/AyO8RxkVKFnmXLTn7
 XyscsiaYISTcP8gmy11L+Uwc4vbCICzUYaLDBU7ILqxqVhVSTFxAiuHoscM1F+hsy2bs
 BCqg==
X-Gm-Message-State: AOAM530Pl8K1o2banURPtqgCFR3mM137zB0V5dy2F7LD7iEDkjPM3vsj
 S1JMI+UVmUUIxX4fRoX5vlisiSlo5C6c1bOklNvVoQ==
X-Google-Smtp-Source: ABdhPJwQO8pJHFNb8p9v0Uv+zTJOyZYyUBFOwoiGCzuPT59UynGevvRHp+VVKupk5VUaX29Kw8b7Zy4woqEdE6YhWDI=
X-Received: by 2002:a5b:283:: with SMTP id x3mr16689301ybl.439.1633372027973; 
 Mon, 04 Oct 2021 11:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
 <20210914223114.435273-13-rananta@google.com>
 <ab2a7213-1857-6761-594d-958af864a23a@huawei.com>
In-Reply-To: <ab2a7213-1857-6761-594d-958af864a23a@huawei.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 4 Oct 2021 11:26:57 -0700
Message-ID: <CAJHc60yXKdCCpSejxwGpmqoTenm=3589+ahmzkLkSnmy89+YLQ@mail.gmail.com>
Subject: Re: [PATCH v7 12/15] KVM: arm64: selftests: Add basic GICv3 support
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 30, 2021 at 1:06 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
>
> On 2021/9/15 6:31, Raghavendra Rao Ananta wrote:
> > +static inline void *gicr_base_gpa_cpu(void *redist_base, uint32_t cpu)
> > +{
> > +     /* Align all the redistributors sequentially */
> > +     return redist_base + cpu * SZ_64K * 2;
> > +}
> > +
> > +static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
> > +{
> > +     void *sgi_base;
> > +     unsigned int i;
> > +     void *redist_base_cpu;
> > +
> > +     GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
> > +
> > +     redist_base_cpu = gicr_base_gpa_cpu(redist_base, cpu);
>
> This is not 'gpa' and I'd rather open-code it directly as there's
> just a single caller.
>
> Zenghui

Thanks for catching this. I agree that mentioning 'gpa' oddballs this
function, since it's called from a guest's point of view. If there are
any other major changes in the series, I'll try to change this as
well. Else, I will try to raise a separate patch to resolve this.

Regards,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
