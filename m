Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4439388881
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787734930; cv=none; b=Oh1cULCXAEwMrYlYCaIMG5duO5IO4CHIobs/0V3RbPD0DcjT0zZc6a+hqAzqZ0DrCK8h9HZ0J1SCWOLaSuhZLzMMpob9AVZ98x36ika2RbiJljpi4JiEQTPJN8ZFB7u8lleX/usC+H7xKsA5E90/1PnVjTEelJgOJnUzpddF940=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787734930; c=relaxed/simple;
	bh=enAIdIfpjwlSqC1gWlXPx7NV0FU3Pk1m0whhjn5JXcU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G2zlGbRzBm3oN5mYD83Alcso6sAOrM2jf3NXOkMHCkaSfXGf9BKcF5aaj8qftI5mE49NckQia5f2a+JLasRpMYFG5EG1+rhIWjnQGAcpbG9Czu+LzVc9akZ2TLVrbSTLi7ORjxSrbfVI73i6+Fh3MOFvFb0TeIw/7vRrpYmSjNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ggvqOVww; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ggvqOVww"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so13180175ad.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 02:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787734928; x=1788339728; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2t7yDZCgF5yF794oBaYJTVqMg1ClYWvzuDLcLD0bTKE=;
        b=ggvqOVwwYrShqSmZowYYXcVnYrdSgWl+VQ9yZhJfYX6yK3CG+mYSXXqcl9kAtMFIJ4
         NibYu9nLFUBDHyo5YE44k9i2pBSTslCbIJQA+1Z7ExKwDV6w/aGnrXy8EB8uUQ/9Kh9+
         UJNldhMBBI8tB5aD7Fo92nNRlpsm8OruTBv18VqMWM+SdlZjxzWUGoQnO7tV2YOYdVmC
         DQXY277g80P5JYE0foTSi3ILOEQLI9x1NGGXOUeGjYc1p9rj9DFlaGO/1EBqoZ0biBGo
         T5cGKv8kMshrcJj5mNz42JykugVW5xBYvzyYjRbt8lTwbTem74wbmdrSiQPxo3ZcfHUB
         9fnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787734928; x=1788339728;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2t7yDZCgF5yF794oBaYJTVqMg1ClYWvzuDLcLD0bTKE=;
        b=GrOBO0kb5n02dZSErwBEHLMfKWKPg7Ox16TRNXqzxfItTFNg8Oey4sQhziwePHH9ho
         tjeOJI2kJa/pUCypOMl6T7ZKLnw7+WLTkoottzaKYoRAUOKpYmYQ+OsTU3uBu+VFRGO8
         PRrGc8UwRf5pPU46kh/W2R68NmaOP/i2VGKf5o6Z/rY136/LA7avomWkNCY4wWEYyONM
         79mPz3pBywxM02ZwWPzo12C/9rMDlgKsKEJRAiubixekSi78KAtMzVKtqgIPbSrs4l08
         EJX/Wiwzo52HwwaHqjQuKHIB/Uou1iLr4QmHT6MaMLPVj3ISf1t/K7UftHww/fwRG26t
         0jGQ==
X-Forwarded-Encrypted: i=1; AHgh+RrJxRk6Efx4P1S7XDHw2gVq8Au5/1JcTJpAK8U4ZJx4OEQib43PQF4NcID27MO2a57NcrW+YB4=@lists.linux.dev
X-Gm-Message-State: AFuF++kX/VI/ayhbjx2HIaS/khusiZt+aitUQPcHZQuu60XzF90DSVCo
	UxzmhJ5k1di8vWso30rzxq9uvt+Q0dHchaZw6T9TOGlmI16gwXPdL3NfQBkQJ2fym1vnnMUkLoE
	HNLNNJNYo0BQAkJn5fO9/cAKCmg==
X-Received: from plae17.prod.google.com ([2002:a17:902:e0d1:b0:2ca:cba4:f740])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3910:b0:2ce:faa6:7cbb with SMTP id d9443c01a7336-2d707a3ed87mr93106385ad.4.1787734927046;
 Wed, 26 Aug 2026 02:02:07 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:01:48 +0000
In-Reply-To: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787734920; l=1785;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=enAIdIfpjwlSqC1gWlXPx7NV0FU3Pk1m0whhjn5JXcU=; b=X/J0naFXaXcacGRfyWJDRGmjT1pR6S35RpMfjdWjFbARTVW571RbgREp+itIh0+NkYxsS2pCt
 0GRcegdOuePAemCvojQPvh6N2NgBYZnP3n8QANxjyBigz32FysjP3WD
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-no-return-page-v4-3-3bb9c1ddb4e3@google.com>
Subject: [PATCH v4 3/5] KVM: SEV: Check for invalidation before warning on
 unassigned RMP entry
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

When handling an RMP fault, KVM looks up the RMP entry for the backing
PFN to determine if a 2MB page needs to be split via PSMASH. If the RMP
entry is not assigned (or lookup fails), KVM logs a rate-limited warning
under the assumption that private memory should always have an assigned
RMP entry.

However, a concurrent invalidation (such as guest_memfd hole punching) can
race with RMP fault handling and transition the page to shared, unassigning
the RMP entry after KVM fetched the PFN. In such cases, not finding an
assigned RMP entry is benign.

Check mmu_invalidate_retry_gfn() under mmu_lock before warning about a
missing or unassigned RMP entry, and suppress the spurious warning if an
invalidation occurred for the faulting GFN.

Fixes: c63cf135cc99 ("KVM: SEV: Add support to handle RMP nested page faults")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0d027cff734cf..f9dce8acac8eb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5060,8 +5060,12 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 
 	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
 	if (ret || !assigned) {
-		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
-				    gpa, pfn, ret);
+		guard(read_lock)(&kvm->mmu_lock);
+
+		if (!mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
+			pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
+					    gpa, pfn, ret);
+
 		return;
 	}
 

-- 
2.55.0.887.g758fc8c411-goog

