Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC60138FBC
	for <kvmarm@lists.linux.dev>; Fri,  6 Oct 2023 19:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gvMuv/kt"
Date: Fri, 6 Oct 2023 19:41:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696621317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vbZQIdAI5SufBWkEnAicqe6YpUsHJGukAGL4rjlW0as=;
	b=gvMuv/kta5sMP92U7s7hL4jqIgx86ia/PnhLjX6FqlQEDBEKOdI5BRpXeYzHnqYtBExtzm
	6koLBOQ1XWaAuDHuQWoep7fg5dcETAJGm0ft1KWBFs9ohosM8+PWPoPhq8VHk4D7VeOxGP
	ucma4LY185PbyV7vDFXp6lmQXnIzVCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 1/2] tools: arm64: Add a copy of sysreg-defs.h generated
 from the kernel
Message-ID: <ZSBjAWlPUBjiU7Vj@linux.dev>
References: <20231005180325.525236-1-oliver.upton@linux.dev>
 <20231005180325.525236-2-oliver.upton@linux.dev>
 <66914631-c2fe-4a20-bfd6-561657cfe8e8@sirena.org.uk>
 <ZR_SLyTfkhmdZoXI@linux.dev>
 <ec96d303-f0c4-470c-b23c-e59054c52008@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec96d303-f0c4-470c-b23c-e59054c52008@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 06, 2023 at 12:33:48PM +0100, Mark Brown wrote:
> On Fri, Oct 06, 2023 at 09:23:59AM +0000, Oliver Upton wrote:
> > On Fri, Oct 06, 2023 at 01:23:08AM +0100, Mark Brown wrote:

[...]

> > incidental user of this via cputype.h, KVM selftests is what's taking
> > the direct dependency.
> 
> If perf doesn't care perhaps just restructure things so it doesn't pull
> it in and do whatever you were doing originally then?

The only option would be to use yet another set of headers that are
specific to KVM selftests, which I feel would only complicate things
further.

> > > Surely if perf is happy to peer into the main kernel source it could
> > > just as well do the generation as part of the build?  There's no great
> > > obstacle to having a target which runs the generation script that I
> > > can see.
> 
> > That'd be less than ideal, IMO. tools maintaining a separate set of kernel
> > headers from the authoritative source avoids the need to coordinate
> > changes across kernel and tools. To keep things that way we either need
> > to copy the script+encoding or the header output. The latter isn't that
> > bothersome if/when we need an update.
> 
> The error Stephen found was:
> 
> | In file included from util/../../arch/arm64/include/asm/cputype.h:201,
> |                  from util/arm-spe.c:37:
> | tools/arch/arm64/include/asm/sysreg.h:132:10: fatal error: asm/sysreg-defs.h: No such file or directory
> 
> so that's already happening - see perf's arm-spe.c.  You could also fix
> perf by avoiding spelunking in the main kernel source like it's
> currently doing.

My interpretation of that relative path is tools/arch/arm64/include/asm/cputype.h

The include path in tools/perf/Makefile.config is using tools/ headers
as well:

  INC_FLAGS += -I$(src-perf)/util/include
  INC_FLAGS += -I$(src-perf)/arch/$(SRCARCH)/include
  INC_FLAGS += -I$(srctree)/tools/include/
  INC_FLAGS += -I$(srctree)/tools/arch/$(SRCARCH)/include/uapi
  INC_FLAGS += -I$(srctree)/tools/include/uapi
  INC_FLAGS += -I$(srctree)/tools/arch/$(SRCARCH)/include/
  INC_FLAGS += -I$(srctree)/tools/arch/$(SRCARCH)/

perf + KVM selftests aren't directly using kernel headers, and I'd rather
not revisit that just for handling the sysreg definitions. So then if we
must periodically copy things out of the kernel tree anyway, what value
do we derive from copying the script as opposed to just lifting the
generated output?

We must do _something_ about this, as updates to sysreg.h are blocked
until the handling of generated headers gets worked out.

-- 
Thanks,
Oliver
