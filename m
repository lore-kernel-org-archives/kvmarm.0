Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FC6241CA8
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254203; cv=none; b=Qb59iotNrofx/EGFahjeJLlmHmv2gTG6K77dfA0n1vVss5MdmB1Ctiepni3xbotYrkRPEgHnvYx2XR4cp8QrwdWAy/H4CTJHuE20T9XnJuhEz21uX14+unVZubErf2OlxW6Cyr1YMKtreVLSb8Xd/Q7VuPpcuR4jaM4F+CKoYZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254203; c=relaxed/simple;
	bh=VG/G+DbytmsCJRMeTYLj0G1mYMysJoBW+4ZySPq273k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SNvsRyTT2x5jcNi7DzYa9IzmuhA5gOuF8UxwRZYeEYgmws7xAZzCeAV9/oUUhxPlnkaDLXvNCpsAsxbaSUhs7BPuKqqs37YrT+65OYkAgvUIWcpsZf7S8WwLFNHNlorAzULNLbUsiyRaXhPJ/aCA3pOV7YqX7QSG2XkFsJAUEIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1jZi11oz; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1jZi11oz"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b115fb801bcso2920743a12.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254201; x=1749859001; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PWbzbH1m+wqWOmBrT8udt/40D0dgC1NwBn/2qwIwUgk=;
        b=1jZi11ozK9oprAIs581bccDFM+sCRvrRDIPZBHFo/zadw4bffz1Mep8QldaPL58CXd
         qDSwaH7QnaqDpGljG8yB0fDdQgb+QTcIP9JLOxbdxeS1SDvSzs5k5+T6tiXkQgLZGw45
         R0V3+y4S7AyUuoHJ37pW1rNRlfGRqQRyzq7qv4ij13krC3iaq+QCBisPcajFmIjQf3+x
         IS+8QQX7ps76uI5yBEKw0KUJnfMZpy7jcMmFOzcNwbR6wPFZq8Jb0UFT1W2rYwXsbGaq
         6A4teIrCzN+n4RWTGYJE23pevbILK2tk5XTVdBLFSuejFebHQHh0R2VE5aYnebD8OMC6
         h+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254201; x=1749859001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWbzbH1m+wqWOmBrT8udt/40D0dgC1NwBn/2qwIwUgk=;
        b=l9dU6B76svP+nJ8vPijmMgW4OgCtiX1wuapi5YAk1mA84Y14fzQ9M8wLOG+S7gJwMz
         K7RL5s76+NWzoIslH69nk+CkzGCmDfEtzU2+zKFK2AzoR8xAWHWXPvt4fqnKX9gYv/Qt
         yA6C/o12P7grVIrj19cF7dNK94WAylKGp0oxpYI7Ww15X98xi+cm7sPoJaQSDBpBAX+N
         8YNV+5KcHAnu/6PSpe5pSRd8LQMIwuLXafuA/aZYfNI6niH+dfQHb780rIp8KYs6s/+n
         +jhvHWkIp7ohCB0ByhoHVMPBXWomt4Dv4mujFIOCNeqZYqQCsqNGwBRGoVFb4viq7PR2
         IVXA==
X-Forwarded-Encrypted: i=1; AJvYcCWWzu344GgG5GNtgsmiEgBYbVHg59eUaevZvvQLvWwEkDAcELhY6/eMB0yiz8hpOCa8SxZ1Dpc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy26u9pnfIlDLwWDyuLlKg0wKbLeZKnvbdz/WZFWm3A+jGJ3DOe
	Rnqf7P9mFneV8KNG1RaytzfZVKo+WubzlAKYjx/W/tU+BaGQd44Jw8eL7fC5x1vUQ3VUcNGIaLu
	kuStf7yl+Fw==
X-Google-Smtp-Source: AGHT+IGVs207s86YmdkUc4NLTl0O3Ae4xRqr3JThhY5MoJTIq3qF5lZ9DcjFAhjtq7dWe0bT1o+6NEUKFsOo
X-Received: from pfbhu52.prod.google.com ([2002:a05:6a00:69b4:b0:746:1b3a:db4])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3383:b0:215:e60b:3bd3
 with SMTP id adf61e73a8af0-21ee25e0bfemr7507277637.29.1749254201128; Fri, 06
 Jun 2025 16:56:41 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:10 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-7-vipinsh@google.com>
Subject: [PATCH v2 06/15] KVM: selftests: Add a flag to print only test status
 in KVM Selftests run
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line argument, --print-status, to limit content printed on
terminal by default. When this flag is passed only print final status of
tests i.e. passed, failed, timed out, etc.

Example:
  python3 runner --test-dirs tests  --print-status

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/runner/__main__.py    | 5 +++++
 tools/testing/selftests/kvm/runner/test_runner.py | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 48d7ce00a097..3f11a20e76a9 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -59,6 +59,11 @@ def cli():
                         type=int,
                         help="Maximum number of tests that can be run concurrently. (Default: 1)")
 
+    parser.add_argument("--print-status",
+                        action="store_true",
+                        default=False,
+                        help="Print only test's status and avoid printing stdout and stderr of the tests")
+
     return parser.parse_args()
 
 
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 0a6e5e0ca0f5..474408fcab51 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -17,6 +17,7 @@ class TestRunner:
         self.tests = []
         self.output_dir = args.output
         self.jobs = args.jobs
+        self.print_status = args.print_status
 
         for test_file in test_files:
             self.tests.append(Selftest(test_file, args.executable,
@@ -29,7 +30,7 @@ class TestRunner:
     def _log_result(self, test_result):
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
-        if (self.output_dir is None):
+        if (self.output_dir is None and self.print_status is False):
             logger.info("************** STDOUT BEGIN **************")
             logger.info(test_result.stdout)
             logger.info("************** STDOUT END **************")
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

