Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168AF274B5D
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 21:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760046249; cv=none; b=RBL/2PeZtN8a16Eb6ClBYQlwwKRLjqxHTQ5BT0bolvQQZGO3HDdy0joL7BjZs5DqjVBg60dR4cf1+WeLK7nC0lq95pJlf9MXyNOXIoqLTghnrEtOZOt14xTd7VQWX+n4+HVR2TTnfwvNEEHnp+rIky4TOROwm1evBluPx7ZAmuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760046249; c=relaxed/simple;
	bh=QBQZ/PII2nd+INm4UhOt/3mrsSRtqFBJsjEBnrwYuhk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ehU7M2N2VE5Li2kkIEue+zuhgz7asQOtQ9fFRtCws677O+SWjK8vdP1tmH4ILOtxBieugQE1GZtKAAGyrT3NPHR6itgbg+dyQMZSgb45r5q8cT8iga22Cmh1zScRAkG9OelUywDhyCty9Ykehb1DBJnzm2SQw20P1JEyoJUE9Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x+tu3dPp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x+tu3dPp"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-26e4fcc744dso15104175ad.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 14:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760046247; x=1760651047; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BDlvwYPz97Xgh+aeVzA9ej1JjFbOizVBMxc/gGXHNu8=;
        b=x+tu3dPp6mHbHV81yvwXNyFQRmV/SQLWG4cVfqUPnuJ2GSrLxvssM0c6ejBx5wfdi8
         Z99zp9Mo9UmK+ml3Mfb/rQWRiEob9PnE+ZoAFlnoFFh2g5O+flfhXnaL4TPO9ZhT0vq+
         K9kXx4ZbzD1Nwplu1qppVTWLYRZEq9W3CalyWnDmAG4Myi5jYzh6C4lMn66+Asd72x6P
         BrPIz3PXLtKlfyxaBcASFqHdVBWw1qerhkWFE3QQsDfYY7OIX+Dnxsh474dweMFrCZLg
         bUOF11/b/ZoSoEiHz1bySTgbgThWmqclanPIZ02cq+jsHlCmEqh3y6/IFtrDFLIh5zdU
         DY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760046247; x=1760651047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDlvwYPz97Xgh+aeVzA9ej1JjFbOizVBMxc/gGXHNu8=;
        b=cUswNULSpJHbO/fj1HipVTUJFjyI9tXsYt+txrojvGnzFA3KQu4Yzg/i97mTm/uAde
         FdHzelgg3EY8AGa3h18Qr7D0Aqowrih73EAEihOXBkAhXqKv8q080m9+E+E6nLovAhhd
         JEbpwEFD/1ou6cBGdEZGhhb+hbkhVs9W2HfdtGDDiII3QK/XeS6x1rrfLfLpxSIrt8c8
         DEbr147dr8V9NE3lxeMDnYbEzCjBmb6GN+tR5VZSBYRN0hkBPkqJxrxMnrvAQefBwXHr
         dyErrv55Rb4W46mcrFSxKDU8WBQvoXMhV4eFnTvwN/5VJyd949Hzj5MQkXKsccnrPZjY
         W2Ng==
X-Forwarded-Encrypted: i=1; AJvYcCUPerjFpur1AtzjY2PETrgh6cziP0JDTAm4ZKftAdLYN+iI5p3MAxD/WuQ7djXWOIE8CHeDEmc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqO9cHmNSWgSTJKnq+oxGjb+dUaKyS5PyZvB5b5lWFBaTgO4U0
	j9olzW++Nik/0KFcl94Kdvt42HC8t3Dmz364r5KSnWKLHv5klYq3MWuJgPCnpPVz8Rv4Z3q28gd
	ywMuJU1GQeEWKCP8b5bBekKOtEA==
X-Google-Smtp-Source: AGHT+IFQjHCm6wm7SAnAbDplPBJVQjkKsdlYJBsa6mhJlfSzzwa6PeU2oGKlk2TkpKhjDbxnR+qB7/kozxjMndhM2A==
X-Received: from plnx24.prod.google.com ([2002:a17:902:8218:b0:24c:af07:f077])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:8cc:b0:267:e3af:ae67 with SMTP id d9443c01a7336-29027238ef6mr108267505ad.14.1760046247397;
 Thu, 09 Oct 2025 14:44:07 -0700 (PDT)
Date: Thu, 09 Oct 2025 14:44:06 -0700
In-Reply-To: <20251007221420.344669-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-7-seanjc@google.com>
Message-ID: <diqzqzvbhhsp.fsf@google.com>
Subject: Re: [PATCH v12 06/12] KVM: selftests: Define wrappers for common
 syscalls to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add kvm_<sycall> wrappers for munmap(), close(), fallocate(), and
> ftruncate() to cut down on boilerplate code when a sycall is expected
> to succeed, and to make it easier for developers to remember to assert
> success.
>
> Implement and use a macro framework similar to the kernel's SYSCALL_DEFINE
> infrastructure to further cut down on boilerplate code, and to drastically
> reduce the probability of typos as the kernel's syscall definitions can be
> copy+paste almost verbatim.
>
> Provide macros to build the raw <sycall>() wrappers as well, e.g. to
> replace hand-coded wrappers (NUMA) or pure open-coded calls.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> ---
>  tools/testing/selftests/kvm/arm64/vgic_irq.c  |  2 +-
>  .../selftests/kvm/include/kvm_syscalls.h      | 81 +++++++++++++++++++
>  .../testing/selftests/kvm/include/kvm_util.h  | 29 +------
>  .../selftests/kvm/kvm_binary_stats_test.c     |  4 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 31 ++-----
>  .../kvm/x86/private_mem_conversions_test.c    |  9 +--
>  6 files changed, 96 insertions(+), 60 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h
>
> 
> [...snip...]
> 
