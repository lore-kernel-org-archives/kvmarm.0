Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E91739182F;
	Wed, 15 Jul 2026 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126286; cv=none; b=X40VSfJhzSIxfaYdUkeZCyNJBLzvYK1lvY3TiWkyRFpGzCegYJslCKI80PVOXc2qxSQoNyUPBnLa+cIqJF5U6ZCOVBkqQM/N82rLllHjmwAQ2ht9fAZ+MZNVV+nw988fOFGN0a5IBH72n5gbZse9SGVt6yEfQmlTOOj6teb4epQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126286; c=relaxed/simple;
	bh=9aJAXcchJ+rfE/kpIHbVZ9K/PIeoh4HZqadIKM5TZgk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MbhDwAudFPDmYElkDM97cawPF4K79JCGExJvCRtpGoaynU5zh9Ui4aY5PH5b5Lu9Dl3WrNPVXxFCoIlFOMlhyEVZZqeMNmUa0eJdSXvrcHxIFD49ZERsUFhSnXjD0GDV4U4T/mvmKkGms1tyZGbXHo6nRQI8S8a5OutgjE2X/UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gfbsuczh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gfbsuczh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDF41F000E9;
	Wed, 15 Jul 2026 14:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784126285;
	bh=haHzTa+1fgT3vzs6VVQ/iPu/MW28WXGQBU/ZPKrQRtQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GfbsuczhuAHAzcnmjR63XqP+D2Eq5GfXqgWE6Ep23IJNwTQDmHagAYc2LYfX+hgO2
	 21W4+JUxn88IoedTbAK8FyQpcT89si0pxrLf/HayUDwDQigh1TXrJVcg2GE1O/IlOh
	 2uzeYeRLe8TzgcE3nGZEPxjWCL8xc6RWxrwa2CtsWWsqm8Mbemf8IyrdAoFDxZEEKb
	 Dzm8hp2/VjLyUGu5qOgF89J8HGEkS2ixIiOTVmZZJxuQM1QQLtUWZqLkqwIgrmzjPR
	 ilV+XdlnG3g8hCsMqqREUIO8uGsvTGJlemYW4m1GDtVUgsZpCNAlyDrJS1MC1kFhXJ
	 1yMbuMtSV7UIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/6] firmware: arm_rmm: Add SMC definitions for calling
 the RMM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260715142739.80398-2-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-2-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 14:38:04 +0000
Message-Id: <20260715143804.ADDF41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] `struct rec_exit` contains 4 bytes of implicit compiler padding bet=
ween `padding9` and `plane`.
- [Low] Discrepancy between the `PROT_MAP` macro prefix and the `DATA_MAP` =
comment and SMC command name.
--

--- Patch [1]: [PATCH 1/6] firmware: arm_rmm: Add SMC definitions for calli=
ng the RMM ---
commit c161f24da1669945cb4dc961f3a3c4ef452450b6
Author: Steven Price <steven.price@arm.com>
firmware: arm_rmm: Add SMC definitions for calling the RMM

The RMM (Realm Management Monitor) provides functionality that can be
accessed by SMC calls from the host.

> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
> new file mode 100644
> index 0000000000000..c965e8867518f
> --- /dev/null
> +++ b/include/linux/arm-smccc-rmi.h

[ ... ]

> +	union { /* 0x600 */
> +		struct {
> +			u16 imm;
> +			u16 padding9;
> +			u64 plane;

[Severity: Low]
Does this struct layout contain implicit padding? The sequence of two u16
fields followed by a u64 field forces the compiler to inject 4 bytes of
padding to align the plane field to an 8-byte boundary. While deterministic
on ARM64, implicit padding in ABI structures shared with firmware is usually
avoided. Should an explicit 32-bit padding field be added here?

> +		};
> +		u8 padding6[0x100];
> +	};

[ ... ]

> +/* RMI_RTT_DATA_MAP_FLAGS definitions */
> +#define RMI_RTT_PROT_MAP_FLAGS_OADDR_TYPE	GENMASK(1, 0)
> +#define RMI_RTT_PROT_MAP_FLAGS_LIST_COUNT	GENMASK(15, 2)

[Severity: Low]
This isn't a bug, but there seems to be a naming discrepancy. The comment
mentions RMI_RTT_DATA_MAP_FLAGS, which corresponds to the
SMC_RMI_RTT_DATA_MAP command, but the macros are prefixed with
RMI_RTT_PROT_MAP_FLAGS. Should these macros use the DATA_MAP prefix instead?

> +
> +/* S2AP Direct Encodings, used in RMI_RTT_UNPROT_MAP_FLAGS_S2AP */
> +#define RMI_S2AP_DIRECT_WRITE			BIT(0)
> +#define RMI_S2AP_DIRECT_READ			BIT(1)
> +
> +#endif /* __LINUX_ARM_SMCCC_RMI_H_ */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715142739.8039=
8-1-steven.price@arm.com?part=3D1
