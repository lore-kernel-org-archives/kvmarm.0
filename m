Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BEF47D952
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933153; cv=none; b=DL1cBF0G1zWogD0EuqDjh5aNYJKH+7ZI1Qf168I/wHG0fqu+Gj1KjjJL85ShzryyhnNUq4MbqmwhgsWCn6rgZeM678X6301GVHbitdtOHlo/inKDr2l7McUZhMXF8CXqfyDfuhHe+BavXp5Ijj+wTv3CPgx3H/7BU6DYQpLyRBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933153; c=relaxed/simple;
	bh=Y1uk7z81ukhofe/vSmwFM2Y0N/XlaFoNJ7JURZkhshM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIwTALdqZJy0FOhegyMFNjfbw2JH502SB4hUbQoV+Mqy5wam5AC/xjL1oQyOMi/eYfFwhzlty695/Tl/uP0PUY19PbxqU8WRdpCbmAXPGqH1fY+Im9Tna9WoCC+O1L8BBx0Usx07CEbeU+yjfLmaeoyk78Hb5pX0K+yz+sTtC/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=KGsZ6cN4; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="KGsZ6cN4"
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-8961cca9193so28171237b3.3
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933150; x=1790537950; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8DswF+PpHLQLFXIsTsYB07zyWStQD5M14yzCJNkAmPg=;
        b=KGsZ6cN4x7NtM6Obme2IHbQCn9NuOCuPHynIrAS/oyTe8Mh6PXw7mfnLIBQPScIMiF
         DnZKkVAKVxnZcqCFNJKmn/aYtXA6pcZYHCiW1mBMlOt7huR2fS+t5IeF4RWydi/2LfWm
         G+gxNOD772MMuCcX5a+tYYaaqavtmCHzckgePfOXyYK/mCA4DD1Aw3JjMpOQOuWH4lPQ
         MzCGvNecGrR8IjRH/bZ+bDegWiSdVHY3lALq5Kl2ta/feCuXh3R01jN2OKt3az76gGFM
         uMl+ahHrFGd+fwkdkbj3Gm3KnhqOW98xPd08DYCgv9Arg+pLJMrpVhz9MZUF4OR21ffo
         nptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933150; x=1790537950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8DswF+PpHLQLFXIsTsYB07zyWStQD5M14yzCJNkAmPg=;
        b=nvCBjyYpMgiD0IQv1/ZcToGlM6iziLCMXS6GZZ5DFOS3+KptPcBafs+RBJ9o0EhXIv
         BAKfRHosf8jmJq/FLMwH3ytTiCC8CZxxCxavzf/CV74rIrG1jfaOXugO76qcgD3fWyNy
         gwFFQq4Zp50s3gYRKq/6b1spoBtqYDTdkdpCwIFT5akR9UHnpRmJIvOvZHReWOAgscMf
         EeK/4p/uEfHGjq+WFy+0SkaQEq30v8fQFYEqFmQgX4t4q1Y+3ZUstE5iDSxP+UPw+MN+
         l8CD1dhz3gnoYcqrZAieKgH/ia6mmPAgzcU8MIbo68tuYFUiho+Idfe43fE6e9KgUv/k
         cwZA==
X-Forwarded-Encrypted: i=1; AKwUvBwBsOUF/tMrqCV9w45dOnTVLDBGHafXFz0P9SllhDpIHmMEIrHiRnMKmWXJxodCARGDDutrwqQ=@lists.linux.dev
X-Gm-Message-State: AFuF++n3wPcU6RVmnb+uDVLz7mks5NSzPK+PujPGfLln+5oMuLVY4KDz
	APAGmF3kBr6WhZoKOtXyUhvIJn/9kxDD2xtP6iy9f7bXJne2/IDv9cRpC7zoSi7Kv2I=
X-Gm-Gg: AYBFou2025BUKtqY3KsZWB6ZvlOeG3B/JKXb9rf7AX5v2d3zFfgh3IHgoIaqxVVEvXF
	ihzg8XAtMfABgmMobslTmxVub/Z30TQtC6DM4IVT6SL2EpapURR7GEuMPvBw0f+HNfEHHN4kc2s
	xpYh0r4IGB3UyOtiYX15TO5bMl8KKxaqUMmezLWgra1ILtXQ+gog3nOWppKVPxlfiKwrUePeN/a
	Ya2G8vneE7M8UVd0W41odJxwYKHYFVkN90XAKy33he+jGMfdE9XomIamnCquRSfNWIt6bpoWjnp
	QXYcdeZmzFWJ6YVaHCCLVe2pcoIBXhRc//UWzU1/NXPpht00Sue8fo73mHhEgdWLHPunUJtXJhF
	Ee2gFJdtxtDwuK07FtFYMufs1jHhH8T/gZpd0js9JHJeNgbL1QFnNcJoRrXhTebUx2KkVQuQfPj
	kraqQ1a+35ynAXI377VwS34hHx7QuSDgRkkYmk+Phii2+IWtPycdVnVnOj24nR/vjVhZu/k93Mc
	jKhjwuO/D9P5eFP+nfef43GgEKbvROQwN7KmXg7V+I9JZHoD9ngM8ZZDPhOq9DKSYgvSDHcjf9M
	HifFTX0+JfiIkWfasSM=
X-Received: by 2002:a05:690c:39d:b0:89b:6b8c:8edf with SMTP id 00721157ae682-89b6b8c9360mr12390877b3.50.1789933150155;
        Sun, 20 Sep 2026 12:39:10 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a41521471sm19169577b3.6.2026.09.20.12.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:09 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 23/46] Documentation: liveupdate: Add physical CPU preservation documentation
Date: Sun, 20 Sep 2026 15:36:27 -0400
Message-ID: <20260920193650.3373435-24-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add documentation for physical CPU preservation subsystem, workload
attachment API, architecture backend hooks, and KHO serialization ABI.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/liveupdate/cpu_preservation.rst | 34 +++++++++++++++++++
 Documentation/liveupdate/index.rst            | 11 ++++++
 2 files changed, 45 insertions(+)
 create mode 100644 Documentation/liveupdate/cpu_preservation.rst
 create mode 100644 Documentation/liveupdate/index.rst

diff --git a/Documentation/liveupdate/cpu_preservation.rst b/Documentation/liveupdate/cpu_preservation.rst
new file mode 100644
index 000000000000..a7a534188685
--- /dev/null
+++ b/Documentation/liveupdate/cpu_preservation.rst
@@ -0,0 +1,34 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+=========================
+Physical CPU Preservation
+=========================
+
+.. kernel-doc:: kernel/liveupdate/cpu_preserve.c
+   :doc: Preserved CPU Subsystem
+
+CPU Preservation Workload API
+=============================
+
+.. kernel-doc:: kernel/liveupdate/cpu_preserve.c
+   :export:
+
+Architecture Backend Interface
+==============================
+
+.. kernel-doc:: include/linux/cpu_preserve.h
+
+CPU Preservation ABI
+====================
+
+.. kernel-doc:: include/linux/kho/abi/cpu.h
+   :doc: CPU Preservation Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/cpu.h
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/liveupdate/vmm`
+- :doc:`/mm/memfd_preservation`
diff --git a/Documentation/liveupdate/index.rst b/Documentation/liveupdate/index.rst
new file mode 100644
index 000000000000..415ac748c9f7
--- /dev/null
+++ b/Documentation/liveupdate/index.rst
@@ -0,0 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========
+Live Update
+===========
+
+.. toctree::
+   :maxdepth: 1
+
+   vmm
+   cpu_preservation
-- 
2.55.0.1082.g2b9226bbc0-goog

