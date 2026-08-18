Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9597145DF67
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 11:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052570; cv=none; b=YM8/eO+Q5Fk8ln5sidp6BerfAWA4N1zZ3Nl72zDWMwGbwS+GE6rj9jirw1wDQFGrZwjI6pp23fHbFV2AYgwxj/EQHSheHFKXcR5GNei8WN6BUJJne8/4uzMEOu5FZXyborc2ZffR39iFXC71ZRf2bsU8Wj4oSO4TfTtjguOvn+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052570; c=relaxed/simple;
	bh=PQS+rhRuPKHawTipTzrfvIQnxbml1r89m5PT9iaRz8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWP5eIyJdmwR05J+Er+0wSdK2RVnRhsTD7tmZcdezgHhh+Kf5qP1hfipFzP+6YLDVKOkit7cAl9Ddh1DNiY0nVxSVn7xc5vgRHMA401gyzt2PZ/M3p0CHt7ZS5XjOGx0+Ie8xMmMjiXdUSmhea0pE7XNXrKMmM0fLCs1bwIunTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nR48uzL8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nR48uzL8"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38dcbade417so4485245a91.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 04:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787052568; x=1787657368; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GjeuzllnPcqvxrpejMrz9/eK7KMKWWQACjRt8b0xaWE=;
        b=nR48uzL8qnN9PiKXFpFYOeFcJM6/06AKpyapchxI4NIdwVqq9jlOVhFD/UAPUIxmaJ
         KZ+uArI5Ct9qN0Sm3+mJ/hD/XNzrBsAYhykFaUH78Rkx8rExW2c7z5tOMzyLL4zVGHC0
         LtehavYKzuDEY5ZIML95GO8RRcrpnC3aSUeRotdT5hVLcUybl4AKsjLzM0mpM+eJp6dw
         z47XNHcyGjvDawgUa8Mh81Ff/uTEII4oHPY+6BOC6GBLI0YYviU/T75183vwNI04UbJE
         9OXC+JpocLraWDUbem7RjjISvwT6ZKyYfCkcaJfVCaVEVuBzOhdQshR5fAbX+wodZ75E
         aMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787052568; x=1787657368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GjeuzllnPcqvxrpejMrz9/eK7KMKWWQACjRt8b0xaWE=;
        b=SjEeG19w0eKLj4Zma6g2wHI90s515CcsG6sw3m51OGfhwbvb/EtKRzyzJNyzC8qda0
         7apLBFgXfqznRf+T3jD9B682bDriblV/ingivUJ5qvZOXlEW5MNPGcTyrONZ6ZaxZZU7
         kmvE8AWpp6fSfa99FC++3W3pyRx9NjfNl6I6W2M7Xs5Z/986gNnROTmeeZ+xyAoI2sMa
         gaRbYPJXJfrSLbi7c+bKWS2z9JbzKpM9C7hMewIkuRBioJjC8MKJQGmBvr36sJVYf9cf
         E8W7XFYToz4WM4FoOUeOCm4MDWbNOJg0K7UaWydYrwQwDvw48rzm+O0WfzQ4/bdBiLNR
         fzpQ==
X-Forwarded-Encrypted: i=1; AHgh+RpdrBQ7KkpsJtjpFfJj9QreKHpxX41OsAl0mCzeOPiZ9pTaPJVI0yEgEINlszgcZ2xtXim4J1Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLozz9FbP4mkAvMQiDkWZuyBMIY3Vdokzvuzm55lBjxz6PoaC+
	5S8H1yYMmGj/ufmn7/4iYQgUx2ISq5wuR/OMKv7iMw6/w2/fZfAqOFpp
X-Gm-Gg: AR+sD13fD+aqGQAZGZCZDGTwCKcKzXx+K5CYEpf0yYzD4zbR+vR1ker6c1xGLJRORpm
	/x2tUG91z+GKAAELuPPd4YmXWHdHztdwPZv1xo3u7Aa7A8B9HpG0KCz5W7YcYJSBOcfBlcFRUxF
	bHd43wmBl8yNz8Zmz+FKbJebxVMR3fjunsCnvWlMSBFvwE05WkoZc5/g8WDXy+QjVjVnM6uvStE
	fThHeLVaJQNyKECA8TCHlDi6IIzBgwKRUuB0yH+XcW6fqRTpSK4P/pWsipb+iAtTBCFLmePZfpD
	eIU/lG9eV0ApayOUQjqyfrpciYwhK3nKl+c9xU00chIXKmw54DVoVHzXFWKbJmXHDFCYS3tFRmL
	YSJpTeNBsH0jxOSgLVpC4nnzD9RsiumROuFCDcRH0irOpd4brAe/J3/Mcxa5RzsBtVSxa8bb8zr
	/mcHpKRq66kuOD+NtfuPSNMAklSJyR/69cLorsMZgbV6lXLe9/i74qvVOu62nidhlL/xlrXpyVy
	JK3u5i8dEaAcXla
X-Received: by 2002:a17:90b:5685:b0:38e:4cb:51f with SMTP id 98e67ed59e1d1-3955a799fcdmr11206957a91.11.1787052567884;
        Tue, 18 Aug 2026 04:29:27 -0700 (PDT)
Received: from LIKEXU-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e31a9dsm8423420a91.4.2026.08.18.04.29.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Aug 2026 04:29:27 -0700 (PDT)
From: Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: jiaqiyan@google.com,
	kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: selftests: arm64: Fix EINJ handling in sea_to_user
Date: Tue, 18 Aug 2026 19:29:18 +0800
Message-ID: <20260818112920.26252-2-likexu@tencent.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260818112920.26252-1-likexu@tencent.com>
References: <20260818112920.26252-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sea_to_user drives EINJ injection through popen("echo ... > file"). A
failed write is hidden behind the shell pipeline, so a botched injection
is silently ignored and the test proceeds as if a poison were placed.
Drive the debugfs interface directly so a write failure is reported
rather than swallowed.

The EINJ support probe is also unreliable. It checks the ACPI EINJ table
with access(R_OK), but reading that table needs CAP_SYS_ADMIN, so the
check gives a false negative for unprivileged runs and skips a test that
could otherwise report a real problem. Probe by opening the debugfs
injection interface instead and classify errno: absence means EINJ is
not built or firmware lacks support, EACCES/EPERM means the test is not
running as root -- both are skips -- while anything else is a genuine
failure.

The injection path is only reachable through debugfs; the kernel EINJ
driver exposes no other interface, so the test must depend on it.

Link: https://lore.kernel.org/kvm/86y0le9cvz.wl-maz@kernel.org/
Signed-off-by: Like Xu <likexu@tencent.com>
---
 .../testing/selftests/kvm/arm64/sea_to_user.c | 45 ++++++++++++++-----
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index e96d8982c28b8..1c2a743ca8e23 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -81,25 +81,46 @@ static u64 translate_hva_to_hpa(unsigned long hva)
 
 static void write_einj_entry(const char *einj_path, u64 val)
 {
-	char cmd[256] = {0};
-	FILE *cmdfile = NULL;
+	char buf[32];
+	int fd, len, ret;
 
-	sprintf(cmd, "echo %#lx > %s", val, einj_path);
-	cmdfile = popen(cmd, "r");
+	fd = open(einj_path, O_WRONLY);
+	if (fd < 0)
+		ksft_exit_fail_perror(einj_path);
 
-	if (pclose(cmdfile) == 0)
-		ksft_print_msg("echo %#lx > %s - done\n", val, einj_path);
-	else
-		ksft_exit_fail_perror("Failed to write EINJ entry");
+	len = snprintf(buf, sizeof(buf), "%#lx\n", val);
+	ret = write(fd, buf, len);
+	if (ret != len)
+		ksft_exit_fail_perror(einj_path);
+
+	close(fd);
+	ksft_print_msg("%#lx > %s - done\n", val, einj_path);
 }
 
 static void inject_uer(u64 hpa)
 {
-	if (access("/sys/firmware/acpi/tables/EINJ", R_OK) == -1)
-		ksft_test_result_skip("EINJ table no available in firmware");
+	int fd;
 
-	if (access(EINJ_ETYPE, R_OK | W_OK) == -1)
-		ksft_test_result_skip("EINJ module probably not loaded?");
+	/*
+	 * EINJ is exposed only through debugfs, and opening it tells us why it
+	 * is unusable far more reliably than access()-ing the ACPI EINJ table:
+	 * reading that table needs CAP_SYS_ADMIN, so access() gives a false
+	 * negative for unprivileged runs. Open the injection interface and let
+	 * errno say whether the test cannot run (skip) or genuinely failed.
+	 */
+	fd = open(EINJ_ETYPE, O_WRONLY);
+	if (fd < 0) {
+		switch (errno) {
+		case ENOENT:
+			ksft_exit_skip("need CONFIG_ACPI_APEI_EINJ and firmware EINJ support\n");
+		case EACCES:
+		case EPERM:
+			ksft_exit_skip("EINJ requires running as root\n");
+		default:
+			ksft_exit_fail_perror(EINJ_ETYPE);
+		}
+	}
+	close(fd);
 
 	write_einj_entry(EINJ_ETYPE, ERROR_TYPE_MEMORY_UER);
 	write_einj_entry(EINJ_FLAGS, MASK_MEMORY_UER);
-- 
2.50.1 (Apple Git-155)

