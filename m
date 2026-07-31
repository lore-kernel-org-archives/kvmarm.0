Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECBD450917
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517592; cv=none; b=eHaBlq1APakV7V46ZTKR/JN5uSH8SKImFd1aydUVoaGX3rZrzvGCLAaAoed2joH7s/O8p/0WFjSuYxdJSneQiyeLVynmYcp40F1OAxBpqXlbGGJvEpO14OzXFFxw3ziMmgNsOUfm12gTOiIXmHnAqsNLnns67r6nza561EgMYQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517592; c=relaxed/simple;
	bh=atVzo7J4szz2vu/UetIPVOdW3jQWtD74LNLShVxaLFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l2IHKxJYj1ZlzFKVJrrA7yg2+37tvScRohz7MeBwEbLErL5JYfuehU1h+JslOfPz1POzdraiP8vUkbPeD5yHkoPQUQUIzoN6BTCCnnw38jxTzypdkno72P9ezCD21U4Ob70xuDgIQYzyIRkd+4ybvld2DipUqHZ+VD44AhAG2+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uaMTYP4+; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uaMTYP4+"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cee894b3d8so21416055ad.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517590; x=1786122390; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9BfMO7lDi/jb9f6SoYoHXqiGNPLVG4w0N20HXOwKIiI=;
        b=uaMTYP4+nBm/lZISa7wTcxGbF/eDWAPQjaDQ7a2AWE2bRzx7Ke/O1skE6CfiHsWP/n
         anglglfJP1THlcJYizNNp0MKFLR4QHBWqOd5tNDh4rjQITCz6sSN7/yNWfFoF6YJFF91
         dOgv06ujDJHDZJNsjAL6Ajsfsf+p37GBnmvkfKWpxzGCi+ErGSxlmEtMhi/x5J0xdakr
         EHDRCIbN2IZ6PAVVTKNVTrKeayVYG/ug0rezDA8mdQbu/jsdCN02v0qs6cS/JjO80cY2
         OKQ+6XgwD/5pIbuoH0C+Rjj+lkVcpPYEawaUIzaXqNU6k7yA6/Kn6yC9A6rYs7//qTzE
         7kkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517590; x=1786122390;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9BfMO7lDi/jb9f6SoYoHXqiGNPLVG4w0N20HXOwKIiI=;
        b=pu2eUi/A5B+zrr43YXUg+0PRW+QSEwDoMokAT8OkUA4o4Wu8YUo+SrtHf7w+JE00hK
         ZNu+PrKAWKiHqbZhzIUkoIySkAt3NYC39EpMU7xl7Sotdg98LggiqTd4zYXP8qCKxfTg
         zRMaKGfcf2p4qOQTJBv9mjlStjQmpxCKzaCDaF0OqzV/I3ZDfZzp0FwXQzaHWUDNtuRH
         4NJObtZm1Wnp7eC1Ov7scmqlqiGhJgVFdNZYiO8wrpOvCOnZlXsrySq1PQYJ1MziB+iS
         f+7v0qABRJP0ZRNwSs2CkyptrSm3KElpcj0qUUQ6sY2prtR2aV+upr3B3LOJC+5PZ7JA
         6YDA==
X-Forwarded-Encrypted: i=1; AHgh+Rr8ptHcHZkWigLNYeywHxRxjSePzsn1n63EsiA8vrwqXmdpXOBcy4zDxKTnSbSmn1rd7RTOQI8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf3WBQj9xqGoxFvmnWKMf5tKoLLqaycfVORLd+MtZ5M+dtGvki
	deoMmYWTjyfutxCKLBAw/EubwztUQz+UD3GmBUzPJ4DqSwkMdlSny6QAzEsVUo2gqCGlDD464cG
	2lCl5eA==
X-Received: from plje10.prod.google.com ([2002:a17:902:ed8a:b0:2ca:e62e:eb94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2d1:b0:2cc:6817:d9bc
 with SMTP id d9443c01a7336-2d0523e6ee5mr6994735ad.38.1785517589951; Fri, 31
 Jul 2026 10:06:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:13 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-7-seanjc@google.com>
Subject: [PATCH v2 06/12] KVM: selftests: Affine threads to random CPUs in
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/hardware_disable_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index d8288147b0a6..bd23c1300370 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -149,12 +149,15 @@ void wait_for_child_setup(pid_t pid)
 
 int main(int argc, char **argv)
 {
+	cpu_set_t allowed_cpu_set;
 	u32 i;
 	int s, r;
 	pid_t pid;
 
-	for (i = 0; i < VCPU_NUM; i++)
-		CPU_SET(i, &threads_cpu_set);
+	kvm_sched_getaffinity(0, sizeof(cpu_set_t), &allowed_cpu_set);
+
+	for (i = 0; i < VCPU_NUM && CPU_COUNT(&allowed_cpu_set); i++)
+		CPU_SET(kvm_pick_random_cpu(&allowed_cpu_set), &threads_cpu_set);
 
 	sem = sem_open("vm_sem", O_CREAT | O_EXCL, 0644, 0);
 	sem_unlink("vm_sem");
-- 
2.55.0.508.g3f0d502094-goog

