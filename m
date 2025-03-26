Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09E91F192E
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743005449; cv=none; b=uJlyyA4Gu4j3CYZkcbvszH9FZnw2K2HiWV0VPJapCvHAd4XyA30rZmOQ+M+XX5U/Gx7Pnw8D0vCmlzBQbYsMs9JEYPjD0DgMcqOpNuVhZsq53BicHO3jdybDJ8Kegk4mnPc3dtmTjnS+V7pXzpoH5F4b2Tv4TgWcY8kbe9TTIOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743005449; c=relaxed/simple;
	bh=3ZqXQYvwwNCelkfnhTRPxWgCe3xYRNXvPDVEGFP3XZw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H4/cr0fgjJddI1nyNe//Y5cZZO8KZ/6ItV8D9KxLA8ewmnjmzondkmty0X2Ti4xn5SviOqg8ZYf9VKJooWQ/ys4fRWX46YuwkBVFUDldvDRGso22dg77EJwnG8xgqUiOtU8fBvHMX/rggUELCBx+go9Qw2Oeum58LB+L/7KiIuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RXShyM0E; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RXShyM0E"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-300fefb8e05so8955874a91.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 09:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743005447; x=1743610247; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hLrRlp5KJ9KUIi71uk+34vr7bPpoyZem9rwFkZwg0ow=;
        b=RXShyM0EjR+Lgz3w/IrrPVpSf7S1Y6z6lO+82LSd5TThMU1m9WoOC9Hk9ShCJvQMXy
         c46GafdEzira5AzgV3zNeuk4Dhb27xl11HLCvFm7qq7Wf+8d06J6AvmZEw9Rx9CgQxgN
         5CnY7srlrXMPRk6i3fzEjhYkZQ4sEwroioFkKtLkZrX23y7uI1YEkKcy29UBLwbeNkKv
         VlJiFQo2Rm+hMoDyiOduBdpcdmrL0uI1IlezcLrkVaBn40mCuTnTJ/gdb8FHmMhA4C7J
         jPKeOtEIAS67fJaAON0LWdZmP3f8KHPtpFr0UAmazLudfzsf/4DBF/o4bkW4/SLO57WB
         VdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743005447; x=1743610247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hLrRlp5KJ9KUIi71uk+34vr7bPpoyZem9rwFkZwg0ow=;
        b=wgJsODP1WLVv5buOpBjnRu0b5KAw/kfs4ZNT7LeicoD67GFUmJmbtLuv5AxLzS9c6o
         qswpr2u7MFDCSAREX7pAFBEPN2ecSdtSHlnOPDKBfOgmRJ92CoUsceRv1+R8YfgkAllC
         hzaQuyhrHCU8TR2AKi2+Pbwtnwf4L5/Vct6oK2IV10jinrnD7wpDmxcrG37bq3uaseVw
         yyRYSICBVujj/Byd25Gw2PUGMmx/kuFmABNempuAAgYcXlLh4wlqCax24Z6OKq8JUKXk
         JcisC2aqlT0rgc0scneFuRFbZPB/Hm5fGzEBwdcFF71kryFOq+R5ug31OEeqvH8ovt/0
         4c9A==
X-Forwarded-Encrypted: i=1; AJvYcCVF71aeiCnJLLxjPwuMq0WVnLnvlOa5T2j9D0PaP3lhrmhx9i5sGa3q+7hC/5PiWnbw9X2dQz0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDUPOeJ/dVYOKwATcLuI7piDJMEfJ/+VVIPlFtyyqr/91n3NG7
	ogqThi4C3TlfNXYMhCcx5LtM76pjaYZbO+bbZJL7+q/stuco3mZ5Ygcbs8TKLoCiL1CWs9zDwPK
	17w==
X-Google-Smtp-Source: AGHT+IGMVcgjpgCj0fYnAQnPKXCiqk1ze3TosYAsajSIn5jZ7TsL42ec0e2/MVtEl+5C4vOlf2f6anST6us=
X-Received: from pjbqx4.prod.google.com ([2002:a17:90b:3e44:b0:2fa:1803:2f9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f81:b0:2ff:784b:ffe
 with SMTP id 98e67ed59e1d1-303a7d6a9b4mr402639a91.11.1743005446972; Wed, 26
 Mar 2025 09:10:46 -0700 (PDT)
Date: Wed, 26 Mar 2025 09:10:45 -0700
In-Reply-To: <86y0wrlrxt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <Z9nJ42PllG8a7AY7@linux.dev> <20250318230909.GD9311@nvidia.com>
 <Z9pryQwy2iwa2bpJ@linux.dev> <20250319170429.GK9311@nvidia.com>
 <Z9sItt8BIgvbBY8M@arm.com> <20250319192246.GQ9311@nvidia.com>
 <Z9s7r2JocpoM_t-m@arm.com> <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Z-QU7qJOf8sEA5R8@google.com> <86y0wrlrxt.wl-maz@kernel.org>
Message-ID: <Z-QnBcE1TKPChQay@google.com>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ankit Agrawal <ankita@nvidia.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>, 
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>, 
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, 
	Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, 
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, 
	Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, 
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke <udhoke@nvidia.com>, 
	Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, 
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, 
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com" <coltonlewis@google.com>, 
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ddutile@redhat.com" <ddutile@redhat.com>, "tabba@google.com" <tabba@google.com>, 
	"qperret@google.com" <qperret@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 26, 2025, Marc Zyngier wrote:
> On Wed, 26 Mar 2025 14:53:34 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Wed, Mar 26, 2025, Ankit Agrawal wrote:
> > > > On Wed, Mar 19, 2025 at 04:22:46PM -0300, Jason Gunthorpe wrote:
> > > > > On Wed, Mar 19, 2025 at 06:11:02PM +0000, Catalin Marinas wrote:
> > > > > > On Wed, Mar 19, 2025 at 02:04:29PM -0300, Jason Gunthorpe wrote:
> > > > > > > On Wed, Mar 19, 2025 at 12:01:29AM -0700, Oliver Upton wrote:
> > > > > > > > You have a very good point that KVM is broken for cacheable PFNMAP'd
> > > > > > > > crap since we demote to something non-cacheable, and maybe that
> > > > > > > > deserves fixing first. Hopefully nobody notices that we've taken away
> > > > > > > > the toys...
> > > > > > >
> > > > > > > Fixing it is either faulting all access attempts or mapping it
> > > > > > > cachable to the S2 (as this series is trying to do)..
> > > > > >
> > > > > > As I replied earlier, it might be worth doing both - fault on !FWB
> > > > > > hardware (or rather reject the memslot creation), cacheable S2
> > > > > > otherwise.
> > > > >
> > > > > I have no objection, Ankit are you able to make a failure patch?
> > > >
> > > > I'd wait until the KVM maintainers have their say.
> > > > 
> > > 
> > > Maz, Oliver any thoughts on this? Can we conclude to create this failure
> > > patch in memslot creation?
> > 
> > That's not sufficient.  As pointed out multiple times in this thread, any checks
> > done at memslot creation are best effort "courtesies" provided to userspace to
> > avoid terminating running VMs when the memory is faulted in.
> > 
> > I.e. checking at memslot creation is optional, checking at fault-in/mapping is
> > not.
> > 
> > With that in place, I don't see any need for a memslot flag.  IIUC, without FWB,
> > cacheable pfn-mapped memory is broken and needs to be disallowed.  But with FWB,
> > KVM can simply honor the cacheability based on the VMA.  Neither of those requires
> 
> Remind me how this work with stuff such as guestmemfd, which, by
> definition, doesn't have a userspace mapping?

Definitely not through a memslot flag.  The cacheability would be a property of
the guest_memfd inode, similar to how it's a property of the underlying device
in this case.

I don't entirely see what guest_memfd has to do with this.  One of the big
advantages of guest_memfd is that KVM has complete control over the lifecycle of
the memory.  IIUC, the issue with !FWB hosts is that KVM can't guarantee there
are valid host mappings when memory is unmapped from the guest, and so can't do
the necessary maintenance.  I agree with Jason's earlier statement that that's a
solvable kernel flaw.

For guest_memfd, KVM already does maintenance operations when memory is reclaimed,
for both SNP and TDX.  I don't think ARM's cacheability stuff would require any
new functionality in guest_memfd.

> > a memslot flag.  A KVM capability to enumerate FWB support would be nice though,
> > e.g. so userspace can assert and bail early without ever hitting an
> > ioctl error.
> 
> It's not "nice". It's mandatory. And FWB is definitely *not* something
> we want to expose as such.

I agree a capability is mandatory if we're adding a memslot flag, but I don't
think it's mandatory if this is all handled through kernel plumbing.

> > If we want to support existing setups that happen to work by dumb luck or careful
> > configuration, then that should probably be an admin decision to support the
> > "unsafe" behavior, i.e. an off-by-default KVM module param, not a memslot flag.
> 
> No. That's not how we handle an ABI issue. VM migration, with and
> without FWB, can happen in both direction, and must have clear
> semantics. So NAK to a kernel parameter.
> 
> If I have a VM with a device mapped as *device* on FWB host, I must be
> able to migrate it to non-FWB host, and back. A device mapped as
> *cacheable* can only be migrated between FWB-capable hosts.

But I thought the whole problem is that mapping this fancy memory as device is
unsafe on non-FWB hosts?  If it's safe, then why does KVM needs to reject anything
in the first place?

> Importantly, it is *userspace* that is in charge of deciding how the
> device is mapped at S2. And the memslot flag is the correct
> abstraction for that.
 
I strongly disagree.  Whatever owns the underlying physical memory is in charge,
not userspace.  For memory that's backed by a VMA, userspace can influence the
behavior through mmap(), mprotect(), etc., but ultimately KVM needs to pull state
from mm/, via the VMA.  Or in the guest_memfd case, from guest_memfd.

I have no objection to adding KVM uAPI to let userspace add _restrictions_, e.g.
to disallow mapping memory as writable even if the VMA is writable.  But IMO,
adding a memslot flag to control cacheability isn't purely substractive.
