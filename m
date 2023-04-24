Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4AD2F58
	for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 20:35:38 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-b8f566ea5e6so23359936276.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 13:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682368537; x=1684960537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l0MSB0945IeDbGQp04rwPUWUysYiVEFGxMNvNn3R9Dk=;
        b=qaA5kj5BLRufFr7HOEwoBj3xuBzT1MM3EqwX810KDK1PJXDmUfYJ4nLm6oNBrqzq5D
         kejv9Yn+BLxpQduLI7gZUWw5gg/LBJYf3iyGlCxVa9XwjUZ25tQcKo5XQXlK34L7VDCT
         e8a1tXQmghUZAYQ9+o8GJvHhq+yTaQ4YM0XuenE3DXhhq66Er3TLgg2gNW3i+21vEsNN
         Y7V8kMT8/uufww59U8/Jw4hwCThUoOVjtCfYbwbJT0IT92HGuHwvl5gdbMD9oZslPNIp
         hcbYSB3xiE3IY0nL4OfpglITPYjFC/j3293vJZ8dlb/JEUjXuPa3xYxVo+u2J/DS9N39
         lCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682368537; x=1684960537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0MSB0945IeDbGQp04rwPUWUysYiVEFGxMNvNn3R9Dk=;
        b=VUTBqx+N8LWfulkuGjckqMXM0yX3TYBUmGje7gWDjvymlwg0zIVzt7FuFNVNMcgvmM
         SMps0Acp6Buu5CC9CubiA0cEho/7OBSTEB8Q7aY8kVjwVl7s/FlUlJjxUniBmdVH7362
         8ffJH2mkSK3wpZ8GQvc6d45G1OG7mvIB5mLETNWWRGk3bxoWNECcEfqL/tZ9TVOZhA8E
         uG1dHHObGNaJ/eXmXqcdwQbpjq5th35kPj5a78ozBne1kH0U1zuK7GhtlKynQq96KGAs
         fBTTvAqp9u6tH9+4rvsqrQXaZFpHJt93PTyAd2N7zcpNmCC7oX1owdoJGtMNSh5sHGfr
         Tn/w==
X-Gm-Message-State: AAQBX9fTTwfDY7XNIw3XY3Ksuu2r3y8DeyFSy4V23SraHFik9lo86PEp
	I+9bFP4q4uUyahbM3EOcCNylmwcybpc=
X-Google-Smtp-Source: AKy350alWB2/sn7vnmKB09ekH2Ungj1lC+xvK8PVtElvPqniaZwd+kmU7CpSimCq0rTDwuANLLp2/iz809o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2b88:b0:54c:15ad:11e4 with SMTP id
 en8-20020a05690c2b8800b0054c15ad11e4mr8066797ywb.0.1682368537764; Mon, 24 Apr
 2023 13:35:37 -0700 (PDT)
Date: Mon, 24 Apr 2023 13:35:36 -0700
In-Reply-To: <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com> <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
Message-ID: <ZEboGH28IVKPZ2vo@google.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Sean Christopherson <seanjc@google.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Anish Moorthy <amoorthy@google.com>, Peter Xu <peterx@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org, 
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 24, 2023, Nadav Amit wrote:
> 
> > On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> wrote:
> > Sean did mention that he wanted KVM_CAP_MEMORY_FAULT_INFO in general,
> > so I'm guessing (some version of) that will (eventually :) be merged
> > in any case.
> 
> It certainly not my call. But if you ask me, introducing a solution for
> a concrete use-case that requires API changes/enhancements is not
> guaranteed to be the best solution. It may be better first to fully
> understand the existing overheads and agree that there is no alternative
> cleaner and more general solution with similar performance.

KVM already returns -EFAULT for these situations, the change I really want to land
is to have KVM report detailed information about why the -EFAULT occurred.  I'll be
happy to carry the code in KVM even if userspace never does anything beyond dumping
the extra information on failures.

> Considering the mess that KVM async-PF introduced, I would be very careful
> before introducing such API changes. I did not look too much on the details,
> but some things anyhow look slightly strange (which might be since I am
> out-of-touch with KVM). For instance, returning -EFAULT on from KVM_RUN? I
> would have assumed -EAGAIN would be more appropriate since the invocation did
> succeed.

Yeah, returning -EFAULT is somewhat odd, but as above, that's pre-existing
behavior that's been around for many years.
