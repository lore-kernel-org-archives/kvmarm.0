Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795476739;
	b=cEDRzZX35cif9hyEglquyClOScqRUvxKX/0X96tsC9/IKwTgSeoywNqA3cPlmGPLnek1
	 PtrnfNmTqhwhm64JaWRrsuMv16MWjMIvL8gDq85zPCOA1Z0CXSycaI0IyEnUEZJxtCRVG
	 yf7G7G1M2tF3brDSMe/Pas/vIyyo5j2qJR8gTgYS7E4wL0ZOLcubFPV7jjNVRx0mLpRUJ
	 EBmEoTF5HE9DoXSBf7y4F91uKe5q7AmgtfOIlraNAYgxcMxGE0OInUHwmASGtfyL6QxZc
	 zXYZ4fFsCgOvBUmYipX5X7Q1Gzj4Qs5DplnNE62d3nh4gt2SF5lKNzdwxmwf1QKJcDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795476739;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p2ZKC1QFeR/1HgUOsmgqd18a9gAL3iFEjKlpTYV0FRs=;
	b=NsqMcywovxFcf9M33EpInWMYlV87mpN2piCQxvR9Atyb3pngZnHY50P7WRLxaH2/B/QG
	 KWsmh1ZX4kohWl5jJyuzzDiX7FtTXXIKRgZw+i4C/3kBvf5zmhCpJvcF4SZIlNWoVSTFi
	 L8V9ZBc9GF64t3BSJEqQ7uGRuldKfY8K0cZasBbaTVxHUlC6M7QP0ulelMU8g58S9fh24
	 wUHqnP+BTWC6x4Mc0+dlhXJP5NfP/LWFFD7yF7trnV1gk4W1wDo4hlsODXNhbPJQdov9G
	 1hD4ht5m5B71IEdc2I+ThtB7f5u00aKMjEeiegpKIJzAGpL1e998x177uj3lgGLHRcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ajz8lhzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3091A606A327;
	Mon, 23 Nov 2026 23:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ajz8lhzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7667A1F000D4;
	Mon, 23 Nov 2026 23:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795476738;
	bh=p2ZKC1QFeR/1HgUOsmgqd18a9gAL3iFEjKlpTYV0FRs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ajz8lhzyWjZtFjP4/O2QqpuAkDRBmtpzQ0+XEm7XyQD8myN0b1mIrCzFzuwGk2IlH
	 pSOMp4joiio/iZVIm2K0dz0v3AFd+D+0OcrWxppnBgyYHmTNgiAkJAPqhNuyvNBzco
	 j5YavBdsZHeDGqLdbddOmJyLDZDqEr2zJXK+CocAWVQgtvOLYjAoVYrxuWc92neijW
	 pRQ7EdmyLx0Z68/Pa0hcmP8jDRsb4g7dOoktMc1PFZ6TIutU5z1lXywqufYDep3piM
	 WfUoQ5/6qXDaFdnaBwE6w0R+f+M9ZnJaQMdZntYD7cSRGqFDDxVrzBBvxr4L30ey8Y
	 kxpFbFuXqPYEw==
Message-ID: <sashiko-outbox-230210@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: nv: Avoid duplicate guest stage-2
 mapping entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261123232647.3733149-3-coltonlewis@google.com>
References: <20261123232647.3733149-1-coltonlewis@google.com>
 <20261123232647.3733149-3-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 23:32:18 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: arm64: nv: missing Fixes trailer for
  kvm_record_guest_s2_mapping() leak
--

commit 948b2b35956480d91765ab46d7a685fc1f8ebecc
Author: Colton Lewis <coltonlewis@google.com>

> KVM: arm64: nv: Avoid duplicate guest stage-2 mapping entries
>
> kvm_record_guest_s2_mapping() unconditionally inserts a new entry into
> both guest_s2_mappings interval trees. Parallel stage-2 faults on the
> same IPA or retries after -EAGAIN can therefore insert identical
> entries for the same nested and canonical IPA range.
>
> Check mmu->guest_s2_mappings under guest_s2_tracking_lock before
> inserting, and free the new entry if an identical one is already
> present.
>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

[Severity: Low]
This fixes unconditional insertion in kvm_record_guest_s2_mapping().
Should the commit message include a Fixes tag:

  Fixes: c2778d14cd2f ("KVM: arm64: nv: Track guest stage-2 mapping creatio=
n")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123232647.3733=
149-1-coltonlewis@google.com?part=3D2
