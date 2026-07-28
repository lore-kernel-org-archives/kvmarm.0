Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC4431487;
	Tue, 28 Jul 2026 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241367; cv=none; b=f3mQVnnwfOnY+8jGRbjKL5uJtCuozaPVAE35dMOU9721shwLauYwu3ijxPw7XEAcMONh2W7ungBfXDIgHEMhf/HwD/nldMD9AnLwD6AV38tcoAl5xHTjSWAy7aSzY/qol6qENaO3Xs6mNPhY6nmdTLnAH06grJ3y5+OSRmkHnOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241367; c=relaxed/simple;
	bh=dEnloA7E5jTUYnZnh7xblpGM92rAmq0drWYR9wUSXDg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kX/pkwLyYSniVhyyuXHvQAvkBjeLD5NmT9cxGk3eJUozjZbZQ/5OPuOgtcmt1cIOYyp41aR0yy7x2mjrkdsRpuNJpulmwyp+ZheZwfUb4vYcKqw513yIU4luXtGdVA9YgRFDomDYVtpLVwxAvHJkKoP0S0iay80alX9alRviWDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oP6bB53R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oP6bB53R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA83D1F000E9;
	Tue, 28 Jul 2026 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241366;
	bh=xST1UwT13aVIR2+zyzBZOokfH3DdRIIO5yz4+VqFFFI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oP6bB53RbC8lLQq4mPdB7ODyQjxL7sVJERQ3BC33Qr6Von4mSkcQiDnWfzbJP0d6s
	 fk/V0iNsSSNXyhVJ2Ctm0W62Mau+gR18phRXTbuzvB3JEx+4owTDyOlZ3O3lrU2jGB
	 cpZhQklgXIiWtwdc2wEtehqXP/OmEy0koAMB3dF7Cm53uWXp654nPQy6dw3ZYKmoRV
	 injq0tI5n1eZWqq5mO5Cvi5ZFLBd1W/LF89clMTbLidU1jWbKfL3ia4ChlrL2WVBiJ
	 aHqbqDToj+ygj/sGBLbfNfY6wzPn3aio9OMLsNq2i9NRzTxYrNhoiLlS5LtHsn/H6n
	 +Q/0NAjuJcqvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config
 option
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260728121138.1103610-2-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-2-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 12:22:45 +0000
Message-Id: <20260728122245.AA83D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch introduces the `LIVEUPDATE_GUEST_MEMFD` Kconfig option=
 claiming to enable a new feature, but there is no actual implementation pr=
ovided.
--

--- Patch [1]: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD conf=
ig option ---
commit e0c3fde657d56c548cd9a7467d2143f0f42c5242
Author: Tarun Sahu <tarunsahu@google.com>

liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option

This commit introduces the LIVEUPDATE_GUEST_MEMFD Kconfig option, which aims
to enable live update support for KVM guest_memfd files.

> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index 1a8513f16ef7c..0bbc4037192e9 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -88,4 +88,19 @@ config LIVEUPDATE_MEMFD
> =20
>  	  If unsure, say N.
> =20
> +config LIVEUPDATE_GUEST_MEMFD
> +	bool "Live update support for guest_memfd"
> +	depends on LIVEUPDATE
> +	depends on KVM_GUEST_MEMFD
> +	default LIVEUPDATE

[Severity: Medium]
Is the implementation for this feature missing from this patch?

The commit message notes that this patch enables live update support for KVM
guest_memfd files, but the newly added LIVEUPDATE_GUEST_MEMFD symbol appears
to be unreferenced in the tree. Since there are no Makefiles, C files, or
preprocessor checks that use it, this currently acts as dead code.

Could the implementation be missing, or was this intended to be introduced =
as
part of a larger series where the symbol is used in a subsequent patch?

> +	help
> +	  Enable live update support for KVM guest_memfd files. This allows
> +	  preserving VM Memory backed by guest_memfd file across kernel live
> +	  updates.
> +
> +	  This can only be used for the guest_memfd that are fully-shared
> +	  and pre-faulted.
> +
> +	  If unsure, say N.
> +
>  endmenu

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.1103=
610-1-tarunsahu@google.com?part=3D1
