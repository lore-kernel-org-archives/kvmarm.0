Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798744;
	b=FAjCwlC4cRC2f4azm81NjzFB0pOPpNrp15qCSYfCeyGEa8VZCZw1AsXVpy9yvOXJHQbp
	 CyOqAAuSyX+h8I5kOFqjkj7mHSIYpZcbciv0racMfgVrwpGrdiibO8F7qAYsRpWCN3hLz
	 eU5fjcLDMBR1mHdJjw2d83zgiRcewwyexr0eJEm4oaenMfLzikRBsxQM8IOw8+QQxVl+q
	 vp794bCy6VmwcGMcLYmdGh+T70fHIzAUdsg+dkQresuMAfIPeCVQj2XZiiHCGB9JrJ9HC
	 HIE8XvOfl7YIq8y0p8I/AF8NZ2T/A/bbdQ+ZpPqH4VrqfUuT0NtB6lN38AJCdYr1M7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798744;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=esRSTx9IpL/ybW25VHcD6mzBY2hlIDI+k1S943K/5/g=;
	b=kVw5JVfdnagsmBjtRlH2u1CM6glbvc2F9v8BiOTeVFrvXErIRChaHUQ9unXpnbESoZPK
	 5qo/Ku6IQZDAy/Ro8fMqsOv9V8XiD+pFaWDdO1coH9XgTE1DODIhKFig8se4l/re5rdrO
	 OOSUGkZNJ+i/aNLOP67GIM6EF2giyQdzv8srQp2Y8O6ADvMTf1EdnuF/uS+jyK/AaICbQ
	 KqbUnENJAFGTgO3bS88Y9I14ml0HtGw9NW0hdeb8LCdVpgDAU3kZPd4Emd5mblT/ZxlHD
	 l7qLV8HO415FvIXkWmeeLLEW/TkNvjy8Zl9PlzU8qg1uhl2igk2xWtdBgU4fInvm2DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q9DwIr2K;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAEC606A32A
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 16:59:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AAEC606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q9DwIr2K
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c4163a5400eso767822766b.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 08:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795798742; x=1796403542; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=esRSTx9IpL/ybW25VHcD6mzBY2hlIDI+k1S943K/5/g=;
        b=Q9DwIr2KO7zIJx4thAdaQoY9nQaOK26gM6CkEGpYyBh5qxy/YWIEd0QkeSbtrbg7FO
         T1oksoIygZbUUEHng2EfQg1ToXXDRds5D55lyD5V9129/qlsNS4WOLpxcB5LikJaXdUU
         QgAqMHHBmN2ZR1yTEzJbMOsdREqJG6FWg4wLYBG1LJ6Me9KkHMlQg6ieic6pXncmNPrM
         LHCxh15Y2+ovrBiDvR2IRhxYziCUxjUheaHA91YvEkONXi0o1rKRdp+f3MPoPpxdeMW1
         oIHRMybPTa6CbH8JFUOtNVLq7ODAV+008CpxoxRwVKOz1zAMWHa8O4HYaUmhp5+tCQLE
         CaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795798742; x=1796403542;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=esRSTx9IpL/ybW25VHcD6mzBY2hlIDI+k1S943K/5/g=;
        b=bUUttH3TWte60t4smZTYZ6VPFd7tZGtS9/KJVKFcA88tCUHNvXp2hMeYV/bk/z7rOJ
         H5F8uVE6Xe37CJTFFasS8zPu/v5h0wJ88MDAIVqiZc0TccvMI804pBznT56lPzxsRY6V
         sSnzxLcsiCSBB83/pOgKlaAWXwVclTy5FKgmZkroygPiymoiXrDR40CbPbLnkkX5AmY6
         P+eo03egRgAF+8+/mRMK+GEtrLQt6Ug0rQLhmBsjcgEKbb26GGA2yv9C3Azk4csvy51U
         meMdGTzs3o0ACpLY2rjHv+Ypb4k46GPamLV2FB9pbjJEdv/OBlbX4c9NjjKiplYs+gKp
         HLIg==
X-Forwarded-Encrypted: i=1; AL+hErE7TS8GkwrkimlCJzWd8zvhYL8wDMU0J2jSywwCQv2NApDdK5iXVr+PIZvY2+9iFzc4bA0aPRU=@lists.linux.dev
X-Gm-Message-State: APuU4Z/okPt2CQ1ryyGZVu/Sc92GAvtDcKZutKBkrvytxkBZhcxom6Fa
	OcaPdlr3LEW7QegKBQ5OZ2svLh9b3YrqOIRtNy5fldMGLsTTYrTrX8DUsPpcY6lFiYZibn9IYuw
	MWzXWX+w1oXBXGa9wTQW3cw==
X-Received: from ejcl14.prod.google.com ([2002:a17:906:78e:b0:c4d:4f51:fd3c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9301:b0:c46:78af:6150 with SMTP id a640c23a62f3a-c5131585160mr2356923966b.2.1795798742373;
 Fri, 27 Nov 2026 08:59:02 -0800 (PST)
Date: Fri, 27 Nov 2026 16:58:41 +0000
In-Reply-To: <20261127165843.709034-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261127165843.709034-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261127165843.709034-2-vdonnefort@google.com>
Subject: [PATCH v2 1/2] util: Use a memoized value for PAGE_SIZE
From: Vincent Donnefort <vdonnefort@google.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The PAGE_SIZE macro invokes sysconf on every evaluation. Promote
host_page_size() to util, memoize the sysconf(_SC_PAGE_SIZE) result and
back PAGE_SIZE with it.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 builtin-run.c      | 14 +-------------
 include/kvm/kvm.h  |  4 ----
 include/kvm/util.h |  6 ++++++
 util/util.c        | 15 +++++++++++++++
 4 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 75e8ced1f421..f06231e382ad 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -401,18 +401,6 @@ static void kernel_usage_with_options(void)
 		KVM_BINARY_NAME);
 }
 
-static long host_page_size(void)
-{
-	long page_size = sysconf(_SC_PAGE_SIZE);
-
-	if (page_size < 0) {
-		pr_warning("sysconf(_SC_PAGE_SIZE) failed");
-		return 0;
-	}
-
-	return page_size;
-}
-
 static long host_ram_nrpages(void)
 {
 	long nr_pages = sysconf(_SC_PHYS_PAGES);
@@ -427,7 +415,7 @@ static long host_ram_nrpages(void)
 
 static u64 host_ram_size(void)
 {
-	long page_size = host_page_size();
+	unsigned long page_size = host_page_size();
 	long nr_pages = host_ram_nrpages();
 
 	return (u64)nr_pages * page_size;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 72a8c3f32b5f..2b7e4b7f4a9f 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -23,10 +23,6 @@
 #define HOME_DIR		getenv("HOME")
 #define KVM_BINARY_NAME		"lkvm"
 
-#ifndef PAGE_SIZE
-#define PAGE_SIZE (sysconf(_SC_PAGE_SIZE))
-#endif
-
 /*
  * We are reusing the existing DEVICE_BUS_MMIO and DEVICE_BUS_IOPORT constants
  * from kvm/devices.h to differentiate between registering an I/O port and an
diff --git a/include/kvm/util.h b/include/kvm/util.h
index 0f5a4bba5714..dc0972061108 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -154,4 +154,10 @@ void *mmap_guest_memfd(struct kvm *kvm, u64 size);
 int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
 			   void *(*start_routine)(void *), void *arg);
 
+unsigned long host_page_size(void);
+
+#ifndef PAGE_SIZE
+#define PAGE_SIZE host_page_size()
+#endif
+
 #endif /* KVM__UTIL_H */
diff --git a/util/util.c b/util/util.c
index ff888bf9e061..c4ee03304503 100644
--- a/util/util.c
+++ b/util/util.c
@@ -235,3 +235,18 @@ int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
 
 	return -ret;
 }
+
+unsigned long host_page_size(void)
+{
+	static long page_size;
+
+	if (!page_size) {
+		page_size = sysconf(_SC_PAGE_SIZE);
+		if (page_size < 0) {
+			pr_warning("sysconf(_SC_PAGE_SIZE) failed");
+			page_size = 0;
+		}
+	}
+
+	return page_size;
+}
-- 
2.56.1.839.g22a8290db9-goog

