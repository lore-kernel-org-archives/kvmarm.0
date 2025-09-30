Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0BD257834
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250227; cv=none; b=Pa8dT9A9XKkaR602ILABYFgLEd4QebG+oyAbsuhg7UyHCeXtZchj4iiuuDfCVLNHqZ0J624FzsXiqvbEp2qfqZoCrU+naTYGtvvHpNB3SeyUAURvYmLJmv7p8Hd6LsDX7Sa5hIKlt1wfxwcTi7gUuTKFzt2eOxSjaQ5AZMGNHhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250227; c=relaxed/simple;
	bh=GJ6Trfw8ZxlzDRTI1uQfQ+m2EdLCPjK6h626Z8z84xY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RgJVgMM8AdT6/J45RXQnz4G6yT3n+skcDSwYrlWo2GGdCxg5XmMnWrmA5oq9Px7uKljvZwTpS6KR2D4TCYvnNQlVaLEvC7X+uUNnbEnQ1Wxdp545PT6s6/c/XBiHWb18zhoxJspkVx+gZLijENjBajTOyD5ALkGdS/tzXVSs+hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhwqMt60; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhwqMt60"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so5478119a91.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250224; x=1759855024; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VhViqDkwcWVSLWWD+zOBqBHO20tquMwNgbfY3Bzt4yk=;
        b=dhwqMt60aHlE0O/mEErbR+kZlpWI9vn6nPciZeeVlZD4qQhpouycODHQ8FR2yZCZZV
         gFFlK9+J6dyrnzEtd5lH6MOdyVYxLK5Jj9W8D02Eglhb0VE6j7o2/OlrHX/v831nteQF
         vWbL6CJWkfkdREtYmy+2/y2CEc6cqgkRqILUPEMigvSx/lE2TNtB+dC+cM4bcEh06tGI
         6PlfhluSFvH0MtLvYV1chk9BInB/WV6mHufF0tsQgzW837maqSxk1xlkaZURhISGhj9c
         u0PFHnLhla6lOJA5oS6sHg1TUewMOTAC+TVeV0n13KGr07bX6tzsd3xgDit1ILd5jcHM
         ed2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250224; x=1759855024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VhViqDkwcWVSLWWD+zOBqBHO20tquMwNgbfY3Bzt4yk=;
        b=f7fbnsK6U9M8XOUGYzlwVJZ9jswtrIp0jIB7f44y//ZQLuTlKv1BgQJxPdCDAKy8Wa
         l9wthxKeHFUTcZfo1gnf0csNlVdb8bC9dL5whJ0/hjFUil8f25X1AJ8gHpndAFUdQ+9Z
         mKUA6OgIQ2HWTjsAD+NtrpqlAb8GTDHl85w2CbU5zD9L3OrXxR1KRa+AJRQbYDHFh021
         sgQCeNBEVSqtLOyesp1fL0Xt2DDV5sT7sxSET/FMtSfG2/00M4nfUROnx5m3ut0SixOG
         nx/Y2Ui5vgd1bJfcpma6Nvlg7bEvPgFI+cm/Ozv0TBgEYwgChHGi/g7928N8wtgKrKqB
         G92w==
X-Forwarded-Encrypted: i=1; AJvYcCUw0bK9QE2NF9VV9/K25yqYdnqpyaFWJvNWmqmGE5G5Z+/eHUH4/CDbq6wV+ntH7HjGdr5XG0k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUKTQWV04XGW6RUIPT/TBcY0KSSe7LluvHncsKd+UuMfgpB7VD
	cU2kxosWGGxA0hGySPdUbGrTCA7Ru+lpQ/agUaxLjEAO1qM+2ERaUSBskP1Hvs2VNkQG80v+AMF
	/5rYicGC5WQ==
X-Google-Smtp-Source: AGHT+IFNJr9lipNoSDt3DruF7rcxWQ60eYd2ESWJFpivjjPDmvUD5g41M9KiJ+nbTnZt0uYf5BR5V0buLOkY
X-Received: from pjkh7.prod.google.com ([2002:a17:90a:7107:b0:332:4129:51b2])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b50:b0:330:48d1:f90a
 with SMTP id 98e67ed59e1d1-339a6f680d9mr89247a91.27.1759250224019; Tue, 30
 Sep 2025 09:37:04 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:35 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-10-vipinsh@google.com>
Subject: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add README.rst for KVM selftest runner and explain how to use the
runner.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/runner/README.rst | 54 +++++++++++++++++++
 2 files changed, 55 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/runner/README.rst

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 548d435bde2f..83aa2fe01bac 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -4,6 +4,7 @@
 !*.c
 !*.h
 !*.py
+!*.rst
 !*.S
 !*.sh
 !*.test
diff --git a/tools/testing/selftests/kvm/runner/README.rst b/tools/testing/selftests/kvm/runner/README.rst
new file mode 100644
index 000000000000..83b071c0a0e6
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/README.rst
@@ -0,0 +1,54 @@
+KVM Selftest Runner
+===================
+
+KVM selftest runner is highly configurable test executor that allows to run
+tests with different configurations (not just the default), parallely, save
+output to disk hierarchically, control what gets printed on console, provide
+execution status.
+
+To generate default tests use::
+
+  # make tests_install
+
+This will create ``testcases_default_gen`` directory which will have testcases
+in `default.test` files. Each KVM selftest will have a directory in  which
+`default.test` file will be created with executable path relative to KVM
+selftest root directory i.e. `/tools/testing/selftests/kvm`. For example, the
+`dirty_log_perf_test` will have::
+
+  # cat testcase_default_gen/dirty_log_perf_test/default.test
+  dirty_log_perf_test
+
+Runner will execute `dirty_log_perf_test`. Testcases files can also provide
+extra arguments to the test::
+
+  # cat tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
+  dirty_log_perf_test -x 2 -v 5 -i 10
+
+In this case runner will execute the `dirty_log_perf_test` with the options.
+
+Example
+=======
+
+To see all of the options::
+
+  # python3 runner -h
+
+To run all of the default tests::
+
+  # python3 runner -d testcases_default_gen
+
+To run tests parallely::
+
+  # python3 runner -d testcases_default_gen -j 40
+
+To print only passed test status and failed test stderr::
+
+  # python3 runner -d testcases_default_gen --print-passed status \
+  --print-failed stderr
+
+To run tests binary which are in some other directory (out of tree builds)::
+
+  # python3 runner -d testcases_default_gen -p /path/to/binaries
+
+
-- 
2.51.0.618.g983fd99d29-goog

