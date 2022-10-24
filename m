Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A0CC67871
	for <kvmarm@archiver.kernel.org>; Mon, 24 Oct 2022 23:50:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EA714B657;
	Mon, 24 Oct 2022 19:50:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ginpebvizyf9; Mon, 24 Oct 2022 19:50:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A5F74B199;
	Mon, 24 Oct 2022 19:50:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D3F4B15C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 19:50:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dk3VR5v6erEa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Oct 2022 19:50:35 -0400 (EDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 189A349F51
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 19:50:35 -0400 (EDT)
Received: by mail-pg1-f172.google.com with SMTP id s196so10021230pgs.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 16:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=j37jHAHaVC2mRgWYzt1F72opTtFOiEc6alqavB7V4Vg=;
 b=nas79F/0vwyRdTzYNbHp4Sqe/uEVwoZfgVThkOiGKkA+URrptTxnMTINJHwq9KC8Ld
 PmW3r0fOUUwFTIA6plJEPD1KQhBM8cgUCZCcApqCr8IMT0r5qdL6UFYaLjreGKICuIQg
 D4vndUu2HGMfrM4RL6MnLsnFgZnqRVsB9v2+tqLz00M5IyiiGkEAD09xJAajKlFLqziy
 yxl+lKqN5IH/MU7a2z3rneCt7GBjRQ0Lxpu8V5/fxqjgGBWKJNL5X/8ef2j8dIXd6MT9
 63SDnEJRDRyJCcuStrluRcuFOC/6x1RGoOCtenydHegxgtE4Wrg4Kjz8O5zPZb2GZdZv
 ID8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=j37jHAHaVC2mRgWYzt1F72opTtFOiEc6alqavB7V4Vg=;
 b=c7WkMKmMFUIpNkRK3q6S0F5Et3UkeV/x6ACwtGGSDKJ5Gij7h0rBYgFpQndCyyV2r9
 yQ6NV4+7x+I1qe5+16O2sjuAs3ze/vE/ehgLGMgVWwDMzFFmScJL9khelD4AwADus3II
 ekX5NsNjbKAJiums5tLbCGFcKan56/F6yxic3+/JYgRf+5/n01pA4hPxkN8Uv62V6tKk
 O+J95MsCzCSxfYInfhjxf4wClPy9hVzIrMvulBd/6ELp05/m6RPqiYqtZWHJIIo4yXGA
 jY3tnu9W3lCnPaC2aXIVwup8OtbVK7BpBzO5DoVUhiLxTqpVFxcnogjqcFMbO9rnIamy
 WxNg==
X-Gm-Message-State: ACrzQf29nU7P8khdEiCp1erh/aYpmLVD4UPIFw31IGb3bWwtJ0mvJIk0
 rKnD52DDHtB/mNj5NBjQicoZ6w==
X-Google-Smtp-Source: AMsMyM7E01nYbmRGETdCkGBee2V5w5TAHttKNh0vlWlunX7VmqWPkpK3Xpj8MKbCOhwsVIc/ozq9AA==
X-Received: by 2002:a05:6a00:181b:b0:56b:fcbe:2e7f with SMTP id
 y27-20020a056a00181b00b0056bfcbe2e7fmr4340798pfa.3.1666655433841; 
 Mon, 24 Oct 2022 16:50:33 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 o17-20020a17090ac09100b0020d9ac33fbbsm416963pjs.17.2022.10.24.16.50.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 24 Oct 2022 16:50:33 -0700 (PDT)
Date: Mon, 24 Oct 2022 23:50:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1ckxYst3tc0LCqb@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com> <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87edv0gnb3.wl-maz@kernel.org>
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 bgardon@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Sat, Oct 22, 2022, Marc Zyngier wrote:
> On Fri, 21 Oct 2022 17:05:26 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Fri, Oct 21, 2022, Marc Zyngier wrote:
> > > Because dirtying memory outside of a vcpu context makes it
> > > incredibly awkward to handle a "ring full" condition?
> > 
> > Kicking all vCPUs with the soft-full request isn't _that_ awkward.
> > It's certainly sub-optimal, but if inserting into the per-VM ring is
> > relatively rare, then in practice it's unlikely to impact guest
> > performance.
> 
> But there is *nothing* to kick here. The kernel is dirtying pages,
> devices are dirtying pages (DMA), and there is no context associated
> with that. Which is why a finite ring is the wrong abstraction.

I don't follow.  If there's a VM, KVM can always kick all vCPUs.  Again, might
be far from optimal, but it's an option.  If there's literally no VM, then KVM
isn't involved at all and there's no "ring vs. bitmap" decision.

> > Would it be possible to require a dirty bitmap when an ITS is
> > created?  That would allow treating the above condition as a KVM
> > bug.
> 
> No. This should be optional. Everything about migration should be
> absolutely optional (I run plenty of concurrent VMs on sub-2GB
> systems). You want to migrate a VM that has an ITS or will collect
> dirty bits originating from a SMMU with HTTU, you enable the dirty
> bitmap. You want to have *vcpu* based dirty rings, you enable them.
> 
> In short, there shouldn't be any reason for the two are either
> mandatory or conflated. Both should be optional, independent, because
> they cover completely disjoined use cases. *userspace* should be in
> charge of deciding this.

I agree about userspace being in control, what I want to avoid is letting userspace
put KVM into a bad state without any indication from KVM that the setup is wrong
until something actually dirties a page.

Specifically, if mark_page_dirty_in_slot() is invoked without a running vCPU, on
a memslot with dirty tracking enabled but without a dirty bitmap, then the migration
is doomed.  Dropping the dirty page isn't a sane response as that'd all but
guaranatee memory corruption in the guest.  At best, KVM could kick all vCPUs out
to userspace with a new exit reason, but that's not a very good experience for
userspace as either the VM is unexpectedly unmigratable or the VM ends up being
killed (or I suppose userspace could treat the exit as a per-VM dirty ring of
size '1').

That's why I asked if it's possible for KVM to require a dirty_bitmap when KVM
might end up collecting dirty information without a vCPU.  KVM is still
technically prescribing a solution to userspace, but only because there's only
one solution.

> > > > The acquire-release thing is irrelevant for x86, and no other
> > > > architecture supports the dirty ring until this series, i.e. there's
> > > > no need for KVM to detect that userspace has been updated to gain
> > > > acquire-release semantics, because the fact that userspace is
> > > > enabling the dirty ring on arm64 means userspace has been updated.
> > > 
> > > Do we really need to make the API more awkward? There is an
> > > established pattern of "enable what is advertised". Some level of
> > > uniformity wouldn't hurt, really.
> > 
> > I agree that uniformity would be nice, but for capabilities I don't
> > think that's ever going to happen.  I'm pretty sure supporting
> > enabling is actually in the minority.  E.g. of the 20 capabilities
> > handled in kvm_vm_ioctl_check_extension_generic(), I believe only 3
> > support enabling (KVM_CAP_HALT_POLL, KVM_CAP_DIRTY_LOG_RING, and
> > KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2).
> 
> I understood that you were advocating that a check for KVM_CAP_FOO
> could result in enabling KVM_CAP_BAR. That I definitely object to.

I was hoping KVM could make the ACQ_REL capability an extension of DIRTY_LOG_RING,
i.e. userspace would DIRTY_LOG_RING _and_ DIRTY_LOG_RING_ACQ_REL for ARM and other
architectures, e.g.

  int enable_dirty_ring(void)
  {
	if (!kvm_check(KVM_CAP_DIRTY_LOG_RING))
		return -EINVAL;

	if (!tso && !kvm_check(KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
		return -EINVAL;

	return kvm_enable(KVM_CAP_DIRTY_LOG_RING);
  }

But I failed to consider that userspace might try to enable DIRTY_LOG_RING on
all architectures, i.e. wouldn't arbitrarily restrict DIRTY_LOG_RING to x86.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
