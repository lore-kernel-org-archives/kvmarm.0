Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F384EA378;
	Thu,  3 Sep 2026 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452453; cv=none; b=rF+CcqajJoUC4GwOUZoXKXSsiJ3Cxk61ZeXnskcqvsRO7npgvzwMIIG+wkaYiqS9O0iEAIcI5bKtO6EDIJt9MpQtT5dhq45LDlpLOzcO0HDfcPUgst2novkrZ7XaBRZqifADz5BRj5UJnC+Uq/yvPDBE+NjodVatWbgYBNr2K9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452453; c=relaxed/simple;
	bh=9pwDyTc+1PYuW/7TMSpEGmRPiZyaYOCYIj2FzNf96S0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qmIL8fSibp3Ro7LlzTRDB9M8VUHqNc6p0IiuSABKX65cA+sYRf4aXJ5GAFlbZrnkuEkrUDvnGnTLd61rwosTsHuSeNcQpEx7odMuMhUpYAm/ViUnwSpk6pqzms/iUtheCqPIrZ3wNekRis/pFUbzbLT1UW0mCOAwwpRV7Kacy34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AppEbzRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AppEbzRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF6D1F00A3D;
	Thu,  3 Sep 2026 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452451;
	bh=9pwDyTc+1PYuW/7TMSpEGmRPiZyaYOCYIj2FzNf96S0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AppEbzRyTh297N0+Eq0LqhWtyexki+mJF3u/n3oPT8XRwwpHvRoRzI7ryA08/akLa
	 I/JQ/eM+4Q+xFWM1GIzI5e68/wT2Es3lSud6oa0apsO9nfizSnwp3AwfomlqPBp5Mt
	 5G0zlfKZns+Aq+s6NdLSLcmgOTcrlYsNwmSvlyk4C+IMgSH+aZwmqLMyww2YhHzvVI
	 pIADQ4ReZ/mWRpNpCINOYpkSO23Y4GmCOVLzqmUytfNudhXDQ+5gmlC9c6kQFfqfxB
	 TAj0rJRsBsn1ZA+LdP8k++a0Df/wN8V0BvllB05XGQhzUHg+xClrMMzZZ859hZTab9
	 222oaV2aOAWng==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 10/28] HACK! KVM: arm64: Disable SPE
 virtualization if nested virt is enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260903160623.315525-11-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-11-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:20:51 +0000
Message-Id: <20260903162051.8FF6D1F00A3D@smtp.kernel.org>
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
25-1-alexandru.elisei@arm.com?part=3D10

