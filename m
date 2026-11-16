Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808844;
	b=2eyIwVC9rKuumxQKCYYu3Cx840NOhAbrYQJiY1yM5WHoc0kRLq3V+AWLMEY/9t1eTfK7
	 8CyyRiWqpOSwFG5PwuE2mYw2rUGhrkUIswRfumg45KbuXdNadmzG8GII0MR9dbkeQRdlD
	 1C6xul2FrQ65VgMvVWi6UfWwSLXro5uBqnkz8RimRWoZoKumRjZttf5TrzcqULqINd2uv
	 BgoeLJbFLpAueSNTs0MgS62rDux3WwXFD7pYkrz0ijb6tuhmKUH9OAEHdT53Ixa4cfsm3
	 Or8Fvyc7YMW71zWh19r++MUlRV3ADX/xsN3Sg56QBY5T9jos1eI/T4EElXkoHHu+mDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808844;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=4EJinoQFWOQAxBpp8/0xszfKNpVkrh34c2hx1lgmetc=;
	b=PuVSELKDmp8yt8jhfB+MAKPIjBk0gSVWVdsmMgHHjOTD4Y20HhQVh2drxGWvcKr8hqr4
	 otJmR+VuchJaiPTNGbyZoQem5XALRAuq8pTLxcZ2XJvH+gW7S9B6UOf7UeQ12XbKGDsYM
	 czyH+n+bBGWDQB2i0HIJ2f6F3NEGylJhWUB0Edc5rDMKwjBhzo5bZ600Ud+39FS2YTCpV
	 4ELurwpQAECGZJMCkdsVp3ZOTQTneqhBezxqqkbj2U992CLSD/k2d8wM8Hf8Jtjv0AbBD
	 Ao7UeNsiOz/UpsY/2gqxQxL5//mM3SG7jEwVJhjz3uf7RvVPU+TSMGD0HzGEIwF6p0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Pa6yCJYl;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4A8606A31C
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 06:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC4A8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Pa6yCJYl
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso4269280a12.1
        for <kvmarm@lists.linux.dev>; Sun, 15 Nov 2026 22:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1794808841; x=1795413641; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4EJinoQFWOQAxBpp8/0xszfKNpVkrh34c2hx1lgmetc=;
        b=Pa6yCJYljfw77Txa02Gv6yY8KJ7MCFkhqntFGZvjxg/eGaOtMsWk/GpDaXz0wLKu/q
         ug8FsLtZKbZyFqn9eEjflBm5GIXJlZvzeJzrt2QPx4fwcMRzwMUjugilxDo8Cu3FvLvM
         46nJDaDOBQ7mgkLfkTKkzaQVtwt0vvC9Wn/Wwbbsr9TVX0YUx2H38VPIINXbngeNnaco
         jAX/2Zc4Kw2AenjmS1Qxxn9XbZe8jpmCnaA4DzH9Ub+X58GQ1zZTNMqoqgN8AKMVOq0/
         9ard4jmIvAp02C8An6jBz29a7ASiUisIaMrfV16m6pY7RicLlt/3tkkTuHHSYqXcIIfq
         3oSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794808841; x=1795413641;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4EJinoQFWOQAxBpp8/0xszfKNpVkrh34c2hx1lgmetc=;
        b=ifBQpMpTIjO1gXvb26pYTmrrzIyl28VKleMnA9BPQq3nz+QxKnO4aR2x1fUVSsOF8t
         RfLRLHHQH9EnPbDvuQM7ux4zDRCq6TYDCstwFkZdP6I4TqT1QaZsI8o+R0oS/UIPkjc4
         sxIq1F8LJnUpzU0QFT73JjQv0sZwU/Gb1pZAShw6vYWclblvzTpTaHO0wF/qYu/PPbc5
         wAuhElvh5Ia7Nu+yEoLRuyCiFBrv4YaLuaMjU7QF1GpMdivUcNUFHMLIN571H68N71Xv
         8YtS8vFOcsr7mxEehwKqbVLhDGVaoystZrNsIcbkU/LJfCQ06azE+qjBNKmO4HEqkT8t
         ZOFg==
X-Forwarded-Encrypted: i=1; AL+hErFA5h+4k7Rm3IdRDPookwLeE4Ojhzghn9AYrQYIemXciqq1glHLL6vQMGn+2mrMUeme0dFQoP8=@lists.linux.dev
X-Gm-Message-State: APuU4Z+8u+kCzYYmn7LOLrKJYY9ByrYHddxNHdnpDoZpa/VMoBa8WqhK
	33OkfEgaNMrHWG1vd+20dBrgnSN2vSre/eXn3o7J1JPA8533Py2u8MiU00GvKPP+HG8=
X-Gm-Gg: AYBFou3dWb8fkN0Fo/Ltqx9JNnvGsXrAUnnBMjwq0M7qtuwV2YpuB6U8S+IeQoStJT2
	fLRwCW8jsgQBjZZw22vfZd3g6wlb326YSUmexnGRVROb+eU7L7Q9PP9DmRVaeJ9YfaFCcX66mkP
	thAeJHnqHvjRfw/6VJZFCa05xEfc/WAc2e9xtJj5av5xOjH6azPKpbUYduyd0F6o/RHzPFjsE8E
	Ig4noG+DEa5pMbr5T9snoWzUW9mtNX+M4GH4wZ9n1NAFLaUUe0mpErttmWDRU9JfaisP2Zm5DFn
	wBaUfxaHEgqS8/KzWLpZZ8McQJqDegkPdaF5HMRW1LVRbJh145+iYTnlZ1Q3UwKmHnrMhoV+CPq
	887IgJOpQ6PPoxdzND7tHh91NtkVuiTx3gp0KI++f6mxVVt5M2nVfPiEbZDgsHPnwDq2wizck8c
	aRKurqiEK2GZ0M77LZqDZzkGXjmt49NIvjZ1tVcp80Z23hv4fBmPwJo5dc3ChkpiHJO4C1jLuHZ
	CDTmTdVBEe42wGtVVppbMUbiUEL4W3KqLNQ6xSIxWUJwTZ+oL/t6fhWzQ34JoxWqYWLVDOCXscC
	7HlQa5+IbW6yQPB1Otg=
X-Received: by 2002:a05:6402:2389:b0:6b7:1c:ead6 with SMTP id 4fb4d7f45d1cf-6b7c0be11abmr4151963a12.28.1794808841111;
        Sun, 15 Nov 2026 22:00:41 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c21b1b5asm3973648a12.4.2026.11.15.22.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:00:40 -0800 (PST)
Date: Mon, 16 Nov 2026 09:00:36 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jintack Lim <jintack.lim@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH 2/2] KVM: arm64: nv: Update the shadow MMU's VMID for AT
 emulation
Message-ID: <5467fc4aae218b86846454bba96c3ba2b95931bf.1794808373.git.dan@pereq.eu>
References: <cover.1794808373.git.dan@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794808373.git.dan@pereq.eu>

There is a missing kvm_arm_vmid_update() before the __load_stage2()
in __kvm_at_s1e01_fast().  The bug affects nested virtualization on
arm64.

In KVM a "stage 2" refers to the VM's page table mappings. The
__kvm_at_s1e01_fast() function emulates the AT instruction, which
translates a virtual address the way the MMU would and returns the
result.

Each stage 2 has a VMID, which the hardware uses to tag TLB and
walk-cache entries, so that one VM never uses another's entries.  There
are only 2^8 or 2^16 VMIDs, which is quite limited, so vmid.c hands
them out by generation.  When they run out, a rollover starts a new
generation and flushes the TLBs: the VMIDs active on a CPU at that
moment are kept, and every other VMID can be given to another VM.

The kvm_arm_vmid_update() function checks the VMID's generation, takes
a new VMID if it is from an old generation, and marks it as active on
this CPU.  Without this, the shadow MMU's VMID could be an old one that
now belongs to another VM, or a rollover on another CPU could hand it
to another VM while we are using it.  Either way the AT fills TLB entries
tagged with another VM's VMID.

To fix this, call kvm_arm_vmid_update() to update the VMID before loading
the shadow stage 2.  That marks it as active on the CPU.  Then at the end
of the function, undo that.  Restore the original VMID as active while
checking for and handling rollover.

Fixes: 477e89cabb14 ("KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/kvm/at.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 06765881a4c8..34c9d10188e0 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1455,6 +1455,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		}
 	}
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
+	kvm_arm_vmid_update(&mmu->vmid);
 	__load_stage2(mmu);
 
 skip_mmu_switch:
@@ -1496,8 +1497,11 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 
-	if (mmu_cs)
+	if (mmu_cs) {
+		kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid);
+		config.vttbr = kvm_get_vttbr(vcpu->arch.hw_mmu);
 		__mmu_config_restore(&config);
+	}
 
 	return par;
 }
-- 
2.53.0

