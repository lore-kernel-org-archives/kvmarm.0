Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023D217BB1A
	for <kvmarm@lists.linux.dev>; Mon, 29 Apr 2024 21:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714424578; cv=none; b=O5lROAmUaqOo+WdLGaxeyzao2B0x9WcWe8KoVEYWBBI7fgETr9YIu8O0uKzG7GJMqc3ie3bAMLpDCzX7TgZ3SnWZIdxHv6epohPkj20vGXc1i9og5mKB5LUl/yP/1T4l4TMo5z+oe0U5XWc4LLyr/TEbJN7ZnRCoEWf9e8ijCdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714424578; c=relaxed/simple;
	bh=PPVNvn0DIhv6FGN+XyDmmtWyNnzYHJ1RnYM4N8RhC9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=czstcZayDcmZG8FZeqaRUqlY9lziwNVTCm+onqBj70IbjySmRnPA+r9Nf4dMcj7pFzPEu/ib5bN6RuvljaNvUi+R94thmTdZS8U5JqxopFNUxKXLGzv40flY2hli+z9iW80XMrFiTKrSvfNpFzZ9hZS13VB6gVVjn88wD3bzBZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QrUIjiuw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QrUIjiuw"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a473ba0632so6015521a91.0
        for <kvmarm@lists.linux.dev>; Mon, 29 Apr 2024 14:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714424575; x=1715029375; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xw3vIJGY2NNuKaQ6MudNnqR6rpTRdltf5mCEUSFWvc4=;
        b=QrUIjiuwIqdlvSQ9Tc8e8yMjc9QG/jmUjrJWwneRKnWOh6z5AS3ZbwX30N/PTywgeS
         tW5CB7lQU1Z23rMQwLpm/8JhMS4OmBu465m7U9VbBm5PSYqOif4duyXt17BGTBQ9l7Y0
         uWOKsR/LOMFM6lYt1algt4h7FfcMXMT3iT1lQpL877mer2t77A5yJTClsKCaPzIkDsFd
         gI+n4YJ/Phtkzm6dQglPEyqDl62+J59wBFpL+Y0Qgz+RP5cG0euQF+MnJ038fUU9SLXQ
         OnyC+zUEMoOeJtv2nO7E2TdVY0oIYS1sovl8qvf+iaXuE2mnqlMKPNyU0I9/ACzIhynJ
         IufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714424575; x=1715029375;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xw3vIJGY2NNuKaQ6MudNnqR6rpTRdltf5mCEUSFWvc4=;
        b=oOnr4qNLP1CpjFHOwjM/UK4VkIx59gymu0N+m37cCsECnXAjsN7aQdYDlULtrPpfSt
         HAzFgkP9DDIaksrbkM6dGp4CIDjptftQOShaP4GSanuEF4GvvC5A/4cyYtIc9oC7h6By
         +URH6en2EEOleHBvex3tkJfrdgTIk5m2Yn0vEUSyT9sEPljlU5dVTAO9YeH1vSHUWhBV
         HRWspdpSJSx3IbYeeaQxKDx6jj0zrGbiB8nmOSWNVFyr9L2a7A54XJX2xW8NVivNyILE
         znHyVCZzzuGoakFkK/clPA7UTcb3AuH4VHWW8yfpeBXqywHPRv1KIxbpk97Ixabm4X+x
         gP0A==
X-Forwarded-Encrypted: i=1; AJvYcCXV8TqOwLQDKgSuMblAaDy1G7+QBbxMJArHVXxmm6xEx661FtRMjor313fo32+sgfPZUdYzbSZWrctujTLE8NEg2VuilBHL
X-Gm-Message-State: AOJu0Ywnn2dSB9K7zkk9giKvatEqemfpI5U2EHReFcCovxRH9EUE3YAO
	YE0HJMl1Ii/iaJ0LghNazCVzpoaqupT5JQ9ykJVqG4Lr8HKqZB1vb/hYz+YpkXuA+lrfgGeH/PF
	s5Q==
X-Google-Smtp-Source: AGHT+IFAPa05P5Phibajkpgu95FpzO3FVIMmtbzX/atvNPTvVmV0SeqoPEqwME76DtqNEjJ0m8ryHAcldiI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d509:b0:1eb:7b9:4f7d with SMTP id
 b9-20020a170902d50900b001eb07b94f7dmr971010plg.11.1714424575332; Mon, 29 Apr
 2024 14:02:55 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:45:25 -0700
In-Reply-To: <20240423190308.2883084-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423190308.2883084-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <171442341918.161544.2844726781684658994.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftest: Define _GNU_SOURCE for all selftests code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 23 Apr 2024 12:03:08 -0700, Sean Christopherson wrote:
> Define _GNU_SOURCE is the base CFLAGS instead of relying on selftests to
> manually #define _GNU_SOURCE, which is repetitive and error prone.  E.g.
> kselftest_harness.h requires _GNU_SOURCE for asprintf(), but if a selftest
> includes kvm_test_harness.h after stdio.h, the include guards result in
> the effective version of stdio.h consumed by kvm_test_harness.h not
> defining asprintf():
> 
> [...]

Applied to kvm-x86 selftests_utils, thanks!

[1/1] KVM: selftest: Define _GNU_SOURCE for all selftests code
      https://github.com/kvm-x86/linux/commit/730cfa45b5f4

--
https://github.com/kvm-x86/linux/tree/next
