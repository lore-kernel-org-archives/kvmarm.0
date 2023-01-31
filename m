Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB2A922
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 18:02:13 +0000 (UTC)
Received: by mail-vk1-f177.google.com with SMTP id bs10so7794798vkb.3
        for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 10:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hd1THhGtDBlQVqSyHF/LS8U0SI+/x7GvR/Q6jc/5tiM=;
        b=EDaFOyJeJI2PjeUcEVVodAjgZDDPZr82ASgXy6rJ1DqKThN2DFDlNMOv0oJNvG/azf
         FahW7Ksk8RHXVY+cpPhKHEPuY8NhNiIzS+Qkp5WV4mNWk07vUS9Mrh7d0phuy3reG5RL
         2RE+9Le1BDJKradDQzMfaDS3vW38c7DqvEHagIP/iW/pTPBTuUuD8OcZE2MI3n35Do5k
         M4JjJoWfFlb4T+cjvTqRo7li7he+vbEeT8NO/6EaCghi/NPLJ/1syl8rgqDNVBf2GsjP
         hgBZipDR/YhgC3uNAtkyoHD/mUQQi8KIkDe0BqrICwmPwMu7Pdx+2zsXlX+ayeQdaTGW
         6KSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hd1THhGtDBlQVqSyHF/LS8U0SI+/x7GvR/Q6jc/5tiM=;
        b=cfIERtBw8YSHVG35Si6Msb5shZNFDL/MsQpvP6UkcYX1Lxxhcfb5kJasjjYPSdCs7r
         rx4eObL/nqM2fKbLd24jokiIb98XNc+/6N9QPb3rHWoQRccOKGTpPfJx5akaEsCi6L92
         ITQJkGoOm+T/nTEADy6cgNxkbQ4BjOHWfcyNchzV7y5B1W1+yIJtQHIQDn6bXwRNmFE6
         KyUK0VkZgndPDwMeM6ArXKYOef9OBo6ikahKeu0+tnsYvImS2GgNXhTmVh/7ZoyFssSR
         z41ik1YcplzPsObvuSbpSSa9UJaRORZGdr0FCp/1V2wc+GkvQ407qxnq4PTAdhBM92tG
         AT3g==
X-Gm-Message-State: AO0yUKX4WB15oQyVHI5MGhwlTYrO30msAF1fOfDRK+r83gg39c2QXQtC
	vZibZN41zeAtUrxXWUf1nbcqDs29p9NKHU8pdL/Xow==
X-Google-Smtp-Source: AK7set+lpmKLJYoUX7vniZmPxeL6Puj1OAb4ho8iEEB6jPm6972arYfYsuy28s7wxMx4vHW1VS2Tg21tdB1hDhyYlHo=
X-Received: by 2002:a05:6122:49d:b0:3ea:300e:bbbd with SMTP id
 o29-20020a056122049d00b003ea300ebbbdmr1251193vkn.6.1675188131976; Tue, 31 Jan
 2023 10:02:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi> <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org> <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com> <Y9hsV02TpQeoB0oN@google.com> <Y9lTz3ryasgkfhs/@google.com>
In-Reply-To: <Y9lTz3ryasgkfhs/@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 31 Jan 2023 10:01:45 -0800
Message-ID: <CALzav=esLqUWd-1z=X+qzSxQDLS3Lh_cx4MAznp+rC9f-mrY0A@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is enabled
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com, yuzenghui@huawei.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 31, 2023 at 9:46 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Tue, Jan 31, 2023 at 01:18:15AM +0000, Sean Christopherson wrote:
> > On Mon, Jan 30, 2023, Oliver Upton wrote:
> > > I think that Marc's suggestion of having userspace configure this is
> > > sound. After all, userspace _should_ know the granularity of the backing
> > > source it chose for guest memory.
> > >
> > > We could also interpret a cache size of 0 to signal that userspace wants
> > > to disable eager page split for a VM altogether. It is entirely possible that
> > > the user will want a differing QoS between slice-of-hardware and
> > > overcommitted VMs.
> >
> > Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
> > guarantees for all VMs on a system are better met by enabling eager splitting
> > across the board.
> >
> > There are other reasons to use module/kernel params beyond what Marc listed, e.g.
> > to let the user opt out even when something is on by default.  x86's TDP MMU has
> > benefited greatly from downstream users being able to do A/B performance testing
> > this way.  I suspect x86's eager_page_split knob was added largely for this
> > reason, e.g. to easily see how a specific workload is affected by eager splitting.
> > That seems like a reasonable fit on the ARM side as well.
>
> There's a rather important distinction here in that we'd allow userspace
> to select the page split cache size, which should be correctly sized for
> the backing memory source. Considering the break-before-make rules of
> the architecture, the only way eager split is performant on arm64 is by
> replacing a block entry with a fully populated table hierarchy in one
> operation.

I don't see how this can be true if we are able to tolerate splitting
2M pages. Splitting 2M pages inherently means 512 Break-Before-Make
operations per 1GiB region of guest physical memory.

If we had a cache size of 1 and were splitting a 1GiB region, we would
then need to do 512+1 BBM per 1GiB region. If we can tolerate 512 per
1GiB, why not 513?

It seems more like the 513 cache size is more to optimize splitting
1GiB pages. I agree it can turn those 513 int 1, but future versions
of the architecture also elide BBM requirements which is another way
to optimize 1GiB pages.


> AFAICT, you don't have this problem on x86, as the
> architecture generally permits a direct valid->valid transformation
> without an intermediate invalidation. Well, ignoring iTLB multihit :)
>
> So, the largest transformation we need to do right now is on a PUD w/
> PAGE_SIZE=4K, leading to 513 pages as proposed in the series. Exposing
> that configuration option in a module parameter is presumptive that all
> VMs on a host use the exact same memory configuration, which doesn't
> feel right to me.
>
> --
> Thanks,
> Oliver
