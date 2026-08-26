Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16C03502A9
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787734926; cv=none; b=TtIo0Lr0uzboqaVOPC7Ok3O3mja/k7DCuI/r/YEZDzuPJZPGjwxGupXbDhSHerxO2k5oYzY9qYnxHzn3NVr9mLZRmEvg/yKZP8UjDVdUdLCb/rqZxvUSPSHQy5P9lRHriyPXR7+21K/ozrr9MJnu7lV2NKh/21rJQm1FHvkvL3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787734926; c=relaxed/simple;
	bh=tBQj3Zs/zFgJuqob5UUxqzp8WSGa3DX0/uF2e5leoMQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QIDYt7bhQd0pzpX6P4YcbznOkrOxlau+wQCEc3xbsvV55wncsfVogIpAG/30fl46+FKufLIggSxaqGzrzI5xyDDvWtN11yAB4P6TNLKXR49Noqdz+S3eoIDBO+y3jYd+c3EYz9G2/yNS1wFRzqLGFvRKNQoJQHMWC7U+vlJl5qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pGVyO0uq; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pGVyO0uq"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so1631953a91.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 02:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787734924; x=1788339724; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DUYw+bKmtZMKiUuqmTKklNQo1kdVyC2ASm9zrjeaODY=;
        b=pGVyO0uq4EVBbTJCWuTXpHvTAuaJ1rljB6c74lwquwSPTrgemzNXRiFHLwp+6enEqP
         HmQ3u56jaPHPCDg0y/sbdX2h9Jj5dmfEVaS0ZE/zwWy7vyrvxZcnwNw+2kII4Bc2MmvC
         yEjpe2lSBkSZmbEklNvvwuna0QvOO29MZHAk7Ztf1ao5hTCnriLNHMsTMQC2ybSaBjEH
         UctllmWdkmfaCCWsjQyXrWb+yvtke2ij1ng5K83gNezyX5QQVKkWtJ7C1JxwBGyLKeRs
         8Uk0YeLkjp722dV2HeuTu54hM0tPKA76rYMfz/tA4vyAjDclMtRwP4Oaj/tn9QO8NY9Q
         KPxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787734924; x=1788339724;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DUYw+bKmtZMKiUuqmTKklNQo1kdVyC2ASm9zrjeaODY=;
        b=pe3pTyLbxudxBXnCg0+ZTd5DzXbB2bl3niw4oOroDtFAt0qlKneHW0c3AhUJ1OvIry
         bzJZqErU/43B1A1OLsaQxOGtTYnyAg7m1tH8d3ew86NyhAH0gWxS0gqEK73K+bR0RDa6
         j4FOUTVmrtIq/Mo91jhG7QmvpdaZDgYvhUF9oNT7hxPoaSLhRg3+F0xAquShN7dlKDLD
         xdUJ1udPTTmHwWGRqt0daj+37GwovmcOTb/fIEMGguZStxDARZsXuZmnqRVURk1XVCvv
         D4FsHjx4Aq05GWDEyIbkKrExxZ4tKf1aJoJTOdGJC4thTuZdZmg/UBsxIZhDssg3AKz8
         lVkQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrtl4Z4D9uAeg+AMwHdQfeNxQIpc271jsdjYAILGnzdHg0BWCMYdc6fBOLuCIq1gLRjiwnyyj8=@lists.linux.dev
X-Gm-Message-State: AFuF++mI4P96652cFZHX7xQLlDkOkXf8CWtDyWlb8oItv81yA7Qn0CM8
	n/ZEBWPgDvLFCo9QegzFpLY99yTmeRd+pZTdnqQPfv5l2eo44kGv1eRijkaNrVJgiPEVO39BN6H
	vI6acEp0hPnynzjQXzRX2D7ejfw==
X-Received: from plhk3.prod.google.com ([2002:a17:902:d583:b0:2cf:7c8c:cf2c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1c83:b0:393:19a3:4f1 with SMTP id 98e67ed59e1d1-3966d1a48b7mr9860233a91.6.1787734923676;
 Wed, 26 Aug 2026 02:02:03 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:01:46 +0000
In-Reply-To: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787734920; l=2054;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tBQj3Zs/zFgJuqob5UUxqzp8WSGa3DX0/uF2e5leoMQ=; b=nHLIey2i5u9SSFrucSIZdJ1XmfoAN4s5aKHgC3ZELugP1EEPbj+x4Hm6gj03zMVF4F5nca+id
 ZU3e9ubiktdC65mxiZZgRyVvXsoN/yMoCRncYdGQyOWDEy2KAsc3df+
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-no-return-page-v4-1-3bb9c1ddb4e3@google.com>
Subject: [PATCH v4 1/5] KVM: SEV: Treat unassigned RMP entry as benign race on
 PSMASH failure
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

When handling an RMP fault, KVM attempts to split a 2MB page via PSMASH.
If PSMASH fails, the only expected return value is FAIL_BADADDR, which does
not distinguish the reason for the bad address. Hence, another RMP entry
lookup is required to determine whether the failure was benign.

Specifically, KVM re-checks the RMP entry to determine if another CPU raced
and already smashed the entry into 4KB pages.

A concurrent operation (such as guest_memfd truncation or hole punching)
can also race and transition the page to shared, removing the page from the
RMP table and causing PSMASH to fail. This can happen even if the page is
still referenced by KVM, because guest_memfd reclaim transitions the RMP
entry to shared when the folio is removed from the page cache.

Treat an unassigned RMP entry as an expected race when re-checking after a
failed PSMASH, and skip logging an error warning.

Fixes: c63cf135cc99 ("KVM: SEV: Add support to handle RMP nested page faults")
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/svm/sev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5705723f1f412..e198469eb074c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5090,10 +5090,11 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		/*
 		 * Look it up again. If it's 4K now then the PSMASH may have
 		 * raced with another process and the issue has already resolved
-		 * itself.
+		 * itself. If it's not assigned, then this must have raced with
+		 * another process that made this page shared.
 		 */
 		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
-		    assigned && rmp_level == PG_LEVEL_4K)
+		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
 			goto out;
 
 		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",

-- 
2.55.0.887.g758fc8c411-goog

