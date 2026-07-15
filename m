Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F08540EB80
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784120348; cv=none; b=ZYbq9RybbDHUTRn6hZmI8qdckeVzfLEPj+caApqdQsSm4pKvcRdq17C35erlXSNAMh1nKgLdXYd03lqj8GhNsQ19tN3WtpRDPk1NBJ5LyWp0uztSbRxQpdQ72yf8sOVabnu17BXIaCPT8nmnphdODqgqzaqGx0u77S3lTx5nsoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784120348; c=relaxed/simple;
	bh=Ff7Zi+Si7vbJ3GfLeJ+McsYQ1Krkf/d8aFtq4SO/8bo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gVq8sHML7eGFPBnwZf2z0uPXci8CdG8BNLQbGsu1pNPwwCT4GICIreO2++CAcZ0UdLDdde1R7AY9Fbkawetmr2Rlz+5YyW/sFNWFFj3buNVC427VdI0BYQ8k377zA1yDEy4tBsb2CAI58Bwy7XJtw1ecqKReS8xGvEPQCxLM3GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lraktbKE; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lraktbKE"
X-Forwarded-Encrypted: i=1; AHgh+RpcPAK3xI932klZrBTEyNPj0GMqz7P8kqnTrm/FhJ/RpvyTsCbfuKRlFZ8T42MmxGQREPVrdY4=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784120343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6GoCz/ULvd+/SKvUCY2cC1AScuvrYcaccndOJDl5pug=;
	b=lraktbKE/8dgHMAESqCsLP0dB5jV38H0SpADtCFKBDxq5fWX39v2dfYMM/hH74tvONrcpF
	OjgGVpjAzz8XC1aipgjJHP9OPRzaLXxjgO5f3OrXVcS25/Q4bjo+W2BLqT5T60asK4pdLA
	FtVbeul7CIT0mt/M1URw0vA/iZyg1DU=
X-Gm-Message-State: AOJu0YyoGBsQe3idIOX5lLBo/nhQP/gpkvF2FIj7XTteUeVfDXTvcWaj
	NclHBzqLKhba3bb6qAyN+pPayJEYAyouhd2gpFy27N3OetuiFCvOgy0bOPC70vR9+N7elI5mjjx
	+tHBz+5Du41sTgqj1JhHUtX2/nV5HjHDdnhnZCkHe
X-Received: by 2002:ac8:7c48:0:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-51d7bd1f623mr26939691cf.13.1784120341010; Wed, 15 Jul 2026
 05:59:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-16-vdonnefort@google.com> <CA+EHjTzNMCMAt=VDnCuR2+Pfz9Qh5HmbEm6tdjpdcPBO+UchEg@mail.gmail.com>
 <aleDOyiP5E8TcoZg@google.com>
In-Reply-To: <aleDOyiP5E8TcoZg@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 13:58:23 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzsFueadxqyaBUD5sywTxozv4PrdkpCC+NbmhWT=AeUnQ@mail.gmail.com>
X-Gm-Features: AUfX_my9Tyv6FaAb2GNxMgl-a8hnzWqh8JyUkaxnbUnjZ2zpERJwcmQFskiDRUY
Message-ID: <CA+EHjTzsFueadxqyaBUD5sywTxozv4PrdkpCC+NbmhWT=AeUnQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/18] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

> > Sashiko might be right on the memcg point: hyp_vm used to be
> > GFP_KERNEL_ACCOUNT and now comes from the heap unaccounted, while pgd
> > next to it is still accounted, so it's inconsistent.
>
> Yep that is correct but there is no way around that:
>
>  * Donated memory can now be shared be shared by several VM (or other parts of
>    the hypervisor)
>
>  * Donated memory is also not reclaimed until the shrinker fires.
>
> So we don't really have a way to account for that meta-data anymore.
>
> (I should at least mention this in the commit message)

Sgtm.
/fuad

>
> >
> > If we do want to fix it, would it go in pkvm_hyp_topup() to cover all
> > consumers rather than here?
> >
> > Cheers,
> > /fuad
