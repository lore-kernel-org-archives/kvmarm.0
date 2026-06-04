Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89842E1C4E
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 18:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780597807; cv=none; b=erCm1Lerc0xTuZTTuSgaWgqPsWFLICQ/+ImE7eDnBQ6N0EQg6Ia/JDLrvBIyOrmjU0tryZk3dWgjJtE7JfEQAIfcd2rbf81ih1mHZoeshRl8VOmV8Z9ZCvB5dHFRHoh/sODwRlF+IzYTid9ODMoffNj91K25Bi3X1HNZFWJzFC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780597807; c=relaxed/simple;
	bh=Z9l/wg+Sz2CoZ7VKUkQgRztRX9E01KjYMDRZrzi+3lM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EYW4hbvxmoq4hZ3F1UqYD2/IdPhwg/b/9A8jYMwf9RVy+bO75oDJGdp8a0wKafyK8uyIEx5lukt3nRByrBLM+xcoOnhQDFoGlS6hd/kz4tmqfsuEHG/CYGQpE/9bspp8G8znrXU+ihDTTlJwC+TpcfCp9BjwAgr3Up2x2JlMypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R/9hBiC9; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R/9hBiC9"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36da151a152so797534a91.1
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 11:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780597805; x=1781202605; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7T8kJ0gjf2hk3Cxd2ChpK32DU2yBtKAlDAVK83XkRZA=;
        b=R/9hBiC9RuteufgNyCIUeM7YaFpnSY0mT0MPl+ssEq4SUBD5ke6EpdtnzZElJV4JgE
         OMf8k3s7jA9JyGpB5z5QTVy6vz9pZ0VDZrN5zQyk4nKhL5MVEDWjrbps+J2v+y+ybwQ2
         d8KxZS+d8jyBR4/DGYdx0VTwub2wSyYdKP8FtPNsr+I9kqJIWY8ZzUTZc2DqfMAI8XUe
         LRzUlb73vQAGZ7V9I21fsLc+HSGpI1p+syPzcBjV92Fm/k2iMn8o9bVfh6U3pjDMakU3
         UVSsseWxcaAaUd5KOos6sP5xvPDPSwboRPpXXuNJEeNwA2KaUOniP3vpqWm4228gTpEL
         EVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780597805; x=1781202605;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7T8kJ0gjf2hk3Cxd2ChpK32DU2yBtKAlDAVK83XkRZA=;
        b=X5FgGFpqB/sOirWP1JRmTYWXR7HjCUUSu3FzOaHW0IyVlXMbaW4rRoBax/NO53UFQa
         ISbXITeWpY3WYz98Zn5SMg0hR5kqzI3LzflzwOtgEGkplFp0qWLyYqqQtkdjufLmxseP
         0r+g4ydv+TMpTX7tZvYDTj3replDYbiR99Fl+BbqTka8hZYYyDuvRZQjhZNJ3I6lRVqJ
         l4yjRHWck6QiTO7proeRVCXULXF1rm3ohk+5d49mq/cH2hc9XA94S0eBzH6qztWFdBjG
         SPOt5Ie3ZjovyK3f4PqSwtvXwZ7L15+0LLzOk2fE+UOQlWqZJS2YoKSKemA7VYxN9kuX
         4M8A==
X-Forwarded-Encrypted: i=1; AFNElJ+ye3eGWQ4J6V5lflJ8HxWgZvL7YHtSmGVdtd+ZTVaf+q1Jg70ZCzs1jr0Xz6m0YUaPH9eEbow=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEsPY5EKfP/Yw/v3JaaiCoBuWwMinvlLSWoNNbwqImBWnSIyMg
	PaLHg0cbA8BPc2YNPbbmNl5Xs5JXX4VW64hbX3huH5n0bnSoESmD0jla
X-Gm-Gg: Acq92OG0ZvQr4tFbVcRdTzGiFm6kTVUNJA7g5LvwNzU156gYtZ3XHNka8ckFNg7k1cR
	CmhSUYKVjIlZCAjMh57V7Yqfzke1pbcqyWhlZa2GtC8avnkoTBEVGttlJVxBOdQlEvGzmUSrvJU
	bhbrA2vHiwnwVd32v61muIEb1vQWo4g9rjJfiRSrf5e8XZpCzi/jQBgA2qkVnPUrWaAqdLsgAZI
	tlkGpnni7lritVJoQl7OsBuRQ17ejfizF6eJ3FM3VW0grNdVGTKwNgK+XoDKbdHQFoCAq10KPnt
	3xvZtHuhbGlFK+21EW0VQ8iH1kKiVZxCkO92B7+C+bu9qctDJLvA83iI1iXg/BOuZb8PNmmOUzW
	V4I/xLO1yV5B/T9gpnq9xai225V/MGxjCPmYz8NcPCTE87aQ46KHWXqrfxw7K0BBNKyMwIsSNw9
	4nkqWXIBVEDCIq40rVqLwTj6fL5sgY9XfDXFFGqWD8PZVJOgLA5kaS8Q==
X-Received: by 2002:a17:90b:5210:b0:36a:8240:2477 with SMTP id 98e67ed59e1d1-370f0967012mr114863a91.19.1780597804928;
        Thu, 04 Jun 2026 11:30:04 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf827e6sm5494310a91.1.2026.06.04.11.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 11:30:04 -0700 (PDT)
Date: Fri, 5 Jun 2026 03:30:00 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, christoffer.dall@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH] KVM: arm64: Reallocate the nested_mmus array under the
 mmu_lock
Message-ID: <aiHEKOeZMVwsRlvP@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Code that walks kvm->arch.nested_mmus[] holds kvm->mmu_lock. By contrast,
kvm_vcpu_init_nested() reallocates the array and frees the old buffer while
holding only kvm->arch.config_lock, so a walker can reference the freed
array.

Allocate the new array outside the lock, as the allocation can sleep, and
do only the copy and the pointer swap under the mmu_lock. After the swap no
walker can reach the old buffer, so free it once the lock has been
released.

Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/nested.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 38f672e940878..6f7bc9a9992e0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -89,21 +89,28 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	 * again, and there is no reason to affect the whole VM for this.
 	 */
 	num_mmus = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
-	tmp = kvrealloc(kvm->arch.nested_mmus,
-			size_mul(sizeof(*kvm->arch.nested_mmus), num_mmus),
-			GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!tmp)
-		return -ENOMEM;
 
-	swap(kvm->arch.nested_mmus, tmp);
+	if (num_mmus > kvm->arch.nested_mmus_size) {
+		tmp = kvcalloc(num_mmus, sizeof(*tmp), GFP_KERNEL_ACCOUNT);
+		if (!tmp)
+			return -ENOMEM;
 
-	/*
-	 * If we went through a realocation, adjust the MMU back-pointers in
-	 * the previously initialised kvm_pgtable structures.
-	 */
-	if (kvm->arch.nested_mmus != tmp)
-		for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
-			kvm->arch.nested_mmus[i].pgt->mmu = &kvm->arch.nested_mmus[i];
+		write_lock(&kvm->mmu_lock);
+
+		if (kvm->arch.nested_mmus_size) {
+			memcpy(tmp, kvm->arch.nested_mmus,
+			       size_mul(sizeof(*tmp), kvm->arch.nested_mmus_size));
+
+			for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
+				tmp[i].pgt->mmu = &tmp[i];
+		}
+
+		swap(kvm->arch.nested_mmus, tmp);
+
+		write_unlock(&kvm->mmu_lock);
+
+		kvfree(tmp);
+	}
 
 	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
 		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
-- 
2.43.0

