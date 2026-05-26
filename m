Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0183030FF36
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808793; cv=none; b=pqrjj59XRckpdxv1NMYui1VUPEQ1CmFcBQRvtyVUrLWQWwI93by+tO8CEm4aJjuSJUotGWNOekM5DpMf7U7nW6BrWE3EEp/CZLYvkL4gx4P5T6/CJJ3tRHrikwT0AQRmhOIreYpHqH5da0sVkd16dy80HtLHI/xx7p7nhRNMqIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808793; c=relaxed/simple;
	bh=QF3GgHGmqxOc2ZiHSwTIFp/SPXOTLWdRiKhIV8Khm7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dfOLUryUanrr+no5Ap0tlO8j3BZFu6/YIH5rck6BIMtoArrYjxmvchbDuymQxH31mTzRbXhlmcrZoCRRhX+AiUYk30ogMt57LJr12Hhc1zKa0VNe2fJ9LR2wnNrHUVFR4JuP33mR0b6cVWaXtTZ7rBYsQvrdRgW+j0uVvY8r44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pm1XkyR/; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pm1XkyR/"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bdfb99d8af7so285112966b.2
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 08:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779808790; x=1780413590; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UeoRdqb2W8o2rKYS6Num15n8gkt/ODkSyZpzjjpRQD8=;
        b=Pm1XkyR/POxjSYaNZKdlir1N+wFarrMWvNP5ILhjxn+BWGyvGerty4N3dtL4Hds8n2
         2Cp/fS5vAT3C79fwo0MWzJwD6+bqFznXJwP49sNfEp3o6jTudP+uYmpiRVHnOQwAfXrM
         lU9zimOlwPoIMhGdn3V8ybs4jggdlAuJx0VsU5dBCc7BHATQRMQwmawr7w6WEDoSOW62
         OHh+licMQ4fM/g/Yjzh771pXEjtv+EqZkIf6f8mrgp4/OJ4L54Mc9QEj9l8ivLVN9cVv
         QopD01rCjy4NTlNFudgnbMDJJ58XeszBOXdSaDVLNPWBIGpyv8SUgNGjfZxkv3ODbyOo
         Ce5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808790; x=1780413590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UeoRdqb2W8o2rKYS6Num15n8gkt/ODkSyZpzjjpRQD8=;
        b=dDigIgIYVJ6ukt4NfACmW0IW0LeT78snKNuutBrRR8lt/fBeiWF0GQQc0Xu0LcHiwz
         sc9Dz5EFFMcTmuvSAaL0e5NWh5kFIQLJPR4KrIYBW5xphUYptH7CAZZi7OffAK7/1+P2
         gZ+ASvmWmWpp1VSnO/cBhzdLCkDyHq5HkgIEn2m59Wm/nCWefi2xxJ/coShK4YemU05l
         DfB+0J48Jc6ysS1lc58W8/EYzeRGaSU48WaV/OyGNFbEGAu3NFyypdVyTkHj0BrHmXf9
         3ilg8QYYBBNo49L0E5wfKcuzmKr8iRWtJPQMTr/U7CQua3/WDNvwEZg5G1oXoH4GSd04
         utEA==
X-Forwarded-Encrypted: i=1; AFNElJ/FgpSFZ5+n/aBkMBAVrnSl29ibCh9sFZ/x/HXf3iI7e6i3cgvlKz8OoNVpjKwGcPmwGNtANE8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTgET5viRZvsDlQ7iq1byzxh9/OhMlqAhBTW5nsA+Ds+QSZpEQ
	hPNqOq0srvwbwEYqmiAxqj9mdqpaYk6aVHe8qumRudkbO/aObuzAJlvxba2RZ2vt2gT3MqftdlY
	sg4HOCJHV9eBXOQ==
X-Received: from edbcr16.prod.google.com ([2002:a05:6402:2230:b0:687:17de:d8b5])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5107:b0:67e:96a8:40d0 with SMTP id 4fb4d7f45d1cf-6889cc429a0mr6652238a12.21.1779808790002;
 Tue, 26 May 2026 08:19:50 -0700 (PDT)
Date: Tue, 26 May 2026 15:19:32 +0000
In-Reply-To: <20260526151934.3783707-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260526151934.3783707-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260526151934.3783707-5-smostafa@google.com>
Subject: [PATCH v5 4/6] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Sashiko (locally) reports out of bound write possiblity if SPMD
returns an invalid data.

While SPMD is considered trusted, pKVM does some basic checks,
for offset to be less than or equal len.

However, that is incorrect as even if the offset is smaller than
len pKVM can still access out of bound memory in the next
ffa_host_unshare_ranges().

Split this check into 2:
1- Check that the fixed portion of the descriptor fits.
2- After getting reg, check the variable array size addr_range_cnt
   fits.

Also, drop the WARN_ONs as that will panic the kernel and in the
next checks there are no WARNs, so that makes it consistent.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..b6cf9ad82e12 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -607,8 +607,8 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	 * check that we end up with something that doesn't look _completely_
 	 * bogus.
 	 */
-	if (WARN_ON(offset > len ||
-		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
+	if (offset + CONSTITUENTS_OFFSET(0) > len ||
+	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_ABORTED;
 		ffa_rx_release(res);
 		goto out_unlock;
@@ -641,6 +641,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 		goto out_unlock;
 
 	reg = (void *)buf + offset;
+	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {
+		ret = FFA_RET_ABORTED;
+		goto out_unlock;
+	}
+
 	/* If the SPMD was happy, then we should be too. */
 	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 					reg->addr_range_cnt));
-- 
2.54.0.746.g67dd491aae-goog

