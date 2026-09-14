Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9A9415B60
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 08:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375323; cv=none; b=dsrjz4fmj9tsc+UqAKn1N1DENrEaNa3fKTdsZ16oEHz3EnXD0aUd09CQ0URctAOQq/nFvpFHQ8bT/B1glkg+dfGwHMtKobRBi238JaPAjSzJouTGJWqX/qhbFjxAAg+R6RvE4I54J+zy4Ps7ehW35uEG+eNIP6c5sKTR1Pmmceo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375323; c=relaxed/simple;
	bh=0Fi0ICRhKWlf5JqHvn4oppoFNf2YfZisroOCVcFgLtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UxaU8O2wMB4t3a7ZaxrQAQoK6Fgo8Rk4FtZJYSditYdnl1KyNICt90jlYT596P7hYpTGP9tRl30TxbXwcDvEYqV53w4HI8yrhosZidvtOkJ5vIHPtd6AZq8u41Ti58Iv1bAhRBaCJcZSkIi4hXKdkIjP8B2POtNCNs1Wub+dwoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SEfatouw; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SEfatouw"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so5719175e9.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 01:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789375311; x=1789980111; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IZYe0H/DkNs3S1y5Hj6oAegp5W2rxwzj7DXdbHt4+9Y=;
        b=SEfatouwgbtwtsUmBP8HxAgxbnJivQu8pDLobIBq7VPbP0DTlQ3gu4Zj4p6y79g2Ou
         7xktMice2caVRJ3nFAK3TWPBZds9n/8IsM8ae5nRzj1KFDofnxSj5LmuzzCbDkZp8KDa
         NiQ7yIeCyUPB4rFxCUJzWPoW/mujlsaE0RhmTaCjDOGdOnsH9o6RBFu2OdxGPYNht9y4
         cYxEsW5IOCsMM6JQSKbg0H9ZdX9T4/Q6sepXLCd76M4kToJgJEBqrDiV5R6PTOyuCPD7
         oR9enZRd+xHrvJ6CVE8AVee581FHcza+AfL9IP3nIayYjZDNnRn2mqAmv/V8BAmje/J1
         scWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789375311; x=1789980111;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IZYe0H/DkNs3S1y5Hj6oAegp5W2rxwzj7DXdbHt4+9Y=;
        b=Sg5CzszXKRnN3zIdquzite1vrWajTYFV4Z1zr9df9t6TG1JGkhvXVYNr20PDLUwVLZ
         dZtVJIDYu4xVESJBE+GydcZskkUqJiIeZdpapp1XBVb4mK02WG/nrroWUM2qJ2zsiwzR
         IIFh5zsSDWHDzi0UZ6r0clcOfpY7dkfRxNOFoUPFS/N5IufXKySYDn6U+ABWA/i7s/6b
         m4NnRrALfIK2V+L2FxyXnhY2mLkDLEYie52T6MiymbPC7lDB8hpI/tBUk8Sms4XGg0Ft
         5kClzuihIeWkyBdQWrOgOSxzO9ryS3VAbMWizIQlqZVCuuEBYN1Gd1pKb2HBexXFs4OG
         KSTQ==
X-Forwarded-Encrypted: i=1; AKwUvByFDkgnGS7Et/Lfx+fFmk3kw8EdwFxwKZ3YDr9KUy6r4LY2TTFGtWudFHdeiozUAz7pr9id8co=@lists.linux.dev
X-Gm-Message-State: AFuF++nwhaOSlRxKxZHOUZ4FgrFBRRbG1IgJhyLncYZOjDB/rlzgZveL
	NSmneVQKYxB0rI50W3s201tElLqgtSLBmGfdlNT+M334G1pYuQEn/IgswKfTn8xfGi/JBftpm5C
	GHGIlRQ==
X-Gm-Gg: AYBFou3JuozyA4M1rjoyjPsl9R5OSiIaVLTrZYDbiOdJJdTWMnwYXtaPgIXxrn+jFTa
	mz//ncoHQl2NwoYfiBUsl0zWOlBKVQBXsFj4SNxDDmLB21bMAGnfyhH+NvM6+1A/XeCY5mLgXKj
	ZXvLnlbzGsr/+pWYZ3GHvx1qGrAHFBFFgwuuRmLb87lsdIihs+HN8H6In9eje8afp1BGlKcSWEt
	Nohe4+ZfI6dj/osKzlhvduW534F5crtRu1ImSKhIRmUwJYBFvW6rWJbqyU8WsVsbM9blw+5ZBy8
	Zd1hXo2xQ1vXeh38BH8gGCVTFS0sMpxz/+VQA/St8mTw0rJY8MeHaoPzgWRbw2vn7qexdDCiOPN
	NRJFNvE17mkOi/ROXN3PQPMv3wmctDRnVuIz6yx3+AAxD+RRtHyPlyBKHeCKN4HWAtSBgZ8QuHV
	FWk541p0HP782xXNynk5Ueo0viKfVTzgAKPLviRShPM8v347FlcnyGLMwK0b/Z/GlXMu343SxkU
	oY8hs436sKgqVT2HhVwbHHO+dwCriuW84twRhaSxFg=
X-Received: by 2002:a05:600c:3b9a:b0:49c:ffde:45ff with SMTP id 5b1f17b1804b1-49e7a66b656mr16287655e9.17.1789375310790;
        Mon, 14 Sep 2026 01:41:50 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35bed0sm25945683f8f.32.2026.09.14.01.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 01:41:50 -0700 (PDT)
Date: Mon, 14 Sep 2026 09:41:46 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com
Subject: Re: [PATCH v2] KVM: arm64: Fix protected VM fault on system with
 pages larger than 4K
Message-ID: <aqezSgNz55DzInH0@google.com>
References: <20260914075839.4019904-1-vdonnefort@google.com>
 <864ifs6xn4.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864ifs6xn4.wl-maz@kernel.org>

On Mon, Sep 14, 2026 at 09:32:47AM +0100, Marc Zyngier wrote:
> On Mon, 14 Sep 2026 08:58:39 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > Just like commit 08f97454b7fa ("KVM: arm64: Fix protected mode handling
> > of pages larger than 4kB") fixed the boot of non-protected VMs on system
> > larger than 4K pages, align the fault IPA down to the page-size for
> > protected VMs.
> > 
> > To paraphrase Marc, pkvm_pgtable_stage2_map() assumes the address passed
> > as a parameter is aligned to the size of the intended mapping, while
> > HPFAR_EL2 gives the IPA minus the bottom 12 bits, regardless of the
> > system page size configuration.
> > 
> > Add a check at the start of pkvm_pgtable_stage2_map() as we do not
> > support !PAGE_ALIGNED arguments and use the gfn as an argument in all
> > callers.
> > 
> > Fixes: ea03466e806f ("KVM: arm64: Handle aborts from protected VMs")
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > ---
> > 
> > Changelog:
> > 
> > v2:
> >   - Use gfn_to_gpa(gfn)
> >   - Drop "phys" from the PAGE_ALIGNED check, it isn't a requirement.
> >   - Fix gmem_abort() as well (Sashiko)
> > 
> > v1: https://lore.kernel.org/all/20260913173516.3122436-1-vdonnefort@google.com/
> > 
> >  arch/arm64/kvm/mmu.c  | 7 ++++---
> >  arch/arm64/kvm/pkvm.c | 3 +++
> >  2 files changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 9ba86450fe4a..ee78201a44df 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1672,10 +1672,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  		 * PTE, which will be preserved.
> >  		 */
> 
> Context:
> 
> 	if (s2fd->nested)
> 		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
> 	else
> 		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
> 
> [...]
> 
> >  		prot &= ~KVM_NV_GUEST_MAP_SZ;
> > -		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
> > +		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
> >  								 prot, flags);
> >  	} else {
> > -		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> > +		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), PAGE_SIZE,
> >  							 __pfn_to_phys(pfn), prot,
> >  							 memcache, flags);
> 
> So 'gfn' is not related to the faulting IPA in the nested case, but is
> the output address of the guest's own S2. You probably end-up with a
> livelock handling the same fault forever, or worse.
> 
> It is a bit annoying that neither gmem nor pkvm are using
> kvm_s2_fault_vma_info, which has the ability to reports all the
> important stuff, as it would avoid this sort of bugs.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Using kvm_s2_fault_vma_info would surely help the THP support for protected VMs
[1]. I am thinking now about bringing it as part of that series.

However for a fix, that's a bit much?

[1] https://lore.kernel.org/all/20260911135053.146435-23-vdonnefort@google.com/

-- 
Vincent
