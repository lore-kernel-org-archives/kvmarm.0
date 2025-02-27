Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559C525CC6E
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740680286; cv=none; b=JYUxkLtkhXCJQEDfqWCIOsre7BXIBhXaIb9z9Rcg80D2OPMmi1eYV7Xo2vjkk8j4mLDZoHNkSvZIEXZaxJL6U8qAOqQSr8XxvFVusFum3yTLvhl0bTCcFsM3+5bJhcod1drpwt/YrvD7aJ9tI5epPcIwAMgkSkTRIF6hw+uyDOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740680286; c=relaxed/simple;
	bh=LhCwUqw6aIcUAaIilumOSmmYJTZiSLI5LKxzpVRdtdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nxz2Yu3hhJEOS3pGkmQFfCYVWnZCIRafb6+Zqm58wcP4tlsPbBB6xXih2cK/3Y1V+qkuVnJMoHb5GLo0duKwXvo89mp9rednnDitGGdymwzk0AOSq8A1X4qxEYagPEkoaHwrMdTpVIHKI3B3FRJG9h3c8wfxrvQ+vzRuTHx83U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Je1gXlV5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Je1gXlV5"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4398a60b61fso6953045e9.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 10:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740680282; x=1741285082; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=je1VJ6mKVPvUaaEVhOcM6k4XIwS96a65cb57ultTPxg=;
        b=Je1gXlV5GxRKfzoscTY6WcM9r63w1JV5FR4SCo2sRQw33NDsuiC/EHMwdslLUrP6Sn
         R2VupOyaoYBFBxqiYi8ce3h/JlG6lwhhb5BOT3Y8LZRjrbm6Qsx7JQUr3wFjQHK6KA87
         mm5TJmdx6kZjKPrcT2rnEEYneRH4tT1maz+BO3CrHatCAeqK3GOz6KLcbKznAK6GnTCP
         t1EV29nYeeK5Hbkq26e5JeaWJAOKGVkTDIfo6Gthk0AwI5l6b4723R34iM2RbiKThWac
         dS2YPa0caGUsRyE9hglOHbzl4552HSHGfwJ5d/PoEH1EkfMdUSsQHPE2sx7kXAunBmZV
         328w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740680282; x=1741285082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=je1VJ6mKVPvUaaEVhOcM6k4XIwS96a65cb57ultTPxg=;
        b=RFuIi2OF3bp8JJ0aQrIi9nNGwq2dv59J8vU2KeQ05hVqLJty7bsCOeNrtHIqpR4dkE
         8Jw7IUSqhFmmkib3DnjIIbPlYOd9xzRmb0HTpG9ilMDnWXmnHqDjIsf7bFMWKe8k3ONX
         KTnoq6q40ns4qq81nCtZqvx05WpenjEr1uaGvged+YCLkIoTYz43C8Q/THUW/osNA76p
         CJpTjoA4h9ZD91Wvo0G4l4ClzQDTd1tuqjiQRh1gT2woUwUqVGcINIAA9dYr6kL+C67N
         hXB9grZ3xuM3kkdJYz1bGl8BfD8vLMvYbJonNoVTheU8+KmjxNs6TpXYEsqBqvGVDP2o
         8dqg==
X-Gm-Message-State: AOJu0YxTDsuoExpC7HhxPMq0SVQCCFQWpBPA0Ti9wZuMe7WKbU43C2ga
	d6l59fCzLUgGYHrPXZfS0ZYahZ9FtO3EVWO4fytGQJjXaYB+NqPFTVrpbCewYs3PRe6YNjaIivq
	KOo+9DwtqiWh80ydau8FSW+UGqg==
X-Google-Smtp-Source: AGHT+IHIGWkJyk1W72MtPuYvvfSzBwxqwzISAWt47NfzIFTk3QsHe3svTwzMWq8Ixj0RG6cPRh6eQd4HAPYTSjvNZaI=
X-Received: from wmbek12.prod.google.com ([2002:a05:600c:3ecc:b0:439:948d:4146])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d16:b0:439:9e13:2dd0 with SMTP id 5b1f17b1804b1-43ba66d5bd9mr1947805e9.6.1740680282702;
 Thu, 27 Feb 2025 10:18:02 -0800 (PST)
Date: Thu, 27 Feb 2025 18:17:49 +0000
In-Reply-To: <20250227181750.3606372-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250227181750.3606372-1-sebastianene@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227181750.3606372-5-sebastianene@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: Release the ownership of the hyp rx buffer
 to Trustzone
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Andrei Homescu <ahomescu@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce the release FF-A call to notify Trustzone that the hypervisor
has finished copying the data from the buffer shared with Trustzone to
the non-secure partition.

Reported-by: Andrei Homescu <ahomescu@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 861f24de97cb..7da0203f1ee9 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -725,6 +725,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
 	DECLARE_REG(u32, uuid3, ctxt, 4);
 	DECLARE_REG(u32, flags, ctxt, 5);
 	u32 count, partition_sz, copy_sz;
+	struct arm_smccc_res _res;
 
 	hyp_spin_lock(&host_buffers.lock);
 	if (!host_buffers.rx) {
@@ -741,7 +742,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
 
 	count = res->a2;
 	if (!count)
-		goto out_unlock;
+		goto release_rx;
 
 	if (hyp_ffa_version > FFA_VERSION_1_0) {
 		/* Get the number of partitions deployed in the system */
@@ -757,10 +758,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
 	copy_sz = partition_sz * count;
 	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ffa_to_smccc_res(res, FFA_RET_ABORTED);
-		goto out_unlock;
+		goto release_rx;
 	}
 
 	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
+release_rx:
+	ffa_rx_release(&_res);
 out_unlock:
 	hyp_spin_unlock(&host_buffers.lock);
 }
-- 
2.48.1.711.g2feabab25a-goog

