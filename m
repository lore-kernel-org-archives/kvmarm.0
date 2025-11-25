Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F98D283FF5
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 11:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764069757; cv=none; b=LjsKTAXJgfjLR+ur70ItTg4zIazb9Wh8LjCccFseHZpOGmMNbqBWF7EZnQmSnSp/4fgz0VEG3Ep7cFmrMY5HZMaqx5g0pjDVfXksEdZd6vJOX5ifH1cmGjh6B/9hCs/+Y8L6PL+hdZAzHZl/j766IcSmm/9U/FA4XNNo2gWOnEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764069757; c=relaxed/simple;
	bh=8A0ajViliK3Xk9CxMhdKP1RnM72/06YSeBi3L9O9P/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STSEWpi8nLkzDbOOCa2CAEUvo/SMGedKurtkz790Wj53WMS43aLFKsEf4Ryz7kEi63JywhTSnCQYfk5ypV+CoRxjo6uLuEtETJoiwW2JiRx7GgHpqyRCGqBty1SIzez5jTbtNDq+ij5c60wk+cdR4V23d2gdJiIiGH+/QUEAfzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iJAassO0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iJAassO0"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b3c5defb2so3550526f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 03:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764069753; x=1764674553; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/GHs616mr7dTyieWIVUhqR8ZeVc35qwPIJKCi+VXq9s=;
        b=iJAassO0raC0bQARTEa3Tbj4Kd7SiyATbZGpihnLUsKJkMpVSvi9TuaA9pQq7vy4YF
         Pz6aBVIzYXmjLhawTk7D7ekq6bKdm+oNEUNCrUit/51eNnODFmNahopbMBtGXbV9w7DI
         S+1myp5KOFwfPC+bL7Kxahxfl+bemRIedzuVAMqJXkRlXrFlbK8yKUIpRjo9hLxittmv
         bNxW4ApAF3/jGWn519LziDSKSw4Yqp2gArLoZ7bWacu4wOHu8x1eU/JSyS3Z5b69EN0E
         VKSgQtBlBjGy/kD4Cvo8wHeJBjX+K1ra0D/hm04dOw+UTtiYDiQyJimJguA8tozab2Ne
         tVyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764069753; x=1764674553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/GHs616mr7dTyieWIVUhqR8ZeVc35qwPIJKCi+VXq9s=;
        b=s65T3PtN5AaYzFRFT4QXM2OhNuxnjiCbQQww200hkxSrb82ikyK9KWUs6a1ku5ITxN
         E01zKSZ89EgIqUdU94HfPcY9GpiLgUzv1pBNDcgeZXOz2pVXgpWnB1c08cOumh5bpszB
         k8VDyvhb4l7LPzWtAPQy87HBhvDMO33Cvk0vlYcPM7/vgjDLGKiVwAzPxvmSFseT/wAF
         pq6dWAvCZxnffM+omX9GfdbmbEwKTulJx5h+b/5HDD63TDcX3YhwglQP/GBNEtZyGMEL
         5EHMU4DCirIMb3Eb9VctYjfbRO8Fd5PuWHCfTaCoYdLtSz76+t8SgDFtaGaYHO4UUo6i
         VVsA==
X-Forwarded-Encrypted: i=1; AJvYcCXpblHe1Ci3T6PcG7FKfRVUl+7yNiiNiOEvtR53B4W2FgpBvhWRCIIMCV0Ees36AKrSM2Tfngc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUYQTvi/pFdLVLX422q95eT2nB/JisjnKcUJVlHWVLpDIAD6Pm
	zrtdHlBnCJbvxaa4mpzfuncGDb+z+xFERBEaWNyXt4o8pVcLVMYg1fIbG+93nXctWw==
X-Gm-Gg: ASbGncvhXf9o5TOAKMdGQpN/qbvynBSNpvUVGXZeNPGzk5L3AIojk2EEU3nxW1Iel+R
	MHD0hIpLmBwWAPOXHiRr2k5wWRMftRVQ5TLSvcTrqT/MMMxR2bw6Bks2puiTZGcD7tX+wjNIYpd
	r4rWhpYZ1TPOUZDICqz7EQrfys9X0xWHi7O78ADJBk+k38qUti3Jecu5j43GjmIPQO8aPt87zWP
	c+K4/S627wdcBB4v/54CDFAwCOPL4CrUFkqiC4mUddKJLp3+YcEPQLXpiHBfOXOBf3E1jxIGfSo
	LGrOyFhi/Gwavqx4rBA91nvmbGP0aDp7i71P01TGF9YWqc0yHxdHC3nk83wJb1US3eptkYxiIne
	zLvvp+zuWC++TW92e4Pw4y7T/KyvEuuq0pdoYlQWN1+jl3zKC7VwDqQP49N6Rrvw/5VpkJuH4gt
	yyXOg35PQaDr86TmLm2RBwMk1pzXuJSMRYZCA3LTcl/r5Su7uhug==
X-Google-Smtp-Source: AGHT+IGTMkYeA9p+ckKB04IyPeZJ4YUR/HSDsAZGnoL2ifU24s5TxikwdtgZkZDiTjUCKMsk8yADHg==
X-Received: by 2002:a5d:5f94:0:b0:42b:3b55:8917 with SMTP id ffacd0b85a97d-42cc1d0cd7dmr15814872f8f.36.1764069752552;
        Tue, 25 Nov 2025 03:22:32 -0800 (PST)
Received: from google.com (120.54.38.34.bc.googleusercontent.com. [34.38.54.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e598sm33172639f8f.4.2025.11.25.03.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 03:22:32 -0800 (PST)
Date: Tue, 25 Nov 2025 11:22:29 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 21/28] KVM: arm64: Add tracing capability for the pKVM
 hyp
Message-ID: <aSWRdSELuYpAXCM8@google.com>
References: <20251107093840.3779150-1-vdonnefort@google.com>
 <20251107093840.3779150-22-vdonnefort@google.com>
 <86bjkyrly9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjkyrly9.wl-maz@kernel.org>

[...]

> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index f55a9a17d38f..504c3b9caef8 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -29,7 +29,7 @@ hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> >  	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
> >  hyp-obj-y += ../../../kernel/smccc-call.o
> >  hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
> > -hyp-obj-$(CONFIG_PKVM_TRACING) += clock.o
> > +hyp-obj-$(CONFIG_PKVM_TRACING) += clock.o trace.o ../../../../../kernel/trace/simple_ring_buffer.o
> 
> Can we get something less awful here? Surely there is a way to get an
> absolute path from the kbuild infrastructure? $(objtree) springs to
> mind...

Because of the path substitution below, I can't simply use $(objtree) here. I
suppose that's why all other paths above are relative.

However, I could probably simplify by including simple_ring_buffer.c into trace.c:

  diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
  -hyp-obj-$(CONFIG_TRACING) += clock.o trace.o ../../../../../kernel/trace/simple_ring_buffer.o
  +hyp-obj-$(CONFIG_TRACING) += clock.o trace.o
   hyp-obj-y += $(lib-objs)
   
  +# Path to simple_ring_buffer.c
  +CFLAGS_trace.nvhe.o += -I$(objtree)/kernel/trace/
  +
  
  
  diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
  -#include <linux/simple_ring_buffer.h>
  +#include "simple_ring_buffer.c"

> 
> >  hyp-obj-y += $(lib-objs)
> >  
> >  ##
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[...]
