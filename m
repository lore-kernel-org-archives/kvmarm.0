Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A0D2DEA61
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 04:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756290; cv=none; b=OAN13x+pGFXFNmb6fFMCybPqkKe5Y453KA8QR1xhDKHdQmDaXsVSvWMxEREMjKZT1ckKk0A2BTWYdg+94SmhDkLlPxjZBGhm017K3kwMQL829TG2c2Jw0hMTSUbHB7LC0wB7HmdICGYcZnut2NXd0qrGlQ8YyPrpre2WvcBsmeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756290; c=relaxed/simple;
	bh=r/Yb1TwYqrAmxqT4G7QAMIstgXNzCAcMpunOKlup3Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mb9SLbX/0MjxXBUGCapny3u1gh6v/s7o7MxryjVY+uQTwu1KnA+KHITghIlk+esIJBbIy8GE73C1qgKgcK9VXhvHjZDwZKS4Xysl2WgKmrE+IlRg2hvLydgpSEYXUDkDDLIX9PTG8KXptrEDgtyKU0PscPpqUYd7KRvbX9ZpFbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J8d2Q0pP; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J8d2Q0pP"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d9520b9155so26960465ad.3
        for <kvmarm@lists.linux.dev>; Sun, 06 Sep 2026 21:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788756289; x=1789361089; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ieAuNZcZYYBHRZ196owNjlAruJ8erVXUUQKh5uVkow4=;
        b=J8d2Q0pPEMsFHz3cIIIBSP6hVlmlEvTa95Ow+Hbe1cUPsA/eMGqma8YNbKW6D8p3ez
         M4b1oyHUDQNWpKMFc80JDaZRfGms7hPB0GBj83vQtNwFPIlNZzoRGbeZisdBrl7lDwIr
         fTkjo4/pI/Jenf9//eGn3mvYTE0eY670N/58NfkkWngnbE9NChPrivcxW46SjWnPA4GF
         P8ts7K9i3B42OJPTsVe5swLSxlfaw/MUObUwUhuULrpmnuNBz1Dfr1DONuQ1svDXV7nI
         o9VDRD+5SICpVc0835nNMKX8exdNdt8lKfapJWecrqQdgAdX3WtIGu8/LOm60TfjTnqQ
         nr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756289; x=1789361089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ieAuNZcZYYBHRZ196owNjlAruJ8erVXUUQKh5uVkow4=;
        b=Q8eGVhgjwTWK7roBAzNfn16BgyojEYzmpnHC4YeZdmIqLFSSS71D8ikD2IjcBVJaEv
         pFSR9gcnxjaSG5mm2XqbNWP2c8WD9Dq8/zhzgjucwpNmxJYLuA6F4Kw68VASBDMsTvTh
         sJx+6OK2i1yC+J5ihy7DhpQWoHezw4ow4a9Rb+ii1vAnZA9FsSYQ/NrijJEfyjs64QrJ
         apZbP4a2rakNpphD/Palp8yNjVXKplEXow3aLC8Wkn695oN4w1IKbNot5oBlRQTeiMOu
         6YpYrQIUEBHJHFdJzwbFkJgDTQdxCsh+tRB6iatmTWeiz4n2+qubrSzEARyVBzwxG4Up
         MjNQ==
X-Forwarded-Encrypted: i=1; AKwUvByFktngLVQrhpXKBrwkRRWTH1C+k8wFwtx0ip0oIFDchYi5I2Dn28BGgUCB5kT3R+krMdbllzU=@lists.linux.dev
X-Gm-Message-State: AFuF++n48+IfWxf5ZZ6Vvw/aRMniRlvu2Acpoi9bdb+f2JZ3+fpJqjgF
	L89peQBntgbHG9pa97E91y4xFXoc84z1zJkNtafeyYjj/uIc1bEaW8U2
X-Gm-Gg: AYBFou1/gxWlOLJ39jfmYmHx2sCx0UD0Dzpj/Ug/97tG3PG7oLyucDuKBE39Jdgm7lz
	PrD0TSxVrPXw/j/FzWziYWHjjMucTPlea/4qIulA/V7wndYzPgGWNa9kMSDHvyww1ps5fNAXDTY
	TegC06W0XOzQgGGrNxdRzDVDvp6UP/dI3Q1ux+qdn+0lCjQCOZgKU8pga3vR9U3A0RZ4a88v7SR
	TTIN/WqJZ32QQazstPJX6FJI94kpvJkjGcf3jwXqQifhtUlE/0LIHtT2pNESpo4kNSUhAmg9FUa
	LZB1Tx0mGsReL/VnQVy2mEl63g5eZsCZLpolbPsI3ZLObNbNnGxtgspbs38r0i4BJHe/gqlRNQg
	kTFfIbVUeVj8PjVELbVsd5NriPvdgTYyR7QHbBy5UIUNI5rjIzP+I132BziTuUD8zEeSLHrrfqm
	itdBvhBmpHy4HjR7qPmuw8fdvPheO8qEhGX36Ixl+6FhVAbxbJwWtZGiPtyX4BnwhpwEbDzSwhk
	Cq3QBqvgaYDwrdBudgtQo1b
X-Received: by 2002:a17:903:40c6:b0:2d8:d4cc:5bb1 with SMTP id d9443c01a7336-2db1286ae13mr285166485ad.17.1788756288604;
        Sun, 06 Sep 2026 21:44:48 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm37823751eec.16.2026.09.06.21.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:44:48 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 1/3] arm64: kvm: fix typo "synchonized" in comment
Date: Mon,  7 Sep 2026 10:14:32 +0530
Message-ID: <20260907044434.4682-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907044434.4682-1-hemanth.selam@gmail.com>
References: <20260907044434.4682-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "synchonized" to "synchronized", reported by scripts/checkpatch.pl
using the misspelling list in scripts/spelling.txt.  Only touches comments,
no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 arch/arm64/kvm/hyp/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 308100ed25de..9709905f21b5 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -46,7 +46,7 @@ alternative_else_nop_endif
 
 	// Ensure that __guest_enter() always provides a context
 	// synchronization event so that callers don't need ISBs for anything
-	// that would usually be synchonized by the ERET.
+	// that would usually be synchronized by the ERET.
 	isb
 	mov	x0, #ARM_EXCEPTION_IRQ
 	ret
