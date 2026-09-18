Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F204ABBB4
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789719141; cv=none; b=Zih0hGfL62FCXya8t1tGzang0pVX+Ozdz7PLUHMwbeCUQxuVhYyzFWWtuALTg970Zyxhu88eL/SrEP0Rnyjd5HlEymTV2wu1LF3Hq3+lRKbS8lqikSDdBydzTGNRmPEhiul3kqjlRDY0bekGSuaCR7hmlGb6i2PshwUn0wY/3xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789719141; c=relaxed/simple;
	bh=RSlF8VpDHyGGzPPSumjtrMkQC+rdi9G5voIFxktO2xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBYkUMRH4RM5uCMMrmapY4422hwvoooEnjjzMJf0P1BOQtyx0GB4Y0Vyh3UQ0t4aaINDcdvL6sy33gXTC5KGFIEQKIIPBbpDZW3Ep38lJlA/k3Nv/3gUcxjBcVrp1q4brElz0jb3m5JGRLPKGUM6HwwFaWqLBameYnSVCqUpFps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nmoeDh3Z; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nmoeDh3Z"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f88so235763f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 01:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789719137; x=1790323937; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g+LHj0w68UNIs9ksSFFw/ZHUYPHct0wG+azZjQnnxdM=;
        b=nmoeDh3ZJbJGQLepnYr8ELf5ZjFpzCFf1gmuOJoRwgUCnSbOsGcEWQCY4XiAInI133
         sqABlUGEQFyVxdYAZjbgs6bT4YqsVFPTVJit18ybFbRUTKLMEfJuN+g3AhJkiRDklxIM
         7qBeZE9XKILR9zYaOFLTwFMZ5zYGDDR61gk23n86t46AAIg05wLdPcJ2bvCS9Hut0P5i
         q1OSAG4HXIS0Bu9zZIGT0MYe4xnxUXX99ubH0GfknSrfbZlprbkGVU4poOEiqRv4Qva/
         xQ+UACZXN/0YWute0hIYX+UBZo/tCPvtGYdYTVVTFTUfeDWz9IxLlzWz8Bfu66At+BJa
         cOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789719137; x=1790323937;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=g+LHj0w68UNIs9ksSFFw/ZHUYPHct0wG+azZjQnnxdM=;
        b=n4Lt3YEfsRlWrz1HSyveZ65TWyP9zT8kYpht1PnXlbvNWJT2h+D1zajjDw/rimaFnT
         D1KcT8NTRHEQJq9S5X5aqj0UrkvMX97VQjBrgVf5YTc3fis0Y8QisOJRn/Wxq+/yMO0c
         zUMuFHAqjCRgh+x6QFtoVzoFLrt3NGjw+14k1jhJeP8vgzarKTM6YHW/SIsCTKbmm2TP
         LNaNzmr23PxZwXAY4r9/FWB23JwI4Fk03aKnyPj2jkblmvLabXzSvqtnJUzde6ausK9o
         nd8vjBUBICllSavt0e8gqzFS2dlnAWb7sD+NZ0+g68br6lA3eLHOVTed+cPUCyHOMnt8
         /88w==
X-Forwarded-Encrypted: i=1; AKwUvByNAeym/hYzAMZKX5d0qFoMRPppTAO9EDgTML7+FnVpGTA7/bBbm3gETSesKZ1uhF+1uuYLziY=@lists.linux.dev
X-Gm-Message-State: AFuF++k3vqxEfo1D7Hz3fJCmb2+3FgY0/D9mM3WRNXVN9yxCRr3TzUKv
	5noOEFeyB0cfNXAw08CgmPBoB2/31JRU498DyJ7TAzDKQIveGPehZRsFiFAeHRhXu2Fs9f9idZN
	ilh0tPA==
X-Gm-Gg: AYBFou3/HQbxFwt2NtXni1vcLRe6Ha3BveWS2GETgQrKvCwKEyFBi+n5xXSQ67/ngav
	DVcAoYbXFwGym/DWvxqDGLJGLtyxqs+r259vFl6jWwT3w0vNpdhE+YYjYqhdF7N9shylEe4whG5
	kPIguv8OTetlv8q5LawnBjA3OYJ1TbAALa4WpDMO6zgwBhP58iuyJm74CjLyy4bl3Vh9W9949h3
	/XH1PaQrP2IMunJrTjgcT2a2v7GPEkKq8c0azin25Ro08XHmfr4nMLKtWT+6wGeaNDcLLOnTImC
	0gSr9fB3C7WgC45fwHkorc+gyO9genGDoz93KVdB/JIsiQ9PfrA61KoNU3fBbJYZKhrQ2t261an
	da4UuxAYGFatESYOC0Lq5idT9c7L6kuyhUl4x2f+5b3xbhbzkyYtpY8biAGQpRL8BohwDqbPgGb
	sE39JotXmftDSPc87huUVE/aNcnPhZImoLxtfMyRfwnDU2yR3eKMpSGXO2gBBvxoNhhgjll3JCp
	eE4jqE8bCmpgQoRkBN6zvtqwO9xaaGonEOdUnQT7Yc1
X-Received: by 2002:a05:600c:354e:b0:49b:8f18:714a with SMTP id 5b1f17b1804b1-49fc57226c9mr17380515e9.12.1789719136409;
        Fri, 18 Sep 2026 01:12:16 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4871ff56021sm2439656f8f.18.2026.09.18.01.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 01:12:14 -0700 (PDT)
Date: Fri, 18 Sep 2026 09:12:11 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sashiko AI <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: ptdump: Check the page tables aren't
 freed when accessing
Message-ID: <aqzyW6oJtStG_nSn@google.com>
References: <20260916230337.4162485-1-weilin.chang@arm.com>
 <20260916230337.4162485-2-weilin.chang@arm.com>
 <aqugxlnqegPzMpB-@google.com>
 <ezplrvcw7buhd75v5rezvkhbgdfldxklqavdpnxl2fad5thswe@kctrvkjzr6cs>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ezplrvcw7buhd75v5rezvkhbgdfldxklqavdpnxl2fad5thswe@kctrvkjzr6cs>

On Thu, Sep 17, 2026 at 08:30:49PM +0100, Wei-Lin Chang wrote:
> On Thu, Sep 17, 2026 at 09:11:50AM +0100, Vincent Donnefort wrote:
> > On Thu, Sep 17, 2026 at 12:03:36AM +0100, Wei-Lin Chang wrote:
> > > An open debugfs file keeps the KVM structure alive, but does not prevent
> > > mmu notifier release from freeing the stage-2 page tables when the VMM’s
> > > address space is torn down. Therefore page tables belonging to the mmus
> > > could have been freed when a thread opens or reads the ptdump files.
> > > Take the mmu_lock and check mmu->pgt is still alive before accessing the
> > > page tables.
> > 
> > As Sashiko said, the read_lock is probably enough, including the existing one in
> > kvm_ptdump_guest_show()
> > 
> > With that change:
> > 
> > Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> > Tested-by: Vincent Donnefort <vdonnefort@google.com>
> 
> Thanks for the review and testing!
> 
> I agree taking read_lock is enough for most of these, but changing
> kvm_ptdump_guest_show() to read_lock could result in a dump showing
> weird output e.g. 0-sized ranges. This happens when the dump reads a
> block, and a parallel fault turns that block into a table, and the dump
> descends into the table later.

Now you say it, I remember discussing that with Sebastian when he wrote the
patches.

> 
> This is debugfs afterall so I think it isn't a dealbreaker, but it adds
> another purpose to this patch. Maybe we can change
> kvm_ptdump_guest_show() into taking a read_lock when someone reports a
> scalability problem when dumping the page tables.
> 
> I'll stick to changing the other ones into taking the read_lock now.
> 
> For future reference: KVM_PGTABLE_WALK_SHARED is required if we want to
> change kvm_ptdump_guest_show() into taking a read_lock.
> 
> Thanks,
> Wei-Lin Chang
> 
> > 

-- 
Vincent
