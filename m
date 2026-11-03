Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.235
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713767;
	b=wdq7pIFnj83NOaBFvgCEs7UdqirMKhI5bAc9wDendn2Z7cgzcyPM726E+nOhg8k6pW7e
	 7gEubkaCrevnh0FKOW5eCRT5VmtoQWlRFyocnzY4f8CoY5BQ8DWXrurpSWGx8dcUv/NZM
	 T19ORooPw0PodOeiBXn4K6i3QO4alB2B1WxAtank6swygvkwAdyFs7dmbw3DtBwT9CqYw
	 rlxFvAQspKlj0+BDtxOMmcKlqxOpdhsp+PTIce52lnRmydx3RYy0IjHS20miy2yZ/sJ8M
	 LtwUXRuq4xf17+zWI91fJDujdyDl26bn/jdcF7TZQftGySKYmF7rKOLSJGgKdrOISHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713767;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Vj7nnf3+hX6pDD4kkVdX7ATUkAs5lwT8YtIid3wScRU=;
	b=CIP4z3zQKkn3bmd90keLhir9y26n1CQZJTS/RhRQ/20af2oEqOZvtI6+cSNPjTKMCD8J
	 yoUQlFi0qbVcf3s0HjnAMX0m8klRvo+tT4SAHLyut8ZNafcF6vzC6ycrPMQ+/Eu77xs4F
	 +oFEu2nc/xsEY2sgeySyQ4/K2l7uw0XIFNsHEbOSmvbOg+/JuBbaMw5Yum40dAIg7Tp1H
	 zj78EDz1R0Fet1q2OUPB5+JYvDqUIIRDn7nq1G86nrfg7emN8ZRQ4K69kCWOKNag47Fys
	 4LyyMjZo4wLmtn+uUGyfAzUvbmnoWkCEvR8DJevWrBzyIHGh4Wsj1XjwEwR7bk1rM2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m6ZKISgp;
	arc=none smtp.remote-ip=91.218.175.235
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33954606A329
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33954606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m6ZKISgp
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=lJFSAvh/s8cWO+ylQ8b65jdqU55xiRLoOy5tUADRJVg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793713764; v=1; x=1794318564;
 b=m6ZKISgp8xEQPw+Ai9aExDC5eCMiDDLfza0YwkI+/bZvg5DtPYHPd9LUrrRoMOieixdKzKeG
 oQ0sm5S/juIQScmXVAvubpwBYk0pWD3xnseJ32gNxxx1JCP/2npE+bmAT70XOTNYxVa5hexeQAi
 D17MCDHF5pv9yFQuCHOuAWsI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id defd1468f28f3c75;
	Tue, 03 Nov 2026 13:49:24 +0000
X-Mizu-Trace-ID: defd1468f28f3c75
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5be58ad9600so7389e87.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 05:49:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByVYUXH+7m+DO73i+1aVKVE35jjy2e6jD0wG57losRchI65VcdC2YMaEaYGa7JD3JvWROi0JSs=@lists.linux.dev
X-Gm-Message-State: APuU4Z8AuR+yU0HeEGcuB6NwK1IzjZEKoJp8Bt/a6n1tMjzRRDWLU6TP
	Ka/X0rAXx+QdpjfqpDtvWet999O5sEhmDZ9wU75WPWzwiueQbRjACpP4eYcfah/OCeBBK1iM1oR
	I7d4gzhxCpLCwlEo5RxXlncPXPXPVRkghZpIGdl0I
X-Received: by 2002:a05:6512:4013:b0:5be:b32e:c309 with SMTP id
 2adb3069b0e04-5bff0f075b2mr105344e87.13.1793713759125; Tue, 03 Nov 2026
 05:49:19 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-7-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-7-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 13:48:42 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwWFobMXrVcm2iFhWXoWfudk6dGL8ed5mCs7u9LTsTpKQ@mail.gmail.com>
X-Gm-Features: AclHuK9t40SuunANo3L6wQKi_X9nYoI88mdBFeXlfd2RawDyjQ21UrVXIFQXO9Y
Message-ID: <CA+EHjTwWFobMXrVcm2iFhWXoWfudk6dGL8ed5mCs7u9LTsTpKQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/16] KVM: arm64: gic-v5: Add ITS MMIO state emulation
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:44 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
[...]
> +static void vgic_v5_its_reset(struct vgic_v5_its *its)
> +{
[...]
> +        its->idr1.dt_levels = 1;
> +        its->idr1.itt_levels = 1;
> +        its->idr1.l2sz = 0;

L2SZ 0 is reserved in the spec when either LEVELS bit is set. Could
this advertise 0b111, as the spec recommends? (Sashiko [1])

Thanks!
/fuad

[1] https://lore.kernel.org/all/sashiko-outbox-194056@kernel.org/
