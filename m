Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE2F379ED4
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 11:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772711432; cv=none; b=VGJ3PKnwcwVIdktxmGg1NRD2Y1SnsfrFbVLyxPJW1uZCQMKspqKR0RIBoxp7dLaterfe6xyBbx8C9z9OII8L2OzY/pErTn4hTd8WE3u4yEuGR29zeq+q3ha4IJOJTADMwoEORsJS6OWcZ7CWjrIPNv2/pW/WGSRT6z3TQr3jZL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772711432; c=relaxed/simple;
	bh=B6IuDX+Z+QZWtAYjmASMhNyfDVcKx1jmIZcMYVzXPSw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gTyHxOeZWv4nCw347L804bebTXIRrorXU3CJumCUHsTx90vWRbnmQ0D7rdmjawhNAlwAqwGEoSPvoU3GEBnckDXjmlAC9qTSYbmdB6QYf3cNk2UQHZH/u3a8g9Bosb6tIrgaRqM3B4LcJqD4NfH5ETLRbcGaAxJTueX3T47r31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RiGkkZ6K; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RiGkkZ6K"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439aeed8a5bso5040527f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 03:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772711430; x=1773316230; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iUs+CGKlSXZwATM56oVixVPREmsA3EmoDPmnZPV6UKk=;
        b=RiGkkZ6KUDraig1dShU/NxJfqnpyLI6EN4JCZRzhZFQK2WZ2K0oF/fSc6QAy+oeq5A
         PeTLVb8a1EZK6xaspRCZN2ebcteUkioEwbajwldxVXcH11JOdYtDFpOvCN8jGOxN3uOE
         fU4deJJOeJsaUU1cKvxoxZtMd0KnhcbGBm+sJreVoUstMmykV4GLj4Z313CohJ2/MVNt
         ZjpJmBPeRLpPFZh9ruBseYKpQr5lQxgwQPildHPnmn1yqNuVxZjQZuEDn/eEPthxgHbg
         UqWVYT+LPyKXtSZH21ZkabhsyIkJ52O9cSTJbmT/iV7otE1F+yDfkLYhYiNO8oRWRgEk
         8gfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772711430; x=1773316230;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUs+CGKlSXZwATM56oVixVPREmsA3EmoDPmnZPV6UKk=;
        b=Cvauc5AASXFKB11o8oqmJDcIAy7H64T7aHorhR9wqbYYIxIL010vqhMcWguS1SRfm4
         W2881jnO3zr43CZxyPxKPaZO2BkGifLHKMeLl556fzekpjIMFlli9z19V1iwysIx3G0B
         JxRpbIeO/7hxjnXSrIsBFkgT4XhpqNsvbyFLFG6K+EEHMqtRDpgo9fX1QZjcg93yB0Ff
         miWulJYVC+7E5CovmFiSpXTPo4MivVVZRfx8kN21qmdYyi4jZvV+QwfGw09ML9Dlblcy
         9fKi0D9Ezzf8Z7RwlayP3PgD3uJn+E773+C9Xz9L0uH2qvP2pF8tqKA+xrVIQnzBNKOk
         a0jg==
X-Forwarded-Encrypted: i=1; AJvYcCXIHJPIzgtpIPIDLYa6GLIM1bePjBBOOEhWF136D+Bw+BigCqed6YKPT2XgiHaV+oBOFLaOf7Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YxI8qxmM9CQo1fsbGbUkW/vudieLSguSSb/drYsIc0WOIggADMJ
	jz4s9C4cmX7kk1x2i1RPgkYOzALw6OzoVRjQq2718OGcaGeV8q5uj16lrAJocH1xQZg=
X-Gm-Gg: ATEYQzz7+7Psq936XRkdizscS2GJFF5n3XfTfqNlvYVHeTcX1D2ay06kzK3L9OtGDVC
	vrQ92ANw7ItBejfzgx5x1T75yEc9EUx/kw8Kk6w6fQ2HED6fsa0sBOBINCIqgWNvDj2UrDt2XEx
	1sEt4++pn7mNxbAzTnihy/vcjf64+5uwrOSKUP3y+5LJ2WDA7eHrlVWqE05Ppa2gq4XLLduRx9H
	XbUmKloOTzO5hgUD1bA/lkNXPl16hLohB9JO+E30gsRWr7bXdfiB6yYFBre/Ilp5LiJX1bId8+v
	WeO+gwS5T8RDhTLo0nQon1GWLpsk1JwqxWN0ZruWmbkiklkMU1kPhWdsrvTwPSjVY49jOMkEOnA
	91TycXcbFrQAEWLixY4XAypezxKz84LFvZkbIG5XbH4/KeRd4iIdDTY7b1k/Xt/EtMhfzzCDP7O
	/d8xC+0Q7kQgao6pnGZOgXvZRVVg5+ooG5wafUU00RFWs=
X-Received: by 2002:a05:6000:18a9:b0:439:b486:ba7f with SMTP id ffacd0b85a97d-439c8015847mr10303402f8f.49.1772711429861;
        Thu, 05 Mar 2026 03:50:29 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c60e40fsm48919998f8f.7.2026.03.05.03.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 03:50:29 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Mar 2026 11:50:01 +0000
Subject: [PATCH] KVM: arm64: Read PMUVer as unsigned
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-james-kvm-pmuver-sign-v1-1-eea0a2116dd0@linaro.org>
X-B4-Tracking: v=1; b=H4sIAOhtqWkC/x3MQQqDMBBG4avIrB2IEaV4FXGRNr92lETJ0FAQ7
 25w+S3eO0mRBEpDdVJCFpU9FjR1RZ+viwtYfDFZY3vTmo5XF6C85cBH+GUkVlkiz3i15u3hvPV
 U2iNhlv/zHafrugEKnUWbZwAAAA==
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Colton Lewis <coltonlewis@google.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

ID_AA64DFR0_EL1.PMUVer is an unsigned field, so this skips
initialization of host_data_ptr(nr_event_counters) for PMUv3 for Armv8.8
onwards as they appear as negative values.

Fix it by reading it as unsigned.

Fixes: 2417218f2f23 ("KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts")
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/kvm/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3ad6b7c6e4ba..b8632edba9a3 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -76,7 +76,7 @@ void kvm_init_host_debug_data(void)
 {
 	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
 
-	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
+	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
 		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
 							      read_sysreg(pmcr_el0));
 

---
base-commit: c107785c7e8dbabd1c18301a1c362544b5786282
change-id: 20260305-james-kvm-pmuver-sign-fe830bdead2d

Best regards,
-- 
James Clark <james.clark@linaro.org>

