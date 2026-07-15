Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85F247886D
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128071; cv=none; b=L+GPKyEHdfksMTgXyOaflJWbXaYsRrm9tXiBuMUVezN/l5rNTFQc6YZL3Mtqf+ccTwiVi08aL9wYmOmPNpUNRhnwvDNueUJ/NQMyA5qeKsppHpVFr8wGBMClG3DP4ra1bENZ563FsLz5/mKQmAEW8TrHZIlUSmsmyVg9WcOuYy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128071; c=relaxed/simple;
	bh=prc3uAEHwoGnYr1c7/aZdqLr0VyU/73L7MWgzk/JWK0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=swV7zvm+W4mkSuuZJU+QBdEJl0s3YoqlnPtyex6LglBMblizwOJkYa2dB+9w74H9rdXxas0/41+SY6PhNWtLeqvbE0LV43O1ewmcUDj1p30ftNVhOI09qA5RdXNj2Ce9gE5wTWr36bFJJmaO2astcBKNd+ahMI7zrpA+fb6SEHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y9GcF9vf; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y9GcF9vf"
X-Forwarded-Encrypted: i=1; AHgh+RpNxA8SSGwtqEDIzz3sZRedV9tpBPb5IrvjQ0MIPTqt/W4PzIOZVtSKXtSYd1BABA5S4r3sPJE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784128065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1UksYG3BGMSWQLFo2u7eoMh9Nmo4SqJ9rgJuiisEQVo=;
	b=Y9GcF9vfCLA4rRR/467dm8y+3laVSHgvk/9IFi+zKNLarob50xdflURvNA6Zcv9oucAlZv
	+FIElWX4z6jivh1ILm0oSGqmarkuBENG+enxL5fjVbufs4ZTQx2WmKV6nzO0Z+b7y9HPti
	C/l2TaOtNb7sHJoficOXOjSAaVfZ5J8=
X-Gm-Message-State: AOJu0YxOT7UyNR9DBNFXepABgLxoGeI6yleoh4hLCf8bq7kMOcQ/jbCK
	E9cJfk2soY8cs4oCNtxUpT1r8oFDZPtG07SyF2eE/kMkBBE4rtB2S2mVYDaMYf+B1UdHhGd2SzR
	kGFT0idhyyJBDW+bt/6BNkOAVslfZIwEW1MFt+w+U
X-Received: by 2002:a05:622a:1314:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-51d7bdcb522mr26277441cf.13.1784128062853; Wed, 15 Jul 2026
 08:07:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-19-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-19-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 16:07:05 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxRFSW=9fAYvikL2t48ykaiGp7O3Mg6ddXdtFZrmWWaGQ@mail.gmail.com>
X-Gm-Features: AUfX_mwQkLtR_K54e2-Z1gB3kd7lVeTizQhfcU3nhShnO-K3WpnpK5Ukazz8LTw
Message-ID: <CA+EHjTxRFSW=9fAYvikL2t48ykaiGp7O3Mg6ddXdtFZrmWWaGQ@mail.gmail.com>
Subject: Re: [PATCH v2 18/18] KVM: arm64: Alloc simple_buffer_page using pKVM
 hyp allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:

...

> @@ -193,17 +211,8 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
>                 if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
>                         return false;
>
> -               /* Overflow bpages backing memory? */
> -               if (nr_bpages < rb_desc->nr_page_va)
> -                       return false;
> -
> -               if (cpu >= hyp_nr_cpus)
> -                       return false;
> -
>                 if (cpu != rb_desc->cpu)
>                         return false;

Sashiko flagged this. Nothing here bounds nr_page_va from below, so
with nr_page_va == 0 on every CPU the bpage size sums to 0.
hyp_alloc() still hands back a chunk, but bpages_backing_size is
stored as 0, so when init_mm() fails on nr_page_va < 3 the free path
takes its if (!size) return and never frees it. The host can repeat
it. Would validating nr_page_va >= 3 here work?

I don't think the rest of Sashiko's note holds: the zero-size path
succeeds rather than hitting -ENOMEM. And it's only reachable from the
host kernel, not userspace.

Cheers,
/fuad
