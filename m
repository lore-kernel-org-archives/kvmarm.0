Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C655F5692
	for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 20:47:35 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id p6-20020a170902a40600b0019c3296ecafso292668plq.4
        for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 12:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jglgM7rGS6BZeewgUjhjVdRgQ10E1ZkiBvAtcJmwM0A=;
        b=Fk69sJTezn6jkRmpd1DOlrDi/iIq2WXleRsAJDJTt7OkCksspb8tAY4dpElPLjf14g
         UoKLZ0QOmMWCJfm6BikS/IJ88Vg4VqOMTMmV32uVmzMww2ByXxzElWT78pCh6cUcgPat
         QU4eRWO4pp2JAr+eH5yWeJbT3WCxjenoN81nCBjvS57Y0o2w0mNOBKJ4TUdbx1ZO9htN
         58LBXXOCJRQrfJ6D2Y6HU8hUzXfkcX5Gu6q6JmojEiMCvn12bUrYIJk93iibcjqMseWJ
         QVa1D7Z2dhdXlzPZ3pzQQIg0AGsdFGJ/kGsdCOF5CWodQJJHb4Evwae+Md76WDEQODN4
         W9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jglgM7rGS6BZeewgUjhjVdRgQ10E1ZkiBvAtcJmwM0A=;
        b=oZAGxHtZu8s084B0e69E9fpSzoe6THIX7sCBdvS8MkIp/yeeszoVDRDvoluVZkAWXb
         e6CxzPz+AHhb4Be9EoHXZ5D/sevHDYUy1El9UcJpjjXKrYggjdYPSNcYFqd4dFe9je/N
         P5EqHAt/0fY4Vmo3ZPTezIIwpSOi5UZpMRKvvFjVmSg8qqtd2WsRcZbFwoGagKmMnE99
         CXJwA1SLJhbQ3BYywIjK+GQmwyRXpW/oTijG3W1RSPXyd7fcUeQ1t4v9axVDp47uQx4r
         RHJtyv+3YYVxrze0BqQK1UvjufJwTzHcG7OWjQB4dkcsmp17xq9ct1qwOY+YWpdp45yK
         QaAw==
X-Gm-Message-State: AO0yUKVc2bcnp1rE7w4EPWei4bQS1duiJUl8pAb2j2IB1SCYkT02aOVF
	DW8b7l04AQVTMjGG3pYMnHzCZC7ySLg=
X-Google-Smtp-Source: AK7set9UYCeqsW7R4kSLIqKVhLLvDClhaJZ1vJl7CZ3hUzRmm9/jrECrLYVaf6bJ9FxAYGOjU16oyF5BFjo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:914c:0:b0:4fb:933a:91d with SMTP id
 l73-20020a63914c000000b004fb933a091dmr267319pge.11.1676666855081; Fri, 17 Feb
 2023 12:47:35 -0800 (PST)
Date: Fri, 17 Feb 2023 12:47:33 -0800
In-Reply-To: <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
 <Y+6iX6a22+GEuH1b@google.com> <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
Message-ID: <Y+/n5X8+fGitI8FE@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Houghton <jthoughton@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	peterx@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2023, Anish Moorthy wrote:
> On Thu, Feb 16, 2023 at 1:38=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > Ensuring that vCPUs "see" the new value and not corrupting memory are t=
wo very
> > different things.  Making the flag an atomic, wrapping with a rwlock, e=
tc... do
> > nothing to ensure vCPUs observe the new value.  And for non-crazy usage=
 of bools,
> > they're not even necessary to avoid memory corruption...
>=20
> Oh, that's news to me- I've learned to treat any unprotected concurrent a=
ccesses
> to memory as undefined behavior: guess there's always more to learn.

To expand a bit, undefined and non-deterministic are two different things. =
 In
this case, the behavior is not deterministic, but it _is_ defined.  Readers=
 will
either see %true or %false, but they will not see %beagle.=20

And more importantly _KVM_ doesn't care whether or not the behavior is dete=
rministic,
that's userspace's responsibility.  E.g. if KVM were endangered by the flag=
 changing
then some form of locking absolutely would be needed, but that's not the ca=
se here.
