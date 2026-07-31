Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EF536F8E4
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527788; cv=none; b=ln2tXCUKzlf0Pkz+60VIS/RGTk91iyMGXyD18uxxDs0gFa4JeYCIFxE2eF/sJ52rQ0n13+B+9YALIRCck0mpjoVk+GKSgLl17OHeD1L4hh/4E1QtqeXSw0dxiMpOiPOOByz/UEBJdeP6NLt0QYICNDD9ae+dg/SOoGDrrKsDA90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527788; c=relaxed/simple;
	bh=ZX3lsEpQM2XoeKfIgtWIwUcQylpJU5vh25cC6mG48ng=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ee5S1/h1aBYbMBEX9KFUEToLM5LZu7Y0h1Sjrus/Ui9MT36WccvXJKDhhqTiLNXyPRpyuM6yH/N32e8lqI4NVWrYOguBNbuMzRfyC8edBVLx6KGW30gkJA0V55M9SK2T5O5Qs3dXttUaNm87SUB6hyV0DL8cUykgCN6kPC5FWDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZFgDWToq; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZFgDWToq"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-848d21bbb55so2419488b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527783; x=1786132583; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=x1rfv+ZTByjOzukF+HUPO8Wjg2keXlPKVWZZNi7BXT8=;
        b=ZFgDWToqxTN4MZOfEsNfgHwF1caO5kt5K30douuZF4nQc2uNMsAojQk4vImRWPpwtx
         m9otvnIMRJGqPU+mf7CjCIpMJMtESBE9gk5GmyaaoJt5SviAKa+jQ8GK5v1Id505TlX6
         rmtiAICyWcxPahmMLlpafGsUbX8/gYtfEkalfOWIaDaqjzDDb5fOTO3JPBW0qeNTeuSE
         UyxaCHHmfqx8avvAFEYv/FUpii22ghcjNk19XJI1kdePSy9wYqdHOR+Gjav86FWWMWv0
         2eXy1c6NO1ZrR3sbfNhfu1+VO9mfHWSPmHLi+rVjUvVgIu1oIx6idf5MlVXNcfcD2sXg
         2cUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527783; x=1786132583;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x1rfv+ZTByjOzukF+HUPO8Wjg2keXlPKVWZZNi7BXT8=;
        b=ojomfRHzAJ1d6LmROjE16ksgaOHmBV0LEngPWKYSb2bffemPg9kNSg+ju8awDqBYUO
         XYkT5vds80VtQSws7Qe/7GK713VboEXWM2uv+xHmfLECv84lY4/4FuIVm2I3F6SktSkD
         O+x4YwyNLyykQwF1D3peUw1Dcj2EMQDvu2U2G/iTDBkPJOZmcVd4DzVkRcqsiRGDioZO
         l1Vkeit31rZ1QAI3Ow805mF2BCorLnYICYYpZ/pJFlqreMBg/MTUBd2M9KZ4xNRCx9kx
         JKri/Nh/KjNByzq5NU/+I7jigQIt7XpBKvSXw/rL24hh66MA5/B+xNWcyBFF2d/Do9/V
         ljVg==
X-Forwarded-Encrypted: i=1; AHgh+RpcBX6ll4hUqRkaWMhorMUKHjw7uvey9TZSsZP7HvuKrvJFmwTKNXqWVvuqUgP1piUeApUr/hg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzn2m7gUvNqiqG5DmChpLOIijfN40thXn/chwpadJxKEYF6lK06
	5p7vEJOrulDUF7myd6nimROVtlJwhEB/GqDnh6XLbZj9FqizA8695HcMO2VGhJAHsqCfOi+4bXW
	qBWJLLQ==
X-Received: from pfjx14.prod.google.com ([2002:aa7:9a4e:0:b0:845:ebfa:4051])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:138d:b0:848:5010:ad39
 with SMTP id d2e1a72fcca58-84ee48d1617mr785061b3a.46.1785527783246; Fri, 31
 Jul 2026 12:56:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:06 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-7-seanjc@google.com>
Subject: [PATCH v3 06/12] KVM: selftests: Affine threads to random CPUs in
 hardware disable test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Affine the worker threads to random CPUs in the hardware disable test, and
honor the starting CPU set in the process.  Hardcoding to CPUs 0-3 is both
wrong and less interesting than running on random CPUs.

Opportunistically convert the local 'i' to an int, as the macros it tests
against are signed, and using 'i' as an iterator is conventionally declared
as an int.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/hardware_disable_test.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index b4edeadfa3f4..fcc06c602fca 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -149,12 +149,17 @@ void wait_for_child_setup(pid_t pid)
 
 int main(int argc, char **argv)
 {
-	u32 i;
-	int s, r;
+	cpu_set_t allowed_cpu_set;
+	int s, r, cpu, i;
 	pid_t pid;
 
-	for (i = 0; i < VCPU_NUM; i++)
-		CPU_SET(i, &threads_cpu_set);
+	kvm_sched_getaffinity(0, sizeof(cpu_set_t), &allowed_cpu_set);
+
+	for (i = 0; i < VCPU_NUM && CPU_COUNT(&allowed_cpu_set); i++) {
+		cpu = kvm_pick_random_cpu(&allowed_cpu_set);
+		CPU_CLR(cpu, &allowed_cpu_set);
+		CPU_SET(cpu, &threads_cpu_set);
+	}
 
 	sem = sem_open("vm_sem", O_CREAT | O_EXCL, 0644, 0);
 	sem_unlink("vm_sem");
-- 
2.55.0.508.g3f0d502094-goog

