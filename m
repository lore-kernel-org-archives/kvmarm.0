Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C2436E48C
	for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 15:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774195066; cv=pass; b=ZRFgqQYZcKMmSlABH2771ZoDaQbMxYTUxoJJ07BwjAPeIzSt+QKh4DsS6mxqyu9jsN1DRcO3inV5ATyKnXfU41/eQP5P4LR7ZRNWqe1bDmmyB7WrhyGjSkCcfsVMieH408kRVYuVuyNav2Gwm3Cn2wHEFyjjBRRCQMAVA3t4Vsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774195066; c=relaxed/simple;
	bh=65twC/jhEDZiz0eFQDVmydTjZYj0s+Vqfpys2qBneXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kD80uD20FoOVWMfC7qqyUsayxS/H7qDGMla9pfvRXbWJdFk1XKNelB0mhWbR6MCfcRrevKRef3pqwu1A5tm39mRI0VcjwRzfDqsZNI1dxVbAzC+0CqS3zN0BNodE0Y5nnbo1gkIX2bQoFIHrVTmlPz2WSG3+agOPqyZTGMsVR9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kYo+8liO; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kYo+8liO"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5091ed02c54so691431cf.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 08:57:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774195063; cv=none;
        d=google.com; s=arc-20240605;
        b=N1Efa7tuYTbAFD8Q62OguDk7RWFuz3T0fzNpT3Q6UawI39yhRILkbBV5oa5xyImhQ7
         Lp82X6eDzrP+AfJhEtg75Hrgm/Yr0Xm/1Dh+eyRQ9HcSSaM2hsdCvAw3h5cXVGg0/V8L
         JlE0IkduLqVDDZ6srQy2XV1xNrf2sNJn3vvz2A+LAYPiwLOrhA7xe1pzTloXQKaca7uf
         iSZGYDeNoPXmTpucP0UO6z1AfvQeHdkkeRF+UmLvMRGV2hbqJxjHAoA1nP2OmQpcdg3D
         hfquThvFz5YZEn1QUzaTFPcDvJRubALaXPShyE5k3FZkQaBhU/Gv+BHupw003htssP76
         gwmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jruzd6NkqjuAAF2rHJBm3v3faoRwpO4fCUwyZnfsofw=;
        fh=br/O7ad/Dpl82iqHQ050DMUcdTbv2XuF8/c9+X0NSgk=;
        b=EpSdVFUUIpP4HELSYxOKlcpCVwvLU3OCzHhO1qsJkxwu7+xHtKRSwyFpL99zbDdKAU
         j2KwE1G03JnTNdUy4BFBogW5USdELV5bgfniREIAixzrwhJY9n6G1UjzGqLM9qs8KX+Y
         wRV/f4otQD3i5yjWn+sxhjLtRHLeS1cPvVlFDa1Mhk81x0dho3xAOXKxnGXAVpCJHnTk
         mrTZMmTun87XQ6XP17eEHV5Dw7Rs9obPlDMI27IFlRpcaDn/NnsMCrkAJVmw55XgVe8P
         yHN8fTp9kF3bSK/niO4hyjyMx+IYHvt+CRPQCowwy9DxenBLsrY4T6y7RP6s6/pvUijf
         KkLQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774195063; x=1774799863; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jruzd6NkqjuAAF2rHJBm3v3faoRwpO4fCUwyZnfsofw=;
        b=kYo+8liOTdeaI9cT+dFGf+z8gNezxGhTpDHOD81ssRUPs5z+BBpHkzoWwA+fM3h+ad
         qgf3B9qCLXtV/b9/2dJM2nVyKABf8j9OVguqBRtzHk9BWi1F4kSOXRP0WiSpeoGi5GfU
         7pqPx/zzFzC37w4h6Lzj6tb3Bc1zMKvrjaFK7QwiStQ/cHQBPG734KCSVNs2BMuwaI8o
         GowqDfnAjr8z/ZcmE+haMfGK9wqks7+5p4m6h5JsOUHGuzAu7BSKG4C4M1z7NCqmR5X0
         gVApsZW9MzAjsocVC9CnH7LnnEwcRBkaoUCtcN7tHqmt0+VerR/zALVemQaJFIZZpfl+
         wcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774195063; x=1774799863;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jruzd6NkqjuAAF2rHJBm3v3faoRwpO4fCUwyZnfsofw=;
        b=IM8RnJEyl7CBuIkDv3DpnN1/3ImjXjEmJ+5ArfsAgddC5efLK8pDC5Tc21wij+5icZ
         CbvT1y8XatRil6Oq2Vov1KU+tE2P7RZ00PPmsgb87HB0fc/bq53W+W9SAj2MQvkUtPYU
         UNGqrkgDr0LJUaSNTbwhSXqFWVmxobVycRamv1UOZBgH62/jJP6/8KNO9LSyU06MWAMb
         EJtKr8zXvx8rH39B/+F6p27+QgfPpzj18s0pUW5BnNDujrDin3eJ68Kt3UOLkZb6xTsU
         XlVehbzJ8fAilL5C5lYwckXGMDXpyJJz2I2x0W5G+b0WeIE8jbv8a5BLxfSw8+bHQQIt
         8CHQ==
X-Gm-Message-State: AOJu0YxeC3ojuaVhYIQnhm0t76J6YqHDor0v08+GuAzB7vxIU2uHALOU
	jYgx4tET381/ONn02muag51k3F3liFyF3DH5JZ9rUglCjeI/rjGPxePYP6rgpcAa2LclP6+T0W7
	AurJDlDlIhWCom3UH1/Pf/gCGpfqLkbzN43pVn4j7
X-Gm-Gg: ATEYQzzQKTSHCGzpAlQrAEc0v6EHuv58pLM3rXUUG53ZPH/ArJOpJ3+KN1VggktpzOb
	+CSuTeXjJ8Upbur+I3TpDBUcfpeNQ2PALKoRXVp3nSNezCS9AWPJdEDURRl55pVWY34Y1ONJHuB
	SK/x0hbkwaKDtXJ6kLZmhgk1mnhzWC0iCRMbWRgiAN3Zw6Ifj5hENS7iTi8M8DEBlj9Z5CYhklR
	360nGv/YAczp8ZeEpXHwMB1QXZyFWjGD3/cF6tkvwOz51fc5pI8HI+Guc4MxMIpiHM/EhpVgNqY
	aOTp9J2J
X-Received: by 2002:a05:622a:1211:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-50b480dbd8emr16496101cf.17.1774195062641; Sun, 22 Mar 2026
 08:57:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260321212419.2803972-1-maz@kernel.org>
In-Reply-To: <20260321212419.2803972-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Mar 2026 15:57:05 +0000
X-Gm-Features: AQROBzAJIzRJ8D-goNBVthnfORrFTafE31L7zl763iq-2MUJoVzQZfSh1NnQFOg
Message-ID: <CA+EHjTyqYQhCCYCRyZv5Purm1_2gL6KGeq_Y24sgiSZgWuGT1Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: arm64: pkvm; Rework aspects of the PSCI relay
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Mar 2026 at 21:24, Marc Zyngier <maz@kernel.org> wrote:
>
> Having recently spent some quality time debugging [1], I ended up
> reading too much of the PSCI relay code and felt that it could do with
> a bit of spring cleaning.
>
> To be clear, this series doesn't really fix anything. It simply adjust
> things to my own taste, which may or may not be everyone's.
>
> Comments appreciated,

With the copy-pasta fix to patch 4:

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Marc Zyngier (5):
>   KVM: arm64: pkvm: Move error handling to the end of kvm_hyp_cpu_entry
>   KVM: arm64: pkvm: Simplify BTI handling on CPU boot
>   KVM: arm64: pkvm: Turn __kvm_hyp_init_cpu into an inner label
>   KVM: arm64: pkvm: Use direct function pointers for cpu_{on,resume}
>   KVM: arm64: Remove extra ISBs when using msr_hcr_el2
>
>  arch/arm64/include/asm/el2_setup.h   |  2 --
>  arch/arm64/include/asm/kvm_asm.h     |  3 +-
>  arch/arm64/include/asm/sysreg.h      |  6 ++--
>  arch/arm64/kernel/hyp-stub.S         |  1 -
>  arch/arm64/kvm/hyp/nvhe/host.S       | 11 --------
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 41 ++++++++++------------------
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c | 39 ++++++++++++++++----------
>  7 files changed, 43 insertions(+), 60 deletions(-)
>
> --
> 2.47.3
>
