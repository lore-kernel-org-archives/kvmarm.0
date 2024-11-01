Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C8D450E2
	for <kvmarm@lists.linux.dev>; Fri,  1 Nov 2024 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730478670; cv=none; b=f66H1l3f9rPtzw1TN9fsf0Do2gmp/COFtpyZmLdEjcNj7DpR8nOtg9Gtp6bqAEceTv3Vh64+afoUoBcgpMCNwFj54dtOfLhZcGIjaMlepZ76J+8wN/wtrzkcEmSOcafyBBW+jPd76lt4H1xs3BC3/IO53GXMhFuBU3ct9PRvk1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730478670; c=relaxed/simple;
	bh=aCYFBS0OlRXeeN66mv6hk1AzePNNwIISd3kE5LOhZGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IF6/XRgnef5V8HICXxT4j6cOo7Ju03ftdAv1afW8m3hqU+giJrUGdyT44IJ2dFsHtVLUhnrQSFFQwyj9luNr85/aPqLGUbqOAkEswxUtY3ARvVDX/09n2xHx6UH9XcYqdYRBxTGKq7OlrB0ueIVqXjWZC8wQXKBjBxwamc7P7jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4ZlKyX4E; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4ZlKyX4E"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30cf48435fso4138559276.0
        for <kvmarm@lists.linux.dev>; Fri, 01 Nov 2024 09:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730478667; x=1731083467; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QUMHVY5Pc5ujaPIETtg1OV7OoMZH/DlrlEhMasUvFWg=;
        b=4ZlKyX4EZki6V5yjV/lBSsD6lSvVfJzVANr7swHMnWLLuZU8Zy6UpWGUbZ+WMUqy1n
         2JATYk2vlh3dVLN271CCxFhlOUwGNonx1aGqe4m6t5iV1BfW7WqiChIvsxPijIvSjNYt
         D2ZWAhh6Sd7s42nLtrGygPUlbERevj7lOvLMxJWUAEzovO9TClChbschluzqa1777i45
         szWgyFeJj51tvkfbubhNcZuBZ32S4T+o7I7Z2F15fIvzoLs/cJVOhiO9TbKE2UQ4aky6
         m3GDx4iLCCUlvZNr1oZQpixqV96pAAGctMHqlZ+/3okhYUElxqQOnxcbr/UFfDxgBN+v
         nzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730478667; x=1731083467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QUMHVY5Pc5ujaPIETtg1OV7OoMZH/DlrlEhMasUvFWg=;
        b=Or75twdUeQfdmC7dEVFwy9yw4hZch3S2wrMJFCsmMXkIkOl/4sjjsz7GQn2NJqj35e
         Zcc+YBFDn4JD7HJb88QWBrHYjdzBeDMjI8Ndyn39KYmwK8IzRWpItiUvvBKuho7OdcKt
         fs3rE5o7XtPrGNbCibLwqTw6kr7kGRnqGLF9rbWGSs2gKaVPWYEl3xHSk9vJZeEpOYSw
         ifw8XoPmUpOfBxBvYrOgXqjWILttRwXmX2IVlZBqOxPUn6h76E28V9tuuwmvevQyGFDB
         eiW9S8FuFeVWSyyZb6FqdTjYhKgJRPAUQcJ69WSm9PUHDGefzL6JfuIZkREre9Bn0l05
         ZZhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVspr+fWOo8mxX2BSOID1plckO2QhqmHBQOBz3yD9FVmtvq+w9iLiViz7+s4D4jg7BRrmq1fSo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXimZnWBpvpSpGEXrh5+YCA8dUbpSQ06GmpB8XMv1sFTQMqKtk
	NOz5nmL02uC23bGF3742t5J3I+vkDsbX8AMrxVhCaR3OgLn9/x49m1PoW+irTMGv120gq8V9JLT
	NlQ==
X-Google-Smtp-Source: AGHT+IHjSky3TikiN5BvrlqT+n0lNdXJaonGgodvNxJp+r7LiGTo8fiUiA/fuWajhuo5hdeSs5DxJ2eOWac=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:c8c6:0:b0:e33:111b:c6a4 with SMTP id
 3f1490d57ef6-e33111bc836mr1008276.1.1730478667415; Fri, 01 Nov 2024 09:31:07
 -0700 (PDT)
Date: Fri, 1 Nov 2024 09:31:05 -0700
In-Reply-To: <ZyUARgGV4G6DOrRL@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <20241009154953.1073471-4-seanjc@google.com>
 <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk> <ZyTpwwm0s89iU9Pk@google.com>
 <ZyT2CB6zodtbWEI9@linux.dev> <ZyT61FF0-g8gKZfc@google.com>
 <ZyT9rSnLcDWkWoL_@linux.dev> <ZyT-6iCNlA1VSAV3@google.com> <ZyUARgGV4G6DOrRL@linux.dev>
Message-ID: <ZyUCSZEv4w1yXwEb@google.com>
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Oliver Upton wrote:
> On Fri, Nov 01, 2024 at 09:16:42AM -0700, Sean Christopherson wrote:
> > One thing I'll add to my workflow would be to do a local merge (and smoke test)
> > of linux-next into kvm-x86 next before pushing it out.  This isn't the only snafu
> > this cycle where such a sanity check would have saved me and others a bit of pain.
> 
> Eh, shit happens, that's what -next is for :)

Heh, but I also don't actually test -next, which was another snafu (not my fault
this time!) from this cycle[*].  Testing 6.12-next prior to the merge window
wouldn't have made that any less painful to bisect, but I think it would at least
have allowed me to detect that the issue specifically came in from linux-next,
and the bug report would have gotten to PeterZ almost two months earlier.

https://lore.kernel.org/all/ZwdA0sbA2tJA3IKh@google.com
