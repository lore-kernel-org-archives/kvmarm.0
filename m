Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39E33BA220
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 22:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786402703; cv=none; b=B6YGNAK+ciHfYqUUAQOLDUDi9X/QfEIlNzY5rEQLdBBWjYuDafSj/uxM9+DIZwSX2e6bMff2h55brAPljOk9surAaXhcI4wNa8SuetzQdzPxEVVZEQmNNDGDIrYrWTAXWO4ANUoQnjux6bve1CKcCUizoImxPTlooO2fV+s3E6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786402703; c=relaxed/simple;
	bh=CFuIJ7Uu9OrHMxjTOKTqmRsJbmdzzsMA0Hirgq5XFeY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=plmWKRM5q9brSMmuOex6E+HI6s1rFPT0eAIgc2VsH403wWEDBLzDZZ/QdyGx7iiOQ0Y70kHsB+Fg7nodC90G+4GAhjjJSuV9ztiGp7IBM3TOdVjYTT4MI82IJtUMZ6C6y7UwOOfjzsc7jVJ5bbchyuGM0jL088OS4I5Wr4aTq5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPIKD7m9; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPIKD7m9"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso2348195a91.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 15:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786402701; x=1787007501; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Mn9WKaRVsVTpGaOSKTBrlWB9M3O9fuL04U/nAsMmiI=;
        b=PPIKD7m9GYHhyHrIiS/2hhkSnihk/WzEW6fjwfuuqq0mtCGKJPzlZ+Ij0mogTeq4wy
         f8ZwLXgXmsPmsHGgnVj/BQ83pFzTBKXE8sAAOM5dii67B3e+8f4eLZdP1XPH/Ml5Cf7j
         EXMyxABLrEHISO3IpXB9jVDBHAsmBq4yoXmwctR3uJEn41GXhq83Is6CY5fJY5/4xnes
         DLIVzz8S3uGs5zjYMbc3OpdiJz/vAMcISC8Ga7jTvLH2p/486CAowods4ch10nNaPl2n
         Sf1iIEbQzmMjNCyyEU8M44X/48bJXzJ45dqVM7ltANDHdGRUu88Twar6y3WiNPwQckES
         RcNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786402701; x=1787007501;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Mn9WKaRVsVTpGaOSKTBrlWB9M3O9fuL04U/nAsMmiI=;
        b=UgqcgRKidiNUIKNHupVu/CSSiv/hF0+T0CVOGnqICoyrScDP98kIL4nk2oiKN4wAv7
         rtpH2COtJIUBommIYlrx7jaHF5bxndZNDA1eyDZgoWrDRuL9ciX1nm1cQYuC+LbgMQlH
         FpzbTfWX5nu/moGUSRlMvpfAYuTQEBhA1oRbdNC68bpazPcaR4TNGqZ+dHXlcEO2fonJ
         6NELifJoe7jSAirVfZ2DbrFwYbXs1H9gknxciBSJFDZ7S+N4LmXq0qDXjXJTw0m0/Dl2
         Ug9Hd8jeEY1hLSVZub6hB7E5MpQYS9tF3QObMA68o2cvNjcA6rCQN6wyz7P7IuiVGpLm
         5s7w==
X-Forwarded-Encrypted: i=1; AHgh+RrEucokKiOhJSvccfSn6QGLWeMbW3/jGpHZQ7unrJ4E059TdNUWpKhtXTvAlgy1JaI/YWKKSjg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGcdzk2/Xzmtc1v6bzyGMQqLBxEEaKsCFMaA+IaLEsVNhmjJhR
	xzSZYhZVEgCgcnv+d4XINqehfPOOWOGHr6sMPzE159eRc1nDs55L6a6KSSkt+iZ9fWjDtucyDp7
	Xqujh6g==
X-Received: from pjse9.prod.google.com ([2002:a17:90a:77c9:b0:384:934b:9128])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:590e:b0:38e:6a44:671b
 with SMTP id 98e67ed59e1d1-3909d301d9cmr33802476a91.0.1786402700758; Mon, 10
 Aug 2026 15:58:20 -0700 (PDT)
Date: Mon, 10 Aug 2026 15:58:20 -0700
In-Reply-To: <20260728121138.1103610-2-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-2-tarunsahu@google.com>
Message-ID: <anpXjM_lg_UTpl0q@google.com>
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
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
> Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
> enables live update support for KVM guest_memfd files, enabling
> guest_memfd-backed memory preservation across kernel upgrades.
> 
> Currently this support only guest_memfd files that are full-shared
> (INIT_SHARED and no support for private_mem).

Why?  Specifically, why do we need/want a separate Kconfig for guest_memfd
liveupdate versus KVM liveupdate?  I can _maybe_ see a KVM-wide Kconfig, but
even that seems like a stretch given that (AFAIK) hypervisors are the one and
only use-case for liveupdate.
