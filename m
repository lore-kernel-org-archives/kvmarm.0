Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712DC2F30
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 00:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726014374; cv=none; b=q4lVvo60N7WawTku+dg0LYCxunWBSLe4MmtRBg8Rxd3ovnn7HjR3Wib85knQGYOr0w0+hB7p4XHxJU9lyFDmibPh9Oe0pPFS7k0L/fE6J0+YmZdcLr7Ov243g/DMc9hwhjJWpVE4JA5pB6itSuP576bc3vIm2PBl3nDTiEQ2Biw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726014374; c=relaxed/simple;
	bh=itxfKfmbD/zsCr0etIDjn7Mvr1MVTsWI0y9iTbmeGSc=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=DiWrQmZSq6IvVTB9OVH6suG9yjOxaMb6o+G7Z5WVPhiaLDrTqJYg5KAsSvIQm/RRi95Fg8cMvIIxJ55m3xPAhMxnbahWoIBVlWckicr3dloi4vf5hNIwV7XXyj4MfTIYyUF+/ED7FGRJ+I/xfnYRK7ji26dzsot+5Sc36qJEFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Er6VUUmU; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Er6VUUmU"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20551e2f1f8so61705925ad.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 17:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726014373; x=1726619173; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEyXAdKeEJQoAHfFQf1BZ5A9dLRXujoz25bWx+9TXyc=;
        b=Er6VUUmUyTn4G8s/sbI1+QPK0XuQR5wRiE50encTdNHUy2LDNIMmBE+WNJ8KzHEvGE
         Yv3AYZmfnLupek1DLNYb+EwYhS4UijoEB1YpxAIHavApVjCbveRCM5p3i2r024En6bgk
         eV81CBDKey5T7abrFwzi54Gwwd3IP8rXlMDb/c6UoDOZpJXG/sxWpvXfOSIqk1TfiqKE
         /uGWp9BYpLEjdmh9U18P+FacVYfC7vajEyF1CRlPwKCBIcP0nOVT1vsqAUyyjMhYc/jY
         5klY2LIVcCWL7AQy1LE/Yw30Zi56YTBCH2jMGs1dsVp/SP37YheJr37wALcpqVenk5eP
         NcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726014373; x=1726619173;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cEyXAdKeEJQoAHfFQf1BZ5A9dLRXujoz25bWx+9TXyc=;
        b=oMeyWgfTczj3hcef+h/UNzuUIbkrHBjNUQB0IFMQjawWFtDE3g/VJvdhPiBZy1A6wF
         bsNPioDegOAVRwtqB3tfCvgKVDRTG2VPL3ZtEqvfwYWzuN/hIOYKVMV359+zd20WN1vx
         MzzCygomXUoXrat5TzakwDHbnrs4aSRokCXdRXvqxaWpRfw+ILd9BrYOxPRElEbwBvGc
         03wN4Dw3zO+NOntauz87Ojl0p03m1eBvp9O1XuoxIx5nHMFGc8ty+2BNMX24pHlABp/t
         RsH8RFJejUKB9GQVIUdGf2L5CaKgqcIRTJGlqqRaNo72L6YHDPvqv5sS/S+Ss6cufgFC
         Cr4A==
X-Forwarded-Encrypted: i=1; AJvYcCW95HDcQ3lJsxPspPvdqCrBE8tTOPhvvjWhggHL4tAIJfeXRikZJBmBECpkzG6Ip4RLDN6M1Xs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNstDkphlCGSUnME34erXA6RYKLgoLJZZrOFTpyGzf2ErLSTEp
	kxTNVQmye1fL1DlTrMr+9/pZQDOlxEweZ7jDWPoiVKhAi/k0Z7AN
X-Google-Smtp-Source: AGHT+IHdupOZtZNvqV8Jq+ivzEDY7SaRBw9l5Q5S/ff1gCan8RdbB7OhqPF/t1bFYOvCzz+LolCTIQ==
X-Received: by 2002:a17:902:ce11:b0:206:c486:4c33 with SMTP id d9443c01a7336-2074c631b1amr37647145ad.30.1726014372538;
        Tue, 10 Sep 2024 17:26:12 -0700 (PDT)
Received: from localhost ([1.146.47.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710eea95esm53895415ad.161.2024.09.10.17.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 17:26:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Sep 2024 10:26:03 +1000
Message-Id: <D431108K19Z2.3EDZQCSG5RC4X@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <lvivier@redhat.com>,
 <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <nrb@linux.ibm.com>,
 <atishp@rivosinc.com>, <cade.richard@berkeley.edu>, <jamestiotio@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] riscv: gitlab-ci: Add clang build
 tests
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.18.2
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-10-andrew.jones@linux.dev>
In-Reply-To: <20240904105020.1179006-10-andrew.jones@linux.dev>

On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> Test building 32 and 64-bit with clang. Throw a test of in- and out-
> of-tree building in too by swapping which is done to which (32-bit
> vs. 64-bit) with respect to the gcc build tests.
>
Acked-by: Nicholas Piggin <npiggin@gmail.com>

> Acked-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  .gitlab-ci.yml | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 67a9a15733f1..b7ad99870e5a 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -176,6 +176,49 @@ build-riscv64-efi:
>        | tee results.txt
>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
> =20
> +build-riscv32-clang:
> + extends: .intree_template
> + script:
> + - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu clang
> + - ./configure --arch=3Driscv32 --cc=3Dclang --cflags=3D'--target=3Drisc=
v32' --cross-prefix=3Driscv64-linux-gnu-
> + - make -j2
> + - printf "FOO=3Dfoo\nBAR=3Dbar\nBAZ=3Dbaz\nMVENDORID=3D0\nMARCHID=3D0\n=
MIMPID=3D0\n" >test-env
> + - ACCEL=3Dtcg KVM_UNIT_TESTS_ENV=3Dtest-env ./run_tests.sh
> +      selftest
> +      sbi
> +      | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
> +build-riscv64-clang:
> + extends: .outoftree_template
> + script:
> + - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu clang
> + - mkdir build
> + - cd build
> + - ../configure --arch=3Driscv64 --cc=3Dclang --cflags=3D'--target=3Dris=
cv64' --cross-prefix=3Driscv64-linux-gnu-
> + - make -j2
> + - printf "FOO=3Dfoo\nBAR=3Dbar\nBAZ=3Dbaz\nMVENDORID=3D0\nMARCHID=3D0\n=
MIMPID=3D0\n" >test-env
> + - ACCEL=3Dtcg KVM_UNIT_TESTS_ENV=3Dtest-env ./run_tests.sh
> +      selftest
> +      sbi
> +      | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
> +build-riscv64-clang-efi:
> + extends: .intree_template
> + script:
> + - dnf install -y edk2-riscv64 qemu-system-riscv gcc-riscv64-linux-gnu c=
lang
> + - cp /usr/share/edk2/riscv/RISCV_VIRT_CODE.fd .
> + - truncate -s 32M RISCV_VIRT_CODE.fd
> + - ./configure --arch=3Driscv64 --cc=3Dclang --cflags=3D'--target=3Drisc=
v64' --cross-prefix=3Driscv64-linux-gnu- --enable-efi
> + - make -j2
> + - printf "FOO=3Dfoo\nBAR=3Dbar\nBAZ=3Dbaz\nMVENDORID=3D0\nMARCHID=3D0\n=
MIMPID=3D0\n" >test-env
> + - ACCEL=3Dtcg KVM_UNIT_TESTS_ENV=3Dtest-env ./run_tests.sh
> +      selftest
> +      sbi
> +      | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
>  build-s390x:
>   extends: .outoftree_template
>   script:

