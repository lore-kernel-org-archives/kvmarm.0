Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043381DFDE
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 00:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786147578; cv=none; b=gpN0HOV9BW/P0catsC3culTTY4N2pCsfbjmVtWvSvrcVXeQKdLTIGPnCJQBJIn7/Z0s1SIZfoMyniTHJOZ42v2NNA4vM21mViEWNoarZfxF/emmVTEC1X+HYIqPiF+6poBzOUtCoG0S2IZWFrZ2el6kETAApzeqsqCqNfbxmHto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786147578; c=relaxed/simple;
	bh=RA9dpZdl+10Up3XzK3DGdcx1jVQ+IhPwZrWXOdRKznw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=umOnoqZZ+hXYL8kwuWilfCBwhXEI4q7lrIKmkfCu8LPb7OLQSmqcaA78TBnYv0zg0pCcvkRq7OA+I9ItadaudEPilwERYgFCK046N4tLf1uMJCbUyA6/4Ek+oUm2yldKC/+pQxSUu6IPPr0dXeky+t96vgaPNfVDzEb0p/ue2fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kImvm1FI; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kImvm1FI"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso954025e9.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 17:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786147575; x=1786752375; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FsKxTA4erx5XTSXjiZYThiZPnvpnWuQr1XWMu+ae7cQ=;
        b=kImvm1FIjsySWa+G05/XiRLOZbT4XnbKHnVXoObD7ttVwGvBS/rrJ5jQa3fmouVlLu
         ERIyj42CwJnqX2pPbdGGN/7qgXYqk24HQj70FEXncul5Vqwh66888WUbhpd6TDv/KdLB
         j5pzUTMREJ2R9kJmrU9zwq8zc+GTLg+kZC6X2j4ofca2NhQ1svc3q0uJL9RP2QjsBw27
         B79iwdcBfzBUTxT8cpTO6P8VDyAH9FsH+vwTer3es72r3bYnhSO6tNdiu8X7BU9CLPcE
         X1HgyNqccdTBmrx9X0wmaD6qJ9XjZAC/5SA/QpgmMyPVjD7LnLjpEVj2oolZTw2RHdLj
         nOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786147575; x=1786752375;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FsKxTA4erx5XTSXjiZYThiZPnvpnWuQr1XWMu+ae7cQ=;
        b=Wo6583/8FssK0Z6hUezepMpRlA9BoDHGor8SH87HCQf1sseF7svYnoP5qj6Yf+vvS5
         4WaU/q2ogQ0uhjodScgcqxPfb9KKAvBqcrC9WRGL9Scask1GfJg1rWUWeaWSOFrkcYK7
         0+w0Ov14075yufTPdN99pxxMxoaAHq+71Vt0YFkLb5WH/kIfGxfjqtDBtr48yFm5FoRf
         foClymrO5Chs+Q768WhxKNfkm36uhKsn0alwRsuP0BYQTDUIkPQOdWCuXiEsbn0LB33s
         XPPQuMvdv72K+hh30sglpL5Y156fLO5eGzvkIGrOP/f3995fqY0enqF9uVc/bOUt3Me5
         7V/A==
X-Gm-Message-State: AOJu0YzSoAUgh6cF2qKDR98L1joLbUr9w2D2udqjvptD84bs3eAsTM2z
	GVZxbpumlzMmXjCZkl07tmTvxbIH49n5fF6LVpr4q/UhTo78HkcqgRbh
X-Gm-Gg: AR+sD10/F7+qefjOgBU+iJLSmHOIQ+shpHeKK0sRfXTRidLWjTFw+4rwkxjF2pAWTtl
	tAaiD4k3EjTfw1j6F51shY3bzlbeJBcYivEm/j4LeoTocXpNtBi2g4c5YCcrwR2hkD/WBxOI37U
	aBaiTQGF+iz3OTPvy6khRHQqxP01HVHYN+ZyDfe8lmS7YE2IIxcwm7yzNp2Vk+5Rr/ZHiaoHiO9
	ueD9helf+XMEWSgAEuWkUoN5xAzsXgD7Sf5ehZvxku0p4WI8lvndmbHHQOikJjDto0YwgJVKgPQ
	yo56qfvYvl9oskIsz4bd7riX6g2O9mdlw8HTCUl/aI65rb5bEp+IGSJq56rPdo5fUAD6cZ95lqC
	uLy2vOW/jwspO+DmeknXWmldGKTWNCAoOBnt9F6ZGvizozxIPPvsZ1iBn5o4Oi8Uh/mGWJ5IqFA
	qpJC4QgI0L7ZT2GbFaaz54y57Ceb5TBl0013c4C8/pqwlxQFyeuVUo4Ai7kHjpzA/DuVJ+iQk8I
	Cjme1/dhd6V1i/FU9hbYGMGSO+xSp+fOrL+G4jem1zRQY/rJtHLQhO4yXezxCPsYcSZ1j2ppplE
	PUn1YinNcYexGA/6A7TTmF+zU+277wrw/Kg/abRiyM+3Yzl1AaLKq+xGGsN3OSi0/A==
X-Received: by 2002:a05:600c:3b0a:b0:493:c47f:3c55 with SMTP id 5b1f17b1804b1-4994e71d7b0mr327822895e9.5.1786147574972;
        Fri, 07 Aug 2026 17:06:14 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-b105-e101-a437-493a-4de9-ee3e.310.pool.telefonica.de. [2a02:3100:b105:e101:a437:493a:4de9:ee3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995428f294sm193311215e9.15.2026.08.07.17.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 17:06:14 -0700 (PDT)
Date: Sat, 8 Aug 2026 02:06:12 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed
 addresses
Message-ID: <anZyR30Zjj-DRJIF@gmail.com>
References: <20260807195940.12642-1-kmehltretter@gmail.com>
 <20260807201709.548941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260807201709.548941F000E9@smtp.kernel.org>

On Fri, Aug 07, 2026 at 08:17:08PM +0100, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [Medium] The `kvm->arch.nested_mmus` array is leaked if VM creation fails after `kvm_arch_init_vm()` completes successfully.
> 

This issue is valid. generic VM-creation failures after that point can
call kvm_arch_destroy_vm() without freeing it. I’ll add the missing 
kvfree(kvm->arch.nested_mmus) there in v5.

Thanks,
Karl
