Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302904582FF
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790267896; cv=none; b=oY7Pdy3QCXKknttTPpeHTvMpUrjmMCJWmTM9ZgA3niKgKLPCfpifkNFdZmrJx3wgZoUIx4VxpuhU0KRlqd9g+xurt5N7NEqYx8ykOqocIVRM1FWRgIaGdcvxFZ8+zEzwurs5SfRd663Esh9B9hGGADiAjSW/BMJxpYMPefca/k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790267896; c=relaxed/simple;
	bh=Y6dfgoDu9ENyHz35342iESy0PYqePxl/sIn9jSurkUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oIdu1lRjjY8B3L2ylPDzA0cAdmCg1Mt3yTqGPnbthf1Vl3LcsXXIgz0iE5BqiAJ0oyrbF+O4BSiNkIzRPaXKYrNQZZpD8TyZHb47pCKQ9Bt+Pf9tZIOvFkEZl2mSJ8oKaqnf/LO4K4gG5gD/sA1GGDmgppqK4ktdD638YYlDJVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=sZpT5d8g; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="sZpT5d8g"
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb76543e2so141201cf.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 09:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790267891; x=1790872691; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LuPrvXBzY5FQ+f/5fzbveR9yF272P1V2+jsIcGJNdC0=;
        b=sZpT5d8g+D4FL5X+8AV2bWQl9bhYLWx0vMB9bpPIuqIKJtcpWedqWqIoUpJdDX5TnR
         g+boazhr3s9aYLQdHfLIoT15ak/NLdHPqmaa0yUD8PT+fsoEVkPgWeU1Gfn5Bx2puSnH
         DQRBf1crA6M/52gdlkihHLkiuM9SmuBjJME1yikBB+SB0c/ihkUM8Erhuco+KxXBrWQW
         fkQ9ys9tLrkq3gZhBrfS+7fH3SfidIR4Dpg2wXguwRyfh7ACvPRb5wSh5jsx2rW9u8+L
         vCZXl9wf/JAObtsIGzhX4YNJyP8oUtn7q2n5rY5fSkB90C8yw92+NDHzJsYeT3rELFNT
         BKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790267891; x=1790872691;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LuPrvXBzY5FQ+f/5fzbveR9yF272P1V2+jsIcGJNdC0=;
        b=2zV37NqBp7f0Y6WRbF5MvCC39kSBBSAkZ9V4B9e2nF5WgKZ0IM6xuenud6sFO8YOAk
         dKjPDCGE5z9l3doqhLlHi8TRms/ssul0M68WO6Qg56tMgn5cx0SUEEfAo9SnJYxrfV2m
         +JW6zeKJ7CCCAMCTjEBdeH8/Yw6IRn+CVQG/9V/RyCs1BY8P0TavKqz8Ne3z0jX/Uo4Q
         kyjPk0RMI0GI+dt1SVcMv+qWPYG/0Spr7m4xRHXTzft/WaqceMivuD8M1omr/wfMZTBw
         1+3fc5q/+U0nZLe1baBlfRDybl5pxD6PCxRNqL4oXDs1p/FiyuWH/hy0McnoiZAGXvvw
         r0fA==
X-Forwarded-Encrypted: i=1; AKwUvBw6gn201z1c60eXTJPqBiiLKwKbkkXmdHjqIQ89j0n8RD58WwHYxx9EMAKQZSIvHc9E7whMlVg=@lists.linux.dev
X-Gm-Message-State: AFuF++mnot3NSEhBcyTSEI9PVAOKVp43kgSoXN3GxofsJDL2dvBx2I3Q
	zDm2pZAY17pwzr5bu8WI9S9kladK1FVI7t1UWCW+bYvhYn9KYX4v90QXYHc7lBoHmEs=
X-Gm-Gg: AYBFou1qL8UAzxbukvL//vsf61xtGnqina/T4a0dgjzSGhxBrpLtYAMIgjbKZInSy5i
	PWJxtr6EUYFtC1tmJA9PxsndrLcrcd8Y75Gbvb2PAVRwq0bs76/nHRaTGAE8VWRMNDEh1n78lE8
	CgMJ+AST9maQew5SNeL84zIEN2Mf2zfmUHYQs+kSwtMf1qz70ew/6KeSkwBULlILvDYskXcgGq0
	o+AoMs8dFuknZR0LLV8h/akB0+pHdYMH8NKH17S45ggF5hZ15O8ZKy4hhc8IkaX6PYVdxW4OIZB
	FPvwCs/D+g0FkR5lgrCorJL9VoYa0Oohpuy3Dpqr+KX8vqgDoAaRiFbL6gePujshbIvn5Zt1wJP
	bGEZ6VBug1LONOf0kNN+HiTh2xD70Swx9nAlX1jzBDn3XUim0q67AEJT3trN/ynzbn08Z4LOR2G
	Mo5HjM+GCjKv803lnDORYdbuF2eT8FHbs183DyVzQ12Rm/Q+LLq3iOT4yy5d0rtzuW0QnDA11/a
	no2CM0WSlmSxAiHUwUOiu9kMOZyPx0f2x1gxuYzRAO9HpSpZvdvcjw=
X-Received: by 2002:ac8:5743:0:b0:530:d860:ffba with SMTP id d75a77b69052e-532fe9f05bamr29797891cf.6.1790267890993;
        Thu, 24 Sep 2026 09:38:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb32f6aasm45064551cf.16.2026.09.24.09.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 09:38:10 -0700 (PDT)
Date: Thu, 24 Sep 2026 12:38:08 -0400
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
Subject: Re: [PATCH v3 03/40] mm/vma: introduce and use
 vma_[flags_]can_merge()
Message-ID: <arVRqJZkql6sGunt@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:12PM +0100, Lorenzo Stoakes (ARM) wrote:
> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
> two new functions vma_flags_can_merge() and vma_can_merge() and update the
> merge logic to use the former.
> 
> This abstracts the check and expresses it in terms of the desired behaviour
> rather than an arbitrary and confusing VMA flag.
> 
> This also lays the groundwork for making further improvements in VMA flag
> usage.
> 
> Also update the userland VMA tests to reflect the change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

