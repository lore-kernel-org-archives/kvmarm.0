Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003276138
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 01:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721267982; cv=none; b=PnOcpRJv0bWPTi/12u8w0YYzc4ZKtrGl6oyhwvKXUOW5ddsxbjUCO+cq12pB5/gVbJzo4wk4rGWcW9uCoIovedqYwMpEQKv63ciWIHkjY52t6nQRlYIMVUSPuZAsQDdkOxViqOXel+o32ZKb0hVowAAODw3erekejnHsa+UuA9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721267982; c=relaxed/simple;
	bh=fwy7tFrFnUI3LzbR2916EQ2Ng8NP4m5zIbrt2rE9Xrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M29FHVPzJTAS2BkXITwAYzappHo5xcknJPbpEgpqCL/TFrxMDr8zXy06nEXXDyjZssXu49Lw+Q5n83JfHN36HCaCEwRZKb+gbZshH1sPM5mrR4J8UUAmdJJ+64E0C1pUl/Lyn0WKNzBT9w1AELWWLUB7+ZTUUv+Mcx05hdcrkOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SLGVq1b8; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SLGVq1b8"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-44e534a1fbeso91341cf.1
        for <kvmarm@lists.linux.dev>; Wed, 17 Jul 2024 18:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721267980; x=1721872780; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwy7tFrFnUI3LzbR2916EQ2Ng8NP4m5zIbrt2rE9Xrc=;
        b=SLGVq1b8DzBCuHqxCnc/PlI/MxKGqc4x7uoRcQJKCeQZzxOXcS4jyyZyAD55NpPvkf
         A1YGRN5aDRpQqfso2Iu5uxw+36cGSvLNL7de0PZ/W0Ua1y3HgTX7rShBKmM8HAznrsqP
         KvoiJ9gKb81LSIIu9d/HhWh6/NNeTc7dYp7GE+iJZR/P7kmkPDFsaIRxay6fPDg4P+2V
         Wj3DHFAzWd6rtdT9def+ERzVQOpeo6ooqkq0p6VQbKjqnSK6ZFY+YSeMgLxvGkW1ETwz
         YOBv1mOzi34NwIHwzO/a/kcOC/bSwFwR8CwKZ0UK+OCYgPTk0VhMIRzBE/Hyj8bsGL/j
         FlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721267980; x=1721872780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fwy7tFrFnUI3LzbR2916EQ2Ng8NP4m5zIbrt2rE9Xrc=;
        b=QH7Pttg0Hjdr4ZMqJF1M7kr63K8y1DVlpnicOEvyEXevi6B46zN2AANjDL0CqlOai0
         +r/peND6FkfRza9khhXlWUUZDEphiuy19vbpa6f4crQsbS8gbb2d/Jz1pMYafe4M/Y48
         Spij3Lv3wracPgNn63KiGjmN5A/ICLZt6cqqOfAvS0bX8+jXQXdYquY2z7x/3BKGysbN
         VpnTqfZxY2fDXn0J7nEUOaea9z3sphES7xMNJmhMNTTT87umh+drc4pbv/MDeOzEZN+8
         p+UzdfoDC7RO8r+OWomp0Q87jhd7ABqRopd/45psw5bK09ncQ9AaGv7hOWbR2LDJNQ2e
         V8qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvNgi59p2xlJ2R+d/DaFWQ4NAvKXvAkg1Dy/SDSdwpnXATU27JZkDg7fOmoRKm3y8gztOhml0z/dnQRWuA5Rrcy2ldZyqM
X-Gm-Message-State: AOJu0YwpjjXtqHMGwugu6NEGEnM1RuGSOeJbTPmzg3hk/xCndosZcmxs
	1SNT6sUH8JUXQaSpHSAPa4eC3Kz3UMOuP0J6+t++/xyd3iOyVbyvOco+H6sw1FYkCoKH6JA5K5m
	9MomiqY9KAIHsSNSHupT7wQZrn7YrE9uwmYZg
X-Google-Smtp-Source: AGHT+IE58y37covXCZXpnSJtGTosaOLDYejn3iVUtH4Ayy+oebIBQjA8FkdBSlTvRYoeDLEBTBvkMRc0DIX3l5grc1I=
X-Received: by 2002:a05:622a:4d06:b0:447:e4cb:bf50 with SMTP id
 d75a77b69052e-44f91ae2480mr892591cf.8.1721267979720; Wed, 17 Jul 2024
 18:59:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com> <CALzav=d+eALgV5UKnwHh67XYba53tkWwDNPWrThcmCP++sCiLg@mail.gmail.com>
In-Reply-To: <CALzav=d+eALgV5UKnwHh67XYba53tkWwDNPWrThcmCP++sCiLg@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 17 Jul 2024 18:59:02 -0700
Message-ID: <CADrL8HUi2x2z+Jow_rb+iiuySWMCRq8Ti6SwzBoHUNSH1mcYhw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 4:37=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Wed, Jul 10, 2024 at 4:42=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > --- Preventing access: KVM_MEMORY_ATTRIBUTE_USERFAULT ---
> >
> > The most straightforward way to inform KVM of userfault-enabled pages i=
s
> > to use a new memory attribute, say KVM_MEMORY_ATTRIBUTE_USERFAULT.
> >
> > There is already infrastructure in place for modifying and checking
> > memory attributes. Using this interface is slightly challenging, as the=
re
> > is no UAPI for setting/clearing particular attributes; we must set the
> > exact attributes we want.
>
> The thing we'll want to optimize specifically is clearing
> ATTRIBUTE_USERFAULT. During post-copy migration, there will be
> potentially hundreds of vCPUs in a single VM concurrently
> demand-fetching memory. Clearing ATTRIBUTE_USERFAULT for each page
> fetched is on the critical path of getting the vCPU back into
> guest-mode.
>
> Clearing ATTRIBUTE_USERFAULT just needs to clear the attribute. It
> doesn't need to modify page tables or update any data structures other
> than the attribute itself. But the existing UAPI takes both mmu_lock
> and slots_lock IIRC.
>
> I'm also concerned that the existing UAPI could lead to userspace
> accidentally clearing ATTRIBUTE_USERFAULT when it goes to set
> ATTRIBUTE_PRIVATE (or any other potential future attribute). Sure that
> could be solved but that means centrally tracking attributes in
> userspace and issuing one ioctl per contiguous region of guest memory
> with matching attributes. Imagine a scenario where ~every other page
> of guest memory as ATTRIBUTE_USERFAULT and then userspace wants to set
> a differient attribute on a large region of memory. That's going to
> take a _lot_ of ioctls.
>
> Having a UAPI to set (attributes |=3D delta) and clear (attributes &=3D
> ~delta) attributes on a range of GFNs would solve both these problems.

Hi David, sorry for the delay getting back to you.

I agree with all of these points.

>
> >
> > The synchronization that is in place for updating memory attributes is
> > not suitable for post-copy live migration either, which will require
> > updating memory attributes (from userfault to no-userfault) very
> > frequently.
>
> There is also the xarray. I imagine that will trigger a lot of dynamic
> memory allocations during post-copy which will slow increase the total
> time a vCPU is paused due to a USERFAULT page.
>
> Is it feasible to convert attributes to a bitmap?

I don't see any reason why we couldn't convert attributes to be a
bitmap (or to have some attributes be stored in bitmaps and others be
stored in the xarray).

>
> >
> > Another potential interface could be to use something akin to a dirty
> > bitmap, where a bitmap describes which pages within a memslot (or VM)
> > should trigger userfaults. This way, it is straightforward to make
> > updates to the userfault status of a page cheap.
>
> Taking a similar approach to dirty logging is attractive for several reas=
ons.
>
> 1. The infrastructure to manage per-memslot bitmaps already exists for
> dirty logging.
> 2. It avoids the performance problems with xarrays by using a bitmap.
> 3. It avoids the performance problems with setting all attributes at once=
.
>
> However it will require new specific UAPIs to set/clear. And it's
> probably possible to optimize attributes to meet our needs, and those
> changes will benefit all attributes.

Ok so the three options in my head are:
1. Add an attribute diff UAPI and track the USERFAULT attribute in the xarr=
ay.
2. Add an attribute diff UAPI and track the USERFAULT attribute with a bitm=
ap.
3. Add a new UAPI to enable KVM userfaults on gfns according to a
particular bitmap, similar to dirty logging.

(1) is problematic because it is valid to have every page (or, say,
every other page) have ATTRIBUTE_USERFAULT.

(2) seems ok to me.

(3) would be great, but maybe the much more complicated UAPI is not
worth it. (We get the ability to mark many different regions as
USERFAULT in one syscall, and KVM has a lot of code for handling
bitmap arguments.)

I'm hoping others will weigh in here.

> >
> > When KVM Userfault is enabled, we need to be careful not to map a
> > userfault page in response to a fault on a non-userfault page. In this
> > RFC, I've taken the simplest approach: force new PTEs to be PAGE_SIZE.
> >
> > --- Page fault notifications ---
> >
> > For page faults generated by vCPUs running in guest mode, if the page
> > the vCPU is trying to access is a userfault-enabled page, we use
> > KVM_EXIT_MEMORY_FAULT with a new flag: KVM_MEMORY_EXIT_FLAG_USERFAULT.
> >
> > For arm64, I believe this is actually all we need, provided we handle
> > steal_time properly.
>
> There's steal time, and also the GIC pages. Steal time can use
> KVM_EXIT_MEMORY_FAULT, but that requires special casing in the ARM
> code. Alternatively, both can use the async mechanism and to avoid
> special handling in the ARM code.

Oh, of course, I forgot about the GIC. Thanks. And yes, if the async
userfault mechanism is acceptable, using that would be better than
adding the special cases.

>
> >
> > For x86, where returning from deep within the instruction emulator (or
> > other non-trivial execution paths) is infeasible, being able to pause
> > execution while userspace fetches the page, just as userfaultfd would
> > do, is necessary. Let's call these "asynchronous userfaults."
> >
> > A new ioctl, KVM_READ_USERFAULT, has been added to read asynchronous
> > userfaults, and an eventfd is used to signal that new faults are
> > available for reading.
> >
> > Today, we busy-wait for a gfn to have userfault disabled. This will
> > change in the future.
> >
> > --- Fault resolution ---
> >
> > Resolving userfaults today is as simple as removing the USERFAULT memor=
y
> > attribute on the faulting gfn. This will change if we do not end up
> > using memory attributes for KVM Userfault. Having a range-based wake-up
> > like userfaultfd (see UFFDIO_WAKE) might also be helpful for
> > performance.
> >
> > Problems with this series
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > - This cannot be named KVM Userfault! Perhaps "KVM missing pages"?
> > - Memory attribute modification doesn't scale well.
> > - We busy-wait for pages to not be userfault-enabled.
>
> Async faults are a slow path so I think a wait queue would suffice.

I think a wait queue seems like a good fit too. (It's what userfaultfd uses=
.)

>
> > - gfn_to_hva and gfn_to_pfn caches are not invalidated.
> > - Page tables are not collapsed when KVM Userfault is disabled.
> > - There is no self-test for asynchronous userfaults.
> > - Asynchronous page faults can be dropped if KVM_READ_USERFAULT fails.
>
> Userspace would probably treat this as fatal anyway right?

Yes, but I still think dropping the gfn isn't great. I'll fix this
when I change from using the hacky list-based thing to something more
sophisticated (like a wait_queue).
