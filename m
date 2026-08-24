Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2000364929
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787584779; cv=none; b=Bcisjy0bwhpZZCXm2Ia/Tp/0GCIAp0bZnWbdFTDmbbE+QW6IRoM0mD2fwvBXvqlC6UTgdh13yqGCXKnbQpnm4ZTdOIJUwkNF2lsAg5OaUSV9U6C4e78QCa3NHoBGcHnX+zsyTPzFgcHQuEs2zbZZkPKmSW9hiLGcjmv0j9+S03E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787584779; c=relaxed/simple;
	bh=rDl6WQt8/u2b/vO94uYaM3pS42AlRyIPyx2BSwDwHyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBOKqVpFojdictGweCslgogPIOf+bwv90G5nGZ5t/EgXKtneEA0mdSskjrff3qAHT+1ZmrLoFnzawQ818y4Bo7IGFd+7nK3TCaQN461npKnBEDv8hixE+0LRiTd7e60ti/2KQmqsfwWWt9n3KMhtB2o7Pn7JvY6AW6Hi62rg65M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P9YWxAj4; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P9YWxAj4"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47fe89fb333so1672889f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 08:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787584776; x=1788189576; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DGVlK1rqoRCdYtqSwH3QAU+C34HZwUZucnX4J/0Qdok=;
        b=P9YWxAj47pKb7n5nUYSitr/KFLP8/UAd0Bm1bEIUY/Mjb7GVlXs8HJVtCnNToDMYyU
         h3llI2QzGhrUKNLJUQ5Szn26kA4CY+vb397OD2hm0wLtnP2as+WO2joiKej9tnWZMmBS
         M12X42RZgv0FMuOwqQodytoi6TCWyHJSpklkCkmQbMGA0AYrS7x8qdWt1v0ngb7tFGhI
         KVKJzrkql/oZ+hyydza/dA5p8qUp9jMBFou3jZC5jkLsMG1O1xb8GpQlTe+X3FeXJiTe
         hiADrWBMKmkQc59SBpplph3jVg4+KZI3Vrg2EcsXSX0/lIRGfQ0eWOtldxkSZ0pEyBKD
         cpBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787584776; x=1788189576;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DGVlK1rqoRCdYtqSwH3QAU+C34HZwUZucnX4J/0Qdok=;
        b=rikL/5BRfFkLfmj7y8RnTMO22/dEjfO/Fpb8wyfENkNGWwpp0HwDPxt8Zsy2FlBsmH
         stSU5WsOalBmJnioI05aKSOpHYA5Ye9F7wXaNxC1X7V9gQvKHEZqWwn+86vfRGid7KBK
         hinRht4GgQud4nyF2SkJBaFT5mdJxPntLYBSbEaVJ525MGiZYC5TbnroSo84VFCv6g9s
         hRO9mlWoLP9BdOW13hV4NThwx6VRM+NIFcYlJ3wuYAV1gmcaMXJ5wYaKMguU44NUiZFW
         6rVNgyPmKQz2u9/zncYPoeRXU+0S7xvUPzN7luz1GIFHvuMXsiUx08u3MIfbp5nHHQa9
         bM7Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro7CX0fYhGssxRa3OJTl8fd1XeKwCWBz63UJ8fM5Oe5bdJwf5bC+86qCmWYWm9hcKkl22+654Y=@lists.linux.dev
X-Gm-Message-State: AFuF++mBaD0G/R3gehTmwzE1/wEuQkFhZp/u7jWMrxmmnynOPxVKKvBW
	+UoUWu/ztBagx6LtbVz/hMHc8gdJKZ+m85532VfaYXRqZUUxEPROaDpOaKeQoiqFMQ==
X-Gm-Gg: AR+sD11XPu4A891IukxmCtH61D03IlZvlULzWllSOZdN6N+X5HBTRo6OOyqDsveuGML
	L1fLaDKKEv2IhnN9NBkjU2xT0lGiKT5QfgCtA2ThvAE4158JVdDK+HxsOS42fyocRULexcngDHR
	POAdKW6rY7JzPI66M+Vt9gsH7Qof1zspSdiv4/PMhpAK9tF92Q7zkJ7Zp/wy2+QH/2XCeo4QxDW
	tEDqfq5kyuV5a/pVOQGkC+MwtMC5KdijbxEN4yeCskr7H8tag0yRUN1u/0EbG3anaacsHpzJVqo
	c9fo68p1+1AEZbRVwK7NiRFPSgsgv0TYwcp5qBvZi1gfq0+dsj8kUxt26NJXUYKd9fqOpjkHFhr
	KIdLub/kACbkDV81Q4zPaomtlE6adIST73wQdoJ4ZfPJYJznAh62c1iVQNVkhXBrAXV3wVKI8TV
	u0sBDpW0sT2mU3oO4tw75KmRzHmDbote8EY388aOrfP/88W1wt0mpvKwoybaJmweX+7ZoCCL6Fp
	/TEQguYG+37ttjN01jkdXhKxEHWUmxK
X-Received: by 2002:a05:600c:4687:b0:493:e451:a9e1 with SMTP id 5b1f17b1804b1-499b82fdac4mr337202065e9.2.1787584775321;
        Mon, 24 Aug 2026 08:19:35 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499c7ccac8csm68380715e9.3.2026.08.24.08.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 08:19:34 -0700 (PDT)
Date: Mon, 24 Aug 2026 16:19:31 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v4 04/17] KVM: arm64: Add a heap allocator for the pKVM
 hyp
Message-ID: <aoxhA91kHwy7P3re@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-5-vdonnefort@google.com>
 <CA+EHjTw9KcKgGDgD=khN8qGPgJAe9POhu1uLby9abDbogwu5sA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw9KcKgGDgD=khN8qGPgJAe9POhu1uLby9abDbogwu5sA@mail.gmail.com>

On Tue, Aug 18, 2026 at 03:22:55PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Fri, 31 Jul 2026 at 15:36, 'Vincent Donnefort' via kernel-team
> <kernel-team@android.com> wrote:
> ...
> > +static int hyp_allocator_destroy_chunk(struct hyp_allocator *allocator,
> > +                                      struct chunk_hdr *prev,
> > +                                      struct chunk_hdr *chunk)
> > +{
> > +       struct chunk_hdr *next;
> > +
> > +       next = prev ? chunk_get_next(chunk) : NULL;
> > +       if (!hyp_allocator_can_destroy_chunk(allocator, prev, next, chunk))
> > +               return -EINVAL;
> > +
> > +       /* Last chunk in the allocator */
> > +       if (!prev) {
> > +               allocator->first_unmapped = chunk_unmapped(chunk);
> > +               allocator->head = allocator->tail = NULL;
> > +               return 0;
> > +       }
> 
> hyp_allocator_destroy_chunk() has only two callers, both in
> hyp_allocator_free(), and both pass a non-NULL prev. So this !prev
> branch cannot be reached, and nor can the matching "if (!prev) return
> true;" in hyp_allocator_can_destroy_chunk() or the false arm of "next
> = prev ? chunk_get_next(chunk) : NULL".
> 
> The empty-allocator reset it looks like it is handling already happens
> in hyp_allocator_reclaim_chunk(), in the addr == allocator->start
> case. Could these be dropped?

Ha yes, correct, that's leftover of the Android version. I can then remove that
allocator argument in hyp_allocator_can_destroy_chunk().

> 
> With that:
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Cheers,
> /fuad
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
