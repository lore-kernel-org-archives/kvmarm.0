Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231E145DF68
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790697504; cv=none; b=FqcBwuJfyhEprlp0YS4ipdxfFr9qgbpxS5WvaTYvEaD6ScV0tmgNS36O4n2s0IjnH6TZnJicCvFLxpWokNVDWeKYYAOcW+CO+dVaGMiRrcJH8QQKEB/YcQ63QjQyK3BtApyL/FEIM8XUoL1IYiIgLM0G7gr2kgPp6xJwk2i/zJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790697504; c=relaxed/simple;
	bh=nR4yrTOIgVgspvjCPgKKmvkm5cZCrViKQN79fpTorck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQGnW1gJloY1pbEPWzCYCd0FU/AXn30hWIkU7mJXnNjDOnIfcA0B8cBMBKsmnsA0dS0wiaxjk/V4uiX4gdR/XetFrnigL6rVsvZc8wrwhbTt1JyxcmMuE1VznSPzjDwtDB4l+Gc5ApwR/WIWGUEHYlszufXuCYfHfbBLFHXB6so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Ai3ReLqh; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Ai3ReLqh"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so33268325e9.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 08:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790697499; x=1791302299; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gf4CL38l7K7zHB2Jr75kV3VIF1+DE+Av3C/FhqhlLqk=;
        b=Ai3ReLqhIvCmoK39cH4pU+w70KIn7wp8g0MdMrd39RmjD48xw/KWex0D/x3Ft+hCaK
         tvl36QVny/fsSJRGnKqRfH8/AuVe1kX4p0vLZrcGgLFHMvVwN4mwQUVMvL2BalXpEACH
         SFilmwEHfj/uyPcWsV1xBmeO5M7mqMCGuNOK0Wm59p6y71HnffbfapbY5sxbY1zaNWDc
         OQSR52byYZcnzxBi2hyXtoBmNvsUmxaIoF1zLmH4CxcZK0wrwCYeYba0ePUF+BNbPKTj
         Za2TZFMawh+DNI3QeO47aS/JsqzJAFXOt9wGc1THmxTe7DSw6/7/JZ7N4EySbnY/t9PZ
         k8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790697499; x=1791302299;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gf4CL38l7K7zHB2Jr75kV3VIF1+DE+Av3C/FhqhlLqk=;
        b=c5aRB3gLC0muSz0ScbuTEeeIktboGFmt/H59xkmwSO5vglrKchtPgkf0VFy3TiekdZ
         ECJ5rmwmBwGC04JsoMmydKWSLtnXTivYHgFQ/uldwhe0cyPws8bqKgc4VkKsqFgR0NJ6
         dm7qwsNFDkaMCLKnZ0RX3Gf6Fy46oPYHS12tuHwNPzd4QmLiFBzxslmJZuIjZrSAxqhN
         n2e30qsXYjTUPVJqdcwxiU91nxwZMhznC4MIr4IttAegVMaWgHqlylcwkhwk3K3Mytk4
         uyD0tYejB8TVLZzlp4AormWgV8U/kjjJVxz2XOHwradZIqkIUS0hNmtKlvJVM5RyyLv2
         p1Gw==
X-Forwarded-Encrypted: i=1; AKwUvByxArKwg8RCkLPfFI/VAsaPEIUHFTbJDmlrK1btRxYCBb5lFZI1YG7vsq9lhZTrZNi9hXiZ5Z0=@lists.linux.dev
X-Gm-Message-State: AFuF++mefVUWMi89xL0Cb60mguBOzbaLRnzG3e0UIeuu8BcKRIANgJ7s
	Zc2KnkBNitH+EKasFJz6OzGBpEe+Lom4MRSvwZco0vx8EAZ5MrMo9VfBYCJdvqDSgNc=
X-Gm-Gg: AYBFou2E0vCY5jd7Td6/U7jLKmdAMrCDWInyU3kTP++iKdyQzSNR/MM2cbfv9N9X6MH
	KJV4Z3PbheJtH8EWTb2eAQLSeuo4HhLsCNLcXsrJ6u8Yoy4lqKnAN9sBIsdXji4Sd/NCc0tiBuI
	m4W8CrjiAZ+KeexdxBcXIN23RSoCNsgNRiOt5JdzA1bDF9+Yj/0tky96UMnUXJbFW/rrEMS+0HB
	vxWqWpVfgmvxYhROWeavMqXXtTkVRasp2a91MCQGbe1EUsSbITP7tZ7KOnaLMv7IT9X6fo6jIfb
	0gQr+9nBlixlOQiKRM7tx/QUmPoRNWRM1oxVbLbm6Q1vZWIjQbmgTAGIRjWJ0lnjCQpRGJiEnTg
	CW1ZfYLMro4EGYtDj3PGjLNYnt/veqNUOBpIYWr4WTpAd4NhIIg1x4Td/TgQhl6sj4y7BonbeCd
	TRBR67P+GLwVrQf5Tjmk3SEcPhMLhemlXmTTBbe5A1n7Iwh5xeyGYwwdqmqQTkbhILasmSabf2+
	3aP
X-Received: by 2002:a05:600c:1d1c:b0:49c:eb16:9fd with SMTP id 5b1f17b1804b1-49fe66c9ae3mr284330975e9.3.1790697499193;
        Tue, 29 Sep 2026 08:58:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::5:5c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cf9dfdbsm127631095e9.1.2026.09.29.08.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 08:58:18 -0700 (PDT)
Date: Tue, 29 Sep 2026 11:58:16 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Message-ID: <arvf-dEnIzsXhzkL@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:15PM +0100, Lorenzo Stoakes (ARM) wrote:
> There's no reason to export the symbols for these functions which are only
> called from internal mm logic, additionally there's no reason for them to
> be declared in mm.h.
> 
> This patch therefore removes the exports and moves the declarations to
> mm/internal.h.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

