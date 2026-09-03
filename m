Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6724EBAF8;
	Thu,  3 Sep 2026 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452864; cv=none; b=ihTyjXh9cfM5c3SXuZ59XaznCf59x+VLTpSiArpWMCxNDFhT+5WP96HG37AcuCXT1BH+U448FYKhKB+4TnVu104eoyzvD9b6KHYtr5SAk5DxUfZIxtvZ7nN0LWHLR29LIc8lNrf7L0q1fVf3v6F2qIgpVbN3Ael13feL6S97jZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452864; c=relaxed/simple;
	bh=UWsMXyzA57zA4c3NuBy9HDpr84Pe+xKBKCZ3nBSTOWk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IIt3s4bxjjx0q9pZfEzynX1gceBoTBLQEAKsTaxzC865PQlb3eOp4R6jFYG9qedbAjnrlxRWJyS+hGL6JHUgVypUSZ8cFkJIZGK810auKyencd1HoGf1/BVnhMDBaVVeYIzwuRwvz17CeSgDaoXDVEajv3j8PlvGTTrkXU9D2NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUkTyJiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUkTyJiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F186F1F000E9;
	Thu,  3 Sep 2026 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452863;
	bh=rtxmrwICn4CkJd2Q8/sG14csQVURO1v0jr+pnzRcZr8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HUkTyJiYX4JUwofXE3aSTyO5jJNnd6Fh/hqQTEdJGp8VMS2a1W3nIdgMvlLpv+blG
	 bPuDfovFK0dqWSALNnqo8rkdiAYBHswfs6fqaAIK6ojHpb3+aJMPzSN1yAA5HMlImu
	 G6500y5eRTIx8q687xnM5AMOjBHIHEsDjdpdH1A5uUMluWHMYGasuoHU2JktupRnDK
	 +RUkyuWT14M1Ti/uYHE5LR/6ch9bI6erL/0tDtp9mu6vxuBp2H8QTp6BSGRgsP9uYt
	 XdhmKqL5Yxh6q5WjhbHOZuLaMjmOBsbAfkO/LSw/1Y1EnUy3EjCwH0XOJYCTFp7tvV
	 K/hY0GsvfWEyA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 12/28] KVM: arm64: Add SPE VCPU device attribute
 to set the interrupt number
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260903160623.315525-13-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-13-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:27:42 +0000
Message-Id: <20260903162742.F186F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> From: Sudeep Holla <sudeep.holla@arm.com>
>=20
> Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_IRQ) to allow the user to set
> the interrupt number for the buffer management interrupt.
>=20
> [ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
>                for SPE" ]
>=20
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D12

