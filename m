Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB804E8DFB;
	Thu,  3 Sep 2026 16:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452910; cv=none; b=Y7rlJ8Zf1UJU/NXwNlv6COrDYFDAPVm+jNyAlz4/YRk2X1Wq0BtiWx8oLw9vofDhtOClgTuashcTRCqttABpPGXQKziZiqmo8v25huBWBqw2mJU7Q7EvA7ymVOu2Je1si7GYVopjdpMMfQv+l1cCwGNePZTBaZPovO+AhTo7inE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452910; c=relaxed/simple;
	bh=tMiFLWS7zotUyA7e3OhsRTtZBhfdNMNfC3iOYg7ZPDM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PNSGGsqVeU7UwmN75KnkEsAV0a5ODBuGka7vMHbWFvaLLNru0POnvsGf7tPDWCtB1auJAVffhVKSwjoArKtk7tljMNSWUHT8GAVjqS2qVUeoH9LJxnFvGEj9yvVb7PNQ7kdMJR2ewgCNFn/qg2Jem7E0WRUOMpqcwQQa10Vs604=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsyN7dnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsyN7dnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39ED51F000E9;
	Thu,  3 Sep 2026 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452909;
	bh=bz1QhiCOxrFKYsGE6iQ2RlB9mlXXrhdfEL3MCCmxvqg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BsyN7dnJy7Z4mAvYb1QtFlLslEdxwzSA20RevWPuOTmd+z+4LwAGtmcoAxel46nRR
	 89AblWjqV3pBY9aJg833acWnrT2IvvmBF4cwn9kgifBM8aSHRIfjWyiojwsBZRG0ce
	 wDd7GtiNMHVhTFivw074puqI8Zu9qLRKN8bLdTA/xirlZzniMxS8MwNCjNfRpDJfJF
	 eo4EiM10BTxzo2P/197cAp9i1F0mw1fRRZVMzk4aT26kxPzS9vETAyx/svtKuA/sJe
	 am/lkVnkgY3BlhiOt8duy5ysxO++GBjYLBLtdRyTTIqXocHiQucGhZ9elPzWZJ/AXC
	 PfKDaa4u126Sg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 14/28] KVM: arm64: Add SPE VCPU device attribute
 to initialize SPE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-15-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-15-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:28:28 +0000
Message-Id: <20260903162829.39ED51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_INIT) VCPU ioctl to initialize
> SPE. Initialization must be done exactly once for each VCPU.
>=20
> [ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
> 	   for SPE" ]
>=20
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D14

