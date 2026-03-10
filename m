Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC8A2D7DD9
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 09:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134863; cv=none; b=XyeND3roErd58QP+fDkyurKurux/l9eY2ONTgHRiEen/90SfoISlodYwXV6ZBVBuJpGxjHb59Us1yHptCNjNIID4/8LulzJA9huKXQ4AvcKXQWJv24mgVtC2+cqM+STin2pTGEhlAD1j3VgXmQOTR4lC30SInBU9hQGMZetFSvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134863; c=relaxed/simple;
	bh=D7ObvPSYJaCOfp/8eCZNwv9y3mCkOjCMhOnGCGubwyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTiYX7NRMyQuQ06lGnobxFuIPVPAzUDP4gx4t2SlzQU9kGpWY5DVXAmjPDUkYQ++n8/2k8nIWx2fFCIn69Fif58H2CRRwV9ih/8fz3d01GS04fAg4gtlrQWSgImJl19rJP2kroFfcLmcW2wA8ovkvEseWxFRnwAjhNXcFo9M55g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z9I04yrl; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z9I04yrl"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4853f2826f7so16723375e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 02:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773134861; x=1773739661; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n6mbdjmVIwUUAco7q5KTIV1hgiOZLKIqNBms+EgWnbs=;
        b=Z9I04yrlP3gOetG57oeEAXkULxqMzeCy8Sz4T5d/sfZvCNJgd5/PaT5es08gr86XSt
         aiqu/ubpIKoMKLzSgQe0sBkoetFRMude4IfqIZOFQhn83sj1Kh0F5cS7zKs7ltOtCsCN
         E9re677Kj5vDFLJeBrpMngsOd94oGV+mqJO2CdB18KepRMwNWVqm/1sQlFCyvDzY3A7O
         LeK5L80o4IoMUS8sN30VwvRTg4+Oto7ltZAxfNpI4O+/WPHqB4zyQwEIj8Wag1BODhYR
         oEJ4allgK6o3+oZILSy/DkETPYQJg0wmFAn7Ixth7H4fCS8c3S562jl2Z61QC3RnRGUM
         zp6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773134861; x=1773739661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n6mbdjmVIwUUAco7q5KTIV1hgiOZLKIqNBms+EgWnbs=;
        b=EYCKYQm/hbiUywnAzmgmhu5NoyVemDR5b18rUkpz91g9q0YDjy6f74pI5dI5viq90m
         WfdEk5aFhpnuXCceiGH8PK7tfUpeGg8PFpZGVy3xc/3ufo3R/z2fMsF+aXTmznSj5WQF
         FXrFbU4aevsFLtu+rVGAcgGQ7frwm6HqAMt3Yz9Zj4FahYv4hNkj6wjKAUG7xwei6vbc
         CoZ1qF9bDVmRCMPp9zREfVZ0vXWRnNWar3L8xgo61sCabNdCMFvU4WqHRfQX1QMczbgD
         6G6WCNSdw2lNoFxT1v55P2xszs/C3fWUkfcBjNTcXjlG/Cy3OPoAu4YxIL1SlYNxks9E
         7xAw==
X-Forwarded-Encrypted: i=1; AJvYcCVIsA7+ZjbPeUWqLYwZIGQhbOnnI/XL8W/sSazeAlRg2wO35898yL6UrUwnYK97cVZ5mdh3Nuk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLHhFXB5VE+8eqe3zL25MlSojh5lys5xcqm09ATbG2Sp+YG//m
	i9maL65uk20usAJFJ/iie+LzAWPSpCGmqel34qCeoShy8vK0nJXVq2gMUv0QzcqdmQ==
X-Gm-Gg: ATEYQzxIZcFHdUAh8MJYTtanPA4GV4B1zxfWwsbfXRjgY1aX1Be7LGG1b/N5g3ZDVm0
	d25sVK6hFzwHI05OwOz9DMLQfTnxE74pEcQ2/D80JJOIISEmelZ/jNvB3jkQb6pq1tQspQs09FV
	wjjUv8wNQZSJA/Nx2WXCDJtyb7o9E2gXq62USpXZrFrzEhh5HSnZQpfjRuSqxdQHXqULIIacobx
	7D07nnmPttPVqqyskY7eafGcK+U5P4HNiu8Jl91AbsWk5pMLica2DCFZ2UptwSIfq+U/EDjSmcr
	njaayaNw1y3SObuow+mWTT8/nQ0f1eJZWcxlnLsUvArkFf5noFX6Mr2cr3vG2V5xttjuEG3h16J
	cN9ciSNIj3E97e0HsCZYE6a4jtrX3/jptlXNO1wsG16LvUkaoRTtRUOJTbuVDV0bgUCpiPH/OKz
	5IIUsHLX6WIb99zm4wnmcbwGX1B+3DzzzqOtco1q48LWfrWUO3Fiofsjza77V7foIA1pe5W09wg
	4IhIQ==
X-Received: by 2002:a05:600c:500d:b0:47e:e48b:506d with SMTP id 5b1f17b1804b1-4852695b9f7mr235710785e9.16.1773134860464;
        Tue, 10 Mar 2026 02:27:40 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4853f8f9938sm31136055e9.23.2026.03.10.02.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 02:27:39 -0700 (PDT)
Date: Tue, 10 Mar 2026 09:27:35 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on
 CPU hotplug
Message-ID: <aa_kBwF3dv8L6TD8@google.com>
References: <20260310085433.3936742-1-maz@kernel.org>
 <5a5afd0a-de2d-4697-a5ba-0e470ddb20f2@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a5afd0a-de2d-4697-a5ba-0e470ddb20f2@arm.com>

On Tue, Mar 10, 2026 at 09:17:43AM +0000, Suzuki K Poulose wrote:
> On 10/03/2026 08:54, Marc Zyngier wrote:
> > Hotplugging a CPU off and back on fails with pKVM, as we try to
> > probe for ICH_VTR_EL2.TDS. In a non-VHE setup, this is achieved
> > by using an EL2 stub helper. However, the stubs are out of reach
> > once pKVM has deprivileged the kernel. The CPU never boots.
> > 
> > Since pKVM doesn't allow late onlining of CPUs, we can detect
> > that protected mode is enforced early on, and return the current
> > state of the capability.
> > 
> > Fixes: 2a28810cbb8b2 ("KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping")
> > Reported-by: Vincent Donnefort <vdonnefort@google.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >   arch/arm64/kernel/cpufeature.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index c31f8e17732a3..947ff71b3b66b 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -2345,6 +2345,9 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
> >   	    !is_midr_in_range_list(has_vgic_v3))
> >   		return false;
> > +	if (system_capabilities_finalized() && is_protected_kvm_enabled())
> > +		return cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR);
> 
> Is it a worth adding a comment here ? Otherwise this looks very odd -
> Returning the system state of a capability for a "hotplugged" CPU.
> 
> Otherwise
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


Tested-by: Vincent Donnefort <vdonnefort@google.com>

> 
> 
> > +
> >   	if (is_kernel_in_hyp_mode())
> >   		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
> >   	else
> 
