Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493702581
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 03:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746157997; cv=none; b=qnPJUNByeXDYJrQftGCTq0pF/jIR4jLC1NDMjR/GopRNh4ra1tZ0bk8k1Yzb5X56XAHVf96V1t1EeYUAUQMg3aGNfaJERgSE3Ebh9cvES8HiwJ0znWCg8HiNcBDpbY06+Dcky/FFyu4DBWIEBSRxNCEwFcE1vNuhL/iXIKQJjyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746157997; c=relaxed/simple;
	bh=3guqmtCUgZU4RrlWuBDVyZE/GiHf7japNUzdE+nkYF0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=k9cIRptU4cE1GiifOtL58jH6oziFETRo/5upRMrXPCDGPNlnxVQ/wu6PMoHtTQhnIUEl+mcWhe2JPUuS9btzp/o4pqofajNfGN4wRaKeFpgD4ZtHYmAnLStV9vDBQGk4GXxmVRYDXqI0NQ/5L8WHmGZD+K9be8ibSNCh1GGS46I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=vRG2avFi; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="vRG2avFi"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6021e3daeabso739879eaf.3
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 20:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1746157995; x=1746762795; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ojFTK86BOKHs5Sffk/1VcJDUeg7+bF9Sd/43yKdhw7c=;
        b=vRG2avFiYbYGkCaZ8NGhw1zj7mBdyWALQsJ/xUfwWNoMSlRGSa61PKHMrQnwg0eEwG
         QyU/8zhycKuE/Tv51tFg99lvwp5GFTGdFlZKfgXv8PjtLy9b5a+H0Cm3rIqfqWK81dQX
         Lgdz2Z/Jt/915YkVF+VU9yNZshvaskcigzrRsKvpNrnRHBQjb9XEJmg504/rRUshQuI6
         63jw+mNLB4QtNDYZ+ZI5uKyC3WMwSsvB7y3J9R7FOVgryFL2MknvT0++Hhb9FT3ncRH4
         HXZ32/gHBb707Q3urTk/dHrCy4seuvvSy5/Cv+420Sw08+cCVGNaOjjXqThsZoRfjfee
         hZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746157995; x=1746762795;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ojFTK86BOKHs5Sffk/1VcJDUeg7+bF9Sd/43yKdhw7c=;
        b=M06e77vJgsOkjhIkViCj9/0ljIIRHhs1WtRYwwbOLad8ysQEz+AaqH+uE7i6l/35f6
         I4iksx0F4uGXM3kXqeXh1crWpbD8HPVLjhQIS10kwxWUEcL5YK8O6mfeEXJIqQsw8kr/
         zRQiBCtxYPTjGqlor213LCItFGRCFTK4N6nUnxmVIirtWPucS8YNk5EPZOwEjf+2sK34
         iMmC0/mwXHP3+H/dHGNEfd0qKp8hdoqSPPRQwA0s3iaoRmp3pmw/JI8bg12LdD7hZxx6
         MKK9UDESHsEgQYXLkTs14EmFVE/oir6eTt8L4nknHT2U0PoKJQO724aEZq7eM+3sJwG0
         IF9g==
X-Forwarded-Encrypted: i=1; AJvYcCXQxBefbAdnnfDv591gk5sFy8Edh09BsX0yOJO3em5hMFlMA6gTZMFZVWm6M7opwkbz3ymLzz4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4A9Oa6XW+jgofvtKNxBiLGnzN78udpgKz1EjePmsedNKeVcP7
	f6g3XGeg4zsknXfxzHBFcfUEoRCDgkLjeq/b9Ko6oZYLkGsSp/0zskL0OmY1AIq4m1/KzE2SuFp
	rfGrkBkhZWhdEtYGBk7v1eM97H3vtw8/PQr6jMQ==
X-Gm-Gg: ASbGncva/5S+vNPUBDBfADF2/XhF40dIIUJqoJ0esYgCxvvLfjrx3UDNZnXWg8pHqxY
	pq+lSMd+Yl9cbWn3DXv7ZG2bC9NTKSMZ91R97ziay9lxbbZE3qM60yvg3Y4ulu6t4nhM4mGkRgk
	TwzNoGb7dJjtOcxrt4Lg==
X-Google-Smtp-Source: AGHT+IFCtscwV8O7+W4yBswaX+xL5CU0m6pTn37NOQZAybr47eZb3GirbpP/+XKz7nDZsXAaZlthUftbLpDAo4xDjtQ=
X-Received: by 2002:a05:6820:3104:b0:606:5531:d903 with SMTP id
 006d021491bc7-607ee6d2206mr788932eaf.2.1746157995308; Thu, 01 May 2025
 20:53:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Per Larsen <perl@immunant.com>
Date: Thu, 1 May 2025 20:52:39 -0700
X-Gm-Features: ATxdqUH0icFH_SkqozKpifraM3UBR6tR1qCNPkxonjxJAJvE10BR_u9dZ27wUdQ
Message-ID: <CA+AY4XcaJa1_U3qXQUBj4wZJYc9hKmRX8FTNeDvV2auEnC_WrA@mail.gmail.com>
Subject: [PATCH 1/3] KVM: arm64: Restrict FF-A host version renegotiation
To: linux-kernel@vger.kernel.org
Cc: "qperret@google.com" <qperret@google.com>, "sebastianene@google.com" <sebastianene@google.com>, kernel-team@android.com, 
	"will@kernel.org" <will@kernel.org>, maz@kernel.org, 
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, yuzenghui@huawei.com, 
	Armelle Laine <armellel@google.com>, arve@android.org
Content-Type: text/plain; charset="UTF-8"

FF-A implementations with the same major version must interoperate with
earlier minor versions per DEN0077A 1.2 REL0 13.2.1 but FF-A version 1.1
broke the ABI on several structures and 1.2 relies on SMCCC 1.2 is not
backwards compatible with SMCCC 1.2 (see DEN0028 1.6 G BET0 Appendix F).

If we return the negotiated hypervisor version when the host requests a
lesser minor version, the host will rely on the FF-A interoperability
rules. Since the hypervisor does not currently have the necessary
compatibility paths (e.g. to handle breaking changes to the SMC calling
convention), return NOT_SUPPORTED.

Signed-off-by: Per Larsen <perlarsen@google.com>
Signed-off-by: Per Larsen <perl@immunant.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 3369dd0c4009..10e88207b78e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -712,7 +712,24 @@ static void do_ffa_version(struct arm_smccc_res *res,

  hyp_spin_lock(&version_lock);
  if (has_version_negotiated) {
- res->a0 = hyp_ffa_version;
+ /*
+ * FF-A implementations with the same major version must
+ * interoperate with earlier minor versions per DEN0077A 1.2
+ * REL0 13.2.1 but FF-A version 1.1 broke the ABI on several
+ * structures and 1.2 relies on SMCCC 1.2 is not backwards
+ * compatible with SMCCC 1.2 (see DEN0028 1.6 G BET0 Appendix F).
+ *
+ * If we return the negotiated hypervisor version when the host
+ * requests a lesser minor version, the host will rely on the
+ * aforementioned FF-A interoperability rules. Since the
+ * hypervisor does not currently have the necessary compatibility
+ * paths (e.g. to paper over the above-mentioned calling
+ * convention changes), return NOT_SUPPORTED.
+ */
+ if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version))
+ res->a0 = FFA_RET_NOT_SUPPORTED;
+ else
+ res->a0 = hyp_ffa_version;
  goto unlock;
  }

-- 
2.49.0.906.g1f30a19c02-goog
