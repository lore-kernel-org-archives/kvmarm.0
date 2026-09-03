Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FBD474271;
	Thu,  3 Sep 2026 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788455317; cv=none; b=GstkhTpMxCVimBAk8JcHJTDrENiV3hyhi+wY+EHCRtU3RxvlqQzw+XiiZhR1wLTKJAtrAM+mlCTdZ6Rl2IEe8A2l1fbjttrhRs9AcXYYOa41egLv52JtWzyKdQ5HkJ8KCe3oSoRA3mPe5lr2ewR5+Ae69SVr9Njw6gSw7Ut3Zoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788455317; c=relaxed/simple;
	bh=YvGeqQc0WoX2/w24cX+JATpHz3yM8STZ0sjrWeKLxVg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A4H73iaQHdfVcOfw0yJw3wk9pkEESkXESMN5UViY3cKsEhgoBZ/rAEVuBrfukqnvNBj0XfHoq+ymZq3n1k2Xz6zRc9i/T9FIxnRNM7RmgvvNZZe9ifCBwqbBq+X9LZ4tUcXFdZqVXQ3qXjmm3vYVTRSo7i+4ygxwyJoJAUqg7+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYSdfZM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYSdfZM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECFA1F000E9;
	Thu,  3 Sep 2026 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788455315;
	bh=YvGeqQc0WoX2/w24cX+JATpHz3yM8STZ0sjrWeKLxVg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jYSdfZM4dt3adnDRE+U7dkl47OHi56Tw0ySKrRgoZ+SZqU7mGfu9HImYcTofeXPyf
	 6GdtzCdC7kemw6QBgs7v4zUPGSBiul/olBL1vvKhc09kbxvGd+4QcKgIwRIR8rwYbP
	 3qALnayiEfSVSPWMwXgyR78t2K21S87GjolSs5dpz9aHkqYDjC6vnC9JTo/qVscyP6
	 FyEZCXBpgiJ0t5W8187MRE6ClqDR2cTwKjAbh3SaZSqV4CfSWW8jsBMr1qTKukCMd7
	 7PVfK7PxLP42OKSa7FvDZxdIruLSOAAFZQ8zMSJnFjIIIJ+RVky4Jd111gitOKCH0q
	 O5RJOOppT0dUw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 26/28] KVM: arm64: Map memory on a SPE stage 2
 fault
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260903160623.315525-27-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-27-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 17:08:34 +0000
Message-Id: <20260903170835.3ECFA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Make sure SPE in a guest can make progress even if something goes terribly
> wrong in KVM by mapping the memory on stage 2 fault SPE buffer management
> event.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D26

