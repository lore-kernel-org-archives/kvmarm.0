Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6281F3AB5C3
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 07:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780040627; cv=none; b=J4Qx61uaD+x/jsxWfeqMlSreogvanhYv/aANrBSKlew3fvFyxoRFAPftilSiYrXEVPFNe7T+lTOfLm5JMygb1HxPQprDUGHpkNTQIzY8KAKMlsHsFxwmeA+4eczOFtBq/vic9a1FoxlpNmBwiHR6vSthCZJbqDNrrU0TzjEImUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780040627; c=relaxed/simple;
	bh=Qps6o6tLw+5Z7L4LX52l3zL+jrsDKX3MK74mb9UYQZA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=udzj0F7caF69xW+W5vg0TzmMfsqCPUta1F6VC04weMtgqYJoW3j+4wInN/TdqsNA0p0PR8dh06ni38PISz3h+qrHQinnUVMzysBHT0Yb6zTfO+si3ypzmVedc/lHFOXTTkyiWHYkw6bj10r+adsEe4gF/fkN5yfyqnV/HU3Jk+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lmLxwqlx; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmLxwqlx"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-449b2a183d3so8556884f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 00:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780040625; x=1780645425; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u7WGxRyEbovaCEk6n++MhLN9S+efqVE7Q4ikibcd+yY=;
        b=lmLxwqlxIvPheBfQc3qXvxH/EHIhDJ+cViY/ivD72/9HJZqQ9rCyle2ZCOPKLIXnOJ
         4zOGZ5qUXlmBRyzX4LGZtfLTHG/caz4ksKGJawmyYaaOyLCmpmJ64HgRcO0DYTiF4GuM
         5l6e88fdQyjIbklLY9Pz+5+uoikymA2HUA4II03Pr3nympHvVXAlfoM1RT77czPNjP1u
         hjp3qrDw2CZpeQIZcr0UMUGAVKz4ndUnaTey8RNyQutmt/GhNISn0JoypUujySPP7VGw
         oHGXINKNI1LkJvyUQ5j578GhPzybdctJ4Nh4cmX9JSkeqgH0p07w59jk8i4z9ZUYtNpq
         nnHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780040625; x=1780645425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7WGxRyEbovaCEk6n++MhLN9S+efqVE7Q4ikibcd+yY=;
        b=jvmrb0QfJg983sqn9DlnSWVOaYPm/jZiAoeq7z7Kmxpnmerhi4C7Q6y2M4nkscv6Dg
         bhvhKPG/dp53D+mvNVrls3WmaxVzCrULGbIJ+JeZ5Imla8BmbEfT1pvO1/ZEqL+xnZxy
         N3Y/SOakORxEnJRUrqNw4VxvCPkSjTx75V+Jj9rFUvUUXpXPoKMCAXDM5mhh0cltIDC3
         FmOZbGzRh5iLKZmJZimUrtWE8Yy8zifHzDGNO4x0EFL+LZh6ni/B8UuNh/I0mKR6o3c1
         LsWg83vBiqAiCrOvgj26ZA4sBXvt/meuheWOnqXXUXS3SQ2a29CSa47cHQCOj+TniWm/
         laOA==
X-Forwarded-Encrypted: i=1; AFNElJ8eTr8YvnQvxXlIgS74HaCr6QzPinm2ipVQ9C7zziXc73eWR38JNpunlbDMLyAY3hVGEdfm6so=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6xRD3YVFho7gYVyvlj+E9bM0PG1toknjxTtqVniG7K8P4lyNz
	EDw78jP5ylLr91x8/TZMB4JXPGr5BBJDyIzSc9yqemZtodWcWJBJRulcvU2F1bywzMTDA5OexLe
	8tA==
X-Received: from wrzf10.prod.google.com ([2002:a05:6000:1b0a:b0:450:e76e:87e1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4683:b0:453:9897:76aa
 with SMTP id ffacd0b85a97d-45ef1385c29mr1854131f8f.21.1780040624606; Fri, 29
 May 2026 00:43:44 -0700 (PDT)
Date: Fri, 29 May 2026 08:43:41 +0100
In-Reply-To: <20260529074341.2271950-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260529074341.2271950-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.929.g9b7fa37559-goog
Message-ID: <20260529074341.2271950-3-tabba@google.com>
Subject: [PATCH 2/2] KVM: arm64: Avoid host/hyp share desync on unshare
 hypercall failure
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

unshare_pfn_hyp() erases the tracking node from hyp_shared_pfns
and frees it before invoking __pkvm_host_unshare_hyp. If the
hypercall fails (e.g. EL2 refcount still held, or page-state
mismatch), the host loses its record while EL2 still holds the
share, breaking later share/unshare attempts on the same pfn.

Invoke the hypercall first; erase and free only on success.

Fixes: 52b28657ebd7 ("KVM: arm64: pkvm: Unshare guest structs during teardown")
Reported-by: Sashiko (local):gemini-3.1-pro
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4a928fb003ff..8026e834528d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -524,13 +524,17 @@ static int unshare_pfn_hyp(u64 pfn)
 		goto unlock;
 	}
 
-	this->count--;
-	if (this->count)
+	if (this->count > 1) {
+		this->count--;
+		goto unlock;
+	}
+
+	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
+	if (ret)
 		goto unlock;
 
 	rb_erase(&this->node, &hyp_shared_pfns);
 	kfree(this);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
 unlock:
 	mutex_unlock(&hyp_shared_pfns_lock);
 
-- 
2.54.0.929.g9b7fa37559-goog

