Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1742D799
	for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 13:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="eWWMO8eh"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-336378d3bfdso926652f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 05:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702475536; x=1703080336; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PTROWi090VipJqK8OYHPEAxaQ5DHXWxJFjKYJmaz5R0=;
        b=eWWMO8ehxYw0DQ9+bauzTSJ13A+n4y0FdklLbq7CFewTSc3Q540qUhLp6IfgK0M1Rc
         oJUX50ZFDZkffKm4B/fZ1Jj+XhrVW1GTJ2IOtBNncCh+vPFk/3vp+WDBpUrO6ut1dAQb
         0Xq9EZ7VRCZ7/W4k2AFTnNnTLPiP1gl6Zyz2YPjhTD1cSk6KmhTdlIwBCrDhg0QSSxWa
         rUFrcUbEKCNDlfF4Lp00GzBW+h1kEyKflDuwoiTrXNGDUOqsZgFSTddC8+Gc6BNDjrOn
         3RU31LDk5ym76+fp5fbCnhu3jzen3dC6u5/Vb78AWi/pWAE/gjsjz8Mnw7H81/y5nUk5
         +HXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702475536; x=1703080336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PTROWi090VipJqK8OYHPEAxaQ5DHXWxJFjKYJmaz5R0=;
        b=vTzeaH8aVlsU+6D3fLDBTpxJzmr9p5BYU0HSlg8xUS6D3W99dU7a1q4iJ1d6bspaG0
         cWQNrBSgs+jRdEygS4knnY43SF2fuNZ2rN6GwE/ZYxYHMdr3WMcZUeCRyHY2j0B6Bu1i
         FT9WVk9XRjqU3qcCJpcCCcmsk2S2oFSWxWb7qTzslC+BsJD53sFSs5lbX3gZyeIZXltD
         OevB6Nsn83irVSLH1DBiWu9JNMoNNH5I4VgV+jTNTvjyULRyOOpDoD3//5R3M2tHOS4q
         oVfHWCy2KpuoJVj9RiG6Ie217lpR12QR0Ni5Gf+k88VB/vo3l/ZYaP5RFaVCj3G4FkJg
         AMUA==
X-Gm-Message-State: AOJu0YzrBr0ZG2croTwvAc5f5HngHSQeOWMQxHsjwXqPRK/yvjO8oG5z
	f47qGPE0K/BIT8bmXidOnP0Xjg==
X-Google-Smtp-Source: AGHT+IF5kmk8LVZ85W7N3gISbpDLPY8LvD+Hn6K1kJJ6Gm74g8cpX+vaNl8XPZV2r1+Itxbw0xZgcg==
X-Received: by 2002:a05:600c:220f:b0:40c:2100:60b1 with SMTP id z15-20020a05600c220f00b0040c210060b1mr3672409wml.178.1702475536469;
        Wed, 13 Dec 2023 05:52:16 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id s13-20020a05600c384d00b004030e8ff964sm22836432wmr.34.2023.12.13.05.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 05:52:16 -0800 (PST)
Date: Wed, 13 Dec 2023 14:52:15 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Greentime Hu <greentime.hu@sifive.com>, wchen <waylingii@gmail.com>, Jisheng Zhang <jszhang@kernel.org>, 
	Samuel Holland <samuel@sholland.org>, Minda Chen <minda.chen@starfivetech.com>, 
	Sean Christopherson <seanjc@google.com>, Like Xu <likexu@tencent.com>, Peter Xu <peterx@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, Thomas Huth <thuth@redhat.com>, 
	Aaron Lewis <aaronlewis@google.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v4 03/11] KVM: selftests: Add CONFIG_64BIT definition for
 the build
Message-ID: <20231213-b7a894416841716b792da2d5@orel>
References: <cover.1702371136.git.haibo1.xu@intel.com>
 <227b86955b24583b5cacedc8480e8f5d7e4fabf8.1702371136.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <227b86955b24583b5cacedc8480e8f5d7e4fabf8.1702371136.git.haibo1.xu@intel.com>

On Tue, Dec 12, 2023 at 05:31:12PM +0800, Haibo Xu wrote:
> Since only 64bit KVM selftests were supported on all architectures,
> add the CONFIG_64BIT definition in kvm/Makefile to ensure only 64bit
> definitions were available in the corresponding included files.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 4838ea899bbb..bb03e278a163 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -225,7 +225,7 @@ else
>  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
>  endif
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> -	-Wno-gnu-variable-sized-type-not-at-end -MD\
> +	-Wno-gnu-variable-sized-type-not-at-end -MD -DCONFIG_64BIT \
>  	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
>  	-fno-builtin-strnlen \
>  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
