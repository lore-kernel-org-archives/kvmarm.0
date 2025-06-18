Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C979621CC79
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220687; cv=none; b=XqNMEZYRJTYYcXg0Ah5vfo9VEuXOHqfZVn0tnL+/fuZm12LFhXijwqUWgk9wsg/jhLCVhT8wn6zu8/9CNpHJn4zr5wDtfjh14/PZaQrDu1TgRQdt3I6cV7ijP49whl+h/QNEmDoeWk3ZTiFJ4VqzdvkGs/2n7IPnJiuGZ8xPGOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220687; c=relaxed/simple;
	bh=jSiCen/C1Tdc2UB541LJK2epQTbdnnCbieLg8I8XSIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oDywPgi9meOZZDn+MVBawOG0qG6sREappBE0CuNGPiZoADx2YnRffcg8sxrSEYYbnltOvIlXMLz0iGspf/sh6pR402e6r2ZIm18NyK1xNA3FwJncoCIpwkGyZjhleDl/7uS68dJNW7zMJIvcbHnEFeXsw7hHmsSSWS0J1JHJ7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z0XUPt3v; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z0XUPt3v"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7398d70abbfso8422197b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220685; x=1750825485; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lJmtzreapar7RYm6csfZXNlZpVROzgpN0suNPttjN9U=;
        b=Z0XUPt3vOwzCwbEiGBjzVhQcLw/fuY7v5zrlgSmDbW7RMWYE8ybw282DihVecvUTY8
         JIqDrW4IxD6pvu7BM5LNl5awqGYyP9Hv/O2/bRgAFHvDlshLeMjZwk7Z84iS0GY/C9yG
         l58z0JmmSYkMchAN+jUXtiEuRHXInrJgszTgpdhu5FJN2bgpUB9MpeP5wrJGRFbq1VGH
         NrhtTrdCjsrGTmrjHmXCrn7q/gDN9GKntyL31QTq+9p26w3DB7dGpgHNiO+YvP9tKZqR
         p/xjho7nqauzPq8PfF565SonIom5WuFPomevtw5rDpM1s8ylxwsxfjmgEYn0NVGcbNnS
         sleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220685; x=1750825485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lJmtzreapar7RYm6csfZXNlZpVROzgpN0suNPttjN9U=;
        b=rnbF0epu0l4pWIP+CM4UbsXX6Iqs+L8laB5xaUB5QB3EZV8qAG4iqO9qWqgAPl8bzq
         wbfbYHI6hNBP9joFpTDv8Kn6BxDSnsuDfZCzOOgQjrI7BdWht63Lwh2ZaPf46HhsEfvK
         oQB1ICGya2MksRUAdnZTQi8vPRB66oR5cbUXre3cG6KXUHb13WXhTkgPkxf3RaQ8n8ur
         BzfInfgv6uAuHheSXPgIGVRrntjZMPKAJkpi58Yc+Fh7yDrLcvnz7Jbiy6kqU45YQHx1
         Sjh5LQM7idwEfvZtBmapVhNX6PtAwzZZ6T6oxi77y8Q9/BE+vpKB3lhOTPU3pDwIG6Ze
         pfbw==
X-Forwarded-Encrypted: i=1; AJvYcCX53qnpAZY/fACqAfO2EUHJuF6uX9E3HuIioM1bgK/qCtttpjz/ibeysWU8653CFKmznxWB6MI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAO6La3W5fKqfcQINBJKIrFlFAXR2kL5miBHI5v/357yzK6S/i
	0GGd4ZFO9njOPzfIt3ETLhD5AGPqrLEdz0YDlIoVcie98B6RO/DS+37Jfr627QpEm3hS1UwSvRD
	JftaEqEGrqHW7d6PdSvHa6A==
X-Google-Smtp-Source: AGHT+IEYBcC2cDsFrgiMsyVhS97ys7BmjM02OsUOLrECd3uh2HcwoI2YZYxPTZFJmgzjhVgSJXNOQSUyK0OIbxzF
X-Received: from pfus9.prod.google.com ([2002:a05:6a00:8c9:b0:747:a4c0:983d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a115:b0:218:c01:ddce with SMTP id adf61e73a8af0-21fbd5d90aemr27193918637.40.1750220685258;
 Tue, 17 Jun 2025 21:24:45 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:21 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-13-jthoughton@google.com>
Subject: [PATCH v3 12/15] KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The KVM_MEM_USERFAULT flag is supported iff KVM_CAP_USERFAULT is
available.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index ce3ac0fd6dfb4..ba3fe8a53b33e 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -364,6 +364,9 @@ static void test_invalid_memory_region_flags(void)
 	if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		supported_flags |= KVM_MEM_GUEST_MEMFD;
 
+	if (kvm_check_cap(KVM_CAP_USERFAULT))
+		supported_flags |= KVM_MEM_USERFAULT;
+
 	for (i = 0; i < 32; i++) {
 		if ((supported_flags & BIT(i)) && !(v2_only_flags & BIT(i)))
 			continue;
-- 
2.50.0.rc2.692.g299adb8693-goog

