Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4349E19E61
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 20:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685564087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Wx6P8WeSlnkOFv6Uvp5u7/1blqUVl/sHiWl5b8BTkmc=;
	b=Cx3mGEqOYzu8JLQ7AvED/Tovk4omWrjkrbQETwAeOaUgKVVvJtyHkpRlQXXj9potdeVoLG
	WzFhCMq/uJADl8dsgw/qWuOsG1N6sBtaBw6YH04m8oOwxBqYwOG12qM+l0E2tAz+PcOjDg
	YCPFV93FY45AUAhWQPjAkN08MS204BI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-NhJShIAIMJKoDyXs6rSNqQ-1; Wed, 31 May 2023 16:14:43 -0400
X-MC-Unique: NhJShIAIMJKoDyXs6rSNqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 123363C0CEE9;
	Wed, 31 May 2023 20:14:43 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5A5C407DEC0;
	Wed, 31 May 2023 20:14:40 +0000 (UTC)
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
Cc: mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 0/6] arm: pmu: Fix random failures of pmu-chain-promotion
Date: Wed, 31 May 2023 22:14:32 +0200
Message-Id: <20230531201438.3881600-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

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

A new 'pmu-mem-access-reliability' is also introduced to
detect issues with MEM_ACCESS event variability and make
the debug easier.

Obviously one can wonder if this variability is something normal
and does not hide any other bug. I hope this series will raise
additional discussions about this.

https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v2

History:
v1 -> v2:
- Take into account Alexandru's & Mark's comments. Added some
  R-b's and T-b's.

Eric Auger (6):
  arm: pmu: pmu-chain-promotion: Improve debug messages
  arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
    values
  arm: pmu: Add extra DSB barriers in the mem_access loop
  arm: pmu: Fix chain counter enable/disable sequences
  arm: pmu: Add pmu-mem-access-reliability test
  arm: pmu-chain-promotion: Increase the count and margin values

 arm/pmu.c         | 196 +++++++++++++++++++++++++++++++++-------------
 arm/unittests.cfg |   6 ++
 2 files changed, 148 insertions(+), 54 deletions(-)

-- 
2.38.1

