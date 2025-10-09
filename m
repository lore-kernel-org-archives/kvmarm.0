Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C2E16DEB1
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 22:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760048217; cv=none; b=m5Y3LdWXWbQsWs99m4XiXIuAdsPAuy2ehzjsAfLeY/AAdnIK/cjSPktMY9n74YkgXCWIwZvrJf+tCtQC4vfDJBKdjDJ1I4zX67JwpnTVQaK4wBduUTgGpckwKZvBNBYzUk6OZQUltaNqwdHVEaWKXwAlEvKU98A7VSyeqMqfSu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760048217; c=relaxed/simple;
	bh=krBRRfDdwyas1WntIR8CFkZ9BCSn/cu8ny6/qRRn7Ro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xxdae07Vspgt3FWMIn3Wggny2ELn3LnbVmrTDCKJiuM4I/TBco1W5U2gG31RqF5ujqz28/28SDaoR5hTtMB2t4SjGaSmB6bPiWp4uxHgIpf7H+LnIhi6iPjrN+tG3ZaWdA3I1sKCM2tfumT4K6i2FnD+lv3/R7HNi5d6RRw7n/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i4wo2C/l; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i4wo2C/l"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5509ed1854so1619045a12.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 15:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760048216; x=1760653016; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ouGIZ18YYsl/9GqodU9OqB8J+uPEhuPrGCcLgx0Wyc=;
        b=i4wo2C/lb7coCTwpwFjHsKJRTXLpMjyBrVLfqids1RbIVyPhPi0DEkW6twlXAyJq4z
         XQSQvIDfFmgyqTmOLb4K5JDBy0LD3sB6RxH4TB9mBhCDajgqZBGwJVsQ/mG0Mj/vpn5Z
         1apSu4gBG2AoYNK9zv4UKXDFNByYEFQwEN+uwGcC1OmZXd7xvmr8U3BryxONvGtKoT/t
         fS1sd/ikmDkXEM68GPjtrNlyvVKYNme+suS3tuH+T2z/L9KxH917h/CAmicozXdDkWbQ
         Wxrig4GQtk2dLcmiqsJaTdK6YM21FFoZoFxHLC7Xl/WKBB+J0WyZ8uo+yb/vYkHduHkW
         98yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760048216; x=1760653016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ouGIZ18YYsl/9GqodU9OqB8J+uPEhuPrGCcLgx0Wyc=;
        b=n2WJbaJS3DdqfSJK7mcHkNROrYvgE/vWS/fAdkGGu8gdo/aBSfJwZzY41GJubXtoKB
         HXQjKpESM6KPkNDC+KI8hXmps/ApBTYDKSgN6XJbALEABwMCgLHRGQG5RCOouchZGdPy
         RAq5yPxGBFEKGkgW+qOI/RyPnShQdh7SibzjVgaC5+zw+M316Dfsdt7dt979PPKXXFwQ
         IRl4pLvGtDAd7UcrD8HVEqfE6qkDLFLrXB1Kdl/LwcWQneJDsSGqudnldoAVacqGD5pk
         o5XBPe5UaJTJLmf2XCrFw52hB936PyKIx236C08XJfnkyiJ3+5uepdgsfNWGa5L5d6AV
         PPLw==
X-Forwarded-Encrypted: i=1; AJvYcCUN43UnqW3ygXjL1YZl4hqnH8PWFmSsIUPCoyTHHVONbIBg//y/F1vq7ymWl1PixgJUJeIZYK4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjziBFxz9DvDek3t35k4TnGHY3vjZSifGMrGUImEXalbTN8r6y
	C+f4XQkfbZFaZ4/cE+ZAsy8G7C3k7N1dU9hGdjz41gsQOae3ws9smxRbMSGWLMhjmLxFG4WWVRj
	fYrp86lo+0FfxeMHluzWQQpI6tA==
X-Google-Smtp-Source: AGHT+IEwKuAuCigrDNWiN+req1c5yFRzIFngZTOobnjj5hIhTotLZtUDLz/dT57kmfJHlodJGDgMWM9ut0fHatowOQ==
X-Received: from pjwd3.prod.google.com ([2002:a17:90a:d3c3:b0:327:c20a:364])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1e0d:b0:32e:a4d:41cb with SMTP id 98e67ed59e1d1-33b511174afmr11693801a91.1.1760048215831;
 Thu, 09 Oct 2025 15:16:55 -0700 (PDT)
Date: Thu, 09 Oct 2025 15:16:54 -0700
In-Reply-To: <20251007221420.344669-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-5-seanjc@google.com>
Message-ID: <diqzldljhga1.fsf@google.com>
Subject: Re: [PATCH v12 04/12] KVM: guest_memfd: Add slab-allocated inode cache
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> From: Shivank Garg <shivankg@amd.com>
>
> Add a dedicated gmem_inode structure and a slab-allocateda inode cache for

Stray 'a' in slab-allocateda here!

> guest memory backing, similar to how shmem handles inodes.
>
> This adds the necessary allocation/destruction functions and prepares
> for upcoming guest_memfd NUMA policy support changes.  Using a dedicated
> structure will also allow for additional cleanups, e.g. to track flags in
> gmem_inode instead of i_private.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> [sean: s/kvm_gmem_inode_info/gmem_inode, name init_once()]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> [...snip...]
> 
