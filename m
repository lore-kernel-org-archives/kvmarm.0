Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CD947126B
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 14:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397042; cv=none; b=hB4dOVF0kyEZdN2UyU0aDGxaUYKygjWuUGSqZy+sHkzzrIIcs4T3axxi+KHEx2ZMwmQueRq0AwYd64PMwxsWbLufIUCrCYdsc0asUjaOqtYHNe5nWnnBo0yyUo6jQ4+hg7U05nKa9twfV1InMZ5To7i0N8u8l5YBhxayHmBzW/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397042; c=relaxed/simple;
	bh=ZOxEFV6yKVa+U+wttltPLAq7YKcnlIAuux7OwLuKqMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BHbuCpBVhQiBvwTMBto3E6Hj5Hd8l3k0SBVXKeC6eHMmOQPMinfJk/gSaOku1PqULiDTZNAWU97e6nip+gxY69zuJQ7N1H97jzCbPyn2N84sMOR6GsSddUU+NzULQOH4rsvG4noQmPOkaovVOWBQM/9y4o705uaK2wkgavynR98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wvmibsLh; arc=none smtp.client-ip=91.218.175.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wvmibsLh"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZOxEFV6yKVa+U+wttltPLAq7YKcnlIAuux7OwLuKqMI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789397037; v=1; x=1790001837;
 b=wvmibsLh5euIm+EX2e8EuQmLcO+WK0UDNnUjPd+SNMh6UGYsywEI4s1uoD768thhldVGjFHE
 DB6N3su8UTgT/R7NwYV46xKMTq21uxLR7GOeCLCCpusx7oSofUBSCm9Aul2B0UMgIP7cgsDcnX9
 plKEbVQD+7NdhVMi9+zK1LRs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3748073340fb3012;
	Mon, 14 Sep 2026 14:43:57 +0000
X-Mizu-Trace-ID: 3748073340fb3012
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so8492e87.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:43:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwa3VQCpdbEAwM6bx+kVWuw66//xqNWZSYVJTRvBtXEilp2eMScn/kw/sRanbyg72YbROqmnWo=@lists.linux.dev
X-Gm-Message-State: AFuF++naLa8CkxdlOfmYMPX++ieU/ZktL0s0BbKL9FwKdMAPPt2NkpNM
	l4rhycZbZJQktv/GNtzyteBaAjNAorJkPksGZAN2Vb1KTv5dj6pa44DlUgmH2n6wzru8u9ZxW3R
	+DhYEZsFppIwpDucb51NOzXjf3kep5P7+w6QC+Z3x
X-Received: by 2002:a05:6512:1555:b0:5b1:5e30:ab4d with SMTP id
 2adb3069b0e04-5b8af7a5089mr55808e87.5.1789397032407; Mon, 14 Sep 2026
 07:43:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-13-fuad.tabba@linux.dev>
 <8633vc6jag.wl-maz@kernel.org>
In-Reply-To: <8633vc6jag.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 15:43:16 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy6F9tG=eRLMuykc12P-Oc2pjMoQqAz34iGR+Q5GzV2jQ@mail.gmail.com>
X-Gm-Features: AcwNN1VwPAYbkVlaO1umpV1hjCIFKM3lgcDxKxOZL3M7XeNBLkF2CpyyCPMyBJY
Message-ID: <CA+EHjTy6F9tG=eRLMuykc12P-Oc2pjMoQqAz34iGR+Q5GzV2jQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/18] KVM: arm64: Prevent host PC adjustments for
 protected vCPUs
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 14 Sept 2026 at 14:42, Marc Zyngier <maz@kernel.org> wrote:
[...]
> nit: it is really odd to see this 'pkvm' prefix in generic code. The
> point of it is not only to abstract the pvkm complexity away, but also
> to have a wrapper that may be of use in other situations.
>
> Don't respin the series just for this though, I may end-up changing
> this when applying it.

Agree, if I respin I'll rename it.

[...]

> > +   hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> > +   if (!hyp_vcpu || hyp_vcpu->host_vcpu != vcpu)
>
> Under which circumstances do we get hyp_vcpu->host_vcpu != vcpu?

When EL2 calls __kvm_adjust_pc() on the hyp vCPU itself:
__kvm_vcpu_run() at guest entry and inject_sync64() in nvhe/sys_regs.c
both pass &hyp_vcpu->vcpu. There the vCPU passed is the one to adjust,
so it's returned as is.

> > +   if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +           return NULL;
>
> Is it always the case that a protected vcpu cannot see its PC adjusted
> at all? How is PC updated after an exit for MMIO? I feel there is an
> interaction with the above, but I'm not 100% certain...

The host can't adjust it directly, EL2 applies the host's request at
the next entry. For MMIO, handle_pvm_exit_dabt() sets mmio_needed on
the hyp vCPU from EL2's own syndrome, the host completes the access
and kvm_handle_mmio_return() sets INCREMENT_PC on the host copy, and
handle_pvm_entry_dabt() increments the hyp vCPU's PC at the next entry
if EL2 had an MMIO pending, through the &hyp_vcpu->vcpu case above.

The NULL return clears nothing, so the request stays on the host copy
for that entry. It's reached from the epilogue of
kvm_arch_vcpu_ioctl_run(), e.g. an MMIO completed on an immediate_exit
run, and consuming it on the host copy there would clear INCREMENT_PC
before EL2 sees it, so the guest would re-execute the access.

"Drop" in the commit message and the adjust_pc.h comment reads as
losing the request. I'll reword if I respin.

Cheers,
/fuad
