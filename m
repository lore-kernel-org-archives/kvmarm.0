Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5900279791
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747664544; cv=none; b=MWD2p6WteksxuO2AesdS6Zzr2Sia3s41tufj4cSMIxlqwQFom1XSm5EGDhjwfZvNZohnCG7GFSux6J6IQsi65Ke3GKkfUxIQEg//tNbgrK3PDd7wJVORPKewmSBS3OKMG1VYhZLFVs2rrihb957AZ2gz8TFHDfZ0TQ6TS1OLP2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747664544; c=relaxed/simple;
	bh=xbm6RIGH0CJZMP9dG3aiux1usLbAUaOL5mgEvxLAyA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOY010XXFPE6wteFRAxpZMRcAQ70zlss9bCCzniBC0FkKovazoixysRTjOQYpipjlXFbJ3uJEZMZ38kfSL/y638Frakt5GY3FbD9a9CvaJuk2RsjoKPoPv7m+3J+GZUU9BoJ4KKr+ckyAPly19JiM+AbfEnUkvqUjHlgIgp68sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PIkWvyNC; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PIkWvyNC"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ad51ef2424bso643424466b.0
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 07:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747664541; x=1748269341; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kQSuEqcHJXFQ1exNbmtWM5VfdOVLBSlLfO7byhWtGpI=;
        b=PIkWvyNC3O1J9wxnI1FeV0lN14w72vFQx4nyhHvvoHD/UHNo+rNAAYgeDVpTIB0UiU
         5HL2flEyt16Wv37dFLgPrh1au1r3JcQDcI+nxpHwTNITuXF7UFGGIkjFaoz+cebOULtI
         lZfB2U5ax//J64SpZCUrglIuGHBEKh2/EkUxQmk+wBp3XNsgPoJo/CzUfxIDCV3b8l4X
         uI+NoxtTYT7JzmMxl5BCsnA2V2kd4tYAaTjYEeFFM0Q1ztft4KUhEL/bPJ5HcGgpCibK
         aq9YkI5Pre5exk77Ji199cL5F6Nox0UdNK6/QE9vtomGZ+twANi0hQnSJlXbF0KvCTzQ
         MiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747664541; x=1748269341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQSuEqcHJXFQ1exNbmtWM5VfdOVLBSlLfO7byhWtGpI=;
        b=mnSJYaPC07dUn3ai762SQqQ++QLJ+eaHeCkSqIRSfgm5sJplV24Wc+2FAmTPVuOX0c
         Kn7viEMphk7OgY9ecFkNb3VWW/PHYr2i8IYqupVciugRBqARODHBoQQYF3J4gQ6p8Eex
         ZeruF/ldnzn3f0QhG4DwKTf+rs8Z8xOVssrWTXGBzr6PDXY+3PY+W+i5qv8BcyMRx2EY
         gGmuUR/CPRUxMGjkpnVvQ4edPe6XEbm7xJ86gx586a2xwWkkzO6WHz0AHgUh1Qcj1Sjh
         hFvkVVO7yjAI07gDOGNCI/FpALqVLAS7zgFbvOzktHgio8VrwfqEHc0EDl6ortP2CV+f
         Zumg==
X-Forwarded-Encrypted: i=1; AJvYcCVy7piY45zkWY40riGAnsZabsTla6ZK65fNV0u3fi2lKnPVpYkfoQWdeTvABrVo7j9rQwyDgcY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyC9WQ1V+gT24k9vXCKpzSe7YY+XuIh4VYgLk2oqpS3FrBxreoV
	4JAulGc3hHdHIYsOf8pgIpZVvq/Pn9k4iCPM0yJyo+QUt6+VZcKFS+d2niqKfEClEatbYFywD2A
	leUYnyA==
X-Gm-Gg: ASbGncvbMDhOYuUDmHFdTgzCtx40PT2mg7glOiiUYZ4DVLd3Vc0tYpp4NrgcK2rS+SO
	xSUnNsjXAtTHJo7aayDudqwC95ZxzrXjy6QQf44giqBBT1szyOxQef2pc0HKyaih0uTRWSLGxkn
	2ifl2ZfutyHo2YrEv6AiC9rh14M9QFoJNpis2bOlq6X4V6we09WDJL/OkFOo6mRUDflmO/TtSSt
	YZaIUKb098MKdwc7QWkqp/umS078RvLXJiwVmII4Oyz8S1TzcUQb1viilCfLjyd5ILIPkRR8gm2
	gI87VC2yuZVnp9o9hAo882NTXOziDbgT6aqrahypDwBRjihV/Hrko+SM2W7bgG2KVRkZjEedzC2
	TBMF9MOZzXM03TVmYR8yJ
X-Google-Smtp-Source: AGHT+IFH5dLBwEyWAFcQq1e+DL6BqjO9tw6VuHfBFByUGGuIQ9a/huk1aiNUfDOMwmKFocYhB49/Cg==
X-Received: by 2002:a17:907:9412:b0:ad5:69e7:181e with SMTP id a640c23a62f3a-ad569e71f30mr348649466b.61.1747664530363;
        Mon, 19 May 2025 07:22:10 -0700 (PDT)
Received: from google.com (68.57.204.35.bc.googleusercontent.com. [35.204.57.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d498747sm595489966b.137.2025.05.19.07.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 07:22:09 -0700 (PDT)
Date: Mon, 19 May 2025 14:22:05 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v4 07/10] KVM: arm64: Convert pkvm_mappings to interval
 tree
Message-ID: <aCs-jYUrEraCnLaX@google.com>
References: <20250509131706.2336138-1-vdonnefort@google.com>
 <20250509131706.2336138-8-vdonnefort@google.com>
 <867c2gg0hq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867c2gg0hq.wl-maz@kernel.org>

On Friday 16 May 2025 at 14:15:45 (+0100), Marc Zyngier wrote:
> > -/*
> > - * __tmp is updated to rb_next(__tmp) *before* entering the body of the loop to allow freeing
> > - * of __map inline.
> > - */
> > +INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
> > +		     __pkvm_mapping_start, __pkvm_mapping_end, static,
> > +		     pkvm_mapping);
> > +
> >  #define for_each_mapping_in_range_safe(__pgt, __start, __end, __map)				\
> > -	for (struct rb_node *__tmp = find_first_mapping_node(&(__pgt)->pkvm_mappings,		\
> > -							     ((__start) >> PAGE_SHIFT));	\
> > +	for (struct pkvm_mapping *__tmp = pkvm_mapping_iter_first(&(__pgt)->pkvm_mappings,	\
> > +								  __start, __end - 1);		\
> >  	     __tmp && ({									\
> > -				__map = rb_entry(__tmp, struct pkvm_mapping, node);		\
> > -				__tmp = rb_next(__tmp);						\
> > +				__map = __tmp;							\
> > +				__tmp = pkvm_mapping_iter_next(__map, __start, __end - 1);	\
> >  				true;								\
> >  		       });									\
> > -	    )											\
> > -		if (__map->gfn < ((__start) >> PAGE_SHIFT))					\
> > -			continue;								\
> > -		else if (__map->gfn >= ((__end) >> PAGE_SHIFT))					\
> > -			break;									\
> > -		else
> > +	    )
> 
> The removal of the comment worries me a bit. Is this iterator still
> safe wrt freeing of the iterator in the loop?

Yep it is still safe (we're still caching the next value in __tmp before
entering the body of the loop). But we shouldn't remove the comment
altogether, it just needs an update.

Cheers,
Quentin
