Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B1044E04A
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 19:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784922742; cv=none; b=TkwGsRUWPnUgsZOmARPmHBXFWuPWAFHAOjP7rs6IU2z1GvS9+JuVTQjxcg66dYzuB05SjUXSFn7vSFJ+x3CtqBONKx/vENtdq5q9sq4eAF9llKr8pRiyYAj13Yate2/QyjcsH8RhQ08+FO9KhGWYTuDOd8N7ZjXiYAcHR0KciZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784922742; c=relaxed/simple;
	bh=A7EEfHCXDQhZbZc+7PwL7H/hPx0GPYjU++n5dKG0w1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sQnUDhkfw7MPDniTspW/zCeKKBKNa3Mo43YkP16uIavZVVIINTVaoG21Os4oVaSqDjVBvxYFm8dLyPWulom4ZKKJsSe0s9zWH3/lBGRhlCZFcR4VSNQ8Y45FMlR714I4V2mxO30ViagMIWdL8Pqf792p5Ack1rXZuD8gV8Xmv/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VcM/1RcZ; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VcM/1RcZ"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb74d5db64eso823486a12.2
        for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 12:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784922741; x=1785527541; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UIrEUXeMwkKPn3AMJe5EPVmRwSj/wiphCk2WS28J/Pk=;
        b=VcM/1RcZKhYOdyrZLHsfjA+jQr2/GEbByyrV5UCkUifj+LjR/tiHIWqJHJbChD3+vC
         rzlJfqqM1bFdP0BKCG/QbpdG25/PGNOtVgIPp8LwZAl/DRhU4oakSnX5JCBR63PCxV9q
         HoiXU1qjRHRxCeKDvzQvL8hwLJf8ahDoWMZYkxJdeHzxI4Mw0Z+yL/dCY8QPFDW/Zc5H
         pvtkpfcJk/TVYbwWNYab1sETp0bLNyiuXp4Z5mp+mS7es2pYgZMKXQGKshUM06JQ4m+Q
         CgSNzRKyS/HMLkHyHFJrpmkmM4MQ5QhxHHsMJGsGC+58CbLD5KpetsfOnQQapO1bGXBq
         1KAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784922741; x=1785527541;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UIrEUXeMwkKPn3AMJe5EPVmRwSj/wiphCk2WS28J/Pk=;
        b=MgkMz+wPRmd9+Dbj9BtheyoA0r2GmEQPa0xzlkXj5uyoiLifu9YQjORIra5xDJX1rh
         G1AWorv1JtERlxJw5S/2mD+0ZISrBoQjsT+HmDWobL5q+zM4l2Euey2Y1mAGR4YglffG
         JPtTbA/RLnOeyZNAJEI9SjSwFFxTx59jmwzDOCRDhsuFrk4NlzNadSS3vucwUr8sVnyQ
         EJ+iayqGl8D43UIEiKJT71hJ6gW+c9xcIzE1jaO/C9cFB4BaY320GAXol8MBf3v4SIMR
         4eRMAIUGYt+lX5FdgxxWVoZhXObp3PygF3j7aqjcj0oLNKQAheFlo7uRNsTORmP33nSU
         tDbg==
X-Forwarded-Encrypted: i=1; AHgh+RqzVi7OtiIcqg99eUKtNvVFBE8Tvo5m3P9mNKpa6OL4Sb1/jQ8BXibCGr0IP0m5AIjJ9NNiYXY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywz8g9RMSqa2bh1O7rgMvO9BaCjhLd+8a3i1whITZR85d4/T19F
	AOajRaaMDcsPEzk1gDwFp/miNEHwAmCpUE95Gc6M1wXNd0qxQoNkzjc7eUE1QlnBnhtrIm5KbGd
	8EN/H2Q==
X-Received: from pgvf24.prod.google.com ([2002:a65:6298:0:b0:cbb:9724:6775])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e0a2:b0:3bf:e2dc:bc85
 with SMTP id adf61e73a8af0-3c44b1ca809mr9783772637.40.1784922740833; Fri, 24
 Jul 2026 12:52:20 -0700 (PDT)
Date: Fri, 24 Jul 2026 12:52:20 -0700
In-Reply-To: <20260714160411.302386-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260714160411.302386-1-alexandru.elisei@arm.com>
Message-ID: <amPCdAswlk24Xilf@google.com>
Subject: Re: [PATCH v2] KVM: Ignore MMU notifiers for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	david.hildenbrand@arm.com, mark.rutland@arm.com, ackerleytng@google.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 14, 2026, Alexandru Elisei wrote:
> +	 * TODO: Skip gmem-only memslots on mmu_notifier events entirely, once
> +	 * gfn_to_pfn_cache is also wired up to directly pull from guest_memfd.

So it turns out we need to solve a very related problem[*], thanks to commit
b9220d32799a ("KVM: x86/xen: allow shared_info to be mapped by fixed HVA"),
which as it says, allows populating gfn_to_pfn_cache directly with an HVA, i.e.
without a memslot.

My not-yet-tested solution for that mess is to give gfn_to_pfn_cache its own
invalidation sequence, at which point there shouldn't be a need to process
gmem-only memslots just for gfn_to_pfn_cache, because it will already be equipped
to handle memslot-less invalidation.

Given how simple this change *should* be, I'm going to put this patch on the
backburner for now, and then assuming my proposed change actually works, I'll
grab your original change (or more likely, re-post it as the last patch in the
series weans gfn_to_pfn_cache off mmu_invalidate_seq).

It'll probably take me a few weeks to circle back to this, as I finally crawled
out from underneath a pile of urgent and am just now getting back into review
mode, but this is fairly high on my todo list, so with luck we might still squeeze
this into 7.3.

[*] https://lore.kernel.org/all/aj2hi-NcqUUCaoQF@google.com
