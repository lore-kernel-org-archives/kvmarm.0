Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717308;
	b=A5oZQXA/+13oBGIWmFW6bmj3el79MbWrZNq55BTBohMln4u8zgD1My9/1R79qSM5v05r
	 EPVsINXjmC+wtJbu/JydRX0ZdCM571NJUnIYQacy+ICW1WwYSRKzvi70qtYEOWzoRdXpr
	 L/3ZqJcf46wNkBtDisPHVYqzPVkauh9tN7MTF6pLtFFqf3zfO3vAYKAe2B9KfuEKbMoUZ
	 S3VpoU1XAgWXd3k4KFG9rGWc/0w5swK2H1YrnYz9dCmdexs9wuyNOrcKRCM4y0EsKtSVO
	 DewEcF72+mDM68NxuOJRbuePFwsDLll/Xc2ITzyKngti8BvnoNx8DIk1D6Fg+Ur618w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717308;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=qwRz5+y1CfI9kDi1iQPoKBCcgpmj5BKvbsT9hE1zi3s=;
	b=O7iyznw25nS9EYIyGM6GYD9KgKCNHGxyhshzriCv8CLVT0Yh58sx0PjTCeIVZRZXj7AM
	 VPhGt647xtuihNoxMeGduqiUV3/L9f3I5DHOCcHI2pC1sOwd6Z5sPoitYiPcxy3TvkgXN
	 hdY1Pse1tbTAbb88xynXC+cHhmKt/vebeSkyuBYCNNQ43aZSiPsuQXG28gQ11fz6tBSlW
	 4qEZQJrbGAxrnFh/eBryu5GWbSVqbSzImxVQE3n+YsgNV6Hd/IBAxlzVG0ODo1mrkbEKA
	 2KuujwM8HacVdQMLPgJ8Qs2HJv/0THrD3HtZDhAZVVxPRQ2wh7G3TMykNSFKPU2cwMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=95.215.58.114
Received: from mta1.migadu.com (out-114.mta1.migadu.com [95.215.58.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FD6606A338
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 14:48:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6FD6606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=e0EHDUYXYwJ2tFPCvYOXU9vuxX2TbQCMEHzWm7MGEI4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793717304; v=1; x=1794322104;
 b=cyutV7yPNJjkOIlw5TGrzQ3a7nwgvuTrqT3zLSpv8irabZXI1z0BcIqSJsRfvahVty9Yndi4
 S/MV4cRNAD9nvPdDFSYFN88Vm37EDyhqcmbZStHfIcOzuAAEALm1y7N3fjEkkdz+jXD7TjeA6du
 USzTXCpto8D2yVADTQBNhX4g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ebd8ce6a98f23fec;
	Tue, 03 Nov 2026 14:48:24 +0000
X-Mizu-Trace-ID: ebd8ce6a98f23fec
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so7508e87.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 06:48:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx5KxMKszPlp99iA456cVsD8jIUK+rCevtOcwKd/43GqgsmYaB8Aj/eDBDrmfOXjYzzu4wcH4U=@lists.linux.dev
X-Gm-Message-State: APuU4Z8cT13kHvRFkQk4n/+Eu6+0Xe5mC+ODzAojh/XYsU97a2bLU8BG
	VZoWJXgxVY8e+3v0csLdf3CZbnbfnDgw65Y7xYjSCUwLpARujFZO9j7Ik4kp6AzHntG3RBHsHxT
	9JXeaRb5+KKTnK6Ip3PqqmApJGthWLl1OuOkYg9/u
X-Received: by 2002:ac2:4558:0:b0:5bf:f067:87da with SMTP id
 2adb3069b0e04-5bff06787efmr94493e87.10.1793717299509; Tue, 03 Nov 2026
 06:48:19 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-12-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-12-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 14:47:43 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyLQKbSWJMb_7kLDiiU2mmgXCEGJo6eaOwq6FyP-0g4Cw@mail.gmail.com>
X-Gm-Features: AclHuK-qvxCnimx5eE-7K4X-2tiMTkkBcU6bg0FMihoezKrSPq8sjEYtl97L8a0
Message-ID: <CA+EHjTyLQKbSWJMb_7kLDiiU2mmgXCEGJo6eaOwq6FyP-0g4Cw@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] irqchip/gic-v5: Enable direct injection in ITS
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:49 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

This should be Co-developed-by:, followed by Timothy's Signed-off-by:.

[...]
> diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v5-its.c
[...]
> +static int gicv5_its_set_vcpu_affinity(struct irq_data *d, void *int_data)
[...]
> +invalidate:
> +        /* Make the change ITS-visible */
> +        dsb(st);
> +        ret = gicv5_its_itt_cache_inv(its, dev_id, event_id);
> +        if (!ret && !data) {
> +                /*
> +                 * Invalidation sends events using the old translation to the
> +                 * IRS, but does not wait for them to be processed.
> +                 */
> +                gicv5_irs_syncr();
> +        }

gicv5_irs_syncr() returns void, so a timed-out sync looks like success
here. Could it return the poll's result into ret, so the if (ret) path
keeps the flag for a retry? (Sashiko [1])

This relies on your host series' patches 3 and 4. Without them the
sync sleeps under desc->lock, and this invalidation races the host's.
Should the cover mention the dependency?

Thanks!
/fuad

[1] https://lore.kernel.org/all/sashiko-outbox-194164@kernel.org/
