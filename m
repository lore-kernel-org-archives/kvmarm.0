Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED24A28E56B
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 14:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750430360; cv=none; b=sfYOxX09eOn/eJ5ZfyBlpynu54WXvrzPP4myG71FpUmXMto47/nlp43BaW5GNlzRPepBHGtqGFsA9cAVPDbT5ukpWwy2mCn+0Gf6jblLLVJHdMr1281WkoiKQbzCviLRtRZx1v6azTKnebyGiNTNdbVWLJrj8rTK8bT8mL3iLeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750430360; c=relaxed/simple;
	bh=f0ERDdgXgTFaM2bAnZ1S200y/0WNSgNRatRYt7yg6uI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dcOO5pSRpOun7Dg+KQ2y3Ddsnx4y3qo7z3uPcaB70nJGgSU7fVPUeMN3PkSrp63EiWUpPQbOf8k27yLrIJXV40FopInfCv0/DAAZ6VlWomedpv8rs505dDP6Fm8vFYoB+lKCaoxEr0x6ceI9/j25RDLLJELXBAkGLLesqhG3MeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SJ1fh/it; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SJ1fh/it"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313c3915345so2805292a91.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 07:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750430358; x=1751035158; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9hYeG/lN/dobWu+WOAuHe6WhQ/AJqqM1f1NumulS6iw=;
        b=SJ1fh/it3Ryt81NUbfdR2zA8gWR9yEEU4da8FArqM61LGAFH41Olod2FVcqOZhYIiw
         HNQEXk5p9XxS7nHDoZORTWa/i96I8vbElb8nxsxKD/kEC52FdYdbfdjELqaPx97ZVJYR
         ubPuHuqmf6oKmdxsPVSSr4HW79x0D+PIja6lu0mKXMLXiLMzZFttdtZiQQzLwLp9gsGE
         N3aAVz2Jfx2Fqt6pFuhixR0zKxCHCBECl/L1GmeQvxbvut0OdZaGF3sI/+kuhTggYZJ3
         jP/aVglZTX/SL+466HipL232YwsOjbNiAK1egG2S1NtUodbkzyhYDL7SCYVSmhZL1o4S
         DQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750430358; x=1751035158;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9hYeG/lN/dobWu+WOAuHe6WhQ/AJqqM1f1NumulS6iw=;
        b=knRqvjHzxooASGCFhifI1nFKhAW/3UXIs+GFUoLOcxizKuAugQHT4j1j7SgMjNDaFS
         yUw+Ta1Ht3E04Z20lbjXYPlHpkwF3CVMBbmVitx8Kr6cC+8SW0UhN5NUmQ9UZY9QeLOH
         8bNX1NWyFNp9FuZNE+XkIf85affG1oBzKVh0kxxrvc29+Ovu7hwQQuOuP4ZEchR/1vrz
         JQ7saZUkpMjusOfOLccrQzB4uHkVXd+10l+QUr3ZsGg46yLlm0sxxXpmUWKJGJwq6xcb
         41fWSL7wtmWbYdLVnioYzAxHU2XYQRf7lR1FFV4m1Zn19GFFrdm7fpqaf7QmSRoqiIRn
         J8+A==
X-Forwarded-Encrypted: i=1; AJvYcCVJe4TMJAqKLwqfQe2KqsCSOjNaaeUwitSpzwF0EtSTILZVZF2q4uJOVpoOPeovEqL9caPyvUc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPsTBnjrMQUEINb7QrA8tGBjaQel9kGNX/odtRzfbP/iJ7lFfk
	dFT3mTp3YcHG1xTnmS7Bjz2PcGso6LLqcYbQ25iXCVoFkWp1lDZEFiIUogrDyoJC2Mruf6eTmVq
	np/cNkQ==
X-Google-Smtp-Source: AGHT+IEu/kAyF65SAfQsKleZ41Vg0owDojNFVAMM/0F6gElDwFbB1sj7AbPvBVKqQ3YY8zBgnoMiSm1QDmM=
X-Received: from pjbee15.prod.google.com ([2002:a17:90a:fc4f:b0:314:d44:4108])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e87:b0:312:51a9:5d44
 with SMTP id 98e67ed59e1d1-3159d61a5c5mr5175181a91.5.1750430358355; Fri, 20
 Jun 2025 07:39:18 -0700 (PDT)
Date: Fri, 20 Jun 2025 07:39:16 -0700
In-Reply-To: <2eqjnjnszlmhlnvw6kcve4exjnpy7skguypwtmxutb2gecs3an@gcou53thsqww>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-19-seanjc@google.com>
 <2eqjnjnszlmhlnvw6kcve4exjnpy7skguypwtmxutb2gecs3an@gcou53thsqww>
Message-ID: <aFVylP1XzMoqocOx@google.com>
Subject: Re: [PATCH v3 17/62] KVM: SVM: Add enable_ipiv param, never set
 IsRunning if disabled
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025, Naveen N Rao wrote:
> On Wed, Jun 11, 2025 at 03:45:20PM -0700, Sean Christopherson wrote:
> > From: Maxim Levitsky <mlevitsk@redhat.com>
> >=20
> > Let userspace "disable" IPI virtualization for AVIC via the enable_ipiv
> > module param, by never setting IsRunning.  SVM doesn't provide a way to
> > disable IPI virtualization in hardware, but by ensuring CPUs never see
> > IsRunning=3D1, every IPI in the guest (except for self-IPIs) will gener=
ate a
> > VM-Exit.
>=20
> I think this is good to have regardless of the erratum. Not sure about VM=
X,
> but does it make sense to intercept writes to the self-ipi MSR as well?

That doesn't work for AVIC, i.e. if the guest is MMIO to access the virtual=
 APIC.

Regardless, I don't see any reason to manually intercept self-IPIs when IPI
virtualization is disabled.  AFAIK, there's no need to do so for correctnes=
s,
and Intel's self-IPI virtualization isn't tied to IPI virtualization either=
.
Self-IPI virtualization is enabled by virtual interrupt delivery, which in =
turn
is enabled by KVM when enable_apicv is true:

  Self-IPI virtualization occurs only if the =E2=80=9Cvirtual-interrupt del=
ivery=E2=80=9D
  VM-execution control is 1.
