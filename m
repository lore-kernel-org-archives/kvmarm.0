Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C362B538A
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 02:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709086375; cv=none; b=H9F8V3qTsYUFHJwLRHTgoByWtH7nI+V+IO5UHYkfwfI0f41nPOza1obqvRGB0atg8FitfSrD9yZOxhZjOKBMspQxr+otz2eAwzGh1jhmZErkdVBGhJa/eV18az7mFRfOOyzW3wAO7rLJwhUWlbz2A0K+Xp1dEFFrrrz5TIyC+L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709086375; c=relaxed/simple;
	bh=heHaKIN6sSWB6QKxW3jTLPXpvf+aV78DvVXemWiQhpI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UF7ma10L1lRHR3hQfFAKmRFW8p6RpF/Qt6zbcQa8NzKhJXNMITTJE3beyWiVp5gIz280Hi/qsZ4MnE8ot8mTeBhCAvxTSAYamsdYV0K6FwtXB6rZl8gW1UhMoiiIMMbMRF1s3ckSkKk/LCdIxfqr+G24IXFMmCmkigJD/I/QfOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wf0V4k3W; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wf0V4k3W"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc693399655so8341841276.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 18:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709086373; x=1709691173; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ug25ooKz3qoCHEHw9pjGJUPzAeGvqTHR1DcTVlpibj0=;
        b=wf0V4k3WUQ/gr9DVYTi8EuSkdfcpDa8Q+L7tIoT+1SC58UsoAbR1wYUedwYTNgVvib
         Byig7Z6t5KRL/ehQw2sM9Z89WHTqIdmCJPLaETmRim96x6TQ5Ui1m692R0q1f+fJPb+A
         2EriTRDSwwvghyVR55CCea7vlbIG5+50uQWYe6KMojoVob8kas6NmNfDC4GV1xuPBOCu
         rM+uJ9hhi3mNkDy1R3J4XHbJX2gK1L93/Sa3D4ssMOixyrAQYqOHf0g0dcA/4IiJaLd7
         S+ssh4LIlhqVVWtt7YjK278vYjJFl7b/qwsIcvgkpRBrzJCK58NOxn2N+6lsf5s/Bdpd
         KejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709086373; x=1709691173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ug25ooKz3qoCHEHw9pjGJUPzAeGvqTHR1DcTVlpibj0=;
        b=YdgCtqUqACiBxlNMr2wbkmvGov4mludnaPmmUDx5Sk8LN2RnVpD9fmxrXDN/SrKseJ
         b+1+9CkCSNhIRea6YoKIQ2pIZ8PESz5ihif+789+I9gBSzDU6+Q0BsNjQpUWY1/uodZj
         q1ZBokxTnBC2rDueWG6IqEFFaaZSDzP8d1nd/8Rryus1eg1k9kZWSClO6ufOo/DQC/qN
         A42OFFCm89HRLo6PoG/nzOC+F1ywSbQ8ljMxV8EA8S5/G2iT2sSdwIrSHPa4ApAt9Ivl
         R4Sy9PXXrMPRCIiAIIBs+hY5jhh+QjiIdy/EndxIgzqAWcQncVLwVKcx2of/AUYtAmCd
         w9tA==
X-Forwarded-Encrypted: i=1; AJvYcCVYSiYFSKAO8fdLQRJwykRl9nxqNUya8/SAjxR6Vt7ckremE0AksVf9cKL5nyro/euLqSc+uQDubvd+6DenOHXDKn5lOF6/
X-Gm-Message-State: AOJu0Yxfmeu/lteLxQqFGJymxm3MDvKNfa0zdCLqbAtjbRd2jpTyojVe
	A/r+pZbOGxVc/YghzvTx+Oqw8IWrsvn8Fyp9OlIn4GbCuvi0FA33nie9y0yyNCrL7w9xg4kQqHJ
	AEA==
X-Google-Smtp-Source: AGHT+IEWMTeeW/rW6Q/Vg95tNiBAFAaIWQo0WCsJMra9fasHaexVBEMkZqZy6bCuf2Vx83BD3Y0c2GDEzj0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab02:0:b0:dcf:411d:67b9 with SMTP id
 u2-20020a25ab02000000b00dcf411d67b9mr330040ybi.5.1709086372730; Tue, 27 Feb
 2024 18:12:52 -0800 (PST)
Date: Tue, 27 Feb 2024 18:12:51 -0800
In-Reply-To: <75d37243-e2a3-421a-b74f-ccbe307fef96@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com> <20240223004258.3104051-8-seanjc@google.com>
 <75d37243-e2a3-421a-b74f-ccbe307fef96@intel.com>
Message-ID: <Zd6Wo0hQu11L4aPc@google.com>
Subject: Re: [PATCH v9 07/11] KVM: selftests: Allow tagging protected memory
 in guest page tables
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Carlos Bilbao <carlos.bilbao@amd.com>, Peter Gonda <pgonda@google.com>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 28, 2024, Xiaoyao Li wrote:
> On 2/23/2024 8:42 AM, Sean Christopherson wrote:
> ...
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
> > new file mode 100644
> > index 000000000000..218f5cdf0d86
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
> > @@ -0,0 +1,7 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
> > +#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
> 
> Since the file name is changed from kvm_host.h (in v7) to kvm_util_arch.h,
> we need to update it as well.
> 
> Ditto for other archs

Ugh, nice catch.  I'll fixup and force push (likely tomorrow).

> > +struct kvm_vm_arch {};
> > +
> > +#endif  // _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
> 
> 
