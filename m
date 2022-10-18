Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99301857
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 04:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666065908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JNqb4x91+ibnSA52SM3oP+YarplnTCPWBJopPQMXy8w=;
	b=CvuFS7+MnP5pVU0WAB57gZNIk/eTfE9nqhT6eRuZFkmpUgczD+ps1wzMyV/INOvh+ZbMgx
	feul9FdFa71CqV7AUI4rRpWzpSVYBX5MB63KY7RZ5QJkWtz5aI7VqcFIRleEQLV8iagCUH
	n37zpB/cwv7OfyA++VTeL0Oof2F+gB8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-KfLnK5g4PyOaphanWfJqXA-1; Tue, 18 Oct 2022 00:05:04 -0400
X-MC-Unique: KfLnK5g4PyOaphanWfJqXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E774329A8AEA;
	Tue, 18 Oct 2022 04:05:03 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57AAA2166B41;
	Tue, 18 Oct 2022 04:04:58 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajones@ventanamicro.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	shuah@kernel.org,
	oliver.upton@linux.dev,
	mail@maciej.szmigiero.name,
	maciej.szmigiero@oracle.com,
	seanjc@google.com,
	peterx@redhat.com,
	ricarkol@google.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH v2 0/6] KVM: selftests: memslot_perf_test: aarch64 cleanup/fixes
Date: Tue, 18 Oct 2022 12:04:48 +0800
Message-ID: <20221018040454.405719-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Message-ID: <20221018040448.XzT4aK74-6Lbur9u5cleQi6k3Y2XO_YbnbQkuh19e5o@z>

kvm/selftests/memslots_perf_test doesn't work with 64KB-page-size-host
and 4KB-page-size-guest on aarch64. In the implementation, the host and
guest page size have been hardcoded to 4KB. It's ovbiously not working
on aarch64 which supports 4KB, 16KB, 64KB individually on host and guest.

This series tries to fix it. After the series is applied, the test runs
successfully with 64KB-page-size-host and 4KB-page-size-guest.

   # ./memslots_perf_tests -v -s 512

Since we're here, the code is cleaned up a bit as PATCH[1-3] do. The
other patches are fixes to handle the mismatched host/guest page
sized.

v1: https://lore.kernel.org/kvmarm/20221014071914.227134-1-gshan@redhat.com/T/#t

Changelog
=========
v2:
  * Pick the smaller value between the ones specified by
    user or probed from KVM_CAP_NR_MEMSLOTS in PATCH[v2 3/6]    (Maciej)
  * Improved comments about MEM_TEST_MOVE_SIZE in
    PATCH[v2 4/6]                                               (Maciej)
  * Avoid mismatched guest page size after VM is started in
    prepare_vm() in PATCH[v2 4/6]                               (Maciej)
  * Fix condition to check MEM_TEST_{UNMAP, UNMAP_CHUNK}_SIZE
    in check_memory_size() in PATCH[v2 4/6]                     (Maciej)
  * Define base and huge page size in kvm_util_base.h in
    PATCH[v2 5/6]                                               (Sean)
  * Add checks on host/guest page size in check_memory_size()
    and fail early if any of them exceeds 64KB in PATCH[v2 5/6] (Maciej)

Gavin Shan (6):
  KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
  KVM: selftests: memslot_perf_test: Consolidate loop conditions in
    prepare_vm()
  KVM: selftests: memslot_perf_test: Probe memory slots for once
  KVM: selftests: memslot_perf_test: Support variable guest page size
  KVM: selftests: memslot_perf_test: Consolidate memory sizes
  KVM: selftests: memslot_perf_test: Report optimal memory slots

 .../selftests/kvm/include/kvm_util_base.h     |  15 +
 .../testing/selftests/kvm/memslot_perf_test.c | 307 +++++++++++-------
 2 files changed, 213 insertions(+), 109 deletions(-)

-- 
2.23.0

