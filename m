Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A2B28EB
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746523362; cv=none; b=fDPYWPwXvQWItu5ly5435rMR+LUWq1Sm1/vvoQbHRFKD/5DbgrVXDirpDEZ44TvcvYVftazXDwChAo/Gu0MaA3nNQ+lHljfVz2lWjAeM4HPk+DzdFeG05eVzwHkRLBvfjQlCKxjmnDTMuDMVEq45EjaqDAEyL+QEAikbxQJKbIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746523362; c=relaxed/simple;
	bh=IXbem8G2R35AAr+aAT8vVVC/AjXI63AKfjNdsXUs0Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGxiwa4RtUz6r7xBgdZOZvxiwI5V+jC1cUpUMb1tPZsqtwdx23EsIc7eYYM8dovcVU996tqP/pO05MsDzRgcyGkTWI8438I6xfZZOGf4MP/lRRPBKryew9GsQjHxGQtEj48/dV4XlvYlXKwlDuzyzBJ5UrtV9Yi68qUj4xljPJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eLULGuC5; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eLULGuC5"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfe808908so47945e9.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 02:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746523358; x=1747128158; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6PKyiTW7t9VlHIC0Fir8qyHkI243/6y/pnmH8hpJckY=;
        b=eLULGuC5ah1VT5uo9hHF/uu0GkuL97oQZjbS0pDj/uMiRO9Au7tZRzuAaSl5EOihN2
         QLJ1vrSDTgSOINOJiG5xQEgOuHHyH7KB6KoOEodreT+yO/unJYPKnRoiAm/k39eheyZ2
         L8N7zQDme1mPiO21WVAeV6G+EzfRXC6KEoP6wXzqa+BrhvGeLoWat62L68ttsW0ONNZ+
         VN2ecaTbVinYpdM4uOodNepYPItGcWwxOPRJStJRBopurMSDSbie2EAPCXi3B/nhWXeM
         vaNiaHOGklqtKX+9p9c8Bi/ZOXmeGZc0jrh5kn2a1/UZ5M0fOLH3VnONFKcwVipL3DpJ
         2qmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746523358; x=1747128158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PKyiTW7t9VlHIC0Fir8qyHkI243/6y/pnmH8hpJckY=;
        b=Rnx1uCOEHcTxUZGiHtptwcwLu375BTsEuRda4DCB5Fy2khWk9qnPA6G/gvteVe00yy
         SfaHBe4PKpAFWowTc69GhHvwgjZ/2VtIAW/dV0xY9CJ4xt04HHKYJLua5mGTi+rwic/r
         +5w4D8E1x8X4OVmpRGjTJALLliHwZL4235sEQhHAjaRhjl1/Un7qfEMpXOdEP1SRsAHo
         4WbpR1VQPJl4VLdj/Tlnkb37fTg5Bt09yDRofNtTd65loWgOedRg0crpMyZxG5RF9oW/
         MbHgdtIH+cqFxCVxXjgpkFswzGwJI5VVv6Z/DuLD+siDdmb5/DodbX6CdTsBGm14I1B2
         xFuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxySrUqwqWHeehCoaMoebop9Q6BcNH5Q+skVC5yKXNokg06CaFPh663pJXWlr7CaN4vKea7S8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzW80L/MbywshXCz4dwa+EqnMkUuV6vmtJB1ZktzU4MUeC/DykC
	0i1qqd3k1jVc2BsgQDfKvahPtFQLWIKYnZxojb/KaEARDxC8QPnDBc76hNGrvw==
X-Gm-Gg: ASbGnctAEqYrmtY5Q6AY8h5n5GHqv+Kn+BASQEaSh4E9NlK4mKK5G7+F9b5joa7d8UQ
	2+8YopeBtjfrtcW34cU43E0qjJY6kFVuCe4c29uMFMqaVjUSfZ3yyw1JTXi+fZvQoBzBmBar7T4
	Bxw4nMXsk6ZyVwFSmo5OpNeITE1fpwtWRxkn7cPiRfqMsL1x49beH75avXbOZ3RfdgP/gWXT/MA
	u+I7dgebo+X4lOtrI5TuHfIbhoCA7mh4O8dAdVDd/QD85GtAIxwV/YylbH8loxFmxUg9ar9yo4l
	1dqOrBhKXyIl7PIKiH4KJ1n1ec6T2srAW9jW9IYmRwa9Bn+ccAP2tPu0BJjUWecoVJKjg8nHT/S
	R7zA=
X-Google-Smtp-Source: AGHT+IHDtwlAgJFzUnwiJ122yccBNhS4YJpQ3qlNsrd7r09OaCmmMYMxQB11yASqxuqK4r8lQg5APg==
X-Received: by 2002:a7b:c04d:0:b0:43b:bf3f:9664 with SMTP id 5b1f17b1804b1-441d123cfd5mr707515e9.5.1746523358264;
        Tue, 06 May 2025 02:22:38 -0700 (PDT)
Received: from google.com (202.88.205.35.bc.googleusercontent.com. [35.205.88.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2b287desm208303605e9.38.2025.05.06.02.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 02:22:37 -0700 (PDT)
Date: Tue, 6 May 2025 09:22:33 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com
Subject: Re: [PATCH] KVM: arm64: Fix memory check in
 host_stage2_set_owner_locked()
Message-ID: <aBnU2aXDvznmGU2l@google.com>
References: <20250501162450.2784043-1-smostafa@google.com>
 <86ikmegmw9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikmegmw9.wl-maz@kernel.org>

On Tue, May 06, 2025 at 09:32:22AM +0100, Marc Zyngier wrote:
> On Thu, 01 May 2025 17:24:50 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > I found this simple bug while preparing some patches for pKVM.
> > AFAICT, it should be harmless (besides crashing the kernel if it
> > was misbehaving)
> > 
> > Fixes: e94a7dea2972 ("KVM: arm64: Move host page ownership tracking to the hyp vmemmap")
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 2a5284f749b4..e80f3ebd3e2a 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -503,7 +503,7 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> >  {
> >  	int ret;
> >  
> > -	if (!addr_is_memory(addr))
> > +	if (!range_is_memory(addr, addr + size))
> >  		return -EPERM;
> >  
> >  	ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
> 
> I vaguely seem to remember that there was an assumption around
> addr/size representing a single page, and therefore addr_is_memory()
> was doing the right thing.
> 
> Has this assumption changed? Or is this only a figment of my imagination?

From what I see, this might have size exceeding page size in the
following cases:
1- When creating a VM with 4K kernel as the struct pkvm_hyp_vm size
   is at least 0x1130 (without vCPUs)
2- When creating a VM and PGD size is bigger than one page (for cases
   with concatenation as 52 bits and 4K would have 64K PGD)

Thanks,
Mostafa

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
