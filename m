Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA2D4CB8BA;
	Thu, 24 Sep 2026 17:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271999; cv=none; b=r6t9Nk/oKNRlSdF8Zx0KxnNJkN9EJFiOrH93y5wr5pA7d7WVeOFztDmHqFhWPG7I4piy+rBf0nUChE64YvDejMZX8g3hmN1SLXTGg9u4WMpYYrzyFegf5y0UJ2Ytyru0lwaMf61u2BeREsua2ctGhcypIa6QTukbbwL534DH8DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271999; c=relaxed/simple;
	bh=Ga3PiptYKuwSfrJaVtkqweXp7roGOJuhRji+dT5OsOo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=spG3uMv84xnN9t9pBM2P0cAJ7thekK1cjONO2J/0sWiy1bHxEtmgua2k/nL6qTgONftAdA/2LSFgSKH+ITHSWmGU1Bwcd3xeE2hhMJ02s2Tg6QPct8mkFyRgX8dnQ/iYSIOenGD+rAlxBn1gRUSpfngAUMfCoFEbOGqV+v+Sje8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6B/HPin; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6B/HPin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8EB1F000FF;
	Thu, 24 Sep 2026 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271997;
	bh=Ga3PiptYKuwSfrJaVtkqweXp7roGOJuhRji+dT5OsOo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m6B/HPinevYMdzwN8Gw0EGcbG3cvLZ6iDfh+KtnBmZSbOUCdb6K0aziider3hIyr9
	 Q+nakoYUseTr7f1MEexT/2MxtkJdb7mD+3lgb2TzME9gNBD/hHrFZ9ET5BTaAj758N
	 K9tNhMSobYmo8b3ncLzSIigr7hXZ9YOdzIuDneRvBXzPCea6ohjWGz09V5B+WO04EM
	 iV4wfshJHjGKfANfQ8a8YfoSw6vzyK8RTsIfqzRLRvnm9i4pFxkGNTsVQ42nht+Nap
	 d5oLPwXA2v6pQEJ1bPYW6hf9CpnTKXwbjkHb+jtH2mfRFQp4YHbG9rz35Ws/XnNu70
	 Y4JLRXkpQZDog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 14/22] perf: Add perf_pmu_resched_update()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org
In-Reply-To: <20260924172928.2110956-15-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-15-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:46:36 +0000
Message-Id: <20260924174637.6A8EB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> To modify PMU guest counter reservations dynamically, the per-CPU
> available counter mask must be updated while host perf events are
> temporarily scheduled out.
>=20
> Introduce perf_pmu_resched_update() to update PMU state while holding
> cpuctx->ctx.lock in between scheduling perf events out and scheduling
> them back in. It accepts a callback invoked between ctx_sched_out() and
> perf_event_sched_in(), accomplishing atomic counter mask updates with
> minimal perf API expansion.
>=20
> Refactor ctx_resched() into __ctx_resched() to invoke the callback at
> the appropriate point.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D14

