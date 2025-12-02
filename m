Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6914248896
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764695402; cv=none; b=scaj5QScs06gfzFPNNwcI2BskpiiCcqQD1tcmaQIcpcRCHZJwfx6lLpkMJzh7yy/utfjfGkfVsnL6/f90m45xzCBfnnvFjyBegRNTUIW3zEDinNZIka7Acj5RZetPrfT2OqLxC7q7GoKEpr460Q1qjlRF/9nW/pGU1tmRUR5DsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764695402; c=relaxed/simple;
	bh=umTx2taCeC5963qb+wkytzIDyDWomHN2zHt2ismTJ6s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hFmN+yNj8w6/xxhOdx0nZNbtyxIcHSBC0LCP1TAbSzfQIKv3+77RDQHOh3LFcyaBq39Xs5CgYTezkjrJW1KfTAVmFKt5WjFIhMyp2HqU2DhCAiU7iQv4VnOrsJyNYwzL24td/S2EjqwodRy8eoi8U04azuPFVATuwWGdszwamUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U/Il14K0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U/Il14K0"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso6370097a91.3
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 09:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764695399; x=1765300199; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E5WJmQwtaiSGjdX3hvQ5G0fLkQaPiiuvbOSh5KLZb28=;
        b=U/Il14K0oMieDTVSfO/Fgc9q2AngxilcWWXbk8ROjTP6NnJeCenoPOuc6ZbaQ8K8Yo
         ec5nkiC458ab8GLsHJo1aHsAOw4bhvRu018knGqCtm8/R1qHpza130C/Ta+2BFPCa037
         kikhUADTIICduTJeMhcDM402mWERj3olibgqFs9LoD5mzZ5szOD47hyvIji/AbFExOPO
         ii/E5f3nPo/eo9isjXXc6Rydrksh2Dm06lWV1hLz50rGZi6dAbA6FUq/G7LaJmU1O4wJ
         SVDUbl22izA8wZvDo5cKEMzJPLNCEYfUxxD+9VoNth4qjudnjZPUQka8BIL3oTve6R60
         QYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764695399; x=1765300199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5WJmQwtaiSGjdX3hvQ5G0fLkQaPiiuvbOSh5KLZb28=;
        b=Ublp0DhuYZdmZE8ZV/VoiLqRAX34IHKGJraey/Pr36I86sTX9bbjrby72mCKcf/w9J
         rAeWSFxK4gkbRkZSV8jTTm80H+NthajPrVkdTsd2reHNZU1eEBxOK3SeasrYQ0wqQTrg
         6zRPfMpMppvUUkNqPEm6LTEQm24D4SDsuIIAsv9R5ePzDe2NQ3xaPhmszH3fXaEKdN7P
         eN6P+VElC4AvfNStRt++eJpG2DYJheIZMwaUpCGL8iCWBsWdyikjNyjpGwfrcsr6rwgc
         ZsR0wK1PVpN7MeXJcDIa2+FBkTyYlDyDR0c4FhIEVtD7J5duyL/rsS9LTTJbtHUHa2jy
         5nXw==
X-Forwarded-Encrypted: i=1; AJvYcCUjEuudENIWRA8wJ8CQIkht5CvhgIYuEwgU8Pp6AmSJF8ZzYVLFuHCHzDqjuEL6gGzzLhldu6Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YyP0Nlqt48qygshcBevwBhQ/ZSMLvwVyCChMfXBHOHfSZTxr1rZ
	90bK126q0Kiq5etXuQOoxqER8lQVuE4taP4PYwYROW04OSX/sCxj9oRtGDraDn+Aq0ZmJz6Dzge
	57RHKJw==
X-Google-Smtp-Source: AGHT+IF/Endm213qEFcUNzAd2NTgktVOwQl4jMK+4bmG2i5epcnkPYvc/1IUDYusSfDWawT+jd3lEpUj2Bs=
X-Received: from pjbta16.prod.google.com ([2002:a17:90b:4ed0:b0:345:b608:e5b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b41:b0:33f:f22c:8602
 with SMTP id 98e67ed59e1d1-3475ed6ac44mr30324034a91.26.1764695399033; Tue, 02
 Dec 2025 09:09:59 -0800 (PST)
Date: Tue,  2 Dec 2025 09:05:12 -0800
In-Reply-To: <20251124050427.1924591-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251124050427.1924591-1-gshan@redhat.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <176469500942.1209959.4892875353793397176.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix core dump in rseq_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev, 
	Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org, 
	shan.gavin@gmail.com
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Nov 2025 15:04:27 +1000, Gavin Shan wrote:
> In commit 0297cdc12a87 ("KVM: selftests: Add option to rseq test to
> override /dev/cpu_dma_latency"), a 'break' is missed before the option
> 'l' in the argument parsing loop, which leads to an unexpected core
> dump in atoi_paranoid(). It tries to get the latency from non-existent
> argument.
> 
>   host$ ./rseq_test -u
>   Random seed: 0x6b8b4567
>   Segmentation fault (core dumped)
> 
> [...]

Applied to kvm-x86 fixes, with a massaged shortlog.  FWIW, I'm planning on
sending Paolo a fixes pull request later this week, so this should make it
into 6.19-rc1.

[1/1] KVM: selftests: Add missing "break" in rseq_test's param parsing
      https://github.com/kvm-x86/linux/commit/1b9439c933b5

--
https://github.com/kvm-x86/linux/tree/next
