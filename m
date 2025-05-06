Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875A153BD9
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 23:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746575284; cv=none; b=eMdNR0f4wiU22DdF9WbVqR0fy3Ds5KOgnMOYQuup0Zip7qmsE/BcZXdA98XYd78iiasiXnoI1P5UQ8jkKoO626xLweka63bHRo4VPh4sO6fbPh9vJQMzNeUkYK8Mt5pqDVAlXlXsqL9Sg9filzaJh50+6cZdhl7cpaR6RN+buSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746575284; c=relaxed/simple;
	bh=NzEAJGMGj67aqLOqPzD1WsJBqcysNCKrFhpDypZk/yY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bPdqlmPoWRFsHyF4Ev+F5cqMTElxq50yDTlDp9UQnJvDrL+t5TMG5gWrXuCry/d3L+qA883SDosJubpwrLpK+kT9vmw9eY5HWVHgc+BjLXk2aMBK/Tk5gpaNFKk8MCkDtlbg9e3wYTOWfHzReS0TSUNMMDDPxtdu8MU/Ul8Oe5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lX4GNA+h; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lX4GNA+h"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-306b590faaeso4444873a91.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 16:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746575282; x=1747180082; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iGR21MUMyA/Iej7QErtZc8eyio+Dks1zWhBSbKI/rik=;
        b=lX4GNA+hDJxXEI1GMZmI5Vaf1WCXNGlPMhlLsiq1cqrGwMx3tMy6UDNhj1/6l+e2k8
         iAuLUpr1dSUIXSjD4WvruDSJlv3HCEhrZ4m4yeE53rT7M+XiMn0rwim64vvbAuiTY0WP
         MjNKCCzRT3cXbnlATqXb3HO1vHj81M2T1SGDZa8UWI3p1uWh++WfYegPkbsTwkubiuwb
         Rv+SU2xzxdsZ87vV5cRSgUjxJKhDJ2NeUXpCN1qR2jXkBHc9i7tAoeP5m5v/s+Rm+6r/
         sheSMQFJBufh/MehPzeF9unXFAfWLOa5m21mTx5VvivMU9SdLaIkgglW7+2GilxubIJo
         Anpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746575282; x=1747180082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iGR21MUMyA/Iej7QErtZc8eyio+Dks1zWhBSbKI/rik=;
        b=RbuKHcOTKiVAbteDFeOS1v/jaR+J2/FevqTODupCexh2ydtDUhlPvm8qFKX9qgMhPv
         96PR7ODS/c3WW9kdH33Af+Oq6oJY/gskdO1/MC7vcaTOz/x4SwPSz7fSFGc2sz9KIZbr
         CGLWdLq1P+EYWdbEuJztJ1wU745lsmx5PZx44C0fUE/xu1sE8RtuVYoHvZxA/5McKZWS
         iGsVdj2Nctjt2cBnxjzJckH4xUkeGI9o0NHw9mJzhLzEk/8ePMZGg25O0N+Es3iZNllh
         /ImhIkZB9yhvQUS6MWsKzEfgX1Y7VaF+30YljFXtvzgTlpaKHTW1j9mxX0h2LA0EUOpa
         oy1g==
X-Forwarded-Encrypted: i=1; AJvYcCUUSlG8scybBkPK8zSzS2G0kI9eAIZ1DLcxytWAbYRCE4TF+QwIyMosXhF+rs0tJolOKkF6aE4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRj5Vj/qzcvsnwg/jciEk/r7mQRXrA04XPy28tNXaRxBt7rjgf
	iVM/BZP589dp9en+gfZXAQmdJEvQacWovxRfmfkbr/YpqsFmAEg2TWYHKPVJwsQ/F7ogZyo+AMQ
	NJQ==
X-Google-Smtp-Source: AGHT+IEI4VPbZHYscktwEOVP6g5TZOKepWU/P1YF6Ndm56diDY5BXYXdB3X0UtnsxrDOZgtWBFkyQyHQxS4=
X-Received: from pjbsr12.prod.google.com ([2002:a17:90b:4e8c:b0:30a:2095:204b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e84:b0:2ff:5357:1c7f
 with SMTP id 98e67ed59e1d1-30aac28b3bcmr1863522a91.30.1746575282052; Tue, 06
 May 2025 16:48:02 -0700 (PDT)
Date: Tue, 6 May 2025 16:48:00 -0700
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
Message-ID: <aBqfsGtUjBUJudFB@google.com>
Subject: Re: [PATCH v2 00/13] KVM: Introduce KVM Userfault
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, James Houghton wrote:
> James Houghton (13):
>   KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
>   KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
>   KVM: Allow late setting of KVM_MEM_USERFAULT on guest_memfd memslot
>   KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION

Starting with some series-wide feedback, the granularity of these first few
patches is too fine.  I normally like to split things up, but honestly, this is
such a small feature that I don't see much point in separating the uAPI from the
infrastructure.

To avoid cyclical dependencies between common KVM and arch code, we can do all
the prep, but not fully enable+advertise support on any architecture until all
targeted architectures are fully ready.

In other words, I think we should squish these into one patch, minus this bit at
the very end of the series (spoiler alert):

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ce7bf5de6d72..0106d6d461a3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1545,6 +1545,9 @@ static int check_memory_region_flags(struct kvm *kvm,
            !(mem->flags & KVM_MEM_GUEST_MEMFD))
                valid_flags |= KVM_MEM_READONLY;
 
+       if (IS_ENABLED(CONFIG_KVM_GENERIC_PAGE_FAULT))
+               valid_flags |= KVM_MEM_USERFAULT;
+
        if (mem->flags & ~valid_flags)
                return -EINVAL;
 
@@ -4824,6 +4827,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
        case KVM_CAP_CHECK_EXTENSION_VM:
        case KVM_CAP_ENABLE_CAP_VM:
        case KVM_CAP_HALT_POLL:
+#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
+       case KVM_CAP_USERFAULT:
+#endif
                return 1;
 #ifdef CONFIG_KVM_MMIO
        case KVM_CAP_COALESCED_MMIO:
