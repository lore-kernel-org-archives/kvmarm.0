Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016078;
	b=SjJq9ooQtNpjQWVCJ8CRumTJY+FvKzxT3vj6TqFgA+wbv5NppXIP8HcmDZ2zLkO7xOKP
	 j+chPo84vaq+koPKQlS/Hd7LzHzTnbWS38u9x4SiZIXUZK+Lw45UKaHDge4ru1krM0ouI
	 EBuloAyRbSDu0Jzu0swfTf7y8ECgwsgZPgKb8mptZakVvexRR34yAiiZyJpSDuC+rw9HD
	 XTfzIo8L2Zv1thf5MWWix9kOHfOcFFIe0wFQuW3q1ae1tPfSawDoBzh+qyYd/Ezzure0J
	 HEqcDm5Ir2JSCYWYLlxjEJF0JZmRGG4YUSHv5Ln9n8ivHk7j+qtr4KkPPNRMfU5NdVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016078;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=fbdx/tyG6sr3ZXv0KgiU+rkzEDWOUQychr08SSf5ASs=;
	b=P/kAzDSS3PZt4cGrLFxX/MmSZYQg2ywsdYrGQOlVYbtBUbfPYnfMvtcj3BuMQ2Z/xs7i
	 xTmrTZ88eV7uY3rC2YdMfu1mkvN/FMmwd3pEXGket1PMG233q3aRLqoTztTseVzwAf09T
	 7nQEmwY9/c8URs8i6R7Og0QOCvYHuMr00RtodwNRuXcMtVbs0/y3wDFqnzLvhkRu1MH+U
	 kQps/rz49KKK64+HbkLxEvy9c8jFuvi/2L6Cyti4ECzxTI+XiDrPAIRFcrZFHHIqt5OCs
	 TXvLrhIPuQVGKE37R3HRc7ywIhDoGSn+sOZolPNhCc1WfeuFMHUX4qlF3KE88U6H3qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HdKdZOPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943FC606A31D;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HdKdZOPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5491F031E1;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016078;
	bh=fbdx/tyG6sr3ZXv0KgiU+rkzEDWOUQychr08SSf5ASs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdKdZOPzrt2zSI4yLCro8FKLIh02ocfjtWDAX7xk+uWhfaO0pnXfmX1OEjgrVeTbe
	 FGXRHIfPqg/W9of+xNBrH+IUxQ9LSLAF0SbLMmAyAtQqdhJYNh3sxT9OM2s0DJcwta
	 xWD9kYim5Oqt1fHyhwxEBAzpjgTwM3si2FQ/v9BKuQEFJR0pAIGJOpLFmqtf+BI/me
	 Mtmyopcp3T2Ik/QX35qoA4qHoFkBLg2HJeGZq4bG3SJo73ZNxsFxsYal4p7kUoI/IM
	 hwZVLWy4Uc2pGRWiLNzzk7VuqwoxwjFecRXriELZc6tlw7ZlmRJ9AGNl9XtH6IuwAB
	 JjtGZwx1+f5CA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO8-00000007Fr6-2zYq;
	Mon, 26 Oct 2026 12:01:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com
Subject: Re: [PATCH v3 0/5] KVM: arm64: pKVM host hypercall and GICv5 CPU interface fixes
Date: Mon, 26 Oct 2026 12:01:01 +0000
Message-ID: <179301587186.2527370.13227763498570302748.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012161524.4016464-1-fuad.tabba@linux.dev>
References: <20261012161524.4016464-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, vdonnefort@google.com, qperret@google.com, Sascha.Bischoff@arm.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 12 Oct 2026 17:15:19 +0100, Fuad Tabba wrote:
> Changes since v2 [1]:
>   - Patch 4 now allows only GICv2 from EL1 and requires VHE for every
>     other CPU interface, instead of adding GICv5 to the VHE list. Same
>     behaviour; I kept Sascha's Reviewed-by. (Marc)
>   - Added Suzuki's Reviewed-by on patches 1-3.
> 
> Thanks Suzuki for the reviews.
> 
> [...]

Applied to fixes, thanks!

[1/5] KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
      commit: ecb6b43cd22245296d910cb392594c9e33691b87
[2/5] KVM: arm64: Reject the stage-2 flush hypercalls under pKVM
      commit: 121d74bee8cd81ce9212837db98ceaef2e530637
[3/5] KVM: arm64: Validate the host-provided vgic model in pKVM
      commit: fb77bb2a0ff253e6c370ec7dc1afa45b2ecd8d2e
[4/5] KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
      commit: cd38c10e191eb2c37b9904a6ffc3b6bf4d9c0c48
[5/5] KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch
      commit: 7ad25ad110608320348669488297e06ea8c72f85

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


