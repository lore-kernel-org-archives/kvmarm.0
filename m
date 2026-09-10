Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE2945D93D
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038591; cv=none; b=Jt2GbayFo7E5c+zsi635MwjCdcSsb11gSjBsug2VTohTeVZTp3jyAVVpzXtp/LS9pByc9vqlrFQ9IqU1kNi6/7AGOj+tX6E4/ve41DmTseSeAP2uswssl9MtbvFJS0yNkuWt/8oFD+GJ8z9UKxAzHYZeEy6cB4dBUVk5m4T05iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038591; c=relaxed/simple;
	bh=Eo81uOdJ+VH0txQFT7CDWDmJC3Wu6IIZvi7ALvkgXzU=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=rtOLS863fZOIH0gmIusysCpe9TlOY/T787TeMiNZdWJGrlt7AW/sw/n87iuVd2PI7J9z6pYKUD3BsjGa1AA0smyuXCXKVao4IEdYThzHir0DDVnq7Z2NQFTUqoj3YfvPpIwuV2jTbfEokOUumVm7lEpKc33u3dDUjgI7G2T+6jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nkJD0N/p; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nkJD0N/p"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea4bfb6so640467a12.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 04:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789038588; x=1789643388; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8QbTTWk563brFKzUulM5hzJdIlUHhbe3RJ1vb+Th/iE=;
        b=nkJD0N/p/HH7QeqkklYrLD4QRtpTZHh3GjZF6nPNbjktZ6dcDhH4K9RP62MI6NUlbg
         GOOimYMpHD4KKrVmil1NrTVIeQr3NqYhIdNsdojtR5Y7uaiJFyefV3Y9IkuQAyxahHNO
         N21RLC2bSA9tCgZ0tLGjTUXP8F9/diD5RGNBVzAJ2dgGez5rATqk2GTN3YsE/+H94HF6
         2Nkt/angchDyfYkCqqeOxG//VsRcK2+8jqCYb/916a3+LWlCu7taiOUwOA6Yjp9+weys
         TZCj0vv/6Bzw62+IXQTvUSrVF4+nAdWy16bllT18H1SOlCJYOgColCBVEzXwxIU+hVYy
         c6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789038588; x=1789643388;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8QbTTWk563brFKzUulM5hzJdIlUHhbe3RJ1vb+Th/iE=;
        b=Ri27fJtVJtyF+4wbxRJvj5PlNqZbS4IjJR6BHDRSsaWW6A3NK6LfM/uxgtGcbszT0N
         8LpTUOmx4DRITwTiR9r6U7fPDXRv3ltCirYTI0okiglNqGCmb+GKbD5EnFnbRDGSBCDQ
         oHzvK1BofrZdmfdpt0kYX8a8uFZ9ynGEW8fPS/WNkXYZB2Nkgq71JXUKPilr+VlA9Rhx
         eXN4Y/IDW2DxT9+bFl7u0L10xPcunQDoMV5Sq1KhvGe1a4Y3NtOyoagV2IACvjoEzf5N
         Yd0GPCBeniHg334hWBjvVZRiCAuEBNVD5o6amr/DWTsLlavvnXD2z0n2y4jUEuq6B+Yt
         Dc7w==
X-Forwarded-Encrypted: i=1; AKwUvBwECzKGcrAE52OCb44oRB6C3TxfFdFDBwTnY+6iy7afNlKJkfRFYyrvlr1X0T9KrpfKoZ2NK1I=@lists.linux.dev
X-Gm-Message-State: AFuF++mgCeE1g+sBotpj+eFj/yc5taeq5asiS9Naw9hzZITK0SGnYCoC
	uJV6Z8e0CvUITxtvwci0tbNp6xOhOnBVoe/+WDQ/g4hSN+DGQjNJnpQn
X-Gm-Gg: AYBFou3coDGptOKjxY2k3zoP+Twy0S3W8laX/0ARNZYJwEH9FuOPlHV/xCcTgJkBNVe
	9anRlCYypldH5HxRT9xsO15Iu+QxYUwx0eJF0Ovm7EvRGH19aaQ9gR1uqamRrlgWey8DBtq8+mF
	Ob4NppzzQs+LJ3ObCLhzgZABbuFdPaoyNnzJSZayccMU+aym2TY2vesJmq9w2um1ziqKpG+zRdf
	KNpxnCZCJb8P2Tn5qvuUTolyXxHlKk+tFm4B+ZqcyKv2ByWvRa+J/aInQt/Y/KA25suwZXMYEMd
	7MSeVRllO81QBgarx51Ucq3aSI7sPDM7zZPGefAitzrCvRdV39j3FOmoF2hqVcVHO+emCZIy/4+
	ZaPoLYN2vE6qQu9du8NIM+7A4DKIWc3rlBxaUvrSHQXRCmGhAdYtsy+WCVTdOZNlBGCwkZZmPjS
	FiDoSty8GM279CA+RClQ8jfQa9XkYxfTyaJlhr+BgRdnnMAo1bw5ISflFjDXIkzOiTo5l+K7XUi
	9WNydGFRHcENjt9BaUvxwKKpfFl7odOe3LeWrt3W/SzxFNgPqhj1PI=
X-Received: by 2002:a17:90a:ec8b:b0:399:1b64:e0d7 with SMTP id 98e67ed59e1d1-39d70bb1bd0mr11082578a91.19.1789038588475;
        Thu, 10 Sep 2026 04:09:48 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432424d27asm68881202c88.2.2026.09.10.04.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 04:09:47 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 11/20] KVM: selftests: Initialize vm->memslots[] with invalid memslots during creation
In-Reply-To: <20260902164123.2546762-12-seanjc@google.com>
Date: Thu, 10 Sep 2026 16:39:02 +0530
Message-ID: <7bkt1hyp.ritesh.list@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Sean Christopherson <seanjc@google.com> writes:

> Initialize vm->memslots[] with an invalid memslots value during very
> initial VM creation so that failure to configure the core memory regions
> generates an immediate assert instead of potential weirdness, e.g. if slot0
> is coincidentally valid.  This will also allow hardening the region APIs to
> guard overriding a region's memslot multiple times.
>

Sure. Looks good overall. Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
