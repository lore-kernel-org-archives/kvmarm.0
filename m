Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B76B492E57
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855779; cv=none; b=nkAfoEuRsVr9GVKg8/yGSlrm5jT7IERtTZLZBcPRNghjTs5Qn62v3PUsCdO1JpFWZ5vMD4jN2HcfNd1NF/BNh/Mu0gQW1VlSkgdLg1bqak9sp515Mn4IX9IcgSSccnL+0HEcR8UYtp68H4Y4gOJ5L5f/lS/iV6sKNF+986UiSUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855779; c=relaxed/simple;
	bh=DlCIAe4lN3Ywg/jZ531L+1dOwy/LVKOYm6dgV2tOXpE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VGZyncy6MRPdhmun0s84ZaSSQTqSo9c5LLgEHm/iSmfneGgl9OdZl8ppTb5g2cxSbdUVjuBtYMY6Xh41LwHrDObFhqDCbcMbNzfzTGB/THvMk+xc++kc5lhIZzGj8mcdw6Eiz+1Wf0BMccTD3c7qXKSb4oRy1DbBANRGweHPVGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6MXDyN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6MXDyN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F9F1F0089A;
	Thu,  1 Oct 2026 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855774;
	bh=0LMk0kxZg+A1N3k26V4n/1tM78ztN08O9jDun9Ut/QI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j6MXDyN1lL6lgjvxqxnEP3GDXn/ysHIECV+RQcck4xX47duZxms+K+cLKFaBqdL4N
	 VU4O9LBYKbdCK1RnZTdWXXFx/JMx4g1+lzGhlmcM6zlqOxRysAavn0x/Zx5siyf3yf
	 1q+7cyMMzwPfg9U8zmtqZgh4CKj7Me1rqeNDI6SAkRK92QFdkrE2J+Fd6ZdzQlJqnV
	 kQY/KC2eaQWFnyYtBAlW7G00hVC6qMVd0DyV67assc5Bt4+GE+Tel99mUlWxifGvGh
	 SORDzj+MpbvyCie6n/CnhqpuJtXSg7OBaYdrKsSFT5J++zxTMf0CAnxWNLshC5lQfO
	 hxvMO83aRfh6Q==
From: sashiko-bot@kernel.org
Subject: Re: [RFC 05/12] ACPICA: Add TLBI table definition
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S3Jpc3RpbmEgTWFydMWhZW5rbw==?= <kristina.martsenko@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261001110655.461473-6-kristina.martsenko@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-6-kristina.martsenko@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 11:56:14 +0000
Message-Id: <20261001115614.82F9F1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] acpi: direct modification of upstream ACPICA headers with draft =
specs
- [Medium] kvm: arm64: HCRX_EL2.FNB bit is not filtered for nested hypervis=
ors
--

commit 1c073d3327bf45ba56b8ee1d936edd5e15ec68be
Author: Kristina Mart=C5=A1enko <kristina.martsenko@arm.com>

ACPICA: Add TLBI table definition

This commit adds the definition of the new Arm TLBI ACPI table to the global
acpica headers. The table is noted as an initial proposal that is not yet
public and may change.

> diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
> index baef525367b5c..68849c9f7cf69 100644
> --- a/include/acpi/actbl2.h
> +++ b/include/acpi/actbl2.h
> @@ -61,6 +61,7 @@
>  #define ACPI_SIG_SVKL           "SVKL"	/* Storage Volume Key Location Ta=
ble */
>  #define ACPI_SIG_SWFT           "SWFT"	/* SoundWire File Table */
>  #define ACPI_SIG_TDEL           "TDEL"	/* TD Event Log Table */
> +#define ACPI_SIG_TLBI           "TLBI"	/* TLB Invalidate Domain Table */
                                   ^^^^

[Severity: Medium]
Is it appropriate to introduce a draft, non-final table signature directly =
into
the global upstream-maintained acpica headers?

The commit message explicitly notes this patch should not be merged as is
because the TLBI table description is not yet public and may change. Merging
draft specifications creates a risk of dead uapi and compatibility issues if
the final specification differs.

[ ... ]

> @@ -3701,6 +3702,37 @@ struct acpi_table_tdel {
>  	u64 log_area_start_address;
>  };
> =20
> +/***********************************************************************=
********
> + *
> + * TLBI - TLBI Domain Table
> + *
> + ***********************************************************************=
*******/
> +
> +struct acpi_table_tlbi {
> +	struct acpi_table_header header;
> +	u32 domain_count;
> +	u32 domains_offset;
> +};

[Severity: Medium]
Is it acceptable to add a Linux-specific out-of-tree structure definition t=
o an
upstream-maintained acpica file?

The acpica headers are maintained upstream, and Linux kernel policy typical=
ly
requires changes to first be accepted by the acpica project before being sy=
nced
to the Linux tree.

commit cb4c50a2ac546f3127893846943d61a1ea5cc49e
Author: Kristina Mart=C5=A1enko <kristina.martsenko@arm.com>

KVM: arm64: Hide TLBID from guest sysregs

This commit hides TLBID system registers and fields from the guest to preve=
nt
them from discovering domains. It reports the feature as unsupported and
sanitizes a nested hypervisor's HCRX register bits.

>   * Sanitize a nested hypervisor's HCRX.{VTLBIDEn,VTLBIDOSEn,FNB}.

[Severity: Medium]
The commit message claims to sanitize the guest's HCRX_EL2.FNB bit, but it
appears HCRX_EL2_FNB is omitted from NV_HCRX_GUEST_EXCLUDE:

arch/arm64/kvm/hyp/include/hyp/switch.h:
#define NV_HCRX_GUEST_EXCLUDE	(HCRX_EL2_TMEA	    | HCRX_EL2_PTTWI	| \
				 HCRX_EL2_EnIDCP128 | HCRX_EL2_VTLBIDEn	| \
				 HCRX_EL2_VTLBIDOSEn)

Because HCRX_EL2 is a VNCR-backed register, a nested guest hypervisor (L1) =
can
write to it directly in memory without trapping. During context switch, KVM
reads the guest's HCRX_EL2 from the VNCR page and masks it with
~NV_HCRX_GUEST_EXCLUDE.

Since FNB is not excluded, will KVM apply the guest's FNB bit to the physic=
al
HCRX_EL2 register, breaking the virtualization boundary?

The impact appears to be limited to the guest's own TLBI coherence.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001110655.4614=
73-1-kristina.martsenko@arm.com?part=3D5
