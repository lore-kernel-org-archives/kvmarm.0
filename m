Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3379F33A704
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577609; cv=none; b=XfXFTaVn40RxAW2fPVePzipwPIQGxOQKZ+Q9FZw7JKb9XyixPURRzr+abKzZqc+tAR9vhv1obUzX/hGdmv2nW4jyslFdpPj+QE4tCeRDHD+u0MhC/YDkXv0zStelgX0n2SHADOBNUdILv6nexlU8jdt0lggeIHgh4su4Ko+N6OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577609; c=relaxed/simple;
	bh=oYQJjlZIpsIZF7YLAGKB4ZoezlcIQxYNhsIH/ahTxms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0agsPJI7ZEBor0zlvRBOCx8nfFTTUc/i+MYSVwcejknuUzXMSKM6mb2R5emn+zi4Zwvnl4zshyJhhkL0p5oF0/CfF+lCjNbPDx+03PDibh8xafsLxLtgmnLyxYJCqZlQsw9560Jrtd4jmSwvXMCsuXh3rTjRLBMWvRLc92w3mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hnPfuKuM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hnPfuKuM"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34aa6655510so2104949a91.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 07:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768577606; x=1769182406; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MFDMwcUB+g0lr3+O0uNE+y+KlNYemC0Uyu3/6hhSiCE=;
        b=hnPfuKuMV5A/GZVBhIkGmkpAA8y1D0WjIO9rDayBefdPqnz8IeGVKglGGh6e4Ivt2N
         oLdsdJiOFvLk1gNYq4yU9tmv7Uz1QAAALyJBFTblsllvEd4GXjKB8LBzr39RiOIi5Eha
         zhBMVKjSS/S3e6Ydnsn2BgEAzC+pJRz/AAbsDl25O2PnFKx3YzTnodGesWS7OjAscLWv
         tryLj3hkzos4xtvsieob2LFPSSmGm84NDuqCVoSm05v63kShfdhLPdRIOkIXd0jqF1pj
         DVmuYBpPWT9IFGAqE9ONtnD0pLof9BchaiYc9AqPA2c4uzXzafXAOAt6k1kxiuSlJChV
         EPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768577606; x=1769182406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFDMwcUB+g0lr3+O0uNE+y+KlNYemC0Uyu3/6hhSiCE=;
        b=QBA5b+DDjJCYh7WrhVyVIJOrw1c5DVPmPZjBYMNv59pwYbHxYoT3ESCCrvvO1t2JHD
         mC3C1y+ytiLGVFrtwgmNjES5WC+mr5NzBOY7zS2eWcKxIJAz0ydNmEWlQiDOjhzFhX8K
         LIzGFXIADztLHDWnsNYBhaTmIdzTOlx4a8UT7Gks0aDa5ZHI3+FserPXsJp5j+QL6BVc
         uPFzt6H3H94QmhXNkQYmxJJ7jILHa4ZANRZRmTk9Qe34EHSUGbRs3Zp6b3J/hAPnf56v
         kb2WzDi3nj2o4obLejUrvlwENKv6NI4xzTdiVDwUEgUMTd5edrqb2j2BOiN58pXvOT8z
         YMCw==
X-Forwarded-Encrypted: i=1; AJvYcCVQ0h1HDdfKMQeEQJLWKHavHxoTDeI4+BRjUKFwVPwIQMHyB1YpqHgIv98bCcEsFv6uMXgeVQU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxaCmsj6ic4R5XKYswIt1fq7UzrR1GXDWKAVIanOqJG53I1eYUc
	3/bk7VE7PvQFcBrGzhehQcxFAP1MpSzr3xS8LMGZ0uO4cQE3bznZBKBgTUBhfIrd3sdVtJh/WMW
	fTNIZ8A==
X-Received: from pjbsh12.prod.google.com ([2002:a17:90b:524c:b0:34c:2156:9de7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5803:b0:32e:3829:a71c
 with SMTP id 98e67ed59e1d1-35272efcc92mr2558426a91.16.1768577606439; Fri, 16
 Jan 2026 07:33:26 -0800 (PST)
Date: Fri, 16 Jan 2026 07:32:47 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176857711424.940905.14821355548518788463.b4-ty@google.com>
Subject: Re: [PATCH v6 00/44] KVM: x86: Add support for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Dec 2025 16:16:36 -0800, Sean Christopherson wrote:
> This series is based on 'https://github.com/kvm-x86/linux next', but except
> for one minor conflict in perf should apply on Linus' tree once the KVM 6.19
> pull request lands.  I considered waiting until 6.19-rc1 to post this, but
> I've had this in a "ready" state for a few weeks and want to get it out there.
> 
> My hope/plan is that the perf changes will go through the tip tree with a
> stable tag/branch, and the KVM changes will go the kvm-x86 tree.
> 
> [...]

Applied the KVM patches to kvm-x86 pmu, thanks!

[14/44] KVM: Add a simplified wrapper for registering perf callbacks
        https://github.com/kvm-x86/linux/commit/4b24910c0569
[15/44] KVM: Add a simplified wrapper for registering perf callbacks
        [DROPPED - already merged (and then fixed)]
[16/44] KVM: x86/pmu: Start stubbing in mediated PMU support
        https://github.com/kvm-x86/linux/commit/3e51822b2fdf
[17/44] KVM: x86/pmu: Implement Intel mediated PMU requirements and constraints
        https://github.com/kvm-x86/linux/commit/bfee4f07d880
[18/44] KVM: x86/pmu: Implement AMD mediated PMU requirements
        https://github.com/kvm-x86/linux/commit/9ba0bb4ae76a
[19/44] KVM: x86/pmu: Register PMI handler for mediated vPMU
        https://github.com/kvm-x86/linux/commit/1c4ba7286afb
[20/44] KVM: x86/pmu: Disable RDPMC interception for compatible mediated vPMU
        https://github.com/kvm-x86/linux/commit/80624272129e
[21/44] KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit fields for mediated PMU
        https://github.com/kvm-x86/linux/commit/d3ba32d1ff2a
[22/44] KVM: x86/pmu: Disable interception of select PMU MSRs for mediated vPMUs
        https://github.com/kvm-x86/linux/commit/2904df6692f4
[23/44] KVM: x86/pmu: Bypass perf checks when emulating mediated PMU counter accesses
        https://github.com/kvm-x86/linux/commit/0ea0d6314870
[24/44] KVM: x86/pmu: Introduce eventsel_hw to prepare for pmu event filtering
        https://github.com/kvm-x86/linux/commit/02918f007792
[25/44] KVM: x86/pmu: Reprogram mediated PMU event selectors on event filter updates
        https://github.com/kvm-x86/linux/commit/3db871fe185b
[26/44] KVM: x86/pmu: Always stuff GuestOnly=1,HostOnly=0 for mediated PMCs on AMD
        https://github.com/kvm-x86/linux/commit/a2f4ba534cc5
[27/44] KVM: x86/pmu: Load/put mediated PMU context when entering/exiting guest
        https://github.com/kvm-x86/linux/commit/56bb27369750
[28/44] KVM: x86/pmu: Disallow emulation in the fastpath if mediated PMCs are active
        https://github.com/kvm-x86/linux/commit/f7a65e58d643
[29/44] KVM: x86/pmu: Handle emulated instruction for mediated vPMU
        https://github.com/kvm-x86/linux/commit/283a5aa57b22
[30/44] KVM: nVMX: Add macros to simplify nested MSR interception setting
        https://github.com/kvm-x86/linux/commit/cb58327c4c8a
[31/44] KVM: nVMX: Disable PMU MSR interception as appropriate while running L2
        https://github.com/kvm-x86/linux/commit/88ebc2a3199c
[32/44] KVM: nSVM: Disable PMU MSR interception as appropriate while running L2
        https://github.com/kvm-x86/linux/commit/3b36160d9406
[33/44] KVM: x86/pmu: Expose enable_mediated_pmu parameter to user space
        https://github.com/kvm-x86/linux/commit/860bcb1021f5
[34/44] KVM: x86/pmu: Elide WRMSRs when loading guest PMCs if values already match
        https://github.com/kvm-x86/linux/commit/b0b6a8d3be16
[35/44] KVM: VMX: Drop intermediate "guest" field from msr_autostore
        https://github.com/kvm-x86/linux/commit/462f092dc55c
[36/44] KVM: nVMX: Don't update msr_autostore count when saving TSC for vmcs12
        https://github.com/kvm-x86/linux/commit/58f21a01417f
[37/44] KVM: VMX: Dedup code for removing MSR from VMCS's auto-load list
        https://github.com/kvm-x86/linux/commit/0bd29379114b
[38/44] KVM: VMX: Drop unused @entry_only param from add_atomic_switch_msr()
        https://github.com/kvm-x86/linux/commit/84ac00042a28
[39/44] KVM: VMX: Bug the VM if either MSR auto-load list is full
        https://github.com/kvm-x86/linux/commit/2ed57bb89976
[40/44] KVM: VMX: Set MSR index auto-load entry if and only if entry is "new"
        https://github.com/kvm-x86/linux/commit/0c4ff0866fc1
[41/44] KVM: VMX: Compartmentalize adding MSRs to host vs. guest auto-load list
        https://github.com/kvm-x86/linux/commit/2239d137a71d
[42/44] KVM: VMX: Dedup code for adding MSR to VMCS's auto list
        https://github.com/kvm-x86/linux/commit/c3d6a7210a4d
[43/44] KVM: VMX: Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR with list address
        https://github.com/kvm-x86/linux/commit/9757a5aebcd6
[44/44] KVM: VMX: Add mediated PMU support for CPUs without "save perf global ctrl"
        https://github.com/kvm-x86/linux/commit/d374b89edbb9

--
https://github.com/kvm-x86/linux/tree/next
