Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04BF391838
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 20:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773692826; cv=pass; b=DH4IpGbXZSt5kPYP18Caf6CoSeymGB9V75JBEtTf6q/6jW4/ubmbOtrSN0bjcYaaSFOkEctrUaWv1s5Yi8Xvl642TAIBU859rj7TR5JTJ7Qs7bUCQ79ZJkseXpHMPTi3Hi3O3NnZIQ3nSJMZ4LXZ4xW7sm2WRXovlVAklPVOSbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773692826; c=relaxed/simple;
	bh=w3aEjEuUjeQXqeLoYDJOMLWyLHdOjvQ9XxM8JKxDsBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YHYTSjKbWhM4xICc2mAk+u5HZ4TIJeL1zlPJiRKMetPJeRrRq3dHDintfiBib2ziPDfmJ679uY2h37Oii/rWQGFwVPtL5kHAEvd/0d97SLVuDOrj79dD/FVso5lmdIKqpAmuoy1M47sghmOxZo2VjW0U0h2TUMk16g+QvSJNBIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FLwjL7rK; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FLwjL7rK"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50906a98ffeso171901cf.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 13:27:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773692823; cv=none;
        d=google.com; s=arc-20240605;
        b=NKcAwXwMSPzd8KAUsfpCiVZf/A1ebMKkRJilHGRMYwrA/kOkCF55zDQ4jW7Q5SE0QJ
         678y75sDkSVksYogD3CC97fdzjTNDVMyZID1FURqDJOLSNsG/hgurUY6oC2Ew3L3BFMy
         jtaZLZ46WfDr8IQC2UeABbLioh74v8VVIkSQ+tvLKQLuIsa2fwLhav72gOQedH4zYtWI
         7s4yJgLXY/GHwmRL7qcfuMhPC+Ya63qfD+EMqu06sBPl2wAIoBjkX2bpvsCUEu8Wq5K4
         SbukV2z4WgHHII103qVobLdeIOQ01hIN3+SereCLLdhYr2Ryl3K4NhRUqpgDwmXz+xvN
         C8ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TbszYKJSUQZ+CFv0gEYGu37cZ2puJInffZF8dV4znTc=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=N0pCsW/+OZXPDwaxsaFxlOom/qoNWsmLy/Ki+55e3FyvmKC/yHem1Q/t1+APlyBgXi
         dtXvy/xwwp/vGC9hhhnH+P+ttKMQMe/PyjV/Ql+0U9xFXl+UTE8dca535nc8kBJCNNt8
         qzNsiC8cDPFf+V+C/ID1UwtJEmAsChYy3F/VMuzIVjBqBhBk4zsXmem/6tE3sEsl0gXK
         BLlkpKQD6F/VMTSF8HNYEvjX0ZWK1Gd8PP/Mue9HX+4MRwTc+DQeDHgBe71cvcxln3e6
         +zMPNIBxl4ngMCuculsNWvACbnuJkqSkSBGRHLnuyFhdlAtKnaYsuQiO/vendNVhNi1l
         Wzqw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773692823; x=1774297623; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TbszYKJSUQZ+CFv0gEYGu37cZ2puJInffZF8dV4znTc=;
        b=FLwjL7rKzYDVTbTF/vvA8n66+8n3oO5d8S7wynDeiU6nNEQ1Kt4sciXToPLZqlKmiR
         KdBIJZWX9Br3GmeygKSGYukSjUpnPWqcHEUTlcY0agbB4VsWfzYy1XqGDdM3NJ3Prnwj
         PnkGCnq/8JFUgDdJo5JYk8ZwYRCCz9tQCQsZaQH/RDtoxws9f9ipmH/SfNQh/NKBG4i0
         qgPF45mT4H4ztRHRGO3CxAgSTjPJIJL5cWOzV716mIAl/u80VeBwLrqNqHgDq6LwGN/6
         fUazOiynGOCtr5qRCM5XQmdKaH1dax92knMyTFLXHHwa3Hs7s1LuG/Z8lFywDQc/A64h
         Batw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773692823; x=1774297623;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbszYKJSUQZ+CFv0gEYGu37cZ2puJInffZF8dV4znTc=;
        b=NVquk0I6EnyfWjxjI8h0tMDFOnR1ahzgjYfCYMtLTP0LmsIjpNawBo7GNXixHYdN4Z
         SfR4bzdjydwX2MJ3wsPKRMI4lKQDdpRVEVTSVHdRZzv+z6cqiNAEHvf6ZC+YUg05M0CT
         JLt1/bm835lzq+kn3kuQoOB/bUaKPZQQDxmZ6BLVOnp5lu77AqPkwaC8uuZkZQbgcd8e
         S4cr0JG3EwBqyF09jpW3WD6qWS5FCBEO9WJBS2vqJ8ePXq0BrwMPZ2RAJA8Mzp1irVLR
         PoPFGv9rvhX/mZp4Z8zacKMm96tuPRgZKtdyojaQvPVjt0PD6hmsBJkgPi7T0U2Si0BC
         c9Kw==
X-Gm-Message-State: AOJu0YyAUsgOuJPFl3aaagxPv7L7rfKpcUyQk5Cye4PhimAnqs9cD3u3
	zHrdii/8L9M+SW8eNE6kGKLrlUyhSdjRPbGFjQ57l9kr6HFVaoNiDNxV8U6/BbTvnQpjZhK4+Ej
	fVJPqKjAUpGG0PCNge06HfvYgchKNZXRiKkJzU1qS
X-Gm-Gg: ATEYQzxDlmKAWZnO1zU6H23RpEO/rvR/3c2QOuXqoh7ddR8U68SvqhMPMnqO2J/Dirv
	wK6Scv4UzKWQkM7+lLwqw91uC3VeKcYVDC5ZiINUMOT1ULyYWrf9R89eCb/riRsGnI5Jf4+KNHE
	IaJhxPjaSnYG8z62WcH0e8EPAhsKgsZXKMJU2LJ+punf6myxilDk5XCNKmW7B82uYRkldcWrbxS
	S7S+05/Xk0qRRtiAC9kVPzWnEOdepCgE2kWQb73Odpde22GVcQA2UNSQgZ2K7lBO+wFdZXtUPAG
	R3qV6vDs
X-Received: by 2002:a05:622a:10:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-5099ac7560bmr742881cf.3.1773692823019; Mon, 16 Mar 2026
 13:27:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Mar 2026 20:26:25 +0000
X-Gm-Features: AaiRm510Pj5izIGMuhDvumE4HdikBCeLOgGx-bwidhVdMD7QfZGqbR37I1-sWLI
Message-ID: <CA+EHjTyBtM5idopKisJf_e10aRifubtKEpbkjkEnmrOqa9-SPw@mail.gmail.com>
Subject: Re: [PATCH 00/17] KVM: arm64: More user_mem_abort() rework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Piqued by Fuad's initial set of patches[1] splitting user_mem_abort()
> into more "edible" functions, I've added my on take on top of it with
> a few goals in mind:
>
> - contextualise the state by splitting kvm_s2_fault into more granular
>   structures
>
> - reduce the amount of state that is visible and/or mutable by any
>   single function
>
> - reduce the number of variable that simply cache state that is
>   already implicitly available (and often only a helper away)
>
> I find the result reasonably attractive, and throwing it at a couple
> of machines didn't result in anything out of the ordinary.
>
> For those interested, I have stashed a branch at [2], and I'd
> appreciate some feedback on the outcome.
>
> [1] https://lore.kernel.org/all/20260306140232.2193802-1-tabba@google.com/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=hack/user_mem_abort-rework

The series in hack/user_mem_abort-rework is different from this one.
Here are the first few patches:

7243471061be KVM: arm64: Extract VMA size resolution in user_mem_abort()
3a8557ce6025 KVM: arm64: Introduce struct kvm_s2_fault to user_mem_abort()
9f3c0a14bbcb KVM: arm64: Extract PFN resolution in user_mem_abort()
98740dc5cf2b KVM: arm64: Isolate mmap_read_lock inside new
kvm_s2_fault_get_vma_info() helper
ea364906b626 KVM: arm64: Extract stage-2 permission logic in user_mem_abort()

The first patch here doesn't appear until quite later.

Cheers,
/fuad

>
> Marc Zyngier (17):
>   KVM: arm64: Kill fault->ipa
>   KVM: arm64: Make fault_ipa immutable
>   KVM: arm64: Move fault context to const structure
>   KVM: arm64: Replace fault_is_perm with a helper
>   KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
>   KVM: arm64: Kill write_fault from kvm_s2_fault
>   KVM: arm64: Kill exec_fault from kvm_s2_fault
>   KVM: arm64: Kill topup_memcache from kvm_s2_fault
>   KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
>   KVM: arm64: Kill logging_active from kvm_s2_fault
>   KVM: arm64: Restrict the scope of the 'writable' attribute
>   KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
>   KVM: arm64: Replace force_pte with a max_map_size attribute
>   KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
>   KVM: arm64: Directly expose mapping prot and kill kvm_s2_fault
>   KVM: arm64: Simplify integration of adjust_nested_*_perms()
>   KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
>
>  arch/arm64/kvm/mmu.c | 428 ++++++++++++++++++++++---------------------
>  1 file changed, 223 insertions(+), 205 deletions(-)
>
> --
> 2.47.3
>
