Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784BD2837F
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 20:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713560261; cv=none; b=OaoRN1K3LHgoKsFS8WHO+EOx4wA2aB6boOTYCAELplJcX2je7vxeWuuDaR9ek9YtoSbQ5hbeXsN0M5ODgK2jI72tYZZKBNYTGLDSvpJ9KfZlAE3HfTKrN9gnG/fnAZt2KbbC8HiE6xAFx4LlW5V/jtsdBpcF/KxhySwb3Tq2NBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713560261; c=relaxed/simple;
	bh=qoLj+dJYefPcd1d7d+sMJMQdz9RnEJbXZl0KVW0Sv7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rndZ6TIclX4MyHgwC4H7HPph9sosvmLxgSICptOF5VQVyX3MeayepvBikl+b4p7aKFkQvC1hLhGEPJg7GNk9r5iRIh+/tFXwPgeMXNW011VtdoFxsP6nDhm2loFuJONrSOS8lHDwvNnjKsVIw9G9prxblTQfRZC1jzEfjUfBG6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xUtQ7oGQ; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xUtQ7oGQ"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4348110e888so25871cf.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 13:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713560259; x=1714165059; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoLj+dJYefPcd1d7d+sMJMQdz9RnEJbXZl0KVW0Sv7A=;
        b=xUtQ7oGQxeQDQ8ChZ0oVclhB4lbi5RRoYPK7+O+Y6S4ch1Rh/pYEK3Z5/iHrhLIDDm
         whm1hOvYQPCuoqKoNcySYdm4MVfAXxeuUGwJLDluZe7TnU0F2mQLyqDOOy35DVc5MrsL
         fLfLY39XokiWeapiSNT7+GKTQEgwzyPOmOIv0UtB0YpjRZUJ/wMhnDhFJivrS614JePw
         SH1DJpzPV2jJ53DAmceaqg5wjvFZTo75I645Cy5tfMKwFvEC37lEj/S/TF64e0NRZ+ma
         cS7DQe52ih6EwejI+vRHELvzacuOOKiKu1ORVYGCh8dyEArMVSlxy721hofD6UWPn0he
         HBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713560259; x=1714165059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qoLj+dJYefPcd1d7d+sMJMQdz9RnEJbXZl0KVW0Sv7A=;
        b=VJLTleXOlVBGpgQnfXKyQxYymPXytsVshACBaalYTdIaiPl28AHHtpmMhciXC0rZjl
         R/EqN3dlzkrS7BiRzaRDUTqcfaMxbRPghBLC5xevDL39Qb968q5+Jig32yTkR0Xf5EOg
         oJIT5/Oit3y6ywfARsXoIlerj302MfWb119z+5yNczlVvecga9qeajbRSWR27BLAYC3s
         umuTPSCSFRlrUBR24Bf6XEJhBgoFDgxboo0vtSGqNBTAYGcxu9ua+KOorPz47Nks+Wx7
         Ak2nsd8RrzyTJIEXzYgzGrumYVJ40hN7EU7IFijJqgBi0iuxXwWIokGGXNp9xUaB3Tw5
         3eqg==
X-Forwarded-Encrypted: i=1; AJvYcCXFy5WTTvP2wDQWacbAmdw7OTw4O6NoWp9P4LgnUKw8Da0KCg2iB+V82GMUawEGfa5oHs3v9HdT6G4AUAfEzDugPc5SEAH0
X-Gm-Message-State: AOJu0YwvDlqsFBB4U/RbQDuHKGmsSpQHyy3WfQW9uv76qq5csXpuo+yB
	CiphjVW0y/MKgf/G2o/2xHIk6Z0viHPDpkCZCVdJukTsQMw0RiD0qRCAxbGX8EZqXW16j2s6hb+
	9Krzh1SZsHF56v+m3jL8xl7YAuaMNpTBXPGcY
X-Google-Smtp-Source: AGHT+IFv1QNbGHT+roZmsKKDk+4PrHigHuJTamLsAWVaJCEFFb06VO4JQpFPHTrcY52wz67cbMD5ADs0MVUpOaV74QM=
X-Received: by 2002:ac8:729a:0:b0:437:b99c:dbf7 with SMTP id
 v26-20020ac8729a000000b00437b99cdbf7mr13893qto.11.1713560259365; Fri, 19 Apr
 2024 13:57:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com> <ZhmAR1akBHjvZ9_4@google.com>
In-Reply-To: <ZhmAR1akBHjvZ9_4@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 19 Apr 2024 13:57:03 -0700
Message-ID: <CADrL8HW+4Yq-wBr1+DzJvSwRRL_hqt5RaCCLgOQndPGUqoX+Rg@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] mm/kvm: Improve parallelism for access bit harvesting
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

On Fri, Apr 12, 2024 at 11:41=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2024-04-01 11:29 PM, James Houghton wrote:
> > This patchset adds a fast path in KVM to test and clear access bits on
> > sptes without taking the mmu_lock. It also adds support for using a
> > bitmap to (1) test the access bits for many sptes in a single call to
> > mmu_notifier_test_young, and to (2) clear the access bits for many ptes
> > in a single call to mmu_notifier_clear_young.
>
> How much improvement would we get if we _just_ made test/clear_young
> lockless on x86 and hold the read-lock on arm64? And then how much
> benefit does the bitmap look-around add on top of that?

I don't have these results right now. For the next version I will (1)
separate the series into the locking change and the bitmap change, and
I will (2) have performance data for each change separately. It is
conceivable that the bitmap change should just be considered as a
completely separate patchset.
