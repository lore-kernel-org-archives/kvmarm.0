Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A914EBAC6;
	Thu,  3 Sep 2026 16:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452547; cv=none; b=JEY65GlUKXAuAAr6MzslQwa7eEasAT33SfzpWJZhi9+XDusMUTGV9CNUzkPrDWLMY+WEn3gTT2jRFrCe1kmG7/2yP9DTWPTs2Uugn1c5sSwaoEk/kmSlTZtZEML6sS7jDvpDIGuKx4O/iqRGVLYJJ/cD/O7afcVORJiu5Q797tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452547; c=relaxed/simple;
	bh=aWyQON4KB3A/SPlS0e2e6QZ1uILSfSvEZwN66cbMUJo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GWX1+IqYyfBTKzKjcSUGg0pxTU4rGD9nh0TZF2f5isQdnbPUEx5pXbo0Gd5NWb7hqtPeNNhYD7XTxBjUO6DaDL7WKvylG7yH2d1qwCXVX/8qI5nfn0v4Ld23e4OtieIY4U7aGXDyyLa5QKACToDglwXyYBAym7yB9hoK9yGbwOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mea9msPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mea9msPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41311F000E9;
	Thu,  3 Sep 2026 16:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452545;
	bh=aWyQON4KB3A/SPlS0e2e6QZ1uILSfSvEZwN66cbMUJo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mea9msPiRbaWFDi8FZSjKEu2VnrAlclSFfHw1V9u80eP7DqPaGDp2MCXo0FabJkPr
	 Mtx1q4xYUwpwhDCgC66m6LhWJizpJ0TzCeGW9N6XurxoUURnidPI4ZbI51E9Hnrewk
	 2I8rpBoh8NNGynUWzCGgJZPSrp2mvJKMDt1KurJ3nlxog1rL1PAXHKqyW2dwtq9d+Y
	 1GIG4Rz8FIRlICT6e+t5OtJMW8iUjloUotCJxmkBDqS+zlZwsnu/rm5QgGdBzuQWy4
	 fWtT3GasZfjI5cXrAKPPDfuFnoo/fRrcLbOjpBwBYBEZT86jMCkdpQgIOplrqr/wns
	 MVC7d81DLdEFA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 11/28] KVM: arm64: Add a new VCPU device control
 group for SPE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260903160623.315525-12-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-12-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:22:24 +0000
Message-Id: <20260903162224.C41311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> From: Sudeep Holla <sudeep.holla@arm.com>
>=20
> Add a new VCPU device control group to control various aspects of KVM's S=
PE
> emulation. Functionality will be added in later patches.
>=20
> [ Alexandru E: Major rework ]
>=20
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D11

