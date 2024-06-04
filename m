Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8700663E
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717517168; cv=none; b=Rh8xDDIK5dTB+c29XToK3iYjXmzm3TytCR0bLflWGu9Njkk8FEoVD7pFrosFrTMQXDHJMuhK3HrIMGMhn7mdZ2ziFnyj0CyaKknck/ZBr6yf0zjXkcy6vjKXpY2OxS+4SO/Wt4qO6Y/0645CEIKUWp49Shpux+Zbnliq8K1U9cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717517168; c=relaxed/simple;
	bh=hM/TP5fuBd2nzlsu3f+H7WQfS62CCwe8Vjt+N5ynidE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UB3nnGXd5+fRl6H6tL9uldE2o0/nF8cqSVpdBkmHqVYJPaOZy2Pt2XZd8ml+bNF6W5Xr+qKMsB0D3N8zSTnCaV4CRgcdh5jna4oRsCq7If1Vl9rdEr2M5gyPiZsmnSkYB5MayTTkKJW2vtmqFNm31Vqf7sffcgu9GfVIGVbFwes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GY6JsTXR; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GY6JsTXR"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-57a5bcfb2d3so1309053a12.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Jun 2024 09:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717517165; x=1718121965; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O5VQrFzKXcacSK2dpPQ1zSM+Xmxoug7aPj+YM5MTTIM=;
        b=GY6JsTXR0Q464q80uO2WdLnKnK5lSXXAHH8Q7rTcwhKiRQy2CC6hCzX54K2BhzZUTi
         +J6XyJEwDa2W88eTxE+qAqFyeqIFht3dKQfxzs1clN0CAx+Nr7FJ28WELUI3um/rn58x
         Y407ACHdKhO08UdkhWa5og3yhADjue1jwYSVORIqmUahrirEDZADNAccgvVkVzVW2BbJ
         Xl7/rzORoVveO0K+jpW8q1pN1LoFK3G4wl5F8cOgtWU1Nykgmu51mELqVlfJnUwuDqGV
         JCI44mRKYR9FV2abeaRUWrU5kQZu/mrfUtQ9eF+HYNgGUcRMrtRWu7NRwq2lUNfn9Ogw
         mdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717517165; x=1718121965;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5VQrFzKXcacSK2dpPQ1zSM+Xmxoug7aPj+YM5MTTIM=;
        b=rY6XsTnUtGu50laOwxz/0uEh+hAc6v4vD2k7lMIvSxDwHrQyfh7VWafP4Nt7Oh/TFH
         DGgSEk88vOzWLbh6X7LfbRrQDfCOQo0YlK4IOiKPG6wJHWzgnXgs0Wvbui67d/wFtsFA
         3L3msvMPTxlkcI5gTw/bxtr1DMXRMTkLEsCuFoq8jD7OCb3deT/icNpdOuXFug2+7DB/
         4VG5wLVxZJ7HcblTvTH59q8p3h0ix5XoTrIKEc/m2Utycq/qAatRjWUX1kKfcg//qqNo
         22w/yGMz7+xHbL61yjDk9ey/0gbIGYafdKcPl35Wkg3NL/Th/VWgyg7j+D5atxincMfr
         dyIw==
X-Gm-Message-State: AOJu0Yw5ZFD38/osr/hT1WQBzdg9x2BwzK9vXXZxR1SS5qmbK5L597pg
	4TL4TqORQgJ5VEvBWGqIcmp4MqCydHawIIswqlsFPkug9uzuP3jXRaOjPcpBhLbyENfV5vbdZoX
	ofRQS
X-Google-Smtp-Source: AGHT+IHjTOc77+v/hrh0//KfOPrghR8jLt/wXqgk/viqeRim9KBVvb5lrLhNkC2Y9ObA7kv+S1+hbA==
X-Received: by 2002:a50:cd9a:0:b0:57a:30fb:576 with SMTP id 4fb4d7f45d1cf-57a8b69704fmr73029a12.8.1717517164535;
        Tue, 04 Jun 2024 09:06:04 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31c6d270sm7488617a12.60.2024.06.04.09.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:06:03 -0700 (PDT)
Date: Tue, 4 Jun 2024 17:05:59 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 11/13] KVM: arm64: Improve CONFIG_CFI_CLANG error
 message
Message-ID: <whzwqltolrms4ct35az5eif5rg25e2km23cztypgikallbcxoj@wtwfckujzcrf>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-12-ptosi@google.com>
 <20240603144808.GL19151@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603144808.GL19151@willie-the-truck>

On Mon, Jun 03, 2024 at 03:48:08PM +0100, Will Deacon wrote:
> On Wed, May 29, 2024 at 01:12:17PM +0100, Pierre-Clément Tosi wrote:
> > For kCFI, the compiler encodes in the immediate of the BRK (which the
> > CPU places in ESR_ELx) the indices of the two registers it used to hold
> > (resp.) the function pointer and expected type. Therefore, the kCFI
> > handler must be able to parse the contents of the register file at the
> > point where the exception was triggered.
> > 
> > To achieve this, introduce a new hypervisor panic path that first stores
> > the CPU context in the per-CPU kvm_hyp_ctxt before calling (directly or
> > indirectly) hyp_panic() and execute it from all EL2 synchronous
> > exception handlers i.e.
> > 
> > - call it directly in host_el2_sync_vect (__kvm_hyp_host_vector, EL2t&h)
> > - call it directly in el2t_sync_invalid (__kvm_hyp_vector, EL2t)
> > - set ELR_EL2 to it in el2_sync (__kvm_hyp_vector, EL2h), which ERETs
> > 
> > Teach hyp_panic() to decode the kCFI ESR and extract the target and type
> > from the saved CPU context. In VHE, use that information to panic() with
> > a specialized error message. In nVHE, only report it if the host (EL1)
> > has access to the saved CPU context i.e. iff CONFIG_NVHE_EL2_DEBUG=y,
> > which aligns with the behavior of CONFIG_PROTECTED_NVHE_STACKTRACE.
> > 
> > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > ---
> >  arch/arm64/kvm/handle_exit.c            | 30 +++++++++++++++++++++++--
> >  arch/arm64/kvm/hyp/entry.S              | 24 +++++++++++++++++++-
> >  arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
> >  arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
> >  arch/arm64/kvm/hyp/vhe/switch.c         | 26 +++++++++++++++++++--
> >  6 files changed, 79 insertions(+), 9 deletions(-)
> 
> This quite a lot of work just to print out some opaque type numbers
> when CONFIG_NVHE_EL2_DEBUG=y. Is it really worth it? How would I use
> this information to debug an otherwise undebuggable kcfi failure at EL2?

The type ID alone might not be worth it but what about the target?

In my experience, non-malicious kCFI failures are often caused by an issue with
the callee, not the caller. Without this patch, only the source of the exception
is reported but, with it, the panic handler also prints the kCFI target (i.e.
value of the function pointer) as a symbol.

With the infrastructure for the target in place, it isn't much more work to also
report the type ID. Although it is rarely informative (as you noted), there are
some situations where it can still be useful e.g. if reported as zero and/or has
been corrupted and does not match its value from the ELF.
