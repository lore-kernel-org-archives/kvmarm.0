Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502454;
	b=qvcFu+qRP3ZT3VFKBR423cQFwVJPGdOEkjPyLr4bngV3w4nlwO+ODNufk8RMZHrLBID/
	 ZTQq65gQIHqGnUXs2X+tXgPd89MUsj9CWJVLeFnwgw63po2bvE6Zl5bd2kdq1FpeSNWl5
	 HhmRkKMJL8hUvxbF69CyYwf6CPTDF+u7cac6FtwAMBOZsNUvZ2PT1kcfLu+pgtu36TanS
	 8+Kzi1vETM1geyHG3P3u3aqYn02gfLNXhTyBy9/dGhdHof2JdhmODsaNcpvSC+Eg2wr2w
	 50MpBEYLv040UbYE77MefKXEBcP7MHnINzVP5uyzuUCCHD2OY36Y15BVd9JbKmOBpPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502454;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7hOOdwwvS68qb6hsI+X6Jqe9Kqp84lfpxhjnWTc5H9M=;
	b=SyPLPsFlsde+v3LQH7nbeLkk6x2bFfzdBnEjfzszgjeRazdyuq8UtCp82ZiB3+AXl0hj
	 hOU2XXmOC21g2F5tUE61Fbr+1YEDpJMPb01kGKAmGTsSdSJi0vC3s3ip/CYLo9apd+PAL
	 IefV7sB8mEVlIBTziM8WjuwqXTK7rnmnLARfL56EPLcpVwe3ttzTXKy+vR5oguPfTywfA
	 2Sj3j24jlr7086S7Mp1PFbrpLtb8yonHj6qPdoq0Z6ypVJ3LsKD2SPVosdajBj+avw5KA
	 vhu/bzfq6uPXHdJ34IT4zJkUvl2Rd87AVs8OXr2K978L4kmHA4oFehYh5ttzFgKBQcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NChkwsKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CE1606A335;
	Tue, 20 Oct 2026 13:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NChkwsKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34F41F000C4;
	Tue, 20 Oct 2026 13:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792502454;
	bh=7hOOdwwvS68qb6hsI+X6Jqe9Kqp84lfpxhjnWTc5H9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NChkwsKKEhQs6KtzcgJns22pF4ahdQVZlJeAmMNPOPWfHAEB/j1QoKfgeDihzA7lg
	 zhtkmBeyDaVMsBy7h8xND0Jx2P1zx/LHEJia21IDAiv7qxWjJwIz2dlH78bGQ6Lbjn
	 ixr/ZhWOFYvMEhU//Fq5Ez6/ILtSLApvpFEJM8IkDRCHdsR4G/E1pa2qJwStVBMmOh
	 VDWxUIS0HmWsbayWWYUiqbFuZvpbmaSqBw44jpdwf4roTbaaCp3iyuUEWrcCbs5uKh
	 VR7aTwGqwyZGxNq/zz0Y/csSO5wYNfoOZwIc2EXrSLbKrflh+5gH/QfV1vVHiexhSb
	 i601AlAGcZjwQ==
Date: Tue, 20 Oct 2026 14:20:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Price <steven.price@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, David Hildenbrand <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: Sanitise MTE tags when a permission
 fault installs a mapping
Message-ID: <atdqkJty3juWpngu@gremlin>
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
 <20261019132103.3836646-4-fuad.tabba@linux.dev>
 <atdXdtXXTH-6DWVt@gremlin>
 <CA+EHjTzH_GA=Vigd_nDXKDFAPCJStcANFFLeLXvsh3UqpjOpCQ@mail.gmail.com>
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
In-Reply-To: <CA+EHjTzH_GA=Vigd_nDXKDFAPCJStcANFFLeLXvsh3UqpjOpCQ@mail.gmail.com>

On Tue, Oct 20, 2026 at 02:17:00PM +0100, Fuad Tabba wrote:

> > In the else branch? Seems neater and clearer.
>
> Agree, I'll move it there in v2.

Great thanks!

> >         if (is_mte_fault(kvm, s2vi))
> >                 sanitise_mte_tags(kvm, pfn, mapping_size);
>
> I'd rather leave that out: the fix doesn't change that part of the
> condition, and it only appears twice.

Ack, just a nice-to-have that. Not a big deal.

--
Cheers, Lorenzo
