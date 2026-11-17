Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937476;
	b=3EzI8CQyXQKMjstSjnKzASMm1UFmVv0tijs0F55WUTNwvAIAxRVwkUI5Jj1kLx8gOITP
	 +qK7xHNkDmstcTvILbVfqqkyQJizqcONxOGLPVNoJr8+ZVELsCJRCbtIZNJSS3ZNLhvrY
	 6EY79wA8wkB2JMuu4+cjlRjlQ4PttKtvdbdy/Br8z4wlwdW0tbRGzQODZfGncKhInz20C
	 NNhj6PdJvOSERXi/M32NG9+b9jwfJNZN0syWFTv78Odn+wJBoQGx6KnqWZqJEtqP9tM07
	 cPUfvzSfZtu1SLiklFHCnH8u+aZ5hC7PLP1nFnBwtsP0nU9aBRL2dUOt3aswKBIFViQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937476;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=kOOB7/7inZWgB6bfqOXg88UlMwSiIOg40Npokp5gZO4=;
	b=LWbYQ/p4S9iOdNXd/yXBjxpgXzRGQ/S7zHJOp7n0NtgL62t8lj6mXy2Px6k1iA5VmOS+
	 /zxono0Kl4yebhkBjGUjdqRKwQYk2RbwFi0Ul2gZWhWysp8XR3ci3lm3cYqTIUOhTzBKJ
	 yohafdh4Nj4JuDBIPSnU4cwkYKYcOSnoTINP4l94o9gc3ssZfkowVEUMywG2RxuBHXQDB
	 yl8gB0/qrrkbsWXpWDtHmICEmRCdcBXVXPlqjuJyX0qR5JeFYXd70mg4Rmhodg/OSYO4/
	 1wDMhboaaddxRRfZ0KrEFE9rObP/RW6AZ4EWbjf+4l6scPu75CH+PzFyrHiEub4JsiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WZ4namz1;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C823606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C823606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WZ4namz1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4a339a24cd1so23473f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937474; x=1795542274; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kOOB7/7inZWgB6bfqOXg88UlMwSiIOg40Npokp5gZO4=;
        b=WZ4namz1J1Oh0NRleSn/Lrn/uhUlcXoZZFT6J60ef0yLWZQJ+g1DJvrsme4qsZakJ1
         3SPtIhCitg7J8a1lKhhIlpTaqBsV1Wi8Ei2GKWBWDBeT//aMbHqqwBXmsX47EFYlvvO5
         +DuRFxB5JiYuxe7V/oiea8LUQO+xrmtY43TBK1hH0YwoGvm24ScV9T7LtmL9l3EhdAIS
         YitOVcD+MwgULnzUxa7WcCe2AVT8TrewSXwGWAM1Ouj4PsQ9VgmNuqLwWaSa+i3bZL9i
         VIm3tz7W72UVuruVOBHqzo7hH4mdYK9d+U9Xml/OUaWQ8SEH2bV8PthUsCT3Wo1fttav
         pGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937474; x=1795542274;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kOOB7/7inZWgB6bfqOXg88UlMwSiIOg40Npokp5gZO4=;
        b=efs6MNNTqJqpgwY0ucxflqm3y7szvb/zcG7FA2JLHQmMGTuoAMq4Coj5nS3BzgNuIh
         JMt/6cUq2OmclpJkGZMzML/jnzr3/LECA25Wi/QZ3nB6ao9IPxmGw/F2hZqmshDOSENy
         ZzHvUHUOn+Ds0WxvxR40sqCkhVVFQ7qF5SOYZxG0bFd++YKsTdtaeJwO/2mhvAGceL06
         5ti1/CfYF+ljaosvjimLvgWkeR47gNfOnnd6C5rDEXxoPsCifrfvSmLKxIU3jsHqDzJ+
         cGyVOe+Y26QpINplF61GtTFoMk+nPjCXgg6WnmL804ZFwJZHAnE27HvWcx57SEYAhl7Q
         a7VA==
X-Forwarded-Encrypted: i=1; AL+hErHosEEtke5/3NJwlXJJOhRUr9j5aviCYkYu6HSnvp9RA/da7FrjmUnKMdKV4nbLCHKkb0FFRa0=@lists.linux.dev
X-Gm-Message-State: APuU4Z9jwB6thzvuwgHZ1bxVE1RcG3xu8GfXBGFIkVtpa8AapSUlFDcT
	ByCLU2+qsnB94QzEcyE3y52cmtGiMv/H31L/3yZ+CvD8/ZNU+/LiVejMfICrJVCGvWIsWFjej8p
	NSyRY0uJm6Giiiso+NaOr3g==
X-Received: from wrnb4.prod.google.com ([2002:adf:e644:0:b0:4a4:9fcb:c0d2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:25c3:b0:4a5:8e3c:8946 with SMTP id ffacd0b85a97d-4a63a2d6fefmr432385f8f.27.1794937474303;
 Tue, 17 Nov 2026 09:44:34 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:55 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-17-vdonnefort@google.com>
Subject: [PATCH v4 16/23] KVM: arm64: Warn on pKVM guest stage-2 block collapse
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

When pKVM is enabled, the host relies on a pkvm_mapping tree that
mirrors the actual hypervisor-owned stage-2. The hypervisor is not
allowed to silently split blocks or collapse page-tables. This should be
treated as a bug.

Therefore, WARN on guest stage-2 page-table collapse which would
otherwise be fatal anyway.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 751f76d3ec39..88af0aec1ea9 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -226,6 +226,12 @@ static void guest_s2_put_page(void *addr)
 	hyp_put_page(&current_vm->pool, addr);
 }
 
+static void guest_s2_free_unlinked_table(void *addr, s8 level)
+{
+	/* We should never collapse guest stage-2 tables into blocks */
+	WARN_ON(1);
+}
+
 static void __apply_guest_page(void *va, size_t size,
 			       void (*func)(void *addr, size_t size))
 {
@@ -294,6 +300,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 		.put_page		= guest_s2_put_page,
 		.dcache_clean_inval_poc	= clean_dcache_guest_page,
 		.icache_inval_pou	= invalidate_icache_guest_page,
+		.free_unlinked_table	= guest_s2_free_unlinked_table,
 	};
 
 	guest_lock_component(vm);
-- 
2.56.1.708.g77570a6a1d-goog

