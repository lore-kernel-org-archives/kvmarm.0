Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FC123FD04
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733923772; cv=none; b=fT1V+AulhIRLGC/y5jTfCBcHyqoa5KvCk1ub3OW8uEGUdOJYDqTvVw01SqTtRhSrrFi9tekHKPE1B/qgm60jgXFU05ZIjPdoqRFYCM+W1YWggCjavv5NQT0+DWcsjzUwSOYv7kgvcyexFn2BxNiSLiGggk/qHRDL24KVdO2HvDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733923772; c=relaxed/simple;
	bh=ezI7OjCcE02zRhevjwMQHQMxZFoMhHMxL6oO1nhKR4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUCdi4ZuyYO3yXQhU3rCeF+33KBuzBhO43iLja/yd/hwMxv5IVGfduYiN0mk0KosqMUVEsaZTx+ShN6xAL9hUyWLWAZ3Y6hTg55fdC1wQcEbO6QZBKYDYWDvfBzWeUM6Io7zEer3EoFNhWNRq/iGsJikski2WeKPAgxd9IwpdO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MFGUdbff; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MFGUdbff"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa543c4db92so569436266b.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 05:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733923769; x=1734528569; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ8WmE2oVMcuY+D5rgASzXIuAkJx2FsjYv4FOWBBAgs=;
        b=MFGUdbff3UvwkvKU6IBkMn34jIi+JNojevFby4cfFdj4qNInpG4omvI//xXMFPCNsf
         raM7ZgpMHJy7h8GO/bAjYab4Wtf31KgG94cozAhcfpsUh/lC2Sedn3fRT7tsduysEEVQ
         rW1RGvWDl1L1/WJYxmazZ6/r+HODrDUD7WB5aQ3Qkl7yF0VK6nJTU9oXvvSUYNhAqaZF
         Vr3X/Bp3+GCnCF3Ntqb4sOVDR8EMvhzJ9e+NXMxvD2TMhiNa2aOqymxFTJlA197lBMar
         dT0h6MsM1C9SRv530IqdXqS3BMU2F3NSAbGaa0kvHtGmGrY0OnEiHMdr5rUd5KJHQ1Kw
         ECPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733923769; x=1734528569;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZ8WmE2oVMcuY+D5rgASzXIuAkJx2FsjYv4FOWBBAgs=;
        b=RGctfMV+y6A1zkwRsBmCo63qX56Pzv/i8OMNSEjsgpLdnv+PZUXTlYf84NZz4XH8dp
         ZK9q+k1CyXg+iOEJl6rxUBJ1zSYzZM/ohOT2Iq0yQ9WJ0r4vGLAbZ6YjnmhAeXZ8F592
         Wn8/cXBLwZ9OhVru0Ij9efTt4lp9KW4Fi8zKuJa/JSFBicSiUcVtzU6qw/H3IyAoMRod
         tnly59qyXOlH1SdqXx1M5gLkNOx8SiJPRktPS4N4h9xUj56SxNGoQw1kmrHzJddSE0rv
         CBn8WpvHQWVBHdfPC6k+5OPChS4I6iMm5Asrm/lgB00I1/Gq5Aoz3MVwdoASaU0gZHAP
         /a/g==
X-Gm-Message-State: AOJu0YzMDxFEt30e7ugiYRwP6D8xViSFk0BtfjBefBHHi78Jgi0FmvM0
	vSlBOf1dcRCYcGh9kj5dPvtC4cnKiYk44IH9t2r+isSR2ZQ4yYIAG0L+6ODQeg==
X-Gm-Gg: ASbGnct+Gc3WIW+YdtCYrP7t0Qm+DgggDr9fdilPEE09+xQyilTuWxI3UbZGtEU6v2E
	+KwZqLCTQsDg0vhlGG42Ktde3QouHEe4Ldbd/wCQnakcLhRCAbZ9FpKUOAFIWb3KrArL5TKrJm0
	HizOwPoGs4DmJCzzIfX0vAAJkkJN7HlJ6WIuoZhH9S5YSgRw6g/zAq7g+Z3FuvmhPhB4+tupybY
	veavZ59cY0UWfcXztBexNv2Rp9YJjL/IPu98t40AAMpnZh2I9hBY5VK/nwFlNQOnzsOxw0XDPT4
	H/UAf6ZymWN0
X-Google-Smtp-Source: AGHT+IHHtuhS5qRK2Vs4YR08EkU42S9jU4/gGJNdMqiKWPhEwaUH1bEnXVsl3kwAZG7CQUix98OaLQ==
X-Received: by 2002:a17:907:7703:b0:aa6:74a9:ce6e with SMTP id a640c23a62f3a-aa6b1179ab6mr244042966b.16.1733923769090;
        Wed, 11 Dec 2024 05:29:29 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa685669acesm483241866b.189.2024.12.11.05.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 05:29:28 -0800 (PST)
Date: Wed, 11 Dec 2024 13:29:25 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 04/14] KVM: arm64: Use KVM extension checks for
 allowed protected VM capabilities
Message-ID: <Z1mTtS9nGvVM-BIq@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-5-tabba@google.com>
 <Z1MwAomiLhnMn--k@google.com>
 <CA+EHjTy6Y6w9RyU2Vn8O+DDviSJf=P-Y4c+xVFqY-3GmHBv3kQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTy6Y6w9RyU2Vn8O+DDviSJf=P-Y4c+xVFqY-3GmHBv3kQ@mail.gmail.com>

On Monday 09 Dec 2024 at 08:14:15 (+0000), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Fri, 6 Dec 2024 at 17:10, Quentin Perret <qperret@google.com> wrote:
> >
> > On Monday 02 Dec 2024 at 15:47:31 (+0000), Fuad Tabba wrote:
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > index fb733b36c6c1..59ff6aac514c 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > @@ -329,34 +329,20 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
> > >
> > >       bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
> > >
> > > -     /*
> > > -      * For protected VMs, always allow:
> > > -      * - CPU starting in poweroff state
> > > -      * - PSCI v0.2
> > > -      */
> > > -     set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
> >
> > For my understanding, why do we drop this bit?
> 
> Since the hypervisor is responsible for the power state of protected
> VMs. This should either be a separate patch or I should explain it in
> the commit message. Any preference?

Gotcha, perhaps make that its own patch so we have a commit message
motivating the change?
