Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39DD21A58B
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 09:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709543190; cv=none; b=U1YPWXQPZ8H+TpDwPG9NvLpCFmIiqJiNBFyltAgROX+cNtSPY0UMTb7677GZrNKTI/nNkLRNlLIiR0jJGVlQCLghVoQh9LCJLC7fBcllqfhOxjChx8BpHpDQNWjjvoDFdlPIZTS03p7qWBq8qhclYGGMLNSnrPQXZzk7R+QRz3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709543190; c=relaxed/simple;
	bh=SOJNLxkPigcuNWjUVf5cDijUNYpZP5lkl6kkKnK18ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWYZSsx+fqZ+IXn03aUZuI5ouIjvydosdARSblZbexVSeTqsLXK3eeXzTPEqfxPnk1Ch6/nxXHwF+sFedQ4XFb37iVGNrVZ4BTn/tQOlxeqM0oxOQJQnXyP8I25zKre8TLYQTRq8RlFPeZaVs2e/sLetj4TfYngw69meohz9g68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AC631FB;
	Mon,  4 Mar 2024 01:07:03 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DA143F762;
	Mon,  4 Mar 2024 01:06:25 -0800 (PST)
Message-ID: <17147e9a-6650-49c3-9b16-03ed1486f70c@arm.com>
Date: Mon, 4 Mar 2024 09:06:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 18/18] arm64: efi: Add gitlab CI
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-38-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-38-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> Now that we have efi-direct and tests run much faster, add a few
> (just selftests) to the CI. Test with both DT and ACPI. While
> touching the file update arm and arm64's pass/fail criteria to
> the new style that ensures they're not all skips.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

I really like --enable-efi-direct, thanks for adding support for this 
and all the clean-ups!

Thanks,

Nikos

> ---
>   .gitlab-ci.yml | 32 ++++++++++++++++++++++++++++++--
>   1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 71d986e9884e..ff34b1f5062e 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -44,7 +44,35 @@ build-aarch64:
>         selftest-vectors-user
>         timer
>         | tee results.txt
> - - if grep -q FAIL results.txt ; then exit 1 ; fi
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
> +build-aarch64-efi:
> + extends: .intree_template
> + script:
> + - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu edk2-aarch64
> + - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu- --enable-efi --enable-efi-direct
> + - make -j2
> + - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
> +      selftest-setup
> +      selftest-smp
> +      selftest-vectors-kernel
> +      selftest-vectors-user
> +      | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
> +build-aarch64-efi-acpi:
> + extends: .intree_template
> + script:
> + - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu edk2-aarch64
> + - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu- --enable-efi --enable-efi-direct
> + - make -j2
> + - EFI_USE_ACPI=y ACCEL=tcg MAX_SMP=8 ./run_tests.sh
> +      selftest-setup
> +      selftest-smp
> +      selftest-vectors-kernel
> +      selftest-vectors-user
> +      | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
>   
>   build-arm:
>    extends: .outoftree_template
> @@ -59,7 +87,7 @@ build-arm:
>        pci-test pmu-cycle-counter gicv2-ipi gicv2-mmio gicv3-ipi gicv2-active
>        gicv3-active
>        | tee results.txt
> - - if grep -q FAIL results.txt ; then exit 1 ; fi
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
>   
>   build-ppc64be:
>    extends: .outoftree_template
