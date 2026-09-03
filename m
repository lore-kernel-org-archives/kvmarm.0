Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB9B37F010;
	Thu,  3 Sep 2026 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452503; cv=none; b=UTGni8N0Rj0L3K7VEPh8hRxXiieXTbL4hvBR9zTaCAv+NzV6y5VyY+fihuBSendwKfWuUgXtMONZs769vGJv+jsSnslpPScaMk9DVtJU1/6TzZTfKf/63nNMjQyiVjElPSGB5PpHbmnqgWZDvZFdu5iLTpjoL8C+PEz+5+3i/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452503; c=relaxed/simple;
	bh=pPcUGgV2Ry3T9E8QWBJeiLWBQda9ibuPF6TSauJOinU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uRqMesKlXmu++l8p2hEj39llU+7vGnda4o2MHQpxJdyfysuiLLqzr3JGTkLE8re2VzFV+ntZfnX8ZjgidVT1DXQ/+lCfJgLSRs6+IveKJ86mk3RPdax6wmof0Ufvy+gvLgD6BNM9+4krrt5dOBO+LUnKRVfWc3Ubr1nknVj9uNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jON0f+3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jON0f+3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AB01F000E9;
	Thu,  3 Sep 2026 16:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452502;
	bh=pPcUGgV2Ry3T9E8QWBJeiLWBQda9ibuPF6TSauJOinU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jON0f+3Tipr7erCDIsyfQK7Pln84/Zba55PgWDFSFMFT9mwXaPVRfLzh9FKyk6OI7
	 aEaCjmZDEE/ST1GdfQYeHr31alRvX+HtuGhj9Q3u3P3U6HpFnjNgQDBarbxV8mzSrO
	 I3NVYgVO3QpsB9ERegWf5rwUQl62dMYcPUOk490P7H1U/33nqQiDVle4SDx2gi4FGA
	 yRTSNt4kOheyBuZz7yP0i1/k+mtVTmqifFZ9bldXVi+lra+rB1HFDSmLASBF3a9t+A
	 wkuUPN+ilSGFTfZzQHMoNxcCtZQXHIRPAUwNswLt1EEGt+TJAVRr1A3Q7Wr+eR9OG3
	 fN2upoTZ5Yp2A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 07/28] KVM: arm64: Add KVM_ARM_VCPU_SPE VCPU
 feature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-8-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-8-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:21:41 +0000
Message-Id: <20260903162142.60AB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Add a new VCPU feature that enables SPE virtualization when set by
> userspace. KVM_VCPU_MAX_FEATURE will be bumped and the feature will
> become selectable by userspace once SPE support in KVM is implemented.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D7

