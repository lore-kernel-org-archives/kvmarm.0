Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C66C220F5B
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 07:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753686344; cv=none; b=KuZEXrMWuzc8XfLtx+jGhRRR/4t0zsO/2lnxz95haLPMyi6kVTyO3J+ISHd7WKjS47w7t6nDmG6xCSmp9v0XAoGb+646+3gqAqSWan55WWwFu/gbLdl2FoO1Zp2yLtGEd9oTVpZT+PufOk/cvbXSX5B0tWb9U/mOCrLj4iH+mNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753686344; c=relaxed/simple;
	bh=kQwpUu3pdIcVVkEM6j2jRU78dQ5txh+ni/j6a59ryYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c3V4rsslHaLPTDUu1rSg0cc0G5E46IDOfrPwL5jkk1ita72HxqdWwgzPHeyT+j0IQSvlX7OiaRbrPNNOybfVZkV+t9F/5EJVSLByHXCXSYS1f7IkV8pcSvOZXU+B2MgrVNvepL3mxqk+nHeKTRa1O6vfposiix16c9XLPH7XV0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ElaUxiY/; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ElaUxiY/"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-553a66c3567so6822e87.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 00:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753686341; x=1754291141; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ABzFGAudwjHSpGmDKnmCejI++sq8wZtuTDnQk4QEthU=;
        b=ElaUxiY/SVKdfKNsO1vVfgoYV+0Py3m+ZiBkQLXj4TmV0iDotDaTcpBQYsKiopXggE
         S68lPzdZC3ZDNjbcxFwo1OeG5t5v0r6oRKujywWXIiCClo3ejIpOpvnb1hGJPBj1LUDv
         evvojcFAkWHVlFtMgEQQbqyMyYBzviMPPoT1T8daUX4l5GzzdIjDVWDMEgA5cYZGcJom
         Ix1NlVoQfcvnfBMjj7M89e5h7sgnNIy3rlwGb1cVrLMJcDr0Byens7BrvOoZ64nJKuCp
         F4smxqp9vrSZESITRkqFa1wFWcrf3ACcUdIUNm/d5qhRnug4qQi3+A9f5KhNyptrLtrw
         8UxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753686341; x=1754291141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABzFGAudwjHSpGmDKnmCejI++sq8wZtuTDnQk4QEthU=;
        b=UUh3QsFU5idVVQ+BD/UtWyNF9Vx0cK7R6i+6Li6m9mog3OlbOJ2IZP5flXcPk7W5j0
         hSQDwQtpzCxQM56hnlGSqYQF3F3rMSx8DQD8ql+eZH8/XArRPEb+WvT0PXmg4ob82deC
         3YmustrFr/YQRhUwtlwsFwXbsR8HN9jFoY+yEH5vWSV51pRgXHXUWeHwcpnVslFj+uhr
         vgzMR+w9z7jGDubkeyypdc9Ap/YrpQyU/J5N1d9jrXTWr90jvFwlhDfEH260NXR4qEF+
         ATylmDewgIZ2bgYNRk5BdSCcA32JRUQyUKDe2VlI+JTSPMYPvSk9xB5xqjWwSjM2tODB
         0+8A==
X-Forwarded-Encrypted: i=1; AJvYcCWMDsvK7vsCEU1PodahMSq9x/egAt6QwmG1kTHWuJJ2G9SzNPaIvqlQfxa7GwGxpJLzNwDhXJE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkYNztD7yHgpRO1hRT5jfT2RVoOsAzAfB4TUgIsT2/J4Xf2FEx
	w3HDLh0agAOCuwXz6yVkhDyP++Bi+ISdTu9oCXSCvzfRaR7r0Kd32ImXyFtriSOJ9FRuvoTy3W8
	UYJX0xD7kUenzPLlVHTmm4eL83IYfZXqvhf2pufth
X-Gm-Gg: ASbGnctLgCpGOMEgJJFHwej/kK6fesKP/MmWrtlqbo5Fq5KYgw9L29RgTVo1lc5/xY6
	mbIz9YF2fvYUGks/dAuiicoqhZretBY987G3PY9yAcvmAYYN4wr35boaZI5r5CyvvJLoqkWunrn
	mjjMYpjqJNxY+Nppd/TzSdCnhrDPlEQmhwhloGuScEJRkee7LxKBQ/367xU/bKmUX434G0616Fc
	bsoULOeZ0E+ibSKzw==
X-Google-Smtp-Source: AGHT+IH+nhG03vhszpw4SpGxLBcsItXrblXPXI/Z3jowcjOUQPpqAObstdzHVPgpSKZxUwqvLJJMux8lmEFM7MWk230=
X-Received: by 2002:a05:6512:2117:b0:55b:5e22:dfb2 with SMTP id
 2adb3069b0e04-55b63a96040mr246280e87.0.1753686340942; Mon, 28 Jul 2025
 00:05:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
 <aIObJH439LQWjnqq@google.com>
In-Reply-To: <aIObJH439LQWjnqq@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 28 Jul 2025 08:05:01 +0100
X-Gm-Features: Ac12FXyVGBddx8pm5Wrn9wDW0AE2GoOgT_q7kkPWz9XW40HNA-igFWzzFSoA1tE
Message-ID: <CA+EHjTyhSU0WiAc7GhwrdZjoUe0w5Uk-gGxd_AD6SRmezYNROQ@mail.gmail.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Fri, 25 Jul 2025 at 15:56, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 24, 2025, Ackerley Tng wrote:
> > Fuad Tabba <tabba@google.com> writes:
> >
> > [snip]
> >
> > Did the patch [1] for x86/mmu that actually allows faulting when
> > kvm_memslot_is_gmem_only() get dropped by accident?
>
> Ah shoot, it did get dropped.  I have a feeling Fuad read "drop the helper" as
> "drop the patch" :-)
>
> Faud, given the growing list of x86-specific goofs, any objection to me sending
> v17?  I'd also like to tack on a selftest patch to verify that KVM can actually
> fault-in non-private memory via a guest_memfd fd.

Whatever you prefer. No objection from me for you sending out a v17.

Thanks!
/fuad
