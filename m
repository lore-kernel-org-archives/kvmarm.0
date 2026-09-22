Received: from mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813C2572667
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096920; cv=none; b=SEUy7LBTq7D1CxgQ4qAuZhUr2/yU4W1p+3tmYE2wzaCfMYIsKIzKgV8rPPs/YIovzIU8PDJSYCRjyuLP+7PS7ULLoEFYcE0wpLmGCP/qP39cvue16ZWIDpD8QsC6ztZnxMjZmeENzd+o687GICjMoBtG3ot+rt/7TNNC756NjEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096920; c=relaxed/simple;
	bh=eX/1NASofdyRydQxppyJHOAcf0kyETrv5J8Ql/c4zbk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OqCZPXOLF6kR2dldknXkdouVbclWkOhFi2Fw+HiVPoSzdzLiYQ4ykCyqTWY15/M8OxCIn7XsdVdrYHuuge98j6IvgdOkvXt1oKzxwJSw7We+sEESyTHUYZC/PwiSdFfWEsh6UtyhSkt3apGGaAVSbQO9yk6GfWrUTKvHMzJT5PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H8qq6okK; arc=none smtp.client-ip=95.215.58.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H8qq6okK"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=eX/1NASofdyRydQxppyJHOAcf0kyETrv5J8Ql/c4zbk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790096916; v=1; x=1790701716;
 b=H8qq6okKdCAm6lxAPSz310S8Aw1q8SnEnFbqtbQsgmqeb1g5f1zTCrj1C3lHhvNTOC79C3rP
 PAqpq7tRh/qa7UK2A2iBii2S4Ww8LtmvkWMANm8VP6abjHQasdtXM7QY4k8RRUU/fs9YP0W061c
 MpwNufc4S0YgWz5vAYmCt3mo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9153cb274da2b908;
	Tue, 22 Sep 2026 17:08:36 +0000
X-Mizu-Trace-ID: 9153cb274da2b908
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Yuchao Zhang <ndaugoing@gmail.com>
Cc: sashiko-reviews@lists.linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2] KVM: selftests: arm64: Add test for cross-vCPU LPI disable race
Date: Tue, 22 Sep 2026 18:08:34 +0100
Message-Id: <20260922170834.3228429-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260922105331.40498-1-ndaugoing@gmail.com>
References: <20260922102959.41FFA1F000FF@smtp.kernel.org> <20260922105331.40498-1-ndaugoing@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Yuchao,

The test passes on an unpatched 7.3-rc3 for me, so it doesn't reproduce
the bug yet.

On Tue, 22 Sep 2026 11:53:31 +0100, Yuchao Zhang <ndaugoing@gmail.com> wrote:
[...]
> On unpatched kernels, this race can lead to a use-after-free or host
> kernel panic in vgic_fold_lr_state() due to a dangling last_lr_irq
> pointer. With the fix in place (stopping the VM and holding a
> refcount on last_lr_irq), the test runs to completion without errors.

With only LPIs in flight EOIcount stays 0, so the fold breaks out of the
ap_list walk before it dereferences anything past the stale last_lr_irq.
To crash, the target vcpu has to EOI a non-LPI interrupt that's active
outside the LRs, with the remote disable landing while it's still in the
guest.

Cheers,
/fuad

