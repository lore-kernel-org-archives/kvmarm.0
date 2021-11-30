Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A7DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 10:20:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8D7D4B15E;
	Tue, 30 Nov 2021 05:20:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GbIMe1+JKR97; Tue, 30 Nov 2021 05:20:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40EF34B1E7;
	Tue, 30 Nov 2021 05:20:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4AD4B1CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 05:20:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rlh1+7PYTlLL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Nov 2021 05:20:04 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 650814B1B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 05:20:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638267604;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=OzpFcvBbG6u7p5sms8xWPW9jQykzma+4R9XPG4RPkT8=;
 b=goXeFwxDjwwa+tB2OKOF43f4HQjezQUJh+wnequZy3GIpyV7UPRqj/ZMLVbFW1mKAQWDzq
 emUTARtd0TvyFA2A5Qxk9p20j6LJ4kziAPLUTs8ocKAvzhrH3NP1auNv5hHavYIfBrBrqe
 H22EjU7khpCwuWPYoeUSD7q1wwcR/CI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-JpV6qq8HMfiKK46JKIlliA-1; Tue, 30 Nov 2021 05:20:02 -0500
X-MC-Unique: JpV6qq8HMfiKK46JKIlliA-1
Received: by mail-ed1-f71.google.com with SMTP id
 30-20020a508e5e000000b003f02e458b17so9758929edx.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 02:20:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OzpFcvBbG6u7p5sms8xWPW9jQykzma+4R9XPG4RPkT8=;
 b=JbSwRd8K+YlJt9hD0nDln5FOQ2FOp+YEXgwxt1HIBvzjB39pBDYfOPZgb+xVE501yN
 eJnUDM/J+4zrZ70o6SFXftitmejWBzFvyUF0owgGdQqih3w1Sged63RqEbp33M+ZWqbW
 axSaKIUXR2OXqk7YavYPXy5D21CYnMPbw1fs6ITN00LiQWVWeb2K6K6oTH2K1PNJNt3D
 x+peS/ttEusUvP0rR2OAdWe3mUEQNILjNAaJyCV81ppW2/TjdtAQV1FtP8wgovdxAbxF
 yIWtTMujGCd1RuhkMyiVonTIDlJZIL8AMDcO9CDacmfwzuAzOv9U7pt+I6zlU6+VLfQj
 f37A==
X-Gm-Message-State: AOAM5305CRaYaaafpM1BVtiRr+h9Gg7kiUDIzI3evU0x6QCS3pQq3Kdb
 mT/tQi9YtJ1tF+lpkPmdQjma1xHs0XFJCQndIQboZ3qnASRXXcFCxtY4PfbkZHwT6sBfXyfNvvT
 gg7I5SAgBuoY0kWdkwXOn9EiP
X-Received: by 2002:a05:6402:41a:: with SMTP id
 q26mr83741460edv.387.1638267601471; 
 Tue, 30 Nov 2021 02:20:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO8sb5ZfWXTnqbvi0ESAmSaw67WDhY9GecOv8WBkx4Pl8wWeORH68lUXXPC0xdOlbVtjRQhg==
X-Received: by 2002:a05:6402:41a:: with SMTP id
 q26mr83741439edv.387.1638267601229; 
 Tue, 30 Nov 2021 02:20:01 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id sh33sm9409065ejc.56.2021.11.30.02.20.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 Nov 2021 02:20:00 -0800 (PST)
Date: Tue, 30 Nov 2021 11:19:58 +0100
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH v2 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
Message-ID: <20211130101958.fcdqthphyhxzvzla@gator.home>
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-5-rananta@google.com>
 <87wnl0cdfn.wl-maz@kernel.org>
 <CAJHc60ydffBkqqb6xyObiK-66psaPODsOo0DpLFv7thx=zHjZw@mail.gmail.com>
 <20211127172720.zte6wfdguoyi3gd6@gator.home>
 <CAJHc60x=Egb=vRu1JHNK6f1ep+t+gDSKxJyfH88-w=v9pwsRsQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHc60x=Egb=vRu1JHNK6f1ep+t+gDSKxJyfH88-w=v9pwsRsQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Mon, Nov 29, 2021 at 04:56:19PM -0800, Raghavendra Rao Ananta wrote:
> On Sat, Nov 27, 2021 at 9:27 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Tue, Nov 23, 2021 at 10:34:23AM -0800, Raghavendra Rao Ananta wrote:
> > > On Mon, Nov 22, 2021 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > I keep being baffled by this. Why should we track the VMM accesses or
> > > > the VMM writeback? This logic doesn't seem to bring anything useful as
> > > > far as I can tell. All we need to ensure is that what is written to
> > > > the pseudo-register is an acceptable subset of the previous value, and
> > > > I cannot see why this can't be done at write-time.
> > > >
> > > > If you want to hide this behind a capability, fine (although my guts
> > > > feeling is that we don't need that either). But I really want to be
> > > > convinced about all this tracking.
> > > >
> > > The tracking of each owner register is necessary here to safe-guard
> > > the possibility that the user-space may not be aware of a newly
> > > introduced register, and hence, hasn't accessed it. If it had at least
> > > read the register, but not write-back, we assume that the user-space
> > > is happy with the configuration. But the fact that the register has
> > > not even been read would state that user-space is unaware of the
> > > existence of this new register. In such a case, if we don't sanitize
> > > (clear all the bits) this register, the features will be exposed
> > > unconditionally to the guest.
> > >
> > > The capability is introduced here to make sure that this new
> > > infrastructure is backward compatible with old VMMs. If the VMMs don't
> > > enable this capability, they are probably unaware of this, and this
> > > will work as it always has- expose new services to the guest
> > > unconditionally as and when they are introduced.
> >
> > Hi Raghavendra,
> >
> > I don't think we need a CAP that has to be enabled or to make any
> > assumptions or policy decisions in the kernel. I think we just need to
> > provide a bit more information to the VMM when it checks if KVM has the
> > CAP. If KVM would tell the VMM how may pseudo registers there are, which
> > can be done with the return value of the CAP, then the VMM code could be
> > something like this
> >
> >   r = check_cap(KVM_CAP_ARM_HVC_FW_REG_BMAP);
> >   if (r) {
> >     num_regs = r;
> >
> >     for (idx = 0; idx < num_regs; ++idx) {
> >       reg = hvc_fw_reg(idx);
> >
> >       if (idx > vmm_last_known_idx) {
> >         ...
> >       } else {
> >         ...
> >       }
> >     }
> >   }
> >
> > With this, the VMM is free to decide if it wants to clear all registers
> > greater than the last index it was aware of or if it wants to let those
> > registers just get exposed to the guest without knowing what's getting
> > exposed. Along with documenting that by default everything gets exposed
> > by KVM, which is the backwards compatible thing to do, then the VMM has
> > been warned and given everything it needs to manage its guests.
> >
> Hi Andrew,
> 
> Thanks for your comments and suggestions!
> 
> I like the idea of sharing info via a read of the CAP, and not having
> to explicitly sanitize/clear the registers before the guest begins to
> run.
> However the handshake is done over an API doc, which is a little
> concerning. The user-space must remember and explicitly clear any new
> register that it doesn't want to expose to the guest, while the
> current approach does this automatically.
> Any bug in VMM's implementation could be risky and unintentionally
> expose features to the guest. What do you think?

The VMM can mess things up in many ways. While KVM should protect itself
from the VMM, it shouldn't try to protect the VMM from the VMM itself. In
this case, the risk here isn't that we allow the VMM to do something that
can harm KVM, or even the guest. The risk is only that the VMM fails to do
what it wanted to do (assuming it didn't want to expose unknown features
to the guest). I.e. the risk here is only that the VMM has a bug, and it's
an easily detectable bug. I say let the VMM developers manage it.

> 
> > Another thing that might be nice is giving userspace control of how many
> > pseudo registers show up in get-reg-list. In order to migrate from a host
> > with a more recent KVM to a host with an older KVM[*] we should only
> > expose the number of pseudo registers that the older host is aware of.
> > The VMM would zero these registers out anyway, in order to be compatible
> > for migration, but that's not enough when they also show up in the list
> > (at least not with QEMU that aborts migration when the destination
> > expects less registers than what get-reg-list provides)
> >
> > [*] This isn't a great idea, but it'd be nice if we can make it work,
> > because users may want to rollback upgrades or, after migrating to a
> > host with a newer kernel, they may want to migrate back to where they
> > started.
> >
> Good point. But IIUC, if the user-space is able to communicate the
> info that it's expecting a certain get-reg-list, do you think it can
> handle it at its end too, rather than relying on the kernel to send a
> list back?

Yes, I think we can probably manage this in the VMM, and maybe/probably
that's the better place to manage it.

> 
> My assumption was that VMM would statically maintain a known set of
> registers that it wants to work with and are to be modified by hand,
> rather than relying on get-reg-list. This could be the least common
> set of registers that are present in all the host kernels (higher or
> lower versions) of the migration fleet. This config doesn't change
> even with get-reg-list declaring a new register as the features
> exposed by it could still be untested. Although, migrating to a host
> with a missing register shouldn't be possible in this setting, but if
> it encounters the scenario, it should be able to avoid migration to
> the host (similar to QEMU).
> 
> Please correct me if you think it's a false assumption to proceed with.

Your assumptions align with mine. It seems as we move towards CPU models,
get-reg-list's role will likely only be to confirm a host supports the
minimum required. We should probably implement/change the VMM to allow
migrating from a host with more registers to one with less as long as
the one with less includes all the required registers. Of course we
also need to ensure that any registers we don't want to require are
not exposed to the guest, but I guess that's precisely what we're trying
to do with this series for at least some pseudo registers.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
