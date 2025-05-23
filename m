Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADAE183CC3
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 11:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747998091; cv=none; b=q/QAEXvlVK2kArq0nRjgn18kp73IW1r2rYbfv1HPrxNy5sLGm+k4bgNaIcNqxBGqpSPsR3EQ/Rbh99nMjZV522bYQ9D5hq6Is1T/opTudrxYOWO6NdrXcB+LeR/IekvBCNGRzi5hNrCX+LztDFyGdMDOEjKHezDyU1V0jy6YAFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747998091; c=relaxed/simple;
	bh=9loMDs0wNC/4CPZhZBtMbb/MHaiUqpZY4NUO5J6p9hI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLbyiUjr1gqjdiUAC55HDdOQ2F/TQA5+aJ6mg3Ss5wPF4xfWg6d6e8lV8nMrZnjKSelliVLpx8NOJeNw/REW8XsM9Pkp6G5BSB874h6h2ojQx2YYMLMDt2qvEnLik+UmaZn00qIqNxMnALBDrKMOngpZoGrAxzMILqLI2DYmqP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azERMFUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azERMFUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CD4C4CEEA;
	Fri, 23 May 2025 11:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747998090;
	bh=9loMDs0wNC/4CPZhZBtMbb/MHaiUqpZY4NUO5J6p9hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azERMFURc2zj0S9nkfN3BwfhmkzPD2mjGXbz09oWMrdp45wveeRoLUdp3O+mfAOQ0
	 MoMuLbDm+erizFRZByCx3qmGuqOCeBHbEx+dOY16TvaeDOgF+EsZr80bQlYcI41OV1
	 ejYqdvD7UNgG1sel7m5mSOaUwlREkBMqNSsrS4WHra9moGxWdN0NkOP8iX+9QrJ+eW
	 0oL9RUrcMLeVHeYV6EKTIFgg6UhNfn8e+ShLjEfOKSG5E5SRdunFHbd+3463uQnYqq
	 sZPiSIAPv1XujFexFOFdMnJ8GbyWbV/hDfdGmbsZZ98miGy8h9W3QHgt5dbnEba/wZ
	 Z2APcVvApywiQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uIQ9Y-00HYcR-Kq;
	Fri, 23 May 2025 12:01:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Release faulted-in VNCR page from mmu_lock critical section
Date: Fri, 23 May 2025 12:01:13 +0100
Message-Id: <174799806251.145825.13963857244128795511.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250521110435.66273-1-maz@kernel.org>
References: <20250521110435.66273-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 21 May 2025 12:04:35 +0100, Marc Zyngier wrote:
> The conversion to kvm_release_faultin_page() missed the requirement
> for this to be called within a critical section with mmu_lock held
> for write. Move this call up to satisfy this requirement.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: nv: Release faulted-in VNCR page from mmu_lock critical section
      commit: 538fbac74019c13dac341b20fbcc1e96c9a8d01e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


