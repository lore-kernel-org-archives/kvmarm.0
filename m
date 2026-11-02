Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652430;
	b=hTX+E5L9BB4TXKCSUjQDi2eqtHI9HlOV9WC4pqozfxol2SR6eYP/yeD2AKSLW9JlNrn5
	 Sp1Oa+O7Ii5jPpuvYL9BSoHe9lkFYjsSaEDyUmk76aSUFXp9Ke/7XEmcXoAFjXig2Lru9
	 ZjP2j/dlvbysp3fxrWfS/EfQoYxgtFJdUvxmln/jJdzZfom3wd1i3+sXSgzCv1fe9xfJZ
	 xGZowOrJrW3i7Dt2thuKpnS6yS7Yzvj2fQzPQ9RrHLPBHimt5e1y4O9Z+8nV7OFBx9E1g
	 9BVBbedbEvgimwJ1RVPqK3852lb4nLlRXhbB9LaHOocNGbP25afMHhwUrE74A+okErw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652430;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=KQoOyQvr1Yf4M6fmXMMxMW5LFm9ZNQllsr1s7UwFllQ=;
	b=ii5lcwfcK3r/8z6lieEXNst0b7zhnB26uZaHSjcledeyuYBUurw/EfJkaVxxXM+bmK+Y
	 HXUxOv5UM9jrFZ+Q21fOJoJfttYxE4czGYmldwNOwtUKmgT+4j4khWWxd3zontx41DnF0
	 75YICNK334+7uWHMUVXBCOa9yTaZwT6+vGVl+80BU4C3StwYO5B06Vtm4ZWPwGPlydbKS
	 cajUAVBKPpxonP/FN1yGIhcFmSQ6vVIFtLdNCXFDozV6pmsy3QbqVUs/oeRs3SjFJb4H5
	 SrY+PcDMpPUjmudwyMFwe4w9iemi3WMNdXCdl6SmiGU9grEKhMwsh2yVHKmIeuydbuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=myf5fea7;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7126C606A32D
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7126C606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=myf5fea7
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48dfdc0f491so1844033f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652428; x=1794257228; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KQoOyQvr1Yf4M6fmXMMxMW5LFm9ZNQllsr1s7UwFllQ=;
        b=myf5fea7fqQXYuiFFDOKAot+3It57EPRSDqBtgvT9FlYjy2aoOvJdPLrPlQmDYC6bN
         XaWWJI0ioY+mbA6x86mswPCS+/oKsKLmNEziBO2rXveDv8x2T1fSiLhZcA68upPa6uwY
         sE+kodO/fVuIu/sgyvcxVc33xmybCiGJZsyPRVR0cvTkAI/+HQouYMxfIecq/MfP8fuX
         pl4S9HmFgMDjc5thZi+y9jL47AUq5FheugKNgFyMcIJMWL9sgpUKPKa6ZY3kqZszWvhI
         5+6KzjSm/mlRoFN5FmeuFrauSMP7pXPJZqZz2uY3acrNX/9b0i0Uon/3lACSeRdgvieK
         IIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652428; x=1794257228;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KQoOyQvr1Yf4M6fmXMMxMW5LFm9ZNQllsr1s7UwFllQ=;
        b=WblVOlG0Rf78ECsgXWSN1Tj6Zvz76811Jy8cYbdyZB+/LdNUS1hhZXEGS7vq2T6ymj
         JehFzB69IXI9ZzdEBhAzTnhFps12wHk9Fcy0GDSMbnAaTNrutnQIEF7jArMQ6yVaFCAw
         T5fYx/5AYHhMqTCaH0n6zPHFcw0y+vOWYuS3PjN1QM17b2sKI6P863WFVjX3O2YxgFqk
         6BNqm6TAh+yB3dBBl1LHtwPXlPsujM7hTmNMvlNsKpIUVNvP0qxU/UqUVev0soJhyNX0
         84BPRf0yytdKzvQIcE7vS32XCyUROOSnKMlx+DPZAt1GfFRaWlj6z9jlmVH7y8FIsZco
         VcHw==
X-Forwarded-Encrypted: i=1; AKwUvBxFTPraQgKlP2WkAzaiePdeovlcStR/gZYkDPrFQ99nnLLq7KliX0Yo6bsb2pCAnpLqGUMNm60=@lists.linux.dev
X-Gm-Message-State: APuU4Z9MDntl8gXQnp+o0DOa204zjivSa/N/5IlQiIFlu+Ff2QVyM5xw
	39i4PNNImWbgZejnSHWOSUOtxDOMqB4d9dulcul9MIIacBXe3X2BVuJ8I/cy/6NvsY00iiigVCb
	60iD2rhKF12IVdi4gh7Dzng==
X-Received: from wrmh7.prod.google.com ([2002:adf:e987:0:b0:48e:3c18:27a1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4908:b0:48e:7470:9e98 with SMTP id ffacd0b85a97d-48e74709f70mr21406431f8f.39.1793652427656;
 Mon, 02 Nov 2026 12:47:07 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:11 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-7-vdonnefort@google.com>
Subject: [PATCH v3 06/23] KVM: arm64: Reject zero-sized ranges in pfn_range_is_valid()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

pfn_range_is_valid() validates that a [pfn, pfn + nr_pages) range fits
within the physical address space, but does nothing when nr_pages is 0.

Luckily, there's currently no existing check that could be evaded.
However the pfn_range_is_valid() should make size trustworthy and 0
could be problematic. Explicitly reject 0 range size.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8d5bfae67396..385a7ed12b3c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -400,6 +400,9 @@ static bool pfn_range_is_valid(u64 pfn, u64 nr_pages)
 {
 	u64 limit = BIT(kvm_phys_shift(&host_mmu.arch.mmu) - PAGE_SHIFT);
 
+	if (!nr_pages)
+		return false;
+
 	return pfn < limit && ((limit - pfn) >= nr_pages);
 }
 
-- 
2.56.0.385.gac671c819a-goog

