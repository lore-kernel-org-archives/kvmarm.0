Received: from mta0.migadu.com (out-123.mta0.migadu.com [91.218.175.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8424DE729
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 11:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789645576; cv=none; b=Xay1vxNGMtTae3yVjZla5rK7NdqIcxn1Doo5IjRB0WqJE9UPXz1+y3Ul1/S6Z9OitFjFdtTnymM8y7iUWujTBfwiAta1XGVurCTEBox7zc50qCB1/EBI6piF8Fvu6tyQMwVBmrQuQxLHWhCHzMJtJd6XAKK+Wg4cHw0TzKoKDZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789645576; c=relaxed/simple;
	bh=qDI4BZ1rw9EhNWsZxeTYF88y9ggTNgPhlWojNlf71ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRLbK+7V5qI8k47p8q0x9pAWLQuRtuortcTDHQvrERMBYl+W4XeZzPEAof0LQM9wB5r3C7LAYzmUdMLT/pA5vZ5ViFG3dAK+dCQPOCSNjVT5bw+u56OFgj0AjDYSJP6ypjW3Die0ncmCe4DoO1x+JmWOpeEfFMQxPQ+40+H6dsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CoMPZ8i3; arc=none smtp.client-ip=91.218.175.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CoMPZ8i3"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qDI4BZ1rw9EhNWsZxeTYF88y9ggTNgPhlWojNlf71ak=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789645566; v=1; x=1790250366;
 b=CoMPZ8i3K64LDNHT4dzLO6DwE5ruXzSnarwzy0cYenxMi+RmocFaWdAd5csnL3ZnjJVRDaRk
 GKg97chSjzIEX9K2QvAcg0dnFULuB3+m31vklo9UzqtVdFx4zk2veWll3MzvZs5ktvjwJ7mynBv
 hXoDHct4BTg9xpWKW1q+PHXs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 92ac47b8f8b690fb;
	Thu, 17 Sep 2026 11:46:06 +0000
X-Mizu-Trace-ID: 92ac47b8f8b690fb
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH 2/3] KVM: selftests: Add missing newline to access_tracking_perf_test help
Date: Thu, 17 Sep 2026 19:45:42 +0800
Message-ID: <20260917114543.85044-3-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917114543.85044-1-zenghui.yu@linux.dev>
References: <20260917114543.85044-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

The help text for the -h option is printed without a trailing newline, so
it runs together with the first line of the guest mode help that follows
it.  Add the missing newline.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index bcdfeb9c22d8..98ace8b8b4ac 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -504,7 +504,7 @@ static void help(char *name)
 	printf("usage: %s [-h] [-m mode] [-b vcpu_bytes] [-v vcpus] [-o]  [-s mem_type]\n",
 	       name);
 	puts("");
-	printf(" -h: Display this help message.");
+	printf(" -h: Display this help message.\n");
 	guest_modes_help();
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
-- 
2.53.0

