Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913D7233920
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556623; cv=none; b=eIZO/cP+hTWotGLRWvwZ3aRKqYvjJmeD51AmAEcOJC7j0eQAf/9szF2MV7MqZlASzz5VG6Ahw52oawLGtrVtGzxH+EBDPhIgHZgcs4ohavzbz+qepI/3+/Vwbpj1M3DehF7LYgND7QwpmhOZaCzXy4qSctUIWZ49UwNx2C+/mwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556623; c=relaxed/simple;
	bh=rlS6xNcctlKWDYAGqP0+ribUz4WFzD1++VPzWb/Yo6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdR43cZnHfV4rfxf4ylGIcBOkGOG17nNrYK01hZEis1c5WQGGAsDJdtj+1cBaDvsPFSJgM0C22tp+oPpR61Nk6VWvLRBegpldB1lbshypV09z2gOz0M1yIh5hufkMseXTLg84pK3734C7myitr8NjPeh/y5TQ+lLk9tJmMb6Ff4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6ygVP2q; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6ygVP2q"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47f7872abb6so443998f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 07:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784556620; x=1785161420; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lhM9lMbzEMyKsQWUHtCjwG+SokjAeGT8KFW0b3yeE84=;
        b=i6ygVP2qyunQCfscveYX/EWe6Ue35fbNFL63zQyhEMBv268gYqQZk7QqyYLNVq+ykW
         vRWbswWvZWuTYThi6pNkpK1m1/UQoN8fqIaHOy2lbvGGl81AgARzw5XDDNnv3m0UpiQu
         fzojQtL1BZO7FJyCgS+Oakc1vwTNInV6HWOXcsiqXjO4jFhkYjxVLLYW6rFR9g41IoIW
         u0XLgM3B2qQoChOtM+rsMKVhH/g0QXp6ZxIMm2+pJJOQawpzV2q7PiBKYc7jLlpFMkHB
         RQ1uL8r8VGaJ7tXXrPyZ2sDwlkpJ6fOFX3dBWpXts4dOrnf5MqNea8Fccnh9QRYRl81N
         eNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784556620; x=1785161420;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lhM9lMbzEMyKsQWUHtCjwG+SokjAeGT8KFW0b3yeE84=;
        b=M36HnLtVs/jIvNhKIJp9z9fimtl9STAo8YeSMLLI8s+ZTMOzkk8n3+aDd9FR5YZQ1R
         k3u6xWlvCL3ysSwIO3jZmdAIZluEIP9iukDzRnlkYcp4eJzn7qENbYXKuQ9WnFgU+rHZ
         c9RsmgJW8BJcGF/wF+Jb1wnRU+uiNBSntiWl4w1AAzg+nn5u8hmpaTKQefD4rm5tcrTj
         bBTiGLv2+dAb8ZVtMeBW0u9kRkcEx40sYZ03QHbGJ8ABWoM2Ln86dYzz0Mob+iejxeu2
         shL+LyCBa+XZsmDZtIgQpgP+5Z8sYZgsmSDIL//8f3NGVlWJ8i0o388NDmHx2eLG+b5s
         v8Ig==
X-Forwarded-Encrypted: i=1; AHgh+RoR82kLBwbUwuF7MzG7/C4bZuVnBlUihOwxDuAi2jcA87d5lEaZdQPpoVFH+2CXvreHT1oXu4w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5FAdH0Bu2Zf0mcALr/xRWiohTAkogefDCEDOOKANjzfybkGgw
	vFR8wovgPsqV96ou/8OSo2kwTT/P/tjZd6uLOjkBhHzu1x8cw24sQxAv48r3+thnNg==
X-Gm-Gg: AR+sD13lNYtN4+VFzI2dI1oFiUgp3BdZda+GycvYK+pMUCpW2leK0haSpjVD2TJCysn
	ki6ALtzQ5cr1k/ENerEwGtvoiEP+83jjaEZ0gxyDjScLE6rkXPex7O1WKylPev0I4bRMpT37Hdp
	xOxKsz3NT4vWj9ihloaLNCy/Z5Ef0MKZ9NuJeTnY1vy34Jpx1JmnlF6Kfrj3W/4VMZPmVgToPyR
	QZK34oW1FRiiUxqrLiSGYyFv+/ZRK0Qc2qbe4J9TvhnQCfkLTHoYRWxENdpaio7sZxouQQUSqNY
	dCDZQqF/4CU3FdEzWbO+fTK7dATMkNpxZVBZkF2NKgU7ieNU+4sSojV06l5nJVvvY4C6T/V+upO
	jfZYYA5bwhe8R1zhI7T5O25vAmXjKJNnzrcXqgQrf2QUulzKvuSPG8RwJaYcLtBIJn/p1iOStYz
	gn7Nrn5ZSgIhE/PanitWqKDMwYWQSyl5bAqLrn+e5/
X-Received: by 2002:a05:6000:310d:b0:47f:7736:2a0c with SMTP id ffacd0b85a97d-47f77362b3bmr5764086f8f.14.1784556619210;
        Mon, 20 Jul 2026 07:10:19 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e52f81sm31185414f8f.9.2026.07.20.07.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 07:10:18 -0700 (PDT)
Date: Mon, 20 Jul 2026 15:10:14 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qperret@google.com
Subject: Re: [PATCH v2 18/18] KVM: arm64: Alloc simple_buffer_page using pKVM
 hyp allocator
Message-ID: <al4sRjt1S5R77cvT@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-19-vdonnefort@google.com>
 <CA+EHjTxRFSW=9fAYvikL2t48ykaiGp7O3Mg6ddXdtFZrmWWaGQ@mail.gmail.com>
 <al4q05rBGvJzi3Vl@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al4q05rBGvJzi3Vl@google.com>

On Mon, Jul 20, 2026 at 03:04:03PM +0100, Vincent Donnefort wrote:
> On Wed, Jul 15, 2026 at 04:07:05PM +0100, Fuad Tabba wrote:
> > On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > ...
> > 
> > > @@ -193,17 +211,8 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
> > >                 if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
> > >                         return false;
> > >
> > > -               /* Overflow bpages backing memory? */
> > > -               if (nr_bpages < rb_desc->nr_page_va)
> > > -                       return false;
> > > -
> > > -               if (cpu >= hyp_nr_cpus)
> > > -                       return false;
> > > -
> > >                 if (cpu != rb_desc->cpu)
> > >                         return false;
> > 
> > Sashiko flagged this. Nothing here bounds nr_page_va from below, so
> > with nr_page_va == 0 on every CPU the bpage size sums to 0.
> > hyp_alloc() still hands back a chunk, but bpages_backing_size is
> > stored as 0, so when init_mm() fails on nr_page_va < 3 the free path
> > takes its if (!size) return and never frees it. The host can repeat
> > it. Would validating nr_page_va >= 3 here work?
> 
> simple_ring_buffer_init_mm() already validates nr_page_va. And on error, we do
> seem to rollback properly and hyp_free().
> 
> So I don't believe there's anything to do here.

Ahhh no my bad! Sashiko's right. Because the size is 0... this will appear as
"unloaded" ...

Indeed perhaps the best check here is to make sure we have the minium
nr_page_va...

> 
> > 
> > I don't think the rest of Sashiko's note holds: the zero-size path
> > succeeds rather than hitting -ENOMEM. And it's only reachable from the
> > host kernel, not userspace.
> > 
> > Cheers,
> > /fuad
