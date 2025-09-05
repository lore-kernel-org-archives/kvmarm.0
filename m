Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CB1DF71
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 07:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757057885; cv=none; b=ppCFRoDwdRtNoKBwLn1NcHrKGCe8iumqDW+RI72hBFz2t89Wm9hmqCzPhB69oL/qyQVjeHhOHwaoS4sc1Rxwlvxy8s1mICbvZefetmgYgEquxV0trcxOa50qZdrPowuRazTKarHIBDEEpN786iay4hkPNj2KGXoTG+s8zmxXJsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757057885; c=relaxed/simple;
	bh=2/my/Ql9o8nPnoXRWfJgugmukVXNPoReFH8GbllR+XE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLLR/nPQAkv5WNTU85C9OP44dyrt3AkN/vWqV+QNqzoaeo8Z7E+cgGIMghlpYwjVXhwRgGIfPV1TUtA2BKhwrCCvClWWj7oMAAWGCnlpxw5cUjg/KPznnHVPNsAhkZjg8mCb1oGXMM3qmO5PmgAR89PCqyqbKDbN6Mb3GR0QWgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xFxorx+y; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xFxorx+y"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-720f0dd2809so9908226d6.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Sep 2025 00:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757057882; x=1757662682; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/my/Ql9o8nPnoXRWfJgugmukVXNPoReFH8GbllR+XE=;
        b=xFxorx+yp2r3OF60ZKa+O5cihQLeE62s4fkMCbtGFwnvMRaDlWlDIwKrewwCEYkaMX
         euQ9qRXKK+VUVvgdj61LDWsgQKImGz9sxj3fNDkbGDxkJEjRkwnVZSxewBVvzCUS+dr4
         vI53nDprNMv/n9Z4qqAPl0FR1OxmFDeUqLAc2yZOJhxsJGgsCNNKDHnzf9spcNOT0mD/
         8zG1j45XzklwWlw8yRWiSS9EvkSJ7sEZkryafTcxzNhrhTubpWdlczXIb3mqXWBmiCX+
         q0rgEfFq3XwWWMLvW5MVkax1UiigRKrto6jWFZgcKpcaeEM6iF3YMFnTChA5aHdLQ3XF
         koYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757057882; x=1757662682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/my/Ql9o8nPnoXRWfJgugmukVXNPoReFH8GbllR+XE=;
        b=WkWk+A2O28B7uPfxHVLcuFsejjEeR594w2b9oALyoUhNRleF4EgyYZTpXEKszxGx4E
         V6gCx/PCthsdTUZKLEEYWiiHgH64NxYWHqyEtxm/2pfs9c4ZGO16jttrDbKkfLp3W04H
         jHQrzVRKl6EAL/w8mPyOdTlt/yz6JwsX7Gb09V4Hmpssb8CO5Hf/Tzhol4+2LqoTNHG1
         VBGKe1KYcAcxB+30dE+hiSB6XNeug+s7tWApjJ60tr4LQ9O+15xTpZQOczgvIY0fkebf
         cFl3aANpke9MKqIzOUTyoRt3u6UuJGBdqm5ktR6FBt2qjefGlOIhu836HXoorQD8LCXu
         jJMA==
X-Forwarded-Encrypted: i=1; AJvYcCVbVYR546PVPTpknPBpH8wEY6rorTuLHKkkzgjEYvCWg/HgYd/NsQgucWW6V6+qdlfKo2n4VN0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIsloj9wPmPWlmGGVMHKtSnkYwNkJERvSjzIzDYYqFG7r/S8ID
	0+X0p9IPl/aHrZfDkOPtb4wLPxuoEI2AnSC9U8S5neTAPczQjcpE4zEyP33U6a9bA9fQulXnTke
	9U+9jYX0JeYIzOEviFfC2kpcntbE3FRtn3kf4/ox2
X-Gm-Gg: ASbGnctf1ulk1mZtqQlp0WIwPkxNXzwb6+8BU0b+DbuJuA+3IKGqkzuG+54vG9Ini/S
	XKV9ANYK8o0NbkE0kZqG20Cz8DTxoemvhuwFbt9QfWxYfvOmOaB3N92qC3C6n851nQzja4Tqz/y
	y66KSW7V6vnJTLHNMFUsIut1KLWM4d2/gN1brRcJ5SkILsJfpDqf4/CQjenEuOChn6Y3xjSkkG0
	+Pjgr0/y67VDElbJbc4Wp4AdDtpWbsaGga5gLDfZ/y5epFMDjkepiYDH8u1VXHGeA==
X-Google-Smtp-Source: AGHT+IFE09o3zvwFit1z+V+NTJ1W2r8nA7pHITHbk+kAV4bsQCI3NxyvXXEch3sDbY+dR8RXfjhjay6jPuMf6SYHGSM=
X-Received: by 2002:a05:6214:130e:b0:720:4a66:d3e3 with SMTP id
 6a1803df08f44-7204a66dec4mr108057196d6.22.1757057882205; Fri, 05 Sep 2025
 00:38:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250904101746.275795-1-oliver.upton@linux.dev> <87seh1z77s.wl-maz@kernel.org>
In-Reply-To: <87seh1z77s.wl-maz@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 5 Sep 2025 09:37:25 +0200
X-Gm-Features: Ac12FXxQPoUcREfxLO7az-YhOj238tT0MVyHkpwaSqXdWgPbs2_1ZZeB3kv-hAY
Message-ID: <CAG_fn=XOcO83S6663vnPgYgs1i1mUg7463dfW1KS4AdFOnyrvQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Only free fully unmapped tables in stage2_free_walker()
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 9:32=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 04 Sep 2025 11:17:46 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > syzkaller caught a terminal use-after-free in the free walker resulting
> > from a premature put_page() on a partially unmapped page table.
> > Previously KVM performed a single walk covering the entire IPA space,
> > but now that the range of the walk is up to KVM_PGTABLE_MIN_BLOCK_LEVEL
> > worth of memory it is possibly to only partially free a table.
> >
> > Fix it by only dropping the table reference if the page count of the
> > table is 1 (i.e. no longer contains valid PTEs).
> >
> > Fixes: e9abe311f356 ("KVM: arm64: Reschedule as needed when destroying =
the stage-2 page-tables")
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
