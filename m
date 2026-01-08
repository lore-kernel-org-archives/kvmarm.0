Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C6831577B
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902655; cv=none; b=LW+6QaCo3py0H8asX7sgrIp12jTxklPh0OzqC+Bgl8hvDzEPn71XuzyJyLQDExwiRW6CtjKEJtMh5ztPD7Rh68nB6cGK/D/7LAEuAESgY+hdTUNgdN1z/MB+PyP3SdR2r1E7lzL6vdipgyBy7jbkajogx4b5fWnW6tTYGOQLJ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902655; c=relaxed/simple;
	bh=Sc+ak6kXD2O2otUHZGDuYAqOJ/KnbA1ceZEKyhd2zdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=myO6p2TPErLdfJsPtUrvdo6OTa2Sbrk1TDmZNLDgrNeHMjzMrfzL6oyurax91fPn5RAMh0C8rXYhMhGPIgpKrDU784RvJqAZzwTFUfb4OJm8dpIkeJsC8T0UzPziIkwzPM7/m7FRC58fRa+tbWFE8AFLSRhSSj64AXBvOlW7PaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s+n44V3U; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s+n44V3U"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so3533981b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 12:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767902653; x=1768507453; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RHDeNFz490Nrky17RXCNoP5KLrJVy9PVF3wfzv9VqJU=;
        b=s+n44V3UwJQpIqU1SQAF7BPYXQqGoQ22WKSWZk9e51SMEmNb3pbZm8Rspvklez1NZz
         ylsnbyL9fE9mC9FPHyc5+fmtq7wQDUcwzdFYkNtatwtyp87slt3/IaITbmHdObieSLW7
         rigrynk62iO226le05tRDliuEM+o97aD9y8EucjqvqGlMJDxOYRxl0f+Dqr/3YT8vzsq
         OFOTdn2Bh9FS7fB5ViNhasEvIOEaLIiNigb8ikXbGtKkt35wp/oe72aRtAJKrlr04bwT
         SRtyQ3ADArO6Bwjdpny75U7gSkm0U1O9/69kF4piulpqZboZBfG+j+BKN/oqQPYY+oWu
         aAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767902653; x=1768507453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RHDeNFz490Nrky17RXCNoP5KLrJVy9PVF3wfzv9VqJU=;
        b=lverewjnQz+usgPPzXQCxUu1XOS1UMEcuNRozOgRYGQa1XtwdcKPwCei46FUnuoYtn
         emO8gvdxly7gF2BOw4JcbDxym7Re0fFRr7Pa0sbE4QiG8/5AQuJ/b2XhY0csPYfPb/xF
         O2zhIol4QrtpvHFX9DM1oUa2HjzK7TyqDdlsAqi083kz0PG0zEIxSF0UnJbgOooFD+mV
         Odb/w0lyHwhW6j8mLXLNe+qH5sIBLMsTdACERqkGr4jWD1bCS3N92EiQTRgMF+QXb5va
         lK0pqZI/+XYzAJeczIzsaOCwF2HG1D53hwIA/uex3qU/CO16OrW460hqKldYcGSv7F9S
         0b4g==
X-Forwarded-Encrypted: i=1; AJvYcCWH7jk6N0B9fPxnT++rzqgifEPg7ZVYjsbACkV/jf28/gBV4XRCW20AjwzgKviyNm+4bEd5oVw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9WWs8QCGTwnJU6AFmgh9cIEHP8eYTS1pPOkgEh3q9fFR97TYX
	O2lfiWtxTYMGuvDdAxjOBl5iOUdyeQ8sd09OTjIE3inQrcWGiHuQC6CunjKJF8HOD7suS3snqu/
	jgz0IoA==
X-Google-Smtp-Source: AGHT+IFhKs48GN0WkSDiAO4qPNHLVPhcEoNB+pDwryoeKjyNGQcxURXgfxIrWzkPwVlbxpHNfeozbbrhcz8=
X-Received: from plhi7.prod.google.com ([2002:a17:903:2ec7:b0:29f:68b:3548])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3947:b0:344:97a7:8c6a
 with SMTP id adf61e73a8af0-3898f9cc49cmr7749765637.51.1767902652739; Thu, 08
 Jan 2026 12:04:12 -0800 (PST)
Date: Thu, 8 Jan 2026 12:04:11 -0800
In-Reply-To: <04c70698-e523-43ae-9092-f360c848d797@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-40-seanjc@google.com>
 <04c70698-e523-43ae-9092-f360c848d797@linux.intel.com>
Message-ID: <aWANuxukqWmo36N0@google.com>
Subject: Re: [PATCH v6 39/44] KVM: VMX: Bug the VM if either MSR auto-load
 list is full
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 08, 2025, Dapeng Mi wrote:
> On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 38491962b2c1..2c50ebf4ff1b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1098,6 +1098,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> >  {
> >  	int i, j = 0;
> >  	struct msr_autoload *m = &vmx->msr_autoload;
> > +	struct kvm *kvm = vmx->vcpu.kvm;
> >  
> >  	switch (msr) {
> >  	case MSR_EFER:
> > @@ -1134,12 +1135,10 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> >  	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> >  	j = vmx_find_loadstore_msr_slot(&m->host, msr);
> >  
> > -	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
> > -	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
> > -		printk_once(KERN_WARNING "Not enough msr switch entries. "
> > -				"Can't add msr %x\n", msr);
> > +	if (KVM_BUG_ON(i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm) ||
> > +	    KVM_BUG_ON(j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> 
> nit: Remove one extra space before "m->host.nr".

Oh, that's intentional, so that the rest of the line is aligned with the "guest"
line above.
