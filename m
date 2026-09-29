Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FB44E3247;
	Tue, 29 Sep 2026 22:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720922; cv=none; b=Y860OvM5U+2Hid3xetzTJtJ5j5LFVNtA0qPoQWgMYj37MnTu9vSSlVphNn84wi/qu05ZJZxBWg/VX2RwOhB5uazDmqxYUDP0EKYXk0zp3WZsAHT/6UA4LeTduJeWdh150YuvRBhH0hvhOkuhwpkHmePwgqdZ1tf68Y70LESNkI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720922; c=relaxed/simple;
	bh=z1RhF0vs0PnCABZd+15W6668NXbAsDKBVOHHsVTFTIQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bQczolKLCQ6Q5pIkGRddPl1SapwZY9GuZOWO+YMAje+o83S+74QV/4OzAOyLu46Zpj4o5GspwQsxllCKgK35wpN4eBZBbbyMSm3Q4xw1xA7mP3I7AxxelBR9NUYRiTrc3eEazPDBquL9XJ0Sb4TxUbqogWXDgvtMNdB3fh9pQdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8jOmKqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8jOmKqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E821F000FF;
	Tue, 29 Sep 2026 22:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790720921;
	bh=cW7tI+XjZiqKfk5S4nvHgKT9oWSEemJ2TqsYJLSaLLk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I8jOmKqZ55Eo/cXOMgQHj1/OVDV5zBKnTrxuBIUUs1hWCwhnAKXfxz3E1IFRfro4X
	 XNAXiwoYPHOai6KGOQr9RT3G2yR/jkaiS94Pw0vgMYlMHk1IjLuPn8W2X+125w3ZSO
	 Pl2TAjQCjCw5OGiFw3cXPWNl5I7rf17kGOD9txlOI+jYl8KdsiJLIqNgOM1mSnPqQx
	 3roQNjIgCiQzMgjRu46He/BXeXNFCc3eHwpPc8poY9IchMXMnV+/2nCIC8d8NZJLc4
	 bJyw+MK7hKLwZ151J+USknULsFILw100A2SHWX30ZQPLGhIh2dbxNC/KagA6OYKAdG
	 i8rnbVVaYKaEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 2/9] firmware: arm_rmm: Check for RMI support at
 init
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260929221623.1342076-3-suzuki.poulose@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-3-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 22:28:40 +0000
Message-Id: <20260929222840.A0E821F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] arm_rmm: unbounded spin loop on RMI_BUSY without scheduling
- [Medium] arm_rmm: commit message and code mismatch on feature registers c=
ount
--

commit 5ddd90a4b6dcf005d84ebc9f9003eb3f383394f8
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Check for RMI support at init

This commit queries the RMI version to ensure compatibility and reads
feature registers from the Realm Management Monitor (RMM). It also exposes
these feature registers for future use.

> The first two feature registers are read and exposed for future code to
> use.

[Severity: Medium]
Is this description accurate? The commit message explicitly claims that the
first two feature registers are read, whereas the actual implementation in
rmi_read_features() iterates over ARRAY_SIZE(rmi_feat_reg_cache) (which is
5) to read all 5 feature registers. This looks like the commit message
might have missed the v19 code change.

> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> new file mode 100644
> index 0000000000000..911489b636522
> --- /dev/null
> +++ b/include/linux/arm-rmi-cmds.h
[ ... ]
> +static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
> +{
> +	struct arm_smccc_1_2_regs args =3D *regs;
> +	long status;
> +	int i =3D 0;
> +
> +	while (i < RMM_BLOCKED_RETRY_COUNT) {
> +		arm_smccc_1_2_invoke(&args, regs);
> +
> +		status =3D RMI_RESULT_STATUS(regs->a0);
> +		if (status !=3D RMI_BUSY && status !=3D RMI_BLOCKED)
> +			break;
> +		if (status =3D=3D RMI_BLOCKED)
> +			i++;
> +		cpu_relax();
> +	}

[Severity: High]
Does this sequence create an unbounded spin loop if the firmware continuous=
ly=20
returns RMI_BUSY?=20

If the status returned by arm_smccc_1_2_invoke() is RMI_BUSY, the loop=20
continues without incrementing the exit counter i. It issues cpu_relax()=20
but does not yield the CPU (e.g., via cond_resched()) or impose a timeout.=
=20
If the RMM firmware remains busy, this could cause the host kernel to lock=
=20
up indefinitely.

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929221623.1342=
076-1-suzuki.poulose@arm.com?part=3D2
