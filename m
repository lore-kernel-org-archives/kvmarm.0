Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D328E4908B5
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 19:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786734668; cv=none; b=ZaspksST3PaEqhu//IKaKCFUJumrLrNvdjUt/scqnIMSdNJPjTvTThX6J3Eq+psZUFPdlnVRN1Cx4GwyKifHRHft+nu5LTYNy9StFGv+Ghat1c+bGKO6yYEJuhlWp+VrfvL6FcBFlxn0dwETNt9cvokjJyVGY9DeYaXXYiOPPiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786734668; c=relaxed/simple;
	bh=w9vAK1GoosRceLnXS1z6Nay4ihVtxX38bQKCwzrAPKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ex/A2VT2aXdlWaElNjXs782ya0iiax4bY5ORDD3y8Ls5VsSzl+9QpFAP4VHfsTmPrljGtG+tYcbOlIM+D+ovbJtPAeagSnHWTIZVCwRRl3iOSlVwFpr2CLVBGtffOl2pRV7F+ccG4jsDjCpw4P4fBmnrB78DfMmEaT1fOTG8pcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u9Hs8d0l; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u9Hs8d0l"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8486c3411c8so1634722b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 12:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786734664; x=1787339464; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFEy1Pzzmf9oV8+r6B/Uh7d0hODw3XhZm9afSq3e+o8=;
        b=u9Hs8d0l4w1ESnbHS2+zwGRbJ6P/r/aOz0Tn15wfWp7l98+egF0n1x3vuWzkAmxY7z
         MFgxz3bLtkkWp3CQ9DBHPfT6/jBE5ugHpCvvh9P4hyoDx7FpOAx818kXnReGl9az/K6s
         iBo3HX2lmUCsQH0EA2i+nmLDN9tTUC9VmSoe4SInhEqj/IbLnNNHyn3nukyxB02pllz4
         luA+Y0XF/0MRzEvmoB7oWfbUTVVLYmR+IlmuAsnSWoRB74Unio0kQoladw1M5mjZU2my
         koPbapjrQIz1IYv+WTb3iJUMqQMb66wkTBzUIzw5ThysIFp5yRnSPaETUzG0mzklfZCC
         1qSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786734664; x=1787339464;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TFEy1Pzzmf9oV8+r6B/Uh7d0hODw3XhZm9afSq3e+o8=;
        b=j5O1w9IDbu1V8u/Az2+27Jd94YHSOisj4LPR9Nnw0A6SlpPAAmLV8SnphLWfote0lh
         fwG1z/fLfisLpFdlZaDANgVX/ahOCkS0tvEUDdJYivDMEq+nkKcU2Stwj/0LaK3l6UKB
         0iPMFPRO45p78WjD4iZMvwgXuI2T1EENSEO+nW0TNAE6Pn76/3Qo5lyYoHWplNK2bgnm
         TEmz8tUV8jDy2vz0nnJunKsPyQ5HMd4FCYYkYJl8lCBJIZbbdCXg7RW9DzVAwg273AIW
         oVoFjqu1F9FJ/XE7/RWajVbm9gUTLLVKC2DD7tLZa/G5C8UCBhD7hwrUVSxCQupIKd6/
         j0ZQ==
X-Forwarded-Encrypted: i=1; AHgh+Rohp6OXimbI5fuVr0dkHeP66520Jx44MwaGz+NjpDbON0y2ht6tg/lyag5Tfuvtiz/vCkwEYe8=@lists.linux.dev
X-Gm-Message-State: AOJu0YybLgOowCH3QLbZHyUde06MRGwr6gKdBcI8EqEDmxAH0aRS7YHN
	pBQR2LMzTv0+YgpYjeUigltuWMkr3XtruAUb+i4jps78TXU3Ix5ogX22hiu0krb93NLypIlxX+n
	vKu6ZOg==
X-Received: from pfbkr10.prod.google.com ([2002:a05:6a00:4b4a:b0:848:569f:3464])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4004:b0:847:99bb:b6d8
 with SMTP id d2e1a72fcca58-84fde251c75mr9480785b3a.26.1786734664084; Fri, 14
 Aug 2026 12:11:04 -0700 (PDT)
Date: Fri, 14 Aug 2026 12:11:03 -0700
In-Reply-To: <an9JNUln8dKaidQc@raptor>
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
 <an8SOvLybeilzCEU@google.com> <an9JNUln8dKaidQc@raptor>
Message-ID: <an9oR3dBVgFs7j7q@google.com>
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
> > Yes, I'm supportive of KVM expressing to guest_memfd that page migration isn't
> > supported by the VM.  I'm only objecting to expressing that memory must stay
> > mapped in S2, because guest_memfd doesn't care *why* page migration is or isn't
> > supported/allowed by a particular VM.
> 
> My naive contribution is this idea I had:
> 
> 1. Userspace queries support in KVM for feature xyz by checking the
> capability KVM_CAP_xyz.
> 
> 2. Userspace knows that for feature xyz to work correctly, it is required
> that memory remains mapped at stage 2.
> 
> 3. Userspace creates a guest_memfd instance with the right combination of
> flags set and _unset_ for feature xyz to work correctly - i.e, to keep
> memory mapped at stage 2.
> 
> For this to work, new guest_memfd features that might lead to memory being
> unmapped are enabled via a flag, and KVM keeps memory mapped at stage 2 by
> default, to maintain compatibility with an userspace not updated for the
> new features/flags.

Probably?  It's impossible to know what the exact flows will look like, but the
common theme for everything will be "don't break userspace".

We might make guest_memfd page migration opt-in, but if all of the incompatible
setups can enumerate their existence prior to creating guest_memfd files, we may
handle it all automatically, e.g. enable page migration by default, but disable
it if a TDX, SNP, pKVM, or SPE-capable VM is detected.
