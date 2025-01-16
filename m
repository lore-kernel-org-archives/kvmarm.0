Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA221D9346
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 22:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737065779; cv=none; b=ETdjZRkjY5SJyKEM+DuGmV8/02zVyXQNwgY1pkU04iCQgy2H+/Bqcv8VY4xApqcuDC7Ds4fDmkQlWmXtEJinLtqq0EfjJty4eRJ6tbOTN4FBDs0H8kS+X8+QzCLtDkwQyn7HLElQscbtySvI3eeEhsEkegMw3XF0JH92Irk6it4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737065779; c=relaxed/simple;
	bh=Z0ddV2nDeH1UNqlW0vz2htYefbtJD3MtZnrUV8fkTRs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZcuzgctNt/XsTOmD3anPQRJKEyDDdHfa6fEqWo+6h8ciPCtfpdcPFvdsnvoz0MNSbJGQf+vis+Tz36XcYHZSIRtX+Tv7BnaUqFJ19XxhIs+wKlUB+el7PdPLSTnDnbB+fmrYAOZNc/9aPDhg/8ClZgNr/moUZB7ytEJy9peSWHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PekjV5tn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PekjV5tn"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so2778164a91.3
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 14:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737065777; x=1737670577; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ+7NcQN2GRHERXJVYagMBxlSawy5BYRQeFxBS4jvGU=;
        b=PekjV5tnt7OVdy6BWdtBQvH6vI0S5lBrLccq/1NaL+9Rfs9J2wVzEmvVj2wBMPzljS
         +4vDx+otYbxmoJIsRTnnp96xe+p6vQUxtrxHcvwKtLStFgv3kXKdiDpmFspFCbIwvZ4U
         9jRP93QYSfhayD4Mb5qzXO0rWhTv/0kybbH2/s16d8GHadkKccHOwIdO+3Cd54hSuMtn
         j3saH2Hc6pD9scV2FZb1l/0NFvzDsNcesJwIal4tbkC9bxH83uKtMM1Nvln4CcgVaU6x
         cVLbZxn++VAfexczXqE64QlefD7FSIp2551y40W9S/cpQ/wqSvqPf7m1hX5pia/jV5ts
         xnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737065777; x=1737670577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ+7NcQN2GRHERXJVYagMBxlSawy5BYRQeFxBS4jvGU=;
        b=Cexap+qaI9J1kfCToL26orq9mXb59x2fqP9gjv65dwjzJbStIM3XDgGvz2EMGMYm5v
         wTOFu7ew8WWHpRKriaVJvnHKK8C4ZqLJSeCyLBfYi22QAuq0F5QxswOdI94GkKszCrCW
         0hr7vlAEaS27AFbAkx1mydGoUx83qwfXnhtd87/u1E96V4a3JBo3jlCAM+1W2QdsYcAj
         NNMxGpxNnuc7vOEbV2HuHPmEhDPzL1cqoVJ25Wg7RLJzCrt8e//S6wDzymVNWpScOS1r
         eifT0Rji6B+pq6MDo+NyqgpJF1+NYQO2RKqFqfHyjPb9sxKWdnAqnGDvbmQNiTPMY53u
         S2JA==
X-Forwarded-Encrypted: i=1; AJvYcCU/pLBlVCKAxtOg5bsZDDIbTOkvBb0abydztI+EwrNfrrqj35lEL1I5kJ98jWuhghiO03xoOGM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwU8/MHBJC4+HcReNhWloNSdlYzbu3huwV9I7E29flljJwDu5JH
	PLPleF2FrT8RsC/spb8IPkHEQ0WekFmsKdnZJQgTOekcs4QOTUeOlphL5V/MfftLTlL8S7j7qx3
	7mw==
X-Google-Smtp-Source: AGHT+IFQWdmM2razhLJbL5aP2luCP61s/wuhDj08lqTNDx6qC+0wGyJoLk/MjnPxGPcgL9u/wZA2pdBixos=
X-Received: from pjbsn6.prod.google.com ([2002:a17:90b:2e86:b0:2ea:4139:e72d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2c7:b0:2ef:2d9f:8e55
 with SMTP id 98e67ed59e1d1-2f782ca1fffmr397272a91.17.1737065777241; Thu, 16
 Jan 2025 14:16:17 -0800 (PST)
Date: Thu, 16 Jan 2025 14:16:15 -0800
In-Reply-To: <Z4lsxgFSdiqpNtdG@x1n>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n> <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n> <Z4lsxgFSdiqpNtdG@x1n>
Message-ID: <Z4mFL8wfHjvz6F1Y@google.com>
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 16, 2025, Peter Xu wrote:
> On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> > > For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
> > > replacing it. And as of right now anyway, KVM Userfault *does* provide
> > > a complete post-copy system for gmem.
> > > 
> > > When gmem pages can be mapped into userspace, for post-copy to remain
> > > functional, userspace-mapped gmem will need userfaultfd integration.
> > > Keep in mind that even after this integration happens, userfaultfd
> > > alone will *not* be a complete post-copy solution, as vCPU faults
> > > won't be resolved via the userspace page tables.
> > 
> > Do you know in context of CoCo, whether a private page can be accessed at
> > all outside of KVM?
> > 
> > I think I'm pretty sure now a private page can never be mapped to
> > userspace.  However, can another module like vhost-kernel access it during
> > postcopy?  My impression of that is still a yes, but then how about
> > vhost-user?
> > 
> > Here, the "vhost-kernel" part represents a question on whether private
> > pages can be accessed at all outside KVM.  While "vhost-user" part
> > represents a question on whether, if the previous vhost-kernel question
> > answers as "yes it can", such access attempt can happen in another
> > process/task (hence, not only does it lack KVM context, but also not
> > sharing the same task context).
> 
> Right after I sent it, I just recalled whenever a device needs to access
> the page, it needs to be converted to shared pages first..

FWIW, once Trusted I/O comes along, "trusted" devices will be able to access guest
private memory.  The basic gist is that the IOMMU will enforce access to private
memory, e.g. on AMD the IOMMU will check the RMP[*], and I believe the plan for
TDX is to have the IOMMU share the Secure-EPT tables that are used by the CPU.

[*] https://www.amd.com/content/dam/amd/en/documents/developer/sev-tio-whitepaper.pdf

> So I suppose the questions were not valid at all!  It is not about the
> context but that the pages will be shared always whenever a device in
> whatever form will access it..
> 
> Fundamentally I'm thinking about whether userfaultfd must support (fd,
> offset) tuple.  Now I suppose it's not, because vCPUs accessing
> private/shared will all exit to userspace, while all non-vCPU / devices can
> access shared pages only.
> 
> In that case, looks like userfaultfd can support CoCo on device emulations
> by sticking with virtual-address traps like before, at least from that
> specific POV.
> 
> -- 
> Peter Xu
> 
