Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645AF3B9949
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 08:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784623373; cv=none; b=WmFDyRtMaARidKJ+pBcG2aXeKvKolHTLNjhxrEWesy+llZba5fovsLKgU0iBTkeHrF7obmTi6CWLSCrNhvDURl8DqQJ0a8n4fmwM7bCUaCGmgweBmi6RL06zFqQWqKBUieZ2zc0eaV2+zy/YbKxaDDMFDG1iR4xLTV+Y2ynYtiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784623373; c=relaxed/simple;
	bh=HUIGo3Rn1Vrg89tTohSZukqtXGYTPYfLx2A27acqApw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDVDmO+igmgvST4+bhBU4OAEHu2urRQmC6JqcJRP9MEG50pOdROwHyQRmZjg9x8KwjFBYwqdLw8V5OyrwXMF7PEx3QjH2yvW5ISC5iavkayBvaG1HpalTkk4nuG1gAxiwhT4duPS64qyEgm7IGuWVzu9snNISyovPiI0bEL4iFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uJ3lbL0K; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uJ3lbL0K"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-698b78c05b0so45218a12.1
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 01:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784623369; x=1785228169; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OshMXjh7Cgoor6MMiGrVEQRdUgGOjdKbShq5C0Pf5vg=;
        b=uJ3lbL0KLf0QQhk2vFAo30ykcnF9mdsIH/O6xBZLFwZ1xrrn/G1TFHoD6tGBXo3X3Y
         dVC1bbDdmZcltHFT9+ft7VGjjfGVqQsJWEqjpf0EGdhXJQMLTI9p6EB9kxPMVJ4K5Z7R
         XXyoPdTNa0Gy0Sm3QNlSo/86HPya2zNguUUYSJLTGkreMj18NVpJJeaG6rhwHxyji4uX
         HZ+YPE1On72ZWSzzJElNQTRJVCmyIczUNfPpOg1zW0amCH/K1w6P9osYlqV19VPgQNoy
         gzRFuvlHZK3kgIL/c16tCLFaUNX1fOQsP+tlVgKKZWyGNLEf/G7bdyBcqMh3T8VdBw/M
         GNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784623369; x=1785228169;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OshMXjh7Cgoor6MMiGrVEQRdUgGOjdKbShq5C0Pf5vg=;
        b=E3pX//rwRLGE1jAGn5mWzVYlphxXzAKm6gL4akodXO+BYdwUzmU/nkwGInGVOm2cPj
         LrIQ4Lx2oJiH78fYbgc/QrabKHNxCfXxoTIpW57EXxr031vtETzcm9oLht9NG1lz8pUE
         1T44/PDQqBo6gsPXjI/n5iqKkGvF+WFHuAJUa+qNnjqf5k8b+IppOFBY0GxQZKNR1Hxw
         g+/7wvnD0BDXJB9ro2VChEXiJIW+XkkQbwyQ3wpLJbbB6/eBstckCJBeq5H+7OMr/JPm
         iFcFczhA7ExaVu1T1dFIlo6CjlQALTFeM46YbBJsGMuRh6Blt+TP17SmsbPAM5F/Chyo
         ZMLg==
X-Forwarded-Encrypted: i=1; AHgh+RriOqM/o/VqXH4vt0629oVHZRB448002q1QAVBxhoUbw0Pv2sejbciKbyiHZsxG5eM8mpbpq/U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIV210Qksy3YBWGlfmN3DZ3okboD4x9icICfuq37Yp7Sh4vWYI
	0/8WKUukHTJX9PnkElrLNmYC88aq9zffjenZNPlmP8+yB75vacaWg7Og7F0tyQkVCg==
X-Gm-Gg: AR+sD13qSGfecH1KW7GiST+i6nLOp1af8dXA3JxcLdiGIJi5KcsvZcIuLljZr8eeumx
	/9wdEw3lOB+aLxhhKIH8ed3RjJb3uLUfAcK41rCwQRZ7HHjtayJPPSFL3dCyArxlhNT1cU/iBN+
	PW3ldQzqVIrhcCXcsdbTQQDcITLEiwN7NFRgGXR4xLA86O0lZLaHvGEZhR8yXUWU3Z8/PHPoQhz
	kCGTBoTpkF6nbEWbJKD+WiOaa6g9byQOE59Z7PwS6fCxBaDEIM5T5+xpxWDVAkn9aoZ6XU5fwOZ
	jqXU7kyYBXDBT2aSfp+jvt2rEAnO3jo/DITSx5BSN21NvMlcuY/yW0DV15OapEzs9OzMyLE9BGF
	96kbfCnEKZkKqSf13HO25bmt9GpGx+DuFJlXLveM7GLUk3+rgXM+8YVfp7E5VjKxbPA1lsHyYBT
	gEWzCUmTtW18zpGmFKCATkOp24wKVwncwTKIR6DDUYzCnPECzu
X-Received: by 2002:aa7:dd03:0:b0:69e:98c8:e958 with SMTP id 4fb4d7f45d1cf-69ef509967emr74880a12.7.1784623369037;
        Tue, 21 Jul 2026 01:42:49 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1705a0a4c2sm566318166b.16.2026.07.21.01.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 01:42:45 -0700 (PDT)
Date: Tue, 21 Jul 2026 08:42:39 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH] KVM: arm64: Optimize protected mode and FWB
Message-ID: <al8w_5ogFQgt7ZFe@google.com>
References: <20260720203529.1276355-1-smostafa@google.com>
 <CA+EHjTw+BypEvWRccxqsSGR+btEX58nCUC2ypuSjw04Qo3nN=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw+BypEvWRccxqsSGR+btEX58nCUC2ypuSjw04Qo3nN=A@mail.gmail.com>

On Tue, Jul 21, 2026 at 08:49:26AM +0100, Fuad Tabba wrote:
> On Mon, 20 Jul 2026 at 21:35, Mostafa Saleh <smostafa@google.com> wrote:
> >
> > KVM opportunistically enables FWB if supported by the system for guest
> > VMs, which allows it to elude cache maintenance for data as they are
> > forced to be cacheable from stage-2.
> > In that case, __clean_dcache_guest_page() will immediately return.
> > However in protected mode, before calling __clean_dcache_guest_page()
> > it loops over the range and fix_map/unmap it, issuing TLB
> > invalidations, dsb() and isb() unnecessarily.
> >
> > This can be optimized by returning early if FWB is supported,
> > kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
> > functions issue dsb() for the unmap path.
> >
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 4e329e39a695..6e9229106a25 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -261,6 +261,10 @@ static void __apply_guest_page(void *va, size_t size,
> >
> >  static void clean_dcache_guest_page(void *va, size_t size)
> >  {
> > +       /* See __clean_dcache_guest_page() */
> 
> This looks good to me. One comment: this file also has
> hyp_poison_page(), which deliberately avoids
> __clean_dcache_guest_page() because the FWB elision would be wrong
> there (it even notes "Prefer kvm_flush_dcache_to_poc() over
> __clean_dcache_guest_page()"). Given the two opposite treatments in
> the same file, could this comment say why eliding is safe here, e.g.
> that the consumer is the guest via the FWB-forced stage-2? It would
> save the next reader (if they're anything like me) from reconciling
> the two.

__clean_dcache_guest_page() already have this comment.
	/*
	 * With FWB, we ensure that the guest always accesses memory using
	 * cacheable attributes, and we don't have to clean to PoC when
	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
	 * PoU is not required either in this case.
	 */

I will add comment to clarify guest vs host:
	/*
	 * Guest stage-2 uses FWB if it exists, in that case it is
	 * safe to elide CMOs.
	 * Unlike the host stage-2 which never have FWB enabled.
	 */

Thanks,
Mostafa

> 
> That fuller comment could also replace "See
> __clean_dcache_guest_page()", which mostly just points back at the
> function passed in the __apply_guest_page() call below.
> 
> With that fixed:
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Cheers,
> /fuad
> 
> > +       if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> > +               return;
> > +
> >         __apply_guest_page(va, size, __clean_dcache_guest_page);
> >  }
> >
> > --
> > 2.55.0.229.g6434b31f56-goog
> >
