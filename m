Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135E140BCA3;
	Tue, 14 Jul 2026 09:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022003; cv=none; b=l/NopgXVwhucjlBPoo6y+nVOimcfXVcOAH+bmr2zywryMQOU2nsW9Gc2iuE5JMq/PCVaFLiqil/yHe4Hdl49rTHy8yQeXtxidW+40OGiTGGZMENHISHs07OYzkltI2kGS2CKQzOBWM5J7xbAGyh5KIxvtf/pRjvSspbuntud97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022003; c=relaxed/simple;
	bh=0F2lM0vNLU3BidXj9qFg40c/IWPjGIAqVSK66SHlTXw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GsZ8QvhhZLBNRcu/p3KO2xpvk4x1WjF5O390cmgCUJiLqRFnisVwpddM9jaOimhW7/8mghagc4Xy/JnpdtWzCYxHJhPrUVx9kimM0mEyX/KgKDyjLoU+ZVf3mgN+LbFx7t/HOMxPdhXHlk0R8H/5K7360FFyay1H81sh/rvk8AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgSFqtqD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgSFqtqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676121F000E9;
	Tue, 14 Jul 2026 09:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784022001;
	bh=m3ZlOarnCUYySgNYJGObdSxi/jYgX0xTdWMXQZI+jGA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QgSFqtqDAuOr79pmpyrd3CFMPBrXT1BfG9I0/NtxEaiRYL7kL4uNuHMAZwowmYeNI
	 5AUGgXbYreEJ1kj/t9EKDqmYr+97iQgMFlpu2fW01iPwwPdXOmRa7nQLqoKLRnQHLK
	 4ZBVBkEale/gmohv8Z5D1X4TIEH+7QeTZKaCuMJz3pNfwd5f3m8Q0/TTRTbZu88p1e
	 5qKxd8mEGc12MfbNnNhSvPdL33oY9rrrybWYqWhN+eQSyOO90+lU+0lt0hhxFV5cKY
	 pcwWe/1N/bs5o0yaC35U4uCLazs6VshmuTKjH1wOTPe2B8k5/WRKP7SJcoBWPv4LsP
	 f42xrQmfTHpXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/28] arm64: Add ARM64_HAS_NV3 capability
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260714091641.1970822-16-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-16-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 09:40:00 +0000
Message-Id: <20260714094001.676121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The newly added ARM64_HAS_NV3 capability lacks the required hard=
ware detection logic, rendering it non-functional.
--

--- Patch [15]: [PATCH v2 15/28] arm64: Add ARM64_HAS_NV3 capability ---
commit 99ad2a0b713bc6373d924541643c7d6b05f45704
Author: Marc Zyngier <maz@kernel.org>

arm64: Add ARM64_HAS_NV3 capability

This commit adds the ARM64_HAS_NV3 capability ID to the cpucaps list. It is
intended to describe host support for FEAT_NV3 so that upcoming KVM code can
depend on it being detected.

> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 242dc211d8efa..7e0414509e89a 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -52,6 +52,7 @@ HAS_LSUI
>  HAS_MOPS
>  HAS_NESTED_VIRT
>  HAS_NV2P1
> +HAS_NV3

[Severity: Medium]
Does this capability require a corresponding detection entry in the
arm64_features array located in arch/arm64/kernel/cpufeature.c?

Without an entry in the arm64_features array to perform the hardware
evaluation, the pointer in cpucap_ptrs for ARM64_HAS_NV3 remains NULL.=20
Could this cause any subsequent code checking this capability to always
receive false, even on capable hardware?

>  HAS_BBML2_NOABORT
>  HAS_PAN
>  HAS_PMUV3

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D15
