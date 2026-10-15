Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A1B52CCD8
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 12:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069043; cv=none; b=eJmHH0DCD29n0Jo9iKOz7z7Uw/EORQrwiwmo8RgrMR9gjoELa239VELb0kOtlvf0Vpw2yhk1S0tkILU5jzzwAPF/IQ1qQiLp/otvR4AcfQMe3W4vjJAnA6o7a6eSBvkDordRxx18muZ0+MJQAIHG0TND2ib+q3P4lQ1uAzDK8wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069043; c=relaxed/simple;
	bh=OyIHE1N8EhU4LfmaBkvq2F19q6tRD3/spV1VOIDMgLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ai23jcRxJc3f8D4WMSWJtlaMjzpFmpZqwtLSm3SnQ/N/BVCFZbIoWfEpUPf+Elck93EZI6ge8MW7E7t2dziSbQnn7jEoCiBhoOZ86gPV3UqXU0oczMQG7V44q2Dhj17zeOjUd30MtalGYvntCciT6dj7HY/+/Acpw14wNUpQwzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u6ZvII4K; arc=none smtp.client-ip=91.218.175.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u6ZvII4K"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=OyIHE1N8EhU4LfmaBkvq2F19q6tRD3/spV1VOIDMgLE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792069039; v=1; x=1792673839;
 b=u6ZvII4K4fHTNkJedM9DiM+1QjA6nMzZUQPTQZcDsPmNKCt/CyvcO4Vp+BTDc2c6pI5A9knk
 LtpSKB+YivY06zTskjBZEsjTknobwUKVpGxm1uHwBbr9SndY+loN4Nb/Aq7DmaiLY5rQMeZTesT
 J68wAbNCe2ic1YyGljQ21TP4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fe94d5db4e3b8dd5;
	Thu, 15 Oct 2026 12:57:19 +0000
X-Mizu-Trace-ID: fe94d5db4e3b8dd5
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 5/7] KVM: arm64: Add helpers to halt a vCPU
Date: Thu, 15 Oct 2026 13:57:16 +0100
Message-Id: <20261015125716.2650737-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261015100539.1011760-6-maz@kernel.org>
References: <20261015100539.1011760-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Thu, 15 Oct 2026 11:05:37 +0100, Oliver Upton <oupton@kernel.org> wrote:
[...]
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> Link: https://patch.msgid.link/20260929212925.31775-2-oupton@kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Should this one have a Cc: stable too? Patch 6 is tagged for stable and
calls kvm_pause_vcpu() and kvm_resume_vcpu(), so it won't build in
stable without this patch.

Cheers,
/fuad
