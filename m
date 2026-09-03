Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337DD411A17;
	Thu,  3 Sep 2026 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454308; cv=none; b=WEPKRE8XF96alXRrMpZ/gOvAmY8nlgtPgMxKg2ocbJnC2qhgog+m6iII1MSvaCqIUSv0qrcOw1pcoPg+yh3QVMJk2nRKuOMPQyoRm51N3QzuaW7g5xdN34BKlf7kQRaFxE09utg++UvZo063vWfq1lIZ34ZWDULyA9vOTo/m0fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454308; c=relaxed/simple;
	bh=rl0h5+qK1k32nVmN/r39pjsJ5xckB59CQmSJJSB2Nz4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nQcAHiOpgs34143cuvFyV/aR1+dwGIzjbdBIGON41dh1ocE5DfsFWpBSblwfbieBWUOthvqdZlbkFL5jP624XbKs9O6nHztNokwAmW4oelUnQIwL5X2f3O3ysvLleLm7T8f8JQkH2bUqO977HgHUg9pR6fUGzSNh85bLO56RB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqMveIcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqMveIcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724D91F000E9;
	Thu,  3 Sep 2026 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788454306;
	bh=rl0h5+qK1k32nVmN/r39pjsJ5xckB59CQmSJJSB2Nz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nqMveIcATg61lGOh2xwXVDE4Ija0L35p+mrzBu3L2bcZ7gaDqSuORJl/2+tIbloOi
	 lWBPAwC3HK+4fIkcX8eO3Z9FgEmNJqNmio0ZpDclIsKFqU2quBVLCeyTYlmdJFZNYR
	 CREduzpWaPdWmj8rUd821ZClkGm+avJinUuPDPVTyUyZYMy6x4nYDdsznmVwIcCp5o
	 g/hijpI1Wvu86i1KgfhkXJaS8AU61FiY+Tga2j6jzAsmGgB1I3SuOAOLCfBMM4taL5
	 U5MHNXkoME5lTiSkIAYdwEysAf/0HoaaZ/tgCXuqWxPM1qYegPtfUW9b5JmWJ2Ma5X
	 eV2pzEG0+vJHg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 25/28] KVM: arm64: at: Use callback for reading
 descriptor
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: linux-perf-users@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260903160623.315525-26-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-26-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:51:45 +0000
Message-Id: <20260903165146.724D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Allow callers of __kvm_translate_va() to use a custom function for reading
> the translation table descriptor from guest memory. This will be useful f=
or
> handling stage 2 faults reported by SPE, to map the stage 1 translation
> tables at stage 2.
>=20
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D25

