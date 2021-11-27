Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CD0C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 27 Nov 2021 17:27:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B96614B252;
	Sat, 27 Nov 2021 12:27:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AJmZsLGiH3SP; Sat, 27 Nov 2021 12:27:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BD5C4B259;
	Sat, 27 Nov 2021 12:27:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 030054B252
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Nov 2021 12:27:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Hlq0rm4c4J4 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 27 Nov 2021 12:27:26 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13ECB4B21C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Nov 2021 12:27:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638034045;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zQkcR9i5clHeNsrtOztHmizggbBo17IKKNg3wYL/MF8=;
 b=huLJyfuhZeIF64faoUM8cwqvHbhXJh6/vNz7gFxfkzoNK/XzjkM/0Tbm/NC31xlf/NVixg
 wlmzfrstVTmNBqlT7V/R7u08Up2DhKIg6ht9gwCFKUcNKSP+q5QzTQRUQKqvdt1U9W689G
 rzwPfSGbdBTeF5yP4TUiqB/i9oNixao=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-MXvRPL9fNiOiRjMbPvKjoA-1; Sat, 27 Nov 2021 12:27:24 -0500
X-MC-Unique: MXvRPL9fNiOiRjMbPvKjoA-1
Received: by mail-ed1-f71.google.com with SMTP id
 p4-20020aa7d304000000b003e7ef120a37so10251178edq.16
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Nov 2021 09:27:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zQkcR9i5clHeNsrtOztHmizggbBo17IKKNg3wYL/MF8=;
 b=YSXVo3IGKFj4ZHW7RGJIUgv6IFaGTVnqUfih1do2sLKq5iiwLNiIgCuQR+IJ5Aj7H5
 ZK61MoteXbnpCZJI4AyjdKInw1nyz3+xL4mIbpDMEPHZEdFVxvZ4WshnqsqnkDDu1Vpk
 Qg+5JAHHFGjbXuuaLu+69HiQzrA6G7jlll/DmYTp5zUnXVbxYzCkyXRpX7Wssl8yqEU6
 RAgRTK2wZkZokN972zBitjiHO1OT7vPzBkh7lpAPsEB/npMD24BI0rn8wYe9nMM7PZwC
 iFGlag7hR6VnYNblcLimzc8Gcm4CAgR9iHwblimrntwBOcU5TZJi6cHkjo6ZsohU9F+y
 Lajw==
X-Gm-Message-State: AOAM530D23g9EXECPRuACZEQw5fWfm28th1HQABYdccullDLScmQt5Zb
 BJmC10R3MqxXVs9pslMhODeokAr7/34ogWQ/RJc7J52pEn0yLMYPq4SAGe2v0mMQlKQtiRx7xZU
 3mC6WP4ohZHmKbd+xHJ5z3lYz
X-Received: by 2002:a05:6402:6d2:: with SMTP id
 n18mr57419266edy.210.1638034043073; 
 Sat, 27 Nov 2021 09:27:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytLtoKh7WUSMD7CfwDREP8JjUQlvCtlwQbJa6dQEbUdPHTgSMZDAvdxnXvttVwBzigk1UUmA==
X-Received: by 2002:a05:6402:6d2:: with SMTP id
 n18mr57419219edy.210.1638034042845; 
 Sat, 27 Nov 2021 09:27:22 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id jg36sm5154065ejc.44.2021.11.27.09.27.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 27 Nov 2021 09:27:22 -0800 (PST)
Date: Sat, 27 Nov 2021 18:27:20 +0100
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH v2 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
Message-ID: <20211127172720.zte6wfdguoyi3gd6@gator.home>
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-5-rananta@google.com>
 <87wnl0cdfn.wl-maz@kernel.org>
 <CAJHc60ydffBkqqb6xyObiK-66psaPODsOo0DpLFv7thx=zHjZw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHc60ydffBkqqb6xyObiK-66psaPODsOo0DpLFv7thx=zHjZw@mail.gmail.com>
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

On Tue, Nov 23, 2021 at 10:34:23AM -0800, Raghavendra Rao Ananta wrote:
> On Mon, Nov 22, 2021 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
> > I keep being baffled by this. Why should we track the VMM accesses or
> > the VMM writeback? This logic doesn't seem to bring anything useful as
> > far as I can tell. All we need to ensure is that what is written to
> > the pseudo-register is an acceptable subset of the previous value, and
> > I cannot see why this can't be done at write-time.
> >
> > If you want to hide this behind a capability, fine (although my guts
> > feeling is that we don't need that either). But I really want to be
> > convinced about all this tracking.
> >
> The tracking of each owner register is necessary here to safe-guard
> the possibility that the user-space may not be aware of a newly
> introduced register, and hence, hasn't accessed it. If it had at least
> read the register, but not write-back, we assume that the user-space
> is happy with the configuration. But the fact that the register has
> not even been read would state that user-space is unaware of the
> existence of this new register. In such a case, if we don't sanitize
> (clear all the bits) this register, the features will be exposed
> unconditionally to the guest.
> 
> The capability is introduced here to make sure that this new
> infrastructure is backward compatible with old VMMs. If the VMMs don't
> enable this capability, they are probably unaware of this, and this
> will work as it always has- expose new services to the guest
> unconditionally as and when they are introduced.

Hi Raghavendra,

I don't think we need a CAP that has to be enabled or to make any
assumptions or policy decisions in the kernel. I think we just need to
provide a bit more information to the VMM when it checks if KVM has the
CAP. If KVM would tell the VMM how may pseudo registers there are, which
can be done with the return value of the CAP, then the VMM code could be
something like this

  r = check_cap(KVM_CAP_ARM_HVC_FW_REG_BMAP);
  if (r) {
    num_regs = r;

    for (idx = 0; idx < num_regs; ++idx) {
      reg = hvc_fw_reg(idx);

      if (idx > vmm_last_known_idx) {
        ...
      } else {
        ...
      }
    }
  }

With this, the VMM is free to decide if it wants to clear all registers
greater than the last index it was aware of or if it wants to let those
registers just get exposed to the guest without knowing what's getting
exposed. Along with documenting that by default everything gets exposed
by KVM, which is the backwards compatible thing to do, then the VMM has
been warned and given everything it needs to manage its guests.

Another thing that might be nice is giving userspace control of how many
pseudo registers show up in get-reg-list. In order to migrate from a host
with a more recent KVM to a host with an older KVM[*] we should only
expose the number of pseudo registers that the older host is aware of.
The VMM would zero these registers out anyway, in order to be compatible
for migration, but that's not enough when they also show up in the list
(at least not with QEMU that aborts migration when the destination
expects less registers than what get-reg-list provides)

[*] This isn't a great idea, but it'd be nice if we can make it work,
because users may want to rollback upgrades or, after migrating to a
host with a newer kernel, they may want to migrate back to where they
started.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
