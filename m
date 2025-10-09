Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61068283FF4
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049287; cv=none; b=LBcZptL6+HnRtP/SaKs1x6o5PZMizRTwKDsDNSQOsMghSea9ftihRnSiFI/MtX0LBRvdQmfENYmF7NRE0l0sXU4Kb1I/5Dxb8hHvLCiw4p4pU72ZNFeb0ASGTAHyPexRPqsH0VvsNrcWn5INlwui9bTrFxGMN+w86RtCaujo4cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049287; c=relaxed/simple;
	bh=9jN7yy4faemkFk4CnVeK+ylZLzuZ08PbRW1aI3m6yEo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l7EP0XP9welEITjxF6wuwsR94jP91iqShnrVB0vp2PsbBw/rBxnCLgz5PbjB/WXR9Au4My0sIdobNmk0SOv3s+alfFjhBeTbNJtvxA1tIVTcLiz+IT5T+sWc4x1tiYVbjcVARImcSENAskmqPlvWrDmED6R8ILM4LSv81GjgPvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lokFdpxk; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lokFdpxk"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-780f914b5a4so1975022b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 15:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049286; x=1760654086; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+k+gk6VQNvvMox+c8DfhOTxAsmkufNVxeH8bt4I1AGw=;
        b=lokFdpxksIlsA5wQAmdTqCTnJhbqhd3cHh5srtrKHw75DAwA/v8+MpXlP+wL/ig23c
         +ltazQ4u3qzIG8vYgJwuL9JZXO7EWvyT+ZUNXHUt6aianDfqpRfNqlMrHIJipBuN6SM8
         /foIk7WqDLcNZtjgfGBISCzdX1LDKkiTYMdb97/3fMVQ0nb//ad2MVJBf5Q5ONKedcQ0
         gGfozLNnwREIC8QXmfhdsqZutyucq5008doTP4pFyIlu7v1BP8qa37GrheSqxS2n4swR
         nPFovqSFA92ZGF9R/xPV5xm/GO3mA7iOh+4XNc3YLO6ySjmxCjLTAqXMyIO+vprJsF68
         TSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049286; x=1760654086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+k+gk6VQNvvMox+c8DfhOTxAsmkufNVxeH8bt4I1AGw=;
        b=kHS/YsfwtNYowej+e55arUG7y+B/uFRJlD6YtKTE2jxeBmERGCQIGIXPLne5vp/VWs
         R6y6ySG/sdsezD+34Y6AMkt+wCkC60q3HO0gw+2C3NPz6c+r4hVrzzVJ1L0XWjShf/DL
         pIcYJSTvoZ0vVAfck4zeqtX0DsflaMO4WzLb9juzbrOfwcHOzDxRItRtzBnUe4QCH75z
         4jVeQCVftuYdjhM7Lf91WmrKevwiBx8ZcqbNC/C0FgfhSElcPqD/tKJTdKwTOZint/xX
         bmzY/tbz+HHSUqOHmWzsgyQcQwWtk+OSE5AF2FSEjSH53WjIv8UarnhN0EzBr54XNNlu
         ltHA==
X-Forwarded-Encrypted: i=1; AJvYcCUmieI2P5gIR5SPP8aSX0yRf+G1dMc9QzxMu+10ezpmSzup2Ff8ji9baRZIh+CLBthz6ZkGpy4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNCqYlizHpEPGwuoUyEVMFmGp7xEFc/QT6SVV1IzPXcBxbbYK0
	YMCq1H+OzHmhQ1uUXR/I6frvt6Qhkb/eHB0CRNGLN6HB/aFpMHCe+bWmi5lcpTA3UB0JB7U+2lZ
	39W9BzgsHMfXhwfvP31z0k+ZX8Q==
X-Google-Smtp-Source: AGHT+IFT3+ACqwDT2lCoDe9XM9NV6pIpsUJnUvsrRoGgkm257Ov/Ea7I3q36/zx0MsZeeBCKYpcs1LHgia7b4IPfmg==
X-Received: from pfbgu11.prod.google.com ([2002:a05:6a00:4e4b:b0:77f:3d60:9807])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:391a:b0:77e:8130:fda with SMTP id d2e1a72fcca58-79385ddc9f9mr11632278b3a.13.1760049285570;
 Thu, 09 Oct 2025 15:34:45 -0700 (PDT)
Date: Thu, 09 Oct 2025 15:34:44 -0700
In-Reply-To: <20251007221420.344669-9-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-9-seanjc@google.com>
Message-ID: <diqzfrbrhfgb.fsf@google.com>
Subject: Re: [PATCH v12 08/12] KVM: selftests: Add additional equivalents to
 libnuma APIs in KVM's numaif.h
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add APIs for all syscalls defined in the kernel's mm/mempolicy.c to match
> those that would be provided by linking to libnuma.  Opportunistically use
> the recently inroduced KVM_SYSCALL_DEFINE() builders to take care of the
> boilderplate, and to fix a flaw where the two existing wrappers would

Typo in boilderplate!

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> generate multiple symbols if numaif.h were to be included multiple times.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/numaif.h  | 36 +++++++++++--------
>  .../selftests/kvm/x86/xapic_ipi_test.c        |  5 ++-
>  2 files changed, 23 insertions(+), 18 deletions(-)
>
> 
> [...snip...]
> 
