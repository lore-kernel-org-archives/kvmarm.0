Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759564;
	b=Td67MplAQPHhgCt9/JQiF99chSO2EcQpfxZF+HxpXfdwDHrXugatzzI3dv0w8Qbig2gP
	 fqSlLOxKeO+ynVlUx0IV6FJ4lLCli5mB0aGeyzCLHQvz4RnW5oGf4739fI2E7JE58s0Nc
	 zdVRCiI2g0gFZ6/jt7KDUXPaERouL3Uuw5YIKDrnXDC4tYyItFxLAzELWG6yPQVBHWYoh
	 JfbbwKzERHOaVKwvNngETClZSDF6TfyCuEMC0llB450DuKAzAep7gbF8e+HL5/HA1+/NN
	 wzTxHSvWflSXNS787CXbxina5UOrH6mybMyIJLVwrcSej9NfWmvmfIsn1zeFy3ul01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759564;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=GDyUAHq5EnMm1c2jA/kc6vkZKZbH8Rr6Mm2+HOczy9s=;
	b=vjNIoehIqrjeUhU/hJWCYvUKuaTa/jlNuNLrYFze3H+fK4Jey793Upl1KDkn79R+va4b
	 G80C+vPJN0ZqJy8DW3G+WfcpnbldycoD4FHTQZyd22V5IhdYgfnXaNwWBW/jjOqcDFfj6
	 MVUY5MuxuNQuCBkzZduKfIC4JJcGUJWmvKIs3YRd3KwQ/Dg8T63nHxaQJIQPqaMa+zKAx
	 2jSDC/0eaWraz+fg2DzHeS9WAA/ya0cprJwJ4mYTerrXVGPt10ByFnbE9zWqfra3qp40E
	 JXA7jsccZ6/ejv2NqufYCps6U86nU90Jm8eOHnqsUKheTo7j/mkrZBhLOCbJb4Nhmig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ct4RnxBC;
	arc=none smtp.remote-ip=91.218.175.22
Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81957606A31E
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 12:46:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81957606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ct4RnxBC
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=c6sAixXJP4HRlc6nJBz9ZvqV2918RZfRoqM9ID70+bM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792759561; v=1; x=1793364361;
 b=Ct4RnxBCuahvMda9SZX7SfxwxqJE1diWLFc6HSOj9wZk115uHan6iPx5ta9ThhZ4VE7m9JGp
 7ivpaerQL225EP/LOvb1VTrC8z2eGPo2bSLU/5o6z3MHAUlZl+q/3ElzcPPtkSg83zOoXthrL7q
 PkK+ZkEMHwn/cJp6NQoPz92M=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 963f14664aeef995;
	Fri, 23 Oct 2026 12:46:01 +0000
X-Mizu-Trace-ID: 963f14664aeef995
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so7789e87.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 05:45:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBymWDuyshNhJwm4KXYUHXk3C4SHmdJ2ards/N6aYq+CO06Na1YYkdI35+7AWh7vudrT4X/zqQw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLFOrn57UZjFIogSRNVuaUcua0nQw7SdO2vtWh3GWo+OF8RuWUQ
	VlO2dQvCtcoM2sOG08i2GiqHsSz7Bg1T4KKN/cNUSnxALHQoZT8KwbbGyr5Ummqck9pEhgXrCQA
	Sw1YURuGAOq9PiiNQPVH7VJoIWU+nF5YgBdZxmwh7
X-Received: by 2002:a05:6512:a94:b0:5bf:a5c1:d20 with SMTP id
 2adb3069b0e04-5bfb07f2065mr115256e87.16.1792759555215; Fri, 23 Oct 2026
 05:45:55 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261023092007.3918848-1-vdonnefort@google.com>
 <CA+EHjTwNOJCphq8YNxK4nUZFj0Xrw31Okx1fiFAS=sHY1Z3cnA@mail.gmail.com> <86bj8kzix4.wl-maz@kernel.org>
In-Reply-To: <86bj8kzix4.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 23 Oct 2026 13:45:18 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxr9g3oir1UvPZFrYAsOVODfWRRtW8rqbD7DxFmr-Ddvg@mail.gmail.com>
X-Gm-Features: AclHuK-tQ-Fh_fw4NY0r1RDT4Ce-dOpOYM6PPBXIKh7mshfcyGMDD02YdETdbGA
Message-ID: <CA+EHjTxr9g3oir1UvPZFrYAsOVODfWRRtW8rqbD7DxFmr-Ddvg@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Use the host kvm_host_data for nr_event_counters
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Oct 2026 at 13:43, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > I tested this in pKVM with a non-protected guest counting with
> > perf_event_open(). On its own the patch doesn't change what the guest
> > sees: every counter, the cycle counter included, still reads 0. That's
> > a separate bug: flush_hyp_vcpu() never copies vcpu->arch.pmu.events to
> > the hyp vCPU, so the guest's events are never enabled on entry. I'll
> > send a fix for that shortly.
>
> Please synchronise with Vincent and sent this as a series fixing PMU
> handling on pKVM, not as discrete patches.
>
> The approach taken for this patch is wrong anyway, so you have plenty
> of opportunity to work together.

Will do.

Cheers,
/fuad
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
