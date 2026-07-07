Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222D22541C
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443219; cv=none; b=XT0eHvojBRx1x8Yldyj/INuwzDPUBkVoHqNdG6ckbj5HBSVFF+suxHZqKemkowenmOzkzedo+RhQ62HeMCgc2SNwFa/Npc1k6fyD9Hefjolv/czrji2/yu0w0GJJdTWRUTG0C3shcg5RpniM5npTc8nElATSxRVPQuUwDZGHonY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443219; c=relaxed/simple;
	bh=x7/WsIxtjQVQlBNleU/AP8zhHac80bKZX9kH2wV/qj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M1CJiZLhH4yYb7PNewdkgbIbByGFLLNpU6nrq60Qw/e+p8ZjtryBvkrBAfSUoJh3ERkrTkpcxiMbGIQEgv1b5iZTFTAc8YqXf1/kkajHycMqDuZP9udaVQtNLfONyuVZ/T3emP0oi11tDp04RMs/BuZfea00vrkC9JlZ29VIO18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kWFyfhFu; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kWFyfhFu"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493c2b3dc8bso30659655e9.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Jul 2026 09:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783443216; x=1784048016; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYLHBFIYkSC00BT3OFNNZ7lMGwlI6NybvgfnsYZ8kCU=;
        b=kWFyfhFu4GDfi0O0kDbCsjQRLw7C0nXpS8ZzeVl+xhJwo5Hv9z+sQAkXHpDy5DkALo
         QqarKsgQldTGSzGTclJRCIQyHm5Z964iZ4Dama38Cr7bUlp78BHBW/h29DfLKCQFesmG
         NraDqEjSXjBJi2slAb/bP+1wb/z5tS906jttGy654mmHkUY692FFW/4G6Whk8xZdgKMz
         TrmE6Nb7gk6UAn8CJBFpCmV5ImN0ExJbzQynZk0ZQOGhR58p/j9I2YArf5MS7W8eFomx
         4jtBSM2py9zv0an361vovu4I/2Gpbt6DIHqakwyJmsSb+uwlnnsiYMp/ScSwl4Q/E2gn
         M5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783443216; x=1784048016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JYLHBFIYkSC00BT3OFNNZ7lMGwlI6NybvgfnsYZ8kCU=;
        b=TNAv/3qo1wAi8/FJSDkpwFQ/Yqjbh2LC/hWSYdMYmxNivDHnJCTpEUJSP+N46Fynl9
         rKB1uGA8sdQo0FQvCKFEpge4sUHSjZX5L5udkALyKZi1TAUsyB0FsMw8qF0KOtVdgA12
         4Q0AdgAqZb3d4aK7l6BwWl8CoylDUbFYHY7tzV5QViEa2qbcxqwhmL+nPChOV9an5jUY
         eeV4+yjQox84m9Oonv5DGd8hVKxqbXZyq5FWPlBwp8V7i1vqcb8MfI+mJ8Iz/6hDIqX2
         +pII/afeo6fRq+I8QupXRFnUBzeFBTDErh52E0BK8466e0eEFcm8NKaknvwh6Ab4I2aa
         GGbA==
X-Forwarded-Encrypted: i=1; AHgh+Rq2Z4aYcgxpB84MfdxRCVNjw63qYSBN1Dz2YwgYwl2P68Pe4CXF3UHUHtymUWW3j8h4w870GIU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0gJivWbN7p9ubEVr2PURf5aF1w6WD1r/t324wJZkj5EVEG6qS
	LV3Ri/DrW551p1W+PKs9HTKoba/Js6LZCY+m7QZlj7yA+joJuur6m8rJrlnpWUvmTw==
X-Gm-Gg: AfdE7cmmh5rM9iZUiJNNde4IrlEgppDgL7+gWmrNR9+XFEMlk58N1RZaYNTjhSFqYMf
	hSTytceAa24euzTZBSw4h6qRuauJLNodIsYPddepXwKq0ZMuVXDB6sJYPZSXFaEl2buVNZSvpq8
	m3Jun3L7rRyhsCRfw1dATiE9Eu2XH8XbxVRMnNGNMz7kXFFAYQHHHn+Hf/+WMtyy7iDRbv+U7Ku
	h4JcUAszKC6rW4tsGu2KOnoDJv686/piiRK9eCIc1dCW0tHxrXP0xm4UNh72xEydqwXrKKxx2BA
	C7X3+d56SaL0+czKauuvxYg2rc5dO3xhFG+WhMzZRQF94p39FvHomMSLXz2wcDJ/5+S3AKvXuXK
	yYQexB1DtOCFnYUiduUYCH4ogk1Oivaixdp/y7esM8sBdRmLOoujhhFRQgOESnkWRuESn+xHuFz
	5Rl1GwD8vbDOmco3r6r9OAaFCG6eq1osjbxeegi1aMlV1ycfxJ4Is=
X-Received: by 2002:a05:600c:4e03:b0:493:cd3f:d097 with SMTP id 5b1f17b1804b1-493df06b123mr64535395e9.12.1783443215304;
        Tue, 07 Jul 2026 09:53:35 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0ebf593sm72423765e9.0.2026.07.07.09.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:53:34 -0700 (PDT)
Date: Tue, 7 Jul 2026 17:53:30 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, rostedt@goodmis.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH v1 1/4] KVM: arm64: Allow early calls to pKVM
 host_share/unshare_hyp
Message-ID: <ak0vCmPyTlWIwFEI@google.com>
References: <20260612142245.1015744-1-vdonnefort@google.com>
 <20260612142245.1015744-2-vdonnefort@google.com>
 <CA+EHjTwSU67aNdgWvgR3ZGSB07Hu7wt4rUBkVGhrhoHKa_S1vw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwSU67aNdgWvgR3ZGSB07Hu7wt4rUBkVGhrhoHKa_S1vw@mail.gmail.com>

On Sun, Jun 14, 2026 at 02:39:30PM +0100, Fuad Tabba wrote:
> On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > The hypervisor tracing for pKVM relies on the __pkvm_host_share_hyp and
> > __pkvm_host_unshare_hyp HVCs. In order to start tracing as early as
> > possible, allow those two HVCs before the host is deprivileged.
> >
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> To my good friend Sashiko:
> https://lore.kernel.org/all/20260529121755.2923500-1-tabba@google.com/
> 
> The hyp_trace_load() issue seems legit though.

I've just posted lore.kernel.org/all/20260707165029.3410701-1-vdonnefort@google.com
> 
> As for this patch itself:
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> 
> Cheers,
> /fuad
> 
> 
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 043495f7fc78..fb049c40d04f 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -89,12 +89,12 @@ enum __kvm_host_smccc_func {
> >         __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
> >         __KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
> >         __KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
> > +       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> > +       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> >
> >         MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
> >
> >         /* Hypercalls that are available only when pKVM has finalised. */
> > -       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> > -       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> >         __KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
> >         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
> >         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 06db299c37a8..f0c52667cf52 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -721,9 +721,9 @@ static const hcall_t host_hcall[] = {
> >         HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
> >         HANDLE_FUNC(__vgic_v5_save_apr),
> >         HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
> > -
> >         HANDLE_FUNC(__pkvm_host_share_hyp),
> >         HANDLE_FUNC(__pkvm_host_unshare_hyp),
> > +
> >         HANDLE_FUNC(__pkvm_host_donate_guest),
> >         HANDLE_FUNC(__pkvm_host_share_guest),
> >         HANDLE_FUNC(__pkvm_host_unshare_guest),
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
