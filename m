Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A6E7B
	for <kvmarm@lists.linux.dev>; Mon, 24 Oct 2022 23:50:34 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id 78so9974135pgb.13
        for <kvmarm@lists.linux.dev>; Mon, 24 Oct 2022 16:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=fk19yniwllZCh++1DbRLP7VOvaUwmZGJqqA9xgYFAtqiwj0dOGIon24MAo64uGbefZ
         pw/L13DT9itDgQ0xhw/GUWefSLM0XWoE1/83cVtdo0+KxlbwC9NfMBh45KsanLMz3yyD
         fnizKvk5kkcHrAFLEuArtoSf+S848mgfz86CUJIUrXMmvPmtYb/RdUY054G4cqA3f/6d
         9hBSBc+7JeykCU/zAmG0bi7fiRdtr5vHU2hKJgi5eykvj50qvk1jOQ7IiT+W+RQoCmV+
         bB4IronoetCo22KdOEjWlWXXt3oqBjlzyMy0339DoK6gXSYU8Pno//AHxo1vsP74Uj7p
         eRAQ==
X-Gm-Message-State: ACrzQf0hQL39u+J0NvPOyixXfB0RxZbuxpsJzU4ZBXefBz0elOSiWsXO
	9PjN9MQPZeNRL6tikwIBDtjNmg==
X-Google-Smtp-Source: AMsMyM7E01nYbmRGETdCkGBee2V5w5TAHttKNh0vlWlunX7VmqWPkpK3Xpj8MKbCOhwsVIc/ozq9AA==
X-Received: by 2002:a05:6a00:181b:b0:56b:fcbe:2e7f with SMTP id y27-20020a056a00181b00b0056bfcbe2e7fmr4340798pfa.3.1666655433841;
        Mon, 24 Oct 2022 16:50:33 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o17-20020a17090ac09100b0020d9ac33fbbsm416963pjs.17.2022.10.24.16.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 16:50:33 -0700 (PDT)
Date: Mon, 24 Oct 2022 23:50:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
	bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
	dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
	james.morse@arm.com, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, oliver.upton@linux.dev,
	shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1ckxYst3tc0LCqb@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com>
 <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edv0gnb3.wl-maz@kernel.org>
Message-ID: <20221024235029.3wy41p0MBDw-jMF-4HEwrK8j5O0gL09fz5Ckq3kJDUg@z>

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
