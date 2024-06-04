Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDC22119
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 00:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460590; cv=none; b=Ojm8iDYkF8tEOkqdvWjPJGl8pScR5HL7ljbda9b3c1kgvKC0uBQ9Eh8jGb25w4SNvaYaK7kjhKRW4Ewi8s/WhBTaEtgo0woAcuKtsuZ4PWbWDdTlwjAig/qRGCKcLh1GawztfXUjvTpF3NLUZr8FHGbod92DWrMaCtj+cAOtgSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460590; c=relaxed/simple;
	bh=ouvtVl7K0PAyNCf/CqS8kHiqugncCwG8s3P79l84eTI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PYSuFlcShJydTgXpDwo8K4p4mFqMIuCNhNjlZigardY0dOudge8rC4engaM9PI6BtAgnSR3kMir39wbJEuuj51W00JKs/xWmuFD/7mq+NjvpZZcVUK2ctlVET+bLjMbOSfmzL0p9fOk1z0zZIq9Yd8DaW5GExCanYDByTs1lolc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UojUQ2BH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UojUQ2BH"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-627e9a500faso80793717b3.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 17:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717460588; x=1718065388; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HRuXM8qP8LdDvX6fn1r8scesSI9q9pU2JyFDr4cXXhA=;
        b=UojUQ2BH9v5rp6hRT9wq3SvE+B0LcgiWW6LvCxc0Ly1+6zwA6VDcDgvV66091vNOKo
         cZ7mk+4AvWo/STdfaTA+2iBbVfHlrUjnQNvIgOK+Y2SsDdISsj8QlibEVb87lwhoabWC
         5N7O7p8hF9jWTM63j2+Rbi2OD2AUbz4WJyK0/CgUKLXVQ6sUzV53XnOVkU2XjANDyZ/L
         BRvhfRxisNIw2RunD0GwWnvLxHKCw3GiRSf77V2vVZmXBFI2/gSEmC7nruh5AAsHzbyg
         4Jo2ZC3nl8hEZp5kvDFjeJC0+2wJ+lCMp2SxtC033hWZX3dpjTqw0DK99DOPR4Ysmxue
         Hhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717460588; x=1718065388;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HRuXM8qP8LdDvX6fn1r8scesSI9q9pU2JyFDr4cXXhA=;
        b=kkPWPHsLGc4KymqpJHvsPDDeTGODhR+97NioODmo7GTnzNH/O72riGRpl/h+dmlc0O
         DQK2W+2Xnu/NhbWlDwu4uyMAuW+6ZV+XJWz4ZaZjcmsQhyZUbIaCZjGA58SrYvSBPd3l
         lNPrTkaBXxrQWpHBN2ixUlW5FQgW7OnpXNazX6o4Gmxu2leWZRgroYpJ21kge9WZI8Qq
         T9RHlDEmS6k9HWaRigMyYD1rEQ9Sc2EuISjw/TzkXIx4QCXJLLRY+5sevaJ8i/BJrmhb
         GNCqj1WCxDxmLiNHJh8ZVxkoyxbMYRm/fimLCJBASc3qnHEf3CG5oClrzfZqIg0CZm+Y
         SRcw==
X-Forwarded-Encrypted: i=1; AJvYcCWrvPZGRjQVbHVRqzSxC5XiQQmxSBEnsCYS0esUPJr98yxMvv3jePJPYWnf/dh+eE9FTe9nOKLssCoV+EzJRw95udCfrsSL
X-Gm-Message-State: AOJu0Ywz23UJM8VQP9hLBS5RbaI1QphQyXyOXogimCwaHiTu5TT12Ocy
	xkG7GGjoWqjWH8KFzC56R8MYZvPkVybrtgXk0zupPj9JVjt5QhVXDf0ngqrzmaK3E5QikOqOGx4
	rtQ==
X-Google-Smtp-Source: AGHT+IEk24C6d/QoiBbCyIExMW7OdPZLjaBEK4ZPTTj/IX3O1NfqjnOFuoealUEhXp84xV+hhBOGjvPTh7s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:707:b0:dfa:ba40:6f43 with SMTP id
 3f1490d57ef6-dfaba407295mr112473276.2.1717460587664; Mon, 03 Jun 2024
 17:23:07 -0700 (PDT)
Date: Mon, 3 Jun 2024 17:23:06 -0700
In-Reply-To: <CADrL8HU734C_OQhzszWJWMXEXLN6HkBo4yweN2fX4BbOegXrFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529180510.2295118-3-jthoughton@google.com>
 <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
 <ZlelW93_T6P-ZuSZ@google.com> <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
 <Zley-u_dOlZ-S-a6@google.com> <CADrL8HXHWg_MkApYQTngzmN21NEGNWC6KzJDw_Lm63JHJkR=5A@mail.gmail.com>
 <CAOUHufZq6DwpStzHtjG+TOiHaQ6FFbkTfHMCe8Yy0n_M9MKdqw@mail.gmail.com>
 <CADrL8HW44Hx_Ejx_6+FVKt1V17PdgT6rw+sNtKzumqc9UCVDfA@mail.gmail.com>
 <Zl5LqcusZ88QOGQY@google.com> <CADrL8HU734C_OQhzszWJWMXEXLN6HkBo4yweN2fX4BbOegXrFA@mail.gmail.com>
Message-ID: <Zl5eat0sh7rrspUG@google.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Ankit Agrawal <ankita@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Bibo Mao <maobibo@loongson.cn>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2024, James Houghton wrote:
> On Mon, Jun 3, 2024 at 4:03=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > But before we do that, I think we need to perform due dilegence (or pro=
vide data)
> > showing that having KVM take mmu_lock for write in the "fast only" API =
provides
> > better total behavior.  I.e. that the additional accuracy is indeed wor=
th the cost.
>=20
> That sounds good to me. I'll drop the Kconfig. I'm not really sure
> what to do about the self-test, but that's not really all that
> important.

Enable it only on architectures+setups that are guaranteed to implement the
fast-only API?  E.g. on x86, it darn well better be active if the TDP MMU i=
s
enabled.  If the test fails because that doesn't hold true, then we _want_ =
the
failure.
