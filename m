Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9320821421E
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748530614; cv=none; b=XHNiodWlaBzjeeo2aPRNeEmJyD2NLteZb1dd3ey5ujggWqaumLPZsiZoQg8euRcAiWehUOTbzdlKLc6SNlz25DW/ntjmXxzZNa5NTeLWwBogGviyIxk19PQNYL4UFgxHfVVC/yS9qw7Pdyv9JUIsUA7E5x/qyWzIQN42njR973E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748530614; c=relaxed/simple;
	bh=B1zsO3xLB87dBpNzAoGuj+8RJlTANU2xKvOZOU1twOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sNqyf3HLg/WCziaFt38YWruUcmvBGxa/xvKqDBpktYLiCW76SgoraLjoTqBxjrjz8rZnv+gvjrQdt7SSA1M+yJxvOSEnbMB0hbJkK0iUdy01G+u5L73ANvuRLUJJNPGnVkHYVE76n3NUWPlueMy2tPUw2vPpE/Pf8NoTeswpYR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kosMx1GU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kosMx1GU"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31226d9d604so418479a91.1
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 07:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748530612; x=1749135412; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wtc8z1lt0l7J7qwleBMoPVIkOE4MKmf5AJAUWp638/g=;
        b=kosMx1GUi4TQlvDYJQsiGsudPKcD0kVW0C/tXDT/T9EL762Wl9SyqZsCIiggQZCDJo
         AkwcC6ForWjoFZgpdhU0kqBP2vI1pMIM0+aB6GufkBkOkP9qPnQjVoQ3d3O2BL+G/YZ4
         ZeaprGSMDZwjyx8zcOr8S7gihygNRc7GBfgNCnUNonjXfZXMA7I8TfQylB5bvBM8WQOE
         ZIDDK5drtAxgEd5q8OmwpmHYPMYcWYCfhNVW/oWtoe50D5I8DPqkrBRixMRpfXGPxl5O
         As1FrmN/o/0owcmBIM6rkPoxRqXIrfeW6q3I3T+8Utl8EiiHzq8cqO1TMukYR9Ne+Q79
         tfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748530612; x=1749135412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wtc8z1lt0l7J7qwleBMoPVIkOE4MKmf5AJAUWp638/g=;
        b=xDH+CbTW0Cn8bJWRdF1zchdcnsnwlmqVin2EUQp6hunKWHPJLrgxJ59m5Niq0XsTBT
         N8fHTFCxBGnelOEz57bSGoS7cGYfZZqlsoj/jhzTnBsMYusp3AfwmA8gjApcHB1aXuZC
         Ej78AvyPxFKFUSI3BmExPO4cItU6gAEURd3TGYmlMtZ0h/X1OTtIbtKtswuaF3qECX+d
         PmGGeAkNp2Jusy/+jV7bUTfypx1sPOknAGO5R557xS1NxeZr/VRDh+DRXGGlUht60alF
         nGz8Y9CDPCgdlOx6ZR9VEx8jKeOUcvMIGnwrWYVt/Q2SkZru666XMm6YbW2LJ4FuHzKV
         JX6g==
X-Forwarded-Encrypted: i=1; AJvYcCVHiYFu7HMVvKV/ojXB8cmbhMa0UwcBIghdu3Rm2KkEk+D9so7No0ght4Wb0uR7mNt5ypHfq88=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaRlOteEjM8GIcjfZUKzALP9gEq+NIb9WW+7j3tZo5NjhDs8D3
	CJaxd7XaRx7hYKDV3Lfa1LEyAvL72hfR2oM73NTQVw5WhTdeQajNYT1NHrrIac97Z7J5WWA0iyw
	xwiD8UA==
X-Google-Smtp-Source: AGHT+IEOksNt6WLBVwwH9cCjd/EZtQ2Y3bLCTU4Al9fuM3w6GA9Cf3/1B4op9exa2/CpdjOTCglkD0RIbFs=
X-Received: from pjbpq14.prod.google.com ([2002:a17:90b:3d8e:b0:311:2c1f:b0d8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c09:b0:30c:4b1d:330
 with SMTP id 98e67ed59e1d1-311e7460123mr9878567a91.27.1748530611851; Thu, 29
 May 2025 07:56:51 -0700 (PDT)
Date: Thu, 29 May 2025 07:56:50 -0700
In-Reply-To: <aDd-lbrJAX62UQLn@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-6-jthoughton@google.com> <aBqj3s8THH9SFzLO@google.com>
 <aDdwXrbAHmVqu0kA@linux.dev> <aDd-lbrJAX62UQLn@google.com>
Message-ID: <aDh1sgc5oAYDfGnF@google.com>
Subject: Re: [PATCH v2 05/13] KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, May 28, 2025, Sean Christopherson wrote:
> On Wed, May 28, 2025, Oliver Upton wrote:
> > On Tue, May 06, 2025 at 05:05:50PM -0700, Sean Christopherson wrote:
> > > > +	if ((old_flags ^ new_flags) & KVM_MEM_USERFAULT &&
> > > > +	    (change == KVM_MR_FLAGS_ONLY)) {
> > > > +		if (old_flags & KVM_MEM_USERFAULT)
> > > > +			kvm_mmu_recover_huge_pages(kvm, new);
> > > > +		else
> > > > +			kvm_arch_flush_shadow_memslot(kvm, old);
> > > 
> > > The call to kvm_arch_flush_shadow_memslot() should definitely go in common code.
> > > The fancy recovery logic is arch specific, but blasting the memslot when userfault
> > > is toggled on is not.
> > 
> > Not like anything in KVM is consistent but sprinkling translation
> > changes / invalidations between arch and generic code feels
> > error-prone.
> 
> Eh, leaving critical operations to arch code isn't exactly error free either :-)
> 
> > Especially if there isn't clear ownership of a particular flag, e.g. 0 -> 1
> > transitions happen in generic code and 1 -> 0 happens in arch code.
> 
> The difference I see is that removing access to the memslot on 0=>1 is mandatory,
> whereas any action on 1=>0 is not.  So IMO it's not arbitrary sprinkling of
> invalidations, it's deliberately putting the common, mandatory logic in generic
> code, while leaving optional performance tweaks to arch code.
> 
> > Even in the case of KVM_MEM_USERFAULT, an architecture could potentially
> > preserve the stage-2 translations but reap access permissions without
> > modifying page tables / TLBs.
> 
> Yes, but that wouldn't be strictly unique to KVM_MEM_USERFAULT.
> 
> E.g. for NUMA balancing faults (or rather, the PROT_NONE conversions), KVM could
> handle the mmu_notifier invalidations by removing access while keeping the PTEs,
> so that faulting the memory back would be a lighter weight operation.  Ditto for
> reacting to other protection changes that come through mmu_notifiers.
> 
> If we want to go down that general path, my preference would be to put the control
> logic in generic code, and then call dedicated arch APIs for removing protections.
> 
> > I'm happy with arch interfaces that clearly express intent (make this
> > memslot inaccessible), then the architecture can make an informed
> > decision about how to best achieve that. Otherwise we're always going to
> > use the largest possible hammer potentially overinvalidate.
> 
> Yeah, definitely no argument there given x86's history in this area.  Though if
> we want to tackle that problem straightaway, I think I'd vote to add the
> aforementioned dedicated APIs for removing protections, with a generic default
> implementation that simply invokes kvm_arch_flush_shadow_memslot().

Alternatively, we could punt on this issue entirely by not allowing userspace to
set KVM_MEM_USERFAULT on anything but KVM_MR_CREATE.  I.e. allow a FLAGS_ONLY
update to clear USERFAULT, but not set USERFAULT.

Other than emulating poisoned pages, is there a (potential) use case for setting
KVM_MEM_USERFAULT after a VM has been created?
