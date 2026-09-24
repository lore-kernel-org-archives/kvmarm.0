Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB73377AB2;
	Thu, 24 Sep 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271497; cv=none; b=umnc1lABrn6gLVXfzn53uz8VDhvBOwSq+7yQWvLthnaYDnNbMT4UvuPE9v7ORaapkgtDaIsugVbJph0SF0xZ1wFTzNDEskTqMtoB9X3ECoKavfNQ0uRzw5lr17qFUGHj3Mhjdbp/3S9Ef1gwC6Kdfii1p+H/VvLcZ1I84MEir0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271497; c=relaxed/simple;
	bh=hvJfNWQg2GSQkjWgcv4bo24mpWxcpMsvHly/toHv+i4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ca28ww+jXNtxa04ABwdLAmBfAQhdYI+d4De5H3iVjbL/w88Haacj0KMUJULYJ+PckRAx1KthoVd6BWWRJj4x95r/wbKWdnpWN4RAu8Ynb6G1mptHvtX+HsE/Etwtdlzhy+HFhX8LiMnxPt3W5nlfYIW/VN7wQQN4NzwNozPej90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfeZsmRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfeZsmRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EB71F000FF;
	Thu, 24 Sep 2026 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271496;
	bh=hvJfNWQg2GSQkjWgcv4bo24mpWxcpMsvHly/toHv+i4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bfeZsmRNelVd487/PBLG4Zg8MbtoVimXCPeY4KxmAq3+1stwAnI6FP1RT6e3XZLc4
	 leItYf+CUO5SMdf0QjKUYviX8p5UhdhXpZMkplIgcjftiLBf1zU/FN53OnQs+G1yI8
	 sa806Alk+NQJ0JBbjTqu0is3T67gMbjKqNs3q2oXBogu9YdLYTFlNycSt6CRucbsiy
	 Aj1g3UvMlOosQW13R1UUhkDheDrW73CUNduI7WsBt10VstOB4ZRmOaAepDOztVkXwI
	 jArxMWuYkbJmH8OpAK45Uffdgv7IFsXN24O6HcmnjDtzOwqzXyWSqYmApgsPhbLxM5
	 A08jl0Az7aQnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 06/22] perf: arm_pmuv3: Check cntr_mask before using
 pmccntr
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260924172928.2110956-7-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-7-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:38:15 +0000
Message-Id: <20260924173816.68EB71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> When the PMU is partitioned, PMCCNTR_EL0 is reserved for the guest and
> removed from cpuc->cntr_mask. Move the PMCCNTR_EL0 availability checks
> (cpuc->cntr_mask and cpuc->used_mask) into armv8pmu_can_use_pmccntr()
> and un-nest the 64-bit user-access fallback check in
> armv8pmu_get_event_idx() so host CPU_CYCLES events fall back to
> general-purpose event counters when PMCCNTR_EL0 is unavailable.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D6

