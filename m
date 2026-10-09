Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB143E1701
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791535549; cv=none; b=XJxWrClFplegJ2OMYSl/kCRvIrj6E3ZOYgyDE+JtQIEF5jY6UmnhhqxrT76bNstB5RKE5faX+2/TMAKex8C0OmTGdeRWytb4QQp2hGgr1llKN1JtHHFr5Upj/rzQQQgJfkqdLCRY/SvYBBmPFJm2+GX9g9utHD78lYXjPTM17Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791535549; c=relaxed/simple;
	bh=18baIormSSWCqs+XjEhUGfYWmVY8+AHpFOuK9zTzp70=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=g0QEK7jKTS7IJgj0aMH4KkkrL0H05hhEd9Ir9osdMB63lWMem4puAIdwNtyR+b98vdXhAdHF2VYfyz5eT0dttSmKdZTA+zpE7On9SwJtoAHmWw25DbYas/DCIOFuZHuzugy3qvnwhLruMTbPjOVP8cIaBY7eiU6iwid+KMpyMH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wAE9htRg; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wAE9htRg"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a019d53f46so49563885e9.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 01:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791535546; x=1792140346; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fAupYzt0RrKa5+FFuATrgv7+Shai6Gp5gi3ntJd9iuk=;
        b=wAE9htRgXZSvB90c2eBQ60GYzcq2TvKa02nN6TMaGykwfWkB6OD5/WV4g6ShJF9cRp
         RnFbsHqpHPLUV7ASSbF/euMELiXicXJhYpnPI/UpbLiZDU1KHzpNOG6YIC7FWP7R5vDz
         Wr7HDNzALZGVLfEXpKPzfI6fDJb7hhC9e+OJD3NtboLL43yt6iVcRyqu0rNKbM8fhyvN
         gkZvr3N5tvpU1PyNBfxUrCeGQ9rATjKP7beuUefNNSLeZ+ZYGLhB/vk+CzuBK6l7dLmu
         6ACZn6bIf4D006Pk2W+oNre5rHMmj83naQDWjvvCX+KIdc8sDrZdItxfLnRRPt4gF62i
         Sr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791535546; x=1792140346;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fAupYzt0RrKa5+FFuATrgv7+Shai6Gp5gi3ntJd9iuk=;
        b=x56nfmtf9JVD54NMRNdT2/M4nCKALycvxemKwdYViO/IbcqphXvmI3AlfjVO8Q/XKN
         MMcHMvBEFUSQpKehYQRuOSinS7qXY612ENRaoYRSVU5Xv21IietLnzAxeVNyNqlQ/54A
         jKlSX4Zg/+RqnW79PYO0j5eN203os5LfRrWK3FdhrwoCWXsPCG/CWrezrRPKKPXU3KfI
         5Mhpght1Z3ThtFmwrQs/3pQiMnfIp+IdhVcCdCdDDELvK8M9yBEFYLeGxvLFa4jR5D2S
         AWDEpE7EwSKvUCYUO8xHgJ/kjxyOUgmq5yfXamGbLjcpCTT9Nc6LShA9m42Jj/UdLb6d
         RBYg==
X-Forwarded-Encrypted: i=1; AKwUvByQA7QcyfChSpUxt+gdP1O9DcsIR5YSN7fcDI74/IUKKSVniFXhk80Q2Mmb0DUpUQAIh5tkiUE=@lists.linux.dev
X-Gm-Message-State: AFuF++kK683qHvdItd2sayi8sEnJHoQfXpBPTnZ0J1S+RnURak72wCDD
	cS+6K3Ewxj2ls2Yt1JQbJm37D+WhHTJaurf4pgSxEfpthfx0O6i7t2JTPPkQGyyPAaUh+GN6u8R
	agG9PZ30uYqw9rDpnh/X2sg==
X-Received: from wmpo4.prod.google.com ([2002:a05:600c:3384:b0:4a1:8075:39c4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e07:b0:4a1:8627:aec7 with SMTP id 5b1f17b1804b1-4a18e4987abmr19126105e9.5.1791535546036;
 Fri, 09 Oct 2026 01:45:46 -0700 (PDT)
Date: Fri,  9 Oct 2026 09:45:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009084529.462577-1-vdonnefort@google.com>
Subject: [PATCH v1 0/3] KVM: arm64: pkvm: Extend hypervisor entering tracing reasons
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This series make the hyp_enter event more detailed by adding a "from="
field and by using the ESR class when relevant. This is interesting for
example to know when the guest has exited for an HVC.

Speaking of HVCs, protected VMs issue an HVC to share memory with the
host. Without this memory sharing, impossible to get logs. So if for any
reason it fails, debugging is quite cumbersome. Add a specific guest_hvc
event that will give even more details than hyp_enter provides.

Also, add a host_hvc event, so that the host gets similar coverage a
protected VM does.

Vincent Donnefort (3):
  KVM: arm64: Add ESR class to the hyp_enter hyp event
  KVM: arm64: Add guest_hvc hyp event
  KVM: arm64: Add host_hvc hyp event

 arch/arm64/include/asm/kvm_hypevents.h | 50 ++++++++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  9 ++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c         |  7 +++-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c       |  6 ++-
 arch/arm64/kvm/hyp_trace.c             | 52 ++++++++++++++++++++------
 6 files changed, 96 insertions(+), 30 deletions(-)


base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
-- 
2.56.0.385.gd3acb90ef8-goog

