Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC1B1FE452
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 19:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452115; cv=none; b=Ynta7/oD5M24/1IODNyox6VM0B8MVbmOb849EeNubQNo6HoD7VXHzdEPOTiTYJvvo+rSExYkCdAgyeF2AbzuFPID1L4Q/0YgL3U/QzAtlAD+qZy3KHIeJGDU0xfeO+RmdfljWrZRMbOahsdgde//qqHhJ8T1lMzwHouQdGIavwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452115; c=relaxed/simple;
	bh=PrFEaEU7DDCl4he6jOcyQtK457MKdnxMIh7aWoIbbEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tSBRkO28aK0x1YNbX2wMdu7yMsH+5FqM2OmAdKfw5GwoU1w3PaP+70CuIi3yeu1bUSHZfkiaZwKxfaKb9Pkb15GSY2q9peXwepzfIKklcyyEdX8vidVdXzS4gkB8v7lvxNn/pbwHcaJ/5ZbaW05JT3/1dx7n7AS11PmbhXwhPds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RklXU5dO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RklXU5dO"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9204f898so2188779a91.2
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 11:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452114; x=1737056914; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DtNoMkgEfRqjn0GoMRLYiLeDG4/kOjxv1c8ix0/Uo/Q=;
        b=RklXU5dO9EnriAK40HNx9yP9jq52yxFmaHEsgYhkzeIsaLqdT14el/UBkmXJvehECt
         esK7Q7MBRXZarMMRAyWVz4skex6CBwAYpqwjEfTQ9j4IEPOiivwmlk2xbh0C9urkBzcD
         soVomeT512ThzEd0QOlVmEDSx4iz5eUraZkmWolEol0Lc3dnKxEz1670CXMdtEEv6Xw7
         7FiBIAjkUBi9VZM3w1p0Fy9FhRsCe0JSRjqidY77azDPvgMTJL5zhk4AoUAzUX+NkYwu
         8uJTbIvmD1pO/kxbYfR4l6xoF22o7S769exQeU27LyweeffViMnvy6Pcgk57AMighu3n
         VHVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452114; x=1737056914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DtNoMkgEfRqjn0GoMRLYiLeDG4/kOjxv1c8ix0/Uo/Q=;
        b=VgAb94cL/B7ZSmP1zdve+pzJPfkUA6oyOTtA80kY/qEVoA5OlN95MOIXmVgFIq5azN
         onxw81uYgFOa94B1fqPPFwjvRmrAzaOLHVjJ4DR2TRwZKvw7MssTY6OWU4n4ltLlaee9
         DrNBSnu4UdOeIfRsZmRqJt9L///9u7OPEWE5cAYKQxNFXT5QV19GDoK/uNsNOXgfRXcS
         IIQvAudonOXWROzQS2cxH6I5htWDuptG0JIhnLMuFAICDEveR/gwe4IOFy6HMRyGag68
         rWNxO0IsRmNvL3Wi6qyaPlaSSLAbBAV9F2GjFm9KK4RsFzDyLuYUnWxmtI+i6zWfMSf2
         EFzg==
X-Forwarded-Encrypted: i=1; AJvYcCVRttlL0c3z44Zzhyprxo1Ne+n544SJlhXexx88FSjzDSRhfgh1+0XlMq4pMPD5/mMb5sk191Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw35/VrHvrpTfdmvwRCeI3+a2HStY4VoJcRMw/gZGCFdqzga73r
	rMYnQTO+YSi5P5SXRWuj2X9NTa5Pvxx1BZEJdhpa0NiCBS0K+qHIiTW8x0tRbZ4GQkJl7no5f8N
	DNA==
X-Google-Smtp-Source: AGHT+IGQsYeXCTLoQtv4zUeKKUd67KMOBJssqkUIj3hvgSqGZyfbB6lhOhAReCaRc5UAnOKDVlHxinf8YUY=
X-Received: from pjbsl13.prod.google.com ([2002:a17:90b:2e0d:b0:2ef:85ba:108f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8a:b0:2ee:c9d8:d01a
 with SMTP id 98e67ed59e1d1-2f548f33b54mr11852213a91.11.1736452113738; Thu, 09
 Jan 2025 11:48:33 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:13 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645122896.885867.13450184481916964756.b4-ty@google.com>
Subject: Re: [PATCH 0/8] KVM: selftests: Binary stats fixes and infra updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 19 Dec 2024 17:38:58 -0800, Sean Christopherson wrote:
> Fix a handful of bugs in the binary stats infrastructure, expand support
> to vCPU-scoped stats, enumerate all KVM stats in selftests, and use the
> enumerated stats to assert at compile-time that {vm,vcpu}_get_stat() is
> getting a stat that actually exists.
> 
> Most of the bugs are benign, and AFAICT, none actually cause problems in
> the current code base.  The worst of the bugs is lack of validation that
> the requested stat actually exists, which is quite annoying if someone
> fat fingers a stat name, tries to get a vCPU stat on a VM FD, etc.
> 
> [...]

Applied 1-7 to kvm-x86 selftests (x86 wants to build tests on the vCPU-scoped
stats infrastructure).  

I'll hold off on the compile-time assertions stuff until there's consensus that
we want to go that route for all architectures (not at all urgent).

[1/8] KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
      https://github.com/kvm-x86/linux/commit/b68ec5b6869f
[2/8] KVM: selftests: Close VM's binary stats FD when releasing VM
      https://github.com/kvm-x86/linux/commit/a59768d6cb64
[3/8] KVM: selftests: Assert that __vm_get_stat() actually finds a stat
      https://github.com/kvm-x86/linux/commit/52ef723593fe
[4/8] KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name string
      https://github.com/kvm-x86/linux/commit/7884da344973
[5/8] KVM: selftests: Add struct and helpers to wrap binary stats cache
      https://github.com/kvm-x86/linux/commit/384544c026f6
[6/8] KVM: selftests: Get VM's binary stats FD when opening VM
      https://github.com/kvm-x86/linux/commit/6d22ccb1c309
[7/8] KVM: selftests: Add infrastructure for getting vCPU binary stats
      https://github.com/kvm-x86/linux/commit/60d432517838
[8/8] KVM: selftests: Add compile-time assertions to guard against stats typos
      not applied

--
https://github.com/kvm-x86/linux/tree/next
