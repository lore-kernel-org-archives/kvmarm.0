Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC77E3793AC
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 10:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782210445; cv=none; b=MJosSGq+PQZm8ndXkQaNzqrMKHip7rPH+V5off66m9+6dAQSc7QQQ6Z+0HZAtJTyyqLgVebyvwTYgjR9yUfFnJhbo12yDOZ+IZIlOuu08uVm3DtzCT/Lm9d/Er1sR1mY77ro4VWbsJMh7S67rvmGxvOxONAHfonpeoOTVMqN+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782210445; c=relaxed/simple;
	bh=eIhMgdWLxfUaAvDhyWDL84g3FkW1tPcTck9/QXuF3SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF5pU1ojfcwdiHezZ9O3fxdHQHGjrN06eL3mDm+Qd1ZvQKSQ8b8I5D4CQkSCT9lbfEKdq/ezMW3PVZNjA9zCptZty5Wwf3O60IpOlAEd+Hc7xCBEYIdc31Qucab6jUWacd+yccRqentlu//jlMaInzTVddqDnUldvRV3xx58r/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1b57e98a6eee11f1aa26b74ffac11d73-20260623
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5104b8fe-fec1-4d35-8ae0-46f375c73fc7,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:53b438acd8985e3159c95f1ba58d32bb,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102|136|865|898,TC:nil,Content:
	0|15|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,O
	SI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1b57e98a6eee11f1aa26b74ffac11d73-20260623
X-User: leixiang@kylinos.cn
Received: from ninol.. [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <leixiang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 382149389; Tue, 23 Jun 2026 18:27:16 +0800
From: leixiang <leixiang@kylinos.cn>
To: Marc Zyngier <maz@kernel.org>
Cc: leixiang <leixiang@kylinos.cn>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH] KVM: arm64: Set irqfd->producer to enable vLPI routing updates
Date: Tue, 23 Jun 2026 18:26:16 +0800
Message-ID: <20260623102704.25270-1-leixiang@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <86v7b9r3cv.wl-maz@kernel.org>
References: <20260622075103.35164-1-leixiang@kylinos.cn> <86v7b9r3cv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

You're right, thanks. I chased the dead-code observation without
understanding what the forwarding path is for -- the translation is the
guest's, and reviving it would only unmap the vLPI without remapping,
which makes things worse, not better. I'll drop it.
