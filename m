Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1007A15ECD2
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 20:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723236727; cv=none; b=NM1+S0Q5mCawJRiwRvxax57jnj5ofgr121OTdjRq5Fg/M3xIE/TdnGt8/sAhtpz+DDStyzQKVs/VtAHeykQFIvL1Ox1ZCCzewS3Dw7RJbk3NoFhQsKOViizfd4/3JRAL8tN6fWGMgAtURTmfXHUtxawBptgy/+1Kc8YJhu1u4zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723236727; c=relaxed/simple;
	bh=F/i+lgt9dfMODC8lpmtv7OIwLyDsx7Z0jTeBvQyEnTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oeIAj6kMt4YqlmT1V8ebZlYlL49gCxFvfGgdfT4ikyfh2zgveFY8VurJ5MPbblG5Pt8FkVUI/rqrcEExtc4xqaEc5P8y4e8noH1rkFCQbMLQs/tncCIYDom1+17P1rRuK3uTHk7V/2XK8pXZzsIlS3Pn7aS78XCsDNxyQBdeBSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lQLeWYfs; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lQLeWYfs"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso4390812276.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Aug 2024 13:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723236725; x=1723841525; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=54OZeUBWyPXA0S87QTioBQQ7Q2CkC6lMvkpXhup6C7s=;
        b=lQLeWYfs6BWr6TLPfk7P+zJjcvqV6RkEFzs0wWn7yHqjCg8qBbbWc+bTSaY4KS++b7
         F01L4VbkFSGmFK0rdY+sQKqXuiLoWEuoHJcjI5G5DURENBWy/ova9uT0MSksC3EM/O3Z
         2z2BgwxtMQYJJADWAUHCDR4GS61A1xKw1nL8kDRBs5WhSL7TB0h02ZcyvosB+m6BHSN5
         oGcLaE7AmllrjEoFWoVkFTWZG6w56rtcrokWsYOdQtwpjYqwNwdwmOiwD6OXoh7JhB8k
         AjXXj7DP1HFjHZc2lALDJYTLrHNBS7EcQcloleejQzfpOZBt+Lucbu+pWX3mq4fwQD4k
         2x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723236725; x=1723841525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=54OZeUBWyPXA0S87QTioBQQ7Q2CkC6lMvkpXhup6C7s=;
        b=AHqK2l+xVa3rAzWeJDbpXl3xMg8Gc+RFuosmktT6AV471ZaCEBiGhMRjPwjQEfIJT9
         dU06vGWvvyKMghqxCipYaQcKpsGNC7B3cEowhvLzTc2ede5qGioTEotdaA8u8GsHi3xb
         A/4HYAuoRNspfLkGfKw71by9dpEAykwl137AdEBI76Mhw5ZMeAwFbNsbQBeGgp4LOJxf
         NRK85Px6yLMCSM/EyAelUlrWxvq/SF+n78wxj8ajao2bmwJiiMU06S7HGZ9PIgn0VNkQ
         XT49+aA4+DMsXpJ/+bwdmiIosGFaNEbOI6M/Rp6p+aVgs1eqDhgiCCy4EVAPBrnSWO9w
         pj4w==
X-Forwarded-Encrypted: i=1; AJvYcCULItfiFvxuExaVXRKnilRqrzYCz3yBvGXJy9K6S6jmDftIgiu3jNVHqJGAfrN5KYVEb7V15iUEjK7S7gKUt9hKVq9qyDF1
X-Gm-Message-State: AOJu0YzMjn1+m/+suG30X+QItHPj9+q1Rny6pAPOaseKB3w/xeTY79vG
	bRCSqEqPJpTFU0FD4fHdapfYOZq+7Yb1AyCY8GbrT5SlEupo/w4mB8H6oxN/BC9fJw4tNi6dwka
	JvwqIIpbBZQ==
X-Google-Smtp-Source: AGHT+IEd1rLj8FyLEliwY0HHp1LBZ6RRlFIxvN6TqVFlyWLq4RucNIuVDKVa8kZXEO3o2onu1BiztI0aOW/YaQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a5b:d44:0:b0:e0e:426b:bf6f with SMTP id
 3f1490d57ef6-e0eb99f2ea1mr5705276.7.1723236725130; Fri, 09 Aug 2024 13:52:05
 -0700 (PDT)
Date: Fri,  9 Aug 2024 20:51:56 +0000
In-Reply-To: <20240809205158.1340255-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809205158.1340255-2-amoorthy@google.com>
Subject: [PATCH v2 1/3] KVM: Documentation: Clarify docs for KVM_CAP_MEMORY_FAULT_INFO
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

The initial paragraph of the documentation here makes it sound like a
KVM_EXIT_MEMORY_FAULT will always accompany an EFAULT from KVM_RUN, but
that's not a guarantee.

Also, define zero to be a special value for the "size" field. This
allows memory faults exits to be set up in spots where KVM_RUN must
EFAULT, but is not able to supply an accurate size.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8e5dad80b337..c5ce7944005c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7073,7 +7073,8 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 
 KVM_EXIT_MEMORY_FAULT indicates the vCPU has encountered a memory fault that
 could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
-guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
+guest physical address range [gpa, gpa + size) of the fault: when zero, it
+indicates that the size of the fault could not be determined. The 'flags' field
 describes properties of the faulting access that are likely pertinent:
 
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
@@ -8131,7 +8132,7 @@ unavailable to host or other VMs.
 :Architectures: x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
-The presence of this capability indicates that KVM_RUN will fill
+The presence of this capability indicates that KVM_RUN *may* fill
 kvm_run.memory_fault if KVM cannot resolve a guest page fault VM-Exit, e.g. if
 there is a valid memslot but no backing VMA for the corresponding host virtual
 address.
-- 
2.46.0.76.ge559c4bf1a-goog

