Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDB0238D36
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738940088; cv=none; b=m/tKBjjmIHpYUWLsbCmKAVtYBpfk08QpWezPja6I+QXsW4LQgvMAgWSI5J5tOwcBcaRyU56ItJUDO3snN3T5eU6q71Y9pUYiX2dPGj93OuxlOexer+yyUW653gwg3Vl8gWWZP7dJDxfgj6MBOOFalFLNcxn8mjig/pw9Tjf/P/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738940088; c=relaxed/simple;
	bh=ZCRFTCY1hi3XMbgWbwzaOADq8bLynRa5HB5rf6QanHA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V+jv45DJpyaUWKKzHqJb3mjeQ3OjuYv0Xd3RhAVYm/2ixLmDeaiv86f+2BtGEbPzc6XPnaCKnRV2rjvr63gcc6q0ffUAdGPX5mZ/6QIaQ1gJNxFUY3v5LivwmcpZOs9A8oVU7E6vhYU6UJmzcfRa9u233sylGb0rzG7HpE6BCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TXW+kWUf; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TXW+kWUf"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5dcee17a6a5so2602160a12.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Feb 2025 06:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738940083; x=1739544883; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QlxUuvHn55P4VJoa3VPKXet3o2roscTj71cLK/0XsCo=;
        b=TXW+kWUfPd9vL1wkUmjbicDBgmV4ZVE16fkM9Xf4fV7mx3E8D9pWptDnLLBEEtNLun
         BTXosvD71aCYZrvd5waahF3wphfhMAEkihgoOK/Z2ZO2oz1X01edKtyeAbPh8CwsBUrP
         SIyFEOdw9UW9zuGWowzW4FLvobtpXaj9o3xoTdVFwIuA4HbXwwpyFDkD6SeWfIDnj6Eb
         E4GWyjMyzVwGkkkhcpPLVQ3by2c5Kjy6BZv5QUMSy9iIxFRVFQ63A8iPJboeRDg4SvDv
         iKB+gEsM2e++ufCGbYPgCWFNBA/Pw54QjyCLfjxg5L73RTW2yzEjsrePz5USupduLrpf
         iIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738940083; x=1739544883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QlxUuvHn55P4VJoa3VPKXet3o2roscTj71cLK/0XsCo=;
        b=ihHMzUaCKOr6mqVPXMOiqryFBbFVc0DrpZdxAUPNSD6MRl8a5OIBXXELNEqHai5ljK
         6csYbcRYP81zS19cX/ZloHooopdv1UuZlllN1UhBTSCvHAYJHA80ar+vX6ogqZFKalw4
         V8x3tbCpGAINuAkPr0wF/e2bfpHbEdrKgDKzS4uJNZydzv3nKcCWA8gXUH5bUDSrvRA9
         lGZnAsgJuLuUOqIER22QkFILFwT+POHtUpv+rBoUEETjGDcDmRXAwtRK+64MU28mlCPa
         +OCpepWDtD+3da3xIUYJQoHiFF8HKhN1Cic02pvBvHTZaL20Dhb0OlZo5UEsf79tI8Ax
         UYvw==
X-Forwarded-Encrypted: i=1; AJvYcCXj1UlJC8NltWef6U5kQcnaS5CFjmtkxzBKzaOVtwNlnsAxQnZuNV0m4blR0Iczo+2xmpvrYT0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPEWLrd3J4nKQ5Jlt5uoqImZyFRttVjif1xJyYpakgluZWOdOs
	2sSWbLTxQMGgs9hEzN3euMyWVdLoQTBB9m7i7Q+aQvuHnZ7NDUvZsW8YT/b/uA9u/6QazEmKzCF
	MRZOBqg==
X-Google-Smtp-Source: AGHT+IEuPMCv7YqXJlNHwKccMEWSYS/+UUaEr2aDY+SyLUIdyjbcKQ2U586hKi+BCjLaIqvUPKXUd5QYm4sG
X-Received: from edax2.prod.google.com ([2002:a05:6402:4142:b0:5dc:110c:e5e2])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2546:b0:5d9:f21a:aa26
 with SMTP id 4fb4d7f45d1cf-5de450a9e4cmr3320543a12.24.1738940083729; Fri, 07
 Feb 2025 06:54:43 -0800 (PST)
Date: Fri,  7 Feb 2025 14:54:37 +0000
In-Reply-To: <20250207145438.1333475-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250207145438.1333475-1-qperret@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250207145438.1333475-2-qperret@google.com>
Subject: [PATCH 1/2] KVM: arm64: Improve error handling from check_host_shared_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The check_host_shared_guest() path expects to find a last-level valid
PTE in the guest's stage-2 page-table. However, it checks the PTE's
level before its validity, which makes it hard for callers to figure out
what went wrong.

To make error handling simpler, check the PTE's validity first.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7ad7b133b81a..41847c04b270 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -943,10 +943,10 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
 	if (ret)
 		return ret;
-	if (level != KVM_PGTABLE_LAST_LEVEL)
-		return -E2BIG;
 	if (!kvm_pte_valid(pte))
 		return -ENOENT;
+	if (level != KVM_PGTABLE_LAST_LEVEL)
+		return -E2BIG;
 
 	state = guest_get_page_state(pte, ipa);
 	if (state != PKVM_PAGE_SHARED_BORROWED)
-- 
2.48.1.502.g6dc24dfdaf-goog

