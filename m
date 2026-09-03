Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF43A47F2D3;
	Thu,  3 Sep 2026 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452098; cv=none; b=EHyNheoihyplOKTBDKPniPqvCeE+T4sH0hkLRIgOvVgLV0ZSWLcG1D1cQY60nKTjUsXdD71OBmOoqVVlU9TlRUYIOd0eVvZChJbm3NwLjMTproK4bLmi3WmlGHF0p7GPs1CQDdL0Q7j0gElvLR6bSposG38nVrUlb9OBz7h6rTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452098; c=relaxed/simple;
	bh=6g0aUSz4V1j1Z47nNX1viFK8Tmhk8NObSFGSk6Ilegk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hvj5f2KJrEHRQIf5PySTUGXCR70ombr2IQWiuj09byw8bok6ozM0mO0kT8ArE8TYU/8v/lel6QKk54t9FZ85BGI0SiBNocB61W8588iWYNDm7JAY8m0odYnh1BCVzTNaQOQmFT0A/XArYB1jsLmwJZaqDu9DspsTfh5JiM5DYlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGEoYOL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGEoYOL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D5C1F000E9;
	Thu,  3 Sep 2026 16:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452096;
	bh=6g0aUSz4V1j1Z47nNX1viFK8Tmhk8NObSFGSk6Ilegk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MGEoYOL0hklJw+5v/8lVuL01BRv5X8OYIDOBoSIYnpB8gcaFacTU5IWelcf9hAkh1
	 ZcXqpHiBUAKP4BEO4sBtyh8WAIwizwcoFTW6HRcuM8n9Gsy/eP6uAURyhPwyxq83RM
	 KIz3wGzbCoBlav9AoRBSNRehC+zG+VL7jQ+pdzVwTrrgSho3DzO1cvl6dt13yfkZoC
	 T2xHQeoSx/iIUM6SVkuKOr+mDh892jGpVhj/ZrQzMt/cyOH3AL5z5sqwAWdWmKLQLO
	 uI++2Kxo+Ea9tmRDtT/wawYrZLhHQrmtGrxkMsP96O3yKdnUnkSQmRgh42zD/Wjrz9
	 J4E1wLMveKBkA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 01/28] arm64/sysreg: Add the nVM field to
 PMBLIMITR_EL1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260903160623.315525-2-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:14:55 +0000
Message-Id: <20260903161456.51D5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Define PMBLIMITR_EL1.nVM, to be used by KVM.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D1

