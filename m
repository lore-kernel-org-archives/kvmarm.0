Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F073A922
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 18:19:38 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id j22so2716588qka.0
        for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 10:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hK0xL11vO1cW1nuDhXZMtvmMjIJPZj7ljY3iY/xX6Vo=;
        b=hFHRU4aUCHe7FZOkeFDWhbz4E74GM2js7i6pMBN/oU6YLbo7iYmH13ZcGo5RAJXAuC
         NrtUNZ5Q1IUUbYpR4TAIP0rOsBQjjVdskDLir0jwluBaZ5j4uP8tmkaWrx4KjCnIDj9I
         dB5bFWlnQdnUl0Y5LVJt5jMTjHNPmNUCTL44yKcDmbewgDgh6vOzWwRSDUmYoRBNn7zf
         tltQxw54cL8svhzjZ5dSZ531DvCA9g5ot3Bg/N2iz48n8r/rKvtfmCjvA5f1iaaKLCP5
         jPNzVO0XA4il8oqT9KIxstFWUCEo19YSFLSV+8gTdZgDpEa5TdQIruPc4CrlADkNhprM
         6bHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hK0xL11vO1cW1nuDhXZMtvmMjIJPZj7ljY3iY/xX6Vo=;
        b=3v9YpMOVKH/YNcR7L8HD9XG6ZvEDX3oHsDOpo3IHcqrtxkNUwLi1RtbH4X7w+OTsQN
         zk7SznwYLPged74ygkzlnRXzZAtAxHxZHno0JiyKYUMrK9MR7iDpC5l0VQLKXuLy4ssD
         GJk8BKVanPekBNXsEasqC2Vi7MqfopQrloQEsbgqoeAeXxh0OVnXFxPv4N7A180KO4pQ
         UiQW6/4lUewcxKQZmnUaMXcVt1fnD9gps6IO48n+/rhNZIRfBl6xUOPgSjP0evuACnAr
         F8kq9pt4dLsBr7bjt+Kn0VHwj5w37borxl7hXvxQysdIr93Lb7fXzZPgh0H4dIn27WPJ
         wg7w==
X-Gm-Message-State: AFqh2koDVu1SHXV0dBd+G5xWfrVFHl7XdEPQJOKmuIXnFAVSdZLxdn5s
	5qOLW7K3cuckcHCtFAErb1gZ/ytPjf242jcykOAkxw==
X-Google-Smtp-Source: AMrXdXvFPI0jCmSwoX1pEMKknliZ3GDVJ/tsK8hnkzz2iLSekN1hlJptmjeWLuvwCJONXKMT0HsuUjWH1tRUCPVuJiQ=
X-Received: by 2002:a05:620a:1e1:b0:706:8588:513c with SMTP id
 x1-20020a05620a01e100b007068588513cmr3034813qkn.390.1675189177184; Tue, 31
 Jan 2023 10:19:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi> <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org> <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com> <Y9hsV02TpQeoB0oN@google.com>
 <Y9lTz3ryasgkfhs/@google.com> <CALzav=esLqUWd-1z=X+qzSxQDLS3Lh_cx4MAznp+rC9f-mrY0A@mail.gmail.com>
In-Reply-To: <CALzav=esLqUWd-1z=X+qzSxQDLS3Lh_cx4MAznp+rC9f-mrY0A@mail.gmail.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Tue, 31 Jan 2023 10:19:25 -0800
Message-ID: <CAOHnOrwVgpznefk_vSeLAfj7zMGnofJSCgb5G8CU0S1xQYAJrg@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is enabled
To: David Matlack <dmatlack@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com, yuzenghui@huawei.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 31, 2023 at 10:02 AM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Jan 31, 2023 at 9:46 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Tue, Jan 31, 2023 at 01:18:15AM +0000, Sean Christopherson wrote:
> > > On Mon, Jan 30, 2023, Oliver Upton wrote:
> > > > I think that Marc's suggestion of having userspace configure this is
> > > > sound. After all, userspace _should_ know the granularity of the backing
> > > > source it chose for guest memory.
> > > >
> > > > We could also interpret a cache size of 0 to signal that userspace wants
> > > > to disable eager page split for a VM altogether. It is entirely possible that
> > > > the user will want a differing QoS between slice-of-hardware and
> > > > overcommitted VMs.
> > >
> > > Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
> > > guarantees for all VMs on a system are better met by enabling eager splitting
> > > across the board.
> > >
> > > There are other reasons to use module/kernel params beyond what Marc listed, e.g.
> > > to let the user opt out even when something is on by default.  x86's TDP MMU has
> > > benefited greatly from downstream users being able to do A/B performance testing
> > > this way.  I suspect x86's eager_page_split knob was added largely for this
> > > reason, e.g. to easily see how a specific workload is affected by eager splitting.
> > > That seems like a reasonable fit on the ARM side as well.
> >
> > There's a rather important distinction here in that we'd allow userspace
> > to select the page split cache size, which should be correctly sized for
> > the backing memory source. Considering the break-before-make rules of
> > the architecture, the only way eager split is performant on arm64 is by
> > replacing a block entry with a fully populated table hierarchy in one
> > operation.
>
> I don't see how this can be true if we are able to tolerate splitting
> 2M pages. Splitting 2M pages inherently means 512 Break-Before-Make
> operations per 1GiB region of guest physical memory.
>
> If we had a cache size of 1 and were splitting a 1GiB region, we would
> then need to do 512+1 BBM per 1GiB region. If we can tolerate 512 per
> 1GiB, why not 513?
>
> It seems more like the 513 cache size is more to optimize splitting
> 1GiB pages.

That's correct. Although there's also a slight benefit for the 2M huge-pages
case as the 512 huge-pages can be split without having to walk down
the tree from the root every time.

> I agree it can turn those 513 int 1, but future versions
> of the architecture also elide BBM requirements which is another way
> to optimize 1GiB pages.

There's also the CPU cost needed to walk down the tree from the root
513 times (same as above).

>
>
> > AFAICT, you don't have this problem on x86, as the
> > architecture generally permits a direct valid->valid transformation
> > without an intermediate invalidation. Well, ignoring iTLB multihit :)
> >
> > So, the largest transformation we need to do right now is on a PUD w/
> > PAGE_SIZE=4K, leading to 513 pages as proposed in the series. Exposing
> > that configuration option in a module parameter is presumptive that all
> > VMs on a host use the exact same memory configuration, which doesn't
> > feel right to me.
> >
> > --
> > Thanks,
> > Oliver
