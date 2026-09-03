Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F392A4E3EEF;
	Thu,  3 Sep 2026 16:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452510; cv=none; b=Du5mpdtAb64l1WF7zNfq0kI9krtDVpWX3YEFCc0L0zf85R9fkEsuYIe78A9npRze2OMV+KI+IKzdN/Z7qirN5gsQz7RmF3EGQKyWJFZg3OCpplove7ZYI/6P2fy/Nrd+UrTzbSsMx7tTR3MwYDXdd8qUA4M5Kkx5vbulYiGUbZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452510; c=relaxed/simple;
	bh=hks9FRbIv30Xm03Z/gni8eF8K08ohDqyg29bsz+xK/0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E4tYc9/tvIdWXcPNqA9ZMnHLcgbU3VyF14Y9XCEnZee7vU+nvyALUV90teWj+Z/i2Q0aljSRSPXk5nrXfpjH9m++G/XuPS6tl3h2X+uZcP4axXW8nqNBk9aMHhq75SPICJUGKVyqATLtyVh1C3Kqc++azDRUYcZMYviCoLVGwGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fy+O8nZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fy+O8nZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5721F000E9;
	Thu,  3 Sep 2026 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452508;
	bh=hks9FRbIv30Xm03Z/gni8eF8K08ohDqyg29bsz+xK/0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fy+O8nZdGTbpfwKJfSj9H926W3x10RWkkhloA8oSogXVIrDwOem9V5vjczsRjB3tb
	 jbrjm8p62SAVRlkOWHCwnd/nOnaeLTUy9Rmkjfa9vBMUZBZhdquAR0lme/jTUaA7uC
	 NQvmFepQAVrDTTEgnPbyUjV0OuFGnvMNJQG5pWkbbFKOtbMB22LLYvv7tRq8Pvik7E
	 Buuup2bzEY3ij305HbCHa+yrDZSfYQfcVzT8cTvi+ee+qJL1SRyO/CS+pBCivyJGc0
	 ZjaDtOPaTVKKooKCEnPvFlx4SCP/8wo8JMahNEDNh9bB5ekTEsFb7nZjUu0kmJUp4r
	 NAPMRALBTIqhA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 08/28] HACK! KVM: arm64: Disable SPE
 virtualization if protected KVM is enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-9-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-9-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:21:47 +0000
Message-Id: <20260903162148.3D5721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> For RFC only.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D8

