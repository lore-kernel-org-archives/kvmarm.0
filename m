Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A669C18000
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 11:41:14 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-583f048985bso58633077b3.2
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 04:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690803673; x=1691408473;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J2Uh5pU2+7wUvvE7qPcCkAGn2ipptuy7Morl4s3U5Yc=;
        b=T1mp60ZQTpJuwo4KyxeRSUlCPImRzMG/olslVfTJicv2F5wtxnMJQzfQLMh+1EgjOV
         a9FDotgKkPcNfi4DNJyGOu717G6IOWBkKEdbMhwV/m51bR+QsLV/Glhw20TI02BPGI63
         qGQAJA2Bjnd2XwqvOS5EK/pUkajd2XjE9nZ16y8OOtYOFXA4iOkuwGEcX+nOa1ewjjk6
         /M5bZYEbpMAC7HWnBfT5ZPsm+tkIQQXAXgM5gykNXCw2hh9jB9UZqLW5QAS3R3OanTpP
         mdzuepTP4RoHhE+KtjkVQ2O33SvdPcf4eViYXLtP+qamFu+k60K7OFEmJCM4km52DAhW
         parg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690803673; x=1691408473;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J2Uh5pU2+7wUvvE7qPcCkAGn2ipptuy7Morl4s3U5Yc=;
        b=N0T/q5h6EQkvuCvIRj1v+pX5/I4XNm+D+3YqXJ9NgP4Oy9eb3LKFpjAlQ1+ibeEvfE
         9wH4IhnISLQKkYj8b0njq8xNxOxT9a8RJ5QurS/ow/f/jFz/gw1fol5ULzPYM+gRofgn
         ScUbnowmvNb3ddFS4/Y4PMkU9lXgT8WiBLKXvpbkgQ1hhh3olji9mIbIZXLkL8Znzijw
         efXWBX+aX0OZyY5uA0rrrD4sYAgmFyBg0cOD37pC95ZHRvXAdOeCruy/XCCr1njPwrRn
         Tsf8Fx0MbZPfN61G1XJJE2nD2VINLC6g3fgUFFw41kklfi/FYzZhJgeOVamxYWBl6b4a
         2t7w==
X-Gm-Message-State: ABy/qLaFiS7q25kyoyQNlpEif9DI69K/RuQGFszBmS+TwhWOPkJiFvha
	QcLVIu4VDXtTELTr+spTsWHchZf+tPiyxIX9epVzyZu5o/S3AwcS8uAXGvT7r3qZ6WaM4TzlDq3
	39HiGswl//nZBNGvJs+/hzfPSZqO7BUiG6aw7ifQYisX1Kz8QVHmPYYslS7A=
X-Google-Smtp-Source: APBJJlGUcM+v62LGfBMdbL/0Qb6Gde1C3RkNw5HsKVJ0y2lFbSehGU/43Ozc8ESWUdhI+r/z3/hBd6+Xfw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:a784:0:b0:577:d5b:7ce3 with SMTP id
 e126-20020a81a784000000b005770d5b7ce3mr72007ywh.9.1690803673197; Mon, 31 Jul
 2023 04:41:13 -0700 (PDT)
Date: Mon, 31 Jul 2023 12:40:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230731114110.2673451-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: Remove redundant kvm_set_pfn_accessed() from user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com
Content-Type: text/plain; charset="UTF-8"

The function user_mem_abort() calls kvm_release_pfn_clean(),
which eventually calls kvm_set_page_accessed(). Therefore, remove
the redundant call to kvm_set_pfn_accessed().

Signed-off-by: Fuad Tabba <tabba@google.com>

---

Based on 6.5-rc4

The call to kvm_set_pfn_accessed() was originally introduced in
35307b9a5f7e ("arm/arm64: KVM: Implement Stage-2 page aging"). At
the time, kvm_release_pfn_clean() did not set accessed (neither
directly nor indirectly).

 arch/arm64/kvm/mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d3b4feed460c..137b775d238b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1541,7 +1541,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 out_unlock:
 	read_unlock(&kvm->mmu_lock);
-	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
 }

base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
-- 
2.41.0.487.g6d72f3e995-goog

