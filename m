Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC274825B0;
	Thu, 24 Sep 2026 17:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272030; cv=none; b=tzcC0M29oJ39y4ZoTL0bNy1qZMvA8mMz47vb/QgKeND4d8vYbRDirw8N3Y4pukLnT+RykZtebrV3CrDnBScnoYFmCxhaSEkYN3uDOGhDCa8wADrzK2Y4LPQtVBjLLiW0tRNDPi5JBm3kwUWTuKIsr9q+dOB6OI46X9BkUG91pJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272030; c=relaxed/simple;
	bh=xXrkhaA5rjueeVw9ekS8DUw1Fe1cW/LL+7wh1JDdWko=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kt6unOd3SB7999OUQILlON244Mr8RTwo9mIW8tQaqkz6qeHCBmQYaCxHiHlXLmO+8T3RdeCiwQ3G8Bq1UjERW8UPqO9NJ1FFEF25U2AiURy33XmDB3eKNXkvGz0k59mxKSmwvkIIsoWNn3Va1mnhWrwvQ8hyBFOnZlfgw49kVeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MAQd6Qz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAQd6Qz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2991F000FF;
	Thu, 24 Sep 2026 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272029;
	bh=xXrkhaA5rjueeVw9ekS8DUw1Fe1cW/LL+7wh1JDdWko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MAQd6Qz91IB7G4qkjQZHW2vaJOlBs8akldXjQVbAYsLrOoOXRvkpHkP5bsAqAXpcC
	 Ryw1P9MnL0GWTnpVuCgISGAfXIOhF7dj/NQzq0ncXa7EmWc2eZEuehcC+h1je377jV
	 vTPzYyuJPE90H9VXqGqRKSzOoVpXJpmMWo5zri0splkkw/fZCSlKPWIwy19spMgzlK
	 s8WVNqsUkT6Sg12L8L79s6nwBZlMYQJNeG44NJhlX4goNI+iG7tUv7tQVybC/4iBUG
	 xxfEDcBIMEdUFXiB53S972fpQEqqzm2GHeXt+RO2sTyameIxJiuf4rNfp3XuHoQSfh
	 pKuMQra9z6AkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 13/22] KVM: arm64: Enforce PMU event filter at
 vcpu_load()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260924172928.2110956-14-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-14-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:47:08 +0000
Message-Id: <20260924174708.AA2991F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> The KVM API for event filtering says that counters do not count when
> blocked by the event filter. To enforce that, the event filter must be
> rechecked on every load since it might have changed since the last
> time the guest wrote a value. If the event is filtered, exclude
> counting at all exception levels before writing the hardware.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D13

