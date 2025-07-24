Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B27F1EC01B
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 23:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753400814; cv=none; b=VXs5Bm2X2xzbgoj+Y8eUGGjSn1oEbS2UeKQYAYe4Wvs2KCGb6TECJNywAOEHrPlfHv0OMMe7zGRRfrnUBSbYzaFxHBAAbQFQdXpm5/LSshjCOBYerX82O+3UZG3kTqjpQH/N43xHsxTXI060bh4BsKkT1v5O7Ooih2JJMxt3JfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753400814; c=relaxed/simple;
	bh=Rq+CCcHnbrLIieKNkCZNAlk2vPBrV5d4uE0b045YV0c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SfRpeF/eug/Zf5CG3jDUkIyVvCcfoImzlwfBt58d3LHQU1Hr8o9ORaHIzwJiQBSDR3C/2o9lNbwOYR2hbmssmPqQGe6cnA+fWXeTqzmBly/leH3dtFWoBNzcUrgFyvBZWbpSCG0MJoitnvoTXGpSlX8aYCFndGMFpUV33Q5rJow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i+dGSgat; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i+dGSgat"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311e7337f26so1493358a91.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 16:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753400812; x=1754005612; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rq+CCcHnbrLIieKNkCZNAlk2vPBrV5d4uE0b045YV0c=;
        b=i+dGSgatjaKt2RDr249gp31O05hrF8G7+wr572n7MMUIYrmfuN50gLobptQNC607DZ
         pKYX+m8j6VVn9rP2MaWGWQtIF/XucaQ0j71OzuCxpbjrkGSB8XdbAOlk8qa06wEnZGjR
         le8NLlALyrwVWimN0TBBaXpIrQSwTZmbNP4cky+HmyUkobn+Ckjkg3xuKG2wSeg9FX+b
         xTGk7TG7/fgT7MPCjaz15/YYnn7P02bdde3PrVSOnau/56q7twKJcthJkAAgYosu2tNN
         7LP0yCKtuGzdxE5WPdrpMKM8zQHc+MhLSkuFjrv+EtKqCb8J4saSBD9XAbRL1xLyqH6Z
         3Avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400812; x=1754005612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rq+CCcHnbrLIieKNkCZNAlk2vPBrV5d4uE0b045YV0c=;
        b=Bn6x9Zh0BTdEPJlkqjL4r05kHecISEI/1opPBMCBnODMmzqyMSW78TxKzbflH+4zAB
         rn4ADaOuMVPXfMfTNtBAf6gJ9pBMzt1pGOPwIT2ItmBecfVRGFFvtgsI5YxWG/bz91ST
         W3N9jtUxL+m3AJQJh8/JeAMIge76MV205te/iCH3oG6g9cAk4xyTXwa+EyM7OuI5NDTJ
         8CEjHgmYLzNWE4e+dwGx6k6q8Eqy6wgJQrqt9yZwiKH9a8DsVtLvSy09sX0YngtS+Hdr
         +8V2kAN6n0M5ewScKjj7IUDtWToKcYHKlSy3Ug+X2VM5KOql8FVd5FKJYar4Hk2EDFzO
         igWw==
X-Forwarded-Encrypted: i=1; AJvYcCXcHpJ8gJXREKgaZSxd4R9se/hwgOQ4kS+YfvPqw8WzbAmxrU5VWRNGz/STPaIZw+628iclTYk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxlPPRl9xefEPxvNlZs+P0VcwOWc4I5OVS6xu5/ygj9z9AvN0gE
	mLczEIEzfITIf03tIlQmpExN6fNZ0Gb2YpOAOR0y42ZyUYQzRdSQNWxlLpFU2pMa0bwlGVlU/SY
	di+19pUtPN7AIzTbj6E8UGh6yLA==
X-Google-Smtp-Source: AGHT+IHBbNLrQlITZTUEwJZc7PPMBuWUPvVh41ATm80JrPARR6vxu6fTSW3zd2GzVR7d4WnT1Q219CCX9tRIUbCxQw==
X-Received: from pji14.prod.google.com ([2002:a17:90b:3fce:b0:313:1c10:3595])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c90:b0:311:d3a5:572a with SMTP id 98e67ed59e1d1-31e5071cc94mr12799088a91.8.1753400812263;
 Thu, 24 Jul 2025 16:46:52 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:46:50 -0700
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
Message-ID: <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

[snip]

Did the patch [1] for x86/mmu that actually allows faulting when
kvm_memslot_is_gmem_only() get dropped by accident?

[1] https://lore.kernel.org/all/20250717162731.446579-14-tabba@google.com/
