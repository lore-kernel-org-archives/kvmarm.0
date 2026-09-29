Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E26C3E171B;
	Tue, 29 Sep 2026 22:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720801; cv=none; b=YmKSPvJf7J3K5d0pdb1sM1N8F5Nt2H5wPfIpaNikEbOGhlopIbyY0KaHxa58Wm/Dw1436Mz4DrxIF28fbBrdbPmkA+eFRf7cZKMnHlP7Vgi0d1DuC8hqeikFFoqyabn51HPUnRBYnV6NSoXkoTfUwPwIg+vaPJ/JQDK08W/Autk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720801; c=relaxed/simple;
	bh=32JVtxIhLjbC8kr9pwS16aE/dTbbA1EEglPJIytqlqg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TtXl3n+cKPaj6iooa3GJ9Xdko8MIuM8ZxhBKJ7VmoBa/dsLUdKSWC4EbO+cVrUIzDrtgUIrfbEM7lGmytSksuzCX8NomISnuq76c1Avk8ahIKjTTqGa44qCxk+9P+XY2JVgrPsZtnBvX3qPyaj7XBjhOSGw9YUCweEI6WvYqGBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2tB2fdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2tB2fdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997731F000FF;
	Tue, 29 Sep 2026 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790720799;
	bh=GifWEk99uhITp8A/jJEDLSMT3WbCrn/6bAFKstPuofM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G2tB2fdExFb7sbkAoRfPWk4wZSjG0K6kN5mV761HCyXa1bry1uz8leHbgu4QQIFMe
	 he6yK6j3Yml7MtOH94yw9LZPtFm9dMFk8TDIj/uW2k063cXvEO0Gzko9h7UosXXiTd
	 AcT3QZRPzOlgh5hOtWEWUMnq6hCubRrPVjtGKJo+pccaS2EN4ROR0dMT2ICvfCw0ay
	 P0khmVKB1pESPpoeekKNVzp0UYb1CBycBVinj39UDD4LdejFY33s/f6crrE8Tq/Sim
	 8mfidf1z7shlLQScb0TrJtMVUe3eCLTZaPO/uwdfi+rgeCKvGqBnLCYY7NYjcQmObG
	 rqrJxrwgkU48A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 7/9] arm64: Block hibernate and kexec while RMM is
 active
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260929221623.1342076-8-suzuki.poulose@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-8-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 22:26:39 +0000
Message-Id: <20260929222639.997731F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] arm64: hibernation resume blind copy triggers GPF when RMM is acti=
ve
--

commit cd33ba7dfabdc9882b5491e3f0d6693b247f8326
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

arm64: Block hibernate and kexec while RMM is active

RMM can be deactivated only after all delegated granules have been
reclaimed. If a new kernel is entered while any granules remain in the
Realm PAS, accesses to that memory can raise a Granule Protection Fault
and be fatal to the new kernel.

> diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
> index 424291c547f02..253f544a59731 100644
> --- a/arch/arm64/kernel/hibernate.c
> +++ b/arch/arm64/kernel/hibernate.c

[ ... ]

> @@ -341,6 +342,11 @@ int swsusp_arch_suspend(void)
>  		return -EBUSY;
>  	}
> =20
> +	if (is_rmm_active()) {
> +		pr_err("Can't hibernate: RMM is active.\n");
> +		return -EBUSY;
> +	}
> +

[Severity: High]
While this successfully prevents saving a hibernation image, is there a mis=
sing
check in the resume path, specifically arch_hibernation_header_restore() in
arch/arm64/kernel/hibernate.c?

If a hibernation image is present on disk (e.g., from a prior boot with RMM
disabled, but with a matching uts_version), subsys_initcall(arm64_init_rmi)
activates RMM and delegates memory to the Realm PAS early in boot.

Later, late_initcall_sync(software_resume_initcall) restores the image.
Because arch_hibernation_header_restore() lacks an is_rmm_active() check,
the image is accepted. The low-level resume path swsusp_arch_resume() then
blindly overwrites physical memory with the saved image.

Without an upstream guard during resume, won't this overwrite newly delegat=
ed
Realm PAS memory, triggering a fatal Granule Protection Fault?

>  	flags =3D local_daif_save();
> =20
>  	if (__cpu_suspend_enter(&state)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929221623.1342=
076-1-suzuki.poulose@arm.com?part=3D7
