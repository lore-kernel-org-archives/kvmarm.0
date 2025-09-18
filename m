Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532A82309B9
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 18:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218511; cv=none; b=my8EjosyHPbwjms/z0OlyVUzDcfLrRj7Qzn3nNC4alKnaAizX9c9lnm3u4hUoMsCgOJExYtpmI434C6c00u9e3VvCRbB6Fm1FWPnRWm1sJjeSo8i2vJAjnS1zwH5bXMBDvGLlP9+k+BQl7zbyNXiqt2CDcWUTTE8yrz5uLqrDt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218511; c=relaxed/simple;
	bh=C1MZGhMDAty4en0TQUdA7UUtP4wMbfS91uN7qIdATBk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=K8VcuLRVMuQnyDN6l+cbCYZK1UTnzVNpdJEg/VwAtvRGOkFSc2BRiW52ZrRTPqt2erR1UMvScEC/qnPHObL08TUmaopRPOXA7iuMydPXUqQdLiAW96o3+uJ/4vY+8BGsjzEys8uwPVheTPHVOuzfXCgW5p3F0AAJBNXGN8drlHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kc7SM/Fu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kc7SM/Fu"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45f2c1556aeso4786615e9.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 11:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758218498; x=1758823298; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6AFtYNgzFlGUfnCDw9OHKWnsFrL+D8ATC1/qMSs/P0E=;
        b=Kc7SM/FuCf+Li0fLlzPswlSaUfuUTRUeDvI4FF9Ln5AIIZGZdXv6CfbTHf8fnnZYvk
         tJJrX7Tc32l9hADbw3p06TMDwvEPlQKwDr0uxIt0Raj8q0M1nO5I2W3wUVgTp0ZsvMzG
         NQP/7sbwmc5HertzqsNpDMgRUS4SJfeDkI025W0cLfoxInZLIGKakOJGfs8Ql2DvP8Jn
         aFMZdxFx38MaP7Lph+U7YqJSVA80Do2ObsXmcBAF2iBjAWBrvqLYWJZyRXd31N94U+Hz
         9uT0sFGG6Dl6zK8ebSdOXayM8MRUdZU/vx4G/dhIrSmqiQyGcXQNmKRyvd2XWOOusk0u
         PUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758218498; x=1758823298;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6AFtYNgzFlGUfnCDw9OHKWnsFrL+D8ATC1/qMSs/P0E=;
        b=F70J1yPkBwu9l87ZwhwhAvDcGsT/GIV7nrxDAIb9l2xvv0mOSarFvkwMgdP3t8BfnC
         UHEPiYc7m8SY9yo+DnwP3P0Or60ffq7JZuys63Ka3nRMWR9MKjHbgtdzvqx0mZGN29aE
         fWNdpPyfrSVQsVO4LtyELv4KXN0KHbGaTPsy0u5I6F4gwWLdKK8DVDlu/PBxwBUt2HJz
         q7jYLDfDBF9gwaTHnlY2bLZfHeKhJDFdclmX07y8kcrwk0LuFAz86D0OplfLzxLnxR7r
         GObbupSTx1jXsaSjfBx1zo5/QYdlus7Evs30wlapaXdym/7x7PFRzP7YpBpGKof6Ewtk
         92vg==
X-Forwarded-Encrypted: i=1; AJvYcCVSzdT0FZ2CNCgVnC6pP/eenhGMwTDQNg91wQCvlTpE4ROzY6uYKTS9Uua1G3oROr9v+IGz02k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8bYsm7lmfA8Hb8hEzv+exvRBIGay81nJUt8Zn3o05OI1TRp1t
	LIhV19+IMJcoSUwILpCzazpeqBVL8rbFGnuw4xHu/uIFVuS3wiAhApgDN4eH68FByuqtGZXIq2z
	aIh+5tqutFiJdWPIU6qAliA==
X-Google-Smtp-Source: AGHT+IE0s3mgC68bYqXT2U/+o4HoYc6G5jDuhQVBgFNX5eIHGXZ+lKBwfO0ohqVmckXSTclutoo8kufdndZGfzQr
X-Received: from wmqd2.prod.google.com ([2002:a05:600c:34c2:b0:45f:29ca:4f27])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4451:b0:459:db69:56bd with SMTP id 5b1f17b1804b1-467ead682c5mr1151005e9.20.1758218498702;
 Thu, 18 Sep 2025 11:01:38 -0700 (PDT)
Date: Thu, 18 Sep 2025 19:00:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250918180050.2000445-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Validate input range for pKVM mem transitions
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, sebastianene@google.com, keirf@google.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

There's currently no verification for host issued ranges in most of the
pKVM memory transitions. The subsequent end boundary might therefore be
subject to overflow and could evade the later checks.

Close this loophole with an additional range_is_valid() check on a per
public function basis.

host_unshare_guest transition is already protected via
__check_host_shared_guest(), while assert_host_shared_guest() callers
are already ignoring host checks.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8957734d6183..b156fb0bad0f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -443,6 +443,11 @@ static bool range_is_memory(u64 start, u64 end)
 	return is_in_mem_range(end - 1, &r);
 }
 
+static bool range_is_valid(u64 start, u64 end)
+{
+	return start < end;
+}
+
 static inline int __host_stage2_idmap(u64 start, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
@@ -776,6 +781,9 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	void *virt = __hyp_va(phys);
 	int ret;
 
+	if (!range_is_valid(phys, phys + size))
+		return -EINVAL;
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -804,6 +812,9 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 	u64 virt = (u64)__hyp_va(phys);
 	int ret;
 
+	if (!range_is_valid(phys, phys + size))
+		return -EINVAL;
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -887,6 +898,9 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
 	u64 size = PAGE_SIZE * nr_pages;
 	int ret;
 
+	if (!range_is_valid(phys, phys + size))
+		return -EINVAL;
+
 	host_lock_component();
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (!ret)
@@ -902,6 +916,9 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
 	u64 size = PAGE_SIZE * nr_pages;
 	int ret;
 
+	if (!range_is_valid(phys, phys + size))
+		return -EINVAL;
+
 	host_lock_component();
 	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
 	if (!ret)
@@ -949,6 +966,9 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 	if (ret)
 		return ret;
 
+	if (!range_is_valid(phys, phys + size))
+		return -EINVAL;
+
 	ret = check_range_allowed_memory(phys, phys + size);
 	if (ret)
 		return ret;

base-commit: 8b789f2b7602a818e7c7488c74414fae21392b63
-- 
2.51.0.470.ga7dc726c21-goog

