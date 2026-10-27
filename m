Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.201
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793094130;
	b=2UIFoxoAuLcNZmJjQRwEk1GFtoRWKVhM0dtNlVC/28fBWHBasz4gF5mFkcjTiPsj+YmL
	 CrbKUVcpMvkcRrT6zIBLh0CxSxm01pXt9O+8S3zb4LdoE8vdpFQOcEKbXWyikF1d8LWnr
	 MUBdK4bhPYIpUmqxKUxT+HuXHpaJMMlKhDpokd7F9/RpGpP5sGbwNdJTV0uh5wTHoDXK1
	 ASZ3QpVXFGcSusQwMx/bG7cF4SlnhKcq+3xSQlqJ+Amk5xnaY8U25l6RiNfH3TlOib/wU
	 wfIo2SZLM2J7CxCsjF+M7McRbeI7Xaup2ZoTDSKYPyzsXg0s/crmJp4iMrk3hTCnBCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793094130;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=+t8OXJ27yQjE3O++/rKAi/jak7lrU5zBJrJZpSfBZnw=;
	b=CsRbLQ+6T/SoPv08f1cZp5PN3TqUbm3diF/hAaEJTq9ELUBK4tE1Asc40E5IsmXlkRUy
	 PJPGl5PoWGyIzOwcGtA6ZNKvGFOXXBYhh0pTryrS8HQYgflXmXfYFksZknWZV6XzcpLkA
	 lPAQiYCyJPuGcmpw1yU6oHOKlEwITAYXZIhTVWPrpvtfuO1J+rwDXj/mkxlCe3OvbSe1M
	 gK81kTFs8HIIqwoRZsRNiurG8u+ny81j3UnGfOPULRzC0uccRJe9on2oed4bz76rbYqSS
	 lei2neNd92gChwz5w8tBuCojUV+E0oGdKSue4J2z8vFekPkRjg4tyZRer9i3Uylf70A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UlUeCDGh;
	arc=none smtp.remote-ip=95.215.58.201
Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869E2606A31F
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 09:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 869E2606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UlUeCDGh
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1vSES+s04GHXXZ3aI3e5tzkJqHQjxYx925g4IWtLlCc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793094126; v=1; x=1793698926;
 b=UlUeCDGhrYoeoYvvx3uuE5GRfm909Lx5E+i9/BJHJ8XbUaujuoHeZ4ROgFriBeMF4yTvFVCO
 eGbFAiJ99elDAqRDWU+RUDUdlfO2kHqb/PtXQHewHAwDslkm29VwoLJtKmuQKZenN6STNt2HesZ
 PPi9FD3bwAvHh54+TYLCEDDc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3110a5ed4cc3142b;
	Tue, 27 Oct 2026 09:42:06 +0000
X-Mizu-Trace-ID: 3110a5ed4cc3142b
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so6850e87.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 02:42:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxxEQTSB4SFF0wFul0OyQvz2/71om7mJH+cv0rEeGPHhntK/Nd8gpxJFfBykCUbKoCAR2iTMsw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLMgxPhC9RSIgqscZckcbaag/sSJcoVgB+4fF2ry2m+Jk1N1HpR
	cp8Pq6lZaZJiGW411N6VdelTUZdNj3QIsIcp2hyUac3I9ObW0lhqXkkMI/ICu4FsGkiRG1HKcBb
	8fW80XAHvq+yD5y0yg68Z6JHO79oQBHwFl1rxM3li
X-Received: by 2002:a05:6512:2250:b0:5bf:b27b:6371 with SMTP id
 2adb3069b0e04-5bfc6972c1fmr93556e87.10.1793094123098; Tue, 27 Oct 2026
 02:42:03 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261027081147.498183-1-fuad.tabba@linux.dev> <20261027081147.498183-4-fuad.tabba@linux.dev>
 <86wlr3xzdb.wl-maz@kernel.org>
In-Reply-To: <86wlr3xzdb.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 27 Oct 2026 09:41:26 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwt5c2GiMZXdaEZ7cb=Op_0FQPXgrih1bN0bpqcib63vg@mail.gmail.com>
X-Gm-Features: AclHuK-5R5nG2ZiFsbhrO7zAaWYXWI133N9FKiM4gKJbvEm8i2qdS390y_nJajM
Message-ID: <CA+EHjTwt5c2GiMZXdaEZ7cb=Op_0FQPXgrih1bN0bpqcib63vg@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Disable host PMU counters for protected guests
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Oculytic <oculytic@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Oct 2026 at 09:32, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > -     if (pmuv3_implemented(pmuver))
> > +     if (pmuv3_implemented(pmuver)) {
> >               *host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
> >                                                             read_sysreg(pmcr_el0));
> > +             host_data_set_flag(HAS_PMUV3);
>
> Honestly, I don't think we need to work out which CPUs have PMUv3 and
> which don't. I'd be perfectly happy to disable KVM on asymmetric
> systems, simply because they don't exist.

Ack. I'll drop the per-CPU flag on the respin, gate on
system_supports_pmuv3(), and refuse KVM on asymmetric systems.

/fuad
