Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795461920;
	b=dG48OIL52s4oBlb9i5N4aHrBmMiF+kKAlfWZlto/Fmieia1LsBAsmmSmJ0qiiI+mOO3X
	 ctNJO7bINhGa0yGQMVR3stabipxGRei0m9A8qi53MTfxW1ZUK9l1K5iODNvc0OnL/hqaI
	 iVXR9iu1FZcSpgKIdFtrjbZbAfHWc0/u4cb4uTtCf9kP6uX+YwvZzbrEU/sPopD9JiCZ0
	 CaBC6RNkdqM1Uj8pZ4SpesmF/nZ0y5Dv6+iVVwl77hU4dpiUBWzkGNP5qqy6eEvAGeFGs
	 qWex+9sGEC722IRdWbbARC6xhPCutsbICXksUovEjrkzZ8nvJfzAMYI0HwhPCUL6c2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461920;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Ivc+yZF1e+YkHBH2XdPHCIshByex18b++1Ftez3VniI=;
	b=C2LILcypnPszC/sq1KHHtLlwlLluR1xmihZxctDrH2kX0fvl/ejhjgpX7iMFEOMGcPN3
	 8D2h2Aq/qaOMJr/s4T0GBR0IvSwgodcR4VhOXIP9zRGJ/mXxKhf/+08FKr4t6HOKWPjFD
	 BysosnTif88itVJA1t71AcaPzlB2nTW1kT9sNBfxGoYwVCLRtpBpzNOrKxueTZpsaeifl
	 eWcmn+NdxLfydSX703ExhmKrxC0lKOoe8+n+z8Cd/5KVkwRI2k0r5rUrBeQMbq+wIDBMY
	 rNdHwqfxx3/L93SWL4UlmYMgYtGLGdPIJdwgxgcb3IDYRgwirATnzeSWkfdfUOZLS1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=KeqImWCM;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BAC606A321
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 19:25:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6BAC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=KeqImWCM
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a210470b49so36215915e9.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795461913; x=1796066713; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ivc+yZF1e+YkHBH2XdPHCIshByex18b++1Ftez3VniI=;
        b=KeqImWCM/9fSw5XXICwDpLbofnwB+fY/ixW+0HlvCU0UbcBWLhvt5wuraUn6Klqfm4
         zJiQZT1HRx20enWhohckf+PMObD5YAy1XyBX9XD9gP9KTFK4HcOYeVQHxML42b/gKfRb
         9uHGHK8d8D4DDjU7umpgGEGdGBXzJG7i8aLAAni9ZFFnwaxTcwihAv8ipruQF4hq7zY5
         DC+31DN5CmpxwNW5YBb+YhDqFAlkBLRcYArob40vFjvdG4qGFvwWFHtneFCe223m6VD8
         raHQQTwJ7aSUk7I7h35s4DjGG0gjO6bAtKJ/QEnFy1AcZl6nXPqEaKfhnGkBFvgYH+jT
         fMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795461913; x=1796066713;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ivc+yZF1e+YkHBH2XdPHCIshByex18b++1Ftez3VniI=;
        b=RUtnrppv6xzhHMZtwl3VT87lpLvveOdB6NL1PJ7ark8ePxV1Md6YWIUUFTqDLmq6xO
         GtVEM5tO20FN+il7SrLu9Vu86BYwHzQ6POdmI2pjU1UC3J09gQ1NmvSsFj89huZ+oLA7
         UR2kqTykohjcmkNhxekg54xmqudb7og09DtRi9lTpLVF9RuRpWnO7kMZFgDFPtkkrInb
         fAIEFPaef6a2reBvb4jHXAhW18nx7JUdFH/Slk6WZ6bjue67ZyrLqi4D3qWkY95cBy/t
         2EooxYvx3LOHc9qqrGfT+oNo2P8j1rZV4+d98qfKpiRIQxfBfTnVD6JaMPN9+TfM0s7V
         w7fA==
X-Gm-Message-State: APuU4Z+g8qV0IXejitMqhdvBbWhbtQflzR0vOD3wEWTr8yRJ+gKtuit8
	qSDKQC0aOR+P2CesZ+otiROAQzzW4IcI8J7G2Fmpjb+YXD1E9su8RzWg8RxiX3r8F38=
X-Gm-Gg: AZFdTZciPooda+MRbJ5ajRh6b9aGqMy4tTV1PTyGRLQvC38NjQWhFZcEhkwAOxSFRYC
	VCqmDTHDym75LAFW3W7SashK28KYUmIBj4pmYcsYzfE2DtuY2MBSukH5QG3Q9V29JMKOQk5oWnr
	6cObDPyDHBAsQviZo9ryqPzUX7kwT2OfAz61qG0nEn9wmjT6nnqP3yQ2Rx1qVc6OONzPfqYjYP7
	7945pklaVo5vWA3ZSD5Rvv1NafoLXuqUkunNGCgEblGdRUuZEZy+zQGPKic3OOc0R6ydxDyN1rS
	dx4RUgBizxYZLO1Jy6+VNO0fJF99OHLjCMh7USwsY6s5RmRBAzH8+d8Z4d4pNaj76f81OJYb/ty
	xaAZE/22P6K5fhDakcP1S/NE/S+YjtVkPpOcmVTVM7Lj5bse/Qkn1Q0IXp5CS5R1sWedRfdx91X
	4+kGWFuqWiFL+b1dPR73wFrpYkiMVam5w/craTLxbWiyLf9Y9C7cucLA3Na8ZOxcrCKYmG8wXRj
	B3hbMru8yurDFHZkCBGmSJ4lvPQmMpzwJ8jlxJc9hU3CZqavei/qBX5Cr+KvHj8yhb1hkDnq1nY
	5Dv+9f9pjy1YmTEmHj0=
X-Received: by 2002:a05:600c:670b:b0:4a6:30c3:1114 with SMTP id 5b1f17b1804b1-4bb88922df3mr240330235e9.12.1795461912931;
        Mon, 23 Nov 2026 11:25:12 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884911e3sm442986305e9.6.2026.11.23.11.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 11:25:12 -0800 (PST)
Date: Mon, 23 Nov 2026 22:25:09 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Upgrade sub-page TTL hint to maximum size
Message-ID: <awSTFVxQQuz1tbk4@stanley.mountain>
References: <20261123182312.4842-1-maz@kernel.org>
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
In-Reply-To: <20261123182312.4842-1-maz@kernel.org>

On Mon, Nov 23, 2026 at 06:23:12PM +0000, Marc Zyngier wrote:
> Should a guest be slightly foolish and submit a S2 TLBI with a TTL hint
> that describe a base granule size smaller than the host's page size,
> we take the resulting size at face value and feed it to the S2 unmapping
> code. Which legitimately screams about something not being page-aligned.
> 
> The architecture allows us to drop the TLBI on the floor, as we don't
> support a S2 granule size smaller than the host's page size. But it turns
> out that doing so is proving pretty hard (we call compute_tlb_inval_range
> from a number of places, none of which is amenable to an early out).
> 
> Instead, detect the annoying case, and pretend that we don't have a TTL
> hint at all, leaving the size upgrade mechanism to take place and use
> the largest possible size for the guest's S2 granule size.
> 
> This will still allow nonsensical stuff to get through, such as a 4kB
> level 2 (aka 2MB) from a guest with a 64kB S2 base granule size running
> on a 16kB page size host, but that's not worse than doing nothing, and
> the host code won't get shouty.
> 
> Reported-by: Dan Carpenter <dan@pereq.eu>
> Link: https://lore.kernel.org/r/20261123-inval_range-v1-1-815e15797089@pereq.eu
> Fixes: d1de1576dc21 ("KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
> 
> Notes:
>     Reposting this as a first class patch, as I'd like to plug that one
>     as early as possible (and Dan has plenty of other patches in flight...)

Tested-by: Dan Carpenter <dan@pereq.eu>

Although obviously zero is handled on the next line so there wasn't
much call for testing, but I still did do the testing.

regards,
dan carpenter
