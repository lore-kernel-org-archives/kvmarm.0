Received: from mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9473FD955
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096706; cv=none; b=J33ix20RMvMtR2FmvKQ1cj1eiUlAy2HyjP7J4DgJpEie4Pue3CpHPZT+8pGLWpZSzrqtHe8DQsq0AMDbhL1KL7ZEx8w55kuoQeQb6iAoIxMRX8Y0Tv0JC2pjqSqTxcTxTP/KuAb/jgrEKAOE4djuvWTaNP2hs1NyWKEjfT2pfuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096706; c=relaxed/simple;
	bh=Y0RaZjhg7p918DG4B83V3Lyvof2PLvieks4Sm8hX9pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZrAExRvZA9Bim+UlAC4tzoC0+kwv+Jb1S7H5SKpKiX2elwJx1T4Sd4zLJH8GYrrWxHnxv2PskrywhfFLT2pVvK1Y+HuhvuOQKEdT77Wy3E89HhTiwVfCyXl8SRFl9xwvdB6dJfa2w5TGwqf3nitOSlPFaojydohNx3Y+6fJxJf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h93VQnMq; arc=none smtp.client-ip=95.215.58.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h93VQnMq"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Y0RaZjhg7p918DG4B83V3Lyvof2PLvieks4Sm8hX9pg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790096702; v=1; x=1790701502;
 b=h93VQnMqqSdogkSW7EqkkRsk3uxkx23YeJc4jSptg6s4nRqntm4xlaVXqJku/323A0EPtUli
 KU+E8yF8Bk7FwTSyY95nNyxN5E8dlonOSajlUtPOfm/4rG7N5uI5GM8V5pw2jBnikpaudh6Tmgj
 4mNaAU2pu1VxrMCDCeIhDv0I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 405ad137f488e4a9;
	Tue, 22 Sep 2026 17:05:01 +0000
X-Mizu-Trace-ID: 405ad137f488e4a9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Yuchao Zhang <ndaugoing@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 0/1] KVM: arm64: vgic: Drop last_lr_irq and serialize overflow EOI replay
Date: Tue, 22 Sep 2026 18:05:00 +0100
Message-Id: <20260922170500.3210708-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <87bj9r4h9z.wl-maz@kernel.org>
References: <20260918040214.85580-1-ndaugoing@gmail.com> <20260920014911.58616-1-ndaugoing@gmail.com> <87bj9r4h9z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Mon, 21 Sep 2026 00:47:20 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> I only boot tested a small nested guest (L1 + L2) with lockdep on my
> laptop, and nothing caught fire. Please give it a go.

FWIW, looks good to me. Tested on QEMU (VHE and nVHE hosts, KASAN and
lockdep on) and on an M4 (pKVM nVHE host on Apple's nested virt): the
pKVM guest boots are fine and Yuchao's selftest passes, though the
selftest passes on plain rc3 as well, so it doesn't exercise the fix
yet. I'll reply on the selftest thread with why.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

