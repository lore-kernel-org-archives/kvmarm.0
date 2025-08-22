Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A2B270ECD
	for <kvmarm@lists.linux.dev>; Fri, 22 Aug 2025 03:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755832605; cv=none; b=lxxXflikMVezogXmFb3lhcRRQZdkcYPQEvLBaZWlYIwUAMh4RKdwo/kO0DBB/DWhVR1SAOEUeADx6wNbtTEXG9Nqmexsx9BAvT4h727nsIaNMy+ZPfiKdZJRpIGA/c0W+SsaYQSG9oAKrC+3lXvyZdYZw6scFgKerXlXCmh3sxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755832605; c=relaxed/simple;
	bh=UxmMU8bzkBQzj8gGXBuFRC2TfwP2x2RdYhhhCuDkImg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JjQqF8Rnf4bWrnEMlNqu2kU0GfvGjw7ushx3rIbOVbJ/izXERaLZFC/so1x9x1xT8G5Fk03D0hngv79UJXdISAAtC3NKy4ASdfsZKYKoxbRSR2xRZhv1zbmADmdPlGtqN8CTbW/5d7/Dwlq2e2TbchBHrllpWFKn9WDW5+BYVlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=WLDmKesq; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="WLDmKesq"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24626e06f04so6340985ad.2
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 20:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1755832600; x=1756437400; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L/zK7mkD8fhIY1XCicJNUFjtjYCKj9ei/cY2eINbo8s=;
        b=WLDmKesqAC0k7kPxS7x7Zo3/SxH1SH1ht1rsWMM3YYW4RzYr7fQ+ApcMQIl7calQ6q
         lFMaotjBcIbTquZZ8bXNItxhlez5A8A/uppcx2Vayh0Wt7UI1cj+9TmRGw9d5tp0I4VK
         CJ6z5TE/hdCcvN6LWfZvz3hJf3Jb8v3GRx29KS43gQXheF0XOleM+AlxQtIhR1rpn7P7
         sQ0PQWcbrQiNhyjx3qUQ5KkSiaLShc5AQblWO2Y1mz8IQ7wSkEoQKlW9Ci8t3jLCw5t2
         w4Xn5yrG7hzimSq87CfIXim7tvScrDQyhIbfssYj5EGJYHJVof6Q5/EIBOpxR1i6OkCr
         QjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755832600; x=1756437400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/zK7mkD8fhIY1XCicJNUFjtjYCKj9ei/cY2eINbo8s=;
        b=dZORF9n62tnhFRhKB59MFUdmzA5wyF3IRq2RL4Ag1jbxZKQx2b42zCGpwNmBTPg6CC
         a7sfsa/ivKRU19YW0bDayARrtwOo6VHKMh2OwYArlFoDtFD8IX5z9jPqyKBrE0KMGOdq
         6SUOr5rVXx5lKTocXctXTH/gSojl6ToAiFrmHd0ooUfF6EQ/X4tc31GkQe5rKx05AgSa
         8RPfWamE5qEHEqfB1gvqfjdSK9X5c0Y5/R6zL4QqbZp2a+QvdnHJEvIUxHtQVals8FfF
         eP/C/ha6aP7xugHF752Nxw1qiJWVfNzyp4iIOWUR4HG19sQKXfw1+4MOVwHFC+i7MScs
         F3fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuSKDCTD58HnDwyxQXSk08VAAnpnpCR3z7J1Av9wdzWjCxgIiRlR+JMBH9FAqbroQvg+v8hAU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0WZq4oauX3f9/FlUJ6vJqRLdw62NNPpILdH075S3uy2HpM7hR
	a6GxPh8trn+GN1vKMWcdQqeFtsY3yke3m/nrPQ0iGfm694gXPgMPwlJfDm9pahdxiSkNlwfwUlh
	bumbylM2qf1c7TIKNrNyGo6AVSgBBLWUDspsrffkm442fUZFyAbo=
X-Gm-Gg: ASbGncvpOrTBIrJ+a+3XY+tM3EDwhNg4xiC3/MeAzZVdBM3IDE9rauVPBVDnvuMZPu9
	L4fE6wlQwBWrEj4v4xf6nXYMhezF/jHL7Mwu4jD90wXSKyooKXrFgF66fOq5Ry4hseeQr95cxe/
	0Snhy4HYFPF6tS0n1caAwOThekbJRxOtTUDCb55wytz0z+ZivV/yTb1/0cnNb6V7U7AMHQvz1FN
	a+1sSbGJRiZiQfi+g1BSuI23nZbsyJChiWrd/W3BAJB6NxWcUdCDTr1DdU/PdR72wlCJYwun8Fs
	kLbSn/c+Wq0vWSlFPwz8DyrcRCcpUxj1RvVFmfieCeBDOhh0cQZBLoGOqM9A+wwDW3DqISLsFYi
	x40C9ZupLLphS6FVIeIKVoGio/RM8fqqNNnLDj+O1DbrelUBpZTtXvZyJf+Hu
X-Google-Smtp-Source: AGHT+IGRHO829XEsXzh+WOPZNk1WyYwE7h4SZNk2NBxWmhF3KYYwHSWfii8nwJe2Ho0aEwY27Tlw2A==
X-Received: by 2002:a17:902:db01:b0:246:1a33:d9da with SMTP id d9443c01a7336-2462ef85803mr23044175ad.42.1755832600100;
        Thu, 21 Aug 2025 20:16:40 -0700 (PDT)
Received: from zenbook (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32514c4b722sm1089459a91.31.2025.08.21.20.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 20:16:39 -0700 (PDT)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: nv: Allow shadow stage 2 read fault
Date: Fri, 22 Aug 2025 11:18:53 +0800
Message-ID: <20250822031853.2007437-1-r09922117@csie.ntu.edu.tw>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

We don't expect to ever encounter a stage-2 read permission fault,
because read permission is always granted when mapping stage-2. However,
this isn't certainly the case when NV is involved. The key is the shadow
mapping built for L2 must have the same or stricter permissions than
those that L1 built for L2, hence opening the possibility of mappings
without read permission.

Let's continue handling the read fault if we're handling a shadow
stage-2 fault, instead of erroring out.

The following illustrates an example, vertical lines stand for either
L0, L1, or L2 running, with left: L0, middle: L1, and right: L2.
Horizontal arrows stand for traps and erets between them.

'''
L0                               L1                               L2
                                               L2                 |
                                               writes to an L2 PA |
|<----------------------------------------------------------------|
|
| L0
| finds no mapping in
| L1's s2pt for L2
|
| L0
| injects data abort
|------------------------------->|
                                 | L1
                                 | for whatever reason
                                 | treats this abort specially,
                                 | only gives it W permission
                                 |
       eret traps to L0          |
|<-------------------------------|
|
|      eret back to L2
|---------------------------------------------------------------->|
                                                                  |
                                                   L2             |
                                                   writes to same |
                                                   L2 PA (replay) |
|<----------------------------------------------------------------|
|
| L0
| finds mapping in s2pt that
| L1 built for L2, create
| shadow mapping for L2,
| but only gives it W to match
| what L1 had given
|
|
|      eret back to L2
|---------------------------------------------------------------->|
                                                                  |
                                                   L2             |
                                                   writes to same |
                                                   L2 PA (replay) |
                                                   success        |
|<----------------------------------------------------------------|
|
|
|------------------------------->| L1
                                 | for some reason, relaxes
                                 | L2's permission from W
                                 | to RW, AND, doesn't flush
                                 | TLB
                                 |
       eret traps to L0          |
|<-------------------------------|
|
|      eret back to L2
|---------------------------------------------------------------->|
                                                                  |
                                                    L2            |
                                                    read to L2 PA |
|<----------------------------------------------------------------|
| stage-2 read fault
|
'''

Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---

I am able to trigger this error with a modified L1 KVM, but I do realize
this requires L1 to be very strange (or even just wrong) so I understand
if we don't want to handle this kind of edge case. On the other hand,
could there also be other ways to trigger this that I have not thought
of?

Another thing is that this change lets L1 get away with not flushing the
TLB, but TLBs are ephemeral so it's fine in this aspect, however I'm not
sure if there are other considerations.

---
 arch/arm64/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1c78864767c5c..41017ca579b19 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1508,8 +1508,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
-	if (fault_is_perm && !write_fault && !exec_fault) {
-		kvm_err("Unexpected L2 read permission error\n");
+	if (fault_is_perm && !write_fault && !exec_fault && !nested) {
+		kvm_err("Unexpected S2 read permission error\n");
 		return -EFAULT;
 	}
 
-- 
2.50.1

