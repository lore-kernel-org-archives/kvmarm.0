Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4E74D8DAB;
	Thu,  3 Sep 2026 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452139; cv=none; b=CxFvfreN0Xt7DRj/xePFWbNahPLHgtqKP8zr3RQBO3XjZgE0kHtky1Xz3gD2jlq4BPwKhX3cvQQ50gbeLq9BbZlMWQJ3bMLO1Mvgwl6nOEmQgsbUOCGXz2wMytenzi852D8ZvGkgnTOlocHyXdR6wZPIgZ2yrfPCFMmirebp7CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452139; c=relaxed/simple;
	bh=0RbCMfm/BzCclRntct8ZPkcok89mZOnt2RT+7ZvDj4k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KiPWR5i72ijlegs34Z4J+NIvVbe7SVvc9/tGEecXxBL5bZ5QsDE/Rcl6fkeNJb007FNgPAO0+g5nwyOmcx+3P3uO7p8k90IKfnCgLkLKg9qGXZf6hdDU4POnNWUrYTG457qE1EsUQ4Ue488grkN7aOiEi+UCz8FKrq3wmdyEdoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Txwy73x+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Txwy73x+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CE01F000E9;
	Thu,  3 Sep 2026 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452138;
	bh=0RbCMfm/BzCclRntct8ZPkcok89mZOnt2RT+7ZvDj4k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Txwy73x+hv7F11RxzAQeexzxOW88Pei4rrZEes53ywRrOpQkreLIAQxYEIGXVj5zG
	 XO6pTAPZHS9niS19rCIt3lXA5U1w+jHYlZDN6Y4UojBTweOycTp1u5gGIDMp/8ScXf
	 Eyh9YJpr+LKrAVLjIbIBid/Gc4W19U4jR5+GfMC5FFZQucns3Z4QZeDQiKDvfeh5ow
	 433FBG6H9rguORa9m9TIrU2iyvwtOGCksLXsEn7b4wIRekJhPtbh876Tsc5Xf2jI+t
	 reVkfHxzLziPbLWvT87zUeg7II/W6p9ck6avwV64kDXU+ybu8Z/XxLjJ2v7at1wgtI
	 hLu+40KU1A65A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 09/28] HACK! KVM: arm64: Enable SPE
 virtualization only in VHE mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-10-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-10-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:15:37 +0000
Message-Id: <20260903161538.18CE01F000E9@smtp.kernel.org>
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
25-1-alexandru.elisei@arm.com?part=3D9

