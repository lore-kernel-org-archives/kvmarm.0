Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6403B42C7
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 08:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374002; cv=none; b=TZXsxPZrbMQ9STgsDqZUC7Dy76qV7j1Jry0pL1044Ln7J2qqoljuFm5vWu0I4JR4550SzZoAa4ZU+kIckfrhocXNY4rK6kmGMlsdgUKONQwL3erTneMNxrhIAeVI6KdweKZQ0wI2cmhsJquFq0jtiPgJlGyVLmT95d6MCOgqci8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374002; c=relaxed/simple;
	bh=izHWduGA3qo4L4/PtjV4AW1D0r/sHQXHqiRNxba8CbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+Mo8pLSG62PPZfHZyByOaoVe6nL7B1vGPEvZeA3nmmNUG4u6HSlD0yvev7Xff/rZ5h4CUTdCg71zXyDFG0mBPGCJJt62C+EnYi6/xwBz1IsHtR2OyCUfCaKp25StLTirP7+PEFpu+VuTLhFxXQposKeYNd5F8DW7+RuePYqPHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Te313Qkr; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Te313Qkr"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a56so209852566b.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 01:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789373999; x=1789978799; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xUV02DPENLr5XEFdpQfIybzrUh+RnORP9zMn9lchDDk=;
        b=Te313QkrwlIQVI3NwbGVSPkqRHqfULPB/qeeyAqDPSA61W6nDwpEfOvsVn4Ewez2fO
         kH+QfbEOsfM9Ut7hYM/mgFLVM//lhSr7zFxb8nVWXR+ntGb6fg60oKukqcGelD/DrBBk
         kjBpaL5wz3oZX0OHH8pbFP+Helj9TB8W0lj/J0cQrs6guEknRKLn13fuJo8/J6rKvSJM
         QUqQ14XBbEUkgpGu97Vy+MQSStREMqVTE18cUdQf1jBntOLHDmwElE+9MyrKcr89HvZq
         XGemIttl93oGfdY0O96M4foi0eJ/7fOomD2e7veldOKgUcnncRUf1/JU45NP53fmCPGx
         rJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789373999; x=1789978799;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xUV02DPENLr5XEFdpQfIybzrUh+RnORP9zMn9lchDDk=;
        b=jbk7DqUJlOHoxPwU2VKAdxi8hQM5PFRchPUSnbm/UnM9hXTkVyFnz4ItC6POMc34DI
         nhkKETQmPzv3nWCKYA9mibmDY+d37vrWhzqecJuNqD345/Y8auHQr7tIxT1pGLrRyjZM
         gKKMcxmMOIv+W1Denx1JcmiSbjU3YxPnUGKyXhIEDnQA4i19Vw+6u6MdiOlUHs9A+47d
         I7XOnw1QU+iaQm42MawSPDdjgx1DPhGtFUv0F1d/2FLBuSx2BSpZu+E/adBS66oX1jUx
         M/nIWQUAzvCXpr46PVFfBOmuonDRdQ925tfXP+7wxY9lhAfovJXpeipk1ZdOwUXW79aJ
         US1Q==
X-Gm-Message-State: AFuF++mviYKkhsUQAO9BBYmvvK5ox42Dl+sgPUeEz4qYYkIZgYL9vVfl
	WtRkXJ+nK/8ARAeyc7H0iXoeIF+5qCEWyL8LT6k6PRSJMd3fDDEnFlJr8xpm84AIOQ==
X-Gm-Gg: AYBFou1R2b/jZJ9nYpd8SI2114Gf+dPv1xl8YjyQiFmyXugeapYL9NafuIdoxqVl3dG
	k2nvnyQ+B87MSHrYy5RDf/HDd4X79QUf6zgCM3oeU6TF+33gGFYPDdLmtL4s6YS+fTkj9xN1p2z
	Ynqz8yIVdjK0AdiQ1sOLnqddGurU/KwNX0Ksi1KEs7nmwbb0vzt5ugY6sbpZQ5ABRm5FjFT1dP9
	gxeNAYE8wZOIYV/tpeqqVChDeNQjejBfrCMOhB1km8JqMBiothbhJhQVmcnHMNfoTSD463eIuwI
	MMDWTOBjHUIZ6dqBzC+G442PYAO1hyIKzGZX7v5Vltzc+naTO1QRIEgw37UXv6baCYfFIdKqzR9
	ecc+AzdXFzItZWYZm8ZkWc2YogWD8Lh3d4DMEZqkQtcMQKm02GJIxhNdB5uvYtK2GF3HBwVlUjS
	C0mlTTF9CkEnoM8s2JlJ0BOz5SRPdSdIwhSmynQ9aP7Q+lUmRqK0Y7obuwStV+OBklTlW/nbLIU
	E/23Fxjrz33cNRX+ihcg+IAHLKDOWpp71ZH+sL8gSA=
X-Received: by 2002:a17:906:8d8b:b0:c26:2b63:a746 with SMTP id a640c23a62f3a-c29b875c08fmr80332166b.49.1789373998141;
        Mon, 14 Sep 2026 01:19:58 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29660ff398sm405554066b.48.2026.09.14.01.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 01:19:57 -0700 (PDT)
Date: Mon, 14 Sep 2026 09:19:53 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Fix protected VM fault on system with
 pages larger than 4K
Message-ID: <aqeuKWRMqxxSE4Jl@google.com>
References: <20260914075839.4019904-1-vdonnefort@google.com>
 <20260914081343.4FF891F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260914081343.4FF891F000FF@smtp.kernel.org>

On Mon, Sep 14, 2026 at 08:13:42AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The patch incorrectly maps the guest PA (L1 IPA) instead of the guest IPA (L2 IPA) in the shadow stage-2 page tables for nested VMs in `gmem_abort()`.
> --
> 
> commit 3995ce8aa44bf10fe23cdc5e9257510868df129d
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Fix protected VM fault on system with pages larger than 4K
> 
> This commit aligns the fault IPA down to the page-size for protected VMs to
> fix boot issues on systems with larger than 4K pages. It updates
> pkvm_pgtable_stage2_map() to require page-aligned arguments and changes the
> callers to pass gfn_to_gpa(gfn) instead of the raw fault_ipa.
> 
> Link: https://lore.kernel.org/all/20260913173516.3122436-1-vdonnefort@google.com/
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 9ba86450fe4af..ee78201a44df1 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1672,10 +1672,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  		 * PTE, which will be preserved.
> >  		 */
> >  		prot &= ~KVM_NV_GUEST_MAP_SZ;
> > -		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
> > +		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
> >  								 prot, flags);
> >  	} else {
> > -		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> > +		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), PAGE_SIZE,
> >  							 __pfn_to_phys(pfn), prot,
> >  							 memcache, flags);
> >  	}
> 
> [Severity: High]
> Does this change break nested virtualization by mapping the guest PA (L1 IPA)
> instead of the faulting guest IPA (L2 IPA)?
> 
> For nested VMs handled in gmem_abort(), gfn represents the L1 IPA. By
> switching from s2fd->fault_ipa to gfn_to_gpa(gfn) in both
> kvm_pgtable_stage2_relax_perms() and kvm_pgtable_stage2_map(), the shadow
> stage-2 page tables now incorrectly install the mapping at the L1 IPA instead
> of the expected L2 IPA.
> 
> This results in the L2 guest continuously faulting at the same L2 IPA, leading
> to an infinite fault loop (DoS for the nested guest) and shadow page table
> corruption. 
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260914075839.4019904-1-vdonnefort@google.com?part=1

That's indeed not possible to use gfn in gmem_abort() 

So I guess ALIGN_DOWN(s2fd->fault_ipa, PAGE_SIZE) will do.

-- 
Vincent
