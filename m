Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AF92EEE73
	for <kvmarm@lists.linux.dev>; Sat,  5 Sep 2026 08:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788598742; cv=none; b=f/bufBxLmrtR5px6GDkLIl3zCCvvoJ2MR44P/2uiAq9Uln1wRK8Ulj9PJnzeimHYvawCYtvIK+psJjQY53hhWSwLhniQPw1fwCTPxg1InfbtokMgrJrcWQNrjr9cULLg1V7qcotSgmXfU2mdBgdp7kRtDIzHEOt/D5yvRx6TBs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788598742; c=relaxed/simple;
	bh=V/NeoGBnmEdvp3k4w8PCcy5SvGN/W72/Vg9D5399iLM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UaCTtPnv9kGztP4+0fi73xl62Lyw1XaJ1Xm7uLR3P/LtMygbUMOJT0ZPdcoQszDmh5yoO0LO/apeAiT6ofQDa95+Jg4TP2OLt3i0TcVJahfX0dYDHMQM9uF7K9+2lo8damc1NySadwhZSvAOfJ5z2EGCdXLFGUlNug+/CQq9QeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JF6J5Ot4; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JF6J5Ot4"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49cdc81f40eso13132945e9.2
        for <kvmarm@lists.linux.dev>; Sat, 05 Sep 2026 01:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788598736; x=1789203536; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=k5DmudKMyqruC0Fs8Lcf8OMZE9n3CdnS0WF8To3bTtU=;
        b=JF6J5Ot4pzW70W7LWZsQ+nPw0yAI8MNRjBV8npXKC4TCwg8isrJSCnD+fTehc5XSn+
         ApG3gBirZ1mojaCMIy2H3gvez7+/PraHDnl72cyXJsqU3seWLl6TkO9d0Gv9Eer7Vyk0
         1P+4x/Trwvuy6aJtFBHWxhpunEds5Wv9HFkjUKuSjT1Fci+m8WwpgauwzTbl56dA4+ub
         f15OYP6sN7n37KOqHTNnNjOGd8HSFbbyK6fGn9yWOeFrqhDDRAjrl7hLWLUlFRYJbNQC
         y+Xr0yuuDgZfWfwbFh7eHSoqh4IlORvBmvQHxFFNcFZ9nmOC1/o8gVxV/9orjW5BLnIr
         0MDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788598736; x=1789203536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k5DmudKMyqruC0Fs8Lcf8OMZE9n3CdnS0WF8To3bTtU=;
        b=FAe3L8/GiyNay7D6+gGa66m8rk5eLujNqJELp2NLMFCYgRoLkKL//bnDTrJT4/u/DL
         IBoFupiIYxnDHkEMHMHZEmTJHmsFMTws+CubpHg8G1zu9oarngNNzug1ZbkkhcwNDhwa
         mS6wSmKSrMEXGbDI+Tgq+wFJdYxZ9Pq0TCcDrh417bM1x2Y0Oy1TJvss2vb2QRJCwvQj
         iBUHHyLg3wpSkmS1cXgoc2N882NJwDYARdZuVXDGTVKYyRxOlb7Z9oF37TyMa/LbARml
         Z0NoKS2ydsZ3DELSTo7HYEnZY7QGwJGVg2rzBZWk6ZstnDeF8ZG1FWSYg3Cq5RnzXij6
         r1+g==
X-Forwarded-Encrypted: i=1; AKwUvBz/QTHajXnc6WL0QbXCdUQ91SCavz2EwSfpeLO92BfrwPRVKTNc1x0U+czojbaX6y053Izf1jo=@lists.linux.dev
X-Gm-Message-State: AFuF++nMUclSvcgM66YsTInM5VLAObVhL6+yA0bZ0XM2OFaDeN8Dt3Kt
	/zZrDaDhqHs5Ma59ee9JStd0CzMEMi16U4tNvOtu40JPvvTv//Xvaesw
X-Gm-Gg: AYBFou35HfNnJmTN+wMDdNQ1U0ijQNU4AKpdmqlCyvwlwPVvI/BRc6bUjdM9sZiwLo9
	LZQW3s4oMJ3zeLTxSoWFaFnIjn/R7h7d9rTaJmZjEKqcQmJ8aR8YHxL9H2gJrI8g9nnwl/g9Frl
	kSZ/lFCrYyx1sDQEnejJmJ/SgyYYkhrTmANKji+ljPXJ1EzliWLVodHqMlKHtuzntm5zNjpv+IT
	/HjvsPNJ1IzBvAvKH2z8muWQo4ZF1ABfDM0ZcMRF5EEAjS6eP/ke69+WW3ILmzEibxWMnYl8C8G
	J26BXvmz0VeGJGoecCem16DR5KL3nv4D5j4SFZnLHLQ069/x90nU/NQ1N+tj/YxlKg6SS+gLbCY
	hCTcvx/iiBHKmSa0FGP/j5IekNuS6yeEni2bRPS1z/TI7EYj6TH7YIK1xE+RNMlkyI0M9NUL8XS
	MvfKhJfmIv8SI0g0HNNsTW04z/plk93AihjmaNLzsw9SC9EokFRsIfaw1QG+1OuJo1dTkMaaB2o
	wiCSi/bjOyvbVnyThlt/XRNv2sK9P0iUUGcAVnHaw3Lbm0cm7SSyg1XbPwlkPbiEV9LEk7C/VZn
	I5NfRhbmRroXquMa8j/aBh565K2WF2TMKYNHG72Y8emKCU+ux4ZDq5MACl1H0d1s5pw=
X-Received: by 2002:a05:600c:3f12:b0:49c:c8de:96a9 with SMTP id 5b1f17b1804b1-49cf7fdd2dfmr200970085e9.2.1788598735989;
        Sat, 05 Sep 2026 01:58:55 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a4eb-3001-c06d-af27-9fa2-ea53.310.pool.telefonica.de. [2a02:3100:a4eb:3001:c06d:af27:9fa2:ea53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee7febb4sm233053035e9.14.2026.09.05.01.58.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 01:58:55 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH] Documentation: KVM: Fix the event_source sysfs path in the PMU attribute description
Date: Sat,  5 Sep 2026 10:58:49 +0200
Message-Id: <20260905085849.40479-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PMU device directories live under /sys/bus/event_source/devices,
the document spells the bus even_source.

Fix the spelling.

Fixes: 6ee7fca2a4a0 ("KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index deb5c51bc00c..a3f20a4ee4b1 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -135,7 +135,7 @@ after selecting a hardware PMU.
 Request that the VCPU uses the specified hardware PMU when creating guest events
 for the purpose of PMU emulation. The PMU identifier can be read from the "type"
 file for the desired PMU instance under /sys/devices (or, equivalent,
-/sys/bus/even_source). This attribute is particularly useful on heterogeneous
+/sys/bus/event_source). This attribute is particularly useful on heterogeneous
 systems where there are at least two CPU PMUs on the system. The PMU that is set
 for one VCPU will be used by all the other VCPUs. It isn't possible to set a PMU
 if a PMU event filter is already present.
-- 
2.53.0

