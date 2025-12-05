Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7E329ACE5
	for <kvmarm@lists.linux.dev>; Fri,  5 Dec 2025 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764956009; cv=none; b=FwSl1JMeCR232nU8WIGeuhFg55DVmkeZuxIeYBEQC0RfVnKP8BOLGF9NG24TuaX4NPCeO4bXKWl5hqsCuGI9GpLkauGU4MkwRpTj0r/HtPfD9k1fLQaGleDOo5kEs+qCea6JGbHXprhPVHYuWdeERx0ZVD1n6dnVMQMdpQISfCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764956009; c=relaxed/simple;
	bh=eB9+/Eym8/sl6sVLo+TtE0s7XKYj4AnzHDQpqXfgiDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fc7t8/yWohiao1bxc74tOdR2bOEAv1EqWfVEQZfo45nmhGsigGS6GqnIzNwuIQszegIrJsmOBfAaOWvHJujkc2a6YMwhL4NFx9jtAhxf1XqRlFbaPa+ITy4aVZFsUd9zJBuJ3k8htgqPXyvHGYsIkdmmeLzBtaBsCvsPFjEg22o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZJoEHFmo; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZJoEHFmo"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b3c965cc4so1168263f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 09:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764956005; x=1765560805; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=amtNQuwco1BO2PnhLkDFqIyQgPKVg/vOsmaYbePwmG4=;
        b=ZJoEHFmonL/xFRRvQMxZWoqYpab18ScM5X5VqSEGLZMDziCpkej7KzTSIAEPz6W3lZ
         cEwSFSw69+B9RQmM/3P/4q8fSDm/E/VCLeyKebJ1/MyO0Yd4YohNcLR2Tg2SQ+MqgGhd
         wFDJeKHaU17Sxj2o/lH4GK3uyrma3pWxr1zMD65WNpr00INwKnfNHBffxhlQMhOPn9B4
         uVZT73sadmuR/7M5A86hrgb0zQeXSbLKoIfBle4sHk6W+EjBOqXSOGb9rYqK/iC2UnbD
         RGW8/C7wKSmNEF5Q9lPNT650I1knI6Y+BaaHA6yBmgaHhIh76NrJqB8a6Kty1h6pIDXy
         v8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764956005; x=1765560805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amtNQuwco1BO2PnhLkDFqIyQgPKVg/vOsmaYbePwmG4=;
        b=eDtHHnKOWjFGwOd8LRPtIBaQQwV0TLawA04s46bVDYWxb/PA2qmvlYrWZzoQUUz/qS
         4q9PTjreqUD+sxX9copMrfgwqexB3hCgCsc9QkSeSoRrdCQr4O4SmcKyGq1u24z+V1UI
         7onLM2fJpkHScqYNvHvmkj0dXWyL955hA4ZugbgjWW6XWg+WY2hUVwxU9/OKpdXWWVCP
         v51khH7SvS/cJEtWc5cuFt2oGYoEPabzLFbSfXIml7vnqOUUd1hmMzCrM3JZbisSc9Ql
         R3RWJYzXRVMSk940/SaGlS3SdlJX1gTwp0vi99S1fwC4jRD4Pg/O5hgnos+GhkK78bD4
         x1yw==
X-Forwarded-Encrypted: i=1; AJvYcCVi3VHZjw/Ugq6ItMnfP7UNN7idT0f+7lOIxm1z8o2sCUSuVhCGhfTh/eSEZ8unzfOESSqCLvE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeiNJ1RcvbRZ36/QpS/SBFPvmaSQ0QeQELvfttXUnVNViHB/hC
	OU8SqJhhTsp8/OoAyeNBxOK1kLHx4i6L4Aw+fkZwE9SrmKeQJlLMCvlsDUL+02hqQw==
X-Gm-Gg: ASbGncsz6IQ0tEx1j4x3bCsS/kxgREs21SMeue6U6rfXX0AnGE+yq3iYOzzDCSTJHoL
	Jbg/DUQ27nS9AWvGcghqrKFFIW2gsXGmMkZIc+vSGU/nDZkLtp8G2TrAdNIUfDZDIGc5jUODoTd
	FXePqPEwGuj8+vieknAl7b17HfY3p+kPR0nfRX0ocTh9yaQftyshieNqY6M6y3b0X3U07APg/9B
	VPAOlDDCgHSZ5TWkOQILn4uLKd7afRh0Nk62R97HhC3/8U9kWhb40GISx9glKJBIcv5FxpInS6j
	ySUnnh/GGfYdxeADuffQ0cNJbmOvOFoxllf0cHOPfzs1s3nzAsA+Q5SpzW/7Aft1OrAR2ra/L7p
	n1DgTfxY8A5X0p1O+L5FbktaP595ZSDnDCPXjPKiE/SHxx+nVRw91RPW4fGAg/o0zQnx1SPsfqr
	JZgTIKdU0khmAjouo8G6eL4Mb2PSLPRYbiU1K6qo3UrcczRfxV7Q==
X-Google-Smtp-Source: AGHT+IG7GHbywu/ls/wVemuOmr6xVx9MQPax08/Ei7Uq0ye9NoSzMgiNsTxCLJQTc1fcXLx9fTdYtw==
X-Received: by 2002:a5d:64e3:0:b0:429:cf03:8b2e with SMTP id ffacd0b85a97d-42f89ecee3fmr43760f8f.13.1764956004866;
        Fri, 05 Dec 2025 09:33:24 -0800 (PST)
Received: from google.com (120.54.38.34.bc.googleusercontent.com. [34.38.54.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d2226d0sm9793222f8f.21.2025.12.05.09.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 09:33:24 -0800 (PST)
Date: Fri, 5 Dec 2025 17:33:21 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Jack Thomson <jackabt.amazon@gmail.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com, xmarcalx@amazon.co.uk,
	kalyazin@amazon.co.uk, jackabt@amazon.com
Subject: Re: [PATCH v3 2/3] KVM: selftests: Enable pre_fault_memory_test for
 arm64
Message-ID: <aTMXYZgZM3QvZP2i@google.com>
References: <20251119154910.97716-1-jackabt.amazon@gmail.com>
 <20251119154910.97716-3-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154910.97716-3-jackabt.amazon@gmail.com>

On Wed, Nov 19, 2025 at 03:49:09PM +0000, Jack Thomson wrote:
> From: Jack Thomson <jackabt@amazon.com>
> 
> Enable the pre_fault_memory_test to run on arm64 by making it work with
> different guest page sizes and testing multiple guest configurations.
> 
> Update the test_assert to compare against the UCALL_EXIT_REASON, for
> portability, as arm64 exits with KVM_EXIT_MMIO while x86 uses
> KVM_EXIT_IO.
> 
> Signed-off-by: Jack Thomson <jackabt@amazon.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |  1 +
>  .../selftests/kvm/pre_fault_memory_test.c     | 78 ++++++++++++++-----
>  2 files changed, 58 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 148d427ff24b..0ddd8db60197 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -183,6 +183,7 @@ TEST_GEN_PROGS_arm64 += memslot_perf_test
>  TEST_GEN_PROGS_arm64 += mmu_stress_test
>  TEST_GEN_PROGS_arm64 += rseq_test
>  TEST_GEN_PROGS_arm64 += steal_time
> +TEST_GEN_PROGS_arm64 += pre_fault_memory_test
>  
>  TEST_GEN_PROGS_s390 = $(TEST_GEN_PROGS_COMMON)
>  TEST_GEN_PROGS_s390 += s390/memop
> diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> index f04768c1d2e4..674931e7bb3a 100644
> --- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
> +++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> @@ -11,19 +11,29 @@
>  #include <kvm_util.h>
>  #include <processor.h>
>  #include <pthread.h>
> +#include <guest_modes.h>
>  
>  /* Arbitrarily chosen values */
> -#define TEST_SIZE		(SZ_2M + PAGE_SIZE)
> -#define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)

After applying on top of the base commit
8a4821412cf2c1429fffa07c012dd150f2edf78c, it does not build.

That TEST_NPAGES seems to still be used in delete_slot_worker(). I believe
that's because of

  "KVM: selftests: Test prefault memory during concurrent memslot removal"

Related issues with the pre_fault_memory() prototype.

Is that the correct base-commit or shall I use something else?

> +#define TEST_BASE_SIZE		SZ_2M
>  #define TEST_SLOT		10
>

[...]
