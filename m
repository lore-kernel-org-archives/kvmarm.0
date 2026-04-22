Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB30623AB9D
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776864963; cv=none; b=de49dziFjMP/DIxPHZwg4JR6h5slwSliNJgTTMk4Pdt4oM+rsWcPhul3zZzymt/KpKSDk/Olnr9ihmNXKrgzI4ymrco8mrZGmFgml6XzyqdHTPyFF4o7T1Sb2kVxxQWKC4RUcLywSumJ1v5LFUwgXoPPLQtXFNHJFluIaWWhaxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776864963; c=relaxed/simple;
	bh=hY79lEU6UkHfJzfkcXHpxlKi2jbwTblFNPx1u51s9zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hShllZQckzcsDaH7/wVHxCRSecpxO9VRdxxUY2+aUoezRsfJ9JbbYxs3pW24gNCa/+u/y7T4S3H/u+ByHYn2nR2nV7tkJp10bjV02NNH6SFheQ2H24N+4hTNs7WNlr3YhuSm1g/R5TVHhmSa36ODgh5WmpYhDLp4GVRsFJnFG0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mCZs41Xv; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mCZs41Xv"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-67148a70f8aso38525a12.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 06:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776864960; x=1777469760; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KxHtXNRYtwufGHW1ufeXFPBW1zoNUni80T80czPie2g=;
        b=mCZs41XvzlluCpeGExhpsyrvTY8KVYz5bYUH0prfvpf/wCqoV/ZTH3cJbWBLIETWkp
         4ISJlsjuXOPUVUQnJlOy232+cs6nvWd8BdJLjWXJyi5nA563dG5krnPWq6d6wsXrvtoS
         xoeFyRMCoT2RI7uuudAqPQKAZgB14h1P9ZzjxXKNr98/k7TYGRs/CX7ZvxCSVEycoXHU
         WHuM78RrIU+9TNFXUjzIXii+UJSKi+DR8P8ssYTETGT1Lr+rL7Tf0yEjOwTfwSncpMfb
         +A3LUcjLfW/lehiJigPtJEmY3Q/7n/M+6KDVZ20+at1VbSlksVOSSB3VnEcAJyjWTqXL
         M3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776864960; x=1777469760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxHtXNRYtwufGHW1ufeXFPBW1zoNUni80T80czPie2g=;
        b=M2aL1hv7NhQIqLMWr9LYMo9aA8EekT7H3pLcNm+BpK1FYLHRa+4Qr9HR80i99+CG4/
         aoHVXeZp0PMiykO0kQTzkQRs+TJtAvqFJnUJ8WIExS2J0cmSSO7Cc+ZOueXhDh/xfREa
         3L2ht+7BuMHzLmX3JkCuelhLwMzF1Lg4QhC33nAW65hkm6yUwnE6ls6TqpKTEUAYSSfI
         By4y9zX+5FJ9JZ060B3wxqdxDhSeqdGHmwJaW5bz4DuxE8PEY7tABGXvFK741jyry/1S
         6nvJ22U5AnE+60y59fdwx2XmMAKWuVuKQXDnln8inBA/sp3Ft+Lp/86OcUQLDHnxm7df
         GRyQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mnK4XMi1G7QdptUG2DQTf95qUicQaIwxHD6tkPzIDQvAhaESQjyCvZNw307JKYjD3agWBD9A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUO4yoe1nkZ7JwhpBUIMvwWasXnwdKicNIFsJzVddtcMFjlvjv
	zBIBDOAPEGUGSfH3EysclDiOaIIdqxlgXnUAifJaJlQUk1/bS90sJ7aoKfXuWcYrLw==
X-Gm-Gg: AeBDietRAHLHhY1K1IyrsRWD3gknx5vuuqw5iCV4RIQL04qhM4QlTeejqvOC5KOCUL1
	Unn7QzcamXYwGaDUyfi6LpDc4SzIYtkk1+R12tt86wP55fTEwkXOfvGpesWQD7xGi9ckLZJRAel
	bu6LSbLtrTxJzCIMmozVqgVfrH8jr/XbxC39voPxUkSHdp50Px9rf329wCmUXjV6Uw+oXGk1Mo7
	5TPT9jWqrchhybYnFyK10oCsAmw1jv68wUTGwN37Xa6DZsD4/MDPivV/8AEKLwXRgqLoftiRfYO
	Sic9vHhLA7pQV/Eby+XCwOatDuObpTCgQ2fbDTdlCSCnLaBu611iYza/iXAyq4uEUxF8KXmjNPS
	THMA9w+UGHvfeW6lS5L7t7kW59uCugjkNPt1Y6Ujuop8dbsLLu9YZKtlV3Yn8+19Mt6MCnW5VlF
	k1hY1k2Gj8Zwmex2jAYs3msvCadtHpCw0FOvq2R1lmzsLHujfwJJzHmUw6Dbupw4VRPkjcCYUcM
	AuRQUK/OoMb2aBnoJw=
X-Received: by 2002:a05:6402:3489:b0:66f:d653:92c0 with SMTP id 4fb4d7f45d1cf-6744d7128e9mr261268a12.1.1776864959480;
        Wed, 22 Apr 2026 06:35:59 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba451210e3dsm550252066b.2.2026.04.22.06.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 06:35:58 -0700 (PDT)
Date: Wed, 22 Apr 2026 13:35:55 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, will@kernel.org, ayrton@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Validate the FF-A memory access descriptor
 placement
Message-ID: <aejOu98q1lEZoFfW@google.com>
References: <20260422102540.1433704-1-sebastianene@google.com>
 <86bjfb18v1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjfb18v1.wl-maz@kernel.org>

On Wed, Apr 22, 2026 at 01:24:02PM +0100, Marc Zyngier wrote:
> On Wed, 22 Apr 2026 11:25:40 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > Prevent the pKVM hypervisor from making assumptions that the
> > endpoint memory access descriptor (EMAD) comes right after the
> > FF-A memory region header and enforce a strict placement for it
> > when validating an FF-A memory lend/share transaction.

Hello Marc,

> 
> As I read this, you want to remove a bad assumption...
> 
> > 
> > Prior to FF-A version 1.1 the header of the memory region
> > didn't contain an offset to the endpoint memory access descriptor.
> > The layout of a memory transaction looks like this:
> > 
> >   Field name				| Offset
> > 					 -- 0
> > [ Header (ffa_mem_region)               |__ ep_mem_offset
> >   EMAD 1 (ffa_mem_region_attributes)	|
> > ]
> > 
> > Reject the host from specifying a memory access descriptor offset
> > that is different than the size of the memory region header.
> 
> And yet you decide that you want to enforce this assumption. I don't
> understand how you arrive to this conclusion.
> 
> Looking at the spec, it appears that the offset is *designed* to allow
> a gap between the header and the EMAD. Refusing to handle a it seems to be a
> violation of the spec.
> 
> What am I missing?

While the spec allows the gap to be variable (since version 1.1), the
arm ff-a driver places it at a fixed position in:
ffa_mem_region_additional_setup() 
https://elixir.bootlin.com/linux/v7.0/source/drivers/firmware/arm_ffa/driver.c#L671

and makes use of the same assumption in: ffa_mem_desc_offset().
https://elixir.bootlin.com/linux/v7.0/source/include/linux/arm_ffa.h#L448
The later one seems wrong IMO. because we should compute the offset
based on the value stored in ep_mem_offset and not adding it up with
sizeof(struct ffa_mem_region).

Maybe this should be the fix instead and not the one in pKVM ? What do
you think ?

The current implementation in pKVM makes use of the
ffa_mem_desc_offset() to validate the first EMAD. If a compromised host
places an EMAD at a different offset than sizeof(struct ffa_mem_region),
then pKVM will not validate that EMAD.

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks,
Sebastian
