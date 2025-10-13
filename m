Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31891F419B
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 16:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374574; cv=none; b=fNnZDPC1seGvVC/oS2EKLIYTNaMJAtCR7mdpp/PnRXr4il9TD3a4W/dx7LM/x1giZ9d3qeupWg0UU4Kxl2Did3YNNgwXfe2ve7LzXYC7cbxNf5VTbrzyuv9ZEH3yJqN7c8Ywg3yagdW5iXILHXaQOOEN+vAm1Jt7wGD9ozbqUek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374574; c=relaxed/simple;
	bh=Q8nv5RFjETDPL0195E+lAabtYxsCp/2IIkKLrWhfXb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nfLJFxcwFraWH9ZkQqShhKUfHYFx+lXd6AdR4pfMJkNMVGA/aIEULZNWnMFrtwmmNtki3c7A1olyJn4kcrWnjfbH2ZoBkBHbDLKZI+u9A+uKdP47D8YZaDANa7BfWwYBiAWZo/eCIUCvEWrk3M45mH/W7TPQUqN+/IKyEA4F1IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hv6ucS/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hv6ucS/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44019C4CEE7;
	Mon, 13 Oct 2025 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760374574;
	bh=Q8nv5RFjETDPL0195E+lAabtYxsCp/2IIkKLrWhfXb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv6ucS/AMdmooVpZCN2Yati1S6HK0D/bzO0hJUpCsoOi97JRt4Q/TsX0xS+hdENYj
	 nBv1Gj2kc8JLsAtvDEAHORyQuB3EnfGfZa4vDngPxyYE8kq1iPVCYMzIVGVhMQKS8C
	 yYwAqj9cDvbIslOK16JORFVEY95gfEtbmg9Nj+8hhk3bzyZJ83wwNC4AsiNNF+omn/
	 6EShDGebBz8QVm+82LNeS4wqipLX9so0zTKYzyUJDFUGrSBFH9UyacNQfgcmoVdo5D
	 sh/Lk9gE8INudaGqnSHU/hSUHw2WMPbBudC54/UQraZH8jmHpawSPYQZPfR+5IXPcE
	 oOMPel2LB+7Ow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8LqG-0000000DaUm-0NVp;
	Mon, 13 Oct 2025 16:56:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Actually enable IRQs in vgic_lpi_stress
Date: Mon, 13 Oct 2025 17:56:09 +0100
Message-ID: <176037441177.969330.12140792562822777637.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007195254.260539-1-oliver.upton@linux.dev>
References: <20251007195254.260539-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 07 Oct 2025 12:52:55 -0700, Oliver Upton wrote:
> vgic_lpi_stress rather hilariously leaves IRQs disabled for the duration
> of the test. While the ITS translation of MSIs happens regardless of
> this, for completeness the guest should actually handle the LPIs.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: selftests: Actually enable IRQs in vgic_lpi_stress
      commit: d5e6310a0d996493b1af9f3eeec418350523388b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


