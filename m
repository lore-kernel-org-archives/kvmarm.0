Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49520224E4
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GaMUFjyy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699897411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rqt89Efo92L9gQUjQREL1i3618rnBSc+Vh+WfUyKjto=;
	b=GaMUFjyybpTySo5LbgVAoSuvIWXl16K+CdBNgoSz/VAtV1uvC1kblZGprICrvRpU/9fTIv
	JOmkuI+1xb0EpyeMQNwBuA6I8Gdh3nKjmEKFuT1LEfNHOW8N/IFUzof/TWbY4FJ+CCwT9h
	mELfn9nKjND2ruP5CN/KW4Rry3Bru4M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-9iy_81rePDapSoTfL6QrKA-1; Mon, 13 Nov 2023 12:43:27 -0500
X-MC-Unique: 9iy_81rePDapSoTfL6QrKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1607F83B825;
	Mon, 13 Nov 2023 17:43:27 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.115])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D7BC1121306;
	Mon, 13 Nov 2023 17:43:25 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev,
	maz@kernel.org,
	oliver.upton@linux.dev,
	alexandru.elisei@arm.com
Cc: jarichte@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/2] arm: pmu-overflow-interrupt: Fix failures on Amberwing
Date: Mon, 13 Nov 2023 18:42:39 +0100
Message-ID: <20231113174316.341630-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Qualcomm Amberwing, some pmu-overflow-interrupt failures can be observed.
Although the even counter overflows, the interrupt is not seen as
expected on guest side. This happens in the subtest after "promote to 64-b"
comment.

After analysis, the PMU overflow interrupt actually hits, ie.
kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
as expected. However the PMCR.E is reset by the handle_exit path, at
kvm_pmu_handle_pmcr() before the next guest entry and
kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
There, since the enable bit has been reset, kvm_pmu_update_state() does
not inject the interrupt into the guest.

This does not seem to be a KVM bug but rather an unfortunate
scenario where the test disables the PMCR.E too closely to the
advent of the overflow interrupt.

Since it looks like a benign and inlikely case, let's resize the number
of iterations to prevent the PMCR enable bit from being resetted
immediately at the same time as the actual overflow event.

Also make pmu_stats volatile to prevent any optimizations.

Eric Auger (2):
  arm: pmu: Declare pmu_stats as volatile
  arm: pmu-overflow-interrupt: Increase count values

 arm/pmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.41.0

