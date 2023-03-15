Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACFD6FC3
	for <kvmarm@lists.linux.dev>; Wed, 15 Mar 2023 21:01:00 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id k3-20020a170902ce0300b0019ca6e66303so11041604plg.18
        for <kvmarm@lists.linux.dev>; Wed, 15 Mar 2023 14:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678914060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UoDvobVQiPMq5acwjCe9688yztYKCiKKo2a8h2clq3Y=;
        b=ABsYD8ivxczrfhW46NqRAYHlkYUpTpC/r4227tqpcgEUGcqmOIJjmJkUXsyslLEZp3
         h6A5RbNktFzEqVzHBEIkMJCft6k2dqY8WR6mjI6m0voJrU/B3sWSQ+PlVuOXTLPytZ+m
         02xaQdGzHShm7xD1s3vveeUjSypDW+kpfzfx2tyf8OGH8SA+A2Wo+otnTl3myqa0/Hgg
         gcnUHxdx1vv/Ldm8vzJ7o+lOMOKa3WDhSFkx1Pq5cm9TieHZO7rIyzZYnAnsAhLKCIKq
         HByZO7+N7kUN+s1qfw5LCtY8jUR5kpsWzVT21LE24/wuBV5ZHgSnFHLUJBSZbhZ4bXkf
         ICDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678914060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UoDvobVQiPMq5acwjCe9688yztYKCiKKo2a8h2clq3Y=;
        b=G7vwIpCprzHAprDNlrYAw6GwKc5HSZ6NTJoH5Lg1ooYRSC2+MpSMB4iuHd3vKj55F8
         D/h2UTeGKGBJT2WS3+zjIF3pKyHnOa90DilYdfcQbw9H6vApXtv5ZKEfKElVKT/HKbt/
         01vmSVgJSXs1mmPjQk1SCDNNykmCBdbxviQe3HUIBvGcmVKQbNVS8DGhP3nbQD+a9sq9
         iU5HbWuR+SlD5XBN3vAEuOpRQ0a7g10m9Nhf7dTwTCZD0Lz2vVWpgQN/PsLAVf99Peho
         U3TmLi3qTZxNC/Sug2oR3acAcjEFCIofxO0bcWmJYK/6pBq9mLOScFHyCa+Ex32jrKBW
         RC6g==
X-Gm-Message-State: AO0yUKVNwjeMeZ56XpjQPQo7/isf8msVMyv30/keEAXndiDngLnCjRkj
	Vu4/LKE0QJNlFa4QUczk7rSgEKX5vjs=
X-Google-Smtp-Source: AK7set9I2d7zMrmbQqwepgi6EVy423MROFM770G/8niG8EsRE4Q4WDIEw2I/e22xzRSKFbKIa6cM2vJUBss=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d48f:b0:1a0:144b:6489 with SMTP id
 c15-20020a170902d48f00b001a0144b6489mr398143plg.10.1678914059460; Wed, 15 Mar
 2023 14:00:59 -0700 (PDT)
Date: Wed, 15 Mar 2023 14:00:57 -0700
In-Reply-To: <86ilf3y6u7.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com> <20230307034555.39733-8-ricarkol@google.com>
 <878rg25hbq.wl-maz@kernel.org> <ZA8+31vQA6vcQuK2@google.com> <86ilf3y6u7.wl-maz@kernel.org>
Message-ID: <ZBIyCQXPVEAkJZES@google.com>
Subject: Re: [PATCH v6 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, alexandru.elisei@arm.com, suzuki.poulose@arm.com, 
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com, 
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 14, 2023, Marc Zyngier wrote:
> On Mon, 13 Mar 2023 15:18:55 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Sun, Mar 12, 2023, Marc Zyngier wrote:
> > > On Tue, 07 Mar 2023 03:45:50 +0000,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > No functional change intended.
> > > 
> > > I wish people stopped adding this pointless sentence to commit
> > > messages. All changes have a functional change one way or another,
> > > unless you are only changing a comment.
> > 
> > The implied context is that there is no change in runtime functionality, which
> > does hold true for many changes.  I personally find the annotation helpful, both
> > for code review and when doing git archaeology.  If a changelog states that the
> > author doesn't/didn't intend a functional change, then _any_ change in (runtime)
> > functionality becomes a red flag, and for me, prompts a closer look regardless of
> > whether or not I have other concerns with the patch/commit.
> 
> And I think it lures the reviewer into a false sense of security. No
> intended change, must be fine. Except when it is not. More often than
> not, we end-up with seemingly innocent changes that break things.
> 
> It is even worse when things get (for good or bad reasons) backported
> to -stable or an internal tree of some description. "No functional
> change" can become something very different in another context. How do
> you communicate this?

For KVM x86, we opt out of AUTOSEL, so barring errors elsewhere in the process,
a maintainer needs to review such patches at some point.  And again, for me,
sending a patch to stable that was intended to be a nop is a flag that the backport
warrants a closer look, e.g. extra justification for why a patch that's (allegedly)
a nop needs to be backported to stable kernels.

I agree it's imperfect, e.g could lead downstream maintainers astray if they view
the disclaimer as a statement of truth as opposed to be a statement of intent.
But IMO the good things that come from being able to know the author's intent far
outweigh the probability of bad things happening because a reviewer and/or downstream
consumer put too much weight on the statement.

My opinion is certainly influenced by having spent far too much time digging through
historical KVM x86 commits, where it's all too often unclear if a buggy/flawed
commit was simply a coding goof, versus the commit doing exactly what the author
intended and being broken because of bad assumptions, incorrect interpretation of
a spec, etc.  But even with that bias in mind, I still think explicitly declaring
an author's intent for these types of changes is overall a net positive.

Anywho, I don't mean to step on toes and force my preferences down everyone's
throats, just wanted to provide my reasoning for including the disclaimer and
encouraging other KVM x86 contributors to do the same.
