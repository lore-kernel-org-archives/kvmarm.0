Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB4A182AE
	for <kvmarm@lists.linux.dev>; Fri, 15 Mar 2024 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710498148; cv=none; b=ZJzp6h/6kpe/wTtOdb8uJp6UxV+ymYLg6wFZA/kx42FPBE+nhfA1WV4rlMbQHRZNRlU757Ave2Xhny9MSl0aKFG0ekbc3DapDIluTIgGF9DocoGNN+B7AWHAKpYJOOKJwERPQmm5jAty4Slk2WlEVqo5O9JiMgqTClmCOVoASPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710498148; c=relaxed/simple;
	bh=5U2FdyBJ9x2N/ZT3lykt6b/ppnU43zp52hERVtbnd4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKJE8IaYq8NF9AXG1drd3GVrLYlliYuORtRKuRZZdeYaDYH91Sln1JTj5cyBVHh9ZSdUm9uBjcOvAqt9TWkKvBIdYuQYdlx9vJNReS+t4Jupg7gk+ZmUzsv2qjsYJeT/PygXuXy9qD5mfcM8arZ76nfFceVS9VpxIRsTqN3brG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MKSW+tZH; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MKSW+tZH"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-513cfd48224so2616358e87.2
        for <kvmarm@lists.linux.dev>; Fri, 15 Mar 2024 03:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710498145; x=1711102945; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4hKS13cZNwTAuS0CQMQLil3nPF8VhVj/moqaBbt3e4Q=;
        b=MKSW+tZHnaoZd1nwJxoZ0wyxqNmDypP/t+2ErVH3aNKMYy9eFSz+lZDJdUNNMuea/F
         qoSHn9+CoTEcD8eD7arTgWn9NK0pGwPXQqN0JA2SA5WUBbIwjmoZUZ6O4oV520LJQXLj
         QkLvCciLxu0s/NWrgPHqqMRr5Vhna8S6kxvrp7ysCvtCWECb5eBJaPdTXE1fZPr8Y8fq
         u1ZnkhRHpJWtstT4GM4SIz/CCEdNVHKcl34EPvBOgCy7NDvXp5mrTUo2Y5m72R37V81x
         2Lw4bV5vBiNZGLGUgRXclRR0DqtfQ8mvlYpeCdbxTYBGwG3UtDUyQn58sOAK6+FDGRmv
         fqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710498145; x=1711102945;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4hKS13cZNwTAuS0CQMQLil3nPF8VhVj/moqaBbt3e4Q=;
        b=pI0r4a+J2OAD+j+OJ0ZLwgHAigMrm/ngjYFsGYlTsv2Txb9jCe8KQQXXLfUy1haKwT
         LYkeLlGoIN1DuOpZ6VWUbTU7Hd1j3+IUKR04ol8g4BVUmUkMJ3DctURksvKCbT4YpFc1
         3wW1eRvJj2GMRgGhnwHoqsdHi5tMyBdckaW9F7TZjbTxBr2NdN8v+44KjCbQdM8kXKjK
         2TXapNvqhvWiUfqM98X/OcWgZg8CzFcXPMHFMbQ2O/7wRk1oR0C0zeelpYLg96Vc/hrs
         4HtfUM4+TOJcriMb4QPbbRdVXHt0q0P2VMtrhce7kO7ySO6bfvENY9xGsncMwryToVf7
         1LcA==
X-Gm-Message-State: AOJu0YxHazyZZDJzcyX9rqZQYkKOW1eJvcaUw4u+CoLbVSN6bTdGUs0q
	2y2DgpdaNNJaXOu/LWID1WsH0+OAjOTr8vlzbN8+E726TUp/KaOqq7+NhvlDSQ==
X-Google-Smtp-Source: AGHT+IED8mmZANKTy9MzOwavrd3Hatz/1kDglj3tvY7tFGNBe5aHeRsc9tnZUPRJMEZX60J8/tNElQ==
X-Received: by 2002:a05:6512:10d4:b0:513:db29:8905 with SMTP id k20-20020a05651210d400b00513db298905mr1317908lfg.69.1710498145116;
        Fri, 15 Mar 2024 03:22:25 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id v23-20020a1709067d9700b00a461a7ba686sm1578047ejo.75.2024.03.15.03.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 03:22:24 -0700 (PDT)
Date: Fri, 15 Mar 2024 10:22:16 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 00/10] KVM: arm64: Add support for hypervisor kCFI
Message-ID: <wlkwdcati2klte4u3xvjiacf7hbuvupd2gksaa6ekjgfjuiy7j@7jvkv45iwdkx>
References: <cover.1710446682.git.ptosi@google.com>
 <86edcc1low.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86edcc1low.wl-maz@kernel.org>

Hi Marc,

On Thu, Mar 14, 2024 at 10:40:47PM +0000, Marc Zyngier wrote:
> Hi Pierre-Clément,
> 
> On Thu, 14 Mar 2024 20:23:00 +0000,
> Pierre-Clément Tosi <ptosi@google.com> wrote:
> > 
> > CONFIG_CFI_CLANG ("kernel Control Flow Integrity") makes the compiler inject
> > runtime type checks before any indirect function call. On AArch64, it generates
> > a BRK instruction to be executed on type mismatch and encodes the indices of the
> > registers holding the branch target and expected type in the immediate of the
> > instruction. As a result, a synchronous exception gets triggered on kCFI failure
> > and the fault handler can retrieve the immediate (and indices) from ESR_ELx.
> > 
> > This feature has been supported at EL1 ("host") since it was introduced by
> > b26e484b8bb3 ("arm64: Add CFI error handling"), where cfi_handler() decodes
> > ESR_EL1, giving informative panic messages such as
> > 
> >   [   21.885179] CFI failure at lkdtm_indirect_call+0x2c/0x44 [lkdtm]
> >   (target: lkdtm_increment_int+0x0/0x1c [lkdtm]; expected type: 0x7e0c52a)
> >   [   21.886593] Internal error: Oops - CFI: 0 [#1] PREEMPT SMP
> > 
> > However, it is not or only partially supported at EL2: in nVHE (or pKVM),
> > CONFIG_CFI_CLANG gets filtered out at build time, preventing the compiler from
> > injecting the checks. In VHE (or hVHE), EL2 code gets compiled with the checks
> 
> Are you sure about hVHE? hVHE is essentially the nVHE object running
> with a slightly different HCR_EL2 configuration. So if you don't have
> the checks in the nVHE code, you don't have them for hVHE either.

No, I am not and my assumption that hVHE was running the VHE hyp code was wrong.
FYI, these patches were tested in VHE, nVHE, and pKVM (with NVHE_EL2_DEBUG set
and unset) but not in hVHE (clearly!). Thanks for pointing this out.

> 
> Or am I missing something obvious?
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

-- 
Pierre
