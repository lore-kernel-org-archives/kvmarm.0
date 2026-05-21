Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3757C2D0603;
	Thu, 21 May 2026 07:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779347233; cv=none; b=tkm0Bqm8ORd6EwxL2dZuqJg8EecuvZaHM+0cIJ//p3gI1ixvcOOUUs47K2ni/kPPFi4MLTYbAOr11/GoZvebcyFx2fbKFz6YRTuax8wYpD2QT3M+sH/O2GeKdCRNujDxotTPGnRZS3Q3bGwuCzRAQYywHQHwb3kicyucInQnT8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779347233; c=relaxed/simple;
	bh=HahHz0MdOjVCSyypqsPgbz+BvD05yQ5hGHQ3HBXl60U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmlnSF3ZxFCoBdXgHhBuCfVC1hMBnpAuhcFlIxempJeZ21d4d0KmshfLTbeLUGmfSGrmpNNgCscOB0OLlkiyIYJW4nphdhBdTVQx1dc30DwlkUF5Rl56Cgsx5pIBleFtbt9NrL1jcW1IYSz9QTKQRpCpy1VmyVRpwI7PRriRcKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmcjuivt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmcjuivt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81111F000E9;
	Thu, 21 May 2026 07:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779347231;
	bh=MWBYFbSSJIlyYLmg5yu4OD5TUCoM5PbmQ+anX61sM9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmcjuivtodEDwjJC8rUpA/6qgkf1lCqjqZTrLeWsfGt+ox6Shn4WkEajN6s0bpI/V
	 ujQUDq8LupgVqh9ZpnWDckk1RPiokkEfq9LKp9b33X9bvakp7akVCBQfpIxSKdDRFk
	 /GCIoGzH5V/GvhkUaLJOLlZi/gpdXiMKX9qWcucs28d+0e3kIL/TFsrkspPKCqCIqi
	 9zPUOgskBVEfyHl6iaVFWGMPLFMXSKVLGx2RjCg/Plym5u62Z73IVz+xeH3xlieHap
	 VSAx8mDje3YXlvUG7hksnbRzO/UncZ8YJZt99F3+mb2C5AU8X5w8LYqV7mS0ETLOzz
	 71WBx1ys+8wqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPxUr-00000004h5X-0uwF;
	Thu, 21 May 2026 07:07:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: nv: Reduce FP/SVE overhead on exception/exception return
Date: Thu, 21 May 2026 08:07:06 +0100
Message-ID: <177934721772.554248.3495223802015312407.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520085036.541666-1-maz@kernel.org>
References: <20260520085036.541666-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, mark.rutland@arm.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 20 May 2026 09:50:34 +0100, Marc Zyngier wrote:
> This is the second version of this short series optimising away a lot
> of unnecessary FPSIMD/SVE context switch with NV.
> 
> * From v1 [1]:
> 
>   - New commit message on patch #2 (Mark)
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: nv: Track L2 to L1 exception emulation
      commit: 27ae400e6e888153ded1ad807a94a94e506dd2df
[2/2] KVM: arm64: nv: Don't save/restore FP register during a nested ERET or exception
      commit: 435c466196148ae116f616e6cda97c33281defc2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


