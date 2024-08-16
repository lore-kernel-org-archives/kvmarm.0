Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA9C10E4
	for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 20:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841836; cv=none; b=eL1hC7NY9M3BnT7RtEehcVF9TNbgXHDGoBApU5vuIa9P8t2cpeLtPXYpTnq5FNUutEgLC7WSkIWW/ow20/AI43MhcehP25ppx4gp8oxICxXhBpEd+/Voj18FQB5JMXIDf6W1q5hAOH8EoYHOjSphV8E3Us47a0kcr9HVzCiwHwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841836; c=relaxed/simple;
	bh=RBEJ+RmDihoYqO8IB9EiZNepAbBIDt2a1lRtlREGuc4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F/J7pVirrflkrbTLrL4SNbq5PU8/uKIxcqT8h4gooVTV3nnGczqug0lD+0fivU1KVrrZDicklGVNymrS6CySGo1FGxEHxtzeunbxhW14ioLCYQOTdZXHJ3jZbHbF0gIYJ+eugE4tUhGi/QF0+81xh9jR4e7BgsuAI/evTPvBD7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C4Jv0wiI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C4Jv0wiI"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a2a04c79b6so2683910a12.0
        for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 13:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723841834; x=1724446634; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ITzWFu2l2gIOubWBntrWLN53RX2KMrpIXb4EIawwVe4=;
        b=C4Jv0wiI/vynA0bfqLEbY46MYvmrwCoIvl6+Lxwsy5QFC+1loEygdb6oYhf1J6gDq5
         l6ht8R69xU8Ob4ddJ3mKO2TOXwLeTjYWtwAUv2dV17G7YatH2oNOJ9blUaG8CniMHCZ4
         acP50sVyBVHQ1UZSp0KMrNMkjmSyuNlaoyGXtI7OXAQLOm6IjsVCBxtJDGwpjL7NPW3m
         zXq+4sTzMckmnpwLC+x1DEyEut/yDnpQrAPUFqXFYDBR+aMKs6yw/5rRkbu4NOatg17+
         oaJhdGq0GIHqOd9wDpFNxrngbbC1Q7ySuqLAOkZnpus/pSU0f5sQ/1h6JkMV/XzIgkrF
         KyZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841834; x=1724446634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITzWFu2l2gIOubWBntrWLN53RX2KMrpIXb4EIawwVe4=;
        b=iRBVw0NslFztQ7p5ilq3r8go9zwWxvuCqeic7V7fFeVW8JpfWbFpq0ynQHZggLRJWO
         XuUIoFkYtHzKSUFXrH15Fx0vWKHnAn2JmSjfS2WHjLsIhoZ+PlsGxv+NXbWcaaSYDkmu
         Os1R+y2LFlrLzVQ3p+DWKLhYvhyr1cDn5mv0ZHcTgRCVW6q4eHAchtPny1qMiKRlbs+i
         +s3H/f+brYLxThL0ODmBTmgQVczL3FXSmrtosvU50y3jnZhknrLl4VSVArCTpSH/strU
         hFdNgBZ5qPvXA2i8CZqVUu3Yq6uYgj/a3ISjigkyiAf/A99gxE8k/0LuuuSTOXPugKxl
         picQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoRFFH5ndBYM84f7y5XRv97EUeVBRGb49JyT4topGfTho+sR+pvdbjWA4VduIxiYm6uQLW5C6jo2n1jtKgUKyfXjthWft3
X-Gm-Message-State: AOJu0YzVrhUSG4UOhBA/86l1mjNltYb6jxjkmw08dQLX9PoaabcIl57c
	kBAOcx1seL7h13xkOxh07Q1TLK5jW5HFbjz1KRSGYkvV4dpQEQOl7BY6wQp0q2RgQxk4xmK2VGT
	HbA==
X-Google-Smtp-Source: AGHT+IEQfYawzH1OLXUwwk7EQAKtqFGys4076yqyg7VRWC3gn64VBhuYN9Gdm8xtcwxQcEVyIscKrTCr4vg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b7c5:b0:1fb:f1f:19ea with SMTP id
 d9443c01a7336-201ee49bfd7mr280315ad.1.1723841834095; Fri, 16 Aug 2024
 13:57:14 -0700 (PDT)
Date: Fri, 16 Aug 2024 13:57:12 -0700
In-Reply-To: <20240809205158.1340255-3-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com> <20240809205158.1340255-3-amoorthy@google.com>
Message-ID: <Zr-9KOvcWK6XtA3i@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2
 fault handler EFAULTs
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 09, 2024, Anish Moorthy wrote:
> Right now userspace just gets a bare EFAULT when the stage-2 fault
> handler fails to fault in the relevant page. Set up a memory fault exit
> when this happens, which at the very least eases debugging and might
> also let userspace decide on/take some specific action other than
> crashing the VM.

Heh, most of the way there (from my hack-a-patch response), just need to add
the KVM_BUG_ON() + -EIO conversions.

Can you send x86 and arm64 as separate series for v3?  E.g. for x86, just this
patch and the -EIO changes.  I'm pretty sure the docs updates can go in the arm64
series (I need to send another response to that patch).
