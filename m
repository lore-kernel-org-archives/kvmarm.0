Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE3B39B947
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788015910; cv=none; b=mciJD4irzt8veRhrJWpR2sG4XLvJupuSXHqwAqXZKnK6pxtPHKwMQFbzPiWkbV0dAdKwM5zXcObBN11IdivlzqAg6PB+BL73llbD2gecZjtEh5AjQdxm7mov4RRftG+SCiwQY93RDAe78Kn6poZHFBwq7tz0gto03dBf6oOs2RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788015910; c=relaxed/simple;
	bh=kwvpB2s4F2EzLbnFB1heuBDYWxBCbVtzb/X0O2S5ZOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G39ekkK2sJsXorlRZZLDMmOsdZmFjgM1Lhs2U8+thBU0iQqIL5GP7lU1KakqDrLPxQ3ravBCuInciB5EB0wmNZqkU6O89KiQ5+9je8iXEbVCkescdPq9fsrobDy95RNt3Bj7ozLrGdI3V6/yX9NivKTqDTX5snsoQYGjOR7GwVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vJHGdqXM; arc=none smtp.client-ip=91.218.175.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vJHGdqXM"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kwvpB2s4F2EzLbnFB1heuBDYWxBCbVtzb/X0O2S5ZOc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788015906; v=1; x=1788620706;
 b=vJHGdqXMU/2kcg/FrkTSr4bB4CiG8BHHkVkSh2pnIGsrbRuG2P/kMsY+m8/cC5HphJ0TiYMh
 fwTXHe5u8U3iG6dnGffYXWJMiZ8Yvisn+XGGn7Uo5fpoRVfwS4qcdEjURsQO+YAPh7UQjt2rVYF
 /u2twBePttGPQZGgacoFXqQk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8552a3e7d7c80a95;
	Sat, 29 Aug 2026 15:05:04 +0000
X-Mizu-Trace-ID: 8552a3e7d7c80a95
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so2212e87.1
        for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 08:04:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxfcbvSxT4IveMTBIT8qPfjVpSTfPaUEvhi+ghS+M9mO14MKes4QnsFrvf5J7uHxhsHMr2dJdM=@lists.linux.dev
X-Gm-Message-State: AFuF++ltj8XAHxDWNdjhGc+8ttX9GYnmKpWk1j5UnzS5b+v8/NnswkGL
	bV3v2Kx+a5XyBHy+pVcpQ8dTEutmJ0FGoxrBrOE+1csQFSxgWOAeSOZ9mkUxXo0q3LClI6zDl6Q
	rJHJzropRTIZRqPD9701gFFr80TqFzNuXBnG65nzj
X-Received: by 2002:a05:6512:2392:b0:5ae:b0ee:f737 with SMTP id
 2adb3069b0e04-5b5ef22d25dmr97393e87.9.1788015898930; Sat, 29 Aug 2026
 08:04:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260829054856.70549-1-kmehltretter@gmail.com> <20260829054856.70549-3-kmehltretter@gmail.com>
In-Reply-To: <20260829054856.70549-3-kmehltretter@gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 29 Aug 2026 16:04:22 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzexMPUFJ_DuqAmKFP57UTd_nqGevWBqODDRi3tvg-YEA@mail.gmail.com>
X-Gm-Features: AcwNN1XqbhfaFCphLC-k_pbis2x4NMIEFS4Vcu3x3JJmr3Eq6xNmX3vLDUzikl0
Message-ID: <CA+EHjTzexMPUFJ_DuqAmKFP57UTd_nqGevWBqODDRi3tvg-YEA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Test empty SMCCC filter range
 at base 0
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 29 Aug 2026 at 06:50, Karl Mehltretter <kmehltretter@gmail.com> wrote:
>
> test_invalid_nr_functions() only checks an empty range at
> PSCI_0_2_FN64_CPU_ON, which KVM's end < start check happens to catch.
> It never exercised base 0, where the inclusive end wraps to U32_MAX
> instead.
>
> Add the base 0 case. Without the preceding fix it fails with EEXIST.
>
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Same nit as before.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/arm64/smccc_filter.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/arm64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
> index 21e41880261b..a41ed3e016ba 100644
> --- a/tools/testing/selftests/kvm/arm64/smccc_filter.c
> +++ b/tools/testing/selftests/kvm/arm64/smccc_filter.c
> @@ -140,6 +140,10 @@ static void test_invalid_nr_functions(void)
>         TEST_ASSERT(r < 0 && errno == EINVAL,
>                     "Attempt to filter 0 functions should return EINVAL");
>
> +       r = __set_smccc_filter(vm, 0, 0, KVM_SMCCC_FILTER_DENY);
> +       TEST_ASSERT(r < 0 && errno == EINVAL,
> +                   "Attempt to filter 0 functions at base 0 should return EINVAL");
> +
>         kvm_vm_free(vm);
>  }
>
> --
> 2.39.5 (Apple Git-154)
>
