Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271849;
	b=uhUquqwg/XqHBnFt5Nnr3CHaDGlQICqnEZ4kBYebswTzrp41dOL124uhwKc6W+21XgR4
	 Ectz/aEp4mO/Zopt69jW/3Xkp26s2rDeFNvQ0Bz+BgQpgQQBMvXaWyNraSpZbH3VXnle6
	 BTsmYAoOsH6uV1nFq/kwN1x5efSPkp9hPaRj9XmHMSH6IO54fI4aQd+llXjOCJCnIZ7Lm
	 AMeUT2l+UlxVuCvvmxyJ0FIAmUDwOCOf/WkluA4bG4eEKLn04meUdLMvmqesN9EGUoboV
	 mxKik2KLPjIu7fB9Cx0IbVWXH87O4y+SImy8fgwbGlaHMRzwO3tLQiN5tGvTqrYt9lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271849;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=9aUmjjXy2UpFvwIaZx+Kc6emVkBoaRCWFUjyBYUuXe4=;
	b=MK3yNPNgpDbMJrAuj8hghAkCSVwz1PQ6wcrDfMxjyPHTIWLZqcoyQ8epfxsLFKl8/Nxe
	 MONP+Bx89t8q06qb7WI3iX27n8knRGEZiWezIaP7rwTIRVcJowPkwMnHovQW1xKhAv4WJ
	 QharBViBXzG7t1fjW0dhkNuqWktzHLYhwUqnFoKaBQFd5r1YCLovvGRXQ+BYr/P5LaMTK
	 vz4TT8mKUde/bDLFCJxDBxFbjGZGi4E1x46yAsWGVs6TxfXYY2Lm9sHwpI/Zvx/8nnKj4
	 FgScEhrE63pAyDZP7/Lq/IpE04IrUTDfJa6S8fFKJ0qj9e6gsTJoD7E1PKPblZTeaDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QU4jmP1B;
	arc=none smtp.remote-ip=209.85.215.197
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBE8606A321
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 00:50:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DBE8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QU4jmP1B
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cdaf2073b0cso862475a12.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 16:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794271848; x=1794876648; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9aUmjjXy2UpFvwIaZx+Kc6emVkBoaRCWFUjyBYUuXe4=;
        b=QU4jmP1Bqf61aPqP1gr2ByMn8da7sRJliVIgskiBaon4HwUXHA/JgbDXeQImU/CiM8
         faBmvo062OEkJegSL/+FLnxLknfbIcT5HlbrnHrMlQ9Vpxn/3oRM52vZLmXBmGK4A1nq
         GZxGBDZNqgAH0TI7ODgJKbHKdR1OVNG7AtzaGWvkVDzEBiLzKN7wFdQihmdan6DrlAc0
         0KCjtXBiblWskm31Np91wWLfvBc9ZgGgmPanunbePAm1HpOGxtEu9ofShIcm4yQj8lps
         V0zZ8EBnoT4+9rQz6afWtOyw6hkVGokwqCbfMdyvac04Onp4cDSH1bBC9zXDaH8Swb7X
         SV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794271848; x=1794876648;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9aUmjjXy2UpFvwIaZx+Kc6emVkBoaRCWFUjyBYUuXe4=;
        b=E3astq6gnFXDNc1mXUeEOueTUDc5s5BRKVF8tvEbunBzRbN0WRWQPU/tQBl91jWw5e
         a5OxUcb0diQAd5WC4PzCUNivbvdzVDCBuQ10EuHXaLEZJmvDNxYC1n2aa2qt7Czr4JEi
         NA4CB02R8zGPTVirTW4hRN7oCsmKNCxKGJcJ2H8vb8zTwXLttb/DLPnJxHjscnR6jz37
         I52MVytc2hBi/xfASM3Ls7skjqxJqNCxWF10JIDrdaBg63SxX1jiPpU/Gb1qAvNp93D9
         OHy/D+qLjLqLPfOpx69ar5tbVev7A7dzP8/v2oz4viUJ3qN6HEVyhISwTsS6wrzRFPHD
         ssTA==
X-Forwarded-Encrypted: i=1; AL+hErG7DM+ujHiW+2Vun9b22fUGyjlRxqtCVBpQOE5x6bixC5KVQ1SGSlbHZULw6yHcYPDx47lMrqA=@lists.linux.dev
X-Gm-Message-State: APuU4Z8Ae/ruQLYw1hUwucVAXYG8vWIMvr7umD5xpRZM/Mml5s5dsaZd
	Lh2aJdBCiuzn8qNeW6iuUG6pqBCZYJp4HRmS5r8pQzAuZjkPMhW7Y16vxnBet4Wu+Px8kavVUXm
	/A5DGmw==
X-Received: from pjdq9.prod.google.com ([2002:a17:90a:2e09:b0:3ad:32d0:ca0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a48:b0:3ae:898e:a123
 with SMTP id 98e67ed59e1d1-3b166cd70c0mr1265220a91.14.1794271848067; Mon, 09
 Nov 2026 16:50:48 -0800 (PST)
Date: Mon, 9 Nov 2026 16:50:47 -0800
In-Reply-To: <CA+EHjTzaJx2nV_9YEExgYn7STSP1Kvhsqan8va8M7ba4WtCiqQ@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20260922071945.693714-1-fuad.tabba@linux.dev> <20261007074037.316564-1-fuad.tabba@linux.dev>
 <CA+EHjTzaJx2nV_9YEExgYn7STSP1Kvhsqan8va8M7ba4WtCiqQ@mail.gmail.com>
Message-ID: <avJqZzKX1ZVAMGr-@seanjc-mac.roam.internal>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Fix incremental build dependencies
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Michal =?utf-8?Q?Koutn=C3=BD?=" <mkoutny@suse.com>, James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 09, 2026, Fuad Tabba wrote:
> Hi Sean, Paolo,
> 
> Another gentle ping on this series. Is there anything else you'd like
> to see before it goes in?

I'll grab the KVM change, but I would prefer the cgroup change go through the
cgroup tree, even though Michal already acked it. AFAICT there are no dependencies,
and it really has nothing to do with KVM.
