Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794470026;
	b=1t0GZgFPI0gimlAxKu96jWUgP8Gb3t3wCwnLmSIWfXDaqQqZdztGTDxfqxVEuy3N8RZc
	 Cqp2D/OKoLl0qH4swnVqcFXeS8yrlcrSJVo/RbeAquR0x26NVlLriEwX7w7szvUxtdRIB
	 z1Rc+VDzYidMQkfpzwZH859IUxhSfti3kvOd7/2Fmc6nqhupoLdUnT1W+4z+OxfpnjqKd
	 EOU3rm9p/wEEBwyfyjlO73v+gsFsJI509XFNR1PLEgGtSufrwXUiMFINHrC2voFZYeFwG
	 uF2aLg5rXIT/n3OaulEP6O8I0103k21JOtfvnGW4s054qpD+ySNktnOK4g7cVFrPcXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470026;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Tb7xdtovrUiu0U2PtVOgt58uhZRmxutl3MY7Wj6Buy8=;
	b=HUy9Hoy1iuHsB76U89lrMzd3ZTwRIC5+e3ymZgqBid/7p8Mi0JIcw5v96kZy6GyuY8V5
	 QeBwDOXlPtkgg8c+DPKaByl2o8aliWh2v4e00trLB/zQE0jWcIzXHnqsm+dIYyYErBUtM
	 Ywy8wLllT/dDgsAuCufFMymtyoqY6rC94ZNO3ciTAqIbGRPE3CFkzQR2qWjwaNlfb4WHh
	 l5Z9AXoHzU5HgHF/6GTARAXQ70PnOXBpoc42ydkWXU5A6xAXroarPYwaNq4hJksrSj6Rn
	 nE0D2Zcng06hFZsXHXbBoQBjbE5FB0ItoEjOlj1q7EihpRRlul3rdIK/671+Qga0Hew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aTb+IuRl;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC7B606A32E
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 07:53:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DC7B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aTb+IuRl
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so2636232f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 23:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794470024; x=1795074824; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tb7xdtovrUiu0U2PtVOgt58uhZRmxutl3MY7Wj6Buy8=;
        b=aTb+IuRlzFHQ0QTDObBeWI5shdaSt3IFEqFfhwGs2EUqSmeJd+r4TtIhiyruJ95CiI
         ami8Hcs/CYI+XdkJCqxgfKRBgDTAEc6u4OkeigV2qe+++/OZ8J9qzii971z0c7hsaLHm
         uqcgHLyYiBF5hYABE4kGiuanI602qETNzecHMZcE1ZxoisezVTq8lCCTGQ/QfRPIBVEm
         i+apMN0kDIUia0y4oVJ01OlqFO4bl6zLjLz9lWsRh+AwiZT9kgwOp4RA8WkLhPG9rxSr
         SWC0w8CUAPw2VCGPpc6cHsypH3ZzXcwV23gop4iglqkJN1TmjZOVn4eK3aUIQ5V3Ue7E
         VALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794470024; x=1795074824;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tb7xdtovrUiu0U2PtVOgt58uhZRmxutl3MY7Wj6Buy8=;
        b=neiwjVCNWRR13AXkG2aG9+TuQXtJO0NCuxbkdhAKSUiLjI5v5VDayehkGTLgPPVTTW
         fItO1fJPENvNW3U/fMLqdRelxITqrbVu7C92qcBr1sZojywMy46v+2sWNjmg2aa/MTxi
         4ZZef/LryLe5rDmszasTVhdzNWZNSapG51UWNNGIIJZXsv1Pw1UsZL8rG8s/AyTdOB7S
         gj4ARFGqwkSv5cNXmdyPA8DbgWTU4iCY1B6ydXjBiYBf3ZFIov2R8kjwYvT8LWFJUBys
         o3dvIWpIZAYYNCKp84TNdTQbQfb0RSriVR/auA9vVADT4gMVhXZmkyq2hm4J8iAHBd/d
         E4rQ==
X-Forwarded-Encrypted: i=1; AL+hErHWVRDdbhmAfauGSjs1AdLL/NaDFVWWK/z3M+e8bzpG75rz4BrQ5P7y+6XO4IIlxtvsPgpR1fg=@lists.linux.dev
X-Gm-Message-State: APuU4Z/E++TxO5s7XxhLgVtjI9tWVdt5lfcyX724mSRHemr9h0Yg8oWR
	ZUGv4s1w6f5RsheCm/JE0quVrydFVR2CI9pvwzzoMdQFd3d5DKaQZ2mP/hYaV3MwwA==
X-Gm-Gg: AYBFou0XC9HW+ITOr2eUEFyZytyIqUuRgmL5ehxZaJlqpFloMDLFv/4p9uMK4t5u3CF
	LzfJpDVBsCrSXb2LflJrgQIiNoEEVGeE/fMXh9zY0cpIUYuPmrbzi0msdk4bkhSRT4I7SZGtHiv
	Y30vZkfG6S2qU+4Snf50LWWHaTW9QNnMaqFfA9hBpcJUqBQQZHucFPr5cYzCC4/3REavTIp8r5v
	xmF6QUxVkuQaS3fnaFTu9Iru8oq5Zo4BaPuXztsy06MLaclXJ87+vbQluhKKeOq8/4Z3i3RI+ua
	MC394USnu2deNIZ0jnizTJYzKrDkS54WWV6PcWDxKYrU8V5zi/S9V79Fa9tGpL+zT061lbJGzAF
	bbzkjzGuL6VBxC2XfZ3caGBEMbbwijberp6Jg0LBuuG+VlnEwuJ1RMlaOrg3p8H7vGBR/aBIkWK
	P+In+jAG2XYspo5Y4/hMz8s4ZGtuLbDzccdXEWe6ebhhQuANNxKage7br5vpxG7Yvaz/3j0VBQg
	1cJB179KkIMXdTO39nvOEYywIZP99z9DYqF3PLIqdKR8SVRGQExpPiRyjP0bRjdAzCDuhTbLghi
	n4l1YZhWyz2v7feDC0nCDrCrfDOT18f7SvDtwK3KKVNd30RnDXISEKg3uERhF/11dA==
X-Received: by 2002:a05:6000:26c8:b0:487:40d:af29 with SMTP id ffacd0b85a97d-499c84b52admr8993973f8f.36.1794470023947;
        Wed, 11 Nov 2026 23:53:43 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983585c4fdsm15541519f8f.10.2026.11.11.23.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 23:53:42 -0800 (PST)
Date: Thu, 12 Nov 2026 07:53:38 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, ljs@kernel.org, ryan.roberts@arm.com
Subject: Re: [PATCH v1] KVM: arm64: Fast path transparent_hugepage_adjust()
 for non-PMD folios
Message-ID: <avVwgiUduRV3xQQ1@google.com>
References: <20261102211900.504192-1-vdonnefort@google.com>
 <867biu2ujs.wl-maz@kernel.org>
 <aunvGQb--3Lp6kQp@google.com>
 <86pkwb202x.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pkwb202x.wl-maz@kernel.org>

On Wed, Nov 11, 2026 at 09:23:34AM +0000, Marc Zyngier wrote:
> On Tue, 03 Nov 2026 14:26:33 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > On Tue, Nov 03, 2026 at 08:22:47AM +0000, Marc Zyngier wrote:
> > > On Mon, 02 Nov 2026 21:19:00 +0000,
> > > Vincent Donnefort <vdonnefort@google.com> wrote:
> > > > 
> > > > transparent_hugepage_adjust() must walk the userspace stage-1 to detect
> > > > if a PMD-level mapping is installed. If it is, then a stage-2 block
> > > > mapping can be installed. Even though this stage-1 walk is most likely
> > > > cache hot (in most cases, the mapping has just been installed), walking
> > > > a page-table is still costly. This walks accounts for ~5% of the
> > > > user_mem_abort() execution time on an Apple M2 big core. This makes a
> > > > fast path interesting.
> > > 
> > > This raises a few questions:
> > > 
> > > - Isn't this a "fast fail" rather than a fast path? You don't make the
> > >   S1 walk faster, but you instead avoid cases where it would have
> > >   returned an level-3 size.
> > > 
> > >   If anything, you make transparent_hugepage_adjust() slower for the
> > >   case that succeeds. I don't think this invalidates the approach, but
> > >   it feels that the commit message is just wrong.
> > 
> > Yes, "fast fail" would be a far better description.
> > 
> > > 
> > > - How do you measure this? 5% feels like a huge amount for something
> > >   that should be 3 loads. Isn't this more an indication that the page
> > >   table walker is overly complicated because it was designed for
> > >   something else? In any case, It'd be good to verify your findings,
> > >   so please provide a minimal reproducer.
> > 
> > I have booted with qemu a L1 guest. Pinned to the biggest CPUs of the Mac M2 and
> > set the performance governor.
> > 
> > Then in the L1 guest, I disabled completely THPs and enabled the tracing
> > function_graph to measure user_mem_abort() and get_user_mapping_size(), before
> > booting a L2 guest with a single vCPU.
> 
> Oh crap, this is *nested*! No wonder things take ages, as you end-up
> going via S2 (and any miss in a TLB is pretty taxing). This really
> should be captured in the commit message...
> 
> What is the impact on a non-NV setup?

I do all the testing with nested: it works great, and it makes sure I don't
break the machine :) 

I have tried on an Ampere Altra machine and the results are actually
interesting: get_user_mapping() seems on average taking just as much time
(0.26us). However the whole user_mem_abort() is also shorter (2.3us) so the
percentage is actually higher: 13% on average.

-- 
Vincent

> 
> > That gave me something like ...
> > 
> >  0)               |  user_mem_abort() {
> >  0)   0.208 us    |    get_user_mapping_size();
> >  0)   5.958 us    |  }
> > 
> > I have skipped the outliers (the function_graph prefix them with '+', '$' ...)
> > which I believe are most likely related to interrupts.
> > 
> > Then for each pair, I got the percentage get_user_mapping_size() represents in
> > the user_mem_abort() execution time.
> > 
> > Now looking again at the results I have, I realised I gave the mean (5%) but
> > perhaps the median which is 2.7% is a better representation of the overall
> > improvement and is slightly less impressive.
> 
> Yeah, but still. Please respin this with an amended commit message,
> and we'll see how we route this.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
