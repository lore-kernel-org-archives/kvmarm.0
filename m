Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5F925CC79;
	Thu,  3 Sep 2026 02:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788403475; cv=none; b=rgRrV94nH7oscGgUCZ2rtDK7LFqSoDvKvYMFZxgPijY61EJrp/wCBaIO2HiIY7esqzwPvgUA63xkvWuScLEkxUjylOUsBeRPgcLXVemdiL16lcSbe3h2YiyMpKkqqdXpQ7IHNqeiLMcLn2B9N00JCflnbfCkw4axqASShu5wkAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788403475; c=relaxed/simple;
	bh=e4XcYUU1OBhFO+5ug+Lhg2ymw0As/lJkv3jbbuyW9gA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m7i2t5V8kwFLPX2FUjwLJhyr+TFtYZ2erEYSI2Ftn1fa9l8VHWb1mJ+WV/RlsF73kbF4CXYrlESHOQ0Mhq8cPBAfINkbx0Z8lGcgm6VvtR3VQ8TBAT7yEqZhVwZH8xYG+A+n/2goFkgJ5y8cyju81qTEB2SPyhhXDuRGzkwLqjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMww8CsS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMww8CsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB761F000E9;
	Thu,  3 Sep 2026 02:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788403474;
	bh=e4XcYUU1OBhFO+5ug+Lhg2ymw0As/lJkv3jbbuyW9gA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YMww8CsSkF0RnHmxIsb72YDZ0VXXQuSH8dilg/AsgH6tIgMzqunAH+FSG8JkFHI7Y
	 BVxuX62UxCxlT+SRyk21S3oTYMD9Nustjpn+O0wNmgx9WtzVqTMz++jLgwFFI9RvmR
	 BeopMr439Yq+XCVm1ExuE15ZtzTpEHUnHqL6/f9HRUfQfmrZk3wcuhdWagQJgn7abG
	 FxxvSwaKtehTjHrj92BGEkCLsmSFE53JTju2gr2BFo6a3q5kpkODTPQXeu7q/TknCq
	 Blq259wnsvQ1dKBa7aZSHEEyARH9EDtayk69q6stDNzA58uZYDKjwJ3T74m1dV56r8
	 ES7AMCiaq9KqA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/3] luo: Export feature support to vmlinux section
Reply-To: sashiko-reviews@lists.linux.dev
To: "Logan Odell" <loganodell@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260903023452.721732-3-loganodell@google.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260903023452.721732-3-loganodell@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 02:44:33 +0000
Message-Id: <20260903024433.ABB761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Create a liveupdate_features section that contains the feature
> information for a given liveupdate component. Add the LUO component
> first. These can be compared between two kernels to determine live
> update compatibility. Features marked as required in the running kernel
> will need to have that feature marked as supported in the next kernel to
> be eligible for compatibility.
>=20
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Logan Odell <loganodell@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903023452.7217=
32-1-loganodell@google.com?part=3D2

