Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBF32AF01
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 20:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713560125; cv=none; b=H6JFaHiWVxzQfzlDL171+mxvbv/vehnsmoNi0rNp3uL1df0vGaRm0x6CZvq0LKx2t7K+4Voir+77G/nIypXh6J8pfkNoWwa9hEZvvZzvgjKHGXdjhTTMwpVyNmw+CKIZofkLCnw6afFWlhymU1GIvi6gDa2vMa21zmknbrrp+RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713560125; c=relaxed/simple;
	bh=0GvM01Qlx5wuJBtCbl0XQHDADvYPFlcLL9+gjZzeNB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IU1+1qeEduNGIAjSOOB25MAKvgzplLgEKcIeonzM1LAwTu7To0k9krSt3fbX9Mwe5JvcmZeTZvFl0Rg6dEfqkgzREKdhLKITDUHAHnW2JVeI0deMqNV0cu3dVVhLvqelxNuBhM+aQ1NRmRcLk0aGTQX9r8SFYzAz9v1ycMlpIB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rz0AQcHT; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rz0AQcHT"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-434b5abbb0dso89401cf.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 13:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713560123; x=1714164923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnzzcopxYVakJwmdZOL+JC6KyzHciDKz/A3YbkmreBI=;
        b=Rz0AQcHTIPVs9SpwnsT6EDXPiXMdwg3oRJZWlJnd3EMrL0+Fc7G2m/II3iK6aX3gYQ
         cjX/xSvTaLcRL561FJUaaNvthTJCLUy8kJX0EhjZHAPvudaZFADwjQHGK2OUEqM2rCQQ
         ycGQ+3ZYvzdgbrEV26+szyd9kMfZD4MNERivxQq1qVVPhfL8xdqscCdVQpi/Zx6AZvCF
         zIY/ANqqI5mbsfMK/dZZnQU8L3tirMzVUtOTxBxXpRo0jFlZLmabDcjr2ljgsCevVUu6
         dJGgbRyIkiM5m2+q3T2ebnC59Y0sdEGrjAAzqYa7BOPnU1SY3diURpJw/JG3oi8FHKaw
         7apg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713560123; x=1714164923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AnzzcopxYVakJwmdZOL+JC6KyzHciDKz/A3YbkmreBI=;
        b=Xo8zkXyG9u0Yq9cTyVRZZn46ZmWXQzsZZRzR8dg+3qIvbiy3yLc0RVmd7ec7NKflaG
         lHteZek52OtuWydQbhgLu3ISpfGsINNpB8X0K4Ove7ozAMWp3aFWYrxHwNjHkkgYGGxm
         hUTONP00UHNJ+J8Qk0IIgENQn4J23+cCy6UHsGiAtO72iIJE0HUc2eB0VezFZKdb7Ymi
         QUW5Y8sw8XORjEaNF4V+aRW0FEuxO/bYWEM6AVaWtKDo6wOP6WM/aOvX+f8HsKvfxoeP
         jCPhmHAdsMXHxDBr9J0495O75gM35PQucYYdkYv80prjfvvrfcfqUNtZ3c/siKtTG6Mp
         GvLQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6jol3KAqi6Ihm0tbdTUTVGmKgQ66iF1by/UeEVybd+o7A5FzE86eqaR5LmQxwVZWGffERR1plOZbb7LXdmOf2v87JoXYB
X-Gm-Message-State: AOJu0Yw8bRRzWL1pUTm4X/If8mDVTyIHIWuTm/NAVdEq+Vkb18C8STnP
	v6GLGl2yhwU1DIM0oJt5Dslz1RkZjX7ax/DhoCm1e4OxcmovzQ9En5AucraCyiKO2hrWDdihk2h
	IOAg6dvuuX+ESg8u4OfVT7ibjW6ocWNq/QFlZ
X-Google-Smtp-Source: AGHT+IH9sSY76fFvumrBUCB5IOWf40dprm49al51d9C63r/bzJh0mJ4NGK5So9vqJF4lfC7MlLaL31EdoOvAUHGh1YY=
X-Received: by 2002:ac8:7357:0:b0:437:c52f:cd6a with SMTP id
 q23-20020ac87357000000b00437c52fcd6amr69580qtp.8.1713560123419; Fri, 19 Apr
 2024 13:55:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com> <ZhmdOb7lAd3DM5Tq@google.com>
In-Reply-To: <ZhmdOb7lAd3DM5Tq@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 19 Apr 2024 13:54:47 -0700
Message-ID: <CADrL8HWAzcq4N-triWiMvtpUKvb7C03+2mQpNBxV9Ci-F5GyBw@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 12, 2024 at 1:44=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2024-04-01 11:29 PM, James Houghton wrote:
> > Only handle the TDP MMU case for now. In other cases, if a bitmap was
> > not provided, fallback to the slowpath that takes mmu_lock, or, if a
> > bitmap was provided, inform the caller that the bitmap is unreliable.
>
> I think this patch will trigger a lockdep assert in
>
>   kvm_tdp_mmu_age_gfn_range
>     kvm_tdp_mmu_handle_gfn
>       for_each_tdp_mmu_root
>         __for_each_tdp_mmu_root
>           kvm_lockdep_assert_mmu_lock_held
>
> ... because it walks tdp_mmu_roots without holding mmu_lock.

Indeed, thanks. I'll make sure to build with CONFIG_LOCKDEP for the
future versions and check for errors.

>
> Yu's patch[1] added a lockless walk to the TDP MMU. We'd need something
> similar here and also update the comment above tdp_mmu_roots describing
> how tdp_mmu_roots can be read locklessly.

I'll add the macro / function to do the lockless walk of tdp_mmu_roots
and explain why it is safe. Thanks for pointing out this big mistake.

> [1] https://lore.kernel.org/kvmarm/ZItX64Bbx5vdjo9M@google.com/
