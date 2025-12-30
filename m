Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230632D94B2
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135725; cv=none; b=YwMXIt+iyjodtOhPx/3iZam2BH6blYkLtKz18XF1lrecsxJFTpASSJB/yP+rfuLIit6wt3QyI1gPJLk13mWZisA+WV+YUMbAMybb0D0tg/n90suo8QNuxnxEX9/9yNEdtASB25VYP5oiBHLiiS/Byn0WTqcQ9zkpA3uVqu8ki8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135725; c=relaxed/simple;
	bh=NTL8KGsm6USzTzkvmwpcMZD2nPHbvkmlY/rR1jDM3PA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OZg5vN5VGYl29twzNOFF0IoyNPP9x+Z8I11KyICCI7rHKbBJO5TbLP9VK2APoWllH4d+X94/qVU9k27Ith9O+2XMQB443jwb93rbEAkZ0nCx5t4CvEUCvoX9Qk4eNfrIPNBK+krCCfxmLa9V6ldVzIlSeXFBkriHsLkhte+O9e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EsTj/iHw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EsTj/iHw"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c6cda4a92so22223837a91.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135721; x=1767740521; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=snslv60TkZffEAQE2fKI/7w9i9KGKI8ATFVeEcgF+Qk=;
        b=EsTj/iHw40PW6rxjJ2RqSP/85e3ehrZc33lntdUosOPV2nk/EMkF4SDs39CEu+kmZm
         gvwpLTyat6UFxIkPjTaD1jGZtlDwSdzKyZTq9zIxYIIh8LOp3SYZDZgEPlVWpNLKMMng
         uFDnH8A013Kp/wGELZR2/C35iCyj088T9o3DZJwLpd0cjvSmrQk40u1R3Fo1KakRDNUq
         PALc6OKSOvkjWfw9wff8kTtyDKssMK9sUEFPRF6lg+ZzPfjn3a1fkVPjSvyeb6SYxX1u
         aECwlqSxC5Yoex35qx55rFjJcnfdX3zJcICCiFyGtECD3kf2LEoIvp0y32q2qOHOyBnf
         vOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135721; x=1767740521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=snslv60TkZffEAQE2fKI/7w9i9KGKI8ATFVeEcgF+Qk=;
        b=O1TozQLLeXb3TBERkiHAe9Bl8qJBrBEWvl1Hm3i3kFSWuRgqZI9+GYQhhPpbHLfirF
         JDSyfj2RG5Q67IibMw/W2BvGo7VB6SsoRcMrfu5xgx1Vs4eWmkIpgJNYeIADqI3GtB8+
         2oeB7thrZDXF5qv9gyrRsaYhrynAbWlttH/fiGCOHkXGUtDNqhodbaTmIMeVvVpoWBvz
         MSLgtOxZe0dYt+j59XcBPmxKRreOEqoGG/4ElMv3w5o+3Tk7xe4YT5w0Uu2p7LjaTfgI
         lTm+VcndbLKgeT2WXk6ui9YMyHkAwctO8iVMbOzdywANfWUq1+asaaYMxmX0tKkWku3n
         pLCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHUzz3mBsfRUMdd5SCtFONukWP7Hb+5iFVz997eBbpBiWdWupq7vy8NYQQGyH+/bwPeOb2A2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTlt2F7PYNf6xrCj7cc2rfnInmiJtlQAMTchUJt+Orh8HQr4OF
	rMKlihfm4RsY28hck/lK3YBfc0ye+1l++PgpWaexaO+AgP6MvsxtraCpZxBCF06RKfZ9QmU2Hlo
	ryYUsMA==
X-Google-Smtp-Source: AGHT+IElvIFPPzPbx/fWhmlKYhmrHPLLecvBIwXjPK26QLj43KDrpSTQ0SF/ILvphJaY0JI4Mn53QzvVzYY=
X-Received: from pjoo4.prod.google.com ([2002:a17:90b:5824:b0:34a:a9d5:99d6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e0c:b0:341:8bda:d0ae
 with SMTP id 98e67ed59e1d1-34e921b7334mr26690257a91.20.1767135721380; Tue, 30
 Dec 2025 15:02:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:34 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-6-seanjc@google.com>
Subject: [PATCH v4 05/21] KVM: selftests: Stop setting A/D bits when creating
 EPT PTEs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

Stop setting Accessed/Dirty bits when creating EPT entries for L2 so that
the stage-1 and stage-2 (a.k.a. TDP) page table APIs can use common code
without bleeding the EPT hack into the common APIs.

While commit 094444204570 ("selftests: kvm: add test for dirty logging
inside nested guests") is _very_ light on details, the most likely
explanation is that vmx_dirty_log_test was attempting to avoid taking an
EPT Violation on the first _write_ from L2.

  static void l2_guest_code(u64 *a, u64 *b)
  {
	READ_ONCE(*a);
	WRITE_ONCE(*a, 1);   <===
	GUEST_SYNC(true);

	...
  }

When handling read faults in the shadow MMU, KVM opportunistically creates
a writable SPTE if the mapping can be writable *and* the gPTE is dirty (or
doesn't support the Dirty bit), i.e. if KVM doesn't need to intercept
writes in order to emulate Dirty-bit updates.  By setting A/D bits in the
test's EPT entries, the above READ+WRITE will fault only on the read, and
in theory expose the bug fixed by KVM commit 1f4e5fc83a42 ("KVM: x86: fix
nested guest live migration with PML").  If the Dirty bit is NOT set, the
test will get a false pass due; though again, in theory.

However, the test is flawed (and always was, at least in the versions
posted publicly), as KVM (correctly) marks the corresponding L1 GFN as
dirty (in the dirty bitmap) when creating the writable SPTE.  I.e. without
a check on the dirty bitmap after the READ_ONCE(), the check after the
first WRITE_ONCE() will get a false pass due to the dirty bitmap/log having
been updated by the read fault, not by PML.

Furthermore, the subsequent behavior in the test's l2_guest_code()
effectively hides the flawed test behavior, as the straight writes to a
new L2 GPA fault also trigger the KVM bug, and so the test will still
detect the failure due to lack of isolation between the two testcases
(Read=>Write vs. Write=>Write).

	WRITE_ONCE(*b, 1);
	GUEST_SYNC(true);
	WRITE_ONCE(*b, 1);
	GUEST_SYNC(true);
	GUEST_SYNC(false);

Punt on fixing vmx_dirty_log_test for the moment as it will be easier to
properly fix the test once the TDP code uses the common MMU APIs, at which
point it will be trivially easy for the test to retrieve the EPT PTE and
set the Dirty bit as needed.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
[sean: rewrite changelog to explain the situation]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 85043bb1ec4d..a3e2eae981da 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -432,14 +432,6 @@ void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 
 		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
 	}
-
-	/*
-	 * For now mark these as accessed and dirty because the only
-	 * testcase we have needs that.  Can be reconsidered later.
-	 */
-	pte->accessed = true;
-	pte->dirty = true;
-
 }
 
 void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-- 
2.52.0.351.gbe84eed79e-goog

