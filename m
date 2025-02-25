Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FEC18C00B
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 19:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512990; cv=none; b=kJbNIkDk2Mz7DwuG3josLkUgP4nLf2UknEjEtK8YRqHMyaPRL2JtQeGSt4dx9lLLGCbINmbgJIotnrc0WzgKtDnanAjYtZdQJIvefRvTKrdB4jwZwMj6quVxQwwPrBV88Wa5IhtJMfV76DPLI8GCxFWS4EpHHQ+1aXGF0h+7IBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512990; c=relaxed/simple;
	bh=Tj5s8TjtZq4v/wFdAqOuakzk8t7y1AdtBQyAr6aL/qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3hhdB9E1cdTBq+8HqPRKXfZhq4U6v+sSrGm9023/xmgFAnGzMIfM+ZXEReVcNE3HnzO7LE6IlTpxRxlmk444mNlhK4lKs9uTCbMSGozTsjM+vJDBlIyGOtdVL6HpY6qhmAD6xaAMD0w6L616f3EuQQvxOw1SsEI6FFLOLHR7ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tURbpoWe; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tURbpoWe"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso945023966b.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 11:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740512987; x=1741117787; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wZ6WGIl+AUHgbUP8huP5qzCstVAL4wh1yB31nQNV5A4=;
        b=tURbpoWeDmYqDUIvz1k2EP85/JFviYS5R7+Q1zo2pmtM/8GwL9vuQMloTsjJLCQQpA
         mR5ctDRTSgNM6WLroce/tmr8Qe+piL0Ln7VVqJvYrfNWkmg4Bh0Bd+rjHJKN2qhbrEoN
         jHFkdvsOrEaYeDmqE4Fq8SkUzUo887ZxovM489PXYX0namABy9VyTHfuEwi56p8uJK4H
         4rbTn/Wo9dVH7r7sYueOUP+siF24Q3P9iiW8YcygJOLH698DmP8bcdKPuop4aFi7DhQn
         x6v3majg2KrH36NvTNdOfvPsPRIc3ZMnb6DBp1IEC6WgJFRMVauDym6gmmD7ER/tlGdq
         ZUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740512987; x=1741117787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZ6WGIl+AUHgbUP8huP5qzCstVAL4wh1yB31nQNV5A4=;
        b=v3qgP3mOVqmNAtPU3pqk1gIG1Lyc5IfH19kMrixmzdbo7UkMhzYyEk3ksPGWikhFn4
         8N56JNpVSZlNAymz5eoRDn6O4dIjztJ85osUwhVM/eUADGV564vYm5Phc7itdLp909Yx
         lbilu7NrBrO/MDTlH8isKJ1/1XLTbJ9pLs+iKC22j7xc3CUm+yG5coi0PCqXKY3sYq1S
         TXUu1cOK4mRSaJLXle6rq6XwJc5oTMoCi9cbLfCpusJ6ylki2kwGSE2wAsR2epzdUzqn
         mXDRHBSokkqUZIj+JeVqW10DvIVauzdw0AFzXlGSZEQVx0fN9qAT6XYvwtEX/09iU/Ao
         zE+w==
X-Forwarded-Encrypted: i=1; AJvYcCXMYJiBtu/OZoabWjHo3zRT+V0ncafvisUWhb0dHpxaXq4epgtoho5zja51e/zrar0669w02NM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAsV/HKdiXuD/+0jgt/95enoxRxxd1dAs2JpCToOhSHzEUfYk/
	CQDEQjwoz4FLGzV9asB4oOBGSO7rE+QFIbn01OJXaoZ9NznBSR4+4Pm7Fa2AAZ3wuWNVRB+aB4H
	46/uU
X-Gm-Gg: ASbGncspD7+buR9Cl4qj8Gd0PWPqniICW93fUsRdXxYi8+71MxCJgR5vk82FZ0DRPcE
	gYIc8LMxZ3lc71GjHg+ciPi+oiDlgzEHztBMdqrECCLQXqXNSA0EubVxSZV3sDF2mB9EsOVwU/v
	Ipvamx2GCcTDle7QJFsAEVeNpz8NiJrH1QfWUKL2z2wdaz3fw2rFjlWBNh76eKlkqQkph9VyT0T
	KfsJ9YnkfkfbQPUV9NTsoG9gy3tJjNKIna3OD3NJvp8p8kyBZsVxgVyvDVofAQdVWA5VQXmAnPW
	9c4sQK/dj6OPCxJ5ZW0w34TSPFR7ViVGx3mal665rhEmuiQ/iBqHLf3qJa8IPik=
X-Google-Smtp-Source: AGHT+IE77LDENhumCNSGLklTSxZoktkRQ6fz4LwYMz58A+ZoJ1Oh18Qlz1D99LVTBsuhgIMY2PKmoA==
X-Received: by 2002:a17:906:6a22:b0:ab7:eda3:3612 with SMTP id a640c23a62f3a-abc0de4e63fmr2092625666b.50.1740512987199;
        Tue, 25 Feb 2025 11:49:47 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed205c7efsm193351766b.149.2025.02.25.11.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 11:49:46 -0800 (PST)
Date: Tue, 25 Feb 2025 19:49:43 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: arm64: Don't WARN from
 __pkvm_host_share_guest()
Message-ID: <Z74e17vBiJAgViHQ@google.com>
References: <20250225015327.3708420-1-qperret@google.com>
 <20250225015327.3708420-3-qperret@google.com>
 <87jz9d299h.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz9d299h.wl-maz@kernel.org>

On Tuesday 25 Feb 2025 at 18:02:02 (+0000), Marc Zyngier wrote:
> On Tue, 25 Feb 2025 01:53:25 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > We currently WARN() if the host attempts to share a page that is not in
> > an acceptable state with a guest. This isn't strictly necessary and
> > makes testing much harder, so drop the WARN and fix the error code.
> 
> Are you really fixing the error code? You still seem to return a
> -EPERM. I guess this was never reachable thanks to WARN() being a
> panic with pKVM?

Exactly, this is really poor wording in the commit message. 'Fix the
error code' in this case was intended to mean 'make sure to return the
error code properly instead outright crashing the device'.

Happy to send out a v3 with a better commit message.

Thanks!
Quentin
