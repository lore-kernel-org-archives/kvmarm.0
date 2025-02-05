Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85971D7985
	for <kvmarm@lists.linux.dev>; Wed,  5 Feb 2025 09:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738749482; cv=none; b=HGwR5lIYF7SBBdPYY6ttSD+ElE6jF4SdarzbNrQxYJoYuZ06upDl4egW/4Jv2M/1PIMTOqdedFP/NiY164gmkqecqqnYK8pTxhZbNfxPnSKWCqk715/hGz7HirEXs80WnajeKS+nZ8FR8YPKSEF4sCmPj/3CmL/roTpkFvXIbxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738749482; c=relaxed/simple;
	bh=Nq/kqlSP3svTs4A+e6SOH1ClmbqaPxsVt5+MQGotkk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mL62DebwL+3tVbVhnWFdSeQ5unSkPPzjfHzbiJ/TosjHmelfrKsRyWdah+6IXZkbnf9andNr8XTGLGRp6RLkNnRyl2nEWt1GZbvr1lawIWnTFnACIfdfTStUlxbl9eyagLtdbcnrE0qLLFscIS31GrEFHYFpUV0iIefOAuTY2K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZAnmk4Y6; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZAnmk4Y6"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5dce27a72e8so313238a12.2
        for <kvmarm@lists.linux.dev>; Wed, 05 Feb 2025 01:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738749479; x=1739354279; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WbnvWfX7jxBUPOrY8qkhn5UbcYi3tt6+vaZLeX9aDhI=;
        b=ZAnmk4Y6bC7c1NnEVmRdioChhVcJWT9N/ZCCvhoxKiya6WnQIRDUtrMLxihw6l7DVV
         lo3No7SOca5a3DIMtBSpS2n42o/H/oPdR/V2fxtjxBR9ES92bE1oEjVK02HuJQQx3pcn
         V06s3go8lh7FXOOL41jmwrhsxk44Sek3bj76SfReF/HHEX/0rir2JUrzTEOf0G3UmmTm
         jm6MQmu4EcYbLr55OkqSR27nrhpzxM6TEFw9EIIUdI00yN0ZyZm3dHixvw0TC4/mmCEM
         FQvRwayjnxcYtsH4f/dvc/BSiTUC/hrP/s8tv/SO4Afrr2+x0AXQDxu7jA9ffHR0WB3g
         olGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738749479; x=1739354279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbnvWfX7jxBUPOrY8qkhn5UbcYi3tt6+vaZLeX9aDhI=;
        b=vjXhJMCLIPjZMZgHMD8X/GfkdAqgNWm5b1CX2W8Y/W5mQdHVMxjNV5PCwdLT2p160l
         lB5hsOF9lwZipVShLj5PeS28vW/cqxpypAjR9TUAUVtw3g8S13Ld15gtTQfE1ykLmviI
         hDDG0Dg0MxxGNE3Q8ASH6nJ4B7+dgMabwMKA1fuLAijAfK6UNb+GGtGRPsgUlBIq3KxQ
         GwLtCTTQwU6SWipTK+FNrLQHh/+F6CXaaoeK4jJkcT0+o0eeReFXPjzvD3FC/Lg7oZBj
         gydwx5A8ezZ7wrgbIH5zwhLh/NPhoRNEt6mcELOJSqsZPgLp5SgCs6wNLXl8bRCpI9DJ
         sfkw==
X-Forwarded-Encrypted: i=1; AJvYcCUrEEFpWXlUhCcfKkD/+ArS2Ls1VjnXUnPSHYJX4eo0emwOoX9JxiaEwGG/TElTd7MkHKS8R5s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx83vGccYBWpPWFVpMk5tLPninlTCVADvhxKVD3S2Av0VnVqzEE
	6K6an0OxCmi4ucQyAZu4TLZWU1PLYpyO7WLQOQIUYxH/tXMqHWvUPA6MJrIBww==
X-Gm-Gg: ASbGncs5UjU3LZLTtAQ9MLQPgkeJrfZhN/1qgMkNtJxBN6L5tosDGbHjpuTYIwxYsUq
	a0kC91RbD6AKb4QtMcOGagMlgncoqhVZ+1koXT6KhQ8wQN62jRQf4eT14OjzzvHQ0fLckzDvHHv
	wLGILuFJBdqdwTT6EPC7yKjfoPw0ZSXHRt5kQ77WO8FFpqb2Mx5Jw+AfwDLtXqxz/Ap50sHLczI
	to/16GX5MmTPC7WTzhIGYRmOKosDoVTbm8DzSWMIPVi+Hwi2oJ67GNo5MLalbYR8Cwo46O6dMTK
	eTVJ+gcwQSN7ABbvToMpteiqh9sFEiRJFUTq6HVNDmjgT0V/Xqc1
X-Google-Smtp-Source: AGHT+IHlSCxcM4Gf9CJt6IMxYC+rLq5h9k2XD0ViVMFq5Bpo0iQeCY5EvWVi/Z+I81xJb2BJo1RUeA==
X-Received: by 2002:a17:907:7b82:b0:ab6:f89d:5a7 with SMTP id a640c23a62f3a-ab75e26358fmr257421066b.34.1738749479093;
        Wed, 05 Feb 2025 01:57:59 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47d0dfasm1077074666b.71.2025.02.05.01.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 01:57:58 -0800 (PST)
Date: Wed, 5 Feb 2025 09:57:54 +0000
From: Quentin Perret <qperret@google.com>
To: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, uJap072421@linux.dev,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/18] KVM: arm64: Introduce __pkvm_vcpu_{load,put}()
Message-ID: <Z6M2Ir6uAT8KcWma@google.com>
References: <20241218194059.3670226-1-qperret@google.com>
 <20241218194059.3670226-10-qperret@google.com>
 <5ca7588c-7bf2-4352-8661-e4a56a9cd9aa@sirena.org.uk>
 <Z6FO04PZtY8fsJhq@linux.dev>
 <5b73e1ac-a48d-4064-a095-26cd9662f0c1@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b73e1ac-a48d-4064-a095-26cd9662f0c1@sirena.org.uk>

On Tuesday 04 Feb 2025 at 14:32:19 (+0000), Mark Brown wrote:
> On Mon, Feb 03, 2025 at 03:19:03PM -0800, Oliver Upton wrote:
> > On Mon, Feb 03, 2025 at 07:50:44PM +0000, Mark Brown wrote:
> 
> > > Current mainline crashes when running the arch_timer_edge_cases selftest
> > > in pKVM mode on a LibreTech Le Potato board, with a bisection pointing
> > > at this change.  The system dies like this:
> > > 
> > > # selftests: kvm: arch_timer_edge_cases
> > > [  130.599140] kvm [4518]: nVHE hyp panic at: [<ffff800081102b58>] __kvm_nvhe___vgic_v3_restore_vmcr_aprs+0x8/0x84!
> 
> > Thanks, fix posted here [*], although as a consequence this machine will
> > stop running KVM in protected mode (which was never meant to work in the
> > first place).
> 
> Yeah, I wasn't clear if this was something that was intended to work or
> not - it's all in a constant state of flux.

FWIW a770ee80e662 ("KVM: arm64: pkvm: Disable GICv2 support") did try to
explicitly disable things, but was clearly incomplete...

Thanks guys for the report and the quick fix!
Quentin
