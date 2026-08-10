Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF60409295
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 23:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403124; cv=none; b=A1mSLgCC1qTjkSb1KNWZTIW0x6PfQhpeMFtKraGDdp7j8UtkCThhMP8yQwU3adKbY/nxnv1N+dlAq8kQO1cT8eA5HeljsVjIRugdVPtQNak1Qsk2OBeWPTwfcyia5hGd4Gg/ddAGSZ/3s93eHmlXsNgmDthjEPs9GX8eP4EoubU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403124; c=relaxed/simple;
	bh=1UixVDhcKktfLAVV3KH2xdxG9X17YLjD04ZwlUbLKmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f18d/RYHoLWM0NAxoXpIY4eMEw4yV55HjEgmL/2FrG4XIvU4SYW3OdVvUknqU/kZLPhBjRk7fGcKkJKKhopeEXgk2/TDvPOCcaBzAqFT+6nll221QsVPU8ZT0Av0LDV2jddjvK5JKUIx7Xo+7ozdqZOYuM6L96ExK6D4zsc9kzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M7CiuJF4; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M7CiuJF4"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84e048a801dso3548344b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 16:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786403122; x=1787007922; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/9OrpqxZWhRM/HFUiR8JGN523y//wB+NGc5onZ0jOJQ=;
        b=M7CiuJF45LiMv3L5TgznG21imImT0rEQv1elIqM4vq7/8wbtS7bdBYzH8kWAmcAOJN
         ypLfp9ckQ0TEcBrBKo6Rf981YMMDviLWpRxWXbgHXd5CwSUKz93VWVPa3oJd366ldlyn
         QdNXS1JMlkPM3SQQJ/S9KlV9QF+KbhG3QhAQox0P7PPeRp8+VhgCL0zXMhwghB96Upw8
         x4L7ynnu8Fi6yjIdg//wk+Oj8Svrx1LFHA5dC+Xg6r2KRTTlLSPo5gf2+JWGAb5FFgKm
         Y/OoKHXQkQC9G9cyD604+ln8mN2dbUo0LPNPTv8SJSD1MxCVTMPc5SmCu+OJJH+MgSz7
         QrYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403122; x=1787007922;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/9OrpqxZWhRM/HFUiR8JGN523y//wB+NGc5onZ0jOJQ=;
        b=XVKQyQhW6VSXG4tmdLEh6S1tPKiSOdEnYLReYpWI+3sdqP9WSkzUWO6QmoO2i/MzYk
         uQEpXe9eyP1zZ7YfvfinB1xbhmxiFF3B9AxlSvncbRqvieFcPmaB6o0yBMEY6cqfhFAI
         dsFFQIFt75DTGZa07KgFOsdDvwUDoepxB1K43z2yjw5NSvouWkvPDT1Sd1P7YO6I5G0/
         ndTALy//5BB5QTYM7ry2Y8KiaES5LXURCk/3GDD3VvnS8aMFuteQyL+cHvNuZ382XTwy
         c15sQBEaYGR+Vdc8j4Yg1dvwogABwdakcq8D/+zP3TUdTUjZJNx30lLQfpnPJdyeckQJ
         AqOw==
X-Forwarded-Encrypted: i=1; AHgh+Rr8rptEiVpg/tMpbAoYvWcmShAlZPSw69w1d73eqzo5uDd78jWp/SzljWSlCrgdVbLEl3Y448E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqFsjkcW/VdTSMcHObEsVgVm7mulBq0LVe0RDzXMPujC6NqIpn
	DwNkqrMvtHnsxpOmdylf6IWkSBAfPBab6sOvab34dl1PVuIoPA5ijvSunMBYCC5ihEx5wzWxzYg
	oso6aUQ==
X-Received: from pfnv2.prod.google.com ([2002:aa7:8502:0:b0:847:7765:a4c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:420c:b0:848:2f2c:b2c8
 with SMTP id d2e1a72fcca58-84f9c95f809mr5850968b3a.24.1786403121703; Mon, 10
 Aug 2026 16:05:21 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:05:21 -0700
In-Reply-To: <20260728121138.1103610-3-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-3-tarunsahu@google.com>
Message-ID: <anpZMemVz5yC_WLo@google.com>
Subject: Re: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
> - Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
>   anon_inode_getfile(), providing a unified VM file creation API.

As Ackerley pointed out, changelogs that are literally a list pretty much always
needs to be split.

These also need to explain *why*.  "providing a unified VM file creation API"
isn't sufficient justification.  In general, all of these changelogs need to
provide more of the "why"; I can figure out what the patches are doing easily
enough, but in my speed read of the series, it's hard to figure out the "why".
