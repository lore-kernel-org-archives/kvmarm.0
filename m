Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86912518148;
	Tue, 29 Sep 2026 10:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790679184; cv=none; b=CmtGELTK9EgXRoA5BM2uqiJ+1njRdUk3zkbK7T54OU0+751o0KAAuI4IHV4flpllAouQa/pNvJ4o+RorT2z1DIqBQg9Fl+uGVHP2fwnz+wIgvGIvMrFlS9a4mly1uUfNDF3Y3ueA+EkG+ErSn9R89KZhDoN6VOxkTOtbUFrojNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790679184; c=relaxed/simple;
	bh=/qXfc2PyXlmCFAbb81VSUKjPWUvH0mHQzbUqFXTq6nA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bI8vWERuXcBP6YO4twax+H4qeG2ocWwQEGdQpLmB+203QT4D59nzw2kMCXFVTBHTeiHUY59Ukp5XZLUXwIH2XIf0hLD93PFJ6fLetZPPO+DYEFGLZ6K0UBm9xJBIDkuTGT4817QKwllkYgHer+Yt08aKm7mqcW73nShvBGRnK58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnpmvC2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnpmvC2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2031F000FF;
	Tue, 29 Sep 2026 10:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790679173;
	bh=qcvb+HcDFBPgFiYCSFMpPsOjJNWfSEvLog2yvY4plsE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZnpmvC2DNT6WCfmdUkhUBs5rMzAVpikQIPO8fAjHGRzmxxW02u6R9+2sB3++8vrXm
	 tPr5P2YoJn7Ss7uigQralhDUmpICMzT9WUIFzhhA7IekWPy3ghb26ISo4DzF35J75r
	 UTaVKEsL99+2yMBAc0gsngT0dVgy/B3poWa3Jr7vMGkj8cqQlcB+q026jCg/zCULLM
	 rceRcF+h4XEh2Nva/JgU99IZmfjQM3BD1D8egACbA5UPaz94AvIyGUDK9eo20aTtC5
	 GhI4+sSKbce98KU35aBVDv+x9lxqt07Uuf/Zffs8uFkFVBK+9bLWSJaiHIk1jxavKu
	 mRru3aixVg+sA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/15] KVM: Add kvm_arch_dirty_ring_size_updated()
 hook
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260929103655.85107-11-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-11-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 10:52:52 +0000
Message-Id: <20260929105253.0A2031F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kvm: missing kvm_arch_dirty_ring_size_updated() stub causes build f=
ailure
--

commit 78c5608c44701deb8c1679c3f53cbd1303655474
Author: Tian Zheng <zhengtian10@huawei.com>

KVM: Add kvm_arch_dirty_ring_size_updated() hook

This commit adds a kvm_arch_dirty_ring_size_updated() hook called right
after kvm->dirty_ring_size is recorded. It provides a weak no-op default
implementation for architectures to override.

> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_rin=
g.h
> index eb10d87adf7d5..c2b922791530d 100644
> --- a/include/linux/kvm_dirty_ring.h
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -73,6 +73,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty=
_ring *ring)
>  #else /* CONFIG_HAVE_KVM_DIRTY_RING */
> =20
>  int kvm_cpu_dirty_log_size(struct kvm *kvm);
> +void kvm_arch_dirty_ring_size_updated(struct kvm *kvm);

[Severity: Low]
Does this cause a build failure on architectures that do not define
CONFIG_HAVE_KVM_DIRTY_RING?

The prototype is placed inside the #else block (when the feature is
enabled), but there is no static inline stub provided in the #ifndef
block. Furthermore, virt/kvm/dirty_ring.c (which contains the weak
definition) is not linked when the config is disabled.

[ ... ]

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 85f42289748dc..d109062f6a1cf 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5011,6 +5011,7 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struc=
t kvm *kvm, u32 size)
>  		r =3D -EINVAL;
>  	} else {
>  		kvm->dirty_ring_size =3D size;
> +		kvm_arch_dirty_ring_size_updated(kvm);
>  		r =3D 0;
>  	}

[Severity: Low]
Since kvm_vm_ioctl_enable_dirty_log_ring() is unconditionally compiled,
will calling kvm_arch_dirty_ring_size_updated() here trigger an implicit
function declaration and link error on architectures like s390x or powerpc
that do not enable the dirty ring?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929103655.8510=
7-1-zhengtian10@huawei.com?part=3D10
