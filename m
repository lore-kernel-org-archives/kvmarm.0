Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6A829A309
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763960703; cv=none; b=eOwoyXjU3q5uaCBd/Iznr/SWbhATYQZ6HgsJjnN9k1JcZSUM5vvLSsiDdORo+YqxBeag8i3I2r6HlT25zAr932S7RAMVRWpmxtgME8UtpTVqjfXd624bjsKlh37uaSGv6H9ihnkRzGNg2h2NUJhk5YxnSTbNHmu+QFkiOccrJ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763960703; c=relaxed/simple;
	bh=jgunH0PsWpK/zSQyPSuaVv0R9gIIlbDMFDceS4blm88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QXhO6+tuA26L9X81byocOsWp1zBkg4oo6tLrt5iErOuQJ9KbD//fDPQVwwG4CHxCaAJy6cB00vxB6JJvfiuc1dZLlXXqDu3E8OGYoCo24aFfsJ+iBlEFUha1gRcepS9m2BVcvqwWP37MON5V5ou/08xtn4YFVaPu7lA7Ezh4VLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uc00vuIT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uc00vuIT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763960700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZARig0mkAfhyVpxziKpIN9dzSGezkpNssMMdRVlHTnA=;
	b=Uc00vuITLiiQvbyp/Egkpybeu5j4SBBAGnMAETPt14MNQEZhRjGI9aFUnWcKJTAJeEj+Np
	jjhJpqz5mlS/L4tGw9g7Mc2ZrIqi8lJq81PAJSGV5hh/AU4VS9Edm+Br0I5lXKxZhEfFzt
	bSg6oLqtNIeLXJiI9Vyqob+AKxd7qLw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-212-yT4DBRBiPsS6WRYmBD1DXg-1; Mon,
 24 Nov 2025 00:04:55 -0500
X-MC-Unique: yT4DBRBiPsS6WRYmBD1DXg-1
X-Mimecast-MFC-AGG-ID: yT4DBRBiPsS6WRYmBD1DXg_1763960694
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0F55195609F;
	Mon, 24 Nov 2025 05:04:53 +0000 (UTC)
Received: from gshan-thinkpadx1nanogen2.rmtau.csb (unknown [10.64.136.67])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC4D619560A7;
	Mon, 24 Nov 2025 05:04:49 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	seanjc@google.com,
	shan.gavin@gmail.com
Subject: [PATCH] KVM: selftests: Fix core dump in rseq_test
Date: Mon, 24 Nov 2025 15:04:27 +1000
Message-ID: <20251124050427.1924591-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In commit 0297cdc12a87 ("KVM: selftests: Add option to rseq test to
override /dev/cpu_dma_latency"), a 'break' is missed before the option
'l' in the argument parsing loop, which leads to an unexpected core
dump in atoi_paranoid(). It tries to get the latency from non-existent
argument.

  host$ ./rseq_test -u
  Random seed: 0x6b8b4567
  Segmentation fault (core dumped)

Add a 'break' before the option 'l' in the argument parsing loop to avoid
the unexpected core dump.

Fixes: 0297cdc12a87 ("KVM: selftests: Add option to rseq test to override /dev/cpu_dma_latency")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 1375fca80bcdb..f80ad6b47d16b 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -215,6 +215,7 @@ int main(int argc, char *argv[])
 		switch (opt) {
 		case 'u':
 			skip_sanity_check = true;
+			break;
 		case 'l':
 			latency = atoi_paranoid(optarg);
 			break;
-- 
2.51.1

