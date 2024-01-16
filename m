Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC3811184
	for <kvmarm@lists.linux.dev>; Tue, 16 Jan 2024 06:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4HjneLK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705388334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tqq6wYIFEnT+LQV2qUAqyFES2NYVYOIc6yshT9Yaoeg=;
	b=b4HjneLKVYcuwzh+HYM+FvitBaZZ9Wyzwczo0/R5pUYNdzQMKiMnJkOzeThjC8AQ2PdyKm
	8tWjBGjT1Iqb3uoF4rRfPuU86glYJ+KOTDRIvNfiGMUb7jXy7/WhRsLCGU1Ze+k0zfhop/
	XJkd4U/5pLKp8xT9mc0kVeLipwZIXig=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-_Kqv1i-AMLK86Exz2t7-UA-1; Tue, 16 Jan 2024 01:58:48 -0500
X-MC-Unique: _Kqv1i-AMLK86Exz2t7-UA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A48D848942;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E48E3C25;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Ricardo Koller <ricarkol@google.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/3] runtime: Fix the missing last_line
Date: Tue, 16 Jan 2024 01:58:44 -0500
Message-Id: <20240116065847.71623-2-shahuang@redhat.com>
In-Reply-To: <20240116065847.71623-1-shahuang@redhat.com>
References: <20240116065847.71623-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
This lead to when SKIP test, the reason is missing. Fix the problem by
adding last_line back.

Fixes: 2607d2d6 ("arm64: Add an efi/run script")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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

