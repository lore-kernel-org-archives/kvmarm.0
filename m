Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03068221FAF
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 20:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750451519; cv=none; b=HfD7JsP6tNqe3rH4A9644msMYEsU6J70g4d+JPIkdAjHDS82Hk64hEcCH6X8x96IxYyaOtbv/pDOOP9ueRuiePIkU+GF+/kLJX7KwJO72PV343Suo1hkf8F72UbNz8RtV5UM3eog3gEzkHZUk4BVl46Aq7T8pvN145LQvLFrR3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750451519; c=relaxed/simple;
	bh=gPYvpazE5IHW++4+swnhzOjII5AZCwNMAl3KBQt/agU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h4LxANSDENm9wcuHNV4uwEDkdpBbNdnJVNHZw2crCM/iRFqd5MANAyPmeOJvc0A02vvF7+wdyNouD4HIWuAPs6bruZatZfdsEbjiVu4DZd7oVzOnkg/B+qyZsdgVUjZvtCXMzKSSz4C/VFBQQ/ShvWhCXZTjNrQInaN8LVc2eFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L4KUBHSK; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L4KUBHSK"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31814efd1cso1433125a12.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 13:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750451517; x=1751056317; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt/+aWwyrkpIimxSl5BUL+43sm1rEuMKKgBDpLCw3jg=;
        b=L4KUBHSKn7mxXdMDyMIVIp8TMah7E6QYdXH+lEIcE/ctltnRH4zger43VvsvaPVK61
         gSb6S5LtY6QkHb5m/2frfixRV8zmmwSet2eeop226oj1hMiY4PMOPEV9ltXoFCU+MYdx
         g0/D4F6yNft/05Scxhd4yZk6hwljox76+oK6rD/R3k1Ad57m37HQ/pTiCTgAUuB3PjdY
         Ok6ovDFs7ATKk4W8qLoZ/42K+ORcis8n7goYIhePGYjjGz+/ohPCK1kqCbq/WqftOlXJ
         JBzUhJzktpTGMfDkRSe+1j6lu+Zpix5f2b0o7nsRZaL+n6dSenHmM/edtnc+T2Rg3o+0
         sy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750451517; x=1751056317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt/+aWwyrkpIimxSl5BUL+43sm1rEuMKKgBDpLCw3jg=;
        b=xR6ZJhHzuhRaEwUkDsxEVxy8glSlTpF+FQvcV713cSGj8DWC4en7JrPQ5ERW2UP8Fd
         KxFysln5iCBOsfqU5lDsv01qS4lW4E5BJ3vLDJ2R7nvrBYVkfiy+SedFJHqAqWfo4WIo
         RpVDQL6ofV0W5Ix5UTRDk6gTKo1yoWP45lTWP9oE9DZ+OU5EktVblsUZ6bB4Fh1HPTyf
         p2WgVhANDpyxNxYIpQaAnCKkaf+5GYlky7f3Nn7ixel+RtSET1Pb9COcfnlMfDYEJXEr
         xGsghB1c28k71DjpSAt/eeHuMzLZXyr0bwzbnzFGxvNER7D6cQEC0ZNtwQGZqxEk5kZ6
         AQDg==
X-Forwarded-Encrypted: i=1; AJvYcCVdFPYeQmsC3EL6WdHw3b34A/rVIBVqw+dTKi8vgA88Ev1Z2nmsxdGlR2rFhoIfNtO8f64T/Wc=@lists.linux.dev
X-Gm-Message-State: AOJu0YztAya9U/kK1daPwNDYZGY7VVkUgrn/MxU3Mg2oW2tPZ/3vfkYC
	16j28bdzqVAS7O/HeDRzXD7kYkQ7h2cRp6wj4ppBafnX8/SDRcy2UPO04rOL6AvtHO99tw6tRGr
	Npz4SuA==
X-Google-Smtp-Source: AGHT+IENxgy3xkU/bYFGboojnHAxZAT6iEP2BT2EbQa3Q20JReS/EV7Fji9LhO0E/EbM/UcH2Oi/Nx+lNZo=
X-Received: from pjb7.prod.google.com ([2002:a17:90b:2f07:b0:312:f650:c7aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5212:b0:311:b3e7:fb3c
 with SMTP id 98e67ed59e1d1-3159d8fef6dmr5375179a91.31.1750451517093; Fri, 20
 Jun 2025 13:31:57 -0700 (PDT)
Date: Fri, 20 Jun 2025 13:31:55 -0700
In-Reply-To: <aFW2NISX0q11sop1@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-4-seanjc@google.com>
 <86tt4lcgs3.wl-maz@kernel.org> <aErlezuoFJ8u0ue-@google.com>
 <aEyOcJJsys9mm_Xs@linux.dev> <aFWY2LTVIxz5rfhh@google.com>
 <aFWtB6Vmn9MnfkEi@linux.dev> <aFWws7h3L-iN52sF@google.com> <aFW2NISX0q11sop1@linux.dev>
Message-ID: <aFXFO6_lVV5PpGW-@google.com>
Subject: Re: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 20, 2025, Oliver Upton wrote:
> On Fri, Jun 20, 2025 at 12:04:19PM -0700, Sean Christopherson wrote:
> > If I post it as a standalone patch, could you/Marc put it into a stable topic
> > branch based on kvm/master? (kvm/master now has patch 1, yay!)  Then I can create
> > a topic branch for this mountain of stuff based on the arm64 topic branch.
> 
> Ok, how about making the arm64 piece patch 1 in your series and you take
> the whole pile. If we need it, I'll bug you for a ref that only has the
> first change.

Any preference as to whether I formally post the last version, or if I apply it
directly from this thread?

> That ok?

Ya, works for me.  What's the going bribe rate for an ack these days?  :-D
