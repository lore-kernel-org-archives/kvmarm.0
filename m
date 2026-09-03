Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929AC4EBAD0;
	Thu,  3 Sep 2026 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451904; cv=none; b=o17uyM5NcKfKhDIByqc+4dHORKJqAsXcGh6N0z6LAswfnAQlaZpZJ1KLKUje1+Y7J7A7NkWBu3/8QUcQTKSpL9RScrYjasxWdDo9q+qPoEeLLcfcmluKXAuTeuUMZveSQDKzyrPrzmoyXxUr5DkaTHHSy/2Qfo/CvVNU3mQp1cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451904; c=relaxed/simple;
	bh=JPBzb+Eu+5h7idQxnV8cugdXmoUMgDNZ2DvvVYZ4FjA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TeaQSw0keKQtunztqbhkz4LwPpIu8MGJRhDezookMVRCfem86FO0Y/RiJH2w9exvQ2/Z3GAQo7Rv2Sy00P3SedZhXRukKKMBViGTLaZmUR4/o7/N/gYk8kAaOXC/nYwrhkitWIMjF9dcD4BCQPmGzzjQsiCjGR1HVucpn0onhtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMZX7nEq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMZX7nEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F351F000E9;
	Thu,  3 Sep 2026 16:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451903;
	bh=JPBzb+Eu+5h7idQxnV8cugdXmoUMgDNZ2DvvVYZ4FjA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hMZX7nEqu0b6r576k/U1bUXtTfBnmYRh9PCSY6DVHIrQebI0RK0p/cKBDx/m8M3h2
	 SlODRBbccVSyuDhQU/ipu5vMvBcdFVEnrUvKq23K8fjUE+KOt1MTgo3eJM9PI5QR4I
	 oa1+PkuhDUo8rl3i+ZROn2bKIez4UyEiBtMh95Vq5H/NyiieP1JqhZ/R1NvoZEU9jR
	 bSVcHsukW57uAejMa/iAn1+MgQi2N1gJvgShJaXWNUTrVNpCG5QddwXxc0C52Z7AhQ
	 93poxPO6B8Zq9hdrxuPsGp6DhjYWkilsCtCp4Ahvzl8E7j/7xUDmPJLTR0Db13QI6f
	 KLW5t8HRX57uw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 05/28] perf: arm_spe_pmu: Add PMBIDR_EL1 and
 PMSIDR_EL1 to struct arm_spe_pmu
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-6-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-6-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:11:42 +0000
Message-Id: <20260903161143.41F351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D5

