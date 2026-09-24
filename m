Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1974F4A92F3;
	Thu, 24 Sep 2026 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271457; cv=none; b=u+7/52q6hI5J5r4DrTNilFZhaaekjjYikQ/1TQscA3DYueKOPAfIbY5rO7/GkFwu20oZElCb+U4GLOg31WaHuVBzaLRPm5SmkICcVUdiqRuHkyWJze1fSfjymVtOZiJKNveBQbjKoYwCpaYoN0cVoTudTDxqqTapyhbQEM/pjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271457; c=relaxed/simple;
	bh=fh1tbF0hsd2HcuPinetYTKJ3SHhS/FonRek5HH4TdV4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BrzMU8aJWSCmADnAd5gC4yKBraXe7KvDcSDu6riOQn1OrY+MD/sToRlgqxVxswVmfAkXA3wz1C7E16POYXzRgtiIvaCob9lRArVUSWnCbwXAY/ne4+MbPKtkI7+u+tP/gmSCO2i+nkjeij48X8aDEbEBRwGEkwzkdfmMA45sxHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+K8u3V4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+K8u3V4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8AF1F000FF;
	Thu, 24 Sep 2026 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271455;
	bh=fh1tbF0hsd2HcuPinetYTKJ3SHhS/FonRek5HH4TdV4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a+K8u3V4WbwhWAVXHQF8IFvukQ0FOOIRaCuawCnFlcbMduApHiQk3cVjxVeCr4bdY
	 qdzc7gnT/nC9dyA0RyEnSo/Aya8/JBO0I0Mh5+GHrjaOPehuqmj3zOqmudXkhS17/o
	 mrL8Ur5SBu7urX3bjGS2KlNicpD5L3rA/1jdHenB+A6jWBJ/2ZRtv3nx3Iy0/1mJnq
	 Nb78Odcuvam5g26EEYNDMK73AM8NRNwR9dfaS7bS2X1dTE3ILrh7ZgKt3ITDC6+hXR
	 nFdsi+BZeLXzJdE4zSWNoPXWqgkFPeCvOXTVUoUBpdCPjNjhTXUNtvbhDCGAan7l6J
	 7cWaqr19vwauA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 07/22] perf: arm_pmuv3: Allocate counter indices from
 high to low
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260924172928.2110956-8-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-8-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:37:35 +0000
Message-Id: <20260924173735.6D8AF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> To minimize collisions between host and guest counters, allocate host
> counters from high to low. How the pivot HPMN is defined to partition
> the counters gives the guest the low index counters.
>=20
> Verify both the upper odd counter and lower even counter are present in
> cpuc->cntr_mask when allocating 64-bit chained events so that an odd
> HPMN boundary does not leak a guest counter into a host chained pair.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D7

