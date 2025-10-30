Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30C333E355
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 23:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761867645; cv=none; b=kLak2wlYUqMQvdUSQmidzsAA0VHxmv/LI6vLDXJOwgHGqvC4NT9QxYVDy8cUTWoXHLucCiZs6c0j8Y9z2zebjDngr1NCnBdLkvCof/m67otKNR/ntyS+8K4+zcxGZatPe+qB3UaebdEA2WZnr/BS/89C+5/Jez6hYugsD11GK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761867645; c=relaxed/simple;
	bh=eUlRvGsTDsOghmrMBild//Vvtgn5Z9S+p8wIvknhN0Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QJrhs9rwyc449XSRAHjeb17mlufcCz7l1ByVpgKS9EyN0iKEE+Eoyd4eq0YqV5W2U3ie+EjwGXjOi2JpI/ggI+GM/CX0HamWFtTV/L1Me2BJvZ22SGgBrHpX6j3mWXSBLUlBJFGc1eZt5qYs/SI77hgL/cQO3z+cyz4sUxikwMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nYfzY8J4; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nYfzY8J4"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7a26c0c057eso1533117b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 16:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761867642; x=1762472442; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hANv7xEJBy7S5lh8h/UQF87h23G6mY0gbFBLav72O2Q=;
        b=nYfzY8J4fzBx3r9WtnfUuYHT8Q87joKiawIBFxFmFB59vnEm+M2u7pTfN70/QIDbO5
         pgE2B3/ux40x9lW9zWkelax6lYYPpSWJ3iLcrtrFsjFzSeu28ofVXQ0uRLAAOi5T/8Tt
         buy252ubCIN0HZB1tab3j6D2zgSa6QFDaVJUcUn3TsgmdBCdlOGEXkrK8v4e+SCFSF0F
         xE1NnWycpNmpHyKMO3kLKj9peV7IILKCZnzW4/cTxzgwW1xDhh9wPmjXDLHg3EqZSBTp
         fxoKFvdcozDij+iIkpoks6SWiWs8UElpl7zcT8vntDh98hqNeWtRHjimxdobi/ll6w5t
         OP2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761867642; x=1762472442;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hANv7xEJBy7S5lh8h/UQF87h23G6mY0gbFBLav72O2Q=;
        b=i2xwmya3biQxqqj7mcPleS9Ol2S5u54s9vlv6mGbRBtrXT1vKpz8IrBgbqsGjer3OP
         plgDomwBTVg4ftEQX9gTLuU0lhO1NQXzWCop5BUlSd+GyCZw44kijwzqeiYox/eMqiFI
         VdWAvplQuU41bmvFQs9n3/NAoNonDLkO00XNJVLklP/u0gAW444KGwaPgYVqKmr44nmg
         tRuc9y9gTiZMWqgFTbfyq7S7iEu+lmLkYTeY820PDU/hofU93eP6eT68gHfCEiCI7YJX
         5gx9hDIpfopxD8v8gqLrcXF1MCgODzaqC6/rGB+9NMp1nor2OUuZZ1igNq3EwkbwhtX4
         KeSw==
X-Forwarded-Encrypted: i=1; AJvYcCWZNTQHsS9b02IdiJ1AKvZodhojNXjT22KlBEGAEbtkxCZ0xSIK/UbDsWrO8X+lRwNfU2AgApM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwL7IAZry8mE1GYp5sNcVhH/4pam4V0zYaBacIUtjSgqTlNRrhb
	ELHVvdBrJ/dJLb/wjmg1ezOm7znW8+qup5yphEuJs/oRiR3LAQErHOx0pJFWEe/6QWoUoZ+XpAB
	T6htK7g==
X-Google-Smtp-Source: AGHT+IH6kktSpJB8uW8dOccHej0bRJlF9t4mdGsOdXoLRdKSPbgGpCfMdKkfH5SPES5/Onbr9IfT7/Ky4i8=
X-Received: from pfbhm7.prod.google.com ([2002:a05:6a00:6707:b0:77e:40c7:d12e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3996:b0:7a4:460e:f86a
 with SMTP id d2e1a72fcca58-7a7796c8a99mr1645968b3a.25.1761867642073; Thu, 30
 Oct 2025 16:40:42 -0700 (PDT)
Date: Thu, 30 Oct 2025 16:40:40 -0700
In-Reply-To: <6572689b28a76bd95bc653b1fc1131fa57ed7669.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com> <20251030200951.3402865-13-seanjc@google.com>
 <6572689b28a76bd95bc653b1fc1131fa57ed7669.camel@intel.com>
Message-ID: <aQP3eJmLTHscDoI4@google.com>
Subject: Re: [PATCH v4 12/28] KVM: TDX: WARN if mirror SPTE doesn't have full
 RWX when creating S-EPT mapping
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"kas@kernel.org" <kas@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, 
	"zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, Vishal Annapurve <vannapurve@google.com>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025, Kai Huang wrote:
> On Thu, 2025-10-30 at 13:09 -0700, Sean Christopherson wrote:
> > Pass in the mirror_spte to kvm_x86_ops.set_external_spte() to provide
> > symmetry with .remove_external_spte(), and assert in TDX that the mirro=
r
> > SPTE is shadow-present with full RWX permissions (the TDX-Module doesn'=
t
> > allow the hypervisor to control protections).
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> Reviewed-by: Kai Huang <kai.huang@intel.com>
>=20
> [...]
>=20
> >  static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> > -				     enum pg_level level, kvm_pfn_t pfn)
> > +				     enum pg_level level, u64 mirror_spte)
> >  {
> >  	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> > +	kvm_pfn_t pfn =3D spte_to_pfn(mirror_spte);
> > =20
> >  	/* TODO: handle large pages. */
> >  	if (KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm))
> >  		return -EIO;
> > =20
> > +	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
> > +		     (mirror_spte & VMX_EPT_RWX_MASK) !=3D VMX_EPT_RWX_MASK);
> > +
>=20
> Nit:=C2=A0
>=20
> I am a little bit confused about when to use WARN_ON_ONCE() and
> KVM_BUG_ON(). :-)

Very loosely: WARN if there's a decent chance carrying on might be fine,
KVM_BUG_ON() if there's a good chance carrying on will crash the host and/o=
r
corrupt the guest, e.g. if KVM suspects a hardware/TDX-Module issue.
