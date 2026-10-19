Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF54D09EE
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 12:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792413557; cv=none; b=M0GgUJCR4bENG81CGPAG8D9lKC3JNgm+AWvotDq+PEWGX6gxKFpJoJrRrI175QUcyJ8zx0qXm2YzE6di+2lrAxylzqBvwZweYfWf7AdT1vx2sg1CUeLc8VTsHoBqBLn2BgvldMb7INPUzNtfpwZDbd8i+sCgWEpxHPnmTmzZGLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792413557; c=relaxed/simple;
	bh=TIpwsXEtH/kqw15lohv1lzbLaGX2CVOAovNsREW9MmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCDaral2LBw0aMDNsZ+95tTHTCpNtR1nhD9RP/8EiI+KR51a8b3PyL+gvlwhVME7tXxYlCAVOfh3cURAYwgKyR7PfnE0uNodSV6teEWFByvaphG99wFhKCg5SeTZAmIg5a76wRyd+3/ZnYN+RAOfTQ+a//ZglbxywaBEk1knOQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TNc5KMpG; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TNc5KMpG"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49d05d51553so14125865e9.2
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 05:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792413546; x=1793018346; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TGmjTl0WYTodj16FKC7BqXqbPxH6xsiMEijaRRuXBds=;
        b=TNc5KMpGsWfQHtRAuhcWnSYQAg9mJOisulbsfqOGyJ70zS6Q5Z+ZAVpX7wcnC//U9S
         SjqnCqathKpWkhZHpcysa3liSYIUqhAu15ZWWyZIPmgL0EzWcgxDc4SJNcLh40N2qoz/
         dIlNYyWMiDzJwv/EgleUxzPz9ZtuJ9/sc7naQ3h4NMYdouGbSf1BIguLm06nMJxzQhZ+
         bZY6vit/nCGBanukqbBBgcobIcWth0dgGbEWtTprsInbZ/ioeiZC75sX+a/3j9CELe3e
         9wCLe+BAyXFCBrl58dyUXdmy6Km9koajb3hd5IizcKTKFIy3ngPndUSnmB53bzr7kFcf
         Nw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792413546; x=1793018346;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TGmjTl0WYTodj16FKC7BqXqbPxH6xsiMEijaRRuXBds=;
        b=lk1o3oIzfwtPqKzQrNed+/9bBOAJqXr0E5OzdZ7f2nz/qudjzgCMBGwHRIzsrxm1JC
         VwuE8rhUvk4miHbaUNyQAZdw88D0ocDB3rTBc3JaLO92y/LGt6fBuQPEFbhGfnZK5niB
         9BTX1xAafeDlV9jspUBtzkt9dJFmtpIZC9kBl572CTMtSriE61GNwl9tIMz/aIyPKXXv
         7i2ZsNJ8H40MqmCJOAtSUOoesEZ3PDILjFvG/qksaf/7f4TxqZ9bfvVRCRcMCo0bRkDy
         ShokUAtnAk6WhICr1c9/xE5AMpZH0LgU06r7l2nqvz71wlF/tVsb21+nzSy/MjJHa69Y
         9bfg==
X-Forwarded-Encrypted: i=1; AKwUvBwTMzeMYoNK0Jn+l1N44HFdzRlFmoV5z6qspIoYZg9yoGtluFxGaysjA28LWUCjqPnpmF1hcI8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJAL5xlVyCAOQpjtfiG+sqpLcrFwn4bzFwSAVumNWsgqojfzS9H
	DXu/Bi8Gt7dfdkv11Uh/xHdqLdH/CzSTqYCh9jYF8F4JyeSQtVIsa/7wBvjkM7PbdQ==
X-Gm-Gg: AYBFou1WW0yoBV/WaONbpGkq4SDGUAlOD/3dx+qyhhEaUQnFXY0xU+AU/7+Sz5CIwyO
	ipfbLuGWmCIyj+tP6tZSf7ZVjOuEdbBNqzxtmU4ig4vvO0UmyZ06lIs/QtXwvV2d5xdYHQsicrE
	ub7Bn4NrdLmTLyvpD5lLsVL4j+b32RpNrant+uS0HFbYvTSaNk4tJt21x2y47jk8kM8caifLYWn
	w/Jc53CJwv2hzMM0piDVuD4o1rYfz4xurRvv/UEl2yxkw8vu+lpgnbtESp1o9NTFHnmBL4XdPyi
	aYkhFNL/gCEHMeTYajLVL0mGF4l0+d1QN7DgKVw+MVdIF0Wvb6H0LE1IReu9CHq1mIzHcfISfpD
	sY4q3lPSF/GIIGuwve2KoqAGAS7RIlWi4MoBYdkZt8GZeuU1JR83ziTgIHMXWIoSb/5GBL+spqQ
	bDJ8JvmVMS0J90umWl7htsMNjB1RVzLzbyud6h0opXLw6Q4P7ZM+H7PG2s0mVtrg9Zt2KmHdGGO
	faKGqH+VN1xH5p6Smd+WvuTQMLOz1ktvBug4Wxlv+0C4FooRyySpg==
X-Received: by 2002:a05:600c:a417:b0:4a1:efd3:987a with SMTP id 5b1f17b1804b1-4a1efd39a78mr14321995e9.6.1792413545350;
        Mon, 19 Oct 2026 05:39:05 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1d85f92d9sm199554545e9.4.2026.10.19.05.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 05:39:04 -0700 (PDT)
Date: Mon, 19 Oct 2026 13:39:01 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Ensure TLBs and I-cache are private to
 each vCPU in pKVM
Message-ID: <atYPZeJuw2grFDlz@google.com>
References: <20261014125510.2928306-1-fuad.tabba@linux.dev>
 <20261014125510.2928306-3-fuad.tabba@linux.dev>
 <atXqLxU5bBtJ8U9W@google.com>
 <20261019114357.3528498-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019114357.3528498-1-fuad.tabba@linux.dev>

On Mon, Oct 19, 2026 at 12:43:57PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Mon, 19 Oct 2026 11:00:15 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> [...]
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> [...]
> > > @@ -54,6 +54,9 @@ struct pkvm_hyp_vm {
> > >          unsigned short refcount;
> > >          hyp_spinlock_t lock;
> > >  
> > > +        /* Per physical CPU, the vcpu_idx of the last vCPU of this VM loaded there. */
> > > +        int *last_vcpu_ran;
> > 
> > Unlikely to be a problem in pratice, but vcpu_idx is "unsigned int". I wonder if
> > this shouldn't be unsigned int here too and initialised to UINT_MAX?
> 
> I'd copied int and -1 from the host's mmu->last_vcpu_ran, but the
> vcpu_idx it's comparing against here is unsigned int, so I'll switch to
> unsigned int and UINT_MAX in v2.
> 
> Thanks,
> /fuad

Also,

as it is always allocated when pkvm_hyp_vm is, Would it make sense to add this
to pkvm_get_hyp_vm_size() instead of allocating separately?

-- 
Vincent
