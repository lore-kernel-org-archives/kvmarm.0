Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8836936A5E6
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 22:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692334; cv=none; b=ZIb5zWMaEm8WDGWZvk6jSxxgCvKnG7Ox2cTZoaGUvAqi3eSO9ydTA/yez1tJWsM1hJG9GokBCVuPTc+b8aNHgTnzXJZngEI2ai8TEpAmuNGKJ4uGzxasW/W+1bzl5ZRWoPuYIul1lKrUVtRSjYFERX+4Yr1Bxx0f+dcl7upOs/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692334; c=relaxed/simple;
	bh=NmfTEh2w90Vx1EUJhCoQ1DnPlLs96QxCb3TH8vg/crY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Content-Type; b=fBmj/JSuTW7oIMyZ5KMhD1eT5PgWzENJt/YJNrzDkhprp/45eeCunspxtJWJrMhBwVudh5fMKnVUssWiyu+72XjBr0u0dj31V/G78RG05wGZgsQJTetwEvB/8YkZsK57Q7lENYiIVv991hihqz0NdK0K+pyTXWoy2SzCBKfkiKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zfnTrYgK; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zfnTrYgK"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-27ee41e062cso73407595ad.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 15:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761692332; x=1762297132; darn=lists.linux.dev;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bafyIACgjKK14wqI7+UpK/XBf9Tl8hwNLLXvm7vBUiQ=;
        b=zfnTrYgKu0+mDIPSLllGW4H1X2G39ZYPJX9WAY5IEEnOLamPlRmn5aneeNd3WJeALh
         8PNx4CBx/C3Zd8WyTolLLhqYvlbGZIn6XtyZELDFIAEfJE70r/wa/T82DLCWfCvRaxvn
         qwmA8cttTdA3c24gnhpcP+wQX8Ot5T1802r2/cq75b0W+HeSPHQOMx+IfUIzyY7Bxqtg
         D9quGuosF0O6QYLaFlOkr28S4HxvXv+w7pYX4ij2cOxvVFI8jBzCce2c7avGPeR44G5P
         868iHIS1iL0SwYZ+3qO4FAleDDU1aaj1CH+dIT9KaA72T7OMOVQ/52S7ECSWDh2lQO1v
         wYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761692332; x=1762297132;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bafyIACgjKK14wqI7+UpK/XBf9Tl8hwNLLXvm7vBUiQ=;
        b=JQAenkwjh5oyyiPH1c+klaFa+TTD+WJXerXYljH8Mp3mZKnTC/T3uCHeaMsVkL60h8
         rqDnRfhcy5f0eypT4tg/HiaEJsXCURnlvhljeEFy9Azaah/AQK4jfk+xVim//vEdLdjT
         VdTwr6Kdlbhkg0uo5w3rVJyg9YXTvrxCrPgS8+QmAVHdeAhQdCcWX97hwiuJKiRaN6jZ
         dyD4nXzRSdMZTTv+E8rdJF3GH6WbkbOW7d+k1XlQbfB1Y6n7umMR+BbTtvwjYKtWNM0r
         iSCdZn0D2hnOBmHrGiOo7lgGcYIydxdqwDB9G2mD1+lXNxpuRCpClz9B/JygozE6M7sA
         tRWA==
X-Forwarded-Encrypted: i=1; AJvYcCXo2rztsLRCK2NVww8qs5gDI5QrblIw5Ey4bGWUMJS0RqDsZCiYqm/LG16UDzBA/PO7PapTn4w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCTLDsUCtexX/PKB3B6yzLeF+4IZYteQLIl36eOncGOogvjPv3
	WdkkUNvZW4H/vUb0FQuKL1rbWvGQLfyQZPbIynWR3aCWHgdPBeLUul8WOlltR5/MQcLAjjkI8jo
	RRWlBZY7S7xZ2Lg==
X-Google-Smtp-Source: AGHT+IHKY2pClvohg4IWDjCOvNKT01DkzF2lTStYT3sIYIsj1O8Psfszn4vksBsANMyqzlJojr3dGZ1p5DLaig==
X-Received: from pjbgq17.prod.google.com ([2002:a17:90b:1051:b0:33d:acf4:5aac])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e847:b0:293:e5f:85d7 with SMTP id d9443c01a7336-294def69091mr8641645ad.55.1761692331928;
 Tue, 28 Oct 2025 15:58:51 -0700 (PDT)
Date: Tue, 28 Oct 2025 15:30:38 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028225827.2269128-1-jmattson@google.com>
Subject: [PATCH v2 0/4] KVM: selftests: Test SET_NESTED_STATE with 48-bit L2
 on 57-bit L1
From: Jim Mattson <jmattson@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Bibo Mao <maobibo@loongson.cn>, Jim Mattson <jmattson@google.com>, 
	"Pratik R. Sampat" <prsampat@amd.com>, James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Prior to commit 9245fd6b8531 ("KVM: x86: model canonical checks more
precisely"), KVM_SET_NESTED_STATE would fail if the state was captured
with L2 active, L1 had CR4.LA57 set, L2 did not, and the
VMCS12.HOST_GSBASE (or other host-state field checked for canonicality)
had an address greater than 48 bits wide.

Add a regression test that reproduces the KVM_SET_NESTED_STATE failure
conditions. To do so, the first three patches add support for 5-level
paging in the selftest L1 VM.

v1 -> v2
  Ended the page walking loops before visiting 4K mappings [Yosry]
  Changed VM_MODE_PXXV48_4K into VM_MODE_PXXVYY_4K;
    use 5-level paging when possible                       [Sean] 
  Removed the check for non-NULL vmx_pages in guest_code() [Yosry]

Jim Mattson (4):
  KVM: selftests: Use a loop to create guest page tables
  KVM: selftests: Use a loop to walk guest page tables
  KVM: selftests: Change VM_MODE_PXXV48_4K to VM_MODE_PXXVYY_4K
  KVM: selftests: Add a VMX test for LA57 nested state

 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
 .../selftests/kvm/include/x86/processor.h     |   2 +-
 .../selftests/kvm/lib/arm64/processor.c       |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  30 ++--
 .../testing/selftests/kvm/lib/x86/processor.c |  80 +++++------
 tools/testing/selftests/kvm/lib/x86/vmx.c     |   6 +-
 .../kvm/x86/vmx_la57_nested_state_test.c      | 134 ++++++++++++++++++
 8 files changed, 197 insertions(+), 62 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_la57_nested_state_test.c

-- 
2.51.1.851.g4ebd6896fd-goog

