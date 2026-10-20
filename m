Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.79
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502613;
	b=4BiTjGt7R7NKcplU3jhA4Z/8gZmK4ye7LFtlWdxGsmHOq8Yc80DmPZ94W0URB7le+Mw7
	 chhaYZ/e8w/YKngpLQgL2JkfVIXe3nxc2v+fITVpsXRkcGqmM8TJd4dmMITtyHrVz+JFp
	 5XhFdMfWE2OAitHSyEj/mMeT1aP8DCW6/tggiTXSpjFYc/2Z/681GEfMhe3LVdRd8ll4i
	 1dsktKEMiqFovzBnh+s6wKnU6H4kifNtx5YYASriAUYJbE2cMqoVGQicKwqfv8yPtkguR
	 z4Bog8Gfc43UtTm3bGkWY/SjpSZLZduNm6yVsjXQkMmcn/oqpJlZZWf7T+Hd5eEooQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502613;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=vm6uQFMUOlEK8EAN2+0e2HbI3MSSUoFOndOtynycXe4=;
	b=NfRAVpex2k3ZGu+A1xMovLrbdolrBOKS3EeAQGn5ZfMA1iPEVaAz80sVgLztn1ikRfxn
	 7I0tJWLMg+rFCOSuRTu0IiOSXBC+XjbKDuv9BlLdrG2JBCP90MR2BrswkUOPi5/gmoUyT
	 VCH7dipE4FhJQ+6ruMWZswnKHVnU9fHshYKPHcLMgcS1bc4N/NR2UObwo5IpVmQ3ZyMn+
	 Vpeb/fhPVQqFT4yrFE9yB8PLXSjhN7BTNZmcjWPRNddmBjc02EKIOun469yt+6d4V2Jrr
	 szae6TCH/oYB5iVZFtEXMDleILVUCUdv2eYjg8gWUyRFxIiqpGjePoHv43ezS/WnNJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eXKLZ2CE;
	arc=none smtp.remote-ip=95.215.58.79
Received: from mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF152606A319
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 13:23:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF152606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eXKLZ2CE
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vm6uQFMUOlEK8EAN2+0e2HbI3MSSUoFOndOtynycXe4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792502609; v=1; x=1793107409;
 b=eXKLZ2CEsRs3cc8t/0JN+EqorP7f2s5GnSPn0qVrFR5E/YtNuz0eLndpRFgvebuRJ2bMgl89
 /Cvy2FUcXxY8yIJxdjQpOI468i+CzMEkGomyQapM2hgsT6WaXtWnUvghhiJdc6Gsi2atpRhlhfu
 5EFdthVLtiqTV7OGwjmBR67U=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1b0c175a14d7c5cc;
	Tue, 20 Oct 2026 13:23:29 +0000
X-Mizu-Trace-ID: 1b0c175a14d7c5cc
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so6919e87.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 06:23:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxPRaOlw8f4izb3clpwhMn8V9o3R/3V7dnd1+GlD5fSXTN7jeCybY5UPhwPFB4deqJZAQvGTDA=@lists.linux.dev
X-Gm-Message-State: AFq9FYIwwlfDLO6h9Klf/604k9SvWaqd8c1rh3CC60GAK40djGUjTv9l
	b0Y3nnG5t3IlV6B8xd5FsqgIqyrA30f+85ZZrw6xc1utrL6ts7jNKLc47MbW9td53NnshgHFP07
	i+W5T60AVJc12K2kxk3+E5wyi7+haE16NBidzxuiU
X-Received: by 2002:a05:6512:10ca:b0:5b7:6707:e44c with SMTP id
 2adb3069b0e04-5be66f2d62fmr149788e87.12.1792502608409; Tue, 20 Oct 2026
 06:23:28 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
 <20261019132103.3836646-2-fuad.tabba@linux.dev> <atdUzfOA1Obd7Mir@gremlin>
 <CA+EHjTykGoHmDt82Cz=eEeBoqpjDRnhKEVGnOhTprn4dLxLZKQ@mail.gmail.com> <atdoknSMviv1xdqd@gremlin>
In-Reply-To: <atdoknSMviv1xdqd@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 20 Oct 2026 14:22:52 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwBydjpMR+jheWzFBy6X+jXxvXF5vygfToHaTYh6XEcyQ@mail.gmail.com>
X-Gm-Features: AclHuK-B0w4gvRBhE874iuCL5xWD4kCqXtNGNKe6lqJ9UqbH-GMhLoiaQjnhj4c
Message-ID: <CA+EHjTwBydjpMR+jheWzFBy6X+jXxvXF5vygfToHaTYh6XEcyQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Clear the whole hugetlb folio when
 sanitising MTE tags
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Steven Price <steven.price@arm.com>, Yang Shi <yang@os.amperecomputing.com>, 
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 Oct 2026 at 14:16, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
[...]
> > I'd keep it: it's why the whole folio has to be cleared, as the flags
> > on the head page cover every page in it.
> OK, but there's an inconsistency between the comments in 1/3 and 2/3 (you update
> one in 2/3 to reflect what's happening), so maybe worth having the comment from
> 2/3 on both, rather than this one?

Sure, I'll use 2/3's wording in 1/3 for v2.

Thanks!
/fuad
