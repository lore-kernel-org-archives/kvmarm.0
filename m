Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DB648A8A4
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786723493; cv=none; b=h9uuqTxK3HIqdiCwlBbaufVKQv5YC0zdKLyGlVXRHE+uks35v00IJr/C9A4OMvBj3DV+pc/Ut1wNPSZ6K1vSpqBxnpSWR9A+4ZQmG5E4NHQXFjBy2CNNgC7heoEAmpudEMO5taEC1F2rVCY0+lWtY1ujZ3tX+1KN8pDKqxPy2AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786723493; c=relaxed/simple;
	bh=L7+zwvJ4nASrYVbjUeFFeoHP7BESPz4/u7WlgERYTLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QOC2KIKzokGWf74bJpU0uktNf//45U7DpaA05dOQfVq41OvbF1Smi+Oz3L17fyk+076HItgIm3f1G9SP5NHu599ir+fR5rw6zlMgwvOvSIMiH9QY0Aj2A5cH/WT7C32KAsSn1enCmQxP+7E6+jflXLH+v3/v/BVxBNlvBUZo6qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a6aFrGv3; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a6aFrGv3"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c85798977dcso1660680a12.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 09:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786723487; x=1787328287; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M45GqPAfaWkAxTNfkHv5H0q0VgCGytksnXS+eq9PrHc=;
        b=a6aFrGv3YBh0+T31cqIxincCH0PtRjD88+mIEGZC9uYUyy8EnpyiJkhSZ9XCKeFFJp
         13Ua12aRBS2fXyz5tIK/Yy8CQJBkLyPIvblbqNMiLxlQb0n3bPAzSbdNTRwwhnkfenaE
         qE5SuPPoWy7HssRLkBvDsamR1sH2Dw/VIBOEN/NSz5KIiXzsUml8TXHM0hjDx1oprFnU
         lIQTI/iG3FjFeeiHc/7WXJNlGOU/yNCNMeD3COOD/p5yWg4URaeIVDOp0wTCtOlbaZf+
         tsBNEl+U0OOHV1zDnu6YYReephK4GMBnexVCM+G6C/Vck/o1YDJRZQsXiEFfJjjTsfqF
         Rduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786723487; x=1787328287;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M45GqPAfaWkAxTNfkHv5H0q0VgCGytksnXS+eq9PrHc=;
        b=UkFk6FnapZdwcS9IGuJrXPDVzE/ZprWEkwqNeEArx/uHtQMMCFa2cJe83Ea/PB/P8T
         Ih9I9umW6VoqTc9Bz/mQVVfApQSEaEk1KULsLMfy+7HOF6oE2FIn5fwXi/xFLhZeaNP9
         +3yY58R0DU61OKbME5N+FFC6EVhJWjav/ZMruekfd0SS1eaQGTLDHgl6EIuFgr84vLDj
         A62/ivpQPLNeRhMKAOWpuuE3WmR+2qWug+CWgMxft6qmIdXmRgo6Wl0/6oH8ZgdoEHhD
         GUFvGsGJEI919uVVJo8bJ5h3MTl8z8bDnz3I8vjiSsmdNQcz1cb4rItEVM+8VCzMvd+w
         Cxrw==
X-Forwarded-Encrypted: i=1; AHgh+RpGs+JfW3yobxLe6qHwgT9OBoN0Q8au4xiGnNj92gsj8ROJVA/Qp8pF/+gzMXXG+eF4sToQ/fU=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywc0tC07NmaSAsC7OqHcc+jaLVln00pE0SoxN3c70t58JCIj7xX
	os0dCIFVhRq+5GAPWRGpbcA1pCLdD94Mqrl2b5bCSXMzunuqXuwuXvXKoeHI2SehcF9tI8YEKQI
	+Sw7jkg==
X-Received: from pgcc9.prod.google.com ([2002:a63:1c09:0:b0:c9b:2759:d240])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6f8a:b0:3c4:1916:9d46
 with SMTP id adf61e73a8af0-3cc71f4a5famr9143644637.27.1786723487045; Fri, 14
 Aug 2026 09:04:47 -0700 (PDT)
Date: Fri, 14 Aug 2026 09:04:46 -0700
In-Reply-To: <an86rPn4P2dRO1RB@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ak-EKSslAz1uqEtv@J2N7QTR9R3> <ak_wC4Q-mQe14DI8@google.com>
 <alDI1b8fC99SG4_a@J2N7QTR9R3> <a127176a-1722-460c-aa84-754e1d343f53@arm.com>
 <an3sEiQlIuGEjUur@raptor> <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com>
 <an5UJ4S_P1LUFmzD@google.com> <487aa57c-72ad-453b-971d-ca24a8380429@arm.com>
 <an8SOvLybeilzCEU@google.com> <an86rPn4P2dRO1RB@raptor>
Message-ID: <an88nuw0FKT87a-W@google.com>
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: David Hildenbrand <david.hildenbrand@arm.com>, Mark Rutland <mark.rutland@arm.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 14, 2026, Alexandru Elisei wrote:
> On Fri, Aug 14, 2026 at 06:03:54AM -0700, Sean Christopherson wrote:
> > > That would be in contrast to user space having to guess that page migration on
> > > the current hardware with the current guest_memfd implementation does not
> > > support page migration, to then disable exactly that.
> 
> If guest_memfd picks up support for another feature that might lead to
> memory being unmapped from stage 2 without userspace initiating it, would
> you be ok with that feature being gated by another guest_memfd flag?

Yes, absolutely.  FWIW, if I get my way and reclaim is driven by userspace, then
hopefully such a feature never comes along.  But if guest_memfd does gain some
feature that triggers invalidations, then yeah, at the very least it would need
to have some knowledge of whether or not the associated VM supports said feature.

> I get the feeling we're all on the same page, that guest_memfd will support
> a mode where memory isn't unmapped from stage 2, and right now the
> discussion is more about how that will be implemented.

Ya.
