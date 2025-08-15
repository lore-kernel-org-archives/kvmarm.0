Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3204308F1B
	for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 15:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273100; cv=none; b=qommvPFP8rYV/x8OmOorix7uBtFyXohg9WOw3m5QWCM/cA+DE5xW7skI2uZDuCRKrWIf6wZQ4wSoi1U1sK10IcaYamMnGBX1mCVa+ZMPvmWMiCa3q683tfGc9l6ztIte9Qql7cVE22qfx6CJN+J0dXMpkH2Dg+mE54VhkhnVnXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273100; c=relaxed/simple;
	bh=TC3F7GjzY+OYu16pCnRLEw1W9DDDYcqj1aSZMIOYjuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PxBzLyEI9qEGRLvFGs1/BZXvxsMd+UMCZUnZd7fwNfdt/WiaxnHGdcOWJRp3rirCvRryHh5qrLUVBQBCQtvsTwzw5oXKbRMNJPIS88tN8Uui9MaeOnPpWUZDaGa4AMQHNFb/oBfA3hi1kZEtRpoM6jO7TisvwTGNbcGUxgCKIG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IvSPbLYy; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IvSPbLYy"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24456ebed7bso25629075ad.0
        for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 08:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755273098; x=1755877898; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yLuuQdqXBRGyu60+ieS//bbxP+3AVwFN22YqAdloirM=;
        b=IvSPbLYyyPu7aZ4McACYudX9QZrTSbORHtyaI9dSF7dzfXIzoVz6zur9zVHUf/zH+I
         jugFFXwv0l6XsxsUQp4T3EGmethyOkx4KYPHJnEIyIoUGjTLEHAg5uxRA0BcaGKCZICq
         7lZbzI2GSRAPrvwHdfJnp+vM2zDUSvDpsozqSokkFXodA46rJB0Hp47Qc6kMKwzFEsHX
         uDJoQV7yTj51CxYw8X0zubLNgHEXR9GRWVoGiPPgvKVIoBHO3KbJFmNbhvrenIZMr737
         kFAz4oS98U7XZEB7WObaOpwdDZ64ZgbC7x+5VQ0HRhz2T+C2+VwmHOKflADu6QHSdGEw
         1Y5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755273098; x=1755877898;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLuuQdqXBRGyu60+ieS//bbxP+3AVwFN22YqAdloirM=;
        b=GTw6CHXsjLxn0rmrOwN8aGA0uSBWdxJdXJQlwI3bokCkESlVwbxBdbsi8kFtRKmFE/
         36NZYDJDw0+zVSZZmVsehNdLF+xEj8/ZwQ1KHJjgIMF0IK3hOQYbpMGDWXQgfL7nOnMv
         FudLvt/9eV/gJUbmIgbog+Ae2CWodGDhCZUiMftp0y2L/nHZUjlgTyzSCW8siHbOzMkZ
         SRZMVkflavPRjfALDsg0A2Lt9hn/Gc9dOj9CK17LClFLKsP/OYpSVFIO5AaJ4phugX6R
         ols8IPYGen/I+vTOgaKoPLg/ajBDrw05o87mVkOKhWl278dd/9BEoa3PBluRSK2S9n/0
         4YWA==
X-Forwarded-Encrypted: i=1; AJvYcCWeo30IzWI36lOksXiZHdcVk9BGXFeNIwaKtygMH5ZakNki0HlQAcxkcRUAi2oLjDr89oqXwzo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHFeLWg1NiB3s1aZm83htG2/g1gyJwD/IyAH8kpu/ucOtmdrv2
	bwU8mkWih+E7euDrDONtgx+X/BK4FiCY3Bxp4/86Jj7Axb4GNSq+ARB0Zx+stRBgFPMgnpFh5RO
	V8ksiyw==
X-Google-Smtp-Source: AGHT+IEixUUF/+ontXG1UvvxuaP113HP3iSlTpnTS0Og0gwZnRo8djp+nSrKI0cvN3mMbDgB4JtBQNij17k=
X-Received: from pjee7.prod.google.com ([2002:a17:90b:5787:b0:321:c2d6:d1c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec3:b0:244:5aa5:a8b
 with SMTP id d9443c01a7336-2445aa50e20mr99042625ad.27.1755273098085; Fri, 15
 Aug 2025 08:51:38 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:51:36 -0700
In-Reply-To: <20250815130436.GA3289052@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815130436.GA3289052@noisy.programming.kicks-ass.net>
Message-ID: <aJ9XiAa58oMs55Ky@google.com>
Subject: Re: [PATCH v5 09/44] perf/x86: Switch LVTPC to/from mediated PMI
 vector on guest load/put context
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> On Wed, Aug 06, 2025 at 12:56:31PM -0700, Sean Christopherson wrote:
> 
> > @@ -2727,6 +2739,21 @@ static struct pmu pmu = {
> >  	.filter			= x86_pmu_filter,
> >  };
> >  
> > +void arch_perf_load_guest_context(unsigned long data)
> > +{
> > +	u32 masked = data & APIC_LVT_MASKED;
> > +
> > +	apic_write(APIC_LVTPC,
> > +		   APIC_DM_FIXED | PERF_GUEST_MEDIATED_PMI_VECTOR | masked);
> > +	this_cpu_write(x86_guest_ctx_loaded, true);
> > +}
> 
> I'm further confused, why would this ever be masked?

The idea is to match the guest's LVTPC state so that KVM doesn't trigger IRQ
VM-Exits on counter overflow when the guest's LVTPC is masked.
