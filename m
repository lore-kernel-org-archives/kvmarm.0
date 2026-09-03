Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1B137FF46;
	Thu,  3 Sep 2026 16:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453632; cv=none; b=XRTfzDqGrl4ta65cbGiIKiJ6Ub8USKG6tG09bFFKauoGQMEyMQyInlki54QVP6bYhzWNQwIlrdHomhyghBIeYhwcIzArjZeGrNJORK+mdZmtCw3Pws0w9KtIsGYDCEbxUWLarYEI5DSB+nhO/JuWzFwzuOX2ANED+AHd39VWDbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453632; c=relaxed/simple;
	bh=GdldnrqLP/YbcLWXrfaUBMuGPJ/8GZRm2uUadA1xplE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gYToini+2LrX8kxM94BXUK29GvmQmpsG1yp59jhV8KumYVpGz+WUv1A0NDhGqQSoFnOuxVormMKb48QwMMNK1Ax+z7j7Zd+KW8fdVPPZ1E+WGGi8r2X4UC+3w8tEwOWFC5n/ntz/A+iKZinmjdnruHko8LblZIRA6yUMjs0QE0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDbF8yhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDbF8yhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ADC1F000E9;
	Thu,  3 Sep 2026 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788453631;
	bh=GdldnrqLP/YbcLWXrfaUBMuGPJ/8GZRm2uUadA1xplE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FDbF8yhiP31tEPmSgmgjyxh/3985xrPyQrHbgLGxCfznUDudyncSbjytHRkYPq2Yy
	 briTbBxscTVeZ7Y5bC7toRBClmfze2tkpduCslXTRDXfiDMNsK7K8tMLvzGs4S1XEL
	 3J/WzNWX7Ng3C2NWEwyMZlCB7dbVS5OkLlIrHI+VDsiLYqZ7SuUmYuh60kyHdxmRBD
	 hn2sssL9qJovXcXO4Lj0/Ykwnl0nwcG+V5rrpROXQPujFy9EYfJklqTfwuIAsEHXgC
	 NElT2KVjRlTobD6lncc+6Ab/RPFkUhFVPQXiKi+e3yHwHwplisSmgudYHXTlD4oKoP
	 /mcrj+Ra1MrYQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 18/28] KVM: arm64: config: Use functions from
 spe.c to test FEAT_SPE_{FnE,FDS}
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260903160623.315525-19-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-19-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:40:30 +0000
Message-Id: <20260903164030.B5ADC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> KVM's FGU mechanism will trap the registers introduced by FEAT_SPE_FnE and
> FEAT_SPE_FDS if the feature is not present for the VM. Move the functions
> that check for the presence of these features out of config.c and into
> spe.c, since that's where the bulk of SPE virtualization lies.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D18

