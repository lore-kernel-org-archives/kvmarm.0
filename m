Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBFE35334D
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 12:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756299467; cv=none; b=JGJcstObYJl5nCBDss2SlR0WCQujauui2KyQD45OQtGR824z0hOnqPrpOKFFrwIPmeSHjApbEbu/BfjWc1ZmoipZv3tD3AtKKecjjWNI2WOnRYc6/oOMm5RToxbEExelsq6D6+fMFqdYCcPGxCyfnCSiQdo6V2gJARY1PQKrcDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756299467; c=relaxed/simple;
	bh=w3nOGUy17xC76CjSfrnPpR5S63ym37zVcNGqJFaVJTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qNyf3lL913BwQGQEttA0SRFx7SOMDJYnuMWMbGS2rbzBTcU8BQXyRs8BRgA7O2JNhCr5KEVDRSxxuiEAxxk+AK+k0d00AeE45yrYqI3sfRvmFiVaNMUCV8WhekLFvuui8EiVBue/PWabcl8W5oGpvwKUnzVBGlyoFt1yLfq6Tx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/GEBd/J; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/GEBd/J"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2461c537540so72638075ad.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756299465; x=1756904265; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tBqCOEucd2EHQAImfHa6bYvYMgk6Ar5j1i6s5MVGeY8=;
        b=i/GEBd/Jp8bXBoLRB63qwgKw/MSj2MjuPBMbJ7a+74Wpmp0nNPYwuIrsd3lwqXk++v
         r39c9Rxy2CK38eYcJ8O/B28ArKkcywx5uJv014pDBGa7Xd1NGZw9QGn8Caa3mPZTt4Yt
         7N1V3uJ3/H8bv+t+qzioS1qhIqJwPWMnQCyjR60fol/jqaLQ62u4rbB/LteQZC0ex4os
         NQ6ECoSGkYopu1gsWaKuIRvrqQMeP3bMaa3KnpNV7naTgpBQLwTE7NzFnS7L1M2fQaTO
         TXhOCa6gRAjWb+v53s/9fh0Z/CsJxaNDiS/A7HRyfOB+kqmhQ+augT7+knhHq0O+Mj3h
         YtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756299465; x=1756904265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBqCOEucd2EHQAImfHa6bYvYMgk6Ar5j1i6s5MVGeY8=;
        b=nydHUkqC0MQClbT8yWrXta/kMO2ZxIMBdeNeZsw2mULUp14x9Cq/5tax6wrOXWYGw9
         CfNTrQW1O8ZmZ+HRy9/4tPPflDTZXaRrWo3EiZu6gZkvcTavANyP+0q+tbqLuHAsQXAm
         sfmfaYmwHaJxOuHbdQeuxZhoi9lJNGgx/D8XR5O5E3+iX1k5kLOZpm+Q8O0fcV1/WJP/
         gtLEMWqrwxDCiABZgDobhbJBG7wo/qb+wvzJ5A4b8uJBD/lvoMJ1FHLXMSoDgUnksgHm
         eNM8yZGKeRzw3SeUzjipJfF5dAGGNRPiT12uonOCf794iP77uL+0/HCHu0xWg+gdsdeo
         OVFg==
X-Forwarded-Encrypted: i=1; AJvYcCXBLolMoiwd/rR4M/QK26pAzwLIrVZvzZrd7exNvtvSNiptS+HM98PWEh97SF/SPXpPf/SaTFM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwC/dWqNSbP2eo0ACmXTuAhoNhb63xlYOt4hX0x6mucbqjjz+/
	UCLW8XYYj5nUVAk8iS93AVeWyYL317ecLrwmtQ/K2CnAuI0lFrXCCq8We3fdgNWpsdX7y2t9GZM
	Lm4z4Qg==
X-Google-Smtp-Source: AGHT+IGjYzo/cbnGJG6xrvxcdKkBIhOc9WrrVofRF0UoN4jq9615eiNnHnaTmYmPl4ZeSe1Rkx8Oa2x6F14=
X-Received: from plbmq12.prod.google.com ([2002:a17:902:fd4c:b0:248:8f78:7ff4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db0e:b0:246:edc9:3a80
 with SMTP id d9443c01a7336-246edc93d95mr136614825ad.5.1756299465291; Wed, 27
 Aug 2025 05:57:45 -0700 (PDT)
Date: Wed, 27 Aug 2025 05:57:43 -0700
In-Reply-To: <87b10d94-dca2-4ecb-a86f-b38c5c90e0cf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <87b10d94-dca2-4ecb-a86f-b38c5c90e0cf@redhat.com>
Message-ID: <aK8Ax2EchXMuX642@google.com>
Subject: Re: [PATCH v17 00/24] KVM: Enable mmap() for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 27, 2025, Paolo Bonzini wrote:
> On 7/30/25 00:54, Sean Christopherson wrote:
> > Paolo,
> > 
> > The arm64 patches have been Reviewed-by Marc, and AFAICT the x86 side of
> > things is a go.  Barring a screwup on my end, this just needs your approval.
> > 
> > Assuming everything looks good, it'd be helpful to get this into kvm/next
> > shortly after rc1.  The x86 Kconfig changes in particular create semantic
> > conflicts with in-flight series.
> > 
> > 
> > Add support for host userspace mapping of guest_memfd-backed memory for VM
> > types that do NOT use support KVM_MEMORY_ATTRIBUTE_PRIVATE (which isn't
> > precisely the same thing as CoCo VMs, since x86's SEV-MEM and SEV-ES have
> > no way to detect private vs. shared).
> > 
> > mmap() support paves the way for several evolving KVM use cases:
> > 
> >   * Allows VMMs like Firecracker to run guests entirely backed by
> >     guest_memfd [1]. This provides a unified memory management model for
> >     both confidential and non-confidential guests, simplifying VMM design.
> > 
> >   * Enhanced Security via direct map removal: When combined with Patrick's
> >     series for direct map removal [2], this provides additional hardening
> >     against Spectre-like transient execution attacks by eliminating the
> >     need for host kernel direct maps of guest memory.
> > 
> >   * Lays the groundwork for *restricted* mmap() support for guest_memfd-backed
> >     memory on CoCo platforms [3] that permit in-place
> >     sharing of guest memory with the host.
> > 
> > Based on kvm/queue.
> 
> Applied to kvm/next, thanks!

Thank you!

FWIW, I did separate run of the patches and came up with the same resolutions
for the arm64 changes, so I'm sure they're perfect ;-)
