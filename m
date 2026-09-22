Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79473299943
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 11:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075819; cv=none; b=lpWk55TTn0VFDVHOYgDBSxXnzoNYTLRCiWwzq64xjh1Kg/6Oc0KKi62aNy+/YK9fQWxGGBTy/ZzDdi3aryGHrkCqsKdmAnPsOPns3pFAPGmvzoF5z+5Aku+CRdSuvdN9rCULJ/M4mjsvt8dVNVYvsnsnbwn66sbNpA+qWelQdDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075819; c=relaxed/simple;
	bh=Gww32BnzCP+2gnnL0+cONTfGmkRFWldN0S9BsHfwgMU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RwATiCMxB1QGfK3r+jvLioGfaopnQQnCBrprcThrcmyuaQ9+X9T4LTNzwRM1QMEnOHWHAOX0xxOQo1LbWhnm3KGsBUj74eHGopHlm0olO7jDibNKeTq9/fUruqQ76ElAZqamBuFkQgrX9o3vkTT6PnWCIF/iOc9Pj2ZPJnjc+PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oLRZHsll; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oLRZHsll"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49e65ecd557so26916275e9.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 04:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790075816; x=1790680616; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cXSrQeMyHW+MKEBO/LMvcq3vJUhSUVerpVL28o1KObI=;
        b=oLRZHsllXW4koujGkiBpAq5/Fm601VM38eillOrA8qcr2//3DKf2FWprHjhD7EfTi9
         pgv1gBynwmhqrffNjHCNR2sho9+ajiqaoOuaSc+ZmhGUZOPnF5D7YyVmOmUvDAQjOe8x
         HThEbsgyVdQnGzUH84Qk+ulyzxxu7gcMmlEtaL7Op9nGZWdjFx5xVjbDde96mReyVcw5
         Y+dWesPT4H0vrookaH7cOJ5ldptvg7pn4h50t2vaQpBcHKBUWW5r9nIdDmHOtus3M8qm
         ClIs9OKqUR6l2uvAPlrhaEyNa84PdwiRvGpuCF1hBboX3nbzYck4Ja0J+0Mjsoe8YTzd
         zoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790075816; x=1790680616;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cXSrQeMyHW+MKEBO/LMvcq3vJUhSUVerpVL28o1KObI=;
        b=oaPDTddSKdfHGSskA6sbZLKCbVoKooagyDFxFpe9TMDtwrD7YiVSMRFeRecLZINT5t
         u4ajjGOlLChMY3K3I4vKt6Ft2z1i/JO7zxPqAICju2lzOB9y+RBihf5YFQOt4NhNq/1w
         2QF0NcW3rTyPQmFiHJIfm50BLcgLAgiJUMkdrDQyE64m8ED7xK5vlnoFrj5di3/i3d2R
         zwmb1tcliSEmPBBAZmGjS8eN102/R+EAFlabCIXRH0PLgX8XjAYHktMkBN4J5lxqAzZG
         0Ru6Wy6Ja0s6MRUAbZETJNB8CJhqsKGO6PBa+TCOm5RD8BtdQk+3d5kb7wGoYn+ABVYl
         qnGg==
X-Forwarded-Encrypted: i=1; AKwUvBzrFobjd6v1ZhYMxPoUzmvV8vGQCOQ2Qj8Q5orDA8xDH+rN/tQXoJAzjUPgT8LH0BD4XPw0P2U=@lists.linux.dev
X-Gm-Message-State: AFuF++nVCgX6B8ed4I01RT3XclheV2m10+hy/thct+MJm8SRgcxAdL5F
	dm/dHUe5BfvSCYxml37WKF2jeG80c7nCXvJGG4iJjjw+qfhwR8kWxHf3skzXURGW805eEqPIJ5s
	+MMQ4MgcNZtY+gR9EKjoGgM5y7g==
X-Received: from wmbju2.prod.google.com ([2002:a05:600c:56c2:b0:499:b2d6:1572])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c1a:b0:49d:1de5:ce0a with SMTP id 5b1f17b1804b1-49fc56d4238mr237637205e9.13.1790075815186;
 Tue, 22 Sep 2026 04:16:55 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:16:54 +0000
In-Reply-To: <arJTf9C-dr3eMnsW@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <arJTf9C-dr3eMnsW@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922111654.1024808-1-snehalreddy@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Support FFA_FN64_MEM_RECLAIM2 in host handler
From: Snehal Koukuntla <snehalreddy@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@arm.com>, Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Sebastian Ene <sebastianene@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Snehal Koukuntla <snehalreddy@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, Sep 22, 2026 at 10:07:27AM +0000, Vincent Donnefort wrote:
> > +	if (ffa_check_unused_args_sbz(ctxt, 6) || (flags & ~1ULL) || (x4 >> 32)) {
> 
> nit: (flags > 1) ?

Ack, will update in v2.

> > +	if (offset % desc_size != 0) {
> 
> nit: 
> 
> if (offset % desc_size) is enough

Ack.

> > +	if (offset >= (u64)req_desc_cnt * desc_size) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> 
> Not sure I understand what Sashiko means here offset can not be bigger than the
> number of constituents we have...
> 
> > +
> > +	hyp_spin_lock(&host_buffers.lock);
> > +	if (!host_buffers.tx) {
> > +		ret = FFA_RET_INVALID_PARAMETERS;
> > +		goto out_unlock;
> > +	}
> > +
> > +	memcpy(hyp_buffers.tx, host_buffers.tx, (u64)req_desc_cnt * desc_size);
> 
> Either I or Sashiko is confused here. The invocation will not do more than
> req_desc_cnt will it?

Agreed. Per [S0039] and [S0047] in the spec, req_desc_cnt is the total
count of constituent descriptors in the TX buffer array starting at
offset 0, and offset indexes into that array so callers can advance
offset on subsequent invocations without repopulating the array.

> > +
> > +	range = (void *)hyp_buffers.tx + offset;
> > +	if (page_index >= range->pg_cnt) {
> > +		ret = FFA_RET_INVALID_PARAMETERS;
> > +		goto out_unlock;
> > +	}
> 
> Should we also verify total_pages here?

Good catch. I will add a check in v2 to verify that the sum of pg_cnt
across the constituent descriptors matches total_pages (without
overflowing) before forwarding the call.

Thanks,
Snehal
