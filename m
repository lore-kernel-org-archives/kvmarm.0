Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316D334D4D6
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785796208; cv=pass; b=gjfIovaQgmWEGQJSxtv0nPG/fd2KnWvvKawOvzfChvP1f2gtcqHbHIS56SeIA8hM+UIN0fDMz3QF9pt/b4RMEqH3kLpsoJ9qFyGzZ5+tSwruMaG4ETinE97oUhKqYRaz1qTunxOzid2ncYLVNDoU2LOYhx9+vXM0NwAp6fVfO+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785796208; c=relaxed/simple;
	bh=SoGWMfuDZcITvarO1qukl7KE+ls5azooLD7ZNrSHGPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ox/uJVHhNgT+bWz7pfQU6HxNePTJHbe8Hd9rJ4Wikz1BrpwDT6ydlMjCUmDFi7efpO5F+1Qp1k253QpHDlbGZQ0bj0sKrgjq4sJtAEIc17ZMSQeFa8NQfO51eaEODFSbd3M3bYNc2D3FgRUoeS2MEIimfHsOGBNi82RT5lJsP74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f8T6DO5o; arc=pass smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f8T6DO5o"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92ea24a2dbfso308019385a.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 15:30:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785796206; cv=none;
        d=google.com; s=arc-20260327;
        b=UQTrzKyVdOpRZi3sUPXnoGe6VN326uBjiWHmSP4sWOPpAVT59gJhDCk7hYRic8J8tL
         GZESHcVNAItLCbuMf/BuJi1Juupj0w+/Yo++SoqJ7NvnFuNSz4HxNzkwpsYvRYDBhlJH
         4gsWfgqxsJWQZ9t30YC+3JdRz67+1l4R3kyMcrKdS67rj+YwvB4uvfFj6BRETDxVG06s
         xgXgstIghOepAaxo/K2yaxf4Z/2hgPrAhpUkbD1I44xucSCLjjurL4b85E9COJ2NVaCD
         myHb6hKFnPR8tbZk63ccJGhQw6AT3m25yI9rkhjJsudlMinQoEZW8E+1KLDA4/SMttbr
         WG0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3yTl9Y/o436Zlv2Vup2MQ3FRSTw8xGxoHxInk9rGis4=;
        fh=fxXmP4rQ7ULdHA8FP1UOh9I4sopMTDJGi2Be+eFFhl0=;
        b=Xss3u4x/OMLS3N7iGi0FfeR6K+Jr6AF/yjlrm8ttaJiYFg8dGtScqdylY2a6e5P9EB
         x5yIO+n7oO/lSKUG0NKgGvfquBhgfyXRGYaP6XNNQx0hgSUd4DbLAMWd4AxQ86u/YRg4
         MHZ3MQfZXVrzJHPihYyNFVN6tnob5/utTUoHT+f0LsM7hiD/0d3fuSWUOmDh7BeFYx3u
         /k2HRE2EwTUM2X8mNzxBU5YT2Bm6HgMNTtwZD8jyPIdSwh+WM/gOt+INmWElqVmMspmY
         4YX1yR/cylxumTuCjsDLUdInAK0h4HS+l6tcPLh+R0grsu/9L6skxdLaS2InRD1MF2jd
         /k1g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785796206; x=1786401006; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3yTl9Y/o436Zlv2Vup2MQ3FRSTw8xGxoHxInk9rGis4=;
        b=f8T6DO5oeI/yBh7vbAt8RY/i606/Dl2Nk79eeofxfwEMm2MjgTEvA8O9yiVvV1qn6O
         Zpa9tJ6GNyE9Lb3tKl66yo4w89PrVUoaKUBKDjTUUzZzTl5vF5cvdR1WRRpR+4XikCEr
         Mlw2U6GWIoQqK8pAfhncj4hZALiaG350LQ5r9MhskrzF27lJ+I/Vk4kxrDrAAvI7SuJn
         Qj3dyUOcNQeb0azT3Zvv0BSvVY3xbQSMcXWjowHcMBrMHNBOqnbkkIrRWSUVGZNgfl2e
         4T1gR5slkiONk2IWQFzFCto2h0tJdXa9/pDa+biKBr/PBFArUJLZf2E7niYQZ/DsclfT
         coPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785796206; x=1786401006;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3yTl9Y/o436Zlv2Vup2MQ3FRSTw8xGxoHxInk9rGis4=;
        b=YverMB8qB8hpkIFTnieXmUfhFAXCBmuzr7TntyYwigEZs1YvGR5KVcLXsCSmlz/xVD
         wBoqZAWlmV8DMboUPecoojFLkJp5SNDD/BHEAW4LufIzrKqh7lPrfcHXuB3xqhLdmDmO
         RaqJqi3/cMpjRVQDc28pBBhhKlDG/6RVWbhXXSd5YsCbwqjIO3t8dOXvvfEXnARsdMfD
         TxXfCfCu3vIUwXXxLuWltQ1skij0/1o9MbjnFlzAv3vTQD9BiWPJFc4jiFXn1aUzfI6l
         u9FsBf6wRmh7nUwwhr0tNS7xZ6w3H2fofbi4JoUbmxaCpI6p1H8fyJIYVS65nYRcYgjI
         msJw==
X-Forwarded-Encrypted: i=1; AHgh+RpWHuJQKSt018wONZvRvai+qcNwamQXihgHofuPvct25ZH5vf9+m0LDmCuwj0OTGEAVkTwTn6U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxG6oHRUuAKWmIu2e55qSo+KPVIo+RXykDofoYst1rvKZwjee2O
	mPqv7Vg1btKNXMz2PTsKe3NpXr8Pv3xgTfV525LCVbfkM8bNORmPyy3onodOM80DlaedrK2XRYG
	7kqx/kK+x5cU2TiF5zaO61MqItpU9Y5eksQQOLwrndU3beZOwPlkVeIQg0c8=
X-Gm-Gg: AR+sD105SBVpchqD9aBGDJzZAFjdFBu7Mo4KvHeztUXDpCToKdg5EDXUMGQFE5hOrZ3
	c1+q4KhJCY/CrkvRPxeJlshbl+bJLu23ltzCbtTw8/jJ3lCA0WLZbA2N1KtE6c8ef82UTPtZSWZ
	gy/gV+4TZI572Ze941rho3SGzYfsrys7/IN9VJvuoy5pgVMJ8pQraAoj9VgUyKWDZmnAXQJDgN2
	khhcLrnfmTPD9XuDUArsfYHwVAFZ9Ewoe4wpaDsLbHGlBYNNvKBZA74/6sjEjHdImINHKp9E+7C
	hMuIoCOEroob5GC+5XF4byDxl2AOlxNF3XE9NtuiGVQrsKE6Fo+hkBFs3VGNScIjOgnGWu/tSZa
	wGw==
X-Received: by 2002:a05:620a:1788:b0:932:d92c:1604 with SMTP id
 af79cd13be357-934a093ee41mr1858091985a.23.1785796205213; Mon, 03 Aug 2026
 15:30:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803134403.80630-1-steven.price@arm.com> <20260803134403.80630-18-steven.price@arm.com>
In-Reply-To: <20260803134403.80630-18-steven.price@arm.com>
From: Alper Gun <alpergun@google.com>
Date: Mon, 3 Aug 2026 15:29:53 -0700
X-Gm-Features: AUfX_mzgu7kD5xmIyUYZ_YnVZsQj0adTFpMJoMddiEH4UKglz6_2Lo8CDB6wxAY
Message-ID: <CABpDEun3NPr7Na85pmOvdfYQ1DB-2nCcocsyDESXM15bzJU1og@mail.gmail.com>
Subject: Re: [PATCH v16 17/45] KVM: arm64: CCA: Tear down RTTs
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 6:45=E2=80=AFAM Steven Price <steven.price@arm.com> =
wrote:
> [...]
> +static void realm_unmap_stage2(struct kvm *kvm)
> +{
> +       struct realm *realm =3D &kvm->arch.realm;
> +
> +       lockdep_assert_held(&kvm->arch.config_lock);
> +
> +       if (realm->stage2_unmapped)
> +               return;
> +
> +       write_lock(&kvm->mmu_lock);
> +       kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
> +                              BIT(realm->ia_bits - 1), true);
> +       write_unlock(&kvm->mmu_lock);
> +
> +       realm->stage2_unmapped =3D true;
> +}
> +
> +int kvm_realm_teardown_stage2(struct kvm *kvm)
> +{
> +       lockdep_assert_held(&kvm->arch.config_lock);
> +
> +       realm_unmap_stage2(kvm);
> +       return realm_destroy_rtts(kvm);
> +}

Hi Steven,

I noticed a warning in dmesg when destroying a realm:

  [  158.533495] Call trace:
  [  158.535927]  kvm_destroy_realm+0x208/0x218
  [  158.540356]  kvm_arch_destroy_vm+0xc8/0xd8
  [  158.544439]  kvm_put_kvm+0x324/0x4b0
  [  158.548002]  kvm_vm_stats_release+0x1c/0x38

I traced this and found the following:

At this point, calling realm_destroy_rtts() may fail destroying the RTTs
because RECs are still active and the Realm is not terminated, but the
walk finishes and still sets realm->rtts_destroyed =3D true.

Later, kvm_destroy_realm() calls rmi_realm_terminate() and then calls
realm_destroy_rtts(kvm) again. But because realm->rtts_destroyed is already
set to true, it exits early without tearing down the RTTs.

Consequently, rmi_realm_destroy() is invoked while the RTT tables still
exist in RMM, which fails and triggers WARN_ON(rmi_realm_destroy).

The fix I used was to remove realm_destroy_rtts() from
kvm_realm_teardown_stage2():
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -434,7 +434,7 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
  lockdep_assert_held(&kvm->arch.config_lock);

  realm_unmap_stage2(kvm);
- return realm_destroy_rtts(kvm);
+ return 0;
 }

I think we don't need RTT destruction here as it will be handled cleanly in
kvm_destroy_realm() later.

Thanks,
Alper
