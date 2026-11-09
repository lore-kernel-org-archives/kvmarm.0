Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214266;
	b=vAeojp0kaqcP8m1BauqAHW4GzJKnikiyAiRQkOUs6BYTmEstujvxgwyDrzGjgOThYR1I
	 rbxTZ56J1ZPFYDB3Al6str5KruqvwW88tM2dt/fLIWk7X+WkGSqsfcvEHugxhxkPSwd7v
	 ka0NpG2RqAR7+gCuB+62LBOBJhocBLrjbKpvcIPkexRG8iqLzpJ665JYsZA7QK++UFTkI
	 0GOCSrrUVbV6CvQoFOc48DDyqPtQG1PUFf0+41csFMm9j4Q6X7kfZL2KlflZv0VI9QEGH
	 qc9E+o8uiEb6A+Q1rtlN+PxTVEdFXNXMn692fMvkI8gtrApe/ojd2t9uJeuFsLfwsxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214266;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=wK3Kj9ggnG7kxPcgujmWtBo3WnCYjA2Q28UFcLisF6c=;
	b=MAm/vQu+yWf6n1i1IyaVi06/D3/5fJnDNiZERPQKtOQY4M3/VNs87xA0yT1JvgOV2ZQA
	 fU+aH7iL5OjfrWyXXjejak6Ygatm8KOKcYAiqlXowDv3nBwBl7VT6PbI1f4fLXZ0nvgAt
	 SC3UEDrwuNXnzKkZllEOyG7hCVFDOurrvfT4fXlNTGreJ7dlksiVAZwwHMXPVOZu+RIuq
	 gc9TaV01vg7wt3sWKemqhBQ82+1i2RA9xo5cO04WG1YriJM1d1mnhVixHPrOoE3EiXx4m
	 Wun9IKGF1f55J2AUqsk1vRwKOjA7IB4d4MKLyn0XNWRcjIWfQW0Ra/qqqKhZVFfPkqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Aelk5yEk;
	arc=none smtp.remote-ip=91.218.175.138
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9E360735DB
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:51:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C9E360735DB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Aelk5yEk
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=z1iR6/blDGadFjt4UJ120lWqA44OWbGZlUOQA5is+Kw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214264; v=1; x=1794819064;
 b=Aelk5yEkc00Lbm2K98coLlcnHb5AzGWx3TkPoyFoqKE5XOdGh6jyzySuzROwP8lrRoLIauNm
 +brJgg8xmz+geyDxYSPsDF/PYv3FRHV1hQ1Wha/xJs5rNnX8xUOaSU0WP3Ydp2j9m/fgzqPCQAk
 wjoy33cDkD61DnQDkl548d6I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cae2898a0ac8bf14;
	Mon, 09 Nov 2026 08:51:04 +0000
X-Mizu-Trace-ID: cae2898a0ac8bf14
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5be58ad9600so2605e87.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 00:51:00 -0800 (PST)
X-Gm-Message-State: APuU4Z/paKSlij0+9irK6cavQ5QbvZx2rlhsqoHH2acI/1+U62ScL6lT
	y+BiMr3IGdnPHQ+Y1vd1JEgocr7H85tFahMw9PEre5WUvBrNuEu7S5tg9BUj3zFEu2uaPsxktsQ
	gP2AQL1NcrrRPmlgk/OUrFx8X3Gyl0U+HSn4a9Vz1
X-Received: by 2002:a05:6512:1192:b0:5bf:f0fb:2c9c with SMTP id
 2adb3069b0e04-5c00b5c77a9mr135877e87.5.1794214259400; Mon, 09 Nov 2026
 00:50:59 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261109083205.806619-1-fuad.tabba@linux.dev> <20261109083205.806619-5-fuad.tabba@linux.dev>
 <sashiko-outbox-204612@kernel.org>
In-Reply-To: <sashiko-outbox-204612@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 9 Nov 2026 08:50:22 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwgOuCha6e7PREa8WkJMChtgiRfFZjTBadV-ZjzqA=miA@mail.gmail.com>
X-Gm-Features: AclHuK--kTlM3MBNHvnwf6yTPpfzyPkz-vODHm7UL62nptqv6qWIB2G90_uWc1M
Message-ID: <CA+EHjTwgOuCha6e7PREa8WkJMChtgiRfFZjTBadV-ZjzqA=miA@mail.gmail.com>
Subject: Re: [PATCH 04/16] KVM: arm64: Advertise ID_AA64ZFR0_EL1 to protected VMs
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Nov 2026 at 08:48, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [High] KVM: arm64: GPA and GPI exposed without vm_has_ptrauth() in
>   pvmid_aa64isar1 [1]

Fixed here:

https://lore.kernel.org/all/20261109084854.840576-2-fuad.tabba@linux.dev/

/fuad
