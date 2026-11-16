Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837884;
	b=GhXLIKYLv2dNhWU5l3gIfltQ46J3U28zJ0MQfE9CXyMoirOxMSqEh2Qw5GQu1Ourrb4x
	 kypvHuhJsc6cOlXjMqPM1DKLMWFDDnCLdy9VTyPgpH2tbZ+39V0yAwQR45S8WDx7cZefK
	 lf6tK7tLi8Y2jLx0MnAqnLonFIOQPKPmauNDvuZItQ4A+gz/P6BVl/P+UH9Rih+WNBaS9
	 YfDXjpnVAFXkFWBqMaKOfWcuUVdWee44SY68M/h0MOZZQc4eeBU2uRTL9daLDI/QvFmqT
	 Z/Qa0kz0cMtiT8YiScOq9o44DACD1KE2GUsTyvahNdMZV8wklnmRwhuXjFHc/Aa+mXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837884;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=S/rwSMYRmKycQT+Q+WaK4Jt3aNV8OhLQHxBDEKKQbT4=;
	b=TlJmSLNnxP8C7AgYaVBakak+w8Pt2cDCZXOSyal9bT1qn+mQQvQfHJXWC5mhx9KkIvxX
	 jvGj/nCxxkuZc7J+Qs9tavIO1jJ30fUar5qHhPpM85oqmXAZsTzWyi7yBgXcskc9p4+4X
	 Dgx4AgkDh2PPdTEQoagbfQtSb3UEuCHoum9FLB6xUrQE7s4qpn++9v4rE2X++BO2K9FEF
	 ASIJI6fmlhXU384Qe1I943VqkBy+A39b5ZNCwJ+lN4Tc21n4DoF10t2JV6exV9wJljW4h
	 tvsHIJhwCeI0tCSga77+9xbGKRi9NrWTdeQ1YWKOgyY8VZrwQsNzUWOC/OTM+eZA+lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lRwku5wE;
	arc=none smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAF7606A323
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 14:04:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FAF7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lRwku5wE
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bccecba199so3838742e87.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 06:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794837882; x=1795442682; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S/rwSMYRmKycQT+Q+WaK4Jt3aNV8OhLQHxBDEKKQbT4=;
        b=lRwku5wEPZGBycPf0+L/uO5RADc61YaWre3GZPxrYjMOTjrBw59uRV2EkQLPG93Am+
         WwBXKRT94x3us5FDC5XwDWzARqx+9avcFmCgCytvCT4mNVECaN1NzEsf7Dit+tRM51E5
         eVEThFyUUZvk45kCDmNBmH888MBRi1ZjHOpAIimkBKEr5anNUXy+rAA/MKtpE5qkOQCo
         AseB3jeyskRZwgSz/ChUdBO1E+O/YoeAMxUwXT0+H4qazwLnne7LOps0GS5WinyFuJm3
         YOoR/bnEeLpIYD7/0e8g74VgYT2Oh4pjmvld0LlRGe/atnqqM95a8nCXR5NBrO1VYlVo
         PUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794837882; x=1795442682;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S/rwSMYRmKycQT+Q+WaK4Jt3aNV8OhLQHxBDEKKQbT4=;
        b=LyryusW1HPRnC/oEwg7iFQAfdOiDgwXQORt107af7Rbe0qKl0dUidj193i99rsAz92
         eFBCoNcQoaXbMsLHM819lXHlbj2k6KmTewp+yP3RINgERSjyS0zxVPJMU7mFBf74etec
         +ty+yNj3hdnMqMF5bTb3pn3i3215b/CoxgWY+1w768qeATre86zuG14MxHAIcrRDPj3D
         K2poeFeN5BpjqNvMOXvBHuNURbEGkr84j7fwQvXvINtd0tcKrX5YKudeAhfpojSMN/Xn
         G/S2eBi3UgS/v6bqmAvvoAfmGwS4l6k3JfwTQ/5Nbc6j8vmw/BTKOBhcze4xWT330X4x
         qUKQ==
X-Forwarded-Encrypted: i=1; AL+hErG2AjxytTbctiiG6tq716IDifmqfZ+UscnrHk/2raSVuSWmMtJjkUE9b3rzQ1y5UDsSRk6H720=@lists.linux.dev
X-Gm-Message-State: APuU4Z9sRBDJYbFVcK07iJVrD7g8ZlqDEGpEFtJpB8mcn5z7BQxLTmmU
	olUZx5a4PU7Plo2Zngrd8eiCSBGF5nt+nuX26OcEjL86s3MWfbBa3w88SPy3rbuzEA==
X-Gm-Gg: AYBFou1c0BvtRxLJ4ZKekd8mRmT6STCZa5tNj470YQzn2HYkS16tHv2KjGpX5b4TmqS
	w99tnr4VJvKyupzYvvk8Z1O937HpCqpvi3Iu/hCM9x9vDxg8ayS4BSNqYdMpmNrXdBgSa3X70CX
	kbo9iUboZU7jXYp5MRSK0iEf2sqTKfBAYoHwiQbWxzFxTfxz7jW5ZraHRcYCrY3vfctQM3Qhwo1
	08FGmlx3IcL6tFowmWaKNU1qytuXRqDli3TXOBktNe+UXxgrCyfbIzc8cuXqiuKcSgWCgkhz49t
	ZgxWjQhC7wtKiMgLweE/69kqBrroEuxubqi67tzUn7/rKn2VjN+4g3audXewlWVy3I2iUmxyhCC
	2n5GYFTIHGjPeJ2XwNL9RCq7n/HrY0vbNcQdVkuuiwsGodJaOmjcKksJPnKyGh+l7tgvdG8d+x1
	ymBDwR8yFIvKO3Sj8zZAdOnMQK08PKbIjdoW+dAzYYCgKFk64FLZLy/ITlx9dV49ELDgLCGGCmQ
	OOTLKB1VWLnHlT4878gPbuo0v346hiYC8xXz09feLZUKbV9LvAejeoN8AVrcm3czCr4hdqJy8iC
	KuIRDz98yVjn8Q/jrvWAyzeEf3K9367VxO/ElCZ1ZpXyumme2S+jjDbySo2JKit7LQ==
X-Received: by 2002:a05:6512:2208:b0:5c1:5970:ae1f with SMTP id 2adb3069b0e04-5c170a25d42mr3870536e87.63.1794837881958;
        Mon, 16 Nov 2026 06:04:41 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8d66esm20599601f8f.57.2026.11.16.06.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 06:04:40 -0800 (PST)
Date: Mon, 16 Nov 2026 14:04:36 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] drivers/virt: pkvm: Zero and clean memory before sharing
 it with the host
Message-ID: <avsNdPissIDAb1hA@google.com>
References: <20261116110549.1863653-1-fuad.tabba@linux.dev>
 <avro44jUWOARFzul@google.com>
 <CA+EHjTxWuiyjmUc3vH_KxRtS_3oX5w=CE76LdsLcrqC+RzLGfg@mail.gmail.com>
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
In-Reply-To: <CA+EHjTxWuiyjmUc3vH_KxRtS_3oX5w=CE76LdsLcrqC+RzLGfg@mail.gmail.com>

On Mon, Nov 16, 2026 at 12:25:43PM +0000, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Mon, 16 Nov 2026 at 11:28, Vincent Donnefort <vdonnefort@google.com> wrote:
> [...]
> > > +     /*
> > > +      * The host can read the pages as soon as they are shared, possibly
> > > +      * through a Non-cacheable mapping. No caller relies on their contents.
> > > +      */
> > > +     memset((void *)addr, 0, size);
> >
> > Are we sure we want that? The guest may want to setup memory and then share it.
> > I am not sure about modifying this API.
> 
> Right! I wanted to fix the bug for the ITS property table, which is
> shared before it's initialized, and totally forgot that this is the
> path all sharing goes through... I'll drop this, and put that fix back
> in the ITS series.
> 
> > > +     dcache_clean_poc(addr, addr + size);
> >
> > I believe the hypervisor is already doing the cache maintainance when the page
> > is mapped back into the host. (see stage2_map_walker_try_leaf())
> 
> I don't think it does on this path. host_mmu.mm_ops doesn't have a
> dcache_clean_inval_poc() callback, so stage2_map_walker_try_leaf()
> doesn't do the CMO for a host mapping. On the guest's side,
> __pkvm_guest_share_host() only changes the software bits of the
> existing mapping, and the walker returns before the CMO in that case.
> 
> Cheers,
> /fuad

Ha yes of course, that's the host s2 we are mapping into. And on the guest side,
we are only changing the software bits, so no CMO. Actually I should have read
the comment in stage2_map_walker_try_leaf() more carefully.

That said, I wonder if that shouldn't be handled by the hypervisor, just like
hyp_poison_page() do the cache clean.

That would be slightly slower than letting the guest (who has a mapping already)
do it, but pKVM is enforcing isolation between host and guest, and it feels like
it should do it by default no matter the memory transition.

-- 
Vincent
