Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713460;
	b=EuQWLtWc0WlteZFEWUnuXARQKy2z3A8CS4l5RN3kHFuhXPhbAdEMTzcPWHcEoDdYE6zl
	 J+cP1u15gPsifuMkUdvxLR2fv5QKktcz9gZAN6POQeOAxaMJi4AF7x2egQxCChcOFrRxQ
	 rQZ/YezIcgQc8WlUXmQkMI0npL4qQ7iGVWkeyIqjAJr/X5dW/o0Ml6DanaKzubsQnuRh3
	 ry5y57fYZrRO1QHhi/6zes47Ug9Di2oRDoMIbc6BpEIHTSdPXURLqr9qoR316T1CpHjwG
	 IrwHCz3V4ADFZX5MAfp/6UFyanf/NQ6K5VQ8adfXhQGhURp0xYWos9kJdaA/O+PKCKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713460;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=ZQzTNVyYYgBE97T4osUhW5EzJ8IbgXAyi0t0S4s5/Jg=;
	b=IVUKOpPS6Oxfvq0Jw9Ihz775H5V7W6Hnv14hENNsMv9FptaYp/2UBR9UD06xiYv+/3L6
	 zelaZlS1uy5lzMEd0YUVLe9Y3bFOkSIrQ+y1bDa+TGm4LpS9YgTf0Z1AZh4u+/xHGTty5
	 6vQpowt4eviH55EmeJB7f/rwrOmNB3PgG3CUx4181njKj/lYzmztlPKXieq+QEsjMTA+w
	 1yiCKlmxmUIb4SzPZWu1byCKEVXI0l8sYlLPAUNUaV4ADwHkbppIsXK/LEnL8rQMYujaB
	 BuZq+Lg3BCTo9W3ua5Rs5piel6bo7PRq7TT42RgRm2fJH8nVzbgXLKzp2ZnmDE87gZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TV15h1QR;
	arc=none smtp.remote-ip=95.215.58.80
Received: from mta1.migadu.com (out-80.mta1.migadu.com [95.215.58.80])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3139B606A324
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3139B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TV15h1QR
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZQzTNVyYYgBE97T4osUhW5EzJ8IbgXAyi0t0S4s5/Jg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793713457; v=1; x=1794318257;
 b=TV15h1QRJjq0hk37RonnLxO0utpnqlK7BHfC4KbHqBXiak+ZlQwFWbiqpAaJpvTXtZ37PZLC
 Eml1Yn9/ASOq2DV52k7tnlUWTWqsePlRMkB5vfzZs76qyfRya0TzI19VkfAcI0gMF+t+FOB11ND
 jbHSmu5JCBik+jjwbe8E69YE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 28d4ed26ffccb672;
	Tue, 03 Nov 2026 13:44:17 +0000
X-Mizu-Trace-ID: 28d4ed26ffccb672
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be58ad9600so7335e87.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 05:44:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwm/iLjyMolqWEQDyMTW3reUCPCq/XtAxHFq7JSCDQ2vUuvSj7qEnNA3Hro9PtHeKibJLzuePE=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ShlyR7qYF8wzMaVHBU2Y3977t6QOYFVAVR8oPV627p+NwAGAd
	Bb0uEb49JQotJJiY+XHHWl5TcuBs+aOn1iM72ljxDDZHm5/h/xSX6WqHl6+6+kWgRBAp/eaO8rC
	skQ4eTj6PSm8C6HDp3tkx6orYlpmbXlYrIT6K2JiC
X-Received: by 2002:a05:6512:b1e:b0:5bf:a191:c132 with SMTP id
 2adb3069b0e04-5bff0a75e51mr126673e87.2.1793713455901; Tue, 03 Nov 2026
 05:44:15 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-4-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-4-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 13:43:39 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzGVtvJ76kwU=qVZc9vVvXoVBy88rdU0idHZaCQMa5-MQ@mail.gmail.com>
X-Gm-Features: AclHuK8Yjeg-Kg3bL_DBiJyv5rYXjdrrn_KkW91Lom2D_wZWZ3GsGIHAcTdrDdc
Message-ID: <CA+EHjTzGVtvJ76kwU=qVZc9vVvXoVBy88rdU0idHZaCQMa5-MQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/16] KVM: arm64: gic-v5: Share CoreSight ID register emulation
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:41 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> This keeps the IRS behaviour unchanged while giving the ITS MMIO
> emulation a helper it can reuse when it is added in the following commit.

nit: the ITS emulation that uses it arrives in patch 6.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks!
/fuad
