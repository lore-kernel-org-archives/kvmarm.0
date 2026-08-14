Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBEC46EF9F
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 13:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786712639; cv=none; b=Rhd1cz7OfpCYJp/QbZASGiunpv49PpeswB7pdfKi0b9gPoROx4B0Su9JmyLxRkSqsk2fEHfERsMOzlNvelac5z/234DbIrVYkDn+fmIC/dYCuvsVbABKa1gDv21yTcPO9Dk894Grk9pRu/J9ruIs2QOWI9UwjIpYRYWmIgryMmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786712639; c=relaxed/simple;
	bh=2tza/Lhp8sgCN48mxycDZ5jMIUVa2dXecs8Tu2/DIBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kkGpkELmqlj+HiOutSWMq1uQUJoQyXlYr3U2X8NLjosLGbUJVV4jHG0LzJ4Z5vQWkCTDqpFcK6Ui+tzr1LToTy0AaV6FjiIt79cc6YrH7zBE2nXnWjCaiAu5XJTNzOTecYwmiKjchSpC6ptaiNAj1fZZw6LJ1kiZ1spJE1Ufras=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ejji8xhI; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ejji8xhI"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfca8558d2so14915925ad.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 06:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786712637; x=1787317437; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gZcYmV5Cug1VJQ3U1/VOA01nGHc5KRf249qTuRVD+sM=;
        b=ejji8xhIYLPKv0f+j1ZIJzPv8BttSNQxyAiEFWmbGuKTnao0Z6+I4+/rBpq33hR53R
         TPqnz0nSrJ98Zud9NTZ9+IM1RcEXRX9yyfIqhyuXl+g1n0x6yasLD3doawMWu15ciCpo
         +cqFjseIFEDYx1bLk58rWcJNwaLZK+XF1FMgHjsLyuccqjBaST4TsnE7iu8Qq1OXvcFl
         R19k62GRBn0wjYaFzfO+Qb++7z2IWkqldckntFrRVMJncMddk9xQoUWilUog7rf50/7f
         JlYl6dheQW0LqbZ9z1TOoLvCHrgxPk7u432+qKRySi/oo++BAfP066hSf8ueV2eqKfac
         +N6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786712637; x=1787317437;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gZcYmV5Cug1VJQ3U1/VOA01nGHc5KRf249qTuRVD+sM=;
        b=m4Y1SvuCCfFSSeV2QqU05VmG3LkFOK/XsufpaD33ceXk06lcrC8SqidX77KepEo2e+
         Idc7CeXRmm+4Zam4slsLi3DDPjMreleeXuRFNbVcRkaCVJ1kqqPQCjtNn+vKzvM/ICqI
         aSl+Z7b/nK9UTXA9bXQRmTzTuvyuahZXD0abeh9Q+s6LSZ0pECPsCMxzmFYWWJCeAdqh
         rlqt9VgeLxR0ixUvrp4Zp9JP2lZUlyq/dqf9rzVOH4jLBO9SJE5JBBOT5T8LoGTIW6DT
         zoRU7X6uxb6kaz+nT2qAd7OoqfXC1bH4/dJmOopTmdjBLXXJu/aZaHSgKuFuoqxuhK6z
         nqLg==
X-Forwarded-Encrypted: i=1; AHgh+Ro3sa3XUEZuLnifVhMzDziOW+wHbDeBfZPLMVXFOZooxBfL4YTdaEa1P6Fqqf+eiJgkHKlO/sw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzP/Kjh8voqbunDuR/dpbHA3mktCkcrumcEHoRtqtXtN9KdRxcE
	JEmNCD+i/zZWJZwTVIa2GorYiqVJlcYiafLdw7uHc5mbCqRk5DCBze3Szt9xd/4Jk7WvDVUIoVk
	ObBGFrA==
X-Received: from pldv11.prod.google.com ([2002:a17:902:ca8b:b0:2c7:e06e:86f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3204:b0:2c0:e2ea:6b0c
 with SMTP id d9443c01a7336-2d3b0d88bd1mr71228795ad.21.1786712636303; Fri, 14
 Aug 2026 06:03:56 -0700 (PDT)
Date: Fri, 14 Aug 2026 06:03:54 -0700
In-Reply-To: <487aa57c-72ad-453b-971d-ca24a8380429@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ak0wSQ1133O7B96D@raptor> <ak0ziUcCXUlDdcla@google.com>
 <ak-EKSslAz1uqEtv@J2N7QTR9R3> <ak_wC4Q-mQe14DI8@google.com>
 <alDI1b8fC99SG4_a@J2N7QTR9R3> <a127176a-1722-460c-aa84-754e1d343f53@arm.com>
 <an3sEiQlIuGEjUur@raptor> <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com>
 <an5UJ4S_P1LUFmzD@google.com> <487aa57c-72ad-453b-971d-ca24a8380429@arm.com>
Message-ID: <an8SOvLybeilzCEU@google.com>
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david.hildenbrand@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Mark Rutland <mark.rutland@arm.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 14, 2026, David Hildenbrand wrote:
> We have a hardware feature that requires pages to always be mapped into S2. Some
> things I had in mind:
> 
> 1) Page migration would not be a problem as long as hardware could be paused
>    while migrating (e.g., kick all vCPUs). I doubt someone would implement that
>    right now,  but you could consider it an implementation detail that page
>    migration cannot be supported right now.
> 
> 2) Newer hardware could mitigate this problem, allowing the feature to support
>    pages temporarily being unmapped from S2.
> 
> 3) Disallowing page migration is really just one implication of "pages must
>    always be mapped into S2".
> 
> So what we really want is "if feature X is enabled and hardware requires it,
> always keep pages mapped into S2, which currently implies that page migration
> cannot be supported."
> 
> Which isn't all that different to "if a confidential VM is run on current TDX
> hardware, always keep pages mapped into S2, which currently implies that page
> migration cannot be supported."
> 
> So I was wondering whether the flow could be:
> 
> User space enabled CPU feature for VM -> KVM knows that current hardware
> requires for that CPU feature to have S2 always mapped -> KVM tells guest_memfd
> that S2 must be always mapped / disables page migration.

I'm a-ok with adding a flag to guest_memfd to communicate whether or not page
migration is allowed, because guest_memfd needs to actively support page migration.

I'm not ok adding a flag telling guest_memfd that memory must always be mapped
in S2, because guest_memfd doesn't care.  E.g. KVM doesn't yet support page
migration for SNP, but SNP tracks page ownership in an out-of-band table and so
KVM can map/unmap all guest memory from S2 at will.

> That would be in contrast to user space having to guess that page migration on
> the current hardware with the current guest_memfd implementation does not
> support page migration, to then disable exactly that.
> 
> Does that explanation makes sense? I don't know the exact mechanism to do that,
> but that's just my high-level thinking.

Yes, I'm supportive of KVM expressing to guest_memfd that page migration isn't
supported by the VM.  I'm only objecting to expressing that memory must stay
mapped in S2, because guest_memfd doesn't care *why* page migration is or isn't
supported/allowed by a particular VM.
