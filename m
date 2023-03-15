Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2938E33F6
	for <kvmarm@lists.linux.dev>; Wed, 15 Mar 2023 11:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678878458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kHrueT9KYqctgZdyPnZ5VDFZ/xLFpYFHmvkZjij7nVY=;
	b=gNQETCX/tWbqJ8gaRJIY5dUumSJsHDKAOqOlArwGnCsrlWUm2SZwFakVjFGqejUD4mhZuw
	mB/47vflGdt7MTxEO3cf1HA3L6BU4PreJOMNEfpWKYgzJ0zkWQvguzKI79KVyIzvAjA4bg
	Wm0qoGMhip1OmPmMON+X8/icul/UV3w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-eYetydg5PD2Z_CrBTdB-ww-1; Wed, 15 Mar 2023 07:07:34 -0400
X-MC-Unique: eYetydg5PD2Z_CrBTdB-ww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDA2187B2A2;
	Wed, 15 Mar 2023 11:07:33 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.134])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB173202701E;
	Wed, 15 Mar 2023 11:07:31 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev,
	maz@kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	ricarkol@google.com,
	reijiw@google.com,
	alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 0/6] arm: pmu: Fix random failures of pmu-chain-promotion
Date: Wed, 15 Mar 2023 12:07:19 +0100
Message-Id: <20230315110725.1215523-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4

On some HW (ThunderXv2), some random failures of
pmu-chain-promotion test can be observed.

pmu-chain-promotion is composed of several subtests
which run 2 mem_access loops. The initial value of
the counter is set so that no overflow is expected on
the first loop run and overflow is expected on the second.
However it is observed that sometimes we get an overflow
on the first run. It looks related to some variability of
the mem_acess count. This variability is observed on all
HW I have access to, with different span though. On
ThunderX2 HW it looks the margin that is currently taken
is too small and we regularly hit failure.

although the first goal of this series is to increase
the count/margin used in those tests, it also attempts
to improve the pmu-chain-promotion logs, add some barriers
in the mem-access loop, clarify the chain counter
enable/disable sequence.

A new 'pmu-memaccess-reliability' is also introduced to
detect issues with MEM_ACCESS event variability and make
the debug easier.

Obviously one can wonder if this variability is something normal
and does not hide any other bug. I hope this series will raise
additional discussions about this.

https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v1

Eric Auger (6):
  arm: pmu: pmu-chain-promotion: Improve debug messages
  arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
    values
  arm: pmu: Add extra DSB barriers in the mem_access loop
  arm: pmu: Fix chain counter enable/disable sequences
  arm: pmu: Add pmu-memaccess-reliability test
  arm: pmu-chain-promotion: Increase the count and margin values

 arm/pmu.c         | 189 +++++++++++++++++++++++++++++++++-------------
 arm/unittests.cfg |   6 ++
 2 files changed, 141 insertions(+), 54 deletions(-)

-- 
2.38.1

