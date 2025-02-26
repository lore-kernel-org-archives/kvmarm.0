Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1337261398
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606547; cv=none; b=b++v1dZdLGmtExtwHyrTqH52FRSsTYPKPG3UCfkEf4lNCZFhLw4xnc2OAURycqaubxur0R0OKt6w6WQpJiUsJMTJi9Ul7Dhc84EeIgR/yxnd4K4D4XCjGBYwPiLBF+rRH1cFWLgLUW/3hzqNv6kmeP/e7J2J43c7VsuicgWBLWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606547; c=relaxed/simple;
	bh=FR9O3f+FzonphJjEwi5+VpVYgFi8WH7raVXQy1pKg8k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZjCtJo3FELf5gYkFvHjsR6rRanI0ZfRWfhchC1acUMSEmIayn3y8AtApaRlZtThLf4bBIeuwzRcB32aiOh0sWzM6cyNBF8qJA/0bAT016LN1i3NgiXC9VyGRO1trO4t3jm6YU/JV38c1Dd468yTAITuDBkOWKfsk/lxMLFJwHT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=etX/tlmL; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="etX/tlmL"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43ab5baf62cso2511335e9.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606544; x=1741211344; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jElUUP1cXmmGkWA/+GnRTo6wT5X97muVU936DPVGfcc=;
        b=etX/tlmLYyNHdDmNu5ffVcR1madX2y+UNrwpqm9QlyQl2CFi7IxW+F3+CwmPzbD2qr
         h2goiZkB6d6p3md6JjcdJrZ+WSoannKtYTgzQeMQweZot/4O8ks0Zjp93uPKjuDVlRHZ
         Z2CB7Ii+9ZD3hO2gJWaPu1Sww11gpEMp5JvS2u9+bvzVb4mG2r1Lb+y0LPAFTxoE6hXb
         o4hESJkvWiTcPzP1cNSRNy2Iuu8PcAtt/nCsiKLj/a0vLAfk6CR5IjD41rLFrxPSyvhi
         ABos6wmWWROroBZP2jOZxCca/iFPo0jK9rT914U0sKRgsilOetI0OlQctLoFPCvA5uGe
         Istg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606544; x=1741211344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jElUUP1cXmmGkWA/+GnRTo6wT5X97muVU936DPVGfcc=;
        b=nCKqJbGT+dv0LVPC8uxBwe2TaFJ+R36LNg174PF3XVuJFzGgRhLdyQ/ISnKpCUOF/L
         V/dSjrDnOEEUV3/NZGLRwX2y4ix6b1VOUYqa9QRas333fzz1VttcmaAqhjEY9om5r+gE
         1ihqw+g2PM0/TffuDnOm8QCe5Yoo0hx/HnuButVqMsgTusBUvpKYXhakQnZDSWbOOg3B
         IdLKXjllxLXtVCOFwS4dEnsiEMwfazq8bzaTzqXoijyglTRZz4kK3Hct0/Gr8BWkmVDV
         XO86AyYeHxYoGDLSPONQLrzmUWFE2bVzcE3+xTJqj0GcOKg0BcrHusvO5hdsIBDeiArE
         ulyw==
X-Gm-Message-State: AOJu0YwngnRl9A6dBjopTj4zqLkiU5cDvvsMJ5sRQ5K6vQetqwG8C8V/
	5MXQ2G0JPRd+J31pru2VdSSGgTMtH6++T+qpw0sVQ/Vt7cAJdjvfG1mkP3hXPLka/P+gzIb/ElO
	gWQie+G2YBqAumfAKcFUYFz+deQ==
X-Google-Smtp-Source: AGHT+IFMNilNm63tpaGE1Thx+63/zfmAmfVfjbx1vaV84Aa8shwCpD7h0mmGQaUHETfocmAdjgNyNEVh/DYceyRboA4=
X-Received: from wmbfm16.prod.google.com ([2002:a05:600c:c10:b0:439:850b:8080])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3506:b0:439:6dba:adf2 with SMTP id 5b1f17b1804b1-43ab8fe7734mr46217465e9.15.1740606544357;
 Wed, 26 Feb 2025 13:49:04 -0800 (PST)
Date: Wed, 26 Feb 2025 21:48:53 +0000
In-Reply-To: <20250226214853.3267057-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250226214853.3267057-1-sebastianene@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250226214853.3267057-4-sebastianene@google.com>
Subject: [PATCH 3/3] KVM: arm64: Release the ownership of the hyp rx buffer to Trustzone
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
2.48.1.658.g4767266eb4-goog

