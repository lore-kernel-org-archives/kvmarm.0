Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621779;
	b=1zUIX5JlRIaX+rPyHeGm7E18zF14Sk3Gp3rjP39JGzD88FCvtDFsAeL6mcMZFP1+hSHE
	 G+y5Wt2qvtNW7UAYRoEjVZFcAbzo4MSJhB6urXTHijLXbPHhpz0HdNhiryPWaDyRI2Xjz
	 uI9jOsrJhEhrPISR+OQTd9razrLWEeJyVMvwFBTSIQCquYhP88mJNqHfv0+oSEEcIJzXE
	 1X3NS/2zqR8HrHUVcxLtwnC3c9PZcaEBQQwM6mJnStQC9jzZ7renHzqHJxPIuXag0xr50
	 ieTu5L8jsBIgucqiiLakN0fC9kerHU+kua9i0w5XscXXixmpVE9ROvCkTIZxZ6IV0CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621779;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=khFMMDagp7G9Nsof8l3eonauio4Yn3HdCBxJqIhS03A=;
	b=nGWNDjG65ZjH2UjlZ1QaJe/gtvTA96qhcd/+DSsoaDl6xbCJICvy3S/rvMLaNXxT8Fc0
	 1bPHkgkRZppcZaa+svTLPlniAZOhpoRaWXSdnYAW7U0xtqFzvozTK54THcdcy6z931AUa
	 hATfSU2+nxfqrud5wg8BjKlP+LighReq3qPMgQOQSVnhsdVtQL4F4hjAvytGFkUAfGjql
	 tT0nBR7/mdYhDvRO1xkQpuIhTr4UvilO+pTmPrr2Lhms2CcNl5LQz+YEjbVevXhiGkjx5
	 pfDMuGugeV5ax3jz8JmP5Ob9N2BmII8fPApw9Xxb/KO6TKzGirQkZd8vBrtRg1dHwrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fJYkZK8A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9893606A329;
	Wed, 25 Nov 2026 15:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fJYkZK8A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D621F000D1;
	Wed, 25 Nov 2026 15:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621778;
	bh=khFMMDagp7G9Nsof8l3eonauio4Yn3HdCBxJqIhS03A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fJYkZK8AB+TpDaySGfnDb2R0yZEkPn3YQAKsNMN00DuSa+Tm4SDF4D6unWrJuQ3h7
	 IIjiU2OBpdV/xStna0t+bWrrDM0sNrVXAQ5foIfTY7yg57Pr6JDgFiEojvwBKklOGk
	 EztuOs4IZxrnpVmzTC2UEAQ288f1VVSazNQ+UCG1OWl/2WNofMPHEABNPBTQv9qLs2
	 0tqn7ondjXQTwv2ODSHRr8pNlRB6q/tQUhA13M0wemqjq4Akk3KTRkpySHw1Lsj7je
	 crog3OImTTfCVver/7OhwpGNdlJ234rCUNbwA92CEufn6aLLdZegV+eX4wGtRQX8Kc
	 GCvCb3cz7xRYA==
Message-ID: <sashiko-outbox-233677@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/20] KVM: arm64: Don't advertise the host's
 MTE_frac to protected VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261125153911.106793-3-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
 <20261125153911.106793-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 15:49:38 +0000
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
- [Low] KVM: arm64: missing Fixes trailer for commit 3d7ff00700d1
--

commit f7eced7525b14181f745f704977ce69bbe4690ce
Author: Fuad Tabba <fuad.tabba@linux.dev>

> KVM: arm64: Don't advertise the host's MTE_frac to protected VMs
>
> Protected VMs don't support MTE, so MTE_frac in their ID_AA64PFR1_EL1
> doesn't apply and is RES0, as it is for a non-protected VM without MTE.
>
> Commit 3d7ff00700d1a ("KVM: arm64: Rework specifying restricted
> features for protected VMs") caps the field at NI in the pVM
> restriction table. However, NI is 0xF and the clamp is unsigned, so the
> cap does nothing and a protected guest sees the host's value. On a CPU
> with MTE2 but without FEAT_MTE_ASYNC, that value is 0xF.
>
> Drop the entry so that the field reads as 0 again. It was the only
> entry capping an unsigned field at an NI other than 0.
>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

[Severity: Low]
Should this include a Fixes tag for the commit that added the MTE_frac
entry to pvmid_aa64pfr1[]?

  Fixes: 3d7ff00700d1 ("KVM: arm64: Rework specifying restricted features f=
or protected VMs")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125153911.1067=
93-1-fuad.tabba@linux.dev?part=3D2
