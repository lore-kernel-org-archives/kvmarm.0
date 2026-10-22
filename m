Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690695;
	b=t66XYyRfDymNfscBy1/ykoWXbD0IwoduJF2tY1M3IXmZBKzK35QmMp0G5NjjGgRzevmy
	 YoMfw/gP6O81JoiscVe7FqJcTUw9/BJAzvDXRxuV4xn6wyHIVI+KvvIuRweslMlc5Lwb9
	 nohhN7vIRbPf7WA30GpY3oWCAeAqLIHuOgfqJh+6MvNH2p3Kn60+I2dxOsRioxS0BZjpY
	 nLe1x8Vay6+RIeRAuleRYfLpq5HX2eCjlb/qRKjbN3o+AkVTuhbmHXCGk001nFLbmKgNt
	 HTLlBCY4Mje+ojVaC0m3HwjmMHMQ9ONSbOrVMrKhr8OnRcU6/bWarKVp3TGarOcodDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690695;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=qp9j90rvNjQEHYpNnURle2G+so6ZY/ayC5ckMBJ47tw=;
	b=QlR2UGOGoy7GhlJ2zLO6QAPt5t2vTcThBz2UP5RVhoWIhE50CYILwx28N9yEJ1Bhe8y/
	 Ce9RrwixWA7/yzVqHorrejno1JRNE1zTSiBYP7nZ6e9RRbKFeN3k+H27oQjIpH6DU302o
	 yuP/eDbOMv4I2h2aTzXMgod0peVXnH6zZJaaAZbo/AOKZSJjbxjSa0QbmiJqy8GcX+s/7
	 +Xpl3wG9lsIWnKJhKHbnxoFixgGFka7FJD2g30fPOf0ZY0czr7mOXt739omGc0ksyjr56
	 3QvwooUVE6o0hmyeI180G2y8taWmnpXpVtf0F+lrJLr/LGgTkatO3K7IIqNjfzvQXpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=C2WdeDsy;
	arc=none smtp.remote-ip=91.218.175.69
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A682606A31B
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 17:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A682606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=C2WdeDsy
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qp9j90rvNjQEHYpNnURle2G+so6ZY/ayC5ckMBJ47tw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792690691; v=1; x=1793295491;
 b=C2WdeDsy/Q6QBr9Xyku5LDGL9KE4sGVWTRGNEc9gDyAjsYyZ4YUmhkHS88MsjykoVJX8Djca
 Gqa15OEkXcTAbl1j3yCpfYDKA+SMukdL022UmNe2NVngXAcx5trsyFP8HuV4HdiPygEIw71tv99
 p6BTAHIKPpfzJTsDz8/+5+2w=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b2080240adfd05ac;
	Thu, 22 Oct 2026 17:38:11 +0000
X-Mizu-Trace-ID: b2080240adfd05ac
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	tabba@google.com
Subject: Re: [PATCH v2 4/4] KVM: arm64: pkvm: Avoid trapping on HVC_RESET_VECTORS
Date: Thu, 22 Oct 2026 18:38:06 +0100
Message-ID: <20261022173806.3752938-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022140048.2522787-5-vdonnefort@google.com>
References: <20261022140048.2522787-1-vdonnefort@google.com> <20261022140048.2522787-5-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Vincent,

On Thu, 22 Oct 2026 15:00:48 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> pKVM prevents the reset of the hypervisor vector and as a consequence,
> kvm_hyp_initialized can never be reset. Add a fast-path for this case to
> skip unnecessary HVCs on the CPU hotplug and PM path.

Could you drop this patch? It brings back a pKVM check in the host code,
which Marc asked to avoid on v1 [1], to save one HVC that pKVM already
rejects.

Cheers,
/fuad

[1] https://lore.kernel.org/all/86jynbyshv.wl-maz@kernel.org/
