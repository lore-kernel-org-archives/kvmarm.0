Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA24A39F
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 07:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665731986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D8s16tiZuYHA8WakFIbdUv+5nE3Pxop3GoZh9YyYHgw=;
	b=Y4FTwj5xQuClfubB5vZos8U5mkBb92Fmh2GB8/CTC5NuWQhRbHvqzQmRjEph644xWL3KbI
	OKJJNLKWDPgl6Wv/qwnx1SSPsSPgCGsDKG1OzauiTgvrTCOuegeyvIrlq28ltyMWaedK2a
	Ug94TyNctAKNGxAANQgR/vf6AYC/vAk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-cVPqaDGcOoClOmvlftlLug-1; Fri, 14 Oct 2022 03:19:43 -0400
X-MC-Unique: cVPqaDGcOoClOmvlftlLug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C64ED833A0D;
	Fri, 14 Oct 2022 07:19:42 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40B36C06224;
	Fri, 14 Oct 2022 07:19:36 +0000 (UTC)
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
	seanjc@google.com,
	peterx@redhat.com,
	maciej.szmigiero@oracle.com,
	ricarkol@google.com,
	zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: [PATCH 0/6] KVM: selftests: memslot_perf_test: aarch64 cleanup/fixes
Date: Fri, 14 Oct 2022 15:19:08 +0800
Message-ID: <20221014071914.227134-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Message-ID: <20221014071908.BpJOo5NO5pMRiXdQCA9BaeQ8aW8RUY6lZ0IfZHcO2pQ@z>

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

Gavin Shan (6):
  KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
  KVM: selftests: memslot_perf_test: Consolidate loop conditions in
    prepare_vm()
  KVM: selftests: memslot_perf_test: Probe memory slots for once
  KVM: selftests: memslot_perf_test: Support variable guest page size
  KVM: selftests: memslot_perf_test: Consolidate memory sizes
  KVM: selftests: memslot_perf_test: Report optimal memory slots

 .../testing/selftests/kvm/memslot_perf_test.c | 286 +++++++++++-------
 1 file changed, 183 insertions(+), 103 deletions(-)

-- 
2.23.0

