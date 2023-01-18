Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE047B
	for <kvmarm@lists.linux.dev>; Wed, 18 Jan 2023 09:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674033723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4tifeO2xGEUe2BR4MTPcvqD9DYXo+N6z/AHt0y7Gfcc=;
	b=bjhyFiYzkCBQg2jO9UONUhQKFJq76ST6ijjU8E5gVWe/fuPWQgW+nCJaPI8ZTpIQO+U0PZ
	cD6EPrinUKedxM9vLgmZsNqA2zp6OsysPVk6VaNZRLZvUj82uTHAvPgmdYVV7G/vuzgn9B
	oY0bxNM+EgTbcXD82w66Z9KNC9Hzmi4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310--F4ruqJ1OKeRdNCD9UsWbQ-1; Wed, 18 Jan 2023 04:21:58 -0500
X-MC-Unique: -F4ruqJ1OKeRdNCD9UsWbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEB67858F0E;
	Wed, 18 Jan 2023 09:21:57 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F9DA40C2064;
	Wed, 18 Jan 2023 09:21:53 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	maciej.szmigiero@oracle.com,
	seanjc@google.com,
	shan.gavin@gmail.com
Subject: [PATCH 0/2] KVM: selftests: Remove duplicate VM in memslot_perf_test
Date: Wed, 18 Jan 2023 17:21:31 +0800
Message-Id: <20230118092133.320003-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

PATCH[1] Removes the duplicate VM in memslot_perf_test
PATCH[2] Assign guest page size in the sync area in prepare_vm()

Gavin Shan (2):
  KVM: selftests: Remove duplicate VM in memslot_perf_test
  KVM: selftests: Assign guest page size in sync area early in
    memslot_perf_test

 tools/testing/selftests/kvm/memslot_perf_test.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

-- 
2.23.0

