Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1507B469823
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 06:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528382; cv=none; b=rADVUfEoHnK9SuNjZs3b5vBrQ6GDSdo0r3QR5Bc/vHzufq9yK38gNAEB2F3y6xj6x23gQuKNCa7emqNb82T7o7QlUSvLneoOBcp1JZAw8y4PeV8AGsmvQieSFrU40tyLvsdIE/hkAZaONeBtqITqHlsS8YrYjajuVfWV/4g2QUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528382; c=relaxed/simple;
	bh=qkbJzcmqDeieYoXJhEk/nB3qFlnGDMJI9zS6yIH7Up8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hEjeTqRYo6kL43mCllyXg/xG4AxVkknMJzxRzjwltFn2QLCaZNG27XJ+4v3IRfCq5crmbdu0LVlBKk0j5nI5XTSYtaM87BPLLBZ+Io6g0OVh0mFCc4SvkyhxawLnuXmZ6Pa+oeQsT6XBFI0Tlp/HBvBQTrCXVVtiBY+iPRlWolU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V8IEyIS3; arc=none smtp.client-ip=91.218.175.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V8IEyIS3"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qkbJzcmqDeieYoXJhEk/nB3qFlnGDMJI9zS6yIH7Up8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791528379; v=1; x=1792133179;
 b=V8IEyIS3s+YgzOthG5qGJA6R57YE8pq9XYBJuOeb+2UPEL8Tefsb8Q0Lqr/WEdpFbmbEam7y
 vNXDKoc6R1Fpt3UtIy0wG5rTrR1zQuKuHJBKwO+AVEH7AiyZK1/ObTDjTvXeDm/i9yLnVGQU/Av
 V21qhwwi/qFlWgBGWF4iGPKo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 00d2ae1cc462cca1;
	Fri, 09 Oct 2026 06:46:19 +0000
X-Mizu-Trace-ID: 00d2ae1cc462cca1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so5097e87.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 23:46:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwGhzBG1SuU7P5doXFwFdUBI+vwGvOFHO9B8FMs2SYDGBRArmvkFoVx4eoNa0RGUvghHoNO7uw=@lists.linux.dev
X-Gm-Message-State: AFq9FYJqapWekbjlCqgqsvqcCPkg4y0pCuG4p8Kv3AteYTedbSYOIvG1
	ZzVqFKqbtjuUnAhs6hEEHnJssIB0MtzV7AgVyp/ir80i2Q3ri2A0QMmJnR18r31hQcdBOy4RqYH
	2OFditYqGt7Y5NGTA99NcVw+8/G1FNU31+nTDHAun
X-Received: by 2002:a05:6512:6d3:b0:5bc:44d4:ab49 with SMTP id
 2adb3069b0e04-5bcdf93c5d4mr38548e87.13.1791528378033; Thu, 08 Oct 2026
 23:46:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929093548.3598547-1-maz@kernel.org> <CA+EHjTybnn2jgVKxCO0WXdGXWJ-=2p4k98CHfh3CrhJopvPDFQ@mail.gmail.com>
 <asf87i2RDh-WksL-@kernel.org>
In-Reply-To: <asf87i2RDh-WksL-@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 9 Oct 2026 07:45:41 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwbhhFipHyi5kL3j6oPxqEO4mVP3BCrtg18iWaFFGiNfw@mail.gmail.com>
X-Gm-Features: AclHuK_nku16xs9azzExlIZ7VItoqo2nur27jo7qgAEiOQl6n1JVILRZZg7lbSQ
Message-ID: <CA+EHjTwbhhFipHyi5kL3j6oPxqEO4mVP3BCrtg18iWaFFGiNfw@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] KVM: arm64: vgic-v3: Make LPI disabling robust
 (and more)
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Yuchao Zhang <ndaugoing@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

[...]
> We could have vgic_target_oracle() return NULL if LPIs are disabled at the redistributor, then the rest of the AP list machinery will "just work" for injections that slip between the cracks.

That would also cover a related one Sashiko raised:
vgic_its_resolve_lpi() can cache a translation after
vgic_its_invalidate_all_caches() has run, since the disable path
doesn't take its_lock, but any MSI that hits that entry would then be
dropped by the oracle. I'll write it up and send a patch on top of
Marc's series.

Cheers,
/fuad
