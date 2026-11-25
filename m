Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621323;
	b=n1/1fvkeB2GQkXCuGvZXqCVB7bl8QL0Tuw7LfhzSduuf+HB+KxLSEl8WKx1oyCIvnNZb
	 cJ9mb9x78t62EHeKnyOniWnd+7UqEjT6EIyyzHiQHGFm+5SzjrCUG7yBca+SjS0i3qoqZ
	 yZxAFrBT0ba107ajrgmpW7NidpK/YXkuMN8pIDhAGpNLPvLUf6oaJUP03Svn8prg3WAqa
	 IRAPUtHaGGE+mRCoikuNqA3nASSJJmb3OqfIcHUQ9WFSrctZ5GRgqioiIooPaFpwvApY9
	 0h0dh2VE108X34eVKy9f3qgGOcEjZCKg3Ly/joPdoZzz30oOW/xCBveduSd0oKNUc5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621323;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EQZSFzWaxf/IxwfImonvvEBds2UHS4e60bC/g5jvdw0=;
	b=DvgUw/e62iIvJvG3U2lw4KI2TQd6gbvGJqnduvcVX07NOUdCnbErWraF1oI8ltk0WxFW
	 JsU9/Eh7yNZJHdS9avPYHRg+4FrxXg9d3/oBH4vUbE34/4csTVRofKausLaA3J29591ir
	 BQeH9uURAIrrugBXSL8HrwatsmamPX+d+HdyrSGfQz3v8dKlopKdXjWTVEcCY4K4wZsn6
	 2pBS/eJKQ/ptvtYPX/1vF2XSUsro+sCF3IgQJnK1ETuOa0bXaRfWK8/cZ9tuTWliVA+bf
	 wVV4XDCu8dfuu8JFoG0S7pik/MJvkNelj8U5tB2tV9kpul/sLYJUAdxLxXkgGl3npBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iANgKMkr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D581606A6A8;
	Wed, 25 Nov 2026 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iANgKMkr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98D81F000D8;
	Wed, 25 Nov 2026 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621322;
	bh=EQZSFzWaxf/IxwfImonvvEBds2UHS4e60bC/g5jvdw0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iANgKMkrhZSX680WviP1Xhu6wPpl6YOkE7+s59+P8k7B0CMY+lpv/RHOXU2Y8Yea0
	 5WyvYXbed8nEWVkpe3YDlPsBiVr4QgLlIWHkdTG+TpnSwvKCCAsglayu+WfQR63k5Z
	 ISzFBBCbQW6taOK7IhLSFF+ShIPqlTENTk252v/AEwcXwo8UVa0W/n4bOubfjlnwVI
	 otK4aodMdfImU0N+jxWTWCEKff0H9DPeyRK/u73/fmglrcXSp0wv4A7iOyRawKPOGI
	 VKNuEBryrYfJYLVsehICA9pE8dOudobO5or4JZpQpa7PNm6HRajdXAeWo0TFi6kcJn
	 D4RJFNk5+Ew1Q==
Message-ID: <sashiko-outbox-233667@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: selftests: Pin vpmu_counter_access to one
 CPU
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Clark" <james.clark@linaro.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261125-james-kvm-pin-pmu-test-v1-1-c3ce989233fb@linaro.org>
References: <20261125-james-kvm-pin-pmu-test-v1-1-c3ce989233fb@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 15:42:02 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: arm64: selftests: missing Fixes trailer for
  vpmu_counter_access
--

commit 743d06a69fdece62aa16db9a505ef5da1403cfd6
Author: James Clark <james.clark@linaro.org>

> KVM: arm64: selftests: Pin vpmu_counter_access to one CPU
>
> The vpmu_counter_access test reads the maximum PMCR_EL0.N from one VM
> and then creates new VMs for each number of counters up to that limit.
> If the test migrates between CPU types the limit may not be valid for
> the new VM which causes:
>
>   =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>     arm64/vpmu_counter_access.c:483: !ret
>     pid=3D9165 tid=3D9165 errno=3D22 - Invalid argument
>   ...
>     KVM_SET_DEVICE_ATTR failed, rc: -1 errno: 22 (Invalid argument)
>
> For example on a Radxa Orion O6 with 20 counters on the big cores and 6
> on the little cores, this happens on most runs.
>
> Fix it by pinning the test to the CPU that it starts on before any VMs
> are created.
>
> Signed-off-by: James Clark <james.clark@linaro.org>

[Severity: Low]
This fixes a bug present since the test was introduced.  Should this
include:

  Fixes: 8d0aebe1ca2b ("KVM: selftests: aarch64: Introduce vpmu_counter_acc=
ess test")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125-james-kvm-=
pin-pmu-test-v1-1-c3ce989233fb@linaro.org?part=3D1
