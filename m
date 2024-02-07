Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB917FBA9
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707319863; cv=none; b=fNLZnrZ2lXyAKEBcxaIVMV+3swWFUp1bDqDrxHbPwJP/I2ZuXDW0uSrrKKKh7eFV6zORGNV4Wbpx7Lthn+Fr9jtRId+R7zmCpRlp9DY/BzmtHeMod9l0MGbj9608yEM5fyUn5tMNPkj17Kn2kyrFfHSqjpYZgypOtNEE1MJbRYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707319863; c=relaxed/simple;
	bh=DXNk6OLCxdYLiD+nZvI2CClPGNogd6p3e1cHGrPIvlk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MTzAX8/GBxTw86Md6tSIdOrZw4Vj4rCei5Bl++VO/l7wc8UH77GdVh6DDFj2KE79GCgSzHaoQjkvq4tTNeYhOtCpZEf7938XRI19HGBPN6hPrQNnTLQxgH4bcgWJseYv4p/0b53cZ/y5eSwr52jAsTD8QeP2++P89DJZT9kqDlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2I6cBXEQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2I6cBXEQ"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-604832bcbd0so15423337b3.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 07:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707319861; x=1707924661; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DXNk6OLCxdYLiD+nZvI2CClPGNogd6p3e1cHGrPIvlk=;
        b=2I6cBXEQfb7q+5+Dx/EXbKpt97qrEw/wvwf7HHix7K1TKrCrsY+sIyaePcbHrnZZ3v
         /ccYGmFS980GOgBLKk/bpyWT/ljmtcuEJMTiKXlfm3kxK1ryxzhOgYZ2/AVwMNd1bTeI
         rsorjidQltCKTHxDv81JBm65n1CAF5CWF98MeOPhSZDbLf5Exa8ywEA+hl73svD32U0/
         3IS+pzwzfatFKL+5Ziu5U5VRJArGA8vJrrw5nPftntb49q1GoVyuDxNvvQ0XvuCXTjmj
         agHMdwZeo+kbFvM8G8HGWCZtQvNn8NZODk0/6S++s+MpSMFvHNvZ5VjVjX3nda3PlSGm
         XQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707319861; x=1707924661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXNk6OLCxdYLiD+nZvI2CClPGNogd6p3e1cHGrPIvlk=;
        b=NByG9C23pEvY+uiVzDrIVhhOq0YXD/2oSXr0X+DStV1IonwwYdBGAqSxJTAi1iNyI4
         mwlkc1JcgjG9Aw4Fl2QdywB3LHi6uQrWm7HtAKsJ2BLg3tyHVrKkwoKsbTbh0TcCn7VG
         Qllf1OnM2glphhC7CHFEQF39KJv/jvyd7BMTFPvecWhxlMJ1Bs1denTO/S7j00Fi9GTl
         pDWtcBScbQcBvomRQJCjSUTHWADkTQaRNnExFEmbnlWEH7wiCGQZ79UxQaYBeXRtpuoo
         LMPMjBM70ayaJPffE7KrZTKpTGdDbNZWRqElnGN4fNMQ9wjyJnDb3z2dlglSE0PLrufp
         pHBA==
X-Gm-Message-State: AOJu0Yx+PmffdcPSTPf+J/mei1K/ulxHiUh9mXQK+b9oFY9u43ci/2W5
	LkF8e8FDGpLuMLAEqNRk+qR+o6RZOg5/Qg4laMIswDtiRJNzmf4TtNVNx6eRa7JJIGbbRkWlWxK
	Tyg==
X-Google-Smtp-Source: AGHT+IF2066JJ5rdaQrPAVjhJ1FNs2puYbStDr1fK8IH8VG65KD1vwXXvlajIrtd+RG7V1si+msMj40S8IE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b04:b0:dc2:398d:a671 with SMTP id
 eh4-20020a0569021b0400b00dc2398da671mr1279778ybb.10.1707319861064; Wed, 07
 Feb 2024 07:31:01 -0800 (PST)
Date: Wed, 7 Feb 2024 07:30:59 -0800
In-Reply-To: <20231109210325.3806151-5-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-5-amoorthy@google.com>
Message-ID: <ZcOiM4O-oPcZpeac@google.com>
Subject: Re: [PATCH v6 04/14] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT
 RWX flags to userspace
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, Anish Moorthy wrote:

Needs a changelog.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
