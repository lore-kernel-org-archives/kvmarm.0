Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8354E2342;
	Thu,  3 Sep 2026 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452104; cv=none; b=pG0grv/okQrUSHFC1uzOncMFZZ5yRafKZnQ1c0L0hIYIR46sKm72k9DSRun+kELcrW6tZWOj2s/lJnp98Tda5eIZU0MqgXJuXWtfLajluDvnyAeAwOBfUyeLp4ZBunAdePSAPKtVtLdHOmQs9BOjXmPF9J5VUXmDumV0C+fNswo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452104; c=relaxed/simple;
	bh=WmwJ+SDNVLutFE/JE1oDvQJavyqxdbwL2Tw08T4DCr4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q55izH/r3KZEAaHu5G3PD8TyYAHLLZexzA7KIihTwznUa2JBLIdOHUqZF7fwr6YeY++2p5XeC1r8d++/bjGkxtOKe6b22QtZngFokk0acy00nYgjkbh14enOy3pofhgBeWSlYhfQT0DBZbb2ZlZ8Zy8Z55qdia0EAeUwE0OiC9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvFfr/Nr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvFfr/Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CE61F000E9;
	Thu,  3 Sep 2026 16:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452102;
	bh=WmwJ+SDNVLutFE/JE1oDvQJavyqxdbwL2Tw08T4DCr4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CvFfr/NrJY0pnQxFoe+PVQ/I7+3JTAiO6cYxem2mLRBqZjAncU7sHx9zvHwnQpLZX
	 t239fNfgbvmBFSIk3x39toAzOZLEFoK9uDajRo5pU4J3mWJkBuphONBuClmMnhPmKw
	 JCnNCHZy6IXDF4/mOqvayQhHqrII/JBT/oc8nCBm0Z/pKbwwSFDvNXS5ZoI0alZCHN
	 MHyfSv018eCorN0/VJpFDLAgccaK0k6w82jhhL3WUxEpuzaqZ3jEmFpAAXyx5zM2xz
	 GY3YmQdeT0oxfag8/2XnqPaAvnLy1LdsL1wFf/1HQduz4LEgU77mNK4uEjBM0ocfqK
	 DVnlQunoPMhWA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 06/28] KVM: arm64: Add KVM_CAP_ARM_SPE capability
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-7-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-7-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:15:01 +0000
Message-Id: <20260903161502.30CE61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Add the SPE capability that will be used by userspace to test if KVM
> supports SPE virtualization.
>=20
> The SPE driver supports heterogenous systems. Keep track of all the
> available Statistical Profiling Units (SPUs) in the system, because KVM
> will require the user to associate a VM with exactly one SPU.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D6

