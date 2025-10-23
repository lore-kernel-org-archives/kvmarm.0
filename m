Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB83332907
	for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 15:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761231602; cv=none; b=JDHwwd0n4xxZCQhNzyGf1YHwKXz6NC9Z8MH2JoYHXO2gtfnCk9941jhKdLwzahIXWDjaJFxioy+nwj9pTzRjqdNlSP49g/5CdMbuCxXSIVT9LBg9aO1m4vb8ZEvpVISnsqV1x0LrY7wODXM9lnQt9cIudgzQ98zAy1tz40HrNK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761231602; c=relaxed/simple;
	bh=cCjw14mLE9P+iI4RdSZoroo4x5ze1Fp0XffjVUeu23Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ear4uDl40FF3ALnoD96OaK9Hxl3//vO6Y/iVP7yCA9FFddB8kBJUTaJZxSF901Bs9OCGKqKDpejFiiSviCSyhoengO0Ih5pyNCeJBQRfEyf5s1SbY5Pa4BzVImjIdy/a8ikdHoCzmrsGupjH8YHm6Rgnk05H9DBCVRAiszYGHhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lulYKaOq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lulYKaOq"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32edda89a37so764665a91.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 08:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761231600; x=1761836400; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DsY3zzD8XUrRiTLyLBawfwaQI9/sErmot+/rfYHcY0U=;
        b=lulYKaOq/TcTSltLmKJBDonwuU391kqfUdLAy49yAcWJ+jpzNlLU8GajY3pjFxzERC
         lh8NFPxrEDgUxuUDVVCaOrgXcSk7fBX352krBjfVFGGlI+gEthVzsQU8ctgJ7c1Bd5D/
         6T2Ss3dzabxs/sZxaWX7ROpZZHa1aagDkHcxUFA7aaCUaPkfGFSA8lAEtrgrrNZ/WICi
         kFwsolRf79hc5oeE6RpXaJggrBQwCaJUpxhF6l7cz9jCIrRuODA95SvA7UUwjUlFPV1K
         T8+4k6hLgXMcJSdvOgGg3g7VDH56hllRXJAuwtiLhTJWFkA6zCOXeYKUoa9fhClzoKCe
         zY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761231600; x=1761836400;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DsY3zzD8XUrRiTLyLBawfwaQI9/sErmot+/rfYHcY0U=;
        b=I20bt0dtraYSK6vPlY/tPWk1U8IRT5cyjuJbbDE8Kz2nerganGbKKt+UEcEBromaON
         WE+HpicRaru1mPjYSdQL9NgGqMrMycAPWXzCqjTRpYk0OqVq1kZN7ZWPZpQmQ/GRMLWZ
         F1xCxS9y/9uoHqbpKidr3k59vzjHEXKIgQi2MqYOPZIaazV6oKdtHXIbPaRdFQOeFI74
         0b92Pzi17jfg6zT7SWiq3mpnwkpVHNG3ouPDktvDrXCXWckHve0auAn4+4l5/oG5CepP
         WjclsXhHYaMOeuOYcPmGL4Tk4bnea8Cn2HGHZ28eq7bUippomEFy+6vazs7uefHUqOVE
         j65Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEu0hp3C7gyEjfbeUWB29Z3Ck/JYUzRHVRZzCHGCfCd/s0+NPvV1dvg2yItLuwWiuk1HWkQZg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRwmigAV/MfqxyPS7xeb0HRXPajMUv7UoJ2vkxfaUBDb3SD0NT
	3EHMbfOl10oEOGieQPoD3jCEOyMODBBqNIpMYtGIdIkmF/eQQj4cH6RdPhemGi9PYvUUlnIhJ4V
	7GqId5A==
X-Google-Smtp-Source: AGHT+IGIKST/5gTXkhLeNb6+zo5OEJ6E7Tz0ILKzp1TDg+5uVro2JJ+z5T3UkH4GmCDPjUQAuY2o81CumRA=
X-Received: from pjbsp15.prod.google.com ([2002:a17:90b:52cf:b0:330:a006:a384])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5291:b0:32e:859:c79
 with SMTP id 98e67ed59e1d1-33bcec1ab25mr31136898a91.0.1761231599767; Thu, 23
 Oct 2025 07:59:59 -0700 (PDT)
Date: Thu, 23 Oct 2025 07:59:58 -0700
In-Reply-To: <28136b62074550826efa3f57b1f7be07f571abdc.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-10-seanjc@google.com>
 <28136b62074550826efa3f57b1f7be07f571abdc.camel@intel.com>
Message-ID: <aPpC7mt3CwWuhv1p@google.com>
Subject: Re: [PATCH v3 09/25] KVM: TDX: Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte()
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
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, Vishal Annapurve <vannapurve@google.com>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 23, 2025, Kai Huang wrote:
> On Thu, 2025-10-16 at 17:32 -0700, Sean Christopherson wrote:
> > Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte() to
> > avoid having to differnatiate between "zap", "drop", and "remove", and to
> 		  ^
> 		  differentiate
> 
> Nit: it's a wee bit confusing that you mentioned "zap", because after this
> patch tdx_sept_zap_private_spte() is still there.  But it may be only me
> feeling that way.

Hmm, yeah, I agree that's a confusing/misleading.  How about this?

  KVM: TDX: Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte()
  
  Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte() as a
  step towards having "remove" be the only and only function that deals with
  removing/zapping/dropping a SPTE, e.g. to avoid having to differentiate
  between "zap", "drop", and "remove".  Eliminating the "drop" helper also
  gets rid of what is effectively dead code due to redundant checks, e.g. on
  an HKID being assigned.
  
  No functional change intended.
