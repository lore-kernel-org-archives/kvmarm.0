Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45475349B6
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790889666; cv=none; b=qnRvd43oTBReg0J7Fcfu5leOklnpeVji2FZAYqsFtv7e4Yhw+MNPg750OP1vcPwEaVkUyJn2+FHwydYQtWGlQ1Md6DPmU1bYyPh1OOtQDuVrXchPYHCf0ouQKyaCtETter4FFL6gxJzTV0M72TsjwwV9KPqiwpvcVoG5HDVZzmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790889666; c=relaxed/simple;
	bh=SbI9zuwpLoviGTLgjhQIkxJ0mcfP+lQtKKioVT52hTM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jINciH8WHwn8f+h4zlg0+v1ttOkbs4ALhuaFDN+U79ozUWtWn4GxGJ15zVTMyMi+wpJvKJf+dbBU/LE6HwwhEw0VCvbmnrAYmKFSmbnwlBM1tLiwlImZfifgd1ekIhfkYO9RurDEIUyjTxtP2OgSZ4hJTbDSpnePlyy1AOPnpaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IBQfZJdm; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IBQfZJdm"
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-806004ec379so6787649a34.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 14:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790889661; x=1791494461; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dIr4K7N8tWlFElP154T0gDhZmtv6PLeTBLURDyjAzjU=;
        b=IBQfZJdmtupUw9sFfKlvti7qcNLXHHh+nn5XA49As6omiS2ylbKgC3y6Mb4eZ68jHa
         hlhS9/hbttV19cmwsVvg6seaMM5Iq3HkIm4FfWbUTUichtFQWVZTVptqMt/kuDNLhlZf
         y1lC4hE217JN2/8W18Q7RtZycXBE8Hg2Axsw9zlY1QuJo3K3dZI2T7cVo7XgHG559jnw
         jDafoxQ9yEdpf1LaFDwGWiHcUDwbdXkaWS5qsPLTsCgxtl1EfHJ5WO8AT/yEtO5JjqvK
         U7Pw17O96aC6S93Ov96RTS50C4rS+WXEu8WBLT2ccppyTUu2EgCjBLTRj6kKrAbv+6Gz
         u2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790889661; x=1791494461;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dIr4K7N8tWlFElP154T0gDhZmtv6PLeTBLURDyjAzjU=;
        b=Mg9MoZfD4eBPPoI2BOwkgA93DjbcW1t57Jxtl9epMCb/iTtnJWuIWdk571qsP67awZ
         /ZzMViuwW8U802LCHQOzWyJSWD8ZmNx4chaorUCLROEBIlmJHhqZHFW1QbsS3nVfNz47
         dVyaNldxl6UMfT00PwVBfxwdkZda0A8m949hyDhQSK1Z6dT4ctdFuuOKTjaDlNTURJem
         VWEGGWQ9apa+9LlCos0QlZnkea+/nVEiaJ5DINSADdj1w/LcD2fC/qvIIA7nIt6oQfZ5
         VQu/4VUcICaF8R2Tk7qUx6A0LtOtfM9/v0ct9PEcZYYqrzPvhfnWqELLMluV/XXPesnG
         nOJw==
X-Forwarded-Encrypted: i=1; AKwUvBx2T97eX7hj7HNTXoOSsX5fxMS2jm2GdN0YTDEjEWLqo7ghytxfByXOlysZ6F+o45tJ9k3uGlQ=@lists.linux.dev
X-Gm-Message-State: AFuF++m37jcZvZV5eKd8iBHux5a7EBK+qwX7DkhqIMCPdYDC52MdlRfw
	6ByuRdc4MvanotCl6PncZxqsl8jcdwVx316B5kEa924hUmkK72PxXQE1j3SPy3pWRDRYRfA2U4q
	RhBamErXgpD/ymqPLFDP/3XTqGA==
X-Received: from iobir24.prod.google.com ([2002:a05:6602:7158:b0:9c3:8b15:2c82])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6905:b0:4c3:a091:52f9 with SMTP id 5614622812f47-4f526747d3fmr385353b6e.2.1790889660625;
 Thu, 01 Oct 2026 14:21:00 -0700 (PDT)
Date: Thu,  1 Oct 2026 21:21:00 +0000
In-Reply-To: <56d86280-fcea-4d2d-b6b9-b47449f3408d@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-21-coltonlewis@google.com> <56d86280-fcea-4d2d-b6b9-b47449f3408d@linaro.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001212100.2035442-1-coltonlewis@google.com>
Subject: Re: [PATCH v9 20/22] KVM: arm64: Add vCPU device attr to partition
 the PMU
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: Colton Lewis <coltonlewis@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Zide Chen <zide.chen@intel.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi James,

On Wed, Sep 30, 2026 at 04:27:27PM +0100, James Clark wrote:
> > @@ -77,7 +80,9 @@ Parameters: in:imaan address of a u32 value (N)
> >   Returns:
> >   	 =======  ====================================================
> >   	 -EBUSY   PMUv3 already initialized, or a vCPU has already run
> > -	 -EINVAL  No PMUv3 explicitly selected, or value of N out of range
> > +	 -EINVAL  No PMUv3 explicitly selected, or value of N out of
> > +		  range (>= max_counters when partitioning is
> > +		  enabled)
>
> "No PMUv3 explicitly selected, or value of N > max_counters, or N >
> max_counters - 1 when partitioning is enabled".
>
> That might be clearer, otherwise it seems like max_counters being relevant
> to "out of range" only applies to when partitioning is enabled, not that
> it's max_counters all the time but one is -1.

Agreed, that reads much better. I will update it to your phrasing in
v10.

Thanks,
Colton
