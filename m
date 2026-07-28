Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C4A4334C2;
	Tue, 28 Jul 2026 12:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241661; cv=none; b=A3IGm8SqislDDwtRqKl2GrQyb2yotnFaxhlnMbuBjru3bJrV48AOA5HKOBhWA16EAYnEMD/v9+dbgCyaBTMYqUpc+9xPhHk/jCkiL44YYggu+a8e1eJJTjr7YjnFidvWoCfsOkltBYVzkAjvlFDqXjAtrzc7+cIpvzIUOMkj+9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241661; c=relaxed/simple;
	bh=u5qtvbqzclACB9103gW70ekiviwTTE2JHu66sreW2x0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BTCH8yOtOAvZDuaaP6VlYZr51wDs0V13eVodNEpu5wsy/fRH44t0GSjXsigXrI17JfboAqLOTndfEanpcT47l/1Yw4ZfVvdLyUmwrmar+Ad0Rh8VruiAuadUubt9F0Jipxv7TcSBZJPeFV9lWU2+5ETH5OB54clGOlz8ujHy5DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbMwjxhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbMwjxhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE2B1F00A3A;
	Tue, 28 Jul 2026 12:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241658;
	bh=8my5GMWJ4ncVz0ymvGfpX8xXOyjalo4X3Eo81mnzPa4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bbMwjxhqgAvn9jbbxXCKL5AtxiHYzquu4iL4PodxR6NaHihlaIHLGQGj+fjEmIzQu
	 LD2Di/8pqyvEzq7qvZjPYEDylCAK7f7qexRuwlmaCaALnvTYO9QP9FWK37mlaNQRnb
	 vt+voVR8UoRZuDB0W78hcls6Cw56KeT3eAKEJ1nbum435+IJdCokI9OO507w/n+M7T
	 XwXgZA4F4xfTwcyGhrpP9KDGCMD4WtVKGOP6H1A6zcasv8cOHqWqWFhvW1t1vVEjcv
	 BV1L2cNdWNgiTE097x2jcJGsE8OXHvN1GH1DNf1o9RT+PJq2noaUpN4aow7JrQYJQ+
	 A3Yz+cDuDD4fA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live
 updates
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260728121138.1103610-6-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 12:27:37 +0000
Message-Id: <20260728122737.CDE2B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The generated `fdname` for a restored VM can collide with the fi=
le descriptor of a newly created VM in the same process, causing `debugfs` =
directory creation to fail silently for the new VM.
- [Low] The MAINTAINERS file was not updated to include the new ABI header =
`include/linux/kho/abi/kvm.h`, contrary to the commit message.
--

--- Patch [5]: [PATCH v4 05/11] KVM: LUO: Support VM preservation across li=
ve updates ---
commit 650c9d9cd02da64dbc0cdbd5b8073f5b00dadf99
Author: Tarun Sahu <tarunsahu@google.com>

KVM: LUO: Support VM preservation across live updates

Register a Live Update Orchestrator (LUO) file handler for KVM VM files to
serialize and deserialize VM state across kexec live updates. Preserves VM
type and recreates the KVM VM file during retrieval with an internally
generated fdname.

> Also updates MAINTAINERS to include virt/kvm/kvm_luo.c and
> include/linux/kho/abi/kvm.h.

[Severity: Low]
This isn't a bug, but the commit message states that the MAINTAINERS file
is updated to include include/linux/kho/abi/kvm.h, but the diff only
adds virt/kvm/kvm_luo.c. Should the header file be added to the KVM LIVE
UPDATE section?

> diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
> new file mode 100644
> index 0000000000000..025b53151b6a0
> --- /dev/null
> +++ b/virt/kvm/kvm_luo.c

[ ... ]

> +static atomic_t restored_vm_id =3D ATOMIC_INIT(0);
> +
> +static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
> +{
> +	char fdname[ITOA_MAX_LEN + 1];
> +	struct kvm_luo_ser *ser;
> +	struct file *file;
> +	struct kvm *kvm;
> +	int err =3D 0;
> +
> +	if (!args->serialized_data)
> +		return -EINVAL;
> +
> +	ser =3D phys_to_virt(args->serialized_data);
> +
> +	snprintf(fdname, sizeof(fdname), "%d",
> +		 atomic_inc_return(&restored_vm_id));

[Severity: Medium]
Could this generated fdname format collide with the file descriptor of a ne=
wly
created VM in the same process?

Since this uses a simple "%d" format based on a global restored_vm_id count=
er,
it shares the identical naming format as normal VM file descriptors.

If a process restores VMs using LUO and then creates a new VM that happens =
to
get assigned a file descriptor matching one of the restored VM IDs, would t=
he
debugfs directory creation for the new VM fail silently and result in missi=
ng
VM stats?

> +
> +	file =3D kvm_create_vm_file(ser->type, fdname);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.1103=
610-1-tarunsahu@google.com?part=3D5
