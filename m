Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A784C6D;
	Sat, 29 Aug 2026 05:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787983090; cv=none; b=FUc5d2MtiA6y1O5eivD+cxvlJ+/LjfDcHAow1QbUu7ibohpnUTezeMmpk6nYyKzQek5HmB37ZXC0RxBNM4cu8guzxqWvT3JYiOeoPUzCJTI8Aowg2OpF1e1/o4tzJUNEPpGnD4Gh4XYRh2S2EwuJbORIZNyBTNFOyD9SBRjyHtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787983090; c=relaxed/simple;
	bh=MOsJ7PmXDjZ8py3Rjr8Pm7XqTBaeuDR6t1MyRWC+5so=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D0s//BRNcXImWcqYG/Ua6hQdyzCkkQKmw+kOUbGI4Hos4LY0v2YHN1BN1RckEhCPDSOewCFpX5j0/EmkueRoAdfKj6zhkUQUDFMhk0cfWWWywskhutoJS0nZCX/iKZE6KzQ6II2dGfs2V66bXLK6YU9Z2zvIp1VviOzEuiHSwxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmN/lr0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmN/lr0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AD31F000E9;
	Sat, 29 Aug 2026 05:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787983089;
	bh=IiGBd0JOvJrJtp4u+ir8NPI5sb9bulLUrxuIULn7zOg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bmN/lr0JIp4xeQRnylFLJlEmY0IhSwhBfDzUQyUpUoabzpUTKgdwFNb5sYxSWSrBO
	 a6G5YJ8PIPyaotzYxNAMWXp4ECZvuUH9M/LceMYo+8g8sEbs/lXNzDXT2zr6zhyZdI
	 onOjt/V1TFB1Wa72Arjz3Rwl1S4MaUnKRagXR6irIcsw8cdjpswqL8FkDXzL1HDulM
	 BlJBXJG4w0LfvdgC88CeI4DivnY2WAuS58EiXJi/eeg1Ro2qWrvdsvsJ+hkstVDVhg
	 duyAMYl1/NJDpRXSPPPkQHSuuS58hy8UYh2TNOddmkPoaJh+IsIqLcHPyy53OQh/kj
	 WSXnKB5tFkXag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Return -EINVAL for an empty SMCCC
 filter range at base 0
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260829054856.70549-2-kmehltretter@gmail.com>
References: <20260829054856.70549-1-kmehltretter@gmail.com>
 <20260829054856.70549-2-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 05:58:08 +0000
Message-Id: <20260829055809.29AD31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprivileged userspace-reachable WARN_ON_ONCE can be triggered by =
memory pressure, potentially causing a host panic.
--

commit 7eae467c4f77ea62fe7302656a7c43a21cc35eb0
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0

This commit fixes an issue where an empty SMCCC filter range at base 0
wraps around to U32_MAX, overlapping reserved ranges and incorrectly
returning -EEXIST. It explicitly rejects a zero function count instead.

> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index b11b8821c9fbc..dfa25bb6f25d4 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -185,7 +185,8 @@ static int kvm_smccc_set_filter(struct kvm *kvm, stru=
ct kvm_smccc_filter __user
>  	start =3D filter.base;
>  	end =3D start + filter.nr_functions - 1;
> =20
> -	if (end < start || filter.action >=3D NR_SMCCC_FILTER_ACTIONS)
> +	if (!filter.nr_functions || end < start ||
> +	    filter.action >=3D NR_SMCCC_FILTER_ACTIONS)
>  		return -EINVAL;
> =20
>  	mutex_lock(&kvm->arch.config_lock);

[Severity: High]
This isn't a bug introduced by this patch, but while looking at
kvm_smccc_set_filter(), is it possible for an unprivileged user to trigger
a kernel panic via the WARN_ON_ONCE lower down in this function?

A userspace process can call the KVM_ARM_VM_SMCCC_FILTER ioctl, which
requires /dev/kvm access. The kernel calls
kvm_smccc_filter_insert_reserved(), which in turn invokes
mtree_insert_range() with GFP_KERNEL_ACCOUNT.

If this maple tree node allocation fails due to memory pressure or cgroup
limits, it returns -ENOMEM.

The caller kvm_smccc_set_filter() then unconditionally executes the
warning check:

    if (!kvm_smccc_filter_configured(kvm)) {
            r =3D kvm_smccc_filter_insert_reserved(kvm);
            if (WARN_ON_ONCE(r))
                    goto out_unlock;
    }

Because KVM subsystem guidelines forbid host-userspace-reachable warnings,
could this lead to a host denial-of-service if panic_on_warn is enabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260829054856.7054=
9-1-kmehltretter@gmail.com?part=3D1
