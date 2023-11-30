Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7C134A6
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 03:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/1RVO8i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701315013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ww/G23VY72lofFkj/eKFHI/9f21iUPOtr0q5DiHkEsk=;
	b=C/1RVO8id4djI+xMaQD3bNvfauc4hgsQkW2cuYCDP1SpkOOhgLe8iRnlzbv5GrOQkZFOos
	CcRQxipH0db6pCq3ZgLORQk8zz97YVGhvjlQYCXY3WJl6f5gcnM7FBU4sh71KakfmBeWFh
	HlOcGWbDVerXhdtsCV8+yVPdqALqTFI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-UC0XSGceN8aF_tBiCGLWKQ-1; Wed,
 29 Nov 2023 22:30:06 -0500
X-MC-Unique: UC0XSGceN8aF_tBiCGLWKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 928643C0008D;
	Thu, 30 Nov 2023 03:30:05 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88D94112130C;
	Thu, 30 Nov 2023 03:30:05 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/3] runtime: Fix the missing last_line
Date: Wed, 29 Nov 2023 22:29:38 -0500
Message-Id: <20231130032940.2729006-2-shahuang@redhat.com>
In-Reply-To: <20231130032940.2729006-1-shahuang@redhat.com>
References: <20231130032940.2729006-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
This lead to when SKIP test, the reason is missing. Fix the problem by
adding last_line back.

Fixes: 2607d2d6 ("arm64: Add an efi/run script")
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index fc156f2f..c73fb024 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -149,7 +149,7 @@ function run()
         fi
 
         if [ ${skip} == true ]; then
-            print_result "SKIP" $testname "" "$last_line"
+            print_result "SKIP" $testname "" "$(tail -1 <<<"$log")"
             return 77
         fi
     }
-- 
2.40.1

