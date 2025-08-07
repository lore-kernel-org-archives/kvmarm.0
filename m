Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB35221737
	for <kvmarm@lists.linux.dev>; Thu,  7 Aug 2025 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754593096; cv=none; b=bXBG9L/CIUwtmPRCjCj2SAcExsmvTtVFp/Ym+fIfkwtBu8KjdpW4cDQROLCeEV+iG0nVr+YeO/56wZJ/0IeqhwX6RiqMMEdzvjfZ2fj1zuEf2Zqnn+Kdy2JFIEfewBLcy9KURVtAAEbdezb9Km5LS53AldwKtFu7IYvVmyFWCtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754593096; c=relaxed/simple;
	bh=MuhIPyi2F5+ipcNc957b0wI7HllbWh/lbIIst2ORD2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TneHuQ0CBq42Ffs+sBaCWasb2aE+m7LXWroWIPxi7ybP2XK6wLU69VCKGsUmJNmCsHYh6vzmVK/i2EJCcHEOR1N3+W5HXo/uP//oLFDM8lfCEjdIarX/OssBEeLhg67Bx7QY71mgXZUCcsLasGWPKDN1RfSUL/kHu6YodcOcvjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UdaIOGIZ; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UdaIOGIZ"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b099118fedso59751cf.1
        for <kvmarm@lists.linux.dev>; Thu, 07 Aug 2025 11:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754593094; x=1755197894; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=96362UVupe8COf1P6wW/mjtmbdG3wWxnQMi7BMOUIUE=;
        b=UdaIOGIZIBN7RDKi7sKyD1+720Qlreq98q3WMyvSnDxP7xUY/ZmFhLucwu450r+rXJ
         nkgq7rLj/g6VX/lh0MJWx6OJ4fbOmm9tq0NOkhkRYETwIzA7OYKsWq93YVEIJfguiO2R
         RhYVi6J5d31ylqu5gdASNWh0nVnhilkikCxIPCedMAn25hTKSeXPc0+s6yFlBZnLfFod
         EntLPF/WhrPbnh7o1GoR137PaVslgV1YWkDM1QFKleG5joYLzlD6VGU5MEL6jbmSLk+C
         Rn77CrdY5uo4WbNmRJ/wxtgP7mytGkLkQ4OB81Vg7wX4vBjjMsCEVn8YVEecUOLVyNjr
         oaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754593094; x=1755197894;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96362UVupe8COf1P6wW/mjtmbdG3wWxnQMi7BMOUIUE=;
        b=S1ZS9gdk5H3tI3CLjvQn2/9vg6aJMT0JOPzmtZvilRce0uS9JR71rQgcRJzIamTF5W
         GDyjtwFx+8vD0QoDzSHGXufNxz9CoicI/r7DqUz2a+NhCAzUMyxjhmCaKV+qHtTkKQDM
         sZe3p8BeGfP71o0rVRipwm9QwxN72wOipVgk4xi2EutCWGtMmbIsHcjmJdGRpfjXGrOv
         ECpylYvzVpZYg20vzRlWyOE6cD9JXU+MVqTIxI3+8JJD7yE+OzYqC+CNWFIxbSLRTHLN
         7I+7LIUOPNxknf20lyQoqyv+3eJBgatLtaOr/26d21ogFuJ/BozItc9X6TJ5dGyL8JZx
         BuXg==
X-Forwarded-Encrypted: i=1; AJvYcCV9tGude5TiutJw/XMXpGrUXCg+2H5oHxCa+Kmwjw9K3vGOkx+CtgttQKTEoXB3FQemOLkg+Hg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIYq9hwdIVdi8B+twJVPQGgay9JYBYXYCWoKQPSbmLDQ6LxGWU
	IVSgO2glA9VWvUFozCRzp8OUaMNDfKbF/EXmmZyjU9Aer1JpB1ptTh0pYFI0Loy6YlraU4CnHsY
	c0/Bw2m7Hk6tACuox6FweNJb/ouTNSfcnN/MwtGpk
X-Gm-Gg: ASbGncv9tZdgz9bqHSMdtuQPV15zJXpz/zaHgcGK6dVprFkNSoVwtaDOt1CBaCzRPuq
	4u8fY2w3HFQbjJ0VRNLhxx1OW6j4s0xykHiURQKf+XZKrFx1fZrK+rFLY6mIwIzJogameFygk30
	5EgLvbmjlcGwVKqaSjhbC6A0eAcjaZhnPnb+YrP0H7M2t6b9lDny++B8nzCa0UDOjIxyrMhrh4s
	JxqyA9tWm0wkjZodAkvs0YPCX93p5gE866J
X-Google-Smtp-Source: AGHT+IGQv3PJBbuZ1uXQcTT0alJEv27zQP6RUhp/GXkD21PwsG9r1YtfOqnK9qoS+hDRmSRDSNYUz0kE+B4S+clok58=
X-Received: by 2002:a05:622a:a648:b0:4a5:a83d:f50d with SMTP id
 d75a77b69052e-4b0af27a4c2mr270701cf.11.1754593093620; Thu, 07 Aug 2025
 11:58:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com> <20250724235144.2428795-3-rananta@google.com>
 <aIjwalITY6CAj7TO@linux.dev>
In-Reply-To: <aIjwalITY6CAj7TO@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 7 Aug 2025 11:58:01 -0700
X-Gm-Features: Ac12FXylmxDAHRXg2gQCPPXuwIGOmW7c0vzzAhp62yyDvoK-TIuMbTJEHyOdR6k
Message-ID: <CAJHc60wBNTP9SSt_skEXXv9N+tF_1RoV6vcQQx4hWphJF6EmkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table periodically
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

>
> Protected mode is affected by the same problem, potentially even worse
> due to the overheads of calling into EL2. Both protected and
> non-protected flows should use stage2_destroy_range().
>
I experimented with this (see diff below), and it looks like it takes
significantly longer to finish the destruction even for a very small
VM. For instance, it takes ~140 seconds on an Ampere Altra machine.
This is probably because we run cond_resched() for every breakup in
the entire sweep of the possible address range, 0 to  ~(0ULL), even
though there are no actual mappings there, and we context switch out
more often.

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c

+ static void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+ {
+       u64 end = is_protected_kvm_enabled() ? ~(0ULL) : BIT(pgt->ia_bits);
+       u64 next, addr = 0;
+
+       do {
+               next = stage2_range_addr_end(addr, end);
+               KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
+                                                            next - addr);
+
+               if (next != end)
+                       cond_resched();
+       } while (addr = next, addr != end);
+
+
+       KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
+ }

--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -316,9 +316,13 @@ static int __pkvm_pgtable_stage2_unmap(struct
kvm_pgtable *pgt, u64 start, u64 e
        return 0;
 }

-void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt, u64
addr, u64 size)
+{
+       __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+}
+
+void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
+{
+}

Without cond_resched() in place, it takes about half the time.

I also tried moving cond_resched() to __pkvm_pgtable_stage2_unmap(),
as per the below diff, and calling pkvm_pgtable_stage2_destroy_range()
for the entire 0 to ~(1ULL) range (instead of breaking it up). Even
for a fully 4K mapped 128G VM, I see it taking ~65 seconds, which is
close to the baseline (no cond_resched()).

--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -311,8 +311,11 @@ static int __pkvm_pgtable_stage2_unmap(struct
kvm_pgtable *pgt, u64 start, u64 e
                        return ret;
                pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
                kfree(mapping);
+               cond_resched();
        }

Does it make sense to call cond_resched() only when we actually unmap pages?

Thank you.
Raghavendra
