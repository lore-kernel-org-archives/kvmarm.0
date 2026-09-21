Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18934499F28
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994249; cv=none; b=tCy391gTYhhYcncKgxU/QwFqto4Zq7Yvoxtydb2SpZ3pFprsjVqVnXJPhqcbiCqgSh0V0Bl9Prhu/VzG0xL9oARJNAagbhOtYeCcnOKfeM9y0gz1TEks8zoI0ne6aEacGjG+OCLil65fSVw7Squ8faV2Gu9QzLx15pevSN7a5DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994249; c=relaxed/simple;
	bh=+Hm52DrFJhVzTImXmCJeMk9yT6JstqdY7Mr3vv4AxKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7gUQChz86EafAr05A6furkKJkPpkQjtvYBZDTuzqjJCmqUvYHWlnw7xU5pHc8JTx5Ofak3lZM8L8YHAuWeBduSZP5r17HiZC4wkSpGVYH3GXbrdLUc7rZGGronzFzfCcfy4yLfSiTLq+qoBvlgBP5+/0PJXNX/n9N5VIPHeDs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=NLs3h9Vl; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="NLs3h9Vl"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb76906adso44278381cf.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 05:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789994247; x=1790599047; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Hm52DrFJhVzTImXmCJeMk9yT6JstqdY7Mr3vv4AxKw=;
        b=NLs3h9VlvshFYKj+FwWrs0XtFOS+Mc7miYFokVGwntH5cw4PSAz3fmCGt76yBXgwFz
         5uF8OiBD996Ji/OvhPveBFRGeW1ZaSYeh3GEcVQt2Z9cVi5T+Khe34mzkRNK1gQLHoYj
         is0jrZyNQXKoE6v8eegpcvyqFLuVJX10DBFXxHSHyYodWc1oMpoH8meUOgUAhQW4MxHd
         7nmrR8zDJRQzbAFjUs4hqgD9u0+4UwZXH5Z1x1xp/+SMzPQpl67eX4pH/ZZMp1muWyzj
         j6NFpbPc4GE5NK50BPLK27SSqWHxdHg6xnTyxyxLgdR1AuRxVkr6j6PahF5GIfKqVMXg
         SqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789994247; x=1790599047;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+Hm52DrFJhVzTImXmCJeMk9yT6JstqdY7Mr3vv4AxKw=;
        b=Jui4C7txZgInlvcUrOSWTG+yB42J+XC4v+/kruRqotxdoigKRwlJ1fZg+hunWkViNY
         hyFMIBrqkU5a3ytv/8hf+aKYp7sO1OQTGzH+80Jm3yf1xji31mO+6UAfIzxkc965gc11
         /vJYztS9jPWpeqO+UgFLwqu3wBjZhjVz6UfZpZfQaE6qutgVRbAe/YmJFtb3R/nLuLo2
         gXZ/TT3cIUaPXGMXSf9pOcFCkQ1NVwQ98uKzXqbT/FRrCCtkUKLX4FmdSzNfIYwYtdqC
         ezCRrvwfNBCzEsMz89xkEJFJCKoPC7dd3Qb5KlFrqTV4w1QY6V+YkNCFpgbgyh6FLc+F
         7Q5g==
X-Forwarded-Encrypted: i=1; AKwUvByesotqGfmmXIsj5YNwtqmqp85z+FVre83mpR9xCVuCAYfcm12D53d8utqa02OJ69Sp2o2H0hE=@lists.linux.dev
X-Gm-Message-State: AFuF++m9tf/ICTSMpB3zrODUwWQQMnTVm9V4H9pbQ00RDR3Ai8CzWRa8
	z/7r2y4oQv+9DbjlIyLH4rHotxcfKgoYRCRyiBoC4xtJWAMLES/qGUOhJbPqzbVTI8k=
X-Gm-Gg: AYBFou0NZwfgMIC2+vJveFTyPCqRmjtUJ/0P3VXKXSdkVFBo/i+3goZvmmsyNNlwN8v
	RuAX3Jd1xYVQM/M4fSlcOdQN+nj7YaxQbdr7HF01EfbvObAGXlQ//sTq6HyES6MGnzbitW6CFL1
	Y5ugfPuaxS2kzgQqvpkqwD/c0+bUb9ypPnGkA+R3dUGjrSlG+RWBSIwjclQwoWUjouuD1SmFT9x
	ebjclx/s8g2EbGSJSIVlkWdgB7Z57+6o+ILPBPzh9HCvQj/hiZDvPy/eyRHZMImKunJNa8Hz7Bl
	NI3kU4aew0nt02M0iIy4Dzd+SilUpSnYe0Et49JQNAzFPsD7fe7mVr/0PeMs3As+cRusqLNHj+G
	cv150Pd3Sx/z0EHFHxGDdciKaGC9YujbM6awqHG6cxvctR4fpo2J0arBWyF/au44XRE0LLE8rsE
	oaBtDi46gDiPXt7dFCxwofohYA8qnza0Fe3KyyYI707VDo7l/cuf43t+X/H7t2gwNxLpu9DfmhG
	CyApKvThAHKTJtAux+y9oVqWRdZ88lB0b2db6lvfEK+3w7Me56HMI9zOeCzxbG9xhE=
X-Received: by 2002:a05:622a:1311:b0:52f:a0b3:bcb9 with SMTP id d75a77b69052e-532d8cf35b1mr4406171cf.10.1789994247006;
        Mon, 21 Sep 2026 05:37:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae77acccsm63282941cf.30.2026.09.21.05.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:37:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x8dGv-00000006HZy-3ljy;
	Mon, 21 Sep 2026 09:37:25 -0300
Date: Mon, 21 Sep 2026 09:37:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
Message-ID: <20260921123725.GN11599@ziepe.ca>
References: <aq1V3oeDdvXobt8J@arm.com>
 <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
 <20260918153642.GD11599@ziepe.ca>
 <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
 <20260918165315.GF11599@ziepe.ca>
 <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>
 <20260921115141.GJ11599@ziepe.ca>
 <45dd7a2f-8474-4388-b383-2dee3ee62206@amd.com>
 <20260921121739.GM11599@ziepe.ca>
 <cd2b32dc-5a80-4ef5-82bc-dd41ea96dc01@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd2b32dc-5a80-4ef5-82bc-dd41ea96dc01@amd.com>

On Mon, Sep 21, 2026 at 02:24:21PM +0200, Christian König wrote:

> I also don't see where mem_cc_shared_granule_size is added?

Patch 1:

https://lore.kernel.org/all/20260904103452.1197239-2-aneesh.kumar@kernel.org/

Aneesh, please be sure to use get_maintainers on series like this so
everyone gets cc'd.

Jason
