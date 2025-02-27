Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372FE1EFF8A
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 18:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740680279; cv=none; b=Y3eCjdm5vyoDLkuvRvEfzXsrwK6+fHcuXHP6P42/s6ZQ+LWhZ3UPE24XD0my7yujYsSBMTB7En4/1fFrD3m5+fYDTN00frT9U7OB9D9VzwMSTq5Lu63Fh2ZNhaW2y4PzzLBmqc+tOrxH/qgQ/KSSYn2Tews03/3jo8c9q2tO6fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740680279; c=relaxed/simple;
	bh=iciPmQ+usvGo91G9AQ+z/XpPH37LLBswHMPsV19xk7Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CX376GPpjj/1QuWl7xxzaxWnYfse2+0GObkokS/GDvDGSkK6Mo0oSmP3yaLurmmEbBO7Fe5vi7cyTZerdwK0TXqKDP6/IvL3b/MkPuLMvt1PGHhlVS/GhdIoKGCddQJNDmpr95iksSIk1W3Qvh9z7UKBwLJCA4njC9ttc192ooA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QpCWM6ft; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QpCWM6ft"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4399a5afcb3so11314395e9.3
        for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 10:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740680276; x=1741285076; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv4f4paK6utMxGVLBPvw8fcn9CW6EObNKlJ/GybX54A=;
        b=QpCWM6ftRrLsTgHd8Pr6hp4tn35NZuhuA3p14tJX2GxNpr6s4qq7/hOYlFWuwvs7zT
         ZfhmnqwvrHRdRyE7RI4p+3c038uxwqn9ulaD/QXBQ9SnUHu/CaZvcw62nkqghqO7Sgfr
         yRqcLF9eLiU1SRALiYj6jmsNqWfaTV514a+gwyOHgXvnqovPwYRX3DtgSvzDD6nrL2M7
         HruxVYJUrHv3rF8LE51U1mB3NjCS7S4nvfFxIfkkIZRYfVw8Dhx85YUyxX3B9XzSL2tY
         sl//w20d3Nv5C1LCdDsJ+wPqBkxKLRIc4U5+SBms85KBdDEE41cqxoOId/v43zUANBID
         WttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740680276; x=1741285076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv4f4paK6utMxGVLBPvw8fcn9CW6EObNKlJ/GybX54A=;
        b=lIgwma+BTKiXEvYLNJv74Gn546km1uYD0wewdIQ9yw+OGwNrHN6ZaNg+eZzrSuY6Jh
         oaug2ZluHwfGVdARyeyPkc/oHAdIrIzXTsxydsr9sidty5/FyK1/XxYJchaT/Hgd9fat
         c3Y2RGviGI/2beddBhMNuAUsIQ9uMTH26gcKAWbJbR/ntUkSfCKkE2UagB9APscjWNYr
         yEDloDwMpHoftRm+XtsRrm2wXYbtyg7gosa/XUSEPbCKDYISGULOKePFgicAiMnDYPyB
         XmdsmMuxtFBmeZoiAx/AESR8KQuAgmq6XPTgaia6xpDFAZvqHqlgEAvFUnFZU1y0BerI
         YbwA==
X-Gm-Message-State: AOJu0YyH8OGTYr1MUmPthZWkCkvqjs72v7B9Agxp8fmigMJLy3nrIpOQ
	GB3e8obAkTx3d/ePD9sGyrpMTHlDuMfJWLviG7EZIfs+RqmDIEokAm233gkznmIfX1TblAiRQa7
	cuWalikQ14m2iyA8tQSc9SA19XQ==
X-Google-Smtp-Source: AGHT+IGeSgG4Yj46KVsKJq4Od+bRmoB4CwRl78JJio8Udz/pRZxQUsr/HNXRQbwORqLTtPX98pEazY6JQMdxAAlRg0U=
X-Received: from wmsp32.prod.google.com ([2002:a05:600c:1da0:b0:439:89d1:bf88])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d8e:b0:439:b565:f457 with SMTP id 5b1f17b1804b1-43ba675c3afmr2084445e9.27.1740680276746;
 Thu, 27 Feb 2025 10:17:56 -0800 (PST)
Date: Thu, 27 Feb 2025 18:17:46 +0000
In-Reply-To: <20250227181750.3606372-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250227181750.3606372-1-sebastianene@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227181750.3606372-2-sebastianene@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Use the static initializer for the vesion lock
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Replace the definition of the hypervisor version lock
with a static initializer.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e433dfab882a..6df6131f1107 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -69,7 +69,7 @@ static struct kvm_ffa_buffers hyp_buffers;
 static struct kvm_ffa_buffers host_buffers;
 static u32 hyp_ffa_version;
 static bool has_version_negotiated;
-static hyp_spinlock_t version_lock;
+static DEFINE_HYP_SPINLOCK(version_lock);
 
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
@@ -911,6 +911,5 @@ int hyp_ffa_init(void *pages)
 		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
 	};
 
-	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
 	return 0;
 }
-- 
2.48.1.711.g2feabab25a-goog

