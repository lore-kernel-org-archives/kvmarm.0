Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5999A372B57
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 10:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789467864; cv=none; b=Tq2OjLLkrXtujjaxFXGLKamyt8N9hKJxjIs7xWYTr9rHINSusyxL4VAm7M/f98K51g7+m0IX0gJB+UefaTIYZijiqcwI+zO4MDy8UL+1GkrZDnU+tW/Ary0rKie0tR4/+IjmZEzPHLqjEo9ceaYd1Gjtr1Ln0X/8SBVWr9cQl2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789467864; c=relaxed/simple;
	bh=eEpTu0phK8BsqOnC0fc6MeL/3Km/1p8O2zPIqVueRhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DfNrjvoT3FU91qHFIkHWgYd/0rjlYm6sm8NkriRSGo8hUK9aEmweD/qscj1GHukCoDPUIG7PwPVR2kJuygQQQvTQQSAQ7EWcbG0urW9VuBvVFm8vBvaBF5Nr+vQc+Fv6CB4diU0J/uEWrlP1I2VZ0zA0fnRvjR5XHq5jK+yfiis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ooHg1/hv; arc=none smtp.client-ip=91.218.175.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ooHg1/hv"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=eEpTu0phK8BsqOnC0fc6MeL/3Km/1p8O2zPIqVueRhk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789467860; v=1; x=1790072660;
 b=ooHg1/hvp+EDH5PFduN7/OPf1Af7TMW7ctTeKKXoHbfCcOl+WFzpLUsssk9s5fXOG1tGhCUs
 MhLxFsV3CbUDeEsOKzZwLfha2HP6Txez8DAFjQKAxkww36e4gTkL3r4UtmlZ+SYzbHSyoHLkrPT
 u2DNTiWKAT87BfrzJJJpwX4U=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d06a58f98de88f4a;
	Tue, 15 Sep 2026 10:24:20 +0000
X-Mizu-Trace-ID: d06a58f98de88f4a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so4415e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 03:24:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwPhlQLIOKXtxqNleW3vzoijQ8yzTa6hUxooDD5QtleGsRQvhb/aqsN8NULBq+DYcXulzXFp7Q=@lists.linux.dev
X-Gm-Message-State: AFuF++mstxLV56jlZTl94AYvJ4RCYTl8WgICaiIH5plmMLCvBlEuxzFV
	y81BCFJ36yU3YXHTavC/1HZces1IVL6iPJaAYcDd5Mmxiej5QVDtaCvnzXEPoKwyxWzpe/BU3JB
	45uvnqtthRyCVWdXW0PE6Mmu/8ZtR77cnJDYEaG2V
X-Received: by 2002:a05:6512:3c91:b0:5b8:9e63:dfb4 with SMTP id
 2adb3069b0e04-5b8b2d4f6a7mr177569e87.14.1789467855333; Tue, 15 Sep 2026
 03:24:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
 <20260915070418.3209779-2-fuad.tabba@linux.dev> <aqkbS810aDLyfS7D@e143914.arm.com>
In-Reply-To: <aqkbS810aDLyfS7D@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 11:23:39 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyc_OL6H8iyjO+hjU9gqxCaJQUv4CUSQ-R6ZRJvG=siDg@mail.gmail.com>
X-Gm-Features: AcwNN1URDJWh2M5sOKluQk7udRVOG1eRZZAroybUEQB5EN27YFtm1788x3yXVpc
Message-ID: <CA+EHjTyc_OL6H8iyjO+hjU9gqxCaJQUv4CUSQ-R6ZRJvG=siDg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Validate the host vCPU's VM before
 reading it under pKVM
To: Joey Gouly <joey.gouly@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	steven.price@arm.com, vdonnefort@google.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Joey,

On Tue, 15 Sept 2026 at 11:17, Joey Gouly <joey.gouly@arm.com> wrote:
[...]
> > -     if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
> > +     kvm = vcpu_get_kvm(vcpu);
> > +     if (kvm && kvm_has_mte(kvm))
>
> It's fine to use the "host->kvm" here because even if sets this bit on
> the host vCPU, the per-entry handlers in the other series won't copy
> across the TCO bit.
> Right?

Yes.

> >               new |= PSR_TCO_BIT;
> > +     vcpu_put_kvm(vcpu, kvm);
> >
> >       new |= (old & PSR_DIT_BIT);
> >
>
> [snip]
>
> Agree with the nits that Vincent suggested!
>
> Let's see if this sticks this time:
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Carrying it over for the respin, thanks again!
/fuad

> Thanks,
> Joey
