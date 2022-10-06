Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC87E654
	for <kvmarm@lists.linux.dev>; Thu,  6 Oct 2022 07:18:02 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id bj12so2457163ejb.13
        for <kvmarm@lists.linux.dev>; Thu, 06 Oct 2022 00:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ea93jPPPZUnNy1Db3wnhBZbPV56tR39Nal7oJ+XayI=;
        b=UAJDcoJhpsghahkmAGx14PoMD9XcbO7WhjPd+i1Zej2Aj661aE4tHAFg5ttXFPt3Oc
         Y6SG4FtF2XBaet5/nCGIfKm1kqriCM91VCQBZsW5hyZ8fxfiBxmjAxEwKyQyIXYwMWgk
         O2f0bgRufWmhdo4BaM2AS4URY30Ab2delyWullS21rqLT9nFj1dKyCKTEf+ZAPKDVv13
         +UQrPkH+RiWHGkfuBZfzy4Uy3VfqfrXGQkcGN5s6eq1cZqqbdOiduD8TG5QHXRzSXNTP
         /iCpAZBTm53eGMUCDjTEhO7OA/UBYgnw3EC0vsXXrLr4ETpC2A+ay0MypOEJlKnKwnEN
         SZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ea93jPPPZUnNy1Db3wnhBZbPV56tR39Nal7oJ+XayI=;
        b=aDM9Vsz/Zb8Z6MFVYBheLTcj2kFNLv1HpvFCj8KN3XrDW8aaWxr4SgqclYirJU7ZrW
         QlD4DbNtSK1mjE0cXh7WFnVC6g5NL/Y7HU4aN5kgw94Im4Eth3by7dc4FaN9Nm4zMeuT
         Y3Kukp01sqFrDr28RE+FPzN0zcCtzT0y5uwQhemZlCq9brDMiiWTa+6Z41uAf/SU/0NH
         EqGhj2OcBrgRBiG+qj2msDtR/PMLQReZXWq4/10E9XIgV5e0Y0V5sJq9KYQZ1t6WnA7p
         DkY32XGOJySC4iON9c/aBkzv16IqBDdUy7oeFA0/jN6howZh6bDFKOyzMd4ZQfibQtAg
         DD5w==
X-Gm-Message-State: ACrzQf04HHQuO7OSCQtV1GCdErUS5da787nD4bvGiNs3tBlmukCg3U5t
	DEDbCqV4AkH8aRcDQtIRtq9SIg==
X-Google-Smtp-Source: AMsMyM5lMgBe+83HYsui965SYgP5BGoba5FSPC8HBc7sSZbBkowS+puYBdElrvbWbkpoDXaLhR7jVg==
X-Received: by 2002:a17:907:6ea8:b0:78d:36d9:b9ef with SMTP id sh40-20020a1709076ea800b0078d36d9b9efmr2919954ejc.408.1665040680691;
        Thu, 06 Oct 2022 00:18:00 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id c9-20020a17090618a900b0077b2b0563f4sm10017756ejf.173.2022.10.06.00.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 00:17:59 -0700 (PDT)
Date: Thu, 6 Oct 2022 07:17:56 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, will@kernel.org,
	catalin.marinas@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, dbrazdil@google.com
Subject: Re: [PATCH] KVM: arm64: Enable stack protection and branch profiling
 for VHE
Message-ID: <Yz6BJJIadPqiktfO@google.com>
References: <20221004154216.2833636-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004154216.2833636-1-vdonnefort@google.com>

On Tuesday 04 Oct 2022 at 16:42:16 (+0100), Vincent Donnefort wrote:
> For historical reasons, the VHE code inherited the build configuration from
> nVHE. Now those two parts have their own folder and makefile, we can
> enable stack protection and branch profiling for VHE.

+CC David who has been messing with these Makefiles in the past to
confirm, but this makes sense to me.

Reviewed-by: Quentin Perret <qperret@google.com>

> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index 687598e41b21..a38dea6186c9 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -5,9 +5,6 @@
>  
>  incdir := $(srctree)/$(src)/include
>  subdir-asflags-y := -I$(incdir)
> -subdir-ccflags-y := -I$(incdir)				\
> -		    -fno-stack-protector		\
> -		    -DDISABLE_BRANCH_PROFILING		\
> -		    $(DISABLE_STACKLEAK_PLUGIN)
> +subdir-ccflags-y := -I$(incdir)
>  
>  obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index b5c5119c7396..48f6ae7cc6e6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,6 +10,9 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
>  # will explode instantly (Words of Marc Zyngier). So introduce a generic flag
>  # __DISABLE_TRACE_MMIO__ to disable MMIO tracing for nVHE KVM.
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
> +ccflags-y += -fno-stack-protector	\
> +	     -DDISABLE_BRANCH_PROFILING	\
> +	     $(DISABLE_STACKLEAK_PLUGIN)
>  
>  hostprogs := gen-hyprel
>  HOST_EXTRACFLAGS += -I$(objtree)/include
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 
