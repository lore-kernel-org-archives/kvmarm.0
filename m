Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C7543302F;
	Tue, 28 Jul 2026 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241616; cv=none; b=ouM9ljqu5Gd33D2FWrJNMTi53OOlCj8dJPsNFYLo2hPStuBF93UNw6mPus0K1aA28/8swzaKruE+VFTX5lueRHRfbwGW22NqvulN1ew1xUeaYWowmYXOEJgC22YPkUKNAPcQRaWXhKC9PwITFtpEz1GgMfk5QoHuex7sbpOrg3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241616; c=relaxed/simple;
	bh=tZfZhJYPuL+/zXJtBT2TnUVBpVg5xe/1E7QlUVIztVo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dz/sUgoBqHMUpRjjpADEDehKT9WdPux0rGq06EKdiO3FNtup/2vTcec+r6EEPL0l4P+VQv69vWj2nljHQR0gK7oMSZv1sEmWiV4LoH5VUyoBjz89jcDQfctWk08dlazrxa6CGdb1eOxG4iYh6xhe8YQvtKsIhgTaqBiQzfxQUQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fk+kO1js; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fk+kO1js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C791F00A3A;
	Tue, 28 Jul 2026 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241615;
	bh=KOqRFhZ94d+a5N/NKhmq6af4N+jAeZwxfV20Yix4Nxo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fk+kO1jspGrJ6DqeaHY6nD2HU7jpY3rlpOeKP8tp3Cqm+DsSWJvoS4uXCPoN5PxHG
	 Pd44KQoKexeOk5CiHUVTWt9HOi+FsIiaHDchzsm9WQ2f53mgWx30uADoyyCMaDbAtJ
	 Qw37uOPPP18ZZICISxOZ9sMSok/S5xRWz/CprBzhCqP3uN9ugUcxBEoCjdDqj7q709
	 gZq1bKmvhqR6lR786EpIf2fv4N8PCnsSHeWicOocCgCBQpWedFgKUkLXJBDNTm5mT4
	 AZUeYRbEWs0+GDgcrFLsXjHbZQjJbEyzcw+wMu+SrJBNdn/f00AsbxJATOYKK8DjuE
	 4UJ7r7aNHEbow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260728121138.1103610-4-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-4-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 12:26:54 +0000
Message-Id: <20260728122655.17C791F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch claims to export `kvm_uevent_notify_vm_create()` but fail=
s to include the `EXPORT_SYMBOL_GPL()` or `EXPORT_SYMBOL_FOR_KVM_INTERNAL()=
` macro.
--

--- Patch [3]: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create() -=
--
commit 5e642ea16f0d267e622a352de60bfe397ecf79df
Author: Tarun Sahu <tarunsahu@google.com>

KVM: Export kvm_uevent_notify_vm_create()

This commit exposes the kvm_uevent_notify_vm_create function to allow
triggering KVM event notifications during VM creation.

[ ... ]

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -6348,6 +6348,11 @@ static void kvm_uevent_notify_change(unsigned int =
type, struct kvm *kvm)
>  	kfree(env);
>  }
> =20
> +void kvm_uevent_notify_vm_create(struct kvm *kvm)
> +{
> +	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
> +}

[Severity: Low]
The commit message mentions exporting this function, but is it missing an
EXPORT_SYMBOL_GPL or EXPORT_SYMBOL_FOR_KVM_INTERNAL declaration?

Without the macro, won't dynamically loaded architecture-specific modules
like kvm-intel.ko hit undefined symbol linking errors when they try to
call it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.1103=
610-1-tarunsahu@google.com?part=3D3
